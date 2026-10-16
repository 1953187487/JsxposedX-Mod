import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_storage.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(ref) async {
  return await SharedPreferences.getInstance();
}

/// 通用存储服务，用于存放 UI 层持久化数据（如聊天记录）
/// 区别于 PiniaNative (专用于 Xposed 跨进程配置)
@Riverpod(keepAlive: true)
class AppStorage extends _$AppStorage {
  @override
  FutureOr<void> build() async {
    // 确保异步加载完成
    await ref.watch(sharedPreferencesProvider.future);
  }

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider).requireValue;

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();
}

