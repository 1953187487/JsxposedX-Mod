// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_host_layout_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OverlayHostLayoutDto _$OverlayHostLayoutDtoFromJson(
  Map<String, dynamic> json,
) => _OverlayHostLayoutDto(
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  enableDrag: json['enableDrag'] as bool,
  displayMode: $enumDecode(
    _$OverlayWindowDisplayModeEnumMap,
    json['displayMode'],
  ),
);

Map<String, dynamic> _$OverlayHostLayoutDtoToJson(
  _OverlayHostLayoutDto instance,
) => <String, dynamic>{
  'width': instance.width,
  'height': instance.height,
  'x': instance.x,
  'y': instance.y,
  'enableDrag': instance.enableDrag,
  'displayMode': _$OverlayWindowDisplayModeEnumMap[instance.displayMode]!,
};

const _$OverlayWindowDisplayModeEnumMap = {
  OverlayWindowDisplayMode.bubble: 'bubble',
  OverlayWindowDisplayMode.panel: 'panel',
};
