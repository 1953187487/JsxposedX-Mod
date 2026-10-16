import 'package:JsxposedX/core/models/audit_log.dart';
import 'package:JsxposedX/features/project/data/datasources/project_action_datasource.dart';
import 'package:JsxposedX/features/project/data/repositories/project_action_repository_impl.dart';
import 'package:JsxposedX/features/project/domain/repositories/project_action_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_action_provider.g.dart';

@riverpod
ProjectActionDatasource projectActionDatasource(Ref ref) {
  return ProjectActionDatasource();
}

@riverpod
ProjectActionRepository projectActionRepository(Ref ref) {
  final dataSource = ref.watch(projectActionDatasourceProvider);
  return ProjectActionRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<void> initProject(Ref ref) async {
  await ref.read(projectActionRepositoryProvider).initProject();
}

@riverpod
Future<void> createProject(Ref ref, {required String packageName}) async {
  await ref
      .read(projectActionRepositoryProvider)
      .createProject(packageName: packageName);
}

@riverpod
Future<void> deleteProject(Ref ref, {required String packageName}) async {
  await ref
      .read(projectActionRepositoryProvider)
      .deleteProject(packageName: packageName);
}

@riverpod
Future<void> deleteAuditLog(
  Ref ref, {
  required String packageName,
  required int timestamp,
}) async {
  await ref
      .read(projectActionRepositoryProvider)
      .deleteAuditLog(packageName: packageName, timestamp: timestamp);
}

@riverpod
Future<void> updateAuditLog(
  Ref ref, {
  required String packageName,
  required AuditLog log,
}) async {
  await ref
      .read(projectActionRepositoryProvider)
      .updateAuditLog(packageName: packageName, log: log);
}

@riverpod
Future<void> clearAuditLogs(Ref ref, {required String packageName}) async {
  await ref
      .read(projectActionRepositoryProvider)
      .clearAuditLogs(packageName: packageName);
}

@riverpod
Future<void> saveAuditLogJsCode(
  Ref ref, {
  required String packageName,
  required String code,
}) async {
  await ref
      .read(projectActionRepositoryProvider)
      .saveAuditLogJsCode(packageName: packageName, code: code);
}
