import 'dart:async';

import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/models/ai_message.dart' as legacy;
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

/// Read-only standard query port used by APK analysis. It is not the chat
/// runtime and contains no duplicate request or parser implementation.
class AiAnalysisQueryService {
  AiAnalysisQueryService(Dio dio) {
    _credentials = _QueryCredentialStore();
    _orchestrator = AiChatOrchestrator(
      providerRegistry: ProviderDefinitionRegistry(const [
        AiProviderDefinition(
          id: 'openai',
          displayName: 'OpenAI',
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

  late final _QueryCredentialStore _credentials;
  late final AiChatOrchestrator _orchestrator;

  Stream<legacy.AiMessage> stream({
    required AiConfig config,
    required List<legacy.AiMessage> messages,
  }) async* {
    final reference = 'query-${config.id}';
    await _credentials.put(AiSecret(config.apiKey), credentialRef: reference);
    try {
      final connection = AiProviderConnection(
        id: reference,
        providerId: _providerId(config.apiType),
        displayName: config.name,
        baseUri: Uri.parse(config.apiUrl),
        credentialRef: reference,
        endpointOverrides: {
          _endpoint(config.apiType): Uri.parse(config.fullApiUrl),
        },
      );
      final model = AiModelDefinition(
        id: config.moduleName,
        connectionId: connection.id,
        displayName: config.moduleName,
        capabilities: const AiModelCapabilities(streaming: true),
        limits: const AiModelLimits(),
        source: 'query',
      );
      final request = AiRequest(
        requestId: '$reference-${DateTime.now().microsecondsSinceEpoch}',
        connection: connection,
        model: model,
        messages: messages.map(_message).toList(growable: false),
        options: const AiGenerationOptions(stream: true),
      );
      final run = _orchestrator.start(request);
      var textLength = 0;
      var reasoningLength = 0;
      await for (final snapshot in run.snapshots) {
        if (snapshot.status == AiStreamStatus.failed) {
          throw StateError(snapshot.failure?.messageKey ?? 'AI request failed');
        }
        if (snapshot.text.length > textLength) {
          yield legacy.AiMessage(
            id: '${request.requestId}-text-$textLength',
            role: 'assistant',
            content: snapshot.text.substring(textLength),
          );
          textLength = snapshot.text.length;
        }
        if (snapshot.reasoning.length > reasoningLength) {
          yield legacy.AiMessage(
            id: '${request.requestId}-reasoning-$reasoningLength',
            role: 'assistant',
            content: snapshot.reasoning.substring(reasoningLength),
            isThinking: true,
          );
          reasoningLength = snapshot.reasoning.length;
        }
      }
    } finally {
      await _credentials.delete(reference);
    }
  }

  static AiMessage _message(legacy.AiMessage message) => AiMessage(
    id: message.id,
    conversationId: 'query',
    role: switch (message.role) {
      'system' => AiMessageRole.system,
      'assistant' => AiMessageRole.assistant,
      _ => AiMessageRole.user,
    },
    parts: [
      if (message.content.isNotEmpty) AiContentPart.text(message.content),
    ],
    createdAt: DateTime.now().toUtc(),
  );
  static String _providerId(AiApiType type) => switch (type) {
    AiApiType.openai => 'openai',
    AiApiType.openaiResponses => 'openai-responses',
    AiApiType.anthropic => 'anthropic',
  };
  static AiEndpointKind _endpoint(AiApiType type) => switch (type) {
    AiApiType.openai => AiEndpointKind.chatCompletions,
    AiApiType.openaiResponses => AiEndpointKind.responses,
    AiApiType.anthropic => AiEndpointKind.messages,
  };
}

final class _QueryCredentialStore implements AiCredentialStore {
  final _values = <String, AiSecret>{};
  @override
  Future<String> put(AiSecret value, {String? credentialRef}) async {
    final ref = credentialRef ?? 'query';
    _values[ref] = value;
    return ref;
  }

  @override
  Future<AiSecret?> read(String ref) async => _values[ref];
  @override
  Future<void> delete(String ref) async {
    _values.remove(ref);
  }
}
