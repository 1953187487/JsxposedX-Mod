import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_orchestrator.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_snapshot.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';
import 'package:JsxposedX/features/ai/domain/registries/protocol_adapter_registry.dart';
import 'package:JsxposedX/features/ai/domain/registries/provider_definition_registry.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/anthropic_messages_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_chat_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_responses_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/transport/dio_ai_transport.dart';
import 'package:dio/dio.dart';

/// Runs a connection check through the same standard protocol pipeline as a
/// normal conversation. Credentials remain in memory for this request only.
class AiConnectionTestService {
  AiConnectionTestService(Dio dio) {
    _credentials = _EphemeralCredentialStore();
    _orchestrator = AiChatOrchestrator(
      providerRegistry: ProviderDefinitionRegistry(const [
        AiProviderDefinition(
          id: 'openai',
          displayName: 'OpenAI Compatible',
          adapterId: 'openai.chat.v1',
        ),
        AiProviderDefinition(
          id: 'openai-responses',
          displayName: 'OpenAI Responses',
          adapterId: 'openai.responses.v1',
        ),
        AiProviderDefinition(
          id: 'anthropic',
          displayName: 'Anthropic',
          adapterId: 'anthropic.messages.v1',
          authScheme: AiAuthScheme.apiKeyHeader,
          authParameterName: 'x-api-key',
        ),
      ]),
      adapterRegistry: ProtocolAdapterRegistry(const [
        OpenAiChatAdapter(),
        OpenAiResponsesAdapter(),
        AnthropicMessagesAdapter(),
      ]),
      transport: DioAiTransport(dio),
      credentialStore: _credentials,
    );
  }

  late final _EphemeralCredentialStore _credentials;
  late final AiChatOrchestrator _orchestrator;

  Future<String> test(AiConfig config) async {
    final reference = 'connection-test-${config.id}';
    await _credentials.put(AiSecret(config.apiKey), credentialRef: reference);
    try {
      final connection = AiProviderConnection(
        id: 'connection-test-${config.id}',
        providerId: _providerId(config.apiType),
        displayName: config.name,
        baseUri: Uri.parse(config.apiUrl),
        credentialRef: reference,
        endpointOverrides: {
          _endpointKind(config.apiType): Uri.parse(config.fullApiUrl),
        },
      );
      final model = AiModelDefinition(
        id: config.moduleName,
        connectionId: connection.id,
        displayName: config.moduleName,
        capabilities: const AiModelCapabilities(streaming: true),
        limits: const AiModelLimits(),
        source: 'connection-test',
      );
      final run = _orchestrator.start(
        AiRequest(
          requestId: '$reference-${DateTime.now().microsecondsSinceEpoch}',
          connection: connection,
          model: model,
          messages: [
            AiMessage(
              id: 'connection-test-message',
              conversationId: 'connection-test',
              role: AiMessageRole.user,
              parts: const [AiContentPart.text('Hi')],
              createdAt: DateTime.now().toUtc(),
            ),
          ],
          options: const AiGenerationOptions(stream: true),
        ),
      );
      final snapshot = await run.completed;
      if (snapshot.status == AiStreamStatus.failed) {
        throw StateError(snapshot.failure?.messageKey ?? 'Connection failed');
      }
      return 'Connection successful';
    } finally {
      await _credentials.delete(reference);
    }
  }

  static String _providerId(AiApiType type) => switch (type) {
    AiApiType.openai => 'openai',
    AiApiType.openaiResponses => 'openai-responses',
    AiApiType.anthropic => 'anthropic',
  };

  static AiEndpointKind _endpointKind(AiApiType type) => switch (type) {
    AiApiType.openai => AiEndpointKind.chatCompletions,
    AiApiType.openaiResponses => AiEndpointKind.responses,
    AiApiType.anthropic => AiEndpointKind.messages,
  };
}

final class _EphemeralCredentialStore implements AiCredentialStore {
  final Map<String, AiSecret> _values = <String, AiSecret>{};

  @override
  Future<String> put(AiSecret secret, {String? credentialRef}) async {
    final ref = credentialRef ?? 'connection-test';
    _values[ref] = secret;
    return ref;
  }

  @override
  Future<AiSecret?> read(String credentialRef) async => _values[credentialRef];

  @override
  Future<void> delete(String credentialRef) async =>
      _values.remove(credentialRef);
}
