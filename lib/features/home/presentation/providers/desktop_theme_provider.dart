import 'dart:async';

import 'package:JsxposedX/core/themes/app_colors.dart';
import 'package:JsxposedX/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PC 端主题模式
///
/// 使用 shared_preferences 持久化，不依赖 Android 的 PiniaNative。
final desktopThemeModeProvider =
    NotifierProvider<DesktopThemeModeNotifier, ThemeMode>(
      DesktopThemeModeNotifier.new,
    );

class DesktopThemeModeNotifier extends Notifier<ThemeMode> {
  static const _prefsKey = 'desktop_theme_mode';

  final _prefs = SharedPreferencesAsync();

  @override
  ThemeMode build() {
    // 异步恢复已保存的主题，不阻塞初始化
    Future.microtask(_restore);
    return ThemeMode.dark;
  }

  Future<void> _restore() async {
    final saved = await _prefs.getString(_prefsKey);
    if (saved == null) return;
    state = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  /// 切换明暗主题并持久化
  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    unawaited(
      _prefs.setString(_prefsKey, state == ThemeMode.dark ? 'dark' : 'light'),
    );
  }
}

/// 亮色主题（缓存，避免每次切换重新构建 ThemeData）
final desktopLightThemeProvider = Provider<ThemeData>(
  (ref) => AppTheme.lightTheme(AppColors.primary),
);

/// 暗色主题（缓存，避免每次切换重新构建 ThemeData）
final desktopDarkThemeProvider = Provider<ThemeData>(
  (ref) => AppTheme.darkTheme(AppColors.primary),
);
