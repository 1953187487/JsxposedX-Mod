import 'dart:convert';

import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_risky_tools_store.g.dart';

/// 持久化用户对每个工具的明确危险判定（configId -> {toolName: isRisky}）。
/// 用户的选择完全覆盖 AiToolDefinition.isRisky 的系统默认值：
/// - 未配置（key 缺失）→ 使用系统默认；
/// - 配置为 true / false → 以用户为准。
/// 这样保证任何工具（包括系统默认危险的工具）的开关都能独立开/关。
@riverpod
class UserRiskyToolsStore extends _$UserRiskyToolsStore {
  static const _storageKeyPrefix = 'ai_user_risky_tools_';

  String _key(String configId) => '$_storageKeyPrefix$configId';

  @override
  Map<String, Map<String, bool>> build() {
    return {};
  }

  /// 同步读取用户对某配置下各工具的明确危险判定
  Map<String, bool> getRiskySync(String configId) {
    return state[configId] ?? <String, bool>{};
  }

  /// 从持久化加载（兼容旧版 Set 格式：列表中的工具视为用户标记危险）
  Future<Map<String, bool>> loadRisky(String configId) async {
    if (state.containsKey(configId)) return state[configId]!;
    final storage = ref.read(piniaStorageLocalProvider);
    final raw = await storage.getString(_key(configId));
    Map<String, bool> loaded = {};
    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          loaded = decoded.map((k, v) => MapEntry(k.toString(), v == true));
        } else if (decoded is List) {
          // 旧版 Set 格式兼容
          loaded = {
            for (final e in decoded)
              if (e != null) e.toString(): true,
          };
        }
      } catch (_) {
        // 解析失败按空处理
      }
    }
    state = {...state, configId: loaded};
    return loaded;
  }

  /// 设置工具的明确危险判定（true/false 均持久化，均可覆盖系统默认）
  Future<void> setRisky(String configId, String toolName, bool isRisky) async {
    final risky = (await loadRisky(configId));
    risky[toolName] = isRisky;
    await _persist(configId, risky);
    state = {...state, configId: Map<String, bool>.from(risky)};
  }

  Future<void> _persist(String configId, Map<String, bool> risky) async {
    final storage = ref.read(piniaStorageLocalProvider);
    if (risky.isEmpty) {
      await storage.remove(_key(configId));
    } else {
      await storage.setString(_key(configId), jsonEncode(risky));
    }
  }
}
