import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_transport_trace.dart';

part 'ai_stream_snapshot.freezed.dart';

enum AiStreamStatus { idle, streaming, completed, failed }

@freezed
abstract class AiToolCallSnapshot with _$AiToolCallSnapshot {
  const factory AiToolCallSnapshot({
    required int index,
    String? id,
    @Default('') String name,
    @Default('') String argumentsJson,
  }) = _AiToolCallSnapshot;
}

@freezed
abstract class AiStreamSnapshot with _$AiStreamSnapshot {
  const factory AiStreamSnapshot({
    required String requestId,
    @Default(-1) int sequence,
    @Default(AiStreamStatus.idle) AiStreamStatus status,
    @Default('') String text,
    @Default('') String reasoning,
    Duration? reasoningDuration,
    @Default(<AiToolCallSnapshot>[]) List<AiToolCallSnapshot> toolCalls,
    AiUsage? usage,
    AiFinishReason? finishReason,
    AiFailure? failure,
    AiTransportTrace? transportTrace,
  }) = _AiStreamSnapshot;
}
