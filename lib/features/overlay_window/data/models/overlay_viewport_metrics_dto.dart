import 'package:JsxposedX/features/overlay_window/domain/models/overlay_viewport_metrics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart' as overlay;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_viewport_metrics_dto.freezed.dart';
part 'overlay_viewport_metrics_dto.g.dart';

@freezed
abstract class OverlayViewportMetricsDto with _$OverlayViewportMetricsDto {
  const OverlayViewportMetricsDto._();

  const factory OverlayViewportMetricsDto({
    @Default(0) double width,
    @Default(0) double height,
    @Default(0) double safeLeft,
    @Default(0) double safeTop,
    @Default(0) double safeRight,
    @Default(0) double safeBottom,
  }) = _OverlayViewportMetricsDto;

  factory OverlayViewportMetricsDto.fromJson(Map<String, dynamic> json) =>
      _$OverlayViewportMetricsDtoFromJson(json);

  factory OverlayViewportMetricsDto.fromPlugin(
    overlay.OverlayViewportMetrics metrics,
  ) {
    return OverlayViewportMetricsDto(
      width: metrics.width,
      height: metrics.height,
      safeLeft: metrics.safeLeft,
      safeTop: metrics.safeTop,
      safeRight: metrics.safeRight,
      safeBottom: metrics.safeBottom,
    );
  }

  OverlayViewportMetrics toEntity() {
    return OverlayViewportMetrics(
      width: width,
      height: height,
      safePadding: EdgeInsets.fromLTRB(
        safeLeft,
        safeTop,
        safeRight,
        safeBottom,
      ),
    );
  }
}
