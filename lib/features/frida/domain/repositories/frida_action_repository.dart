abstract class FridaActionRepository {
  /// 创建 Frida 脚本
  Future<void> createFridaScript({
    required String packageName,
    required String localPath,
    required String content,
    bool append = false,
  });

  /// 删除 Frida 脚本
  Future<void> deleteFridaScript({
    required String packageName,
    required String localPath,
  });

  Future<void> importFridaScripts({
    required String packageName,
    required List<String> localPaths,
  });

  Future<void> setFridaScriptStatus({
    required String packageName,
    required String localPath,
    required bool enabled,
  });

  Future<void> bundleFridaHookJs({required String packageName});

  /// 获取包级 Frida target 状态（config.json.targets）
  Future<bool> getFridaTargetStatus({required String packageName});

  /// 设置包级 Frida target 状态（config.json.targets）
  Future<void> setFridaTargetStatus({
    required String packageName,
    required bool enabled,
  });
}
