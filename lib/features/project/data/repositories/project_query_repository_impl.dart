import 'dart:typed_data';

import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/core/models/audit_log.dart';
import 'package:JsxposedX/features/project/data/datasources/project_query_datasource.dart';
import 'package:JsxposedX/features/project/domain/repositories/project_query_repository.dart';

class ProjectQueryRepositoryImpl implements ProjectQueryRepository {
  final ProjectQueryDatasource _dataSource;

  ProjectQueryRepositoryImpl({required ProjectQueryDatasource dataSource})
    : _dataSource = dataSource;

  @override
  Future<bool> projectExists({required String packageName}) async {
    return await _dataSource.projectExists(packageName: packageName);
  }


  @override
  Future<List<AppInfo>> getProjects() async {
    final pigeonList = await _dataSource.getProjects();
    return pigeonList
        .map(
          (p) => AppInfo(
            name: p.name,
            packageName: p.packageName,
            versionName: p.versionName,
            versionCode: p.versionCode,
            isSystemApp: p.isSystemApp,
            icon: p.icon ?? Uint8List(0),
          ),
        )
        .toList();
  }

  @override
  Future<List<AuditLog>> getAuditLogs({
    required String packageName,
    required int limit,
    required int offset,
    String? keyword,
  }) async {
    final dtos = await _dataSource.getAuditLogs(
      packageName: packageName,
      limit: limit,
      offset: offset,
      keyword: keyword,
    );
    return dtos
        .map(
          (e) => AuditLog(
            algorithm: e.algorithm,
            operation: e.operation,
            key: e.key,
            keyBase64: e.keyBase64,
            keyPlaintext: e.keyPlaintext,
            iv: e.iv.isEmpty ? null : e.iv,
            ivBase64: e.ivBase64.isEmpty ? null : e.ivBase64,
            ivPlaintext: e.ivPlaintext.isEmpty ? null : e.ivPlaintext,
            input: e.input,
            inputBase64: e.inputBase64,
            output: e.output,
            outputBase64: e.outputBase64,
            inputHex: e.inputHex,
            outputHex: e.outputHex,
            stackTrace: e.stackTrace,
            fingerprint: e.fingerprint,
            timestamp: e.timestamp,
          ),
        )
        .toList();
  }

  @override
  Future<String> getAuditLogJsCode({required String packageName}) async {
    return await _dataSource.getAuditLogJsCode(packageName: packageName);
  }
}
