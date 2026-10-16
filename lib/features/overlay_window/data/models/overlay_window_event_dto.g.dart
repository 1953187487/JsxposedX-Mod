// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_window_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OverlayWindowEventDto _$OverlayWindowEventDtoFromJson(
  Map<String, dynamic> json,
) => _OverlayWindowEventDto(
  type: $enumDecode(_$OverlayWindowEventTypeEnumMap, json['type']),
  hostX: (json['hostX'] as num?)?.toDouble(),
  hostY: (json['hostY'] as num?)?.toDouble(),
);

Map<String, dynamic> _$OverlayWindowEventDtoToJson(
  _OverlayWindowEventDto instance,
) => <String, dynamic>{
  'type': _$OverlayWindowEventTypeEnumMap[instance.type]!,
  'hostX': instance.hostX,
  'hostY': instance.hostY,
};

const _$OverlayWindowEventTypeEnumMap = {
  OverlayWindowEventType.bubbleTap: 'bubbleTap',
  OverlayWindowEventType.bubbleDragEnd: 'bubbleDragEnd',
};
