import 'package:JsxposedX/core/models/ai_message.dart';

class AiChatContextBudgetEstimator {
  const AiChatContextBudgetEstimator();

  int estimateTextTokens(String text, {String? role}) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return 0;
    }

    final lineCount = '\n'.allMatches(normalized).length + 1;
    final codeBlocks = '```'.allMatches(normalized).length ~/ 2;
    final jsonMarkers = RegExp(r'[\{\}\[\]"]').allMatches(normalized).length;
    final pathLike = RegExp(r'([A-Za-z]:\\|/[\w\-.]+|[\w\-.]+\.[A-Za-z]{2,6})')
        .allMatches(normalized)
        .length;
    final roleOverhead = switch (role) {
      'system' => 16,
      'assistant' => 12,
      'tool' => 18,
      _ => 10,
    };

    var estimate = (normalized.runes.length / 3.6).ceil() + roleOverhead;
    estimate += lineCount;
    estimate += codeBlocks * 24;
    estimate += (jsonMarkers / 12).ceil();
    estimate += pathLike * 2;
    return estimate;
  }

  int estimateMessageTokens(AiMessage message) {
    var estimate = estimateTextTokens(message.content, role: message.role);
    if (message.toolCalls != null && message.toolCalls!.isNotEmpty) {
      estimate += estimateTextTokens(
        message.toolCalls.toString(),
        role: 'tool',
      );
    }
    if (message.toolCallId != null && message.toolCallId!.isNotEmpty) {
      estimate += 8;
    }
    return estimate;
  }

  int estimateMessagesTokens(List<AiMessage> messages) {
    var total = 0;
    for (final message in messages) {
      total += estimateMessageTokens(message);
    }
    return total;
  }
}
