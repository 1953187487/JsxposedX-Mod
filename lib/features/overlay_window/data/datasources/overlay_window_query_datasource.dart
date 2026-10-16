import 'package:JsxposedX/features/overlay_window/data/datasources/overlay_window_platform_gateway.dart';
import 'package:JsxposedX/features/overlay_window/data/models/overlay_viewport_metrics_dto.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayWindowQueryDatasource {
  const OverlayWindowQueryDatasource({
    required OverlayWindowPlatformGateway gateway,
  }) : _gateway = gateway;

  final OverlayWindowPlatformGateway _gateway;

  Stream<dynamic> get overlayEvents => _gateway.overlayListener;

  Future<bool> isPermissionGranted() => _gateway.isPermissionGranted();

  Future<bool> isActive() => _gateway.isActive();

  Future<OverlayPosition> getOverlayPosition() => _gateway.getOverlayPosition();

  Future<OverlayViewportMetricsDto> getOverlayViewportMetrics() async {
    final metrics = await _gateway.getOverlayViewportMetrics();
    return OverlayViewportMetricsDto.fromPlugin(metrics);
  }
}
