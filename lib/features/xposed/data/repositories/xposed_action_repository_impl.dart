import 'package:JsxposedX/features/xposed/data/datasources/xposed_action_datasource.dart';
import 'package:JsxposedX/features/xposed/domain/repositories/xposed_action_repository.dart';

class XposedActionRepositoryImpl implements XposedActionRepository {
  final XposedActionDatasource _dataSource;

  XposedActionRepositoryImpl({required XposedActionDatasource dataSource})
    : _dataSource = dataSource;

  @override
  Future<void> createJsScript({
    required String packageName,
    required String localPath,
    required String content,
    bool append = false,
  }) async {
    await _dataSource.createJsScript(
      packageName: packageName,
      localPath: localPath,
      content: content,
      append: append,
    );
  }

  @override
  Future<void> deleteJsScript({
    required String packageName,
    required String localPath,
  }) async {
    await _dataSource.deleteJsScript(
      packageName: packageName,
      localPath: localPath,
    );
  }

  @override
  Future<void> importJsScripts({
    required String packageName,
    required List<String> localPaths,
  }) async {
    await _dataSource.importJsScripts(
      packageName: packageName,
      localPaths: localPaths,
    );
  }

  @override
  Future<void> setJsScriptStatus({
    required String packageName,
    required String localPath,
    required bool status,
  }) async {
    await _dataSource.setJsScriptStatus(
      packageName: packageName,
      localPath: localPath,
      status: status,
    );
  }
}
