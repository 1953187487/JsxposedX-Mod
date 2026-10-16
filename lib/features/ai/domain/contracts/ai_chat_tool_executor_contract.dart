import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';

abstract class AiChatToolExecutorContract {
  Future<AiToolResult> execute(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  });
}
