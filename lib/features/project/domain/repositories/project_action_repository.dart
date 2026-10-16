import 'package:JsxposedX/core/models/audit_log.dart';

abstract class ProjectActionRepository {
  /// 初始化项目根目录
  Future<void> initProject();

  /// 创建应用关联项目
  Future<void> createProject({required String packageName});

  /// 删除应用关联项目
  Future<void> deleteProject({required String packageName});


  /// 删除审计日志
  Future<void> deleteAuditLog({
    required String packageName,
    required int timestamp,
  });

  /// 更新审计日志
  Future<void> updateAuditLog({
    required String packageName,
    required AuditLog log,
  });

  /// 清空审计日志
  Future<void> clearAuditLogs({required String packageName});

  Future<void> saveAuditLogJsCode({
    required String packageName,
    required String code,
  });
}
