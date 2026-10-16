import 'package:JsxposedX/features/frida/data/datasources/frida_query_datasource.dart';
import 'package:JsxposedX/features/frida/data/repositories/frida_query_repository_impl.dart';
import 'package:JsxposedX/features/frida/domain/repositories/frida_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'frida_query_provider.g.dart';

@riverpod
FridaQueryDatasource fridaQueryDatasource(Ref ref) {
  return FridaQueryDatasource();
}

@riverpod
FridaQueryRepository fridaQueryRepository(Ref ref) {
  final dataSource = ref.watch(fridaQueryDatasourceProvider);
  return FridaQueryRepositoryImpl(dataSource: dataSource);
}

@Riverpod(keepAlive: true)
Future<List<String>> fridaScripts(
  Ref ref, {
  required String packageName,
}) async {
  return await ref
      .watch(fridaQueryRepositoryProvider)
      .getFridaScripts(packageName: packageName);
}

@riverpod
Future<String> readFridaScript(
  Ref ref, {
  required String packageName,
  required String localPath,
}) async {
  return await ref
      .watch(fridaQueryRepositoryProvider)
      .readFridaScript(packageName: packageName, localPath: localPath);
}

@riverpod
Future<bool> getFridaScriptStatus(
  Ref ref, {
  required String packageName,
  required String localPath,
}) async {
  return await ref
      .watch(fridaQueryRepositoryProvider)
      .getFridaScriptStatus(packageName: packageName, localPath: localPath);
}

@riverpod
Future<bool> isZygiskModuleInstalled(Ref ref) async {
  return await ref
      .watch(fridaQueryRepositoryProvider)
      .isZygiskModuleInstalled();
}
