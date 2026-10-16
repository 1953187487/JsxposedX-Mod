import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:JsxposedX/features/ai/application/chat/ai_transport_trace.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

part 'ai_stream_event.freezed.dart';

@freezed
sealed class AiStreamEvent with _$AiStreamEvent {
  const AiStreamEvent._();

  const factory AiStreamEvent.started({
    required String requestId,
    required int sequence,
  }) = AiResponseStarted;

  const factory AiStreamEvent.textDelta({
    required String requestId,
    required int sequence,
    required String itemId,
    required String delta,
  }) = AiTextDelta;

  const factory AiStreamEvent.reasoningDelta({
    required String requestId,
    required int sequence,
    required String itemId,
    required String delta,
  }) = AiReasoningDelta;

  const factory AiStreamEvent.toolCallDelta({
    required String requestId,
    required int sequence,
    required int index,
    String? toolCallId,
    String? name,
    String? argumentsDelta,
  }) = AiToolCallDelta;

  const factory AiStreamEvent.usage({
    required String requestId,
    required int sequence,
    required AiUsage value,
  }) = AiUsageUpdated;

  const factory AiStreamEvent.completed({
    required String requestId,
    required int sequence,
    required AiFinishReason reason,
  }) = AiResponseCompleted;

  const factory AiStreamEvent.failed({
    required String requestId,
    required int sequence,
    required AiFailure failure,
  }) = AiResponseFailed;
}
