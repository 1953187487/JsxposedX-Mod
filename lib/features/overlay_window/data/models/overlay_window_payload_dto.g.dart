// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_window_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OverlayWindowPayloadDto _$OverlayWindowPayloadDtoFromJson(
  Map<String, dynamic> json,
) => _OverlayWindowPayloadDto(
  sceneId: (json['sceneId'] as num?)?.toInt() ?? 0,
  displayMode:
      $enumDecodeNullable(
        _$OverlayWindowDisplayModeEnumMap,
        json['displayMode'],
      ) ??
      OverlayWindowDisplayMode.bubble,
  localeLanguageCode: json['localeLanguageCode'] as String? ?? 'zh',
  localeCountryCode: json['localeCountryCode'] as String? ?? 'CN',
  isDarkTheme: json['isDarkTheme'] as bool? ?? false,
  primaryColorValue: (json['primaryColorValue'] as num?)?.toInt() ?? 0xFF98D2D5,
);

Map<String, dynamic> _$OverlayWindowPayloadDtoToJson(
  _OverlayWindowPayloadDto instance,
) => <String, dynamic>{
  'sceneId': instance.sceneId,
  'displayMode': _$OverlayWindowDisplayModeEnumMap[instance.displayMode]!,
  'localeLanguageCode': instance.localeLanguageCode,
  'localeCountryCode': instance.localeCountryCode,
  'isDarkTheme': instance.isDarkTheme,
  'primaryColorValue': instance.primaryColorValue,
};

const _$OverlayWindowDisplayModeEnumMap = {
  OverlayWindowDisplayMode.bubble: 'bubble',
  OverlayWindowDisplayMode.panel: 'panel',
};
