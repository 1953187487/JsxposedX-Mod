import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/user_risky_tools_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        piniaStorageLocalProvider.overrideWith((ref) => _FakePiniaStorage()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('setRisky on one tool does not affect other tools', () async {
    final container = createContainer();
    const configId = 'cfg-1';
    final notifier = container.read(userRiskyToolsStoreProvider.notifier);

    await notifier.setRisky(configId, 'tool_a', true);
    await notifier.setRisky(configId, 'tool_b', true);

    final risky = notifier.getRiskySync(configId);
    expect(risky['tool_a'], isTrue);
    expect(risky['tool_b'], isTrue);

    await notifier.setRisky(configId, 'tool_a', false);
    final updated = notifier.getRiskySync(configId);
    expect(updated['tool_a'], isFalse, reason: 'tool_a should be explicitly turned off');
    expect(updated['tool_b'], isTrue, reason: 'tool_b must remain risky after tool_a is turned off');
  });

  test('setting risky false on a tool records explicit OFF (overrides system default)', () async {
    final container = createContainer();
    const configId = 'cfg-1';
    final notifier = container.read(userRiskyToolsStoreProvider.notifier);

    await notifier.setRisky(configId, 'generate_so_hook', false);

    final risky = notifier.getRiskySync(configId);
    expect(risky['generate_so_hook'], isFalse,
        reason: 'explicit OFF must be persisted, not treated as "not configured"');
  });

  test('risky choices are independent across different config ids', () async {
    final container = createContainer();
    final notifier = container.read(userRiskyToolsStoreProvider.notifier);

    await notifier.setRisky('cfg-a', 'tool_x', true);
    await notifier.setRisky('cfg-b', 'tool_y', true);

    expect(notifier.getRiskySync('cfg-a'), equals(<String, bool>{'tool_x': true}));
    expect(notifier.getRiskySync('cfg-b'), equals(<String, bool>{'tool_y': true}));
  });

  test('persisted state is reloaded correctly', () async {
    final storage = _FakePiniaStorage();
    final container = ProviderContainer(
      overrides: [piniaStorageLocalProvider.overrideWith((ref) => storage)],
    );
    addTearDown(container.dispose);
    const configId = 'cfg-1';

    final notifier = container.read(userRiskyToolsStoreProvider.notifier);
    await notifier.setRisky(configId, 'tool_a', true);
    await notifier.setRisky(configId, 'tool_b', false);

    final container2 = ProviderContainer(
      overrides: [piniaStorageLocalProvider.overrideWith((ref) => storage)],
    );
    addTearDown(container2.dispose);
    final notifier2 = container2.read(userRiskyToolsStoreProvider.notifier);

    final reloaded = await notifier2.loadRisky(configId);
    expect(reloaded, equals(<String, bool>{'tool_a': true, 'tool_b': false}),
        reason: 'both explicit ON and OFF choices must round-trip persistence');
  });

  test('legacy Set-format storage is loaded as explicit risky marks', () async {
    final storage = _FakePiniaStorage();
    await storage.setString('ai_user_risky_tools_cfg-legacy', '["tool_old"]');
    final container = ProviderContainer(
      overrides: [piniaStorageLocalProvider.overrideWith((ref) => storage)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(userRiskyToolsStoreProvider.notifier);
    final reloaded = await notifier.loadRisky('cfg-legacy');
    expect(reloaded, equals(<String, bool>{'tool_old': true}),
        reason: 'old list format should convert to explicit risky marks');
  });
}

class _FakePiniaStorage implements PiniaStorage {
  final _data = <String, String>{};

  @override
  Future<String> getString(String key, {String defaultValue = '', String space = 'pinia'}) async {
    return _data[key] ?? defaultValue;
  }

  @override
  Future<void> setString(String key, String value, {String space = 'pinia'}) async {
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
