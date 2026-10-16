import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tools_spec.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';

class AiChatToolCatalog implements AiChatToolsSpec {
  const AiChatToolCatalog({
    required this.definitions,
  });

  final List<AiToolDefinition> definitions;

  @override
  List<Map<String, dynamic>> buildToolsJson({
    required AiApiType apiType,
  }) {
    return definitions
        .map(
          (tool) => switch (apiType) {
            AiApiType.openai => tool.toOpenAiToolJson(),
            AiApiType.openaiResponses => tool.toOpenAiToolJson(),
            AiApiType.anthropic => tool.toAnthropicToolJson(),
          },
        )
        .toList(growable: false);
  }

  @override
  List<AiToolDefinition> get toolDefinitions => definitions;
}
