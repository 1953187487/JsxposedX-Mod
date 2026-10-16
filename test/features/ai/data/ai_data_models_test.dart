import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/data/models/ai_assistant_profile_dto.dart';
import 'package:JsxposedX/features/ai/data/models/ai_conversation_dto.dart';
import 'package:JsxposedX/features/ai/data/models/ai_message_record_dto.dart';
import 'package:JsxposedX/features/ai/data/models/ai_model_definition_dto.dart';
import 'package:JsxposedX/features/ai/data/models/ai_provider_connection_dto.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

void main() {
  test('connection DTO round-trips without containing a secret', () {
    final entity = AiProviderConnection(
      id: 'connection',
      providerId: 'openai',
      displayName: 'OpenAI',
      baseUri: Uri.parse('https://example.test/v1/'),
      credentialRef: 'credential-ref',
      endpointOverrides: {
        AiEndpointKind.responses: Uri.parse('https://proxy.test/responses'),
      },
    );

    final json = AiProviderConnectionDto.fromEntity(entity).toJson();
    final restored = AiProviderConnectionDto.fromJson(json).toEntity();

    expect(restored, entity);
    expect(json.toString(), isNot(contains('secret')));
  });

  test('connection DTO rejects invalid endpoint overrides', () {
    const dto = AiProviderConnectionDto(
      id: 'connection',
      providerId: 'openai',
      displayName: 'OpenAI',
      baseUri: 'https://example.test/v1/',
      endpointOverrides: {'responses': 'relative/responses'},
    );

    expect(dto.toEntity, throwsFormatException);
  });

  test('connection DTO rejects unknown endpoint override kinds', () {
    const dto = AiProviderConnectionDto(
      id: 'connection',
      providerId: 'openai',
      displayName: 'OpenAI',
      baseUri: 'https://example.test/v1/',
      endpointOverrides: {'legacy': 'https://example.test/legacy'},
    );

    expect(dto.toEntity, throwsFormatException);
  });

  test('model DTO preserves capabilities and limits', () {
    const entity = AiModelDefinition(
      id: 'model',
      connectionId: 'connection',
      displayName: 'Model',
      capabilities: AiModelCapabilities(
        streaming: true,
        reasoning: true,
        toolCalling: true,
      ),
      limits: AiModelLimits(contextTokens: 128000, maxOutputTokens: 8192),
    );

    final restored = AiModelDefinitionDto.fromJson(
      AiModelDefinitionDto.fromEntity(entity).toJson(),
    ).toEntity();

    expect(restored, entity);
  });

  test('assistant and conversation DTOs preserve UTC dates', () {
    final now = DateTime.parse('2026-09-05T01:02:03+08:00');
    final assistant = AiAssistantProfile(
      id: 'assistant',
      name: 'Default',
      connectionId: 'connection',
      modelId: 'model',
      createdAt: now,
      updatedAt: now,
    );
    final conversation = AiConversation(
      id: 'conversation',
      title: 'Chat',
      assistantId: 'assistant',
      environmentId: 'apk_reverse',
      scopeId: 'com.example.app',
      createdAt: now,
      updatedAt: now,
    );

    final restoredAssistant = AiAssistantProfileDto.fromJson(
      AiAssistantProfileDto.fromEntity(assistant).toJson(),
    ).toEntity();
    final restoredConversation = AiConversationDto.fromJson(
      AiConversationDto.fromEntity(conversation).toJson(),
    ).toEntity();

    expect(restoredAssistant.createdAt, now.toUtc());
    expect(restoredConversation.createdAt, now.toUtc());
    expect(restoredConversation.environmentId, 'apk_reverse');
    expect(restoredConversation.scopeId, 'com.example.app');
  });

  test('message DTO preserves typed content parts', () {
    final entity = AiMessage(
      id: 'message',
      conversationId: 'conversation',
      role: AiMessageRole.assistant,
      parts: const [
        AiContentPart.reasoning('thinking'),
        AiContentPart.text('answer'),
        AiContentPart.toolCall(
          toolCall: AiToolCall(
            id: 'call',
            name: 'scan',
            arguments: {'path': 'a.apk'},
          ),
        ),
      ],
      usage: const AiUsage(inputTokens: 1, outputTokens: 2, totalTokens: 3),
      createdAt: DateTime.utc(2026, 9, 5),
    );

    final restored = AiMessageRecordDto.fromJson(
      AiMessageRecordDto.fromEntity(entity).toJson(),
    ).toEntity();

    expect(restored, entity);
    expect(restored.parts.whereType<AiReasoningPart>().single.text, 'thinking');
    expect(
      restored.parts.whereType<AiToolCallPart>().single.toolCall.name,
      'scan',
    );
  });
}
