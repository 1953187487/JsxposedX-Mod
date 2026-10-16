import 'dart:async';
import 'dart:ui';

import 'package:JsxposedX/features/overlay_window/domain/models/overlay_viewport_metrics.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_runtime_message.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_status.dart';

abstract class OverlayWindowQueryRepository {
  bool get isSupportedPlatform;

  Stream<OverlayWindowRuntimeMessage> get overlayEvents;

  Future<bool> isPermissionGranted();

  Future<bool> isActive();

  Future<Offset> getOverlayPosition();

  Future<OverlayViewportMetrics> getOverlayViewportMetrics();

  Future<OverlayWindowStatus> getStatus();
}
