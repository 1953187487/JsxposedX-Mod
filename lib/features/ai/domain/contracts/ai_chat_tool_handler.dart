import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';

abstract class AiChatToolHandler {
  String get toolName;

  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  });
}
