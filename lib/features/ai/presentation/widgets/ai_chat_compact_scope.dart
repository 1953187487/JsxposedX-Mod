import 'package:flutter/widgets.dart';

class AiChatCompactScope extends InheritedWidget {
  const AiChatCompactScope({
    super.key,
    required this.enabled,
    this.scale = 1.0,
    required super.child,
  });

  final bool enabled;
  final double scale;

  static bool of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<AiChatCompactScope>()
            ?.enabled ??
        false;
  }

  static double scaleOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<AiChatCompactScope>()
            ?.scale ??
        1.0;
  }

  @override
  bool updateShouldNotify(covariant AiChatCompactScope oldWidget) {
    return oldWidget.enabled != enabled || oldWidget.scale != scale;
  }
}
