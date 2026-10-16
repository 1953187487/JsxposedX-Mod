import 'package:flutter/widgets.dart';

@immutable
class OverlayViewportMetrics {
  const OverlayViewportMetrics({
    required this.width,
    required this.height,
    this.safeLeft = 0,
    this.safeTop = 0,
    this.safeRight = 0,
    this.safeBottom = 0,
  });

  final double width;
  final double height;
  final double safeLeft;
  final double safeTop;
  final double safeRight;
  final double safeBottom;

  Size get size => Size(width, height);

  EdgeInsets get safePadding =>
      EdgeInsets.fromLTRB(safeLeft, safeTop, safeRight, safeBottom);

  factory OverlayViewportMetrics.fromMap(Map<Object?, Object?>? map) {
    return OverlayViewportMetrics(
      width: _parseDouble(map?['width']),
      height: _parseDouble(map?['height']),
      safeLeft: _parseDouble(map?['safeLeft']),
      safeTop: _parseDouble(map?['safeTop']),
      safeRight: _parseDouble(map?['safeRight']),
      safeBottom: _parseDouble(map?['safeBottom']),
    );
  }

  static double _parseDouble(Object? value) {
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }
}
