import 'dart:ui';

import 'package:JsxposedX/features/overlay_window/domain/models/overlay_host_layout.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_payload.dart';

abstract class OverlayWindowActionRepository {
  Future<bool> requestPermission();

  Future<void> showOverlayHost({
    required OverlayHostLayout layout,
    required String notificationTitle,
    required String notificationContent,
  });

  Future<bool> updateOverlayHost(OverlayHostLayout layout);

  Future<bool> moveOverlay(Offset position);

  Future<void> sharePayload(OverlayWindowPayload payload);

  Future<bool> closeOverlay();
}
