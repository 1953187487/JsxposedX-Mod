import 'dart:async';
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_context_builder.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_orchestrator.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_environment.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_controller.dart';
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
import 'package:JsxposedX/features/ai/domain/services/ai_chat_context_memory_compactor.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_chat_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart'
    hide
        AiAssistantProfile,
        AiConversation,
        AiModelDefinition,
        AiProviderConnection;

/// 多场景上下文记忆回归测试：模拟 10+ 类的连续逆向分析流程，验证
/// 预算裁剪 / 高水位压缩 / 重启分页窗口外历史都不会丢失"已分析类"
/// 的记录，模型收到的每个请求始终能看到全部已分析类（防重复分析）。
///
/// Builder 场景用 12 个类；Controller 端到端用 26 个类（54 条消息，
/// 超过 50 条分页阈值），复现"重启后分页窗口外历史不可见"的原始
/// 缺陷场景并验证持久化记忆回流。
void main() {
  final builderClasses = _classSet(12);

  group('AiChatContextBuilder 连续类分析防重复回归', () {
    test('token 预算裁剪后每个已分析类仍在请求中可见且不重复', () {
      // 无高水位（占比 0.71 < 0.75），由硬预算裁掉最早的 ~5 个类。
      final result = const AiChatContextBuilder().buildWithStats(
        assistant: _assistant(),
        model: _model(contextTokens: 5376),
        messages: _analysisHistory(),
        idFactory: _counter(),
        now: _epoch,
      );

      expect(result.stats.didCompact, isTrue);
      expect(result.stats.compactReason, 'budget');
      expect(result.stats.highWatermarkReached, isFalse);
      expect(result.stats.memoryEntryCount, greaterThan(0));

      // 核心不变量：窗口内工具调用 ∪ 记忆消息 == 全部 12 个类；
      // 两者交集为空（同一类绝不同时以"完整往返 + 摘要"两种身份出现，
      // 模型也不会看到重复内容而误判需要重新分析）。
      final memoryText = _memoryText(result.messages);
      expect(memoryText, isNotNull);
      final windowClasses = _windowClasses(result.messages);
      final memoryClasses = _classNames(memoryText!);
      expect(windowClasses.intersection(memoryClasses), isEmpty);
      expect(windowClasses.union(memoryClasses), containsAll(builderClasses));
      expect(result.stats.estimatedTokens, lessThanOrEqualTo(result.stats.tokenBudget));
    });

    test('高水位触发预防性压缩且压缩后占用回到水位线以下', () {
      // 历史全量占 0.93 ≥ 0.75：高水位收紧预算，提前裁剪 + 记忆补偿。
      final result = const AiChatContextBuilder().buildWithStats(
        assistant: _assistant(),
        model: _model(contextTokens: 4096),
        messages: _analysisHistory(),
        idFactory: _counter(),
        now: _epoch,
      );

      expect(result.stats.highWatermarkReached, isTrue);
      expect(result.stats.usageRatio, lessThan(0.75));
      expect(result.stats.memoryEntryCount, greaterThan(0));
      final memoryText = _memoryText(result.messages);
      expect(memoryText, isNotNull);
      final windowClasses = _windowClasses(result.messages);
      final memoryClasses = _classNames(memoryText!);
      expect(windowClasses.intersection(memoryClasses), isEmpty);
      expect(windowClasses.union(memoryClasses), containsAll(builderClasses));
      expect(result.stats.estimatedTokens, lessThanOrEqualTo(result.stats.tokenBudget));
    });

    test('条数策略下高水位压缩上报 watermark 原因', () {
      final result = const AiChatContextBuilder().buildWithStats(
        assistant: _assistant(
          contextPolicy: const AiContextPolicy(
            mode: AiContextMode.recentMessages,
            recentMessageLimit: 15,
          ),
        ),
        model: _model(contextTokens: 4096),
        messages: _analysisHistory(),
        idFactory: _counter(),
        now: _epoch,
      );

      expect(result.stats.didCompact, isTrue);
      expect(result.stats.highWatermarkReached, isTrue);
      expect(result.stats.compactReason, 'watermark');
      final memoryText = _memoryText(result.messages);
      expect(memoryText, isNotNull);
      expect(
        _windowClasses(result.messages).union(_classNames(memoryText!)),
        containsAll(builderClasses),
      );
    });

    test('重启后仅加载近期历史时持久化记忆回流覆盖早期类', () {
      // 第一阶段：完整历史组装，产出持久化记忆条目（快照落盘语义）。
      final first = const AiChatContextBuilder().buildWithStats(
        assistant: _assistant(),
        model: _model(contextTokens: 4096),
        messages: _analysisHistory(),
        idFactory: _counter(),
        now: _epoch,
      );
      final persistedClasses = {
        for (final entry in first.memoryEntries)
          ..._classNames(entry),
      };
      // 首轮记忆条目已覆盖被裁出窗口的早期类（预算 768 仅保留 ~2 个类）。
      expect(persistedClasses, hasLength(greaterThan(6)));

      // 第二阶段：模拟重启 + 分页只加载最近 10 条消息（类 8~11 的尾部），
      // 早期类既不在窗口也不在加载历史中，只能依赖持久化记忆回流。
      final fullHistory = _analysisHistory();
      final restartedHistory = fullHistory.sublist(fullHistory.length - 10);
      final second = const AiChatContextBuilder().buildWithStats(
        assistant: _assistant(),
        model: _model(contextTokens: 4096),
        messages: restartedHistory,
        idFactory: _counter(),
        now: _epoch,
        persistedMemory: first.memoryEntries,
      );

      final memoryText = _memoryText(second.messages);
      expect(memoryText, isNotNull);
      final memoryClasses = _classNames(memoryText!);
      // 加载窗口之外的早期类（0~7）全部由持久化记忆带回请求。
      final earlyClasses = {
        for (var index = 0; index < 8; index++) _className(index),
      };
      expect(memoryClasses, containsAll(earlyClasses));
      // 条目语义：memoryEntries 只含被裁出窗口的历史摘要（窗口内的类
      // 仍以完整往返呈现），合并去重后与窗口恰好覆盖全部 12 个类。
      final mergedClasses = {
        for (final entry in second.memoryEntries) ..._classNames(entry),
      };
      expect(mergedClasses, containsAll(earlyClasses));
      expect(
        _windowClasses(second.messages).union(mergedClasses),
        builderClasses,
      );
    });
  });

  group('AiChatSessionController 26 类连续逆向分析端到端', () {
    const classCount = 26;
    final allClasses = _classSet(classCount);

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

    test('26 轮工具分析的每个请求都完整可见已分析类，重启后记忆回流', () async {
      // 26 轮工具调用超过默认轮数预算 24，显式放宽到上限 32。
      final assistant = await catalog.getAssistant('assistant');
      await catalog.saveAssistant(
        assistant!.copyWith(
          toolPolicy: assistant.toolPolicy.copyWith(maxRounds: 32),
        ),
      );

      final executor = _SmaliToolExecutor();
      final environment = _environment(executor);
      // 脚本模型：第 i 轮请求 analyze_class(ClassII)，最后一轮文本收尾。
      final transport = _ScriptedSseTransport([
        for (var index = 0; index < classCount; index++)
          [
            _toolCallChunk(
              index: 0,
              id: 'call-$index',
              name: 'analyze_class',
              arguments: jsonEncode({'className': _className(index)}),
            ),
            _finishToolCallsChunk(),
          ],
        [_textChunk('vip analysis complete')],
      ]);
      final contexts = <AiChatSessionContext>[];
      final controller = _controller(
        catalog,
        conversations,
        transport,
        environment: environment,
        onContextAssembled: (_, context) => contexts.add(context),
      );

      await controller.initialize();
      await controller.sendText('hook vip logic, analyze all vip related classes');

      // 26 轮工具调用全部执行，且类名按序推进（脚本模型不回溯）。
      expect(executor.calls, hasLength(classCount));
      expect(
        executor.calls.map((call) => call.arguments['className']),
        [for (var index = 0; index < classCount; index++) _className(index)],
      );
      expect(transport.requests, hasLength(classCount + 1));
      // 默认分页只取最新 50 条，显式放宽以核验全量落盘条数。
      final stored = await conversations.getMessages('conversation', limit: 100);
      // 1 条用户消息 + 26 组（调用 + 结果）+ 1 条最终回答 = 54 条，
      // 超过 50 条分页阈值：重启后最早的 4 条（用户消息 + 类 0 往返 +
      // 类 1 的调用）落在分页窗口之外。
      expect(stored, hasLength(1 + classCount * 2 + 1));
      expect(
        stored.last.parts.whereType<AiTextPart>().single.text,
        'vip analysis complete',
      );

      // 核心不变量（逐请求）：对第 k 个请求（k ≥ 1），此前的 k 个类
      // 分析要么以完整工具往返在窗口中，要么以 [context_memory] 摘要
      // 注入；两类呈现互斥，杜绝"窗口丢失 + 记忆缺失 → 重复分析"。
      for (var requestIndex = 1; requestIndex <= classCount; requestIndex++) {
        final request = transport.requests[requestIndex];
        final messages = request.body['messages'] as List;
        final windowClasses = _requestWindowClasses(messages);
        final memoryText = _requestMemoryText(messages);
        final memoryClasses = _classNames(memoryText ?? '');
        expect(
          windowClasses.toSet().intersection(memoryClasses),
          isEmpty,
          reason: 'request $requestIndex 在窗口与记忆中重复呈现同一类',
        );
        final analyzedSoFar = {
          for (var index = 0; index < requestIndex; index++) _className(index),
        };
        expect(
          windowClasses.toSet().union(memoryClasses).containsAll(analyzedSoFar),
          isTrue,
          reason: 'request $requestIndex 丢失了已分析类',
        );
        // 同一请求内没有任何类被以工具调用形式回放两次。
        expect(windowClasses.length, windowClasses.toSet().length,
            reason: 'request $requestIndex 窗口内重复回放同类调用');
        // 窗口开始裁剪后（预算 ~1024 约保留 3 个类），记忆消息必须出现。
        if (requestIndex >= 7) {
          expect(memoryText, isNotNull,
              reason: 'request $requestIndex 已发生裁剪但缺少记忆补偿');
        }
      }

      // 高水位监控：26 类后历史占模型上下文 1.8 倍，最终统计触发水位
      // 告警，且压缩后的请求占用回到水位线以下（不超模型上限）。
      final lastStats = contexts.last.stats;
      expect(lastStats.highWatermarkReached, isTrue);
      expect(lastStats.usageRatio, lessThan(0.75));
      expect(lastStats.estimatedTokens, lessThanOrEqualTo(lastStats.tokenBudget));
      await controller.close();

      // 持久化快照保存了被裁出窗口的类分析记忆条目（含即将落在分页
      // 窗口之外的类 0 / 类 1）。
      final snapshot = await conversations.getConversationContext(
        'conversation',
      );
      final persistedEntries = snapshot?.sessionMemory.memoryEntries
          .where((entry) => entry.contains('com.vip.Class'))
          .toList();
      expect(
        persistedEntries,
        hasLength(greaterThanOrEqualTo(classCount - 4)),
        reason: '快照记忆条目不足以覆盖分页窗口外的已分析类',
      );
      expect(
        persistedEntries,
        containsAll(<String>[
          'analyze_class(className=${_className(0)})',
          'analyze_class(className=${_className(1)})',
        ]),
      );

      // 重启：新控制器只从快照恢复记忆。分页只加载最近 50 条消息，
      // 类 0（整组往返）与类 1（调用消息）不可见——只有持久化记忆
      // 能把它们带回请求，模型据此不会重复分析任何已处理类。
      final restartTransport = _ScriptedSseTransport([
        [_textChunk('next step done')],
      ]);
      final restartContexts = <AiChatSessionContext>[];
      final restarted = _controller(
        catalog,
        conversations,
        restartTransport,
        environment: environment,
        onContextAssembled: (_, context) => restartContexts.add(context),
      );
      await restarted.initialize();
      await restarted.sendText('generate the hook script');
      await restarted.close();

      expect(restartTransport.requests, hasLength(1));
      final restartMessages =
          restartTransport.requests.single.body['messages'] as List;
      final restartMemoryText = _requestMemoryText(restartMessages);
      expect(restartMemoryText, isNotNull,
          reason: '重启后首个请求缺少 [context_memory] 记忆消息');
      final restartMemoryClasses = _classNames(restartMemoryText!);
      // 分页窗口外的类 0 / 类 1 只能来自持久化记忆回流。
      expect(
        restartMemoryClasses,
        containsAll([_className(0), _className(1)]),
        reason: '重启后分页窗口外的已分析类未被持久化记忆带回',
      );
      // 窗口 ∪ 记忆 == 全部 26 个类：不丢、不重。
      final restartWindow = _requestWindowClasses(restartMessages).toSet();
      expect(restartWindow.union(restartMemoryClasses), allClasses);
      expect(restartContexts.last.stats.memoryEntryCount,
          greaterThanOrEqualTo(classCount - 6));
    });
  });
}

// ---------------------------------------------------------------------------
// 共享测试数据与提取工具
// ---------------------------------------------------------------------------

final _epoch = DateTime.utc(2026, 9, 5);

// Controller 场景的全局单调时钟（秒），跨控制器实例共享，
// 保证重启控制器写入的消息晚于第一阶段的全部消息。
var _clockValue = 0;

String _className(int index) =>
    'com.vip.Class${index.toString().padLeft(2, '0')}';

Set<String> _classSet(int count) => {
      for (var index = 0; index < count; index++) _className(index),
    };

final RegExp _classPattern = RegExp(r'com\.vip\.Class\d{2}');

Set<String> _classNames(String text) =>
    _classPattern.allMatches(text).map((match) => match[0]!).toSet();

/// 模拟 12 个类被连续分析后的完整历史：用户目标 + 每类
/// （工具调用 → 735 字符 smali 结果 → 结论）。
List<AiMessage> _analysisHistory() {
  final messages = <AiMessage>[
    AiMessage(
      id: 'user-goal',
      conversationId: 'conversation',
      role: AiMessageRole.user,
      parts: [AiContentPart.text('hook vip logic, analyze all vip related classes')],
      createdAt: _epoch,
    ),
    for (var index = 0; index < 12; index++) ...[
      AiMessage(
        id: 'call-$index',
        conversationId: 'conversation',
        role: AiMessageRole.assistant,
        parts: [
          AiContentPart.toolCall(
            toolCall: AiToolCall(
              id: 'call-$index',
              name: 'analyze_class',
              arguments: {'className': _className(index)},
            ),
          ),
        ],
        createdAt: _epoch.add(Duration(seconds: index * 3)),
      ),
      AiMessage(
        id: 'result-$index',
        conversationId: 'conversation',
        role: AiMessageRole.tool,
        parts: [
          AiContentPart.toolResult(
            toolResult: AiToolResult(
              toolCallId: 'call-$index',
              name: 'analyze_class',
              success: true,
              content: _smaliResult,
            ),
          ),
        ],
        createdAt: _epoch.add(Duration(seconds: index * 3 + 1)),
      ),
      AiMessage(
        id: 'conclusion-$index',
        conversationId: 'conversation',
        role: AiMessageRole.assistant,
        parts: [
          // 结论不含类名：类名只能来自工具调用参数与记忆条目，
          // 保证可见性断言互斥语义精确。
          AiContentPart.text('hook point confirmed: isVip() returns constant true'),
        ],
        createdAt: _epoch.add(Duration(seconds: index * 3 + 2)),
      ),
    ],
  ];
  return messages;
}

/// 735 字符 smali 片段：大到足以在 4096 上下文内触发水位与裁剪，
/// 且不含类名（类名可见性只经工具调用参数与记忆条目两条路径）。
const String _smaliResult =
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n'
    'method public isVip()Z const/4 v0, 0x1 return v0\n';

/// Builder 结果中窗口内的工具调用类名集合。
Set<String> _windowClasses(List<AiMessage> messages) => {
  for (final message in messages)
    for (final part in message.parts.whereType<AiToolCallPart>())
      ..._classNames(part.toolCall.arguments['className']?.toString() ?? ''),
};

/// Builder 结果中的 [context_memory] 记忆消息文本。
String? _memoryText(List<AiMessage> messages) {
  for (final message in messages) {
    final text = message.parts
        .whereType<AiTextPart>()
        .map((part) => part.text)
        .join();
    if (text.startsWith(AiChatContextMemoryCompactor.memoryHeader)) {
      return text;
    }
  }
  return null;
}

/// 请求 JSON 中窗口内工具调用的类名（按出现顺序，含重复以便去重断言）。
List<String> _requestWindowClasses(List<Object?> messages) => [
  for (final message in messages.whereType<Map>())
    if (message['tool_calls'] is List)
      for (final call in (message['tool_calls'] as List).whereType<Map>())
        ..._classNames(
          (call['function'] as Map?)?['arguments']?.toString() ?? '',
        ),
].toList();

/// 请求 JSON 中 [context_memory] 记忆消息文本。
String? _requestMemoryText(List<Object?> messages) {
  for (final message in messages.whereType<Map>()) {
    final content = message['content'];
    if (content is String &&
        content.startsWith(AiChatContextMemoryCompactor.memoryHeader)) {
      return content;
    }
  }
  return null;
}

int _counterValue = 0;

String Function() _counter() => () => 'generated-${_counterValue++}';

// ---------------------------------------------------------------------------
// Builder 场景桩
// ---------------------------------------------------------------------------

AiAssistantProfile _assistant({AiContextPolicy? contextPolicy}) {
  return AiAssistantProfile(
    id: 'assistant',
    name: 'Assistant',
    connectionId: 'connection',
    modelId: 'model',
    contextPolicy: contextPolicy ?? const AiContextPolicy(),
    createdAt: _epoch,
    updatedAt: _epoch,
  );
}

AiModelDefinition _model({int? contextTokens}) {
  return AiModelDefinition(
    id: 'model',
    connectionId: 'connection',
    displayName: 'Model',
    capabilities: const AiModelCapabilities(),
    limits: AiModelLimits(contextTokens: contextTokens),
  );
}

// ---------------------------------------------------------------------------
// Controller 场景桩
// ---------------------------------------------------------------------------

AiChatSessionEnvironment _environment(AiToolExecutor executor) {
  return AiChatSessionEnvironment(
    id: 'apk_reverse',
    scopeId: 'com.example.app',
    version: 'v2',
    systemPrompt: 'Reverse the vip logic in the APK.',
    tools: const [
      AiToolSpec(
        name: 'analyze_class',
        description: 'Analyze one class',
        inputSchema: {'type': 'object'},
      ),
    ],
    toolExecutor: executor,
  );
}

class _SmaliToolExecutor implements AiToolExecutor {
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
      content: _smaliResult,
    );
  }
}

/// 可脚本化 SSE transport：第 N 个请求回放第 N 组预置分片。
class _ScriptedSseTransport implements AiTransport {
  _ScriptedSseTransport(this._rounds);

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

AiChatSessionController _controller(
  DriftAiCatalogRepository catalog,
  AiConversationRepository conversations,
  AiTransport transport, {
  AiChatSessionEnvironment? environment,
  void Function(String conversationId, AiChatSessionContext context)?
  onContextAssembled,
}) {
  final ids = _IdFactory();
  // 单调时钟：drift 的 getMessages 按 createdAt DESC 排序，固定时间戳
  // 会让 id 字典序（'id-9' > 'id-54'）打乱消息顺序。计数器跨控制器
  // 共享，重启控制器的消息时间戳必须晚于既有消息。
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
    now: () => _epoch.add(Duration(seconds: _clockValue++)),
    checkpointInterval: const Duration(milliseconds: 20),
    environment: environment,
    onContextAssembled: onContextAssembled,
  );
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
