import 'package:JsxposedX/core/utils/path_utils.dart';
import 'package:JsxposedX/generated/pinia.g.dart';
import 'package:JsxposedX/generated/project.g.dart';

class XposedActionDatasource {
  final _native = ProjectNative();
  final _piniaNative = PiniaNative();

  Future<void> createJsScript({
    required String packageName,
    required String localPath,
    required String content,
    bool append = false,
  }) async {
    await _native.createJsScript(
      packageName,
      content,
      PathUtils.getName(path: localPath),
      append,
    );
  }

  Future<void> deleteJsScript({
    required String packageName,
    required String localPath,
  }) async {
    await _native.deleteJsScript(
      packageName,
      PathUtils.getName(path: localPath),
    );
    await _piniaNative.remove(
      key: "xposed_check_status_${packageName}_$localPath",
    );
  }

  Future<void> importJsScripts({
    required String packageName,
    required List<String> localPaths,
  }) async {
    await _native.importJsScripts(packageName, localPaths);
  }

  Future<void> setJsScriptStatus({
    required String packageName,
    required String localPath,
    required bool status,
  }) async {
    await _piniaNative.setBool(
      key: "xposed_check_status_${packageName}_$localPath",
      value: status,
    );
  }
}
