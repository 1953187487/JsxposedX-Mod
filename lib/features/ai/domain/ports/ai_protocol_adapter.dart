import 'package:JsxposedX/features/ai/domain/events/ai_stream_event.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_transport_trace.dart';

abstract interface class AiProtocolAdapter {
  String get id;

  PreparedAiRequest prepare(
    AiRequest request, {
    required AiAdapterContext context,
  });

  Stream<AiStreamEvent> decodeStream(
    Stream<List<int>> bytes, {
    required String requestId,
  });

  Stream<AiStreamEvent> decodeResponse(
    List<int> bytes, {
    required String requestId,
  });
}

class AiAdapterContext {
  const AiAdapterContext({required this.provider, this.apiKey});

  final AiProviderDefinition provider;

  /// Resolved only for the duration of request preparation.
  final String? apiKey;
}

class PreparedAiRequest {
  const PreparedAiRequest({
    required this.uri,
    required this.headers,
    required this.body,
  });

  final Uri uri;
  final Map<String, String> headers;
  final Map<String, Object?> body;
}

abstract interface class AiTransport {
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  });
}

class AiTransportResponse {
  AiTransportResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
    AiTransportTrace? trace,
    Future<AiTransportTrace>? completedTrace,
  }) : trace = trace ?? _missingTrace,
       completedTrace = completedTrace ?? Future.value(trace ?? _missingTrace);

  final int statusCode;
  final Map<String, List<String>> headers;
  final Stream<List<int>> body;
  final AiTransportTrace trace;
  final Future<AiTransportTrace> completedTrace;

  static const _missingTrace = AiTransportTrace(requestUrl: '');
}

abstract interface class AiCancellationToken {
  bool get isCancelled;

  Future<void> get cancelled;
}

class AiTransportException implements Exception {
  const AiTransportException(this.failure);

  final AiFailure failure;

  @override
  String toString() => 'AiTransportException(${failure.code.name})';
}
