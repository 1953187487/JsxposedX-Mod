/// AI API 提供商类型
enum AiApiType {
  /// OpenAI 兼容 API
  openai,

  /// OpenAI Responses API
  openaiResponses,

  /// Anthropic Claude API
  anthropic;

  /// 获取显示名称
  String get displayName {
    switch (this) {
      case AiApiType.openai:
        return 'OpenAI';
      case AiApiType.openaiResponses:
        return 'OpenAI Responses';
      case AiApiType.anthropic:
        return 'Anthropic';
    }
  }

  /// 从字符串解析
  static AiApiType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'openai':
        return AiApiType.openai;
      case 'openairesponses':
      case 'openai_responses':
      case 'openai-responses':
        return AiApiType.openaiResponses;
      case 'anthropic':
        return AiApiType.anthropic;
      default:
        return AiApiType.openai;
    }
  }
}
