import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/features/app/data/datasources/app_query_datasource.dart';
import 'package:JsxposedX/features/app/data/repositories/app_query_repository_impl.dart';
import 'package:JsxposedX/features/app/domain/repositories/app_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_query_provider.g.dart';

@riverpod
AppQueryDatasource appQueryDatasource(Ref ref) {
  return AppQueryDatasource();
}

@riverpod
AppQueryRepository appQueryRepository(Ref ref) {
  final dataSource = ref.watch(appQueryDatasourceProvider);
  return AppQueryRepositoryImpl(dataSource: dataSource);
}

/// 获取应用列表
@riverpod
Future<List<AppInfo>> installedApps(
  Ref ref, {
  bool includeSystemApps = false,
}) async {
  final result = await ref
      .watch(appQueryRepositoryProvider)
      .getInstalledApps(
        includeSystemApps: includeSystemApps,
        offset: 0,
        limit: 1000,
      );

  return result.map((e) => e.toEntity()).toList();
}

@riverpod
Future<AppInfo?> getAppByPackageName(Ref ref, {required String packageName}) async {
  return await ref
      .watch(appQueryRepositoryProvider)
      .getAppByPackageName(packageName: packageName);
}
