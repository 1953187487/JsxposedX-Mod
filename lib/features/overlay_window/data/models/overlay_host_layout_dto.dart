import 'dart:ui';

import 'package:JsxposedX/features/overlay_window/domain/models/overlay_host_layout.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_host_layout_dto.freezed.dart';
part 'overlay_host_layout_dto.g.dart';

@freezed
abstract class OverlayHostLayoutDto with _$OverlayHostLayoutDto {
  const OverlayHostLayoutDto._();

  const factory OverlayHostLayoutDto({
    required int width,
    required int height,
    required double x,
    required double y,
    required bool enableDrag,
    required OverlayWindowDisplayMode displayMode,
  }) = _OverlayHostLayoutDto;

  factory OverlayHostLayoutDto.fromJson(Map<String, dynamic> json) =>
      _$OverlayHostLayoutDtoFromJson(json);

  OverlayHostLayout toEntity() {
    return OverlayHostLayout(
      width: width,
      height: height,
      position: Offset(x, y),
      enableDrag: enableDrag,
      displayMode: displayMode,
    );
  }
}
