import 'package:JsxposedX/features/xposed/data/datasources/xposed_query_datasource.dart';
import 'package:JsxposedX/features/xposed/domain/repositories/xposed_query_repository.dart';

class XposedQueryRepositoryImpl implements XposedQueryRepository {
  final XposedQueryDatasource _dataSource;

  XposedQueryRepositoryImpl({required XposedQueryDatasource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<String>> getJsScripts({required String packageName}) async {
    return await _dataSource.getJsScripts(packageName: packageName);
  }

  @override
  Future<String> readJsScript({
    required String packageName,
    required String localPath,
  }) async {
    return await _dataSource.readJsScript(
      packageName: packageName,
      localPath: localPath,
    );
  }

  @override
  Future<bool> getJsScriptStatus({
    required String packageName,
    required String localPath,
  }) async {
    return await _dataSource.getJsScriptStatus(
      packageName: packageName,
      localPath: localPath,
    );
  }
}
