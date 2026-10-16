import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_payload.freezed.dart';

enum OverlayWindowDisplayMode { bubble, panel }

@freezed
abstract class OverlayWindowPayload with _$OverlayWindowPayload {
  const OverlayWindowPayload._();

  const factory OverlayWindowPayload({
    required int sceneId,
    required OverlayWindowDisplayMode displayMode,
    required String localeLanguageCode,
    required String localeCountryCode,
    required bool isDarkTheme,
    required int primaryColorValue,
  }) = _OverlayWindowPayload;

  bool get isBubble => displayMode == OverlayWindowDisplayMode.bubble;
  bool get isPanel => displayMode == OverlayWindowDisplayMode.panel;
}
