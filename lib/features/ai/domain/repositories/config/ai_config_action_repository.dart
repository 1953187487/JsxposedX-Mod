import 'package:JsxposedX/core/models/ai_config.dart';

/// AI 配置操作仓储接口
abstract class AiConfigActionRepository {
  /// 保存配置
  Future<void> saveConfig(AiConfig config);
  
  /// 获取配置列表
  Future<List<AiConfig>> getConfigList();
  
  /// 添加新配置
  Future<void> addConfig(AiConfig config);
  
  /// 更新配置
  Future<void> updateConfig(AiConfig config);
  
  /// 删除配置
  Future<void> deleteConfig(String id);
  
  /// 切换配置
  Future<void> switchConfig(String id);
}
