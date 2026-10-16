import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

/// 语言设置 Provider
/// 管理应用的当前语言，支持本地存储
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  late final storage = ref.read(piniaStorageLocalProvider);

  @override
  Locale build() {
    // 异步加载保存的语言设置，不阻塞初始化
    // 使用 Future.microtask 延迟执行，避免在 build 期间修改状态
    Future.microtask(() => loadLocale());
    return const Locale('zh', 'CN'); // 默认中文
  }

  Future<void> loadLocale() async {
    final isChinese = await _isChinese();
    final result = isChinese
        ? const Locale('zh', 'CN')
        : const Locale('en', 'US');
    debugPrint('Loaded locale: $result');
    state = result;
  }

  /// 切换到中文
  Future<void> setZh() async {
    const locale = Locale('zh', 'CN');
    state = locale; // 先立即更新 UI
    await storage.setBool('zh', true); // 异步保存
  }

  /// 切换到英文
  Future<void> setEn() async {
    const locale = Locale('en', 'US');
    state = locale; // 先立即更新 UI
    await storage.setBool('zh', false); // 异步保存
  }

  /// 切换语言（中文 ⇄ 英文）
  void toggleLanguage() {
    // 立即返回，不阻塞当前帧
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (state.languageCode == 'zh') {
        setEn();
      } else {
        setZh();
      }
    });
  }

  /// 检查是否为中文
  Future<bool> _isChinese() async {
    // 先检查是否存储过语言设置
    final hasKey = await storage.contains('zh');
    if (!hasKey) return true; // 没存过，默认中文
    return await storage.getBool('zh', defaultValue: true);
  }

  /// 获取当前语言代码
  String get languageCode => state.languageCode;

  /// 检查是否为中文
  bool get isChinese => state.languageCode == 'zh';

  /// 检查是否为英文
  bool get isEnglish => state.languageCode == 'en';
}
