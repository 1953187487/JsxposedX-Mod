import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_context_builder.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_chat_context_memory_compactor.dart';

void main() {
  test(
    'uses a bounded recent-message context and drops orphan tool results',
    () {
      final messages = [
        for (var index = 0; index < 4; index++)
          AiMessage(
            id: 'message-$index',
            conversationId: 'conversation',
            role: AiMessageRole.user,
            parts: [
              AiContentPart.text('$index'),
              const AiContentPart.toolResult(
                toolResult: AiToolResult(
                  toolCallId: 'call',
                  name: 'tool',
                  success: true,
                  content: 'result',
                ),
              ),
            ],
            createdAt: _epoch.add(Duration(seconds: index)),
          ),
      ];
      final result = const AiChatContextBuilder().build(
      assistant: _assistant(
        contextPolicy: const AiContextPolicy(
          mode: AiContextMode.recentMessages,
          recentMessageLimit: 2,
          includeToolResults: false,
        ),
      ),
      model: _model(),
      messages: messages,
      idFactory: () => 'system',
      now: _epoch,
    );

    // 被裁剪的历史不再静默丢弃，而是以 [context_memory] 记忆消息注入。
    expect(result.first.parts.first, isA<AiTextPart>());
    expect(
      (result.first.parts.first as AiTextPart).text,
      startsWith(AiChatContextMemoryCompactor.memoryHeader),
    );
    expect(
      result.where((message) => message.role == AiMessageRole.user).map(
            (message) => message.id,
          ),
      ['message-2', 'message-3'],
    );
    expect(
      result.expand((message) => message.parts).whereType<AiToolResultPart>(),
      isEmpty,
    );
    },
  );

  test('uses user-role fallback when a model has no system role', () {
    final result = const AiChatContextBuilder().build(
      assistant: _assistant(systemPrompt: 'instructions'),
      model: _model(systemRole: false),
      messages: [_message('message')],
      idFactory: () => 'prompt',
      now: _epoch,
    );

    expect(result.first.id, 'prompt');
    expect(result.first.role, AiMessageRole.user);
    expect((result.first.parts.single as AiTextPart).text, 'instructions');
  });

  test('keeps the recent minimum when the token budget is exceeded', () {
    final result = AiChatContextBuilder(tokenEstimator: const _FixedEstimator())
        .build(
          assistant: _assistant(
            contextPolicy: const AiContextPolicy(
              reservedOutputTokens: 10,
              recentMessageMinimum: 2,
            ),
          ),
          model: _model(contextTokens: 20),
          messages: [_message('one'), _message('two'), _message('three')],
          idFactory: () => 'unused',
          now: _epoch,
        );

    // 预算失效（协议开销吞满预算）时，minimum 兜底：保留最近两条
    // 而不是只剩一条，被裁掉的 one 以记忆消息注入。
    expect(
      result.where((message) => message.role == AiMessageRole.user).map(
            (message) => message.id,
          ),
      ['two', 'three'],
    );
    expect(
      result.first.parts.whereType<AiTextPart>().first.text,
      startsWith(AiChatContextMemoryCompactor.memoryHeader),
    );
  });

  test('keeps Responses function calls paired with their results', () {
    final call = AiMessage(
      id: 'assistant-call',
      conversationId: 'conversation',
      role: AiMessageRole.assistant,
      parts: const [
        AiContentPart.toolCall(
          toolCall: AiToolCall(id: 'fc_1', name: 'inspect', arguments: {}),
        ),
      ],
      createdAt: _epoch,
    );
    final resultMessage = AiMessage(
      id: 'tool-result',
      conversationId: 'conversation',
      role: AiMessageRole.tool,
      parts: const [
        AiContentPart.toolResult(
          toolResult: AiToolResult(
            toolCallId: 'fc_1',
            name: 'inspect',
            success: true,
            content: 'ok',
          ),
        ),
      ],
      createdAt: _epoch.add(const Duration(seconds: 1)),
    );
    final result = const AiChatContextBuilder().build(
      assistant: _assistant(
        contextPolicy: const AiContextPolicy(
          mode: AiContextMode.recentMessages,
          recentMessageLimit: 1,
        ),
      ),
      model: _model(),
      messages: [call, resultMessage],
      idFactory: () => 'unused',
      now: _epoch,
    );

    expect(result.map((message) => message.id), [
      'assistant-call',
      'tool-result',
    ]);
  });

  test('drops incomplete calls from a multi-call assistant turn', () {
    final assistantCall = AiMessage(
      id: 'assistant-call',
      conversationId: 'conversation',
      role: AiMessageRole.assistant,
      parts: const [
        AiContentPart.toolCall(
          toolCall: AiToolCall(
            id: 'fc_complete',
            name: 'inspect',
            arguments: {},
          ),
        ),
        AiContentPart.toolCall(
          toolCall: AiToolCall(id: 'fc_missing', name: 'search', arguments: {}),
        ),
      ],
      createdAt: _epoch,
    );
    final resultMessage = AiMessage(
      id: 'tool-result',
      conversationId: 'conversation',
      role: AiMessageRole.tool,
      parts: const [
        AiContentPart.toolResult(
          toolResult: AiToolResult(
            toolCallId: 'fc_complete',
            name: 'inspect',
            success: true,
            content: 'ok',
          ),
        ),
      ],
      createdAt: _epoch.add(const Duration(seconds: 1)),
    );

    final result = const AiChatContextBuilder().build(
      assistant: _assistant(),
      model: _model(),
      messages: [assistantCall, resultMessage],
      idFactory: () => 'unused',
      now: _epoch,
    );

    final calls = result
        .expand((message) => message.parts)
        .whereType<AiToolCallPart>()
        .map((part) => part.toolCall.id);
    final outputs = result
        .expand((message) => message.parts)
        .whereType<AiToolResultPart>()
        .map((part) => part.toolResult.toolCallId);
    expect(calls, ['fc_complete']);
    expect(outputs, ['fc_complete']);
  });

  test('keeps a complete tool exchange even with a legacy false flag', () {
    final call = AiMessage(
      id: 'assistant-call',
      conversationId: 'conversation',
      role: AiMessageRole.assistant,
      parts: const [
        AiContentPart.toolCall(
          toolCall: AiToolCall(id: 'fc_1', name: 'inspect', arguments: {}),
        ),
      ],
      createdAt: _epoch,
    );
    final output = AiMessage(
      id: 'tool-result',
      conversationId: 'conversation',
      role: AiMessageRole.tool,
      parts: const [
        AiContentPart.toolResult(
          toolResult: AiToolResult(
            toolCallId: 'fc_1',
            name: 'inspect',
            success: true,
            content: 'ok',
          ),
        ),
      ],
      createdAt: _epoch.add(const Duration(seconds: 1)),
    );

    final result = const AiChatContextBuilder().build(
      assistant: _assistant(
        contextPolicy: const AiContextPolicy(includeToolResults: false),
      ),
      model: _model(),
      messages: [call, output],
      idFactory: () => 'unused',
      now: _epoch,
    );

    expect(
      result.expand((message) => message.parts).whereType<AiToolCallPart>(),
      hasLength(1),
    );
    expect(
      result.expand((message) => message.parts).whereType<AiToolResultPart>(),
      hasLength(1),
    );
  });

  test('reports the real token budget and compaction reason', () {
    final result = AiChatContextBuilder(tokenEstimator: const _FixedEstimator())
        .buildWithStats(
          assistant: _assistant(
            contextPolicy: const AiContextPolicy(reservedOutputTokens: 0),
          ),
          // 2048 protocol overhead + 16 message tokens.
          model: _model(contextTokens: 2064),
          messages: [_message('one'), _message('two'), _message('three')],
          idFactory: () => 'unused',
          now: _epoch,
        );

    expect(
      result.messages
          .where((message) => message.role == AiMessageRole.user)
          .map((message) => message.id),
      ['two', 'three'],
    );
    expect(result.stats.tokenBudget, 2064);
    // 记忆消息（8 token）+ 保留消息（16 token）。
    expect(result.stats.estimatedTokens, 24);
    expect(result.stats.remainingTokens, 2040);
    expect(result.stats.didCompact, isTrue);
    expect(result.stats.compactReason, 'budget');
    expect(result.stats.recentRoundsKept, 2);
    expect(result.stats.memoryEntryCount, 1);
    expect(result.stats.includedLayers, ['context_memory', 'token_budget']);
    // 被裁剪的 one 生成持久化记忆条目，供跨请求合并。
    expect(result.memoryEntries, hasLength(1));
  });

  test('reports every participating layer when nothing is trimmed', () {
    final call = AiMessage(
      id: 'assistant-call',
      conversationId: 'conversation',
      role: AiMessageRole.assistant,
      parts: const [
        AiContentPart.toolCall(
          toolCall: AiToolCall(id: 'fc_1', name: 'inspect', arguments: {}),
        ),
      ],
      createdAt: _epoch,
    );
    final output = AiMessage(
      id: 'tool-result',
      conversationId: 'conversation',
      role: AiMessageRole.tool,
      parts: const [
        AiContentPart.toolResult(
          toolResult: AiToolResult(
            toolCallId: 'fc_1',
            name: 'inspect',
            success: true,
            content: 'ok',
          ),
        ),
      ],
      createdAt: _epoch.add(const Duration(seconds: 1)),
    );

    final result = const AiChatContextBuilder().buildWithStats(
      assistant: _assistant(
        systemPrompt: 'instructions',
        contextPolicy: const AiContextPolicy(mode: AiContextMode.fullHistory),
      ),
      model: _model(contextTokens: 100000),
      messages: [call, output],
      idFactory: () => 'prompt',
      now: _epoch,
    );

    expect(result.stats.didCompact, isFalse);
    expect(result.stats.compactReason, isNull);
    expect(result.stats.repairedToolContext, isFalse);
    expect(result.stats.tokenBudget, 100000);
    expect(
      result.stats.estimatedTokens,
      lessThanOrEqualTo(result.stats.tokenBudget),
    );
    expect(
      result.stats.remainingTokens,
      result.stats.tokenBudget - result.stats.estimatedTokens,
    );
    expect(result.stats.includedLayers, [
      'system_prompt',
      'full_history',
      'tool_context',
    ]);
  });

  test('flags recent-message trimming without a budget reason', () {
    final result = const AiChatContextBuilder().buildWithStats(
      assistant: _assistant(
        contextPolicy: const AiContextPolicy(
          mode: AiContextMode.recentMessages,
          recentMessageLimit: 1,
        ),
      ),
      model: _model(),
      messages: [_message('one'), _message('two'), _message('three')],
      idFactory: () => 'unused',
      now: _epoch,
    );

    expect(result.stats.didCompact, isTrue);
    expect(result.stats.compactReason, isNull);
    expect(result.stats.recentRoundsKept, 1);
    expect(result.stats.includedLayers, ['context_memory', 'recent_messages']);
  });

  test('flags a repaired tool context when pairing restores a call', () {
    final call = AiMessage(
      id: 'assistant-call',
      conversationId: 'conversation',
      role: AiMessageRole.assistant,
      parts: const [
        AiContentPart.toolCall(
          toolCall: AiToolCall(id: 'fc_1', name: 'inspect', arguments: {}),
        ),
      ],
      createdAt: _epoch,
    );
    final output = AiMessage(
      id: 'tool-result',
      conversationId: 'conversation',
      role: AiMessageRole.tool,
      parts: const [
        AiContentPart.toolResult(
          toolResult: AiToolResult(
            toolCallId: 'fc_1',
            name: 'inspect',
            success: true,
            content: 'ok',
          ),
        ),
      ],
      createdAt: _epoch.add(const Duration(seconds: 1)),
    );

    final result = const AiChatContextBuilder().buildWithStats(
      assistant: _assistant(
        contextPolicy: const AiContextPolicy(
          mode: AiContextMode.recentMessages,
          recentMessageLimit: 1,
        ),
      ),
      model: _model(),
      messages: [call, output],
      idFactory: () => 'unused',
      now: _epoch,
    );

    expect(result.messages.map((message) => message.id), [
      'assistant-call',
      'tool-result',
    ]);
    expect(result.stats.repairedToolContext, isTrue);
    expect(result.stats.didCompact, isFalse);
  });

  test('exposes the composed system prompt it actually sends', () {
    final result = const AiChatContextBuilder().buildWithStats(
      assistant: _assistant(systemPrompt: 'profile rules'),
      model: _model(),
      messages: [_message('one')],
      idFactory: () => 'prompt',
      now: _epoch,
      environmentSystemPrompt: 'environment rules',
    );

    expect(result.systemPrompt, 'environment rules\n\nprofile rules');
  });

  test('reports an empty system prompt when no rules are configured', () {
    final result = const AiChatContextBuilder().buildWithStats(
      assistant: _assistant(),
      model: _model(),
      messages: [_message('one')],
      idFactory: () => 'prompt',
      now: _epoch,
    );

    expect(result.systemPrompt, isEmpty);
  });
}

AiAssistantProfile _assistant({
  String? systemPrompt,
  AiContextPolicy contextPolicy = const AiContextPolicy(),
}) {
  return AiAssistantProfile(
    id: 'assistant',
    name: 'Assistant',
    connectionId: 'connection',
    modelId: 'model',
    systemPrompt: systemPrompt,
    contextPolicy: contextPolicy,
    createdAt: _epoch,
    updatedAt: _epoch,
  );
}

AiModelDefinition _model({bool systemRole = true, int? contextTokens}) {
  return AiModelDefinition(
    id: 'model',
    connectionId: 'connection',
    displayName: 'Model',
    capabilities: AiModelCapabilities(systemRole: systemRole),
    limits: AiModelLimits(contextTokens: contextTokens),
  );
}

AiMessage _message(String id) => AiMessage(
  id: id,
  conversationId: 'conversation',
  role: AiMessageRole.user,
  parts: [AiContentPart.text(id)],
  createdAt: _epoch,
);

final _epoch = DateTime.utc(2026, 9, 5);

class _FixedEstimator implements AiTokenEstimator {
  const _FixedEstimator();

  @override
  int estimate(AiMessage message) => 8;
}
