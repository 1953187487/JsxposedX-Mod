abstract class XposedQueryRepository {
  Future<String> readJsScript({
    required String packageName,
    required String localPath,
  });

  /// 获取 JS 脚本列表
  Future<List<String>> getJsScripts({required String packageName});

  Future<bool> getJsScriptStatus({
    required String packageName,
    required String localPath,
  });

}
