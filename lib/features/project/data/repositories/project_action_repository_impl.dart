import 'package:JsxposedX/core/models/audit_log.dart';
import 'package:JsxposedX/features/project/data/datasources/project_action_datasource.dart';
import 'package:JsxposedX/features/project/data/models/audit_log_dto.dart';
import 'package:JsxposedX/features/project/domain/repositories/project_action_repository.dart';

class ProjectActionRepositoryImpl implements ProjectActionRepository {
  final ProjectActionDatasource _dataSource;

  ProjectActionRepositoryImpl({required ProjectActionDatasource dataSource})
    : _dataSource = dataSource;

  @override
  Future<void> initProject() async {
    await _dataSource.initProject();
  }

  @override
  Future<void> createProject({required String packageName}) async {
    await _dataSource.createProject(packageName: packageName);
  }

  @override
  Future<void> deleteProject({required String packageName}) async {
    await _dataSource.deleteProject(packageName: packageName);
  }


  @override
  Future<void> deleteAuditLog({
    required String packageName,
    required int timestamp,
  }) async {
    await _dataSource.deleteAuditLog(
      packageName: packageName,
      timestamp: timestamp,
    );
  }

  @override
  Future<void> updateAuditLog({
    required String packageName,
    required AuditLog log,
  }) async {
    final dto = AuditLogDto(
      algorithm: log.algorithm,
      operation: log.operation,
      key: log.key,
      keyBase64: log.keyBase64,
      keyPlaintext: log.keyPlaintext,
      iv: log.iv ?? '',
      ivBase64: log.ivBase64 ?? '',
      ivPlaintext: log.ivPlaintext ?? '',
      input: log.input,
      inputBase64: log.inputBase64,
      output: log.output,
      outputBase64: log.outputBase64,
      inputHex: log.inputHex,
      outputHex: log.outputHex,
      stackTrace: log.stackTrace,
      fingerprint: log.fingerprint,
      timestamp: log.timestamp,
    );
    await _dataSource.updateAuditLog(packageName: packageName, log: dto);
  }

  @override
  Future<void> clearAuditLogs({required String packageName}) async {
    await _dataSource.clearAuditLogs(packageName: packageName);
  }

  @override
  Future<void> saveAuditLogJsCode({
    required String packageName,
    required String code,
  }) async {
    await _dataSource.saveAuditLogJsCode(packageName: packageName, code: code);
  }
}
