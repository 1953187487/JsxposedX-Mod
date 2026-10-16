// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_viewport_metrics_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OverlayViewportMetricsDto _$OverlayViewportMetricsDtoFromJson(
  Map<String, dynamic> json,
) => _OverlayViewportMetricsDto(
  width: (json['width'] as num?)?.toDouble() ?? 0,
  height: (json['height'] as num?)?.toDouble() ?? 0,
  safeLeft: (json['safeLeft'] as num?)?.toDouble() ?? 0,
  safeTop: (json['safeTop'] as num?)?.toDouble() ?? 0,
  safeRight: (json['safeRight'] as num?)?.toDouble() ?? 0,
  safeBottom: (json['safeBottom'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$OverlayViewportMetricsDtoToJson(
  _OverlayViewportMetricsDto instance,
) => <String, dynamic>{
  'width': instance.width,
  'height': instance.height,
  'safeLeft': instance.safeLeft,
  'safeTop': instance.safeTop,
  'safeRight': instance.safeRight,
  'safeBottom': instance.safeBottom,
};
