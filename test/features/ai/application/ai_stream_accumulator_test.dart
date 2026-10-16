import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_accumulator.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_snapshot.dart';
import 'package:JsxposedX/features/ai/domain/events/ai_stream_event.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

void main() {
  test('publishes text deltas immediately without losing content', () async {
    final accumulator = AiStreamAccumulator(
      requestId: 'r1',
      publishInterval: const Duration(hours: 1),
    );
    final snapshots = <AiStreamSnapshot>[];
    final subscription = accumulator.snapshots.listen(snapshots.add);

    accumulator.add(const AiStreamEvent.started(requestId: 'r1', sequence: 0));
    accumulator.add(
      const AiStreamEvent.textDelta(
        requestId: 'r1',
        sequence: 1,
        itemId: 'item',
        delta: '你',
      ),
    );
    accumulator.add(
      const AiStreamEvent.textDelta(
        requestId: 'r1',
        sequence: 2,
        itemId: 'item',
        delta: '好',
      ),
    );

    expect(snapshots, hasLength(3));
    accumulator.flush();
    expect(snapshots, hasLength(3));
    expect(snapshots.last.text, '你好');
    expect(snapshots.last.sequence, 2);

    await accumulator.close();
    await subscription.cancel();
  });

  test(
    'publishes terminal state immediately with usage and tool fragments',
    () async {
      final accumulator = AiStreamAccumulator(
        requestId: 'r2',
        publishInterval: const Duration(hours: 1),
      );
      final snapshots = <AiStreamSnapshot>[];
      final subscription = accumulator.snapshots.listen(snapshots.add);

      accumulator.add(
        const AiStreamEvent.started(requestId: 'r2', sequence: 0),
      );
      accumulator.add(
        const AiStreamEvent.toolCallDelta(
          requestId: 'r2',
          sequence: 1,
          index: 0,
          toolCallId: 'call-1',
          name: 'search',
          argumentsDelta: '{"q":',
        ),
      );
      accumulator.add(
        const AiStreamEvent.toolCallDelta(
          requestId: 'r2',
          sequence: 2,
          index: 0,
          argumentsDelta: '"x"}',
        ),
      );
      accumulator.add(
        const AiStreamEvent.usage(
          requestId: 'r2',
          sequence: 3,
          value: AiUsage(inputTokens: 2, outputTokens: 3, totalTokens: 5),
        ),
      );
      accumulator.add(
        const AiStreamEvent.completed(
          requestId: 'r2',
          sequence: 4,
          reason: AiFinishReason.toolCall,
        ),
      );

      final terminal = snapshots.last;
      expect(terminal.status, AiStreamStatus.completed);
      expect(terminal.finishReason, AiFinishReason.toolCall);
      expect(terminal.usage?.totalTokens, 5);
      expect(terminal.toolCalls.single.argumentsJson, '{"q":"x"}');

      await accumulator.close();
      await subscription.cancel();
    },
  );

  test('keeps the canonical tool call id when later deltas omit it', () async {
    final accumulator = AiStreamAccumulator(
      requestId: 'tool-id',
      publishInterval: Duration.zero,
    );
    accumulator.add(
      const AiStreamEvent.started(requestId: 'tool-id', sequence: 0),
    );
    accumulator.add(
      const AiStreamEvent.toolCallDelta(
        requestId: 'tool-id',
        sequence: 1,
        index: 0,
        toolCallId: 'call_real',
        name: 'search',
        argumentsDelta: '{}',
      ),
    );
    accumulator.add(
      const AiStreamEvent.toolCallDelta(
        requestId: 'tool-id',
        sequence: 2,
        index: 0,
        toolCallId: 'fc_item_wrong',
      ),
    );

    expect(accumulator.currentSnapshot.toolCalls.single.id, 'call_real');
    await accumulator.close();
  });

  test('rejects stale, foreign and post-terminal events', () async {
    final accumulator = AiStreamAccumulator(requestId: 'r3');
    accumulator.add(const AiStreamEvent.started(requestId: 'r3', sequence: 0));

    expect(
      () => accumulator.add(
        const AiStreamEvent.textDelta(
          requestId: 'other',
          sequence: 1,
          itemId: 'item',
          delta: 'x',
        ),
      ),
      throwsStateError,
    );
    expect(
      () => accumulator.add(
        const AiStreamEvent.textDelta(
          requestId: 'r3',
          sequence: 0,
          itemId: 'item',
          delta: 'x',
        ),
      ),
      throwsStateError,
    );

    accumulator.add(
      const AiStreamEvent.completed(
        requestId: 'r3',
        sequence: 1,
        reason: AiFinishReason.stop,
      ),
    );
    expect(
      () => accumulator.add(
        const AiStreamEvent.textDelta(
          requestId: 'r3',
          sequence: 2,
          itemId: 'item',
          delta: 'late',
        ),
      ),
      throwsStateError,
    );

    await accumulator.close();
  });
}
