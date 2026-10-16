import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/core/models/audit_log.dart';
import 'package:JsxposedX/features/project/data/datasources/project_query_datasource.dart';
import 'package:JsxposedX/features/project/data/repositories/project_query_repository_impl.dart';
import 'package:JsxposedX/features/project/domain/repositories/project_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_query_provider.g.dart';

@riverpod
ProjectQueryDatasource projectQueryDatasource(Ref ref) {
  return ProjectQueryDatasource();
}

@riverpod
ProjectQueryRepository projectQueryRepository(Ref ref) {
  final dataSource = ref.watch(projectQueryDatasourceProvider);
  return ProjectQueryRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<bool> projectExists(Ref ref, {required String packageName}) async {
  return await ref
      .watch(projectQueryRepositoryProvider)
      .projectExists(packageName: packageName);
}


@Riverpod(keepAlive: true)
Future<List<AppInfo>> projects(Ref ref) async {
  return await ref.watch(projectQueryRepositoryProvider).getProjects();
}

@riverpod
Future<List<AuditLog>> auditLogs(
  Ref ref, {
  required String packageName,
  required int limit,
  required int offset,
  String? keyword,
}) async {
  return await ref
      .watch(projectQueryRepositoryProvider)
      .getAuditLogs(
        packageName: packageName,
        limit: limit,
        offset: offset,
        keyword: keyword,
      );
}

@riverpod
Future<String> auditLogJsCode(Ref ref, {required String packageName}) {
  return ref
      .watch(projectQueryRepositoryProvider)
      .getAuditLogJsCode(packageName: packageName);
}

