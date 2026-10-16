import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:JsxposedX/features/ai/application/chat/ai_transport_trace.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioAiTransport implements AiTransport {
  const DioAiTransport(this._dio, {this.maxTraceBytes = 64 * 1024});

  final Dio _dio;
  final int maxTraceBytes;

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    final cancelToken = CancelToken();
    if (cancellation.isCancelled) {
      cancelToken.cancel('AI request cancelled before sending');
    } else {
      unawaited(
        cancellation.cancelled.then((_) {
          if (!cancelToken.isCancelled) {
            cancelToken.cancel('AI request cancelled');
          }
        }),
      );
    }

    late final Response<ResponseBody> response;
    final requestStartTime = DateTime.now().toUtc();
    try {
      response = await _dio.postUri<ResponseBody>(
        request.uri,
        data: request.body,
        cancelToken: cancelToken,
        options: Options(
          headers: request.headers,
          responseType: ResponseType.stream,
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (error) {
      throw AiTransportException(_mapFailure(error));
    }
    final responseHeadersTime = DateTime.now().toUtc();
    final responseBody = response.data;
    if (responseBody == null) {
      throw StateError('AI transport returned an empty response body');
    }
    final headers = Map<String, List<String>>.unmodifiable(
      response.headers.map,
    );
    final contentType = response.headers.value('content-type');
    final trace = AiTransportTrace(
      requestUrl: request.uri.toString(),
      statusCode: response.statusCode,
      contentType: contentType,
      requestStartTime: requestStartTime,
      requestEndTime: responseHeadersTime,
      responseDuration: responseHeadersTime.difference(requestStartTime),
      providerRequestId: _providerRequestId(headers),
    );
    final traceCollector = _TransportTraceCollector(
      initialTrace: trace,
      maxBytes: maxTraceBytes,
      captureSseLines:
          contentType?.toLowerCase().contains('text/event-stream') ?? false,
    );
    if (kDebugMode) {
      developer.log(
        '[AI][HTTP] ${request.uri} status=${response.statusCode} '
        'content-type=${contentType ?? 'unknown'}',
        name: 'AiTransport',
      );
    }
    return AiTransportResponse(
      statusCode: response.statusCode ?? 0,
      headers: headers,
      body: _debugBody(responseBody.stream, traceCollector),
      trace: trace,
      completedTrace: traceCollector.completed,
    );
  }

  Stream<List<int>> _debugBody(
    Stream<List<int>> source,
    _TransportTraceCollector traceCollector,
  ) async* {
    try {
      await for (final chunk in source) {
        traceCollector.add(chunk);
        if (kDebugMode) {
          final text = utf8.decode(chunk, allowMalformed: true);
          final preview = text.length <= 4000
              ? text
              : '${text.substring(0, 4000)}...[truncated]';
          developer.log(
            '[AI][SSE] bytes=${chunk.length}\n$preview',
            name: 'AiTransport',
          );
        }
        yield chunk;
      }
    } finally {
      traceCollector.complete();
    }
  }

  static AiFailure _mapFailure(DioException error) {
    final code = switch (error.type) {
      DioExceptionType.cancel => AiFailureCode.cancelled,
      DioExceptionType.connectionTimeout => AiFailureCode.connectTimeout,
      DioExceptionType.receiveTimeout => AiFailureCode.receiveTimeout,
      DioExceptionType.connectionError ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.badCertificate => AiFailureCode.networkUnavailable,
      DioExceptionType.badResponse ||
      DioExceptionType.unknown => AiFailureCode.unknown,
    };
    return AiFailure(
      code: code,
      messageKey: 'ai.error.${code.name}',
      httpStatus: error.response?.statusCode,
      retryable:
          code == AiFailureCode.networkUnavailable ||
          code == AiFailureCode.connectTimeout ||
          code == AiFailureCode.receiveTimeout,
      providerRequestId: error.response == null
          ? null
          : _providerRequestId(error.response!.headers.map),
    );
  }

  static String? _providerRequestId(Map<String, List<String>> headers) {
    const candidates = {
      'x-request-id',
      'request-id',
      'x-correlation-id',
      'anthropic-request-id',
      'openai-request-id',
      'cf-ray',
    };
    for (final entry in headers.entries) {
      if (candidates.contains(entry.key.toLowerCase()) &&
          entry.value.isNotEmpty &&
          entry.value.first.trim().isNotEmpty) {
        return entry.value.first.trim();
      }
    }
    return null;
  }
}

class _TransportTraceCollector {
  _TransportTraceCollector({
    required this.initialTrace,
    required this.maxBytes,
    required this.captureSseLines,
  });

  final AiTransportTrace initialTrace;
  final int maxBytes;
  final bool captureSseLines;
  final Completer<AiTransportTrace> _completed = Completer<AiTransportTrace>();
  final StringBuffer _rawText = StringBuffer();
  final List<String> _rawSseLines = [];
  String _pendingLine = '';
  int _capturedBytes = 0;

  Future<AiTransportTrace> get completed => _completed.future;

  void add(List<int> chunk) {
    if (_capturedBytes < maxBytes) {
      final remaining = maxBytes - _capturedBytes;
      final captured = chunk.length <= remaining
          ? chunk
          : chunk.take(remaining).toList(growable: false);
      _capturedBytes += captured.length;
      final text = utf8.decode(captured, allowMalformed: true);
      _rawText.write(text);
      if (captureSseLines) _collectSseLines(text);
    }
  }

  void complete() {
    if (_completed.isCompleted) return;
    if (captureSseLines && _pendingLine.isNotEmpty) {
      _addSseLine(_pendingLine);
      _pendingLine = '';
    }
    final endTime = DateTime.now().toUtc();
    final text = _rawText.toString();
    _completed.complete(
      initialTrace.copyWith(
        requestEndTime: endTime,
        responseDuration: initialTrace.requestStartTime == null
            ? initialTrace.responseDuration
            : endTime.difference(initialTrace.requestStartTime!),
        rawSseEvents: List<String>.unmodifiable(_rawSseLines),
        rawResponseText: text.isEmpty ? null : text,
      ),
    );
  }

  void _collectSseLines(String text) {
    final source = '$_pendingLine$text';
    final lines = source.split('\n');
    _pendingLine = lines.removeLast();
    for (final line in lines) {
      _addSseLine(line);
    }
  }

  void _addSseLine(String line) {
    final normalized = line.endsWith('\r')
        ? line.substring(0, line.length - 1)
        : line;
    if (normalized.isEmpty) return;
    if (normalized.startsWith('event:') ||
        normalized.startsWith('data:') ||
        normalized.startsWith('id:') ||
        normalized.startsWith('retry:')) {
      _rawSseLines.add(normalized);
    }
  }
}
