import 'dart:ui';

import 'package:JsxposedX/features/overlay_window/data/models/overlay_host_layout_dto.dart';
import 'package:JsxposedX/features/overlay_window/data/models/overlay_window_event_dto.dart';
import 'package:JsxposedX/features/overlay_window/data/models/overlay_window_payload_dto.dart';
import 'package:JsxposedX/features/overlay_window/data/models/overlay_viewport_metrics_dto.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_host_layout.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_event.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_payload.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_viewport_metrics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverlayWindowPayloadDto', () {
    test('parses payload map and serializes back', () {
      final dto = OverlayWindowPayloadDto.fromRaw(<String, dynamic>{
        'sceneId': 7,
        'displayMode': OverlayWindowDisplayMode.panel,
      });

      expect(dto.sceneId, 7);
      expect(dto.displayMode, OverlayWindowDisplayMode.panel);
      expect(dto.toEntity().sceneId, 7);
      expect(dto.toRaw(), <String, dynamic>{
        'sceneId': 7,
        'displayMode': OverlayWindowDisplayMode.panel.name,
        'localeLanguageCode': 'zh',
        'localeCountryCode': 'CN',
        'isDarkTheme': false,
        'primaryColorValue': 0xFF98D2D5,
      });
    });

    test('supports legacy scene field', () {
      final dto = OverlayWindowPayloadDto.fromRaw(<String, dynamic>{
        'scene': '5',
      });

      expect(dto.sceneId, 5);
      expect(dto.displayMode, OverlayWindowDisplayMode.bubble);
    });

    test('parses theme and locale snapshot fields', () {
      final dto = OverlayWindowPayloadDto.fromRaw(<String, dynamic>{
        'sceneId': 3,
        'displayMode': OverlayWindowDisplayMode.bubble,
        'localeLanguageCode': 'en',
        'localeCountryCode': 'US',
        'isDarkTheme': true,
        'primaryColorValue': 0xFF123456,
      });

      expect(dto.localeLanguageCode, 'en');
      expect(dto.localeCountryCode, 'US');
      expect(dto.isDarkTheme, isTrue);
      expect(dto.primaryColorValue, 0xFF123456);
      expect(dto.toEntity().isDarkTheme, isTrue);
    });
  });

  group('OverlayWindowEventDto', () {
    test('parses bubble tap event', () {
      final event = OverlayWindowEventDto.maybeFromRaw(<String, dynamic>{
        'event': OverlayWindowEventType.bubbleTap,
      });

      expect(event, isNotNull);
      expect(event!.type, OverlayWindowEventType.bubbleTap);
      expect(event.toEntity().isBubbleTap, isTrue);
      expect(event.toEntity().hostPosition, isNull);
    });

    test('parses drag end event with host position', () {
      final event = OverlayWindowEventDto.maybeFromRaw(<String, dynamic>{
        'event': OverlayWindowEventType.bubbleDragEnd,
        'x': '12.5',
        'y': 30,
      });

      expect(event, isNotNull);
      expect(event!.type, OverlayWindowEventType.bubbleDragEnd);
      expect(event.toEntity().isBubbleDragEnd, isTrue);
      expect(event.toEntity().hostPosition, const Offset(12.5, 30));
    });
  });

  group('OverlayViewportMetricsDto', () {
    test('maps dto to entity', () {
      const dto = OverlayViewportMetricsDto(
        width: 400,
        height: 800,
        safeLeft: 10,
        safeTop: 20,
        safeRight: 30,
        safeBottom: 40,
      );

      expect(
        dto.toEntity(),
        const OverlayViewportMetrics(
          width: 400,
          height: 800,
          safePadding: EdgeInsets.fromLTRB(10, 20, 30, 40),
        ),
      );
    });
  });

  group('OverlayHostLayoutDto', () {
    test('maps dto to entity', () {
      const dto = OverlayHostLayoutDto(
        width: 90,
        height: 100,
        x: 12.5,
        y: 66,
        enableDrag: true,
        displayMode: OverlayWindowDisplayMode.bubble,
      );

      expect(
        dto.toEntity(),
        const OverlayHostLayout(
          width: 90,
          height: 100,
          position: Offset(12.5, 66),
          enableDrag: true,
          displayMode: OverlayWindowDisplayMode.bubble,
        ),
      );
    });
  });
}
