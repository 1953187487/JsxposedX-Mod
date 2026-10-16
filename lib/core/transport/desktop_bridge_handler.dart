import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:JsxposedX/core/transport/android_desktop_bridge_server.dart';
import 'package:JsxposedX/generated/desktop_bridge.g.dart';

/// 实现 Pigeon 的 DesktopBridgeFlutterApi，处理来自原生层的桥接请求
class DesktopBridgeHandler extends DesktopBridgeFlutterApi {
  DesktopBridgeHandler(this.container);

  final ProviderContainer container;

  @override
  Future<DesktopBridgeResponse> handleRequest(DesktopBridgeRequest request) async {
    try {
      debugPrint('[DesktopBridge] Handling request: ${request.method}');
      
      final server = AndroidDesktopBridgeServer.instance;
      final result = await server.handleRequestFromNative(request.method, request.params);
      
      return DesktopBridgeResponse(
        ok: true,
        result: result,
      );
    } catch (error, stackTrace) {
      debugPrint('[DesktopBridge] Request failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      
      return DesktopBridgeResponse(
        ok: false,
        errorCode: 'REQUEST_FAILED',
        errorMessage: error.toString(),
      );
    }
  }
}

/// 在前台服务中注册 Dart 端处理器
void setupDesktopBridgeHandler(ProviderContainer container) {
  DesktopBridgeFlutterApi.setUp(DesktopBridgeHandler(container));
  debugPrint('[DesktopBridge] Handler registered');
}
