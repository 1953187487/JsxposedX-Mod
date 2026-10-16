import 'package:flutter_overlay_window/flutter_overlay_window.dart';

abstract class OverlayWindowPlatformGateway {
  Stream<dynamic> get overlayListener;

  Future<bool> isPermissionGranted();

  Future<bool?> requestPermission();

  Future<bool> isActive();

  Future<void> showOverlay({
    required int width,
    required int height,
    required OverlayPosition position,
    required bool enableDrag,
    required OverlayFlag flag,
    required String overlayTitle,
    required String overlayContent,
  });

  Future<bool?> updateOverlayLayout({
    required int width,
    required int height,
    required OverlayPosition position,
    required bool enableDrag,
    required OverlayFlag flag,
  });

  Future<bool?> moveOverlay(OverlayPosition position);

  Future<OverlayPosition> getOverlayPosition();

  Future<OverlayViewportMetrics> getOverlayViewportMetrics();

  Future<void> shareData(dynamic data);

  Future<bool?> closeOverlay();
}

class FlutterOverlayWindowPlatformGateway
    implements OverlayWindowPlatformGateway {
  const FlutterOverlayWindowPlatformGateway();

  @override
  Stream<dynamic> get overlayListener => FlutterOverlayWindow.overlayListener;

  @override
  Future<bool?> closeOverlay() {
    return FlutterOverlayWindow.closeOverlay();
  }

  @override
  Future<OverlayPosition> getOverlayPosition() {
    return FlutterOverlayWindow.getOverlayPosition();
  }

  @override
  Future<OverlayViewportMetrics> getOverlayViewportMetrics() {
    return FlutterOverlayWindow.getOverlayViewportMetrics();
  }

  @override
  Future<bool> isActive() {
    return FlutterOverlayWindow.isActive();
  }

  @override
  Future<bool> isPermissionGranted() {
    return FlutterOverlayWindow.isPermissionGranted();
  }

  @override
  Future<bool?> moveOverlay(OverlayPosition position) {
    return FlutterOverlayWindow.moveOverlay(position);
  }

  @override
  Future<bool?> requestPermission() {
    return FlutterOverlayWindow.requestPermission();
  }

  @override
  Future<void> shareData(dynamic data) {
    return FlutterOverlayWindow.shareData(data);
  }

  @override
  Future<void> showOverlay({
    required int width,
    required int height,
    required OverlayPosition position,
    required bool enableDrag,
    required OverlayFlag flag,
    required String overlayTitle,
    required String overlayContent,
  }) {
    return FlutterOverlayWindow.showOverlay(
      width: width,
      height: height,
      alignment: OverlayAlignment.topLeft,
      positionGravity: PositionGravity.none,
      enableDrag: enableDrag,
      flag: flag,
      visibility: NotificationVisibility.visibilityPublic,
      overlayTitle: overlayTitle,
      overlayContent: overlayContent,
      startPosition: position,
    );
  }

  @override
  Future<bool?> updateOverlayLayout({
    required int width,
    required int height,
    required OverlayPosition position,
    required bool enableDrag,
    required OverlayFlag flag,
  }) {
    return FlutterOverlayWindow.updateOverlayLayout(
      width: width,
      height: height,
      position: position,
      enableDrag: enableDrag,
      flag: flag,
    );
  }
}
