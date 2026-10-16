import 'package:pigeon/pigeon.dart';

/// 桌面桥接请求参数
class DesktopBridgeRequest {
  final String method;
  final Map<String, Object?>? params;

  DesktopBridgeRequest({required this.method, this.params});
}

/// 桌面桥接响应结果
class DesktopBridgeResponse {
  final bool ok;
  final Map<String, Object?>? result;
  final String? errorCode;
  final String? errorMessage;

  DesktopBridgeResponse({
    required this.ok,
    this.result,
    this.errorCode,
    this.errorMessage,
  });
}

/// 原生层调用 Dart 层处理桥接请求
@FlutterApi()
abstract class DesktopBridgeFlutterApi {
  /// 处理来自桌面端的请求（项目管理、脚本执行、控制台等复杂操作）
  @async
  DesktopBridgeResponse handleRequest(DesktopBridgeRequest request);
}
