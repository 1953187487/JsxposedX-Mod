import 'dart:async';
import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PC 端语言设置
///
/// 默认跟随系统语言，用户手动切换后持久化到 shared_preferences。
final desktopLocaleProvider = NotifierProvider<DesktopLocaleNotifier, Locale>(
  DesktopLocaleNotifier.new,
);

class DesktopLocaleNotifier extends Notifier<Locale> {
  static const _prefsKey = 'desktop_locale';

  final _prefs = SharedPreferencesAsync();

  @override
  Locale build() {
    // 异步恢复已保存的语言，不阻塞初始化
    Future.microtask(_restore);
    // 默认跟随系统语言
    return PlatformDispatcher.instance.locale.languageCode == 'en'
        ? const Locale('en')
        : const Locale('zh');
  }

  Future<void> _restore() async {
    final saved = await _prefs.getString(_prefsKey);
    if (saved == null) return;
    state = Locale(saved);
  }

  /// 在中文 / 英文之间切换并持久化
  void toggle() {
    state = state.languageCode == 'en' ? const Locale('zh') : const Locale('en');
    unawaited(_prefs.setString(_prefsKey, state.languageCode));
  }
}
