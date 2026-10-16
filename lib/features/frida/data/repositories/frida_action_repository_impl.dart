import 'package:JsxposedX/features/frida/data/datasources/frida_action_datasource.dart';
import 'package:JsxposedX/features/frida/domain/repositories/frida_action_repository.dart';

class FridaActionRepositoryImpl implements FridaActionRepository {
  final FridaActionDatasource _dataSource;

  FridaActionRepositoryImpl({required FridaActionDatasource dataSource})
    : _dataSource = dataSource;

  @override
  Future<void> createFridaScript({
    required String packageName,
    required String localPath,
    required String content,
    bool append = false,
  }) async {
    await _dataSource.createFridaScript(
      packageName: packageName,
      localPath: localPath,
      content: content,
      append: append,
    );
  }

  @override
  Future<void> deleteFridaScript({
    required String packageName,
    required String localPath,
  }) async {
    await _dataSource.deleteFridaScript(
      packageName: packageName,
      localPath: localPath,
    );
  }

  @override
  Future<void> importFridaScripts({
    required String packageName,
    required List<String> localPaths,
  }) async {
    await _dataSource.importFridaScripts(
      packageName: packageName,
      localPaths: localPaths,
    );
  }

  @override
  Future<void> setFridaScriptStatus({
    required String packageName,
    required String localPath,
    required bool enabled,
  }) async {
    await _dataSource.setFridaScriptStatus(
      packageName: packageName,
      localPath: localPath,
      enabled: enabled,
    );
  }

  @override
  Future<void> bundleFridaHookJs({required String packageName}) async {
    await _dataSource.bundleFridaHookJs(packageName: packageName);
  }

  @override
  Future<bool> getFridaTargetStatus({required String packageName}) async {
    final installed = await _dataSource.isZygiskModuleInstalled();
    if (!installed) {
      throw StateError("Zygisk Frida module not installed");
    }
    return await _dataSource.isZygiskTargetEnabled(packageName: packageName);
  }

  @override
  Future<void> setFridaTargetStatus({
    required String packageName,
    required bool enabled,
  }) async {
    final installed = await _dataSource.isZygiskModuleInstalled();
    if (!installed) {
      throw StateError("Zygisk Frida module not installed");
    }

    final code = await _dataSource.setZygiskTargetEnabled(
      packageName: packageName,
      enabled: enabled,
    );

    if (code == 0) {
      return;
    }
    if (code == 1) {
      throw StateError("Zygisk Frida module not ready");
    }
    if (code == 2) {
      throw StateError("Failed to read config.json");
    }
    if (code == 3) {
      throw StateError("Failed to write config.json");
    }
    throw StateError("Unknown setTargetEnabled code: $code");
  }
}
