import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_payload_dto.freezed.dart';
part 'overlay_window_payload_dto.g.dart';

@freezed
abstract class OverlayWindowPayloadDto with _$OverlayWindowPayloadDto {
  const OverlayWindowPayloadDto._();

  const factory OverlayWindowPayloadDto({
    @Default(0) int sceneId,
    @Default(OverlayWindowDisplayMode.bubble)
    OverlayWindowDisplayMode displayMode,
    @Default('zh') String localeLanguageCode,
    @Default('CN') String localeCountryCode,
    @Default(false) bool isDarkTheme,
    @Default(0xFF98D2D5) int primaryColorValue,
  }) = _OverlayWindowPayloadDto;

  factory OverlayWindowPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$OverlayWindowPayloadDtoFromJson(json);

  OverlayWindowPayload toEntity() {
    return OverlayWindowPayload(
      sceneId: sceneId,
      displayMode: displayMode,
      localeLanguageCode: localeLanguageCode,
      localeCountryCode: localeCountryCode,
      isDarkTheme: isDarkTheme,
      primaryColorValue: primaryColorValue,
    );
  }

  Map<String, dynamic> toRaw() {
    return <String, dynamic>{
      'sceneId': sceneId,
      'displayMode': displayMode.name,
      'localeLanguageCode': localeLanguageCode,
      'localeCountryCode': localeCountryCode,
      'isDarkTheme': isDarkTheme,
      'primaryColorValue': primaryColorValue,
    };
  }

  static OverlayWindowPayloadDto? maybeFromRaw(dynamic raw) {
    if (raw is OverlayWindowPayloadDto) {
      return raw;
    }

    if (raw is int) {
      return OverlayWindowPayloadDto(sceneId: raw);
    }

    if (raw is String) {
      final parsedScene = int.tryParse(raw);
      if (parsedScene == null) {
        return null;
      }
      return OverlayWindowPayloadDto(sceneId: parsedScene);
    }

    if (raw is! Map) {
      return null;
    }

    final normalized = raw.map(
      (Object? key, Object? value) => MapEntry(key.toString(), value),
    );
    final sceneValue = normalized['sceneId'] ?? normalized['scene'];
    final parsedScene = switch (sceneValue) {
      int value => value,
      String value => int.tryParse(value),
      _ => null,
    };
    if (parsedScene == null) {
      return null;
    }

    return OverlayWindowPayloadDto(
      sceneId: parsedScene,
      displayMode: _displayModeFromRaw(normalized['displayMode']),
      localeLanguageCode: normalized['localeLanguageCode']?.toString() ?? 'zh',
      localeCountryCode: normalized['localeCountryCode']?.toString() ?? 'CN',
      isDarkTheme: _boolFromRaw(normalized['isDarkTheme']) ?? false,
      primaryColorValue:
          _intFromRaw(normalized['primaryColorValue']) ?? 0xFF98D2D5,
    );
  }

  factory OverlayWindowPayloadDto.fromRaw(dynamic raw) {
    return maybeFromRaw(raw) ?? const OverlayWindowPayloadDto();
  }

  static OverlayWindowDisplayMode _displayModeFromRaw(Object? raw) {
    return raw?.toString() == OverlayWindowDisplayMode.panel.name
        ? OverlayWindowDisplayMode.panel
        : OverlayWindowDisplayMode.bubble;
  }

  static bool? _boolFromRaw(Object? raw) {
    return switch (raw) {
      bool value => value,
      String value => value.toLowerCase() == 'true',
      int value => value != 0,
      _ => null,
    };
  }

  static int? _intFromRaw(Object? raw) {
    return switch (raw) {
      int value => value,
      String value => int.tryParse(value),
      _ => null,
    };
  }
}
