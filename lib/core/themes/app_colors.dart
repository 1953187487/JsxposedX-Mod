import 'package:flutter/material.dart';

/// 应用颜色常量（beta.2 全新色板）
class AppColors {
  AppColors._();

  // 主题色
  static const primary = Color(0xFF6366F1); // 默认 · AI 靛蓝
  static const secondary = Color(0xFF22D3EE); // 青

  // 文字颜色（亮色模式）
  static const textPrimary = Color(0xFF1B1F27);
  static const textSecondary = Color(0xFF5A6472);
  static const textHint = Color(0xFF9AA3AF);
  static const textWhite = Colors.white;

  // 背景色（亮色模式）
  static const background = Color(0xFFF4F6FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEEF1F7);

  // 暗色模式
  static const darkBackground = Color(0xFF0E1116);
  static const darkSurface = Color(0xFF12151B);
  static const darkSurfaceContainer = Color(0xFF1A1F28);
  static const darkSurfaceContainerHigh = Color(0xFF1F2530);
  static const darkSurfaceContainerHighest = Color(0xFF242B38);

  // 功能色
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // 分割线
  static const divider = Color(0xFFE4E7EE);

  // 半透明
  static const overlay = Color(0x80000000);
}
