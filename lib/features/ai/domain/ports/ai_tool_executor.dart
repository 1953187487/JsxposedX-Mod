import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

typedef AiToolProgress = void Function(String message);

abstract interface class AiToolExecutor {
  Future<AiToolResult> execute(AiToolCall call, {AiToolProgress? onProgress});
}
