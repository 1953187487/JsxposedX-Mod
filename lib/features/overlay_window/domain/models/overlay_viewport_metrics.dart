import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_viewport_metrics.freezed.dart';

@freezed
abstract class OverlayViewportMetrics with _$OverlayViewportMetrics {
  const OverlayViewportMetrics._();

  const factory OverlayViewportMetrics({
    required double width,
    required double height,
    required EdgeInsets safePadding,
  }) = _OverlayViewportMetrics;

  Size get size => Size(width, height);
}
