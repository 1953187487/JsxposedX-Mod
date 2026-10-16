import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 返回顶部悬浮按钮
///
/// 用于长列表滚动时显示的返回顶部按钮
///
/// 示例:
/// ```dart
/// BackToTopButton(
///   visible: showBackToTop,
///   scrollController: scrollController,
/// )
/// ```
class BackToTopButton extends StatelessWidget {
  /// 是否显示按钮
  final bool visible;

  /// 滚动控制器，用于执行滚动到顶部操作
  final ScrollController scrollController;

  /// 刷新回调（非移动端和 Web 时使用）
  final VoidCallback? onRefresh;

  /// 按钮距离右边距（默认 16）
  final double? right;

  /// 按钮距离底部边距（默认 16）
  final double? bottom;

  /// 淡入淡出动画时长（默认 300ms）
  final Duration fadeDuration;

  /// 滚动到顶部的动画时长（默认 1000ms）
  final Duration scrollDuration;

  /// 滚动曲线（默认 Curves.easeInOut）
  final Curve scrollCurve;

  /// 按钮图标（默认 Icons.arrow_upward）
  final IconData icon;

  /// 图标颜色（默认白色）
  final Color? iconColor;

  /// 是否使用迷你尺寸（默认 true）
  final bool mini;

  /// Hero 标签（用于页面转场动画，必须唯一）
  final String? heroTag;

  const BackToTopButton({
    super.key,
    required this.visible,
    required this.scrollController,
    this.onRefresh,
    this.right = 16,
    this.bottom = 16,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.scrollDuration = const Duration(milliseconds: 1000),
    this.scrollCurve = Curves.easeInOut,
    this.icon = Icons.arrow_upward,
    this.iconColor = Colors.white,
    this.mini = true,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    // 判断是否为 Android 平台
    final bool isAndroid = !kIsWeb && Platform.isAndroid;

    // 除了 Android 以外的所有平台都显示刷新按钮（Android 有下拉刷新手势）
    final bool showRefreshButton = !isAndroid && onRefresh != null;

    return Positioned(
      right: right,
      bottom: bottom,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: fadeDuration,
        child: showRefreshButton
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 刷新按钮
            FloatingActionButton(
              heroTag: '${heroTag ?? 'back_to_top_fab'}_refresh',
              mini: mini,
              onPressed: onRefresh,
              child: Icon(Icons.refresh, color: iconColor),
            ),
            const SizedBox(height: 8),
            // 返回顶部按钮
            FloatingActionButton(
              heroTag: heroTag ?? 'back_to_top_fab',
              mini: mini,
              onPressed: _scrollToTop,
              child: Icon(icon, color: iconColor),
            ),
          ],
        )
            : FloatingActionButton(
          heroTag: heroTag ?? 'back_to_top_fab',
          mini: mini,
          onPressed: _scrollToTop,
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }

  /// 滚动到顶部
  void _scrollToTop() {
    scrollController.animateTo(0, duration: scrollDuration, curve: scrollCurve);
  }
}
