import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_tool_executor.dart';

class AiChatSessionEnvironment {
  const AiChatSessionEnvironment({
    required this.id,
    required this.scopeId,
    required this.version,
    required this.systemPrompt,
    this.tools = const [],
    this.toolExecutor,
    this.toolDefinitions = const [],
  });

  final String id;
  final String scopeId;
  final String version;
  final String systemPrompt;
  final List<AiToolSpec> tools;
  final AiToolExecutor? toolExecutor;
  final List<AiToolDefinition> toolDefinitions;
}
