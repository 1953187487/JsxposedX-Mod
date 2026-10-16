import 'dart:async';
import 'dart:convert';

import 'package:JsxposedX/features/ai/application/chat/ai_chat_context_builder.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_context_deriver.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_environment.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_orchestrator.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_state.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_snapshot.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_catalog_repository.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_question_parser.dart';
import 'package:JsxposedX/features/ai/presentation/providers/ask/ai_ask_provider.dart';

class AiChatSessionController {
  AiChatSessionController({
    required this.conversationId,
    required AiCatalogRepository catalogRepository,
    required AiConversationRepository conversationRepository,
    required AiChatRun Function(AiRequest request) startRun,
    required String Function() idFactory,
    DateTime Function()? now,
    AiChatContextBuilder contextBuilder = const AiChatContextBuilder(),
    AiChatSessionContextDeriver contextDeriver =
        const AiChatSessionContextDeriver(),
    this.environment,
    this.onContextAssembled,
    this.pageSize = 50,
    this.checkpointInterval = const Duration(milliseconds: 300),
  }) : _catalogRepository = catalogRepository,
       _conversationRepository = conversationRepository,
       _startRun = startRun,
       _idFactory = idFactory,
       _now = now ?? DateTime.now,
       _contextBuilder = contextBuilder,
       _contextDeriver = contextDeriver,
       _state = AiChatSessionState(conversationId: conversationId);

  final String conversationId;
  final int pageSize;
  final Duration checkpointInterval;
  final AiChatSessionEnvironment? environment;

  /// 每次完成上下文组装（初始化恢复、每轮请求下发前）后回调该对话最新的
  /// 上下文状态（含真实组装统计），供控制台展示，不参与请求本身。
  final void Function(String conversationId, AiChatSessionContext context)?
  onContextAssembled;
  final AiCatalogRepository _catalogRepository;
  final AiConversationRepository _conversationRepository;
  final AiChatRun Function(AiRequest request) _startRun;
  final String Function() _idFactory;
  final DateTime Function() _now;
  final AiChatContextBuilder _contextBuilder;
  final AiChatSessionContextDeriver _contextDeriver;
  final StreamController<AiChatSessionState> _states =
      StreamController<AiChatSessionState>.broadcast(sync: true);

  AiChatSessionState _state;
  AiChatRun? _activeRun;
  StreamSubscription<AiStreamSnapshot>? _runSubscription;
  Timer? _checkpointTimer;
  AiStreamSnapshot? _pendingCheckpointSnapshot;
  Future<void> _checkpointTail = Future.value();
  /// 上次持久化的对话级上下文快照，初始化时读回，用于恢复无法从消息
  /// 历史重建的状态（固定约束、恢复点、迁移标记）。
  AiChatSessionContext? _restoredContext;
  /// 跨请求/跨重启的上下文记忆条目：被裁出请求窗口的历史摘要（含已
  /// 完成的类分析工具调用记录）。每次组装后由压缩器输出去重合并的
  /// 完整集合，持久化在上下文快照中，重启/分页后回流注入请求，
  /// 防止模型重复分析已处理过的类。
  List<String> _memoryEntries = const [];
  /// 上下文快照落盘串行链，避免并发写覆盖并保证关闭前写完。
  Future<void> _contextTail = Future.value();
  Future<void>? _initialization;
  bool _closed = false;
  Completer<bool>? _approvalCompleter;
  AiMessage? _pendingApprovalAssistantMessage;
  /// 问答模式挂起：模型抛出提问块后阻塞在此，等待用户作答后再继续本轮。
  Completer<List<String>>? _answerCompleter;
  AiQuestion? _pendingQuestion;

  AiChatSessionState get state => _state;

  Stream<AiChatSessionState> get states => _states.stream;

  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    final conversation = await _conversationRepository.getConversation(
      conversationId,
    );
    if (conversation == null) {
      throw StateError('Conversation $conversationId does not exist');
    }
    final assistant = await _catalogRepository.getAssistant(
      conversation.assistantId,
    );
    if (assistant == null) {
      throw StateError(
        'Conversation $conversationId references a missing assistant',
      );
    }
    final connection = await _catalogRepository.getConnection(
      assistant.connectionId,
    );
    final model = await _catalogRepository.getModel(
      assistant.connectionId,
      assistant.modelId,
    );
    if (connection == null || model == null) {
      throw StateError('Assistant ${assistant.id} has an invalid catalog link');
    }

    final loaded = await _conversationRepository.getMessages(
      conversationId,
      limit: pageSize + 1,
    );
    final hasOlder = loaded.length > pageSize;
    final page = hasOlder ? loaded.sublist(loaded.length - pageSize) : loaded;
    final repaired = await _repairInterruptedMessages(page);
    _emit(
      _state.copyWith(
        conversation: conversation,
        assistant: assistant,
        connection: connection,
        model: model,
        messages: repaired,
        phase: AiChatSessionPhase.ready,
        hasOlderMessages: hasOlder,
        failure: null,
      ),
    );
    _restoredContext = await _conversationRepository.getConversationContext(
      conversationId,
    );
    // 分页加载窗口外的历史（更早的类分析记录）无法从消息列表恢复，
    // 从上下文快照读回持久化记忆条目，注入后续每次请求组装。
    _memoryEntries =
        _restoredContext?.sessionMemory.memoryEntries ?? const [];
    _publishContext(
      _contextBuilder.buildWithStats(
        assistant: assistant,
        model: model,
        messages: repaired,
        idFactory: _idFactory,
        now: _now().toUtc(),
        environmentSystemPrompt: environment?.systemPrompt,
        persistedMemory: _memoryEntries,
      ),
      repaired,
    );
  }

  Future<void> loadOlderMessages() async {
    await initialize();
    if (_state.isLoadingOlderMessages || !_state.hasOlderMessages) return;
    final oldest = _state.messages.firstOrNull;
    if (oldest == null) return;
    _emit(_state.copyWith(isLoadingOlderMessages: true));
    try {
      final loaded = await _conversationRepository.getMessages(
        conversationId,
        before: AiMessageCursor(createdAt: oldest.createdAt, id: oldest.id),
        limit: pageSize + 1,
      );
      final hasOlder = loaded.length > pageSize;
      final page = hasOlder ? loaded.sublist(loaded.length - pageSize) : loaded;
      _emit(
        _state.copyWith(
          messages: [...page, ..._state.messages],
          hasOlderMessages: hasOlder,
          isLoadingOlderMessages: false,
        ),
      );
    } catch (_) {
      _emit(_state.copyWith(isLoadingOlderMessages: false));
      rethrow;
    }
  }

  Future<void> sendText(String text) async {
    await initialize();
    final content = text.trim();
    if (content.isEmpty) return;
    _ensureCanStart();
    final createdAt = _now().toUtc();
    final userMessage = AiMessage(
      id: _idFactory(),
      conversationId: conversationId,
      role: AiMessageRole.user,
      parts: [AiContentPart.text(content)],
      parentId: _state.messages.lastOrNull?.id,
      createdAt: createdAt,
    );
    await _startGeneration(userMessage, [
      ..._state.messages,
      userMessage,
    ], persistUserMessage: true);
  }

  /// 中断后的非破坏性接续：保留全部历史消息（含工具调用与部分回复），
  /// 追加一条与当前语言匹配的“继续”指令，基于中断前的上下文继续推进任务，
  /// 而不是回退到会话起始状态重新生成。
  Future<void> continueFromInterruption({required bool isZh}) async {
    await initialize();
    _ensureCanStart();
    final keyword = isZh ? '继续' : 'Continue';
    final createdAt = _now().toUtc();
    final userMessage = AiMessage(
      id: _idFactory(),
      conversationId: conversationId,
      role: AiMessageRole.user,
      parts: [AiContentPart.text(keyword)],
      parentId: _state.messages.lastOrNull?.id,
      createdAt: createdAt,
    );
    await _startGeneration(userMessage, [
      ..._state.messages,
      userMessage,
    ], persistUserMessage: true);
  }

  Future<void> retryLastResponse({bool isZh = true}) async {
    await initialize();
    _ensureCanStart();
    final hasInterrupted = _state.messages.any(
      (message) =>
          message.role == AiMessageRole.assistant && _isResumable(message),
    );
    if (!hasInterrupted) {
      throw StateError('There is no failed response to retry');
    }
    // 中断后的重试不再回退会话，改为发送“继续”指令接续推进。
    await continueFromInterruption(isZh: isZh);
  }

  Future<void> retryByMessageId(String messageId, {bool isZh = true}) async {
    await initialize();
    _ensureCanStart();
    final index = _state.messages.indexWhere(
      (message) => message.id == messageId,
    );
    if (index < 0) return;
    final target = _state.messages[index];
    if (target.role == AiMessageRole.tool &&
        target.parts.whereType<AiToolResultPart>().any(
          (part) => !part.toolResult.success,
        )) {
      await _retryFailedToolResult(index);
      return;
    }
    // 中断/取消/失败的 assistant 轮次：保留既有上下文，
    // 以“继续”指令接续推进，避免会话跳回初始消息。
    if (target.role == AiMessageRole.assistant && _isResumable(target)) {
      await continueFromInterruption(isZh: isZh);
      return;
    }
    if (target.role == AiMessageRole.user) {
      await _regenerateFrom(target);
      return;
    }
    final userMessage = _findUserMessageBefore(index);
    if (userMessage == null) {
      throw StateError('The response has no user parent');
    }
    await _regenerateFrom(userMessage);
  }

  Future<void> regenerateLastResponse() async {
    await initialize();
    _ensureCanStart();
    final assistantIndex = _state.messages.lastIndexWhere(
      (message) => message.role == AiMessageRole.assistant,
    );
    if (assistantIndex <= 0) {
      throw StateError('There is no response to regenerate');
    }
    final userMessage = _findUserMessageBefore(assistantIndex);
    if (userMessage == null) {
      throw StateError('The response has no user parent');
    }
    await _regenerateFrom(userMessage);
  }

  /// Removes one persisted message. Conversation structure is never mutated
  /// while a request is active; callers should provide a confirmation UI.
  Future<void> deleteMessage(String messageId) async {
    await initialize();
    _ensureCanStart();
    final index = _state.messages.indexWhere(
      (message) => message.id == messageId,
    );
    if (index < 0) return;
    await _conversationRepository.deleteMessagesById(conversationId, [
      messageId,
    ]);
    final messages = [..._state.messages]..removeAt(index);
    _emit(_state.copyWith(messages: messages, failure: null));
  }

  /// Clears an assistant turn without deleting its user parent.
  Future<void> clearAssistantResponse(String messageId) async {
    await initialize();
    _ensureCanStart();
    final message = _state.messages.firstWhere(
      (candidate) => candidate.id == messageId,
      orElse: () => throw StateError('Message $messageId does not exist'),
    );
    if (message.role != AiMessageRole.assistant) return;
    await deleteMessage(messageId);
  }

  /// 以非破坏性方式接续被中断的 assistant 轮次：不删除任何历史消息，
  /// 发送与当前语言匹配的“继续”指令，基于中断前的上下文继续推进任务。
  Future<void> continueGeneration(String messageId, {bool isZh = true}) async {
    await initialize();
    _ensureCanStart();
    final index = _state.messages.indexWhere(
      (message) => message.id == messageId,
    );
    if (index < 0) return;
    final target = _state.messages[index];
    if (target.role != AiMessageRole.assistant ||
        (target.status != AiMessageStatus.cancelled &&
            target.status != AiMessageStatus.interrupted)) {
      throw StateError('Message is not resumable');
    }
    await continueFromInterruption(isZh: isZh);
  }

  static bool _isResumable(AiMessage message) {
    return message.status == AiMessageStatus.failed ||
        message.status == AiMessageStatus.cancelled ||
        message.status == AiMessageStatus.interrupted;
  }

  Future<void> editUserMessageAndResend({
    required String messageId,
    required String updatedText,
  }) async {
    await initialize();
    _ensureCanStart();
    final index = _state.messages.indexWhere(
      (message) =>
          message.id == messageId && message.role == AiMessageRole.user,
    );
    if (index < 0 || updatedText.trim().isEmpty) return;
    final original = _state.messages[index];
    final updated = original.copyWith(
      parts: original.parts
          .map(
            (part) => part is AiTextPart
                ? AiContentPart.text(updatedText.trim())
                : part,
          )
          .toList(growable: false),
    );
    await _regenerateFrom(updated);
  }

  Future<void> _regenerateFrom(AiMessage userMessage) async {
    final discardedIds = _state.messages
        .skipWhile((message) => message.id != userMessage.id)
        .skip(1)
        .map((message) => message.id);
    await _conversationRepository.deleteMessagesById(
      conversationId,
      discardedIds,
    );
    // A retry writes the same record again, while an edited resend replaces
    // the persisted user content before the new assistant turn starts.
    await _conversationRepository.saveMessage(userMessage);
    final history =
        _state.messages
            .takeWhile((message) => message.id != userMessage.id)
            .toList(growable: true)
          ..add(userMessage);
    _emit(_state.copyWith(messages: history));
    await _startGeneration(userMessage, history);
  }

  AiMessage? _findUserMessageBefore(int index) {
    for (var candidate = index - 1; candidate >= 0; candidate--) {
      final message = _state.messages[candidate];
      if (message.role == AiMessageRole.user) return message;
    }
    return null;
  }

  Future<void> _startGeneration(
    AiMessage userMessage,
    List<AiMessage> history, {
    bool persistUserMessage = false,
  }) async {
    if (persistUserMessage) {
      await _conversationRepository.saveMessage(userMessage);
    }

    await _runAssistantLoop(
      initialHistory: history,
      initialParentId: userMessage.id,
    );
  }

  Future<void> _retryFailedToolResult(int resultIndex) async {
    final resultMessage = _state.messages[resultIndex];
    final failedResult = resultMessage.parts
        .whereType<AiToolResultPart>()
        .map((part) => part.toolResult)
        .firstWhere(
          (result) => !result.success,
          orElse: () => throw StateError('Message has no failed tool result'),
        );
    final toolCall = _findToolCallBefore(resultIndex, failedResult.toolCallId);
    if (toolCall == null) {
      throw StateError('The failed tool result has no matching tool call');
    }
    if (environment?.toolExecutor == null) {
      throw StateError('No tool executor is available for this conversation');
    }

    final discardedIds = _state.messages
        .skip(resultIndex)
        .map((message) => message.id);
    await _conversationRepository.deleteMessagesById(
      conversationId,
      discardedIds,
    );
    final history = _state.messages.take(resultIndex).toList(growable: true);
    _emit(
      _state.copyWith(
        messages: history,
        phase: AiChatSessionPhase.requesting,
        failure: null,
      ),
    );

    final previous = history.lastOrNull;
    final toolMessage = await _executeToolCall(
      toolCall,
      maxResultBytes: _state.assistant!.toolPolicy.maxResultBytes,
      parentId: previous?.id,
      previousTime: previous?.completedAt ?? previous?.createdAt ?? _now(),
    );
    await _runAssistantLoop(
      initialHistory: [...history, toolMessage],
      initialParentId: toolMessage.id,
      startingToolRound: _toolRoundsInCurrentTurn(history),
    );
  }

  AiToolCall? _findToolCallBefore(int index, String toolCallId) {
    for (var candidate = index - 1; candidate >= 0; candidate--) {
      final message = _state.messages[candidate];
      if (message.role != AiMessageRole.assistant) continue;
      for (final part in message.parts.whereType<AiToolCallPart>()) {
        if (part.toolCall.id == toolCallId) return part.toolCall;
      }
    }
    return null;
  }

  /// 统计“当前用户轮次”内已发生的工具调用轮数。
  ///
  /// 轮数上限是每轮用户消息的预算（`_startGeneration` 始终从 0 起算），
  /// 因此重试失败的工具结果时也必须从最近一条用户消息之后开始计数。
  /// 若沿用整段会话的累计值，历史越长越容易在重试时误判超限，表现为
  /// 间歇性的“工具调用被强行终止”。
  int _toolRoundsInCurrentTurn(List<AiMessage> messages) {
    var rounds = 0;
    for (var index = messages.length - 1; index >= 0; index--) {
      final message = messages[index];
      if (message.role == AiMessageRole.user) break;
      if (message.role == AiMessageRole.assistant &&
          message.parts.whereType<AiToolCallPart>().isNotEmpty) {
        rounds++;
      }
    }
    return rounds;
  }

  Future<void> _runAssistantLoop({
    required List<AiMessage> initialHistory,
    required String initialParentId,
    int startingToolRound = 0,
  }) async {
    try {
      await _runAssistantLoopUnsafe(
        initialHistory: initialHistory,
        initialParentId: initialParentId,
        startingToolRound: startingToolRound,
      );
    } catch (error, stackTrace) {
      // 工具调用链路熔断：任何未捕获异常（DB 写入失败、状态错乱等）
      // 都不允许让会话永久停留在 requesting/streaming 中间状态，
      // 统一恢复到 failed（可重试），保证功能不会直接卡死。
      await _recoverFromLoopFailure(error, stackTrace);
    }
  }

  Future<void> _runAssistantLoopUnsafe({
    required List<AiMessage> initialHistory,
    required String initialParentId,
    int startingToolRound = 0,
  }) async {
    final assistant = _state.assistant!;
    final connection = _state.connection!;
    final model = _state.model!;
    var workingHistory = List<AiMessage>.from(initialHistory);
    var parentId = initialParentId;
    final tools = model.capabilities.toolCalling
        ? environment?.tools ?? const <AiToolSpec>[]
        : const <AiToolSpec>[];
    final maxToolRounds = resolveMaxToolRounds(assistant.toolPolicy.maxRounds);

    for (var toolRound = startingToolRound; ; toolRound++) {
      // 轮数预算耗尽时本轮不再下发工具，让模型基于已获取的信息直接给出
      // 文本结论，避免“达到上限即强行终止”导致整轮结果被丢弃。
      final toolRoundsExhausted = toolRound >= maxToolRounds;
      final requestId = _idFactory();
      final assistantMessageId = _idFactory();
      final previousTime =
          workingHistory.lastOrNull?.createdAt ?? _now().toUtc();
      final currentTime = _now().toUtc();
      final assistantCreatedAt = currentTime.isAfter(previousTime)
          ? currentTime
          : previousTime.add(const Duration(microseconds: 1));
      final placeholder = AiMessage(
        id: assistantMessageId,
        conversationId: conversationId,
        role: AiMessageRole.assistant,
        parts: const [],
        status: AiMessageStatus.queued,
        parentId: parentId,
        createdAt: assistantCreatedAt,
      );
      await _conversationRepository.saveMessage(placeholder);
      final visibleMessages = [...workingHistory, placeholder];
      final requestMessages = _contextBuilder
          .buildWithStats(
            assistant: assistant,
            model: model,
            messages: workingHistory,
            idFactory: _idFactory,
            now: currentTime,
            environmentSystemPrompt: environment?.systemPrompt,
            persistedMemory: _memoryEntries,
          );
      _publishContext(requestMessages, workingHistory);
      final request = AiRequest(
        requestId: requestId,
        connection: connection,
        model: model,
        messages: requestMessages.messages,
        options: assistant.generation.copyWith(
          stream: assistant.generation.stream && model.capabilities.streaming,
        ),
        // 轮数预算耗尽后转为纯文本轮：不下发工具定义，模型只能输出文本
        // 总结收尾；若模型仍违规返回 tool_calls（部分网关不遵守），
        // 再在下方以 toolRoundsExceeded 失败收尾，避免无限循环。
        tools: toolRoundsExhausted ? const <AiToolSpec>[] : tools,
      );

      _emit(
        _state.copyWith(
          messages: visibleMessages,
          phase: AiChatSessionPhase.requesting,
          activeRequestId: requestId,
          activeAssistantMessageId: assistantMessageId,
          runSnapshot: AiStreamSnapshot(requestId: requestId),
          failure: null,
        ),
      );
      final run = _startRun(request);
      _activeRun = run;
      _runSubscription = run.snapshots.listen(
        (snapshot) => _handleSnapshot(snapshot, placeholder),
      );

      var finalSnapshot = await run.completed;
      await _runSubscription?.cancel();
      _runSubscription = null;
      _activeRun = null;
      if (finalSnapshot.status != AiStreamStatus.completed &&
          finalSnapshot.status != AiStreamStatus.failed) {
        finalSnapshot = finalSnapshot.copyWith(
          status: AiStreamStatus.failed,
          failure: const AiFailure(
            code: AiFailureCode.protocolTruncated,
            messageKey: 'ai.error.protocolTruncated',
            retryable: true,
          ),
        );
      }

      // 问答模式：模型以 question 块抛出疑问时挂起本轮，等用户作答后
      // 把答复作为用户消息回灌，继续同一轮生成。
      // 必须优先于工具调用判定：模型常「一边提问一边顺手发起工具调用」，
      // 若先走工具分支就会跳过挂起，用户永远等不到这个问题。
      final question = finalSnapshot.status == AiStreamStatus.completed
          ? AiQuestionParser.parse(finalSnapshot.text)
          : null;
      if (question != null) {
        // 提问轮只保留文本：同轮附带的工具调用一律丢弃，否则历史里会留下
        // 没有 tool 结果配对的 toolCall，下一轮请求会被协议拒绝。
        final questionMessage = _messageFromSnapshot(
          finalSnapshot.copyWith(toolCalls: const []),
          placeholder,
          completedAt: _now().toUtc(),
        );
        await _conversationRepository.saveMessage(questionMessage);
        final questionHistory = [
          for (final message in _state.messages)
            if (message.id == questionMessage.id) questionMessage else message,
        ];
        // 注意：_states 是 sync 广播流，_emit 会同步触发监听器读
        // pendingQuestion，因此挂起字段必须先于 _emit 赋值，否则会
        // 被映射成 null，导致卡片不可交互。
        _pendingQuestion = question;
        _answerCompleter = Completer<List<String>>();
        _emit(
          _state.copyWith(
            messages: questionHistory,
            phase: AiChatSessionPhase.awaitingUserAnswer,
            activeRequestId: null,
            activeAssistantMessageId: null,
            runSnapshot: null,
          ),
        );
        final answers = await _answerCompleter!.future;
        _answerCompleter = null;
        _pendingQuestion = null;
        if (answers.isEmpty || _closed) return;
        final answerMessage = AiMessage(
          id: _idFactory(),
          conversationId: conversationId,
          role: AiMessageRole.user,
          parts: [
            AiContentPart.text(
              AiAskPrompt.answerMessage(question.prompt, answers),
            ),
          ],
          status: AiMessageStatus.completed,
          parentId: questionMessage.id,
          createdAt: _now().toUtc(),
        );
        await _conversationRepository.saveMessage(answerMessage);
        workingHistory = [...questionHistory, answerMessage];
        parentId = answerMessage.id;
        _emit(
          _state.copyWith(
            messages: workingHistory,
            phase: AiChatSessionPhase.requesting,
            failure: null,
          ),
        );
        continue;
      }

      final hasToolCalls =
          finalSnapshot.status == AiStreamStatus.completed &&
          finalSnapshot.toolCalls.isNotEmpty;
      if (!hasToolCalls) {
        await _finishRun(finalSnapshot, placeholder);
        return;
      }
      // 仅 name 缺失才视为协议畸形整轮失败；call id 缺失（部分 DeepSeek
      // 流式分片全程 id 为 null）由 _messageFromSnapshot 合成稳定 id 继续，
      // OpenAI 协议只要求 assistant.tool_calls[].id 与 tool 消息的
      // tool_call_id 配对一致，合成 id 不影响回传。
      final invalidToolCall = finalSnapshot.toolCalls.firstWhere(
        (call) => call.name.trim().isEmpty,
        orElse: () => const AiToolCallSnapshot(index: -1),
      );
      if (invalidToolCall.index >= 0) {
        await _finishRun(
          finalSnapshot.copyWith(
            status: AiStreamStatus.failed,
            failure: AiFailure(
              code: AiFailureCode.protocolMalformed,
              messageKey:
                  'Responses tool call ${invalidToolCall.index} is missing name',
            ),
          ),
          placeholder,
        );
        return;
      }
      if (toolRoundsExhausted || environment?.toolExecutor == null) {
        await _finishRun(
          finalSnapshot.copyWith(
            status: AiStreamStatus.failed,
            failure: const AiFailure(
              code: AiFailureCode.toolFailed,
              messageKey: 'ai.error.toolRoundsExceeded',
            ),
          ),
          placeholder,
        );
        return;
      }

      final assistantMessage = await _persistCompletedToolCall(
        finalSnapshot,
        placeholder,
      );
      workingHistory = [...workingHistory, assistantMessage];

      final needsApproval = _needsToolApproval(
        assistant.toolPolicy,
        assistantMessage,
      );
      if (needsApproval) {
        _emit(
          _state.copyWith(
            messages: workingHistory,
            phase: AiChatSessionPhase.awaitingToolApproval,
            activeRequestId: null,
            activeAssistantMessageId: null,
            runSnapshot: null,
          ),
        );
        _pendingApprovalAssistantMessage = assistantMessage;
        _approvalCompleter = Completer<bool>();
        final approved = await _approvalCompleter!.future;
        _approvalCompleter = null;
        _pendingApprovalAssistantMessage = null;

        if (!approved) {
          final rejectionMessages = _createRejectedToolResults(
            assistantMessage,
            assistant.toolPolicy.maxResultBytes,
          );
          workingHistory = [...workingHistory, ...rejectionMessages];
          parentId = rejectionMessages.lastOrNull?.id ?? assistantMessage.id;
          _emit(
            _state.copyWith(
              messages: workingHistory,
              phase: AiChatSessionPhase.requesting,
              activeRequestId: null,
              activeAssistantMessageId: null,
              runSnapshot: null,
            ),
          );
          continue;
        }
      }

      _emit(
        _state.copyWith(
          messages: workingHistory,
          phase: AiChatSessionPhase.requesting,
          activeRequestId: null,
          activeAssistantMessageId: null,
          runSnapshot: null,
        ),
      );
      final toolMessages = await _executeToolCalls(
        assistantMessage,
        assistant.toolPolicy.maxResultBytes,
      );
      workingHistory = [...workingHistory, ...toolMessages];
      parentId = toolMessages.lastOrNull?.id ?? assistantMessage.id;
      _emit(
        _state.copyWith(
          messages: workingHistory,
          phase: AiChatSessionPhase.requesting,
          activeRequestId: null,
          activeAssistantMessageId: null,
          runSnapshot: null,
        ),
      );
    }
  }

  Future<AiMessage> _persistCompletedToolCall(
    AiStreamSnapshot snapshot,
    AiMessage placeholder,
  ) async {
    _checkpointTimer?.cancel();
    _checkpointTimer = null;
    _pendingCheckpointSnapshot = null;
    await _checkpointTail;
    final message = _messageFromSnapshot(
      snapshot,
      placeholder,
      completedAt: _now().toUtc(),
    );
    await _conversationRepository.saveMessage(message);
    return message;
  }

  Future<List<AiMessage>> _executeToolCalls(
    AiMessage assistantMessage,
    int maxResultBytes,
  ) async {
    final results = <AiMessage>[];
    var previousTime =
        assistantMessage.completedAt ?? assistantMessage.createdAt;
    String? parentId = assistantMessage.id;
    for (final part in assistantMessage.parts.whereType<AiToolCallPart>()) {
      final message = await _executeToolCall(
        part.toolCall,
        maxResultBytes: maxResultBytes,
        parentId: parentId,
        previousTime: previousTime,
      );
      results.add(message);
      parentId = message.id;
      previousTime = message.completedAt ?? message.createdAt;
    }
    return results;
  }

  Future<AiMessage> _executeToolCall(
    AiToolCall toolCall, {
    required int maxResultBytes,
    required String? parentId,
    required DateTime previousTime,
  }) async {
    final executor = environment!.toolExecutor!;
    AiToolResult rawResult;
    final rawArguments = toolCall.arguments['_rawArguments'];
    if (rawArguments is String) {
      // 兜底重试：参数拼接并修复后仍不是合法 JSON 时不执行工具，
      // 把格式错误连同原始参数文本明确回传给模型，模型在下一轮
      // 自我修正后重新调用（受 maxToolRounds 约束，不会无限循环）。
      rawResult = AiToolResult(
        toolCallId: toolCall.id,
        name: toolCall.name,
        success: false,
        content:
            'Tool arguments are not a valid JSON object; the tool was not '
            'executed. Raw arguments received: $rawArguments. Call the tool '
            'again with a complete JSON object, e.g. '
            '{"keyword": "value"}.',
      );
    } else {
      try {
        rawResult = await executor.execute(
          toolCall,
          onProgress: (progress) {
            _sendToolProgress(toolCall.id, progress);
          },
        );
      } catch (error) {
        rawResult = AiToolResult(
          toolCallId: toolCall.id,
          name: toolCall.name,
          success: false,
          content: 'Tool execution failed: $error',
        );
      }
    }
    final content = _truncateUtf8Like(rawResult.content, maxResultBytes);
    final now = _now().toUtc();
    final createdAt = now.isAfter(previousTime)
        ? now
        : previousTime.add(const Duration(microseconds: 1));
    final message = AiMessage(
      id: _idFactory(),
      conversationId: conversationId,
      role: AiMessageRole.tool,
      parts: [
        AiContentPart.toolResult(
          toolResult: rawResult.copyWith(content: content),
        ),
      ],
      parentId: parentId,
      createdAt: createdAt,
      completedAt: createdAt,
    );
    await _conversationRepository.saveMessage(message);
    _emit(
      _state.copyWith(
        messages: [..._state.messages, message],
        phase: AiChatSessionPhase.requesting,
      ),
    );
    return message;
  }

  static String _truncateUtf8Like(String content, int maxBytes) {
    if (maxBytes <= 0 || content.length <= maxBytes) return content;
    return '${content.substring(0, maxBytes)}\n\n[tool result truncated]';
  }

  void _sendToolProgress(String toolCallId, String progress) {
    // 工具执行进度回调：可在后续版本中通过消息更新或独立进度卡片展示
    // 当前版本通过工具执行状态变更（preparing -> running -> succeeded/failed）来展示进度
  }

  bool _needsToolApproval(AiToolPolicy toolPolicy, AiMessage assistantMessage) {
    if (toolPolicy.approvalMode == AiToolApprovalMode.never) return false;
    if (toolPolicy.approvalMode == AiToolApprovalMode.always) return true;
    // riskyOnly: 仅当消息中包含危险工具时才需要审批
    // 优先使用用户自定义的危险工具列表，没有则用系统默认 isRisky 标记
    final toolDefs = environment?.toolDefinitions ?? const [];
    final riskyNames = toolDefs
        .where((d) => d.isRisky == true)
        .map((d) => d.name)
        .toSet();
    return assistantMessage.parts.whereType<AiToolCallPart>().any(
      (part) => riskyNames.contains(part.toolCall.name),
    );
  }

  List<AiMessage> _createRejectedToolResults(
    AiMessage assistantMessage,
    int maxResultBytes,
  ) {
    final results = <AiMessage>[];
    var previousTime =
        assistantMessage.completedAt ?? assistantMessage.createdAt;
    String? parentId = assistantMessage.id;
    for (final part in assistantMessage.parts.whereType<AiToolCallPart>()) {
      final now = _now().toUtc();
      final createdAt = now.isAfter(previousTime)
          ? now
          : previousTime.add(const Duration(microseconds: 1));
      final message = AiMessage(
        id: _idFactory(),
        conversationId: conversationId,
        role: AiMessageRole.tool,
        parts: [
          AiContentPart.toolResult(
            toolResult: AiToolResult(
              toolCallId: part.toolCall.id,
              name: part.toolCall.name,
              success: false,
              content: '工具调用被用户拒绝',
            ),
          ),
        ],
        parentId: parentId,
        createdAt: createdAt,
        completedAt: createdAt,
      );
      results.add(message);
      parentId = message.id;
      previousTime = message.completedAt ?? message.createdAt;
    }
    return results;
  }

  /// 批准当前等待审批的所有工具调用
  void approvePendingTools() {
    final completer = _approvalCompleter;
    if (completer == null || completer.isCompleted) return;
    completer.complete(true);
  }

  /// 拒绝当前等待审批的所有工具调用
  void rejectPendingTools() {
    final completer = _approvalCompleter;
    if (completer == null || completer.isCompleted) return;
    completer.complete(false);
  }

  /// 是否有等待审批的工具调用
  bool get hasPendingToolApproval =>
      _approvalCompleter != null && !_approvalCompleter!.isCompleted;

  /// 当前挂起等待用户作答的问题；为空表示没有待作答问题。
  AiQuestion? get pendingQuestion => _pendingQuestion;

  /// 是否有等待用户作答的问题
  bool get hasPendingAnswer =>
      _answerCompleter != null && !_answerCompleter!.isCompleted;

  /// 用户提交作答后恢复本轮生成；[answers] 为空视为放弃作答。
  void submitAnswer(List<String> answers) {
    final completer = _answerCompleter;
    if (completer == null || completer.isCompleted) return;
    completer.complete(List<String>.from(answers));
  }

  void cancel() {
    // 如果有等待审批的工具，先拒绝它们
    final completer = _approvalCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(false);
    }
    // 如果有等待作答的问题，先放弃作答
    final answerCompleter = _answerCompleter;
    if (answerCompleter != null && !answerCompleter.isCompleted) {
      answerCompleter.complete(const <String>[]);
    }
    final run = _activeRun;
    if (run == null) return;
    _emit(_state.copyWith(phase: AiChatSessionPhase.cancelling));
    run.cancel();
  }

  void _handleSnapshot(AiStreamSnapshot snapshot, AiMessage placeholder) {
    if (snapshot.requestId != _state.activeRequestId || _closed) return;
    final phase = switch (snapshot.status) {
      AiStreamStatus.idle => AiChatSessionPhase.requesting,
      AiStreamStatus.streaming => AiChatSessionPhase.streaming,
      AiStreamStatus.completed => AiChatSessionPhase.streaming,
      AiStreamStatus.failed => AiChatSessionPhase.streaming,
    };
    _emit(_state.copyWith(phase: phase, runSnapshot: snapshot));
    if (snapshot.status == AiStreamStatus.streaming) {
      _scheduleCheckpoint(snapshot, placeholder);
    }
  }

  void _scheduleCheckpoint(AiStreamSnapshot snapshot, AiMessage placeholder) {
    _pendingCheckpointSnapshot = snapshot;
    if (_checkpointTimer != null) return;
    _checkpointTimer = Timer(checkpointInterval, () {
      _checkpointTimer = null;
      final pending = _pendingCheckpointSnapshot;
      _pendingCheckpointSnapshot = null;
      if (pending == null || pending.requestId != _state.activeRequestId) {
        return;
      }
      final checkpoint = _messageFromSnapshot(pending, placeholder);
      _checkpointTail = _checkpointTail
          .then((_) => _conversationRepository.saveMessage(checkpoint))
          .catchError((Object _) {});
    });
  }

  /// 熔断恢复：把会话从异常中恢复到可重试的 failed 状态。
  /// 将本轮未完成的 assistant 占位消息标记为失败并尽力持久化，
  /// 同时清理运行中的传输订阅、checkpoint 与审批挂起状态。
  Future<void> _recoverFromLoopFailure(
    Object error,
    StackTrace stackTrace,
  ) async {
    _runSubscription?.cancel();
    _runSubscription = null;
    _activeRun = null;
    _checkpointTimer?.cancel();
    _checkpointTimer = null;
    _pendingCheckpointSnapshot = null;
    final approvalCompleter = _approvalCompleter;
    if (approvalCompleter != null && !approvalCompleter.isCompleted) {
      approvalCompleter.complete(false);
    }
    _approvalCompleter = null;
    _pendingApprovalAssistantMessage = null;
    // 问答挂起同理：异常恢复时必须放弃作答，否则本轮会永久阻塞。
    final answerCompleter = _answerCompleter;
    if (answerCompleter != null && !answerCompleter.isCompleted) {
      answerCompleter.complete(const <String>[]);
    }
    _answerCompleter = null;
    _pendingQuestion = null;
    try {
      await _checkpointTail;
    } catch (_) {}

    final failure = AiFailure(
      code: AiFailureCode.unknown,
      messageKey: 'ai.error.unknown',
      detail: error.toString(),
      retryable: true,
    );
    var messages = _state.messages;
    final placeholderIndex = messages.lastIndexWhere(
      (message) =>
          message.role == AiMessageRole.assistant &&
          message.status != AiMessageStatus.completed &&
          message.status != AiMessageStatus.failed &&
          message.status != AiMessageStatus.cancelled,
    );
    if (placeholderIndex >= 0) {
      final failedMessage = messages[placeholderIndex].copyWith(
        status: AiMessageStatus.failed,
        failure: failure,
        completedAt: _now().toUtc(),
      );
      messages = [
        for (var i = 0; i < messages.length; i++)
          i == placeholderIndex ? failedMessage : messages[i],
      ];
      try {
        await _conversationRepository.saveMessage(failedMessage);
      } catch (_) {}
    }
    _emit(
      _state.copyWith(
        messages: messages,
        phase: AiChatSessionPhase.failed,
        activeRequestId: null,
        activeAssistantMessageId: null,
        runSnapshot: null,
        failure: failure,
      ),
    );
  }

  Future<void> _finishRun(
    AiStreamSnapshot snapshot,
    AiMessage placeholder,
  ) async {
    if (snapshot.requestId != _state.activeRequestId) return;
    _checkpointTimer?.cancel();
    _checkpointTimer = null;
    _pendingCheckpointSnapshot = null;
    await _checkpointTail;
    final finalMessage = _messageFromSnapshot(
      snapshot,
      placeholder,
      completedAt: _now().toUtc(),
    );
    await _conversationRepository.saveMessage(finalMessage);
    final conversation = _state.conversation!.copyWith(
      updatedAt: finalMessage.completedAt!,
    );
    await _conversationRepository.saveConversation(conversation);
    final updatedMessages = [
      for (final message in _state.messages)
        if (message.id == finalMessage.id) finalMessage else message,
    ];
    _activeRun = null;
    _emit(
      _state.copyWith(
        conversation: conversation,
        messages: updatedMessages,
        phase: finalMessage.status == AiMessageStatus.failed
            ? AiChatSessionPhase.failed
            : AiChatSessionPhase.ready,
        activeRequestId: null,
        activeAssistantMessageId: null,
        runSnapshot: null,
        failure: finalMessage.failure,
      ),
    );
  }

  AiMessage _messageFromSnapshot(
    AiStreamSnapshot snapshot,
    AiMessage placeholder, {
    DateTime? completedAt,
  }) {
    final parts = <AiContentPart>[
      if (snapshot.reasoning.isNotEmpty)
        AiContentPart.reasoning(snapshot.reasoning),
      if (snapshot.text.isNotEmpty) AiContentPart.text(snapshot.text),
      for (final call in snapshot.toolCalls)
        AiContentPart.toolCall(
          toolCall: AiToolCall(
            id: call.id != null && call.id!.trim().isNotEmpty
                ? call.id!
                : 'tool-${placeholder.id}-${call.index}',
            name: call.name,
            arguments: _decodeArguments(call.argumentsJson),
          ),
        ),
    ];
    final status = switch (snapshot.status) {
      AiStreamStatus.idle => AiMessageStatus.queued,
      AiStreamStatus.streaming => AiMessageStatus.streaming,
      AiStreamStatus.completed => AiMessageStatus.completed,
      AiStreamStatus.failed
          when snapshot.failure?.code == AiFailureCode.cancelled =>
        AiMessageStatus.cancelled,
      AiStreamStatus.failed => AiMessageStatus.failed,
    };
    return placeholder.copyWith(
      parts: parts,
      status: status,
      usage: snapshot.usage,
      failure: snapshot.failure,
      completedAt: completedAt,
    );
  }

  /// 拼接完成后的工具参数解码：先按原始 JSON 校验，失败时对 DeepSeek
  /// 流式分片截断的典型畸形（缺外层大括号、尾随逗号）做保守修复，
  /// 仍失败则保留原始文本（_rawArguments），由工具执行阶段生成格式
  /// 错误回传模型自我修正，而不是让 toolCall part 凭空消失。
  static Map<String, Object?> _decodeArguments(String source) {
    if (source.isEmpty) return const {};
    final direct = _tryDecodeArgumentsJson(source);
    if (direct != null) return direct;
    final repaired = _repairArgumentsJson(source);
    if (repaired != null) return repaired;
    final raw = source.length > 512 ? source.substring(0, 512) : source;
    return <String, Object?>{'_rawArguments': raw};
  }

  static Map<String, Object?>? _tryDecodeArgumentsJson(String source) {
    try {
      final decoded = jsonDecode(source);
      return decoded is Map
          ? Map<String, Object?>.from(decoded)
          : <String, Object?>{'value': decoded};
    } on FormatException {
      return null;
    }
  }

  /// 保守修复两类常见拼接畸形：
  /// 1. 分片截断导致缺外层大括号（如 `"keyword": "vip"`）→ 包裹大括号；
  /// 2. 对象字面量带尾随逗号（如 `{"a": 1,}`）→ 清理后重试。
  /// 修复后仍不是 JSON 对象则返回 null 交给兜底重试。
  static Map<String, Object?>? _repairArgumentsJson(String source) {
    var candidate = source.trim();
    if (candidate.isEmpty) return null;
    if (!candidate.startsWith('{')) {
      candidate = '{$candidate}';
    }
    candidate = candidate.replaceAll(RegExp(r',\s*([}\]])'), r'$1');
    try {
      final decoded = jsonDecode(candidate);
      return decoded is Map ? Map<String, Object?>.from(decoded) : null;
    } on FormatException {
      return null;
    }
  }

  Future<List<AiMessage>> _repairInterruptedMessages(
    List<AiMessage> messages,
  ) async {
    final repaired = <AiMessage>[];
    final changed = <AiMessage>[];
    for (final message in messages) {
      if (message.status == AiMessageStatus.streaming ||
          message.status == AiMessageStatus.queued) {
        final replacement = message.copyWith(
          status: AiMessageStatus.interrupted,
          failure: const AiFailure(
            code: AiFailureCode.unknown,
            messageKey: 'ai.error.interrupted',
            retryable: true,
          ),
          completedAt: _now().toUtc(),
        );
        repaired.add(replacement);
        changed.add(replacement);
      } else {
        repaired.add(message);
      }
    }
    if (changed.isNotEmpty) {
      await _conversationRepository.saveMessages(changed);
    }
    return repaired;
  }

  void _ensureCanStart() {
    if (!_state.canSend || _activeRun != null) {
      throw StateError(
        'Conversation $conversationId already has an active run',
      );
    }
  }

  void _emit(AiChatSessionState next) {
    if (_closed) return;
    _state = next;
    _states.add(next);
  }

  /// 组装完成后发布并持久化该对话的上下文状态：同步回调控制台（保证
  /// 交互低延迟），异步串行落盘（不阻塞请求链路）。
  void _publishContext(
    AiChatContextBuildResult assembled,
    List<AiMessage> history,
  ) {
    if (_closed) return;
    // 记忆条目是压缩器输出去重合并后的完整集合（本轮被裁摘要 +
    // 历史持久化条目），直接整体替换，供下一轮请求与重启后回流。
    _memoryEntries = assembled.memoryEntries;
    final restored = _restoredContext;
    final context = _contextDeriver
        .derive(
          history: history,
          stats: assembled.stats,
          sessionRules: assembled.systemPrompt,
          memoryEntries: assembled.memoryEntries,
        )
        .copyWith(
          // 恢复点与固定约束无法从消息历史重建，保留上次持久化的取值。
          checkpoint: restored?.checkpoint,
          pinnedContext: restored?.pinnedContext ?? const [],
          migratedFromLegacySummary:
              restored?.migratedFromLegacySummary ?? false,
        );
    _restoredContext = context;
    onContextAssembled?.call(conversationId, context);
    _contextTail = _contextTail
        .then(
          (_) => _conversationRepository.saveConversationContext(
            conversationId,
            context,
          ),
        )
        .catchError((Object _) {});
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _checkpointTimer?.cancel();
    _pendingCheckpointSnapshot = null;
    _approvalCompleter?.complete(false);
    _approvalCompleter = null;
    _pendingApprovalAssistantMessage = null;
    _answerCompleter?.complete(const <String>[]);
    _answerCompleter = null;
    _pendingQuestion = null;
    _activeRun?.cancel();
    await _runSubscription?.cancel();
    await _checkpointTail;
    await _contextTail;
    await _states.close();
  }
}
