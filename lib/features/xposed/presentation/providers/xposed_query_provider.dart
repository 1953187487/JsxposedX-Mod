import 'package:JsxposedX/features/xposed/data/datasources/xposed_query_datasource.dart';
import 'package:JsxposedX/features/xposed/data/repositories/xposed_query_repository_impl.dart';
import 'package:JsxposedX/features/xposed/domain/repositories/xposed_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'xposed_query_provider.g.dart';

@riverpod
XposedQueryDatasource xposedQueryDatasource(Ref ref) {
  return XposedQueryDatasource();
}

@riverpod
XposedQueryRepository xposedQueryRepository(Ref ref) {
  final dataSource = ref.watch(xposedQueryDatasourceProvider);
  return XposedQueryRepositoryImpl(dataSource: dataSource);
}

@Riverpod(keepAlive: true)
Future<List<String>> jsScripts(Ref ref, {required String packageName}) async {
  return await ref
      .watch(xposedQueryRepositoryProvider)
      .getJsScripts(packageName: packageName);
}
@riverpod
Future<String> readJsScript(
    Ref ref, {
      required String packageName,
      required String localPath,
    }) async {
  return await ref
      .watch(xposedQueryRepositoryProvider)
      .readJsScript(packageName: packageName, localPath: localPath);
}
@riverpod
Future<bool> getJsScriptStatus(
  Ref ref, {
  required String packageName,
  required String localPath,
}) async {
  return await ref
      .watch(xposedQueryRepositoryProvider)
      .getJsScriptStatus(packageName: packageName, localPath: localPath);
}
