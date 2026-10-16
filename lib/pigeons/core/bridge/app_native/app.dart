import 'package:pigeon/pigeon.dart';

/// 应用信息数据模型 (按照 status_management.dart 的模式定义)
class AppInfo {
  final String name;
  final String packageName;
  final String versionName;
  final int versionCode;
  final bool isSystemApp;
  final Uint8List? icon;

  AppInfo({
    required this.name,
    required this.packageName,
    required this.versionName,
    required this.versionCode,
    required this.isSystemApp,
    this.icon,
  });
}

@HostApi()
abstract class AppNative {
  /// 获取符合条件的已安装应用总数
  int getAppCount(bool includeSystemApps, String query);

  /// 异步分页获取应用列表 (取代半手动的 EventChannel)
  @async
  List<AppInfo> getInstalledApps(
    bool includeSystemApps,
    int offset,
    int limit,
    String query,
  );

  /// 根据包名获取单个应用详情
  @async
  AppInfo? getAppByPackageName(String packageName);

  @async
  void openAppX(String packageName);
}
