import 'package:JsxposedX/features/xposed/data/datasources/xposed_action_datasource.dart';
import 'package:JsxposedX/features/xposed/data/repositories/xposed_action_repository_impl.dart';
import 'package:JsxposedX/features/xposed/domain/repositories/xposed_action_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'xposed_action_provider.g.dart';

@riverpod
XposedActionDatasource xposedActionDatasource(Ref ref) {
  return XposedActionDatasource();
}

@riverpod
XposedActionRepository xposedActionRepository(Ref ref) {
  final dataSource = ref.watch(xposedActionDatasourceProvider);
  return XposedActionRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<void> createJsScript(
  Ref ref, {
  required String packageName,
  required String localPath,
  required String content,
  bool append = false,
}) async {
  await ref
      .read(xposedActionRepositoryProvider)
      .createJsScript(
        packageName: packageName,
        localPath: localPath,
        content: content,
        append: append,
      );
}

@riverpod
Future<void> deleteJsScript(
  Ref ref, {
  required String packageName,
  required String localPath,
}) async {
  await ref
      .read(xposedActionRepositoryProvider)
      .deleteJsScript(packageName: packageName, localPath: localPath);
}

@riverpod
Future<void> importJsScripts(
  Ref ref, {
  required String packageName,
  required List<String> localPaths,
}) async {
  await ref
      .read(xposedActionRepositoryProvider)
      .importJsScripts(packageName: packageName, localPaths: localPaths);
}

@riverpod
Future<void> setJsScriptStatus(
  Ref ref, {
  required String packageName,
  required String localPath,
  required bool status,
}) async {
  await ref
      .read(xposedActionRepositoryProvider)
      .setJsScriptStatus(
        packageName: packageName,
        localPath: localPath,
        status: status,
      );
}
