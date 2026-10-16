import 'dart:ui';

import 'package:JsxposedX/features/overlay_window/domain/models/overlay_viewport_metrics.dart';
import 'package:JsxposedX/features/overlay_window/presentation/utils/overlay_window_geometry.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const viewport = OverlayViewportMetrics(
    width: 400,
    height: 800,
    safePadding: EdgeInsets.fromLTRB(10, 20, 10, 30),
  );

  test('returns default bubble visual offset on the right edge', () {
    final offset = OverlayWindowGeometry.defaultBubbleVisualOffset(
      viewport: viewport,
      bubbleSize: 58,
    );

    expect(offset.dx, 316);
    expect(offset.dy, 366);
  });

  test('clamps bubble visual offset inside safe bounds', () {
    final offset = OverlayWindowGeometry.clampBubbleVisualOffset(
      const Offset(999, -10),
      viewport: viewport,
      bubbleSize: 58,
    );

    expect(offset.dx, 316);
    expect(offset.dy, 36);
  });

  test('snaps bubble visual offset to nearest horizontal edge', () {
    final left = OverlayWindowGeometry.snapBubbleVisualOffset(
      const Offset(40, 100),
      viewport: viewport,
      bubbleSize: 58,
    );
    final right = OverlayWindowGeometry.snapBubbleVisualOffset(
      const Offset(280, 100),
      viewport: viewport,
      bubbleSize: 58,
    );

    expect(left, const Offset(26, 100));
    expect(right, const Offset(316, 100));
  });

  test('converts between visual and host positions', () {
    const visualOffset = Offset(100, 120);

    final hostPosition = OverlayWindowGeometry.hostPositionFromVisualOffset(
      visualOffset,
    );
    final restored = OverlayWindowGeometry.visualOffsetFromHostPosition(
      hostPosition,
    );

    expect(restored, visualOffset);
  });
}
