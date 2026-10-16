import 'dart:convert';

import 'package:JsxposedX/features/ai/data/models/ai_message_dto.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';

const String openAiResponsesReasoningProtocolPrefix =
    '[responses_reasoning_item]';

final class OpenAiResponsesPayloadComposer {
  static List<Map<String, dynamic>> buildInput(List<AiMessageDto> messages) {
    final input = <Map<String, dynamic>>[];
    for (final message in messages) {
      final reasoningItem = OpenAiResponsesReasoningItemCodec.tryDecode(
        message.content,
      );
      if (reasoningItem != null) {
        input.add(reasoningItem);
        continue;
      }
      if (message.role == 'system' || message.role == 'developer') {
        input.add({
          'type': 'message',
          'role': 'developer',
          'content': [
            {'type': 'input_text', 'text': message.content},
          ],
        });
        continue;
      }
      if (message.role == 'tool') {
        final toolCallId = message.toolCallId?.trim();
        if (toolCallId == null || toolCallId.isEmpty) continue;
        input.add({
          'type': 'function_call_output',
          'call_id': toolCallId,
          'output': message.content,
        });
        continue;
      }
      if (message.hasToolCalls) {
        if (message.content.trim().isNotEmpty) input.add(mapMessage(message));
        for (final toolCall in message.toolCalls!) {
          final function = toolCall['function'] as Map<String, dynamic>? ?? {};
          final callId = toolCall['id']?.toString().trim() ?? '';
          final name = function['name']?.toString().trim() ?? '';
          if (callId.isEmpty || name.isEmpty) continue;
          input.add({
            'type': 'function_call',
            'call_id': callId,
            'name': name,
            'arguments': function['arguments']?.toString() ?? '{}',
          });
        }
        continue;
      }
      input.add(mapMessage(message));
    }
    return input;
  }

  static Map<String, dynamic> mapMessage(AiMessageDto message) {
    final normalizedRole = message.role == 'assistant' ? 'assistant' : 'user';
    final contentType = normalizedRole == 'assistant'
        ? 'output_text'
        : 'input_text';
    if (normalizedRole == 'user' &&
        AiMultimodalMessageCodec.isEncoded(message.content)) {
      return {
        'type': 'message',
        'role': normalizedRole,
        'content': toResponsesContent(message.content),
      };
    }
    return {
      'type': 'message',
      'role': normalizedRole,
      'content': [
        {'type': contentType, 'text': message.content},
      ],
    };
  }

  static List<Map<String, dynamic>> toResponsesContent(String content) {
    final openAiContent = AiMultimodalMessageCodec.toOpenAiContent(
      content,
      isZh: true,
    );
    return openAiContent.map((part) {
      final type = part['type']?.toString() ?? 'text';
      if (type == 'image_url') {
        final payload = part['image_url'];
        return {
          'type': 'input_image',
          'image_url': payload is Map<String, dynamic>
              ? payload['url']?.toString() ?? ''
              : '',
        };
      }
      return {
        'type': 'input_text',
        'text': part['text']?.toString() ?? '',
      };
    }).toList(growable: false);
  }
}

final class OpenAiResponsesReasoningItemCodec {
  static String encode(Map<String, dynamic> item) =>
      '$openAiResponsesReasoningProtocolPrefix${jsonEncode(item)}';

  static bool isEncoded(String content) =>
      content.startsWith(openAiResponsesReasoningProtocolPrefix);

  static Map<String, dynamic>? tryDecode(String content) {
    if (!isEncoded(content)) return null;
    try {
      final decoded = jsonDecode(
        content.substring(openAiResponsesReasoningProtocolPrefix.length),
      );
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      return null;
    }
    return null;
  }
}
