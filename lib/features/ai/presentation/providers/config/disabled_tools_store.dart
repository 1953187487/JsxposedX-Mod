import 'dart:convert';

import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'disabled_tools_store.g.dart';

/// 持久化每个 configId 对应的被禁用工具名称集合
@riverpod
class DisabledToolsStore extends _$DisabledToolsStore {
  static const _storageKeyPrefix = 'ai_disabled_tools_';

  String _key(String configId) => '$_storageKeyPrefix$configId';

  @override
  Map<String, Set<String>> build() {
    return {};
  }

  /// 同步读取已缓存的禁用工具集合（从内存）
  Set<String> getDisabledToolsSync(String configId) {
    return state[configId] ?? <String>{};
  }

  /// 从持久化存储加载禁用工具集合
  Future<Set<String>> loadDisabledTools(String configId) async {
    if (state.containsKey(configId)) return state[configId]!;

    final storage = ref.read(piniaStorageLocalProvider);
    final raw = await storage.getString(_key(configId));
    if (raw.isEmpty) {
      state = {...state, configId: <String>{}};
      return state[configId]!;
    }
    try {
      final list = (jsonDecode(raw) as List).map((e) => e.toString()).toSet();
      state = {...state, configId: list};
      return list;
    } catch (_) {
      state = {...state, configId: <String>{}};
      return state[configId]!;
    }
  }

  /// 切换指定工具的启用/禁用状态
  Future<void> toggleTool(String configId, String toolName) async {
    final disabled = (await loadDisabledTools(configId)).toSet();
    if (disabled.contains(toolName)) {
      disabled.remove(toolName);
    } else {
      disabled.add(toolName);
    }
    await _persist(configId, disabled);
    state = {...state, configId: disabled};
  }

  Future<void> _persist(String configId, Set<String> disabled) async {
    final storage = ref.read(piniaStorageLocalProvider);
    if (disabled.isEmpty) {
      await storage.remove(_key(configId));
    } else {
      await storage.setString(_key(configId), jsonEncode(disabled.toList()));
    }
  }
}