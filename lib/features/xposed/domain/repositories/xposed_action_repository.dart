abstract class XposedActionRepository {
  /// 创建 JS 脚本
  Future<void> createJsScript({
    required String packageName,
    required String localPath,
    required String content,
    bool append = false,
  });

  /// 删除 JS 脚本
  Future<void> deleteJsScript({
    required String packageName,
    required String localPath,
  });

  Future<void> importJsScripts({
    required String packageName,
    required List<String> localPaths,
  });

  Future<void> setJsScriptStatus({
    required String packageName,
    required String localPath,
    required bool status,
  });
}
