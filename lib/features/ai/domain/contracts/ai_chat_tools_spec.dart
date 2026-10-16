import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';

abstract class AiChatToolsSpec {
  List<Map<String, dynamic>> buildToolsJson({
    required AiApiType apiType,
  });

  /// 返回工具定义列表，用于UI展示每项工具的启用/禁用管理
  List<AiToolDefinition> get toolDefinitions;
}
