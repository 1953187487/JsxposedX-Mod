import 'package:JsxposedX/core/utils/path_utils.dart';
import 'package:JsxposedX/generated/pinia.g.dart';
import 'package:JsxposedX/generated/project.g.dart';

class XposedQueryDatasource {
  final _native = ProjectNative();
  final _piniaNative = PiniaNative();

  Future<String> readJsScript({
    required String packageName,
    required String localPath,
  }) async {
    return await _native.readJsScript(
      packageName,
      PathUtils.getName(path: localPath),
    );
  }

  Future<List<String>> getJsScripts({required String packageName}) async {
    return await _native.getJsScripts(packageName);
  }

  Future<bool> getJsScriptStatus({
    required String packageName,
    required String localPath,
  }) async {
    return await _piniaNative.getBool(
      key: "xposed_check_status_${packageName}_$localPath",
      defaultValue: false,
    );
  }
}
