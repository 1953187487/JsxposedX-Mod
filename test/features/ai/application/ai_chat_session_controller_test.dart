import 'dart:async';
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_orchestrator.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_environment.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_controller.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_state.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_ai_catalog_repository.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_tool_executor.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/domain/registries/protocol_adapter_registry.dart';
import 'package:JsxposedX/features/ai/domain/registries/provider_definition_registry.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_chat_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart'
    hide
        AiAssistantProfile,
        AiConversation,
        AiModelDefinition,
        AiProviderConnection;

void main() {
  late AiDatabase database;
  late DriftAiCatalogRepository catalog;
  late DriftAiConversationRepository conversations;

  setUp(() async {
    database = AiDatabase.forTesting(NativeDatabase.memory());
    catalog = DriftAiCatalogRepository(database);
    conversations = DriftAiConversationRepository(database);
    await _seedCatalog(catalog);
    await conversations.saveConversation(
      AiConversation(
        id: 'conversation',
        title: 'Chat',
        assistantId: 'assistant',
        createdAt: _epoch,
        updatedAt: _epoch,
      ),
    );
  });

  tearDown(() => database.close());

  test(
    'publishes real stream snapshots and persists the final message',
    () async {
      final transport = _ControlledTransport();
      final controller = _controller(catalog, conversations, transport);
      await controller.initialize();

      final sending = controller.sendText('hello');
      await transport.sent.future;
      transport.addChatDelta('Hel');
      await _waitUntil(() => controller.state.runSnapshot?.text == 'Hel');

      expect(controller.state.phase, AiChatSessionPhase.streaming);
      expect(controller.state.runSnapshot?.text, 'Hel');
      expect(controller.state.messages, hasLength(2));
      expect(controller.state.messages.last.parts, isEmpty);

      transport.addChatDelta('lo');
      await transport.complete();
      await sending;

      final assistantMessage = controller.state.messages.last;
      expect(controller.state.phase, AiChatSessionPhase.ready);
      expect(assistantMessage.status, AiMessageStatus.completed);
      expect(
        assistantMessage.parts.whereType<AiTextPart>().single.text,
        'Hello',
      );
      final stored = await conversations.getMessages('conversation');
      expect(stored, hasLength(2));
      expect(stored.last.id, assistantMessage.id);
      await controller.close();
    },
  );

  test('rejects a second run in the same conversation', () async {
    final transport = _ControlledTransport();
    final controller = _controller(catalog, conversations, transport);
    await controller.initialize();

    final sending = controller.sendText('first');
    await transport.sent.future;

    await expectLater(controller.sendText('second'), throwsStateError);

    await transport.complete();
    await sending;
    expect(await conversations.getMessages('conversation'), hasLength(2));
    await controller.close();
  });

  test('cancels the transport and keeps partial output', () async {
    final transport = _ControlledTransport();
    final controller = _controller(catalog, conversations, transport);
    await controller.initialize();

    final sending = controller.sendText('hello');
    await transport.sent.future;
    transport.addChatDelta('partial');
    await Future<void>.delayed(const Duration(milliseconds: 80));
    controller.cancel();
    await sending;

    final assistantMessage = controller.state.messages.last;
    expect(assistantMessage.status, AiMessageStatus.cancelled);
    expect(
      assistantMessage.parts.whereType<AiTextPart>().single.text,
      'partial',
    );
    expect(controller.state.hasActiveRun, isFalse);
    await controller.close();
  });

  test('repairs a stale streaming message during initialization', () async {
    await conversations.saveMessage(
      AiMessage(
        id: 'stale',
        conversationId: 'conversation',
        role: AiMessageRole.assistant,
        parts: const [AiContentPart.text('partial')],
        status: AiMessageStatus.streaming,
        createdAt: _epoch.add(const Duration(seconds: 1)),
      ),
    );
    final controller = _controller(
      catalog,
      conversations,
      _ControlledTransport(),
    );

    await controller.initialize();

    expect(
      controller.state.messages.single.status,
      AiMessageStatus.interrupted,
    );
    expect(
      (await conversations.getMessages('conversation')).single.status,
      AiMessageStatus.interrupted,
    );
    await controller.close();
  });

  test('publishes real context stats for the active conversation', () async {
    final transport = _TextTransport(['answer']);
    final assembled = <AiChatSessionContext>[];
    final controller = _controller(
      catalog,
      conversations,
      transport,
      onContextAssembled: (conversationId, context) {
        expect(conversationId, 'conversation');
        assembled.add(context);
      },
    );

    // 初始化恢复阶段即产出统计：预算来自模型上下文上限（4096），
    // 空历史下估算值仍为 0 而不是伪造值。
    await controller.initialize();
    expect(assembled, hasLength(1));
    expect(assembled.single.stats.tokenBudget, 4096);
    expect(assembled.single.stats.estimatedTokens, 0);
    expect(assembled.single.stats.remainingTokens, 4096);
    expect(assembled.single.stats.includedLayers, ['token_budget']);

    await controller.sendText('question');

    // 每轮请求下发前再次产出统计，且估算值真实、不超预算。
    expect(assembled, hasLength(2));
    final stats = assembled.last.stats;
    expect(stats.tokenBudget, 4096);
    expect(stats.estimatedTokens, greaterThan(0));
    expect(stats.remainingTokens, 4096 - stats.estimatedTokens);
    expect(stats.didCompact, isFalse);
    expect(stats.recentRoundsKept, 1);
    expect(stats.includedLayers, ['token_budget']);
    await controller.close();
  });

  test('persists edited user content before regenerating', () async {
    final transport = _TextTransport(['first answer', 'edited answer']);
    final controller = _controller(catalog, conversations, transport);
    await controller.initialize();
    await controller.sendText('original question');

    final userMessageId = controller.state.messages.first.id;
    await controller.editUserMessageAndResend(
      messageId: userMessageId,
      updatedText: 'edited question',
    );

    final stored = await conversations.getMessages('conversation');
    expect(stored, hasLength(2));
    expect(stored.first.id, userMessageId);
    expect(
      stored.first.parts.whereType<AiTextPart>().single.text,
      'edited question',
    );
    expect(
      stored.last.parts.whereType<AiTextPart>().single.text,
      'edited answer',
    );
    await controller.close();
  });

  test('deletes a single message when idle', () async {
    final controller = _controller(
      catalog,
      conversations,
      _TextTransport(['answer']),
    );
    await controller.initialize();
    await controller.sendText('question');
    final assistantId = controller.state.messages.last.id;
    await controller.deleteMessage(assistantId);
    expect(controller.state.messages, hasLength(1));
    expect((await conversations.getMessages('conversation')), hasLength(1));
    await controller.close();
  });

  test('executes reverse tools and returns results to the model', () async {
    final transport = _ScriptedToolTransport();
    const executor = _FakeToolExecutor();
    final controller = _controller(
      catalog,
      conversations,
      transport,
      environment: const AiChatSessionEnvironment(
        id: 'apk_reverse',
        scopeId: 'com.example.app',
        version: 'v2',
        systemPrompt: 'Analyze the APK with tools.',
        tools: [
          AiToolSpec(
            name: 'get_manifest',
            description: 'Read manifest',
            inputSchema: {'type': 'object'},
          ),
        ],
        toolExecutor: executor,
      ),
    );

    await controller.initialize();
    await controller.sendText('analyze');

    expect(transport.requests, hasLength(2));
    final secondMessages = transport.requests[1].body['messages'] as List;
    expect(
      secondMessages.whereType<Map>().any(
        (message) =>
            message['role'] == 'tool' && message['content'] == 'manifest-data',
      ),
      isTrue,
    );
    final stored = await conversations.getMessages('conversation');
    expect(stored, hasLength(4));
    expect(stored[1].parts.whereType<AiToolCallPart>(), hasLength(1));
    expect(stored[2].parts.whereType<AiToolResultPart>(), hasLength(1));
    expect(
      stored.last.parts.whereType<AiTextPart>().single.text,
      'analysis complete',
    );

    await controller.regenerateLastResponse();
    expect(transport.requests, hasLength(3));
    expect(await conversations.getMessages('conversation'), hasLength(2));
    await controller.close();
  });

  test('persists a failed tool result when the executor throws', () async {
    final transport = _ScriptedToolTransport();
    final controller = _controller(
      catalog,
      conversations,
      transport,
      environment: const AiChatSessionEnvironment(
        id: 'apk_reverse',
        scopeId: 'com.example.app',
        version: 'v2',
        systemPrompt: '',
        tools: [
          AiToolSpec(
            name: 'get_manifest',
            description: 'Read manifest',
            inputSchema: {'type': 'object'},
          ),
        ],
        toolExecutor: _ThrowingToolExecutor(),
      ),
    );

    await controller.initialize();
    await controller.sendText('analyze');

    final stored = await conversations.getMessages('conversation');
    final result = stored
        .expand((message) => message.parts)
        .whereType<AiToolResultPart>()
        .single
        .toolResult;
    expect(result.success, isFalse);
    expect(result.content, contains('boom'));
    expect(controller.state.phase, AiChatSessionPhase.ready);
    await controller.close();
  });

  test(
    'retries a failed tool result and continues the assistant turn',
    () async {
      final transport = _ScriptedToolTransport();
      final executor = _FlakyToolExecutor();
      final controller = _controller(
        catalog,
        conversations,
        transport,
        environment: AiChatSessionEnvironment(
          id: 'apk_reverse',
          scopeId: 'com.example.app',
          version: 'v2',
          systemPrompt: '',
          tools: const [
            AiToolSpec(
              name: 'get_manifest',
              description: 'Read manifest',
              inputSchema: {'type': 'object'},
            ),
          ],
          toolExecutor: executor,
        ),
      );

      await controller.initialize();
      await controller.sendText('analyze');

      final failedToolMessage = controller.state.messages.singleWhere(
        (message) =>
            message.role == AiMessageRole.tool &&
            message.parts.whereType<AiToolResultPart>().any(
              (part) => !part.toolResult.success,
            ),
      );

      await controller.retryByMessageId(failedToolMessage.id);

      expect(executor.calls, 2);
      expect(transport.requests, hasLength(3));
      final stored = await conversations.getMessages('conversation');
      expect(stored, hasLength(4));
      final retriedResult = stored
          .expand((message) => message.parts)
          .whereType<AiToolResultPart>()
          .single
          .toolResult;
      expect(retriedResult.success, isTrue);
      expect(retriedResult.content, 'manifest-data-after-retry');
      expect(
        stored.last.parts.whereType<AiTextPart>().single.text,
        'analysis complete',
      );
      await controller.close();
    },
  );

  test(
    'continues from an interruption with a Chinese continue prompt',
    () async {
      final transport = _CancelThenTextTransport();
      final controller = _controller(catalog, conversations, transport);
      await controller.initialize();

      final sending = controller.sendText('analyze this app');
      await transport.sent.future;
      controller.cancel();
      await sending;
      expect(controller.state.messages.last.status, AiMessageStatus.cancelled);

      await controller.retryLastResponse(isZh: true);

      // 中断历史完整保留，不回退到会话起始状态。
      final stored = await conversations.getMessages('conversation');
      expect(stored, hasLength(4));
      expect(
        stored[0].parts.whereType<AiTextPart>().single.text,
        'analyze this app',
      );
      expect(stored[1].status, AiMessageStatus.cancelled);
      expect(stored[2].role, AiMessageRole.user);
      expect(stored[2].parts.whereType<AiTextPart>().single.text, '继续');
      expect(
        stored.last.parts.whereType<AiTextPart>().single.text,
        'resumed answer',
      );
      // 接续请求基于既有上下文，包含原始问题与“继续”指令。
      expect(transport.requests, hasLength(2));
      final secondMessages = transport.requests[1].body['messages'] as List;
      final contents = secondMessages
          .whereType<Map>()
          .map((message) => message['content'])
          .toList();
      expect(contents, contains('analyze this app'));
      expect(contents, contains('继续'));
      await controller.close();
    },
  );

  test(
    'continues from an interruption with an English continue prompt',
    () async {
      final transport = _CancelThenTextTransport();
      final controller = _controller(catalog, conversations, transport);
      await controller.initialize();

      final sending = controller.sendText('analyze this app');
      await transport.sent.future;
      controller.cancel();
      await sending;

      await controller.retryLastResponse(isZh: false);

      final stored = await conversations.getMessages('conversation');
      expect(stored, hasLength(4));
      expect(stored[2].parts.whereType<AiTextPart>().single.text, 'Continue');
      expect(
        stored.last.parts.whereType<AiTextPart>().single.text,
        'resumed answer',
      );
      await controller.close();
    },
  );

  test(
    'reports unrecoverable tool call arguments to the model for retry',
    () async {
      // 复现线上异常数据流：tool_calls 分片 id 为 null、name 为空字符串、
      // arguments 分多次送达，累积后不是合法 JSON 且无法自动修复。
      final transport = _SseFragmentedToolTransport();
      final controller = _controller(
        catalog,
        conversations,
        transport,
        environment: const AiChatSessionEnvironment(
          id: 'apk_reverse',
          scopeId: 'com.example.app',
          version: 'v2',
          systemPrompt: '',
          tools: [
            AiToolSpec(
              name: 'get_manifest',
              description: 'Read manifest',
              inputSchema: {'type': 'object'},
            ),
          ],
          toolExecutor: _FakeToolExecutor(),
        ),
      );

      await controller.initialize();
      await controller.sendText('analyze');

      // 畸形参数不能让 toolCall part 凭空消失：id 与 name 正确累积，
      // 原始参数文本以 _rawArguments 保留。
      final stored = await conversations.getMessages('conversation');
      expect(stored, hasLength(4));
      final toolCallPart = stored[1].parts.whereType<AiToolCallPart>().single;
      expect(toolCallPart.toolCall.id, 'call-1');
      expect(toolCallPart.toolCall.name, 'get_manifest');
      expect(toolCallPart.toolCall.arguments, contains('_rawArguments'));
      expect(
        toolCallPart.toolCall.arguments['_rawArguments'],
        contains('keyword'),
      );
      // 兜底重试：不可修复时不执行工具，格式错误连同原始文本作为
      // tool result 回传给模型，由模型自我修正后重新调用。
      final toolResultPart = stored[2].parts
          .whereType<AiToolResultPart>()
          .single;
      expect(toolResultPart.toolResult.success, isFalse);
      expect(
        toolResultPart.toolResult.content,
        contains('not a valid JSON object'),
      );
      expect(
        toolResultPart.toolResult.content,
        contains(toolCallPart.toolCall.arguments['_rawArguments'] as String),
      );
      // 工具结果仍回传给模型，第二轮请求含 tool 消息，链路不中断。
      expect(transport.requests, hasLength(2));
      final secondMessages = transport.requests[1].body['messages'] as List;
      expect(
        secondMessages.whereType<Map>().any(
          (message) => message['role'] == 'tool',
        ),
        isTrue,
      );
      expect(
        stored.last.parts.whereType<AiTextPart>().single.text,
        'analysis complete',
      );
      expect(controller.state.phase, AiChatSessionPhase.ready);
      await controller.close();
    },
  );

  test(
    'assembles multi-chunk SSE tool call arguments into valid JSON',
    () async {
      // 精确复现线上日志：search_classes 参数分块传输（{、"keyword":
      // "pay"}），后续分块 id 为 null、name 为空，拼接后为完整合法 JSON。
      final transport = _SseScriptTransport([
        [
          _toolCallChunk(
            index: 0,
            id: '01a0c868595133c333aadf99dd4e7533',
            name: 'search_classes',
            arguments: '',
          ),
          _toolCallChunk(index: 0, id: null, arguments: '{'),
          _toolCallChunk(index: 0, id: null, arguments: '"keyword": "pay"}'),
          _finishToolCallsChunk(),
        ],
        [_textChunk('analysis complete')],
      ]);
      final executor = _RecordingToolExecutor();
      final controller = _controller(
        catalog,
        conversations,
        transport,
        environment: AiChatSessionEnvironment(
          id: 'apk_reverse',
          scopeId: 'com.example.app',
          version: 'v2',
          systemPrompt: '',
          tools: [
            const AiToolSpec(
              name: 'search_classes',
              description: 'Search classes',
              inputSchema: {'type': 'object'},
            ),
          ],
          toolExecutor: executor,
        ),
      );

      await controller.initialize();
      await controller.sendText('find pay logic');

      // 元数据完整保留（首分块的 id/name），参数拼接为合法 JSON 对象。
      expect(executor.calls, hasLength(1));
      expect(executor.calls.single.id, '01a0c868595133c333aadf99dd4e7533');
      expect(executor.calls.single.name, 'search_classes');
      expect(executor.calls.single.arguments, {'keyword': 'pay'});

      // 第二轮请求中 assistant tool_call id 与 tool 消息 tool_call_id
      // 配对一致，回传协议合法。
      final secondMessages = transport.requests[1].body['messages'] as List;
      final assistantJson = secondMessages.whereType<Map>().firstWhere(
        (message) => message['tool_calls'] != null,
      );
      final toolCallJson = (assistantJson['tool_calls'] as List).single as Map;
      final toolJson = secondMessages.whereType<Map>().firstWhere(
        (message) => message['role'] == 'tool',
      );
      expect(toolCallJson['id'], '01a0c868595133c333aadf99dd4e7533');
      expect(toolJson['tool_call_id'], '01a0c868595133c333aadf99dd4e7533');
      expect(
        (toolCallJson['function'] as Map)['arguments'],
        '{"keyword":"pay"}',
      );
      expect(controller.state.phase, AiChatSessionPhase.ready);
      await controller.close();
    },
  );

  test('repairs tool call arguments that lost the outer braces', () async {
    // 复现上一轮线上日志：分片参数累积为 "keyword": "vip"（缺外层
    // 大括号），拼接完成后自动包裹修复，无需模型重试。
    final transport = _SseScriptTransport([
      [
        _toolCallChunk(
          index: 0,
          id: 'call-1',
          name: 'search_classes',
          arguments: '',
        ),
        _toolCallChunk(index: 0, id: null, arguments: '"keyword": "v'),
        _toolCallChunk(index: 0, id: null, arguments: 'ip"'),
        _finishToolCallsChunk(),
      ],
      [_textChunk('analysis complete')],
    ]);
    final executor = _RecordingToolExecutor();
    final controller = _controller(
      catalog,
      conversations,
      transport,
      environment: AiChatSessionEnvironment(
        id: 'apk_reverse',
        scopeId: 'com.example.app',
        version: 'v2',
        systemPrompt: '',
        tools: [
          const AiToolSpec(
            name: 'search_classes',
            description: 'Search classes',
            inputSchema: {'type': 'object'},
          ),
        ],
        toolExecutor: executor,
      ),
    );

    await controller.initialize();
    await controller.sendText('find vip logic');

    // 修复后工具正常执行：executor 收到完整参数而非 _rawArguments。
    expect(executor.calls, hasLength(1));
    expect(executor.calls.single.arguments, {'keyword': 'vip'});
    expect(executor.calls.single.arguments, isNot(contains('_rawArguments')));
    expect(controller.state.phase, AiChatSessionPhase.ready);
    await controller.close();
  });

  test(
    'synthesizes a stable tool call id when every fragment omits the id',
    () async {
      // 复现 id 全程为 null 的流（name 首分块携带、参数合法）：
      // 修复前会以 protocolMalformed 整轮失败，修复后合成稳定 id 继续。
      final transport = _SseScriptTransport([
        [
          _toolCallChunk(
            index: 0,
            id: null,
            name: 'search_classes',
            arguments: '{"keyword": "root"}',
          ),
          _finishToolCallsChunk(),
        ],
        [_textChunk('analysis complete')],
      ]);
      final executor = _RecordingToolExecutor();
      final controller = _controller(
        catalog,
        conversations,
        transport,
        environment: AiChatSessionEnvironment(
          id: 'apk_reverse',
          scopeId: 'com.example.app',
          version: 'v2',
          systemPrompt: '',
          tools: [
            const AiToolSpec(
              name: 'search_classes',
              description: 'Search classes',
              inputSchema: {'type': 'object'},
            ),
          ],
          toolExecutor: executor,
        ),
      );

      await controller.initialize();
      await controller.sendText('find root logic');

      // 合成 id 以 tool- 开头，工具正常执行，会话不再失败。
      expect(executor.calls, hasLength(1));
      final synthesizedId = executor.calls.single.id;
      expect(synthesizedId, startsWith('tool-'));

      // 第二轮请求中 assistant/tool 消息使用同一合成 id 配对回传。
      final secondMessages = transport.requests[1].body['messages'] as List;
      final assistantJson = secondMessages.whereType<Map>().firstWhere(
        (message) => message['tool_calls'] != null,
      );
      final toolCallJson = (assistantJson['tool_calls'] as List).single as Map;
      final toolJson = secondMessages.whereType<Map>().firstWhere(
        (message) => message['role'] == 'tool',
      );
      expect(toolCallJson['id'], synthesizedId);
      expect(toolJson['tool_call_id'], synthesizedId);
      expect(controller.state.phase, AiChatSessionPhase.ready);
      await controller.close();
    },
  );

  test(
    'recovers to a retryable failed state when persistence fails mid tool loop',
    () async {
      final transport = _ScriptedToolTransport();
      // 第 3 次 saveMessage（持久化工具调用轮的 assistant 消息）抛 DB 异常。
      // 修复前该异常会逃逸出 _runAssistantLoop，会话永久停留在
      // requesting，无法再次发送；修复后应熔断恢复到 failed（可重试）。
      final repository = _FailingSaveMessageRepository(
        conversations,
        failOnAttempt: 3,
      );
      final controller = _controller(
        catalog,
        repository,
        transport,
        environment: const AiChatSessionEnvironment(
          id: 'apk_reverse',
          scopeId: 'com.example.app',
          version: 'v2',
          systemPrompt: '',
          tools: [
            AiToolSpec(
              name: 'get_manifest',
              description: 'Read manifest',
              inputSchema: {'type': 'object'},
            ),
          ],
          toolExecutor: _FakeToolExecutor(),
        ),
      );

      await controller.initialize();
      await controller.sendText('analyze');

      expect(controller.state.phase, AiChatSessionPhase.failed);
      expect(controller.state.failure, isNotNull);
      expect(controller.state.failure!.retryable, isTrue);
      expect(controller.state.failure!.detail, contains('db write failed'));
      expect(controller.state.hasActiveRun, isFalse);
      expect(controller.state.canSend, isTrue);
      final assistantMessage = controller.state.messages
          .where((message) => message.role == AiMessageRole.assistant)
          .last;
      expect(assistantMessage.status, AiMessageStatus.failed);
      expect(assistantMessage.failure, isNotNull);

      // 熔断恢复后功能可用：再次发送能正常完成整轮对话。
      await controller.sendText('retry');
      expect(controller.state.phase, AiChatSessionPhase.ready);
      expect(transport.requests, hasLength(2));
      final stored = await conversations.getMessages('conversation');
      expect(
        stored.last.parts.whereType<AiTextPart>().single.text,
        'analysis complete',
      );
      await controller.close();
    },
  );

  test('retries a failed tool result using the current turn budget', () async {
    // 复现间歇性失败：重试失败工具结果时轮数误用“整段会话累计值”。
    // 两轮用户消息各产生一次工具调用（累计 2，已达本用例预算上限 2），
    // 修复前重试会立即被判超限而失败；修复后按“当前用户轮次”计数
    // （仅 1 轮），重试可获得剩余预算顺利完成。
    await _useToolPolicy(catalog, const AiToolPolicy(maxRounds: 2));
    final transport = _SseScriptTransport([
      [
        // 第 1 轮用户消息：模型请求工具（执行成功）。
        _toolCallChunk(
          index: 0,
          id: 'call-1',
          name: 'get_manifest',
          arguments: '{}',
        ),
        _finishToolCallsChunk(),
      ],
      [_textChunk('first answer')],
      [
        // 第 2 轮用户消息：模型请求工具（执行失败）。
        _toolCallChunk(
          index: 0,
          id: 'call-2',
          name: 'get_manifest',
          arguments: '{}',
        ),
        _finishToolCallsChunk(),
      ],
      // 失败结果回传后模型先给出部分回答，等待用户重试失败的工具。
      [_textChunk('partial answer')],
      [
        // 重试续跑：模型再请求一次工具（执行成功）。
        _toolCallChunk(
          index: 0,
          id: 'call-3',
          name: 'get_manifest',
          arguments: '{}',
        ),
        _finishToolCallsChunk(),
      ],
      [_textChunk('analysis complete')],
    ]);
    final executor = _SequenceToolExecutor([true, false, true, true]);
    final controller = _controller(
      catalog,
      conversations,
      transport,
      environment: AiChatSessionEnvironment(
        id: 'apk_reverse',
        scopeId: 'com.example.app',
        version: 'v2',
        systemPrompt: '',
        tools: [
          const AiToolSpec(
            name: 'get_manifest',
            description: 'Read manifest',
            inputSchema: {'type': 'object'},
          ),
        ],
        toolExecutor: executor,
      ),
    );

    await controller.initialize();
    await controller.sendText('first question');
    await controller.sendText('second question');

    final failedToolMessage = controller.state.messages.singleWhere(
      (message) =>
          message.role == AiMessageRole.tool &&
          message.parts.whereType<AiToolResultPart>().any(
            (part) => !part.toolResult.success,
          ),
    );
    await controller.retryByMessageId(failedToolMessage.id);

    // 重试未被误判超限：3 次执行（成功/失败/重试成功），
    // 随后进入纯文本收尾，会话最终顺利完成而非超限失败。
    expect(executor.calls, 3);
    expect(transport.requests, hasLength(6));
    expect(controller.state.phase, AiChatSessionPhase.ready);
    expect(controller.state.failure, isNull);
    final stored = await conversations.getMessages('conversation');
    expect(
      stored.last.parts.whereType<AiTextPart>().single.text,
      'analysis complete',
    );

    // 预算耗尽后的收尾请求不再携带工具定义（纯文本轮），
    // 倒数第二次请求（重试续跑）仍携带工具。
    final retryTools = transport.requests[4].body['tools'];
    expect(retryTools, isA<List>());
    expect(retryTools as List, isNotEmpty);
    final wrapUpTools = transport.requests[5].body['tools'];
    expect(wrapUpTools == null || (wrapUpTools as List).isEmpty, isTrue);
    await controller.close();
  });

  test(
    'wraps up with a text-only round when the tool round budget is exhausted',
    () async {
      // 预算 2 轮：恰好执行 2 次工具后不再下发工具定义，模型转为文本
      // 总结收尾。修复前第 2 轮后模型再请求工具会以 toolRoundsExceeded
      // 整轮失败，丢失全部已完成的工具结果。
      await _useToolPolicy(catalog, const AiToolPolicy(maxRounds: 2));
      final transport = _ToolLovingTransport();
      final executor = _RecordingToolExecutor();
      final controller = _controller(
        catalog,
        conversations,
        transport,
        environment: AiChatSessionEnvironment(
          id: 'apk_reverse',
          scopeId: 'com.example.app',
          version: 'v2',
          systemPrompt: '',
          tools: [
            const AiToolSpec(
              name: 'get_manifest',
              description: 'Read manifest',
              inputSchema: {'type': 'object'},
            ),
          ],
          toolExecutor: executor,
        ),
      );

      await controller.initialize();
      await controller.sendText('analyze');

      expect(executor.calls, hasLength(2));
      expect(transport.requests, hasLength(3));
      // 收尾请求未携带工具定义。
      final wrapUpTools = transport.requests[2].body['tools'];
      expect(wrapUpTools == null || (wrapUpTools as List).isEmpty, isTrue);
      expect(controller.state.phase, AiChatSessionPhase.ready);
      expect(controller.state.failure, isNull);
      final stored = await conversations.getMessages('conversation');
      expect(
        stored.last.parts.whereType<AiTextPart>().single.text,
        'budget summary',
      );
      await controller.close();
    },
  );

  test(
    'completes tool-heavy reverse tasks within the default round budget',
    () async {
      // 压力场景：模型持续请求工具直到预算耗尽。历史默认 8 轮会在
      // 第 8 轮后强制失败；新默认预算下整轮任务顺利完成并正常收尾。
      final transport = _ToolLovingTransport();
      final executor = _RecordingToolExecutor();
      final controller = _controller(
        catalog,
        conversations,
        transport,
        environment: AiChatSessionEnvironment(
          id: 'apk_reverse',
          scopeId: 'com.example.app',
          version: 'v2',
          systemPrompt: '',
          tools: [
            const AiToolSpec(
              name: 'get_manifest',
              description: 'Read manifest',
              inputSchema: {'type': 'object'},
            ),
          ],
          toolExecutor: executor,
        ),
      );

      await controller.initialize();
      await controller.sendText('analyze');

      expect(executor.calls, hasLength(kDefaultMaxToolRounds));
      expect(transport.requests, hasLength(kDefaultMaxToolRounds + 1));
      expect(controller.state.phase, AiChatSessionPhase.ready);
      expect(controller.state.failure, isNull);
      await controller.close();
    },
  );

  test(
    'fails boundedly when the model keeps calling tools past the budget',
    () async {
      // 兜底：部分网关不遵守“无工具定义即不返回 tool_calls”，预算耗尽
      // 的纯文本轮仍返回工具调用。此时必须有界失败（toolRoundsExceeded）
      // 而不是无限循环或静默丢弃。
      await _useToolPolicy(catalog, const AiToolPolicy(maxRounds: 1));
      final transport = _ToolLovingTransport(violateNoToolsRound: true);
      final executor = _RecordingToolExecutor();
      final controller = _controller(
        catalog,
        conversations,
        transport,
        environment: AiChatSessionEnvironment(
          id: 'apk_reverse',
          scopeId: 'com.example.app',
          version: 'v2',
          systemPrompt: '',
          tools: [
            const AiToolSpec(
              name: 'get_manifest',
              description: 'Read manifest',
              inputSchema: {'type': 'object'},
            ),
          ],
          toolExecutor: executor,
        ),
      );

      await controller.initialize();
      await controller.sendText('analyze');

      expect(executor.calls, hasLength(1));
      expect(transport.requests, hasLength(2));
      expect(controller.state.phase, AiChatSessionPhase.failed);
      expect(
        controller.state.failure?.messageKey,
        'ai.error.toolRoundsExceeded',
      );
      expect(controller.state.hasActiveRun, isFalse);
      await controller.close();
    },
  );

  test('resolves configurable tool round budgets', () async {
    // 非正值回落默认值，1~50 的输入（包括历史默认值 8）保持用户配置，
    // 超范围值收敛到合法边界。
    expect(const AiToolPolicy().maxRounds, kDefaultMaxToolRounds);
    expect(resolveMaxToolRounds(0), kDefaultMaxToolRounds);
    expect(resolveMaxToolRounds(-3), kDefaultMaxToolRounds);
    expect(resolveMaxToolRounds(8), 8);
    expect(resolveMaxToolRounds(12), 12);
    expect(resolveMaxToolRounds(1), kMinMaxToolRounds);
    expect(resolveMaxToolRounds(kMaxMaxToolRounds), 50);
    expect(resolveMaxToolRounds(51), kMaxMaxToolRounds);
    expect(resolveMaxToolRounds(999), kMaxMaxToolRounds);

    // 用户保存的自定义值经过 DTO 往返后仍保持不变。
    final assistant = await catalog.getAssistant('assistant');
    await catalog.saveAssistant(
      assistant!.copyWith(
        toolPolicy: assistant.toolPolicy.copyWith(maxRounds: 8),
      ),
    );
    final saved = await catalog.getAssistant('assistant');
    expect(saved!.toolPolicy.maxRounds, 8);
  });
}

AiChatSessionController _controller(
  DriftAiCatalogRepository catalog,
  AiConversationRepository conversations,
  AiTransport transport, {
  AiChatSessionEnvironment? environment,
  void Function(String conversationId, AiChatSessionContext context)?
  onContextAssembled,
}) {
  final ids = _IdFactory();
  final orchestrator = AiChatOrchestrator(
    providerRegistry: ProviderDefinitionRegistry(const [
      AiProviderDefinition(
        id: 'openai',
        displayName: 'OpenAI',
        adapterId: 'openai.chat.v1',
      ),
    ]),
    adapterRegistry: ProtocolAdapterRegistry(const [OpenAiChatAdapter()]),
    transport: transport,
    credentialStore: const _CredentialStore(),
  );
  return AiChatSessionController(
    conversationId: 'conversation',
    catalogRepository: catalog,
    conversationRepository: conversations,
    startRun: orchestrator.start,
    idFactory: ids.next,
    now: () => _epoch.add(const Duration(minutes: 1)),
    checkpointInterval: const Duration(milliseconds: 20),
    environment: environment,
    onContextAssembled: onContextAssembled,
  );
}

Future<void> _seedCatalog(DriftAiCatalogRepository catalog) {
  return catalog.saveConnectionBundle(
    connection: AiProviderConnection(
      id: 'connection',
      providerId: 'openai',
      displayName: 'OpenAI',
      baseUri: Uri.parse('https://example.test/v1/'),
      credentialRef: 'credential',
    ),
    models: const [
      AiModelDefinition(
        id: 'model',
        connectionId: 'connection',
        displayName: 'Model',
        capabilities: AiModelCapabilities(streaming: true, toolCalling: true),
        limits: AiModelLimits(contextTokens: 4096),
      ),
    ],
    assistants: [
      AiAssistantProfile(
        id: 'assistant',
        name: 'Assistant',
        connectionId: 'connection',
        modelId: 'model',
        createdAt: _epoch,
        updatedAt: _epoch,
      ),
    ],
  );
}

final _epoch = DateTime.utc(2026, 9, 5);

/// 覆盖种子 assistant 的工具策略，用于按用例定制轮数预算。
Future<void> _useToolPolicy(
  DriftAiCatalogRepository catalog,
  AiToolPolicy toolPolicy,
) async {
  final assistant = await catalog.getAssistant('assistant');
  await catalog.saveAssistant(assistant!.copyWith(toolPolicy: toolPolicy));
}

class _IdFactory {
  var _value = 0;

  String next() => 'id-${_value++}';
}

class _CredentialStore implements AiCredentialStore {
  const _CredentialStore();

  @override
  Future<AiSecret?> read(String credentialRef) async => const AiSecret('key');

  @override
  Future<String> put(AiSecret secret, {String? credentialRef}) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String credentialRef) async {}
}

class _ControlledTransport implements AiTransport {
  final StreamController<List<int>> _body = StreamController<List<int>>();
  final Completer<void> sent = Completer<void>();
  bool _closed = false;

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    if (!sent.isCompleted) sent.complete();
    unawaited(
      cancellation.cancelled.then((_) async {
        if (_closed) return;
        _closed = true;
        _body.addError(
          const AiTransportException(
            AiFailure(
              code: AiFailureCode.cancelled,
              messageKey: 'ai.error.cancelled',
            ),
          ),
        );
        await _body.close();
      }),
    );
    return AiTransportResponse(
      statusCode: 200,
      headers: const {},
      body: _body.stream,
    );
  }

  void addChatDelta(String text) {
    final payload = jsonEncode({
      'choices': [
        {
          'delta': {'content': text},
          'finish_reason': null,
        },
      ],
    });
    _body.add(utf8.encode('data: $payload\n\n'));
  }

  Future<void> complete() async {
    if (_closed) return;
    _closed = true;
    _body.add(utf8.encode('data: [DONE]\n\n'));
    await _body.close();
  }
}

class _ScriptedToolTransport implements AiTransport {
  final List<PreparedAiRequest> requests = [];

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    requests.add(request);
    final event = requests.length == 1
        ? {
            'choices': [
              {
                'delta': {
                  'tool_calls': [
                    {
                      'index': 0,
                      'id': 'call-1',
                      'function': {'name': 'get_manifest', 'arguments': '{}'},
                    },
                  ],
                },
                'finish_reason': 'tool_calls',
              },
            ],
          }
        : {
            'choices': [
              {
                'delta': {'content': 'analysis complete'},
                'finish_reason': 'stop',
              },
            ],
          };
    final body = utf8.encode('data: ${jsonEncode(event)}\n\ndata: [DONE]\n\n');
    return AiTransportResponse(
      statusCode: 200,
      headers: const {},
      body: Stream.value(body),
    );
  }
}

class _CancelThenTextTransport implements AiTransport {
  final List<PreparedAiRequest> requests = [];
  final StreamController<List<int>> _firstBody = StreamController<List<int>>();
  final Completer<void> sent = Completer<void>();

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    requests.add(request);
    if (requests.length == 1) {
      if (!sent.isCompleted) sent.complete();
      unawaited(
        cancellation.cancelled.then((_) {
          _firstBody.addError(
            const AiTransportException(
              AiFailure(
                code: AiFailureCode.cancelled,
                messageKey: 'ai.error.cancelled',
              ),
            ),
          );
          _firstBody.close();
        }),
      );
      return AiTransportResponse(
        statusCode: 200,
        headers: const {},
        body: _firstBody.stream,
      );
    }
    // 第二轮起：模拟模型基于“继续”指令返回接续内容。
    final event = {
      'choices': [
        {
          'delta': {'content': 'resumed answer'},
          'finish_reason': 'stop',
        },
      ],
    };
    return AiTransportResponse(
      statusCode: 200,
      headers: const {},
      body: Stream.value(
        utf8.encode('data: ${jsonEncode(event)}\n\ndata: [DONE]\n\n'),
      ),
    );
  }
}

class _TextTransport implements AiTransport {
  _TextTransport(this.responses);

  final List<String> responses;
  var _index = 0;

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    final text = responses[_index++];
    final event = {
      'choices': [
        {
          'delta': {'content': text},
          'finish_reason': 'stop',
        },
      ],
    };
    return AiTransportResponse(
      statusCode: 200,
      headers: const {},
      body: Stream.value(
        utf8.encode('data: ${jsonEncode(event)}\n\ndata: [DONE]\n\n'),
      ),
    );
  }
}

class _FakeToolExecutor implements AiToolExecutor {
  const _FakeToolExecutor();

  @override
  Future<AiToolResult> execute(
    AiToolCall call, {
    AiToolProgress? onProgress,
  }) async {
    return AiToolResult(
      toolCallId: call.id,
      name: call.name,
      success: true,
      content: 'manifest-data',
    );
  }
}

class _ThrowingToolExecutor implements AiToolExecutor {
  const _ThrowingToolExecutor();

  @override
  Future<AiToolResult> execute(
    AiToolCall call, {
    AiToolProgress? onProgress,
  }) async {
    throw StateError('boom');
  }
}

class _FlakyToolExecutor implements AiToolExecutor {
  var calls = 0;

  @override
  Future<AiToolResult> execute(
    AiToolCall call, {
    AiToolProgress? onProgress,
  }) async {
    calls++;
    if (calls == 1) {
      throw StateError('temporary boom');
    }
    return AiToolResult(
      toolCallId: call.id,
      name: call.name,
      success: true,
      content: 'manifest-data-after-retry',
    );
  }
}

/// 复现线上异常数据流：tool_calls 以分片形式送达，后续分片 id 为 null、
/// name 为空字符串，arguments 分多次累积为 `"keyword": "v"ip"`——既不是
/// 合法 JSON，也无法通过补外层大括号等保守修复手段还原（`"v"` 后跟
/// 悬空的 `ip"`），用于验证兜底重试路径。
class _SseFragmentedToolTransport implements AiTransport {
  final List<PreparedAiRequest> requests = [];

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    requests.add(request);
    if (requests.length == 1) {
      final chunks = <Map<String, Object?>>[
        {
          'choices': [
            {
              'delta': {
                'tool_calls': [
                  {
                    'index': 0,
                    'id': 'call-1',
                    'type': 'function',
                    'function': {'name': 'get_manifest', 'arguments': ''},
                  },
                ],
              },
              'finish_reason': null,
            },
          ],
        },
        {
          'choices': [
            {
              'delta': {
                'tool_calls': [
                  {
                    'index': 0,
                    'id': null,
                    'type': null,
                    'function': {'name': '', 'arguments': '"keyword": "v"'},
                  },
                ],
              },
              'finish_reason': null,
            },
          ],
        },
        {
          'choices': [
            {
              'delta': {
                'tool_calls': [
                  {
                    'index': 0,
                    'id': null,
                    'type': null,
                    'function': {'name': '', 'arguments': 'ip"'},
                  },
                ],
              },
              'finish_reason': null,
            },
          ],
        },
        {
          'choices': [
            {
              'delta': {'content': null},
              'finish_reason': 'tool_calls',
            },
          ],
        },
      ];
      final body = chunks
          .map((chunk) => 'data: ${jsonEncode(chunk)}\n\n')
          .join('');
      return AiTransportResponse(
        statusCode: 200,
        headers: const {},
        body: Stream.value(utf8.encode('$body data: [DONE]\n\n')),
      );
    }
    final event = {
      'choices': [
        {
          'delta': {'content': 'analysis complete'},
          'finish_reason': 'stop',
        },
      ],
    };
    return AiTransportResponse(
      statusCode: 200,
      headers: const {},
      body: Stream.value(
        utf8.encode('data: ${jsonEncode(event)}\n\ndata: [DONE]\n\n'),
      ),
    );
  }
}

/// 在第 [failOnAttempt] 次 saveMessage 调用时抛出一次异常，其余透传，
/// 用于模拟工具调用链路中途的持久化故障。
class _FailingSaveMessageRepository implements AiConversationRepository {
  _FailingSaveMessageRepository(this._inner, {required this.failOnAttempt});

  final AiConversationRepository _inner;
  final int failOnAttempt;
  var _saveAttempts = 0;
  var _failedOnce = false;

  @override
  Future<void> saveMessage(AiMessage message) async {
    _saveAttempts++;
    if (!_failedOnce && _saveAttempts >= failOnAttempt) {
      _failedOnce = true;
      throw StateError('db write failed');
    }
    return _inner.saveMessage(message);
  }

  @override
  Future<AiConversation?> getConversation(String id) =>
      _inner.getConversation(id);

  @override
  Future<List<AiMessage>> getMessages(
    String conversationId, {
    AiMessageCursor? before,
    int limit = 50,
  }) => _inner.getMessages(conversationId, before: before, limit: limit);

  @override
  Future<void> saveConversation(AiConversation conversation) =>
      _inner.saveConversation(conversation);

  @override
  Future<List<AiConversation>> getConversations({
    AiConversationCursor? before,
    int limit = 30,
  }) => _inner.getConversations(before: before, limit: limit);

  @override
  Future<void> deleteConversation(String id) => _inner.deleteConversation(id);

  @override
  Future<void> saveMessages(List<AiMessage> messages) =>
      _inner.saveMessages(messages);

  @override
  Future<void> deleteMessagesAfter(String conversationId, DateTime createdAt) =>
      _inner.deleteMessagesAfter(conversationId, createdAt);

  @override
  Future<void> deleteMessagesById(
    String conversationId,
    Iterable<String> ids,
  ) => _inner.deleteMessagesById(conversationId, ids);

  @override
  Future<AiChatSessionContext?> getConversationContext(String conversationId) =>
      _inner.getConversationContext(conversationId);

  @override
  Future<void> saveConversationContext(
    String conversationId,
    AiChatSessionContext context,
  ) => _inner.saveConversationContext(conversationId, context);
}

/// 记录型工具执行器：不执行任何真实逻辑，仅记录收到的调用供断言。
class _RecordingToolExecutor implements AiToolExecutor {
  final calls = <AiToolCall>[];

  @override
  Future<AiToolResult> execute(
    AiToolCall call, {
    AiToolProgress? onProgress,
  }) async {
    calls.add(call);
    return AiToolResult(
      toolCallId: call.id,
      name: call.name,
      success: true,
      content: 'executed:${call.name}',
    );
  }
}

/// 按 [_outcomes] 依次返回成功/失败的工具执行结果，越界后一律成功。
class _SequenceToolExecutor implements AiToolExecutor {
  _SequenceToolExecutor(this._outcomes);

  final List<bool> _outcomes;
  var calls = 0;

  @override
  Future<AiToolResult> execute(
    AiToolCall call, {
    AiToolProgress? onProgress,
  }) async {
    final success = calls < _outcomes.length ? _outcomes[calls] : true;
    calls++;
    return AiToolResult(
      toolCallId: call.id,
      name: call.name,
      success: success,
      content: success ? 'manifest-data' : 'tool exploded',
    );
  }
}

/// 模拟“工具上瘾”的模型：请求携带工具定义时永远再请求一次工具；
/// 不携带时返回文本总结收尾。`violateNoToolsRound` 为 true 时即使
/// 不携带工具定义也违规返回工具调用（模拟不遵守协议的网关），
/// 用于验证预算耗尽后的兜底行为。
class _ToolLovingTransport implements AiTransport {
  _ToolLovingTransport({this.violateNoToolsRound = false});

  final bool violateNoToolsRound;
  final requests = <PreparedAiRequest>[];

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    requests.add(request);
    final tools = request.body['tools'];
    final hasTools = tools is List && tools.isNotEmpty;
    final chunks = hasTools || violateNoToolsRound
        ? [
            _toolCallChunk(
              index: 0,
              id: 'call-${requests.length}',
              name: 'get_manifest',
              arguments: '{}',
            ),
            _finishToolCallsChunk(),
          ]
        : [_textChunk('budget summary')];
    final body =
        '${chunks.map((chunk) => 'data: ${jsonEncode(chunk)}\n\n').join()}'
        'data: [DONE]\n\n';
    return AiTransportResponse(
      statusCode: 200,
      headers: const {},
      body: Stream.value(utf8.encode(body)),
    );
  }
}

/// 可脚本化的 SSE transport：第 N 轮请求返回第 N 组预置分片。
class _SseScriptTransport implements AiTransport {
  _SseScriptTransport(this._rounds);

  final List<List<Map<String, Object?>>> _rounds;
  final requests = <PreparedAiRequest>[];

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    requests.add(request);
    final roundIndex = (requests.length - 1).clamp(0, _rounds.length - 1);
    final chunks = _rounds[roundIndex];
    final body =
        '${chunks.map((chunk) => 'data: ${jsonEncode(chunk)}\n\n').join()}'
        'data: [DONE]\n\n';
    return AiTransportResponse(
      statusCode: 200,
      headers: const {},
      body: Stream.value(utf8.encode(body)),
    );
  }
}

/// 构造 tool_calls 分片（模拟 DeepSeek 流式 delta）。
Map<String, Object?> _toolCallChunk({
  required int index,
  Object? id,
  String? name,
  String? arguments,
}) => {
  'choices': [
    {
      'delta': {
        'tool_calls': [
          {
            'index': index,
            'id': id,
            'type': id == null ? null : 'function',
            'function': {'name': name ?? '', 'arguments': arguments ?? ''},
          },
        ],
      },
      'finish_reason': null,
    },
  ],
};

Map<String, Object?> _finishToolCallsChunk() => {
  'choices': [
    {
      'delta': {'content': null},
      'finish_reason': 'tool_calls',
    },
  ],
};

Map<String, Object?> _textChunk(String text) => {
  'choices': [
    {
      'delta': {'content': text},
      'finish_reason': 'stop',
    },
  ],
};

Future<void> _waitUntil(bool Function() predicate) async {
  for (var attempt = 0; attempt < 50; attempt++) {
    if (predicate()) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('Condition was not reached before timeout');
}
