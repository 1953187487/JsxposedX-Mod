import 'package:pigeon/pigeon.dart';

/// Dhizuku 免 root 权限链路状态。
class DhizukuStatus {
  /// 设备上是否安装了 Dhizuku。
  final bool installed;

  /// Dhizuku 是否已激活为设备所有者且服务可用。
  final bool activated;

  /// 本应用是否已获得 Dhizuku 授权。
  final bool permissionGranted;

  /// 当前设备所有者应用包名。
  final String ownerPackage;

  /// Dhizuku 服务端 API 版本名。
  final String serverVersionName;

  /// Dhizuku 服务端 API 版本号。
  final int serverVersionCode;

  DhizukuStatus({
    required this.installed,
    required this.activated,
    required this.permissionGranted,
    required this.ownerPackage,
    required this.serverVersionName,
    required this.serverVersionCode,
  });
}

@HostApi()
abstract class DhizukuNative {
  /// 读取 Dhizuku 安装、激活与授权状态。
  @async
  DhizukuStatus getStatus();

  /// 请求 Dhizuku 授权，返回用户是否授予权限。
  @async
  bool requestPermission();

  /// 打开 Dhizuku 应用，未安装时返回 false。
  bool openDhizuku();

  /// 打开 Dhizuku 发布页。
  bool openDownloadPage();
}
