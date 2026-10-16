import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/disabled_tools_store.dart';
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

  test('toggling one tool does not affect other tools', () async {
    final container = createContainer();
    const configId = 'cfg-1';
    final notifier = container.read(disabledToolsStoreProvider.notifier);

    await notifier.toggleTool(configId, 'tool_a');
    await notifier.toggleTool(configId, 'tool_b');

    final disabled = notifier.getDisabledToolsSync(configId);
    expect(disabled, contains('tool_a'));
    expect(disabled, contains('tool_b'));

    await notifier.toggleTool(configId, 'tool_a');
    final updated = notifier.getDisabledToolsSync(configId);
    expect(updated, isNot(contains('tool_a')));
    expect(updated, contains('tool_b'), reason: 'tool_b should remain disabled after tool_a is re-enabled');
  });

  test('tools are independent across different config ids', () async {
    final container = createContainer();
    final notifier = container.read(disabledToolsStoreProvider.notifier);

    await notifier.toggleTool('cfg-a', 'tool_x');
    await notifier.toggleTool('cfg-b', 'tool_y');

    expect(notifier.getDisabledToolsSync('cfg-a'), equals(<String>{'tool_x'}));
    expect(notifier.getDisabledToolsSync('cfg-b'), equals(<String>{'tool_y'}));
  });

  test('persisted state is reloaded correctly', () async {
    final storage = _FakePiniaStorage();
    final container = ProviderContainer(
      overrides: [piniaStorageLocalProvider.overrideWith((ref) => storage)],
    );
    addTearDown(container.dispose);
    const configId = 'cfg-1';

    final notifier = container.read(disabledToolsStoreProvider.notifier);
    await notifier.toggleTool(configId, 'tool_a');

    // Simulate a fresh provider instance by creating a new container.
    final container2 = ProviderContainer(
      overrides: [piniaStorageLocalProvider.overrideWith((ref) => storage)],
    );
    addTearDown(container2.dispose);
    final notifier2 = container2.read(disabledToolsStoreProvider.notifier);

    final reloaded = await notifier2.loadDisabledTools(configId);
    expect(reloaded, equals(<String>{'tool_a'}));
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
