class PathUtils {
  PathUtils._();

  static String getName({required String path, bool isXposedScript = false}) {
    String fileName = path.split('/').last;
    if (isXposedScript) {
      return fileName.replaceAll(RegExp(r'\[.*?\]'), ''); // 移除方括号及其内容
    }
    return fileName;
  }

  //xposed脚本的类型

  static String? getType(String name) {
    return RegExp(r'\[(.*?)\]').firstMatch(name)?.group(1);
  }
}
