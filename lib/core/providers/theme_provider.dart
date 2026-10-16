import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/core/themes/app_colors.dart';
import 'package:JsxposedX/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// 主题设置 Provider
/// 管理应用的主题模式（亮色/暗色），支持本地存储
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  late final storage = ref.read(piniaStorageLocalProvider);

  @override
  ThemeData build() {
    // 异步加载保存的主题设置
    Future.microtask(() => loadTheme());
    return AppTheme.lightTheme(AppColors.primary);
  }

  /// 获取当前主色调
  Future<Color> get primaryColor async {
    final colorValue = storage.getInt('primaryColor', defaultValue: AppColors.primary.value);
    return Color(await colorValue);
  }

  /// 从存储加载主题设置
  Future<void> loadTheme() async {
    final isDark = await _isDarkMode();
    final color = primaryColor;
    state = isDark ? AppTheme.darkTheme(await color) : AppTheme.lightTheme(await color);
    debugPrint('Loaded theme: ${isDark ? 'dark' : 'light'}, color: $color');
  }

  /// 切换到暗色主题
  Future<void> setDark() async {
    state = AppTheme.darkTheme(await primaryColor);
    await storage.setBool('darkTheme', true);
  }

  /// 切换到亮色主题
  Future<void> setLight() async {
    state = AppTheme.lightTheme(await primaryColor);
    await storage.setBool('darkTheme', false);
  }

  /// 更新主色调
  Future<void> updatePrimaryColor(Color color) async {
    final isDark = await _isDarkMode();
    state = isDark ? AppTheme.darkTheme(color) : AppTheme.lightTheme(color);
    await storage.setInt('primaryColor', color.value);
  }

  /// 切换主题（亮色 ⇄ 暗色）
  void toggleTheme() {
    // 立即返回，不阻塞当前帧
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (state.brightness == Brightness.dark) {
        setLight();
      } else {
        setDark();
      }
    });
  }

  /// 检查是否为暗色模式
  Future<bool> _isDarkMode() async {
    return await storage.getBool('darkTheme', defaultValue: false);
  }

  /// 获取当前主题模式名称
  String get themeModeName =>
      state.brightness == Brightness.dark ? 'dark' : 'light';

  /// 检查是否为暗色主题
  bool get isDark => state.brightness == Brightness.dark;

  /// 检查是否为亮色主题
  bool get isLight => state.brightness == Brightness.light;
}

/// 主题模式 Provider（只读）
@riverpod
String themeMode(Ref ref) {
  final theme = ref.watch(themeProvider);
  return theme.brightness == Brightness.dark ? 'dark' : 'light';
}

/// 是否为暗色模式 Provider（只读）
@riverpod
bool isDarkMode(Ref ref) {
  final theme = ref.watch(themeProvider);
  return theme.brightness == Brightness.dark;
}
