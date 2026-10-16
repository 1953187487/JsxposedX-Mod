import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/features/ai/data/datasources/config/ai_config_action_datasource.dart';
import 'package:JsxposedX/features/ai/data/models/ai_config_dto.dart';

void main() {
  const currentConfigKey = 'ai_config';
  const configListKey = 'ai_config_list';

  AiConfigActionDatasource createDatasource(_FakePiniaStorage storage) =>
      AiConfigActionDatasource(storage: storage);

  test(
    'updateConfig syncs the current config snapshot when updating the active config',
    () async {
      final storage = _FakePiniaStorage();
      final datasource = createDatasource(storage);

      final config = const AiConfigDto(
        id: 'cfg-1',
        name: 'Custom',
        apiKey: 'key',
        apiUrl: 'https://api.test/v1',
        moduleName: 'old-model',
      );
      // cfg-1 既是列表成员，也是当前生效配置。
      await storage.setString(
        currentConfigKey,
        jsonEncode(config.toJson()),
      );
      await storage.setString(configListKey, jsonEncode([config.toJson()]));

      // 模拟快捷设置面板切换模型：updateConfig(copyWith(moduleName: ...))。
      await datasource.updateConfig(
        config.copyWith(moduleName: 'deepseek-ai/DeepSeek-V3.2'),
      );

      // 关键回归断言：读取端从 ai_config 键取到的模型必须已同步更新，
      // 否则面板刷新后仍会显示切换前的旧模型。
      final current = AiConfigDto.fromJson(
        jsonDecode(await storage.getString(currentConfigKey))
            as Map<String, dynamic>,
      );
      expect(current.id, 'cfg-1');
      expect(current.moduleName, 'deepseek-ai/DeepSeek-V3.2');

      // 列表条目同样保持一致。
      final list = await datasource.getConfigList();
      expect(list.single.moduleName, 'deepseek-ai/DeepSeek-V3.2');
    },
  );

  test(
    'updateConfig keeps the current snapshot untouched when updating another config',
    () async {
      final storage = _FakePiniaStorage();
      final datasource = createDatasource(storage);

      final active = const AiConfigDto(
        id: 'cfg-active',
        name: 'Active',
        moduleName: 'active-model',
      );
      final other = const AiConfigDto(
        id: 'cfg-other',
        name: 'Other',
        moduleName: 'other-model',
      );
      await storage.setString(currentConfigKey, jsonEncode(active.toJson()));
      await storage.setString(
        configListKey,
        jsonEncode([active.toJson(), other.toJson()]),
      );

      await datasource.updateConfig(
        other.copyWith(moduleName: 'other-model-v2'),
      );

      final current = AiConfigDto.fromJson(
        jsonDecode(await storage.getString(currentConfigKey))
            as Map<String, dynamic>,
      );
      expect(current.id, 'cfg-active');
      expect(current.moduleName, 'active-model');
    },
  );

  test(
    'updateConfig tolerates a corrupted current config snapshot',
    () async {
      final storage = _FakePiniaStorage();
      final datasource = createDatasource(storage);

      final config = const AiConfigDto(
        id: 'cfg-1',
        name: 'Custom',
        moduleName: 'old-model',
      );
      await storage.setString(currentConfigKey, 'not-json');
      await storage.setString(configListKey, jsonEncode([config.toJson()]));

      // 当前配置快照损坏时跳过同步，不应让列表更新失败。
      await datasource.updateConfig(config.copyWith(moduleName: 'new-model'));

      expect((await datasource.getConfigList()).single.moduleName, 'new-model');
    },
  );
}

class _FakePiniaStorage implements PiniaStorage {
  final _data = <String, String>{};

  @override
  Future<String> getString(
    String key, {
    String defaultValue = '',
    String space = 'pinia',
  }) async => _data[key] ?? defaultValue;

  @override
  Future<void> setString(
    String key,
    String value, {
    String space = 'pinia',
  }) async {
    _data[key] = value;
  }

  @override
  Future<void> remove(String key, {String space = 'pinia'}) async {
    _data.remove(key);
  }

  // Not used by these tests.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
