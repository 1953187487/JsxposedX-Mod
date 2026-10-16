import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_orchestrator.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_snapshot.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_transport_trace.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:JsxposedX/features/ai/domain/registries/protocol_adapter_registry.dart';
import 'package:JsxposedX/features/ai/domain/registries/provider_definition_registry.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_chat_adapter.dart';

void main() {
  test(
    'runs transport bytes through adapter into a completed snapshot',
    () async {
      final payload = jsonEncode({
        'choices': [
          {
            'delta': {'content': 'real delta'},
            'finish_reason': 'stop',
          },
        ],
        'usage': {
          'prompt_tokens': 2,
          'completion_tokens': 3,
          'total_tokens': 5,
        },
      });
      final transport = _FakeTransport(
        response: AiTransportResponse(
          statusCode: 200,
          headers: const {},
          body: Stream.value(utf8.encode('data: $payload\n\n')),
        ),
      );
      final orchestrator = _orchestrator(
        transport: transport,
        credentialStore: const _FakeCredentialStore({'credential-1': 'secret'}),
      );

      final run = orchestrator.start(_request());
      final snapshots = <AiStreamSnapshot>[];
      final subscription = run.snapshots.listen(snapshots.add);
      final result = await run.completed;

      expect(result.status, AiStreamStatus.completed);
      expect(result.text, 'real delta');
      expect(result.usage?.totalTokens, 5);
      expect(transport.lastRequest?.headers['Authorization'], 'Bearer secret');
      expect(
        transport.lastRequest?.headers['Authorization'],
        isNot(contains('credential-1')),
      );
      expect(snapshots.last, result);
      await subscription.cancel();
    },
  );

  test(
    'maps an HTTP authentication failure without parsing it as chat',
    () async {
      final initialTrace = AiTransportTrace(
        requestUrl: 'https://example.test/v1/chat/completions',
        statusCode: 401,
        requestStartTime: _epoch,
      );
      final completedTrace = initialTrace.copyWith(
        requestEndTime: _epoch.add(const Duration(milliseconds: 12)),
        responseDuration: const Duration(milliseconds: 12),
        rawResponseText: '{"error":{"message":"bad key"}}',
      );
      final orchestrator = _orchestrator(
        transport: _FakeTransport(
          response: AiTransportResponse(
            statusCode: 401,
            headers: const {
              'X-Request-ID': ['provider-request-1'],
            },
            body: Stream.value(utf8.encode('{"error":{"message":"bad key"}}')),
            trace: initialTrace,
            completedTrace: Future.value(completedTrace),
          ),
        ),
        credentialStore: const _FakeCredentialStore({'credential-1': 'secret'}),
      );

      final result = await orchestrator.start(_request()).completed;

      expect(result.status, AiStreamStatus.failed);
      expect(result.failure?.code, AiFailureCode.authenticationFailed);
      expect(result.failure?.httpStatus, 401);
      expect(result.failure?.providerRequestId, 'provider-request-1');
      expect(result.failure?.messageKey, 'bad key');
      expect(
        result.transportTrace?.rawResponseText,
        completedTrace.rawResponseText,
      );
      expect(
        result.transportTrace?.rawErrorJson,
        completedTrace.rawResponseText,
      );
      expect(
        result.transportTrace?.requestEndTime,
        completedTrace.requestEndTime,
      );
    },
  );

  test('does not reinterpret a JSON response as SSE', () async {
    final payload = jsonEncode({
      'choices': [
        {
          'delta': {'content': 'mislabelled delta'},
          'finish_reason': 'stop',
        },
      ],
    });
    final orchestrator = _orchestrator(
      transport: _FakeTransport(
        response: AiTransportResponse(
          statusCode: 200,
          headers: const {
            'Content-Type': ['application/json'],
          },
          body: Stream.value(utf8.encode('data: $payload\n\n')),
        ),
      ),
      credentialStore: const _FakeCredentialStore({'credential-1': 'secret'}),
    );

    final result = await orchestrator.start(_request()).completed;

    expect(result.status, AiStreamStatus.failed);
    expect(result.failure?.code, AiFailureCode.protocolMalformed);
  });

  test(
    'fails before transport when a credential reference cannot resolve',
    () async {
      final transport = _FakeTransport(
        response: AiTransportResponse(
          statusCode: 200,
          headers: const {},
          body: const Stream.empty(),
        ),
      );
      final orchestrator = _orchestrator(
        transport: transport,
        credentialStore: const _FakeCredentialStore({}),
      );

      final result = await orchestrator.start(_request()).completed;

      expect(result.failure?.code, AiFailureCode.credentialMissing);
      expect(transport.lastRequest, isNull);
    },
  );
}

AiChatOrchestrator _orchestrator({
  required AiTransport transport,
  required AiCredentialStore credentialStore,
}) {
  return AiChatOrchestrator(
    providerRegistry: ProviderDefinitionRegistry([
      const AiProviderDefinition(
        id: 'openai',
        displayName: 'OpenAI',
        adapterId: 'openai.chat.v1',
      ),
    ]),
    adapterRegistry: ProtocolAdapterRegistry([const OpenAiChatAdapter()]),
    transport: transport,
    credentialStore: credentialStore,
  );
}

AiRequest _request() {
  return AiRequest(
    requestId: 'request-1',
    connection: AiProviderConnection(
      id: 'connection-1',
      providerId: 'openai',
      displayName: 'OpenAI',
      baseUri: Uri.parse('https://example.test/v1/'),
      credentialRef: 'credential-1',
    ),
    model: const AiModelDefinition(
      id: 'model-1',
      connectionId: 'connection-1',
      displayName: 'Model',
      capabilities: AiModelCapabilities(streaming: true),
      limits: AiModelLimits(),
    ),
    messages: [
      AiMessage(
        id: 'message-1',
        conversationId: 'conversation-1',
        role: AiMessageRole.user,
        parts: [AiContentPart.text('hello')],
        createdAt: _epoch,
      ),
    ],
  );
}

final _epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

class _FakeTransport implements AiTransport {
  _FakeTransport({required this.response});

  final AiTransportResponse response;
  PreparedAiRequest? lastRequest;

  @override
  Future<AiTransportResponse> send(
    PreparedAiRequest request, {
    required AiCancellationToken cancellation,
  }) async {
    lastRequest = request;
    return response;
  }
}

class _FakeCredentialStore implements AiCredentialStore {
  const _FakeCredentialStore(this.values);

  final Map<String, String> values;

  @override
  Future<String> put(AiSecret secret, {String? credentialRef}) {
    throw UnimplementedError();
  }

  @override
  Future<AiSecret?> read(String credentialRef) async {
    final value = values[credentialRef];
    return value == null ? null : AiSecret(value);
  }

  @override
  Future<void> delete(String credentialRef) async {}
}
