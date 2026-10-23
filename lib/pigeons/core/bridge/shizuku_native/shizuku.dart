import 'package:pigeon/pigeon.dart';

/// Shizuku 免 root 权限链路状态。
class ShizukuStatus {
  /// 设备上是否安装了 Shizuku。
  final bool installed;

  /// Shizuku 服务是否正在运行。
  final bool running;

  /// 本应用是否已获得 Shizuku 授权。
  final bool permissionGranted;

  /// 是否运行在 Android 11 以下版本（不支持）。
  final bool isPreV11;

  /// Shizuku 服务端版本号。
  final int version;

  /// Shizuku SELinux 上下文。
  final String selinuxContext;

  ShizukuStatus({
    required this.installed,
    required this.running,
    required this.permissionGranted,
    required this.isPreV11,
    required this.version,
    required this.selinuxContext,
  });
}

@HostApi()
abstract class ShizukuNative {
  /// 读取 Shizuku 安装、运行与授权状态。
  @async
  ShizukuStatus getStatus();

  /// 请求 Shizuku 授权，返回用户是否授予权限。
  @async
  bool requestPermission();

  /// 打开 Shizuku 应用，未安装时返回 false。
  bool openShizuku();

  /// 打开 Shizuku 发布页。
  bool openDownloadPage();
}
