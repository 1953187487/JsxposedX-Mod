import 'package:flutter/material.dart';

const List<Color> aiActivationGradientColors = <Color>[
  Color(0xFF70D7F9),
  Color(0xFFAD98FF),
  Color(0xFFFFB385),
];

const LinearGradient aiActivationGradient = LinearGradient(
  colors: aiActivationGradientColors,
);

List<BoxShadow> buildAiActivationGlowShadows({bool compact = false}) {
  if (compact) {
    return <BoxShadow>[
      BoxShadow(
        color: aiActivationGradientColors.first.withValues(alpha: 0.22),
        blurRadius: 10,
        spreadRadius: 0.8,
      ),
      BoxShadow(
        color: aiActivationGradientColors[1].withValues(alpha: 0.2),
        blurRadius: 12,
        offset: const Offset(2, 3),
      ),
    ];
  }

  return <BoxShadow>[
    BoxShadow(
      color: aiActivationGradientColors.first.withValues(alpha: 0.3),
      blurRadius: 15,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: aiActivationGradientColors[1].withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(5, 5),
    ),
  ];
}
