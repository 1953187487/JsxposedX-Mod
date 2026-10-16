import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_event.freezed.dart';

enum OverlayWindowEventType { bubbleTap, bubbleDragEnd }

@freezed
abstract class OverlayWindowEvent with _$OverlayWindowEvent {
  const OverlayWindowEvent._();

  const factory OverlayWindowEvent({
    required OverlayWindowEventType type,
    Offset? hostPosition,
  }) = _OverlayWindowEvent;

  bool get isBubbleTap => type == OverlayWindowEventType.bubbleTap;
  bool get isBubbleDragEnd => type == OverlayWindowEventType.bubbleDragEnd;
}
