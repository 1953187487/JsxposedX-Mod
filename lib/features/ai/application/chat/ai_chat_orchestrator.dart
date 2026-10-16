import 'dart:convert';
import 'dart:async';

import 'package:JsxposedX/features/ai/application/chat/ai_cancellation_controller.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_accumulator.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_snapshot.dart';
import 'package:JsxposedX/features/ai/domain/events/ai_stream_event.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:JsxposedX/features/ai/domain/registries/protocol_adapter_registry.dart';
import 'package:JsxposedX/features/ai/domain/registries/provider_definition_registry.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_connection_validator.dart';

class AiChatOrchestrator {
  const AiChatOrchestrator({
    required ProviderDefinitionRegistry providerRegistry,
    required ProtocolAdapterRegistry adapterRegistry,
    required AiTransport transport,
    required AiCredentialStore credentialStore,
  }) : _providerRegistry = providerRegistry,
       _adapterRegistry = adapterRegistry,
       _transport = transport,
       _credentialStore = credentialStore;

  final ProviderDefinitionRegistry _providerRegistry;
  final ProtocolAdapterRegistry _adapterRegistry;
  final AiTransport _transport;
  final AiCredentialStore _credentialStore;

  AiChatRun start(AiRequest request) {
    final run = AiChatRun._(request.requestId);
    unawaited(_execute(request, run));
    return run;
  }

  Future<void> _execute(AiRequest request, AiChatRun run) async {
    try {
      _validate(request);
      final provider = _providerRegistry.require(request.connection.providerId);
      final adapter = _adapterRegistry.require(provider.adapterId);
      final apiKey = await _resolveCredential(request, provider);
      if (run.isCancelled) {
        _fail(run, AiFailureCode.cancelled);
        return;
      }

      final prepared = adapter.prepare(
        request,
        context: AiAdapterContext(provider: provider, apiKey: apiKey),
      );
      var response = await _transport.send(
        prepared,
        cancellation: run._cancellation,
      );
      run._accumulator.updateTransportTrace(response.trace);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final errorBody = await _readAtMost(response.body, 64 * 1024);
        final rawError = _rawBodyText(errorBody);
        final completedTrace = await response.completedTrace;
        final finalTrace = completedTrace.copyWith(rawErrorJson: rawError);
        run._accumulator.updateTransportTrace(finalTrace);
        run._accumulator.add(
          AiStreamEvent.failed(
            requestId: request.requestId,
            sequence: 0,
            failure: _httpFailure(
              response.statusCode,
              response.headers,
              detail: _extractErrorDetail(rawError),
            ),
          ),
        );
        return;
      }

      final events = await _decodeResponse(
        adapter: adapter,
        body: response.body,
        request: request,
        headers: response.headers,
      );
      await for (final event in events) {
        run._accumulator.add(event);
      }
      final completedTrace = await response.completedTrace;
      run._accumulator.updateTransportTrace(completedTrace);
    } on AiTransportException catch (error) {
      _addFailure(run, error.failure);
    } on StateError {
      _fail(run, AiFailureCode.invalidConfiguration);
    } on UnsupportedError {
      _fail(run, AiFailureCode.invalidConfiguration);
    } catch (e) {
      _addFailure(
        run,
        AiFailure(
          code: run.isCancelled ? AiFailureCode.cancelled : AiFailureCode.unknown,
          messageKey: 'ai.error.${run.isCancelled ? 'cancelled' : 'unknown'}',
          detail: e.toString(),
        ),
      );
    } finally {
      await run._finish();
    }
  }

  static bool _isJsonResponse(Map<String, List<String>> headers) {
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() != 'content-type' || entry.value.isEmpty) {
        continue;
      }
      return entry.value.first.toLowerCase().contains('application/json') ||
          entry.value.first.toLowerCase().contains('+json');
    }
    return false;
  }

  static Future<Stream<AiStreamEvent>> _decodeResponse({
    required AiProtocolAdapter adapter,
    required Stream<List<int>> body,
    required AiRequest request,
    required Map<String, List<String>> headers,
  }) async {
    if (!request.options.stream) {
      return adapter.decodeResponse(
        await _readAll(body),
        requestId: request.requestId,
      );
    }
    if (!_isJsonResponse(headers)) {
      return adapter.decodeStream(body, requestId: request.requestId);
    }

    return adapter.decodeResponse(
      await _readAll(body),
      requestId: request.requestId,
    );
  }

  void _validate(AiRequest request) {
    validateAiProviderConnection(request.connection);
    if (!request.connection.enabled ||
        request.model.connectionId != request.connection.id ||
        request.model.id.trim().isEmpty ||
        request.messages.isEmpty) {
      throw StateError('Invalid AI request');
    }
    if (request.options.stream && !request.model.capabilities.streaming) {
      throw StateError('Model does not support streaming');
    }
    if (request.tools.isNotEmpty && !request.model.capabilities.toolCalling) {
      throw StateError('Model does not support tool calling');
    }
  }

  Future<String?> _resolveCredential(
    AiRequest request,
    AiProviderDefinition provider,
  ) async {
    if (provider.authScheme == AiAuthScheme.none) return null;
    final reference = request.connection.credentialRef;
    if (reference == null || reference.isEmpty) {
      throw const AiTransportException(
        AiFailure(
          code: AiFailureCode.credentialMissing,
          messageKey: 'ai.error.credentialMissing',
        ),
      );
    }
    final secret = await _credentialStore.read(reference);
    if (secret == null || secret.value.isEmpty) {
      throw const AiTransportException(
        AiFailure(
          code: AiFailureCode.credentialMissing,
          messageKey: 'ai.error.credentialMissing',
        ),
      );
    }
    return secret.value;
  }

  static Future<List<int>> _readAll(Stream<List<int>> body) async {
    final bytes = <int>[];
    await for (final chunk in body) {
      bytes.addAll(chunk);
    }
    return bytes;
  }

  static Future<List<int>> _readAtMost(
    Stream<List<int>> body,
    int limit,
  ) async {
    final bytes = <int>[];
    await for (final chunk in body) {
      final remaining = limit - bytes.length;
      if (remaining <= 0) break;
      bytes.addAll(chunk.length <= remaining ? chunk : chunk.take(remaining));
      if (bytes.length >= limit) break;
    }
    return bytes;
  }

  static String? _rawBodyText(List<int> bytes) {
    if (bytes.isEmpty) return null;
    final text = utf8.decode(bytes, allowMalformed: true).trim();
    return text.isEmpty ? null : text;
  }

  static String? _extractErrorDetail(String? text) {
    if (text == null || text.isEmpty) return null;
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map) {
        final error = decoded['error'];
        if (error is Map && error['message'] != null) {
          return error['message'].toString().trim();
        }
        if (error is String && error.trim().isNotEmpty) return error.trim();
        final message = decoded['message'];
        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString().trim();
        }
      }
    } on FormatException {
      // Plain-text error responses are useful as-is.
    }
    return text.length <= 500 ? text : '${text.substring(0, 500)}...';
  }

  static AiFailure _httpFailure(
    int status,
    Map<String, List<String>> headers, {
    String? detail,
  }) {
    final code = switch (status) {
      401 => AiFailureCode.authenticationFailed,
      403 => AiFailureCode.permissionDenied,
      404 => AiFailureCode.modelNotFound,
      429 => AiFailureCode.rateLimited,
      >= 500 => AiFailureCode.serverFailure,
      _ => AiFailureCode.unknown,
    };
    return AiFailure(
      code: code,
      messageKey: detail?.isNotEmpty == true
          ? detail!
          : 'ai.error.${code.name}',
      httpStatus: status,
      retryable: status == 429 || status >= 500,
      providerRequestId: _providerRequestId(headers),
    );
  }

  static String? _providerRequestId(Map<String, List<String>> headers) {
    const candidates = {
      'x-request-id',
      'request-id',
      'anthropic-request-id',
      'cf-ray',
    };
    for (final entry in headers.entries) {
      if (candidates.contains(entry.key.toLowerCase()) &&
          entry.value.isNotEmpty &&
          entry.value.first.isNotEmpty) {
        return entry.value.first;
      }
    }
    return null;
  }

  static void _fail(AiChatRun run, AiFailureCode code) {
    _addFailure(
      run,
      AiFailure(code: code, messageKey: 'ai.error.${code.name}'),
    );
  }

  static void _addFailure(AiChatRun run, AiFailure failure) {
    if (run._accumulator.isTerminal) return;
    run._accumulator.add(
      AiStreamEvent.failed(
        requestId: run.requestId,
        sequence: run._accumulator.lastSequence + 1,
        failure: failure,
      ),
    );
  }
}

class AiChatRun {
  AiChatRun._(this.requestId)
    : _accumulator = AiStreamAccumulator(requestId: requestId);

  final String requestId;
  final AiCancellationController _cancellation = AiCancellationController();
  final Completer<AiStreamSnapshot> _completion = Completer<AiStreamSnapshot>();
  final AiStreamAccumulator _accumulator;

  Stream<AiStreamSnapshot> get snapshots => _accumulator.snapshots;

  AiStreamSnapshot get currentSnapshot => _accumulator.currentSnapshot;

  Future<AiStreamSnapshot> get completed => _completion.future;
  bool get isCancelled => _cancellation.isCancelled;

  void cancel() => _cancellation.cancel();

  Future<void> _finish() async {
    await _accumulator.close();
    if (!_completion.isCompleted) {
      _completion.complete(_accumulator.currentSnapshot);
    }
  }
}
