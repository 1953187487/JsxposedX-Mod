import 'dart:async';
import 'dart:convert';

import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/providers/locale_provider.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_controller.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_environment.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_state.dart';
import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_executor_contract.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_environment_snapshot.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_response_issue.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_session_init_state.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';
import 'package:JsxposedX/features/ai/infrastructure/migration/legacy_ai_conversation_migrator.dart';
import 'package:JsxposedX/features/ai/infrastructure/services/ai_connection_test_service.dart';
import 'package:JsxposedX/features/ai/presentation/providers/chat/ai_chat_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/disabled_tools_store.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/user_risky_tools_store.dart';
import 'package:JsxposedX/features/ai/presentation/providers/plan/ai_plan_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/ask/ai_ask_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_catalog_actions_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/ai/presentation/mappers/ai_chat_view_message_mapper.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_runtime_state.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_session_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart'
    as standard;
import 'package:JsxposedX/features/ai/domain/ports/ai_tool_executor.dart';

part 'ai_chat_action_provider.g.dart';

@Riverpod(keepAlive: true)
Future<bool> aiStatus(Ref ref) async {
  // 必须 await 配置加载完成：配置 provider 被 invalidate 后重建时处于
  // AsyncLoading（此时 .value 为 null），若直接用 .value 判断会误判为
  // “未激活”，而 keepAlive 会把这次误判缓存下来，直到下次手动刷新。
  final config = await ref.watch(aiConfigProvider.future);
  if (config.apiUrl.isEmpty) return false;
  try {
    await ref.read(aiConnectionTestServiceProvider).test(config);
    return true;
  } catch (_) {
    return false;
  }
}

@riverpod
AiConnectionTestService aiConnectionTestService(Ref ref) {
  return AiConnectionTestService(ref.watch(aiDioProvider));
}

@riverpod
class AiChatAction extends _$AiChatAction {
  static const _viewMapper = AiChatViewMessageMapper();
  final StreamController<String> _streamingContentController =
      StreamController<String>.broadcast();
  final StreamController<bool> _streamingThinkingController =
      StreamController<bool>.broadcast();
  final Set<String> _migratedPackages = <String>{};

  AiChatSessionController? _sessionController;
  StreamSubscription<AiChatSessionState>? _sessionSubscription;
  AiChatSessionEnvironment? _environment;
  AiChatEnvironmentSnapshot? _lastSnapshot;
  bool _sessionReady = false;
  bool _disposed = false;

  /// 记录最近一次发送是否携带图片：带图片的请求失败后需要提示用户
  /// 为该模型配置图片能力，避免用户不知道“整个对话为什么废了”。
  bool _lastSendHadImage = false;

  Stream<String> get streamingContentStream =>
      _streamingContentController.stream;

  Stream<bool> get streamingThinkingStream =>
      _streamingThinkingController.stream;

  @override
  AiChatRuntimeState build({required String packageName}) {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      unawaited(_sessionSubscription?.cancel());
      unawaited(_sessionController?.close());
      unawaited(_streamingContentController.close());
      unawaited(_streamingThinkingController.close());
    });
    ref.listen(aiConfigProvider, (previous, next) {
      final before = previous?.value;
      final after = next.value;
      if (_disposed || after == null) return;
      if (before?.id == after.id &&
          before?.moduleName == after.moduleName &&
          before?.apiType == after.apiType &&
          before?.apiUrl == after.apiUrl) {
        return;
      }
      unawaited(_attachSession());
    });

    // 监听工具开关变化：实时更新会话中的工具列表与危险判定
    ref.listen(disabledToolsStoreProvider, (previous, next) {
      if (_disposed || _lastSnapshot == null) return;
      _reapplyToolState();
    });
    ref.listen(userRiskyToolsStoreProvider, (previous, next) {
      if (_disposed || _lastSnapshot == null) return;
      _reapplyToolState();
    });

    Future.microtask(_initializeSessions);
    return const AiChatRuntimeState();
  }

  void beginSessionInitialization() {
    _clearStreaming();
    state = state.copyWith(
      sessionInitState: AiSessionInitState.initializing,
      error: null,
      lastResponseIssue: null,
      toolsSpec: null,
      toolExecutor: null,
    );
  }

  void markSessionReady() {
    state = state.copyWith(
      sessionInitState: AiSessionInitState.ready,
      error: null,
      lastResponseIssue: null,
    );
  }

  void markSessionInitFailed(String message) {
    _clearStreaming();
    state = state.copyWith(
      sessionInitState: AiSessionInitState.failed,
      error: message,
      lastResponseIssue: AiResponseIssue.toolInitError,
      isStreaming: false,
      toolsSpec: null,
      toolExecutor: null,
    );
  }

  void applyEnvironmentSnapshot(AiChatEnvironmentSnapshot snapshot) {
    state = state.copyWith(
      systemPrompt: snapshot.systemPrompt,
      environmentVersion: snapshot.environmentVersion,
      sessionInitState: snapshot.sessionInitState,
      error: snapshot.error,
      lastResponseIssue: snapshot.sessionInitState == AiSessionInitState.failed
          ? AiResponseIssue.toolInitError
          : null,
      toolsSpec: snapshot.toolsSpec,
      toolExecutor: snapshot.toolExecutor,
      toolDefinitions: snapshot.toolDefinitions,
      sessionContext: state.sessionContext.copyWith(
        sessionRules: _buildSessionRules(),
      ),
    );
    _lastSnapshot = snapshot;
    final previous = _environment;
    _environment = _standardEnvironment(snapshot);
    if (!_environmentsEquivalent(previous, _environment)) {
      unawaited(_attachSession());
    }
  }

  AiChatSessionEnvironment _standardEnvironment(
    AiChatEnvironmentSnapshot snapshot,
  ) {
    final apiType =
        ref.read(aiConfigProvider).value?.apiType ?? AiApiType.openai;
    final tools =
        snapshot.toolsSpec?.buildToolsJson(apiType: apiType) ??
        const <Map<String, dynamic>>[];

    // 读取被禁用 + 用户自定义危险工具，合并到 toolDefinitions
    final configId = ref.read(aiConfigProvider).value?.id ?? '';
    final disabledTools =
        ref.read(disabledToolsStoreProvider)[configId] ?? <String>{};
    final userRisky =
        ref.read(userRiskyToolsStoreProvider)[configId] ?? <String, bool>{};
    final finalToolDefs = snapshot.toolDefinitions
        .map((d) {
          // 危险判定按工具独立计算：用户的明确选择完全覆盖系统默认。
          // 未配置用系统默认；配置 true/false 一律以用户为准，
          // 保证系统默认危险的工具也能被用户关闭。
          final effectiveRisky = userRisky[d.name] ?? (d.isRisky == true);
          return AiToolDefinition(
            name: d.name,
            description: d.description,
            descriptionEn: d.descriptionEn,
            parameters: d.parameters,
            isRisky: effectiveRisky,
          );
        })
        .toList(growable: false);

    return AiChatSessionEnvironment(
      id: 'reverse-${snapshot.scopeId}',
      scopeId: snapshot.scopeId,
      version: snapshot.environmentVersion,
      // 系统规则统一由 _buildSessionRules 组装：基础提示 + 计划模式约束，
      // 这样切换计划模式时无需重建环境快照即可生效。
      systemPrompt: _buildSessionRules(),
      tools: tools
          .map((raw) {
            final rawFunction = raw['function'];
            final function = rawFunction is Map
                ? Map<String, dynamic>.from(rawFunction)
                : Map<String, dynamic>.from(raw);
            final rawParameters =
                function['parameters'] ?? function['input_schema'];
            return standard.AiToolSpec(
              name: function['name']?.toString() ?? '',
              description: function['description']?.toString() ?? '',
              inputSchema: rawParameters is Map
                  ? Map<String, Object?>.from(rawParameters)
                  : const <String, Object?>{},
            );
          })
          .where(
            (tool) =>
                tool.name.isNotEmpty && !disabledTools.contains(tool.name),
          )
          .toList(growable: false),
      toolExecutor: snapshot.toolExecutor == null
          ? null
          : _LegacyStandardToolExecutor(snapshot.toolExecutor!),
      toolDefinitions: finalToolDefs,
    );
  }

  /// 工具开关变化时重新应用环境
  void _reapplyToolState() {
    final snapshot = _lastSnapshot;
    if (snapshot == null || _disposed) return;
    final previous = _environment;
    _environment = _standardEnvironment(snapshot);
    if (!_environmentsEquivalent(previous, _environment)) {
      unawaited(_attachSession());
    }
  }

  /// 判断两个环境是否等价（version/scopeId/tools 均相同）
  bool _environmentsEquivalent(
    AiChatSessionEnvironment? left,
    AiChatSessionEnvironment? right,
  ) {
    if (identical(left, right)) return true;
    if (left == null || right == null) return false;
    if (left.version != right.version || left.scopeId != right.scopeId) {
      return false;
    }
    final leftNames = left.tools.map((t) => t.name).toSet();
    final rightNames = right.tools.map((t) => t.name).toSet();
    return leftNames.length == rightNames.length &&
        leftNames.containsAll(rightNames);
  }

  Future<void> _initializeSessions() async {
    try {
      final config = await ref.read(aiConfigProvider.future);
      if (_disposed || !ref.mounted) return;
      await _migrateLegacySessions(config);
      final sessions = await getSessionsAsync();
      if (_disposed || !ref.mounted || sessions.isEmpty) return;
      state = state.copyWith(
        currentSessionId: null,
        standardMessages: const [],
        viewMessages: const [],
        visibleMessageCount: 10,
        hasOlderMessages: false,
        sessionContext: AiChatSessionContext(sessionRules: _buildSessionRules()),
        contextStats: const AiChatContextStats(),
        contextVersion: AiChatSessionContext.currentVersion,
      );
    } catch (error) {
      if (_disposed || !ref.mounted) return;
      state = state.copyWith(error: 'AI 会话加载失败：$error', isStreaming: false);
    }
  }

  Future<List<AiChatSessionView>> getSessionsAsync() async {
    // 在任何异步 gap 之前捕获依赖。调用方通常是 ref.read(...notifier)，
    // 不会建立订阅，autoDispose 会在下一帧回收 provider；此后访问 ref 或
    // state 都会抛 "Cannot use the Ref ... after it has been disposed"。
    // 仓库实例已在销毁前取出，继续查询本身是安全的，因此这里不中途返回，
    // 否则会把“provider 被回收”误判成“该应用暂无 AI 会话”。
    final config = ref.read(aiConfigProvider).value;
    final repository = ref.read(aiConversationRepositoryV2Provider);
    if (config != null) await _migrateLegacySessions(config);
    final conversations = <standard.AiConversation>[];
    AiConversationCursor? cursor;
    while (true) {
      final page = await repository.getConversations(
        before: cursor,
        limit: 100,
      );
      conversations.addAll(page);
      if (page.length < 100) break;
      final last = page.last;
      cursor = AiConversationCursor(updatedAt: last.updatedAt, id: last.id);
    }
    final sessions =
        conversations
            .where((conversation) => conversation.scopeId == packageName)
            .map(
              (conversation) => AiChatSessionView(
                id: conversation.id,
                name: conversation.title,
                scopeId: packageName,
                updatedAt: conversation.updatedAt.toLocal(),
              ),
            )
            .toList(growable: true)
          ..sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    if (!_disposed) {
      state = state.copyWith(
        sessions: List<AiChatSessionView>.unmodifiable(sessions),
      );
    }
    return sessions;
  }

  List<AiChatSessionView> getSessions() => state.sessions;

  Future<void> switchSession(String sessionId) async {
    if (state.isStreaming) {
      state = state.copyWith(error: '请先停止当前响应，再切换会话');
      return;
    }
    final conversation = await ref
        .read(aiConversationRepositoryV2Provider)
        .getConversation(sessionId);
    if (conversation == null || conversation.scopeId != packageName) {
      state = state.copyWith(error: '会话不存在或不属于当前逆向目标');
      return;
    }
    _clearStreaming();
    state = state.copyWith(
      currentSessionId: sessionId,
      standardMessages: const [],
      viewMessages: const [],
      visibleMessageCount: 10,
      hasOlderMessages: false,
      error: null,
      isStreaming: false,
      lastResponseIssue: null,
      sessionContext: AiChatSessionContext(sessionRules: _buildSessionRules()),
      contextStats: const AiChatContextStats(),
      contextVersion: AiChatSessionContext.currentVersion,
    );
    await _attachSession();
  }

  Future<void> _attachSession() async {
    final sessionId = state.currentSessionId;
    final environment = _environment;
    if (_disposed || sessionId == null || environment == null) return;

    _sessionReady = false;
    final previousSubscription = _sessionSubscription;
    final previousController = _sessionController;
    _sessionSubscription = null;
    _sessionController = null;
    await previousSubscription?.cancel();
    await previousController?.close();

    AiChatSessionController? controller;
    try {
      controller = AiChatSessionController(
        conversationId: sessionId,
        catalogRepository: ref.read(aiCatalogRepositoryProvider),
        conversationRepository: ref.read(aiConversationRepositoryV2Provider),
        startRun: ref.read(aiChatOrchestratorProvider).start,
        idFactory: const Uuid().v4,
        environment: environment,
        onContextAssembled: _handleContextAssembled,
      );
      _sessionController = controller;
      _sessionSubscription = controller.states.listen(_applySessionState);
      await controller.initialize();
      if (!identical(_sessionController, controller)) {
        await controller.close();
        return;
      }
      _sessionReady = true;
      _applySessionState(controller.state);
    } catch (error) {
      if (controller != null && !identical(_sessionController, controller)) {
        await controller.close();
        return;
      }
      _sessionReady = false;
      state = state.copyWith(
        error: '标准 AI 会话初始化失败：$error',
        isStreaming: false,
        lastResponseIssue: AiResponseIssue.toolInitError,
      );
    }
  }

  /// 写入当前会话真实的上下文状态：组装统计（token 预算/裁剪/参与层）
  /// 与从消息派生的工具轨迹、任务状态，供控制台可视化。
  void _handleContextAssembled(
    String conversationId,
    AiChatSessionContext context,
  ) {
    if (_disposed || conversationId != state.currentSessionId) return;
    if (_sameContext(state.sessionContext, context)) return;
    state = state.copyWith(
      sessionContext: context,
      contextStats: context.stats,
      contextVersion: context.version,
    );
  }

  /// 上下文状态逐字段比较成本高，这里以持久化 JSON 作为等价性基准，
  /// 既能覆盖嵌套结构，又能避免无变化时的重复重建。
  static bool _sameContext(
    AiChatSessionContext left,
    AiChatSessionContext right,
  ) {
    if (identical(left, right)) return true;
    return jsonEncode(left.toStorageJson()) ==
        jsonEncode(right.toStorageJson());
  }

  void _applySessionState(AiChatSessionState next) {
    if (_disposed || next.conversationId != state.currentSessionId) return;
    var display = _viewMapper.mapHistory(next.messages, phase: next.phase);
    final snapshot = next.runSnapshot;
    if (snapshot != null) {
      final id = next.activeAssistantMessageId ?? 'standard-streaming';
      final streaming = _viewMapper.mapStreaming(
        messageId: id,
        snapshot: snapshot,
      );
      final index = display.indexWhere((message) => message.id == id);
      if (index < 0) {
        display = [...display, streaming];
      } else {
        final updated = List.of(display);
        updated[index] = streaming;
        display = updated;
      }
      _pushStreaming(streaming.content);
      _pushThinking(snapshot.reasoning.isNotEmpty && snapshot.text.isEmpty);
    }

    final streaming =
        next.phase == AiChatSessionPhase.requesting ||
        next.phase == AiChatSessionPhase.streaming ||
        next.phase == AiChatSessionPhase.cancelling ||
        next.phase == AiChatSessionPhase.awaitingToolApproval ||
        next.phase == AiChatSessionPhase.awaitingUserAnswer;
    if (!streaming && snapshot == null) _clearStreaming();
    state = state.copyWith(
      sessions: _updatedSessions(next.conversation),
      standardMessages: List<standard.AiMessage>.unmodifiable(next.messages),
      viewMessages: List.unmodifiable(display),
      hasOlderMessages: next.hasOlderMessages,
      isStreaming: streaming,
      error: next.failure == null
          ? null
          : LegacyAiConversationMigrator.describeAiFailure(next.failure!),
      lastResponseIssue: _issueFor(next.failure),
      // 带图片的请求失败时提示用户配置该模型的图片能力，
      // 让用户能从错误本身直接完成配置，而不是整轮对话作废。
      visionConfigPromptPending:
          next.failure != null &&
          next.failure!.code != standard.AiFailureCode.cancelled &&
          _lastSendHadImage,
      pendingQuestion: next.isAwaitingUserAnswer
          ? _sessionController?.pendingQuestion
          : null,
    );
  }

  List<AiChatSessionView> _updatedSessions(
    standard.AiConversation? conversation,
  ) {
    if (conversation == null) return state.sessions;
    final sessions = List<AiChatSessionView>.from(state.sessions);
    final index = sessions.indexWhere((item) => item.id == conversation.id);
    final mapped = AiChatSessionView(
      id: conversation.id,
      name: conversation.title,
      scopeId: packageName,
      updatedAt: conversation.updatedAt.toLocal(),
    );
    if (index < 0) {
      sessions.add(mapped);
    } else {
      sessions[index] = mapped;
    }
    sessions.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return List<AiChatSessionView>.unmodifiable(sessions);
  }

  AiResponseIssue? _issueFor(standard.AiFailure? failure) {
    if (failure == null || failure.code == standard.AiFailureCode.cancelled) {
      return null;
    }
    return switch (failure.code) {
      standard.AiFailureCode.protocolMalformed => AiResponseIssue.parseError,
      standard.AiFailureCode.protocolTruncated =>
        AiResponseIssue.partialResponse,
      _ => AiResponseIssue.networkError,
    };
  }

  void loadMore() {
    if (state.visibleMessageCount < state.viewMessages.length) {
      state = state.copyWith(
        visibleMessageCount: (state.visibleMessageCount + 10).clamp(
          0,
          state.viewMessages.length,
        ),
      );
      return;
    }
    if (state.hasOlderMessages && _sessionReady) {
      unawaited(_loadOlderMessages());
    }
  }

  Future<void> _loadOlderMessages() async {
    try {
      await _sessionController?.loadOlderMessages();
      if (_disposed) return;
      state = state.copyWith(
        visibleMessageCount: (state.visibleMessageCount + 10).clamp(
          0,
          state.viewMessages.length,
        ),
      );
    } catch (error) {
      if (!_disposed) state = state.copyWith(error: '加载历史消息失败：$error');
    }
  }

  Future<void> createSession(String name) async {
    final config = ref.read(aiConfigProvider).value;
    if (config == null) {
      state = state.copyWith(error: 'AI 配置未加载');
      return;
    }
    await _migrateLegacySessions(config);
    final assistantId = 'legacy-assistant-${config.id}';
    final assistant = await ref
        .read(aiCatalogRepositoryProvider)
        .getAssistant(assistantId);
    if (assistant == null) {
      state = state.copyWith(error: '标准 AI 配置尚未就绪，无法创建会话');
      return;
    }
    final now = DateTime.now();
    final id = const Uuid().v4();
    final title = name.trim().isEmpty ? assistant.name : name.trim();
    await ref
        .read(aiConversationRepositoryV2Provider)
        .saveConversation(
          standard.AiConversation(
            id: id,
            title: title,
            assistantId: assistantId,
            environmentId: 'general',
            scopeId: packageName,
            createdAt: now.toUtc(),
            updatedAt: now.toUtc(),
          ),
        );
    state = state.copyWith(
      currentSessionId: id,
      sessions: [
        AiChatSessionView(
          id: id,
          name: title,
          scopeId: packageName,
          updatedAt: now,
        ),
        ...state.sessions,
      ],
      standardMessages: const [],
      viewMessages: const [],
      visibleMessageCount: 10,
      hasOlderMessages: false,
      error: null,
      isStreaming: false,
      lastResponseIssue: null,
      sessionContext: AiChatSessionContext(sessionRules: _buildSessionRules()),
      contextStats: const AiChatContextStats(),
      contextVersion: AiChatSessionContext.currentVersion,
    );
    await _attachSession();
  }

  /// 组合当前生效的会话系统规则：基础系统提示 + 计划模式约束 + 问答模式约束。
  String _buildSessionRules() {
    return AiAskPrompt.systemRules(
      baseRules: AiPlanPrompt.systemRules(
        baseRules: state.systemPrompt ?? '',
        enabled: state.planModeEnabled,
        isZh: _resolveIsZh(),
      ),
      enabled: state.askModeEnabled,
      isZh: _resolveIsZh(),
    );
  }

  /// 切换计划模式：更新系统规则，并让当前会话在下一轮请求中生效。
  /// 计划约束只进入系统规则，不拼进用户消息，因此不会显示在对话气泡里。
  Future<void> setPlanMode(bool enabled) async {
    if (_disposed || state.planModeEnabled == enabled) return;
    state = state.copyWith(planModeEnabled: enabled);
    await _refreshSessionRules();
  }

  /// 切换问答模式：更新系统规则，并让当前会话在下一轮请求中生效。
  /// 与计划模式一致，约束只走系统规则，不污染用户消息与气泡。
  Future<void> setAskMode(bool enabled) async {
    if (_disposed || state.askModeEnabled == enabled) return;
    state = state.copyWith(askModeEnabled: enabled);
    await _refreshSessionRules();
  }

  /// 重建系统规则并重挂会话；_attachSession 用的是缓存的 _environment，
  /// 这里必须同步重建，否则新的系统规则不会进入下一轮请求。
  Future<void> _refreshSessionRules() async {
    state = state.copyWith(
      sessionContext: AiChatSessionContext(sessionRules: _buildSessionRules()),
      contextVersion: AiChatSessionContext.currentVersion,
    );
    final snapshot = _lastSnapshot;
    if (snapshot != null) {
      _environment = _standardEnvironment(snapshot);
    }
    await _attachSession();
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    // 问答模式挂起期间，输入框内容即用户对该问题的自由作答，
    // 直接回灌给挂起的本轮，而不是开启新的一轮请求。
    if (state.pendingQuestion != null) {
      submitAnswer(<String>[text.trim()]);
      return;
    }
    if (state.isStreaming) return;
    if (state.currentSessionId == null) {
      await createSession(
        '新对话 ${DateTime.now().hour}:${DateTime.now().minute}',
      );
    }
    if (state.sessionInitState == AiSessionInitState.initializing) {
      state = state.copyWith(
        error: '逆向会话仍在初始化，请稍后再试。',
        lastResponseIssue: AiResponseIssue.toolInitError,
      );
      return;
    }
    if (state.sessionInitState == AiSessionInitState.failed) {
      state = state.copyWith(
        error: state.error ?? '逆向会话初始化失败，当前无法发送消息。',
        lastResponseIssue: AiResponseIssue.toolInitError,
      );
      return;
    }
    final controller = _readyController();
    if (controller == null) return;
    // 记录本轮是否带图片：若发送失败，需要提示用户为该模型配置图片能力，
    // 而不是让整轮对话无声作废。
    _lastSendHadImage = AiMultimodalMessageCodec.hasImageAttachments(text);
    // 关闭图片能力的模型，图片附件会在请求构造层被降级为文本占位。这里在发送
    // 前就判定出来，发送后提示用户「图片未真正送达」，避免误以为已经发出。
    final visionBlocked = _lastSendHadImage && !_currentModelAllowsVision();
    state = state.copyWith(visionConfigPromptPending: false);
    try {
      await controller.sendText(text);
      if (!_disposed && visionBlocked) {
        state = state.copyWith(visionConfigPromptPending: true);
      }
    } catch (error) {
      if (!_disposed) {
        state = state.copyWith(
          error: '消息发送失败：$error',
          isStreaming: false,
          lastResponseIssue: AiResponseIssue.networkError,
          visionConfigPromptPending: _lastSendHadImage,
        );
      }
    }
  }

  /// 当前模型是否声明支持图片输入。
  ///
  /// 仅读取已缓存的能力（[aiModelsV2Provider] 由快捷设置与配置页预加载），
  /// 未加载时按「不支持」处理：宁可不发图片，也不要因误发触发服务端拒绝。
  bool _currentModelAllowsVision() {
    final config = ref.read(aiConfigProvider).value;
    if (config == null) return false;
    final modelId = config.moduleName.trim();
    if (modelId.isEmpty) return false;
    final connectionId = 'legacy-connection-${config.id}';
    final models = ref.read(aiModelsV2Provider(connectionId)).value;
    if (models == null) return false;
    final model = models.where((item) => item.id == modelId).firstOrNull;
    return model?.capabilities.visionInput ?? false;
  }

  /// 用户确认「当前模型支持图片输入」或「不支持」后写回模型能力。
  ///
  /// 能力只存在于模型目录（[standard.AiModelDefinition]）里，因此这里基于
  /// 目录中的现有定义做 [standard.AiModelDefinition.copyWith]，既保留其它
  /// 能力与限制，又能让下一轮请求按新的能力判断。
  Future<void> markVisionCapability({required bool supported}) async {
    final config = ref.read(aiConfigProvider).value;
    if (config == null) return;
    final modelId = config.moduleName.trim();
    if (modelId.isEmpty) return;
    final connectionId = 'legacy-connection-${config.id}';
    final repository = ref.read(aiCatalogRepositoryProvider);
    final models = await repository.getModels(connectionId);
    final index = models.indexWhere((model) => model.id == modelId);
    if (index < 0) return;
    final current = models[index];
    final updated = current.copyWith(
      capabilities: current.capabilities.copyWith(visionInput: supported),
    );
    await ref.read(aiCatalogActionsV2Provider.notifier).saveModel(updated);
    if (!_disposed) {
      state = state.copyWith(visionConfigPromptPending: false);
    }
  }

  /// 用户忽略「配置图片能力」提示时复位标志。
  void dismissVisionConfigPrompt() {
    if (_disposed || !state.hasVisionConfigPrompt) return;
    state = state.copyWith(visionConfigPromptPending: false);
  }

  /// 去掉最近一条用户消息中的图片后重发，保留原有文字内容。
  ///
  /// 用于模型确实不支持图片的场景：用户不必重新组织文案，直接以纯文本
  /// 继续这一轮对话。
  Future<void> resendLastTurnWithoutImage() async {
    if (state.isStreaming) return;
    final index = state.standardMessages.lastIndexWhere(
      (message) => message.role == standard.AiMessageRole.user,
    );
    if (index < 0) return;
    final original = state.standardMessages[index];
    final originalText = original.parts
        .whereType<standard.AiTextPart>()
        .map((part) => part.text)
        .join();
    final stripped = AiMultimodalMessageCodec.stripImageAttachments(
      originalText,
    );
    if (!AiMultimodalMessageCodec.hasImageAttachments(originalText)) return;
    if (stripped.trim().isEmpty) {
      if (!_disposed) {
        state = state.copyWith(visionConfigPromptPending: false);
      }
      return;
    }
    await editUserMessageAndResend(
      messageId: original.id,
      updatedText: stripped,
    );
  }

  Future<void> editUserMessageAndResend({
    required String messageId,
    required String updatedText,
  }) async {
    if (state.isStreaming) return;
    final index = state.standardMessages.indexWhere(
      (message) =>
          message.id == messageId &&
          message.role == standard.AiMessageRole.user,
    );
    if (index < 0) return;
    final original = state.standardMessages[index];
    final originalText = original.parts
        .whereType<standard.AiTextPart>()
        .map((part) => part.text)
        .join();
    if (!AiMultimodalMessageCodec.canEditText(originalText)) return;
    final content = AiMultimodalMessageCodec.replaceUserText(
      originalText,
      updatedText,
    );
    if (content.trim().isEmpty) return;
    final controller = _readyController();
    if (controller == null) return;
    try {
      await controller.editUserMessageAndResend(
        messageId: messageId,
        updatedText: content,
      );
    } catch (error) {
      if (!_disposed) {
        state = state.copyWith(
          error: '消息发送失败：$error',
          lastResponseIssue: AiResponseIssue.networkError,
        );
      }
    }
  }

  Future<void> retryByMessageId(String messageId) async {
    if (state.isStreaming) return;
    final controller = _readyController();
    if (controller == null) return;
    try {
      await controller.retryByMessageId(messageId, isZh: _resolveIsZh());
    } catch (error) {
      if (!_disposed) {
        state = state.copyWith(
          error: '重试失败：$error',
          lastResponseIssue: AiResponseIssue.networkError,
        );
      }
    }
  }

  Future<void> deleteMessage(String messageId) async {
    if (state.isStreaming) return;
    final controller = _readyController();
    if (controller == null) return;
    try {
      await controller.deleteMessage(messageId);
    } catch (error) {
      if (!_disposed) {
        state = state.copyWith(error: '删除消息失败：$error');
      }
    }
  }

  Future<void> clearAssistantResponse(String messageId) async {
    if (state.isStreaming) return;
    final controller = _readyController();
    if (controller == null) return;
    try {
      await controller.clearAssistantResponse(messageId);
    } catch (error) {
      if (!_disposed) state = state.copyWith(error: '清除回复失败：$error');
    }
  }

  Future<void> continueGeneration(String messageId) async {
    if (state.isStreaming) return;
    final controller = _readyController();
    if (controller == null) return;
    try {
      await controller.continueGeneration(messageId, isZh: _resolveIsZh());
    } catch (error) {
      if (!_disposed) state = state.copyWith(error: '继续生成失败：$error');
    }
  }

  Future<void> retryLastTurn() async {
    if (state.isStreaming) return;
    final controller = _readyController();
    if (controller == null) return;
    // 存在中断/失败的 assistant 轮次时，不回退会话，
    // 改为发送语言匹配的“继续”指令，基于中断前的上下文接续推进。
    final hasInterrupted = controller.state.messages.any(
      (message) =>
          message.role == standard.AiMessageRole.assistant &&
          (message.status == standard.AiMessageStatus.failed ||
              message.status == standard.AiMessageStatus.cancelled ||
              message.status == standard.AiMessageStatus.interrupted),
    );
    if (hasInterrupted) {
      try {
        await controller.continueFromInterruption(isZh: _resolveIsZh());
      } catch (error) {
        if (!_disposed) {
          state = state.copyWith(
            error: '重试失败：$error',
            lastResponseIssue: AiResponseIssue.networkError,
          );
        }
      }
      return;
    }
    if (!state.hasUserMessages) return;
    final lastUser = state.standardMessages.lastWhere(
      (message) => message.role == standard.AiMessageRole.user,
    );
    await retryByMessageId(lastUser.id);
  }

  /// 读取当前应用语言，用于生成语言匹配的“继续”指令。
  bool _resolveIsZh() => ref.read(localeProvider).languageCode == 'zh';

  Future<void> stopStreaming() async {
    if (!state.isStreaming) return;
    final controller = _readyController(showError: false);
    if (controller == null) {
      state = state.copyWith(
        error: '标准 AI 会话尚未就绪，当前没有可取消的请求。',
        isStreaming: false,
        lastResponseIssue: AiResponseIssue.toolInitError,
      );
      return;
    }
    controller.cancel();
  }

  /// 批准当前等待审批的工具调用
  void approvePendingTools() {
    final controller = _readyController(showError: false);
    controller?.approvePendingTools();
  }

  /// 拒绝当前等待审批的工具调用
  void rejectPendingTools() {
    final controller = _readyController(showError: false);
    controller?.rejectPendingTools();
  }

  /// 是否有等待审批的工具调用
  bool get hasPendingToolApproval =>
      _sessionController?.hasPendingToolApproval ?? false;

  /// 当前挂起等待用户作答的问题；为空表示没有待作答问题。
  AiQuestion? get pendingQuestion => _sessionController?.pendingQuestion;

  /// 用户提交作答，恢复本轮生成。
  void submitAnswer(List<String> answers) {
    final controller = _readyController(showError: false);
    controller?.submitAnswer(answers);
  }

  Future<void> deleteSession(String sessionId) async {
    if (state.currentSessionId == sessionId && state.isStreaming) {
      state = state.copyWith(error: '请先停止当前响应，再删除会话');
      return;
    }
    if (state.currentSessionId == sessionId) {
      await _sessionSubscription?.cancel();
      await _sessionController?.close();
      _sessionSubscription = null;
      _sessionController = null;
      _sessionReady = false;
    }
    await ref
        .read(aiConversationRepositoryV2Provider)
        .deleteConversation(sessionId);
    final remaining = List<AiChatSessionView>.from(state.sessions)
      ..removeWhere((session) => session.id == sessionId);
    if (state.currentSessionId != sessionId) {
      state = state.copyWith(sessions: List.unmodifiable(remaining));
      return;
    }
    if (remaining.isNotEmpty) {
      state = state.copyWith(sessions: List.unmodifiable(remaining));
      await switchSession(remaining.first.id);
      return;
    }
    _clearStreaming();
    state = state.copyWith(
      sessions: const [],
      currentSessionId: null,
      standardMessages: const [],
      viewMessages: const [],
      visibleMessageCount: 10,
      hasOlderMessages: false,
      isStreaming: false,
      error: null,
      lastResponseIssue: null,
      sessionContext: AiChatSessionContext(
        sessionRules: state.systemPrompt ?? '',
      ),
      contextStats: const AiChatContextStats(),
      contextVersion: AiChatSessionContext.currentVersion,
    );
  }

  Future<void> deleteHistory() async {
    final id = state.currentSessionId;
    if (id != null) await deleteSession(id);
  }

  Future<void> clear() async {
    await createSession('新对话 ${DateTime.now().hour}:${DateTime.now().minute}');
  }

  /// 把历史消息纳入可见窗口，使 [messageId] 所在的消息能够被渲染。
  ///
  /// 返回是否成功命中（未命中表示该消息不在当前已加载的会话消息中）。
  bool revealMessage(String messageId) {
    final index = state.viewMessages.indexWhere(
      (message) => message.id == messageId,
    );
    if (index < 0) return false;
    final required = state.viewMessages.length - index;
    if (required > state.visibleMessageCount) {
      state = state.copyWith(visibleMessageCount: required);
    }
    return true;
  }

  Future<String> testConnection(AiConfig config) {
    return ref.read(aiConnectionTestServiceProvider).test(config);
  }

  AiChatSessionController? _readyController({bool showError = true}) {
    final controller = _sessionController;
    if (_sessionReady && controller != null) return controller;
    if (showError) {
      state = state.copyWith(
        error: '标准 AI 会话尚未就绪，请重试会话初始化。',
        lastResponseIssue: AiResponseIssue.toolInitError,
      );
    }
    return null;
  }

  Future<void> _migrateLegacySessions(AiConfig config) async {
    if (_migratedPackages.contains(packageName)) return;
    // 同样在任何异步 gap 之前取齐依赖，迁移过程本身可能跨越 provider 的
    // 销毁时机（用户离开页面），之后再碰 ref 就会抛异常。
    final migration = ref.read(aiSystemMigrationProvider.future);
    final migrator = LegacyAiConversationMigrator(
      queryRepository: ref.read(aiChatQueryRepositoryProvider),
      catalogRepository: ref.read(aiCatalogRepositoryProvider),
      conversationRepository: ref.read(aiConversationRepositoryV2Provider),
    );
    await migration;
    await migrator.migratePackage(packageName: packageName, config: config);
    _migratedPackages.add(packageName);
  }

  void _pushStreaming(String content) {
    if (!_streamingContentController.isClosed) {
      _streamingContentController.add(content);
    }
  }

  void _pushThinking(bool value) {
    if (!_streamingThinkingController.isClosed) {
      _streamingThinkingController.add(value);
    }
  }

  void _clearStreaming() {
    _pushStreaming('');
    _pushThinking(false);
  }
}

class _LegacyStandardToolExecutor implements AiToolExecutor {
  const _LegacyStandardToolExecutor(this._delegate);

  final AiChatToolExecutorContract _delegate;

  @override
  Future<standard.AiToolResult> execute(
    standard.AiToolCall call, {
    AiToolProgress? onProgress,
  }) async {
    final result = await _delegate.execute(
      AiToolCall(
        id: call.id,
        name: call.name,
        arguments: Map<String, dynamic>.from(call.arguments),
      ),
      onProgress: onProgress,
    );
    return standard.AiToolResult(
      toolCallId: result.toolCallId,
      name: result.toolName,
      success: result.success,
      content: result.success ? result.content : result.errorContent,
    );
  }
}
