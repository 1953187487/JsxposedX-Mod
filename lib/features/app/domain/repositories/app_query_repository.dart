import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/features/app/data/models/app_info_dto.dart';

/// 应用查询操作仓储接口
abstract class AppQueryRepository {
  /// 获取应用总数
  Future<int> getAppCount({bool includeSystemApps = false, String query = ""});

  /// 获取已安装应用列表 (支持分页)
  Future<List<AppInfoDto>> getInstalledApps({
    bool includeSystemApps = false,
    int offset = 0,
    int limit = 50,
    String query = "",
  });

  Future<AppInfo?> getAppByPackageName({required String packageName});
}
