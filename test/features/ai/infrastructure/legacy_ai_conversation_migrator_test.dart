import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/core/models/ai_message.dart' as legacy;
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/infrastructure/migration/legacy_ai_conversation_migrator.dart';

void main() {
  test(
    'maps legacy tool calls, reasoning and failed tool results losslessly',
    () {
      final legacyMessages = [
        const legacy.AiMessage(
          id: 'user-1',
          role: 'user',
          content: 'Inspect the manifest',
        ),
        const legacy.AiMessage(
          id: 'assistant-1',
          role: 'assistant',
          content: '',
          reasoningContent: 'I will inspect it first.',
          toolCalls: [
            {
              'id': 'call-1',
              'type': 'function',
              'function': {
                'name': 'get_manifest',
                'arguments': '{"package":"com.example.app"}',
              },
            },
          ],
        ),
        const legacy.AiMessage(
          id: 'tool-1',
          role: 'tool',
          content: 'permission denied',
          toolCallId: 'call-1',
          isError: true,
        ),
      ];

      final standard = LegacyAiConversationMigrator.toStandardMessages(
        legacyMessages,
        'conversation-1',
        DateTime.utc(2026, 9, 5),
      );

      expect(standard.map((message) => message.id).toList(), [
        'user-1',
        'assistant-1',
        'tool-1',
      ]);
      expect(standard[0].role, AiMessageRole.user);
      expect(
        standard[1].parts,
        contains(const AiContentPart.reasoning('I will inspect it first.')),
      );
      final toolCall = standard[1].parts
          .whereType<AiToolCallPart>()
          .single
          .toolCall;
      expect(toolCall.id, 'call-1');
      expect(toolCall.name, 'get_manifest');
      expect(toolCall.arguments, {'package': 'com.example.app'});
      expect(standard[2].role, AiMessageRole.tool);
      expect(standard[2].status, AiMessageStatus.failed);
      final toolResult = standard[2].parts
          .whereType<AiToolResultPart>()
          .single
          .toolResult;
      expect(toolResult.toolCallId, 'call-1');
      expect(toolResult.success, isFalse);
      expect(toolResult.content, 'permission denied');

      final restored = standard.map(
        LegacyAiConversationMigrator.toLegacyMessage,
      );
      expect(restored.elementAt(0).content, 'Inspect the manifest');
      expect(
        restored.elementAt(1).reasoningContent,
        'I will inspect it first.',
      );
      expect(restored.elementAt(1).toolCalls?.single['id'], 'call-1');
      expect(
        restored.elementAt(1).toolCalls?.single['function']['name'],
        'get_manifest',
      );
      expect(restored.elementAt(2).toolCallId, 'call-1');
      expect(restored.elementAt(2).isError, isTrue);
    },
  );

  test('does not fail migration when legacy tool arguments are malformed', () {
    const message = legacy.AiMessage(
      id: 'assistant-1',
      role: 'assistant',
      content: '',
      toolCalls: [
        {
          'id': 'call-1',
          'function': {'name': 'get_manifest', 'arguments': '{malformed'},
        },
      ],
    );

    final converted = LegacyAiConversationMigrator.toStandardMessages(
      const [message],
      'conversation-1',
      DateTime.utc(2026, 9, 5),
    );

    final toolCall = converted.single.parts.whereType<AiToolCallPart>().single;
    expect(toolCall.toolCall.arguments, isEmpty);
    expect(converted.single.status, AiMessageStatus.completed);
  });
}
