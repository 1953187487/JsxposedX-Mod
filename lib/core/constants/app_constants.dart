import 'package:flutter/material.dart';

/// 应用全局常量配置
/// 统一管理间距、尺寸、时长等常量
class AppConstants {
  AppConstants._();

  // ==================== 间距配置 ====================

  /// 页面默认内边距
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    vertical: 5,
    horizontal: 10,
  );

  /// 小间距
  static const double spacingXS = 4.0;

  /// 默认间距
  static const double spacingSM = 8.0;

  /// 中等间距
  static const double spacingMD = 16.0;

  /// 大间距
  static const double spacingLG = 24.0;

  /// 超大间距
  static const double spacingXL = 32.0;

  // ==================== 圆角配置 ====================

  /// 小圆角
  static const double radiusSM = 4.0;

  /// 默认圆角
  static const double radiusMD = 8.0;

  /// 中等圆角
  static const double radiusLG = 12.0;

  /// 大圆角
  static const double radiusXL = 16.0;

  /// 圆形
  static const double radiusRound = 999.0;

  // ==================== 尺寸配置 ====================

  /// AppBar 高度
  static const double appBarHeight = 56.0;

  /// BottomNavigationBar 高度
  static const double bottomNavBarHeight = 56.0;

  /// 按钮最小高度
  static const double buttonMinHeight = 48.0;

  /// 输入框高度
  static const double inputHeight = 48.0;

  /// 头像默认大小
  static const double avatarSize = 40.0;

  /// 图标默认大小
  static const double iconSize = 20.0;

  static const double defaultInterval = 20.0;

  static const double defaultHeight = 12.0;

  // ==================== 动画时长配置 ====================

  /// 快速动画
  static const Duration animationFast = Duration(milliseconds: 150);

  /// 默认动画
  static const Duration animationNormal = Duration(milliseconds: 300);

  /// 慢速动画
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ==================== 其他配置 ====================

  /// 默认防抖时长
  static const Duration debounceDelay = Duration(milliseconds: 300);

  /// 默认超时时长
  static const Duration requestTimeout = Duration(seconds: 30);

  /// 图片缓存时长
  static const Duration imageCacheDuration = Duration(days: 7);

  /// 最大图片上传大小（5MB）
  static const int maxImageSize = 5 * 1024 * 1024;

  /// 分页默认大小
  static const int defaultPageSize = 20;
}
