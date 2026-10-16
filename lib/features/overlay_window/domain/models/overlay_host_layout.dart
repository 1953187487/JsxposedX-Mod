import 'dart:ui';

import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_host_layout.freezed.dart';

@freezed
abstract class OverlayHostLayout with _$OverlayHostLayout {
  const OverlayHostLayout._();

  const factory OverlayHostLayout({
    required int width,
    required int height,
    required Offset position,
    required bool enableDrag,
    required OverlayWindowDisplayMode displayMode,
  }) = _OverlayHostLayout;

  static const int matchParent = -1;
  static const int fullCover = -1999;

  factory OverlayHostLayout.panel() {
    return const OverlayHostLayout(
      width: matchParent,
      height: fullCover,
      position: Offset.zero,
      enableDrag: false,
      displayMode: OverlayWindowDisplayMode.panel,
    );
  }
}
