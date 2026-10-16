import 'package:JsxposedX/features/frida/data/datasources/frida_query_datasource.dart';
import 'package:JsxposedX/features/frida/domain/repositories/frida_query_repository.dart';

class FridaQueryRepositoryImpl implements FridaQueryRepository {
  final FridaQueryDatasource _dataSource;

  FridaQueryRepositoryImpl({required FridaQueryDatasource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<String>> getFridaScripts({required String packageName}) async {
    return await _dataSource.getFridaScripts(packageName: packageName);
  }

  @override
  Future<String> readFridaScript({
    required String packageName,
    required String localPath,
  }) async {
    return await _dataSource.readFridaScript(
      packageName: packageName,
      localPath: localPath,
    );
  }

  @override
  Future<bool> getFridaScriptStatus({
    required String packageName,
    required String localPath,
  }) async {
    return await _dataSource.getFridaScriptStatus(
      packageName: packageName,
      localPath: localPath,
    );
  }

  @override
  Future<bool> isZygiskModuleInstalled() async {
    return await _dataSource.isZygiskModuleInstalled();
  }
}
