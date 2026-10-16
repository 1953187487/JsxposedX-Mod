class AiThinkingMarkup {
  AiThinkingMarkup._();

  static const String startTag = '<ai-thinking>';
  static const String endTag = '</ai-thinking>';

  static String compose({
    required String thinking,
    required String answer,
    Duration? duration,
  }) {
    final normalizedThinking = thinking.trim();
    final normalizedAnswer = answer.trim();
    if (normalizedThinking.isEmpty) {
      return normalizedAnswer;
    }
    final meta = duration != null
        ? ' duration="${duration.inMilliseconds}"'
        : '';
    final tag = '<ai-thinking$meta>';
    if (normalizedAnswer.isEmpty) {
      return '$tag\n$normalizedThinking\n$endTag';
    }
    return '$tag\n$normalizedThinking\n$endTag\n\n$normalizedAnswer';
  }

  static AiThinkingMarkupParts split(String content) {
    final startMatch = RegExp(r'<ai-thinking(?: duration="(\d+)")?>')
        .firstMatch(content);
    if (startMatch == null) {
      return AiThinkingMarkupParts(answer: content);
    }
    
    final startIndex = startMatch.start;
    final contentStartIndex = startMatch.end;
    final endIndex = content.indexOf(endTag, contentStartIndex);
    
    if (endIndex == -1) {
      // 容错：如果流还没结束，可能没有闭合标签，将剩余全部当做 thinking
      return AiThinkingMarkupParts(
        thinking: content.substring(contentStartIndex).trim(),
        answer: '',
      );
    }

    final durationMs = startMatch.group(1);
    final duration = durationMs != null
        ? Duration(milliseconds: int.parse(durationMs))
        : null;

    final thinking = content
        .substring(contentStartIndex, endIndex)
        .trim();
    final answer = content.substring(endIndex + endTag.length).trimLeft();
    return AiThinkingMarkupParts(
      thinking: thinking,
      answer: answer,
      duration: duration,
    );
  }

  static String strip(String content) => split(content).answer.trim();
}

class AiThinkingMarkupParts {
  const AiThinkingMarkupParts({
    this.thinking = '',
    this.answer = '',
    this.duration,
  });

  final String thinking;
  final String answer;
  final Duration? duration;

  bool get hasThinking => thinking.trim().isNotEmpty;
}
