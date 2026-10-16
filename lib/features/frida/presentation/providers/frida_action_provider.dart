import 'package:JsxposedX/features/frida/data/datasources/frida_action_datasource.dart';
import 'package:JsxposedX/features/frida/data/repositories/frida_action_repository_impl.dart';
import 'package:JsxposedX/features/frida/domain/repositories/frida_action_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'frida_action_provider.g.dart';

@riverpod
FridaActionDatasource fridaActionDatasource(Ref ref) {
  return FridaActionDatasource();
}

@riverpod
FridaActionRepository fridaActionRepository(Ref ref) {
  final dataSource = ref.watch(fridaActionDatasourceProvider);
  return FridaActionRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<void> createFridaScript(
  Ref ref, {
  required String packageName,
  required String localPath,
  required String content,
  bool append = false,
}) async {
  await ref
      .read(fridaActionRepositoryProvider)
      .createFridaScript(
        packageName: packageName,
        localPath: localPath,
        content: content,
        append: append,
      );
}

@riverpod
Future<void> deleteFridaScript(
  Ref ref, {
  required String packageName,
  required String localPath,
}) async {
  await ref
      .read(fridaActionRepositoryProvider)
      .deleteFridaScript(packageName: packageName, localPath: localPath);
}

@riverpod
Future<void> importFridaScripts(
  Ref ref, {
  required String packageName,
  required List<String> localPaths,
}) async {
  await ref
      .read(fridaActionRepositoryProvider)
      .importFridaScripts(packageName: packageName, localPaths: localPaths);
}

@riverpod
Future<void> setFridaScriptStatus(
  Ref ref, {
  required String packageName,
  required String localPath,
  required bool enabled,
}) async {
  await ref
      .read(fridaActionRepositoryProvider)
      .setFridaScriptStatus(
        packageName: packageName,
        localPath: localPath,
        enabled: enabled,
      );
}

@riverpod
Future<void> bundleFridaHookJs(
  Ref ref, {
  required String packageName,
}) async {
  await ref
      .read(fridaActionRepositoryProvider)
      .bundleFridaHookJs(packageName: packageName);
}

@riverpod
Future<bool> getFridaTargetStatus(
  Ref ref, {
  required String packageName,
}) async {
  return await ref
      .read(fridaActionRepositoryProvider)
      .getFridaTargetStatus(packageName: packageName);
}

@riverpod
Future<void> setFridaTargetStatus(
  Ref ref, {
  required String packageName,
  required bool enabled,
}) async {
  await ref
      .read(fridaActionRepositoryProvider)
      .setFridaTargetStatus(packageName: packageName, enabled: enabled);
}
