/// Function Calling 工具定义模型
class AiToolDefinition {
  final String name;
  final String description;
  final String descriptionEn;
  final Map<String, dynamic> parameters;
  final bool isRisky;

  const AiToolDefinition({
    required this.name,
    required this.description,
    this.descriptionEn = '',
    required this.parameters,
    this.isRisky = false,
  });

  /// 转为 OpenAI Function Calling 格式
  Map<String, dynamic> toOpenAiToolJson() => {
        'type': 'function',
        'function': {
          'name': name,
          'description': description,
          'parameters': parameters,
        },
      };

  /// 转为 Anthropic Messages API tools 格式
  Map<String, dynamic> toAnthropicToolJson() => {
        'name': name,
        'description': description,
        'input_schema': parameters,
      };

  /// 兼容旧调用方，默认输出 OpenAI 格式。
  Map<String, dynamic> toFunctionJson() => toOpenAiToolJson();
}

/// 参数 JSON Schema 构建器
class ToolParametersBuilder {
  final Map<String, Map<String, dynamic>> _properties = {};
  final List<String> _required = [];

  ToolParametersBuilder addString(
    String name,
    String description, {
    bool required = false,
    List<String>? enumValues,
  }) {
    final prop = <String, dynamic>{
      'type': 'string',
      'description': description,
    };
    if (enumValues != null) prop['enum'] = enumValues;
    _properties[name] = prop;
    if (required) _required.add(name);
    return this;
  }

  ToolParametersBuilder addInteger(
    String name,
    String description, {
    bool required = false,
  }) {
    _properties[name] = {
      'type': 'integer',
      'description': description,
    };
    if (required) _required.add(name);
    return this;
  }

  ToolParametersBuilder addBoolean(
    String name,
    String description, {
    bool required = false,
  }) {
    _properties[name] = {
      'type': 'boolean',
      'description': description,
    };
    if (required) _required.add(name);
    return this;
  }

  ToolParametersBuilder addStringArray(
    String name,
    String description, {
    bool required = false,
  }) {
    _properties[name] = {
      'type': 'array',
      'description': description,
      'items': {'type': 'string'},
    };
    if (required) _required.add(name);
    return this;
  }

  /// 无参数
  static Map<String, dynamic> empty() => {
        'type': 'object',
        'properties': <String, dynamic>{},
        'required': <String>[],
      };

  Map<String, dynamic> build() => {
        'type': 'object',
        'properties': Map<String, dynamic>.from(_properties),
        'required': List<String>.from(_required),
      };
}
