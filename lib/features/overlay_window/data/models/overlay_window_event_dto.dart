import 'dart:ui';

import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_event_dto.freezed.dart';
part 'overlay_window_event_dto.g.dart';

@freezed
abstract class OverlayWindowEventDto with _$OverlayWindowEventDto {
  const OverlayWindowEventDto._();

  const factory OverlayWindowEventDto({
    required OverlayWindowEventType type,
    double? hostX,
    double? hostY,
  }) = _OverlayWindowEventDto;

  factory OverlayWindowEventDto.fromJson(Map<String, dynamic> json) =>
      _$OverlayWindowEventDtoFromJson(json);

  OverlayWindowEvent toEntity() {
    return OverlayWindowEvent(
      type: type,
      hostPosition: hostX != null && hostY != null
          ? Offset(hostX!, hostY!)
          : null,
    );
  }

  static OverlayWindowEventDto? maybeFromRaw(dynamic raw) {
    if (raw is OverlayWindowEventDto) {
      return raw;
    }

    if (raw is! Map) {
      return null;
    }

    final normalized = raw.map(
      (Object? key, Object? value) => MapEntry(key.toString(), value),
    );
    final eventType = _eventTypeFromRaw(normalized['event']);
    if (eventType == null) {
      return null;
    }

    return switch (eventType) {
      OverlayWindowEventType.bubbleTap => const OverlayWindowEventDto(
        type: OverlayWindowEventType.bubbleTap,
      ),
      OverlayWindowEventType.bubbleDragEnd => () {
        final x = _parseDouble(normalized['x']);
        final y = _parseDouble(normalized['y']);
        if (x == null || y == null) {
          return null;
        }
        return OverlayWindowEventDto(
          type: OverlayWindowEventType.bubbleDragEnd,
          hostX: x,
          hostY: y,
        );
      }(),
    };
  }

  static OverlayWindowEventType? _eventTypeFromRaw(Object? raw) {
    return switch (raw?.toString()) {
      'bubbleTap' => OverlayWindowEventType.bubbleTap,
      'bubbleDragEnd' => OverlayWindowEventType.bubbleDragEnd,
      _ => null,
    };
  }

  static double? _parseDouble(Object? value) {
    return switch (value) {
      int number => number.toDouble(),
      double number => number,
      String text => double.tryParse(text),
      _ => null,
    };
  }
}
