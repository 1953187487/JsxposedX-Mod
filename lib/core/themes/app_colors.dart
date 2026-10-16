import 'package:flutter/material.dart';

/// 应用颜色常量
class AppColors {
  AppColors._();

  // 主题色
  static const primary = Color(0xFF98D2D5); // 青色
  static const secondary = Color(0xF59DBBFF); // 浅蓝紫

  // 文字颜色
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);
  static const textHint = Color(0xFF999999);
  static const textWhite = Colors.white;

  // 背景色
  static const background = Color(0xFFF5F5F5);
  static const surface = Colors.white;
  static const surfaceVariant = Color(0x89C8C7C7); // 浅灰色
  static Color darkBackground = Color(0xFF1E1E1E);

  // 功能色
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);

  // 分割线
  static const divider = Color(0xFFE0E0E0);

  // 半透明
  static const overlay = Color(0x80000000);
}
