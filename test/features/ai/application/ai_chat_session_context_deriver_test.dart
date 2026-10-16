import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_context_deriver.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

void main() {
  const deriver = AiChatSessionContextDeriver();
  const stats = AiChatContextStats(tokenBudget: 4096, estimatedTokens: 40);

  test('derives goals, findings and a complete tool trace from real history',
      () {
    final context = deriver.derive(
      history: [
        _user('analyze target app'),
        _toolCall('fc_1', 'inspect', const {'path': '/tmp/app.apk'}),
        _toolResult('fc_1', 'inspect', success: true, content: 'classes found'),
      ],
      stats: stats,
      sessionRules: 'rules',
    );

    expect(context.sessionRules, 'rules');
    expect(context.stats, same(stats));
    expect(context.sessionMemory.userGoals, ['analyze target app']);
    expect(context.sessionMemory.toolFindings, ['inspect: classes found']);
    expect(context.taskState.lastUserGoal, 'analyze target app');
    expect(context.taskState.lastError, isNull);

    final trace = context.toolTrace;
    expect(trace.toolCallIds, ['fc_1']);
    expect(trace.resultSummaries['fc_1'], 'classes found');
    expect(trace.argumentSummaries['fc_1'], '{"path":"/tmp/app.apk"}');
    expect(trace.isComplete, isTrue);
    expect(trace.canReplay, isTrue);
    expect(trace.assistantToolCallMessage?.id, 'call-fc_1');
    expect(trace.hasPendingToolResults, isFalse);
  });

  test('flags a tool phase that still waits for its result', () {
    final context = deriver.derive(
      history: [_user('drop the hook'), _toolCall('fc_1', 'inspect', const {})],
      stats: stats,
      sessionRules: '',
    );

    expect(context.toolTrace.toolCallIds, ['fc_1']);
    expect(context.toolTrace.resultSummaries, isEmpty);
    expect(context.toolTrace.isComplete, isFalse);
    expect(context.toolTrace.canReplay, isFalse);
    expect(context.hasPendingToolPhase, isTrue);
  });

  test('reports the latest failed tool result as the current error', () {
    final context = deriver.derive(
      history: [
        _user('run the script'),
        _toolCall('fc_1', 'run', const {}),
        _toolResult('fc_1', 'run', success: false, content: 'boom  failed'),
      ],
      stats: stats,
      sessionRules: '',
    );

    expect(context.taskState.lastError, 'boom failed');
    expect(context.sessionMemory.toolFindings, isEmpty);
    // 失败结果同样构成一次完整往返，只有成功结果才进入记忆条目。
    expect(context.toolTrace.isComplete, isTrue);
  });

  test('drops a stale error once a later tool call succeeds', () {
    final context = deriver.derive(
      history: [
        _user('run the script'),
        _toolCall('fc_1', 'run', const {}),
        _toolResult('fc_1', 'run', success: false, content: 'boom'),
        _user('retry please'),
        _toolCall('fc_2', 'run', const {}),
        _toolResult('fc_2', 'run', success: true, content: 'ok'),
      ],
      stats: stats,
      sessionRules: '',
    );

    expect(context.taskState.lastError, isNull);
    expect(context.taskState.lastUserGoal, 'retry please');
    expect(context.toolTrace.toolCallIds, ['fc_2']);
  });

  test('ignores messages that are not completed', () {
    final context = deriver.derive(
      history: [
        _user('settled question'),
        _user('still streaming', status: AiMessageStatus.streaming),
      ],
      stats: stats,
      sessionRules: '',
    );

    expect(context.sessionMemory.userGoals, ['settled question']);
    expect(context.taskState.lastUserGoal, 'settled question');
  });

  test('leaves semantic fields it cannot derive empty', () {
    final context = deriver.derive(
      history: [_user('question')],
      stats: stats,
      sessionRules: '',
    );

    expect(context.sessionMemory.confirmedFacts, isEmpty);
    expect(context.sessionMemory.openHypotheses, isEmpty);
    expect(context.sessionMemory.blockers, isEmpty);
    expect(context.taskState.currentStep, isNull);
    expect(context.taskState.nextStep, isNull);
    expect(context.taskState.recentSuccessStep, isNull);
    expect(context.toolTrace.assistantToolCallMessage, isNull);
    expect(context.pinnedContext, isEmpty);
    expect(context.checkpoint, isNull);
    expect(context.recentMessages, isEmpty);
  });

  test('bounds memory entries and truncates long values', () {
    const bounded = AiChatSessionContextDeriver(
      maxMemoryEntries: 2,
      maxEntryCharacters: 5,
    );
    final context = bounded.derive(
      history: [
        _user('one'),
        _user('two'),
        _user('three'),
        _user('four'),
      ],
      stats: stats,
      sessionRules: '',
    );

    expect(context.sessionMemory.userGoals, ['three', 'four']);
  });

  test('collapses whitespace and truncates over-long entries with an ellipsis',
      () {
    const bounded = AiChatSessionContextDeriver(maxEntryCharacters: 5);
    final context = bounded.derive(
      history: [_user('alpha   beta\ngamma')],
      stats: stats,
      sessionRules: '',
    );

    expect(context.sessionMemory.userGoals, ['alpha…']);
  });
}

AiMessage _user(String text, {AiMessageStatus status = AiMessageStatus.completed}) {
  return AiMessage(
    id: 'user-$text',
    conversationId: 'conversation',
    role: AiMessageRole.user,
    parts: [AiContentPart.text(text)],
    status: status,
    createdAt: _epoch,
  );
}

AiMessage _toolCall(String id, String name, Map<String, dynamic> arguments) {
  return AiMessage(
    id: 'call-$id',
    conversationId: 'conversation',
    role: AiMessageRole.assistant,
    parts: [AiContentPart.toolCall(toolCall: AiToolCall(id: id, name: name, arguments: arguments))],
    createdAt: _epoch,
  );
}

AiMessage _toolResult(
  String callId,
  String name, {
  required bool success,
  required String content,
}) {
  return AiMessage(
    id: 'result-$callId',
    conversationId: 'conversation',
    role: AiMessageRole.tool,
    parts: [
      AiContentPart.toolResult(
        toolResult: AiToolResult(
          toolCallId: callId,
          name: name,
          success: success,
          content: content,
        ),
      ),
    ],
    createdAt: _epoch,
  );
}

final _epoch = DateTime.utc(2026, 9, 5);
