import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_transport_trace.freezed.dart';

@freezed
abstract class AiTransportTrace with _$AiTransportTrace {
  const factory AiTransportTrace({
    required String requestUrl,
    int? statusCode,
    String? contentType,
    DateTime? requestStartTime,
    DateTime? requestEndTime,
    Duration? responseDuration,
    String? providerRequestId,
    @Default([]) List<String> rawSseEvents,
    String? rawResponseText,
    String? rawErrorJson,
  }) = _AiTransportTrace;
}
