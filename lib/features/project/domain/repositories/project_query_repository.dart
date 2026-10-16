import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/core/models/audit_log.dart';

abstract class ProjectQueryRepository {
  /// 检查应用是否已创建项目
  Future<bool> projectExists({required String packageName});


  /// 获取所有项目列表
  Future<List<AppInfo>> getProjects();

  /// 获取审计日志列表
  Future<List<AuditLog>> getAuditLogs({
    required String packageName,
    required int limit,
    required int offset,
    String? keyword,
  });

  Future<String> getAuditLogJsCode({required String packageName});
}
