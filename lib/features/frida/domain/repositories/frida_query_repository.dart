abstract class FridaQueryRepository {
  Future<List<String>> getFridaScripts({required String packageName});

  Future<String> readFridaScript({
    required String packageName,
    required String localPath,
  });

  Future<bool> getFridaScriptStatus({
    required String packageName,
    required String localPath,
  });
  Future<bool> isZygiskModuleInstalled();
}