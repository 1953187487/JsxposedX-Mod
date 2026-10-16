import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_environment_snapshot.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';
import 'package:JsxposedX/features/ai/presentation/providers/chat/ai_chat_action_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/disabled_tools_store.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/user_risky_tools_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer createContainer({
    required Set<String> disabledTools,
    required Map<String, bool> userRiskyTools,
  }) {
    final container = ProviderContainer(
      overrides: [
        aiConfigProvider.overrideWith((ref) async => _testConfig()),
        disabledToolsStoreProvider.overrideWith(() => _FakeDisabledToolsStore(disabledTools)),
        userRiskyToolsStoreProvider.overrideWith(() => _FakeUserRiskyToolsStore(userRiskyTools)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'user explicit OFF overrides system-default risky (the stuck-switch bug scenario)',
    () {
      // generate_so_hook 系统默认危险，但用户明确关闭 → 不再危险
      final container = createContainer(
        disabledTools: <String>{},
        userRiskyTools: <String, bool>{'generate_so_hook': false},
      );

      final notifier =
          container.read(aiChatActionProvider(packageName: 'pkg').notifier);
      notifier.applyEnvironmentSnapshot(
        AiChatEnvironmentSnapshot.ready(
          scopeId: 'pkg',
          environmentVersion: '1',
          systemPrompt: '',
          toolDefinitions: [
            AiToolDefinition(
              name: 'generate_so_hook',
              description: '',
              parameters: const {},
              isRisky: true,
            ),
          ],
        ),
      );

      final generateHook = notifier.state.toolDefinitions
          .firstWhere((d) => d.name == 'generate_so_hook');
      expect(
        generateHook.isRisky,
        isFalse,
        reason: 'user explicit OFF must override system-default risky flag',
      );
    },
  );

  test(
    'each tool is evaluated independently and user choice wins in both directions',
    () {
      final container = createContainer(
        disabledTools: <String>{},
        userRiskyTools: <String, bool>{
          'decompile_class': true, // 用户标记危险
          'generate_so_hook': false, // 用户关闭系统默认危险
        },
      );

      final notifier =
          container.read(aiChatActionProvider(packageName: 'pkg').notifier);
      notifier.applyEnvironmentSnapshot(
        AiChatEnvironmentSnapshot.ready(
          scopeId: 'pkg',
          environmentVersion: '2',
          systemPrompt: '',
          toolDefinitions: [
            AiToolDefinition(
              name: 'decompile_class',
              description: '',
              parameters: const {},
            ),
            AiToolDefinition(
              name: 'generate_so_hook',
              description: '',
              parameters: const {},
              isRisky: true,
            ),
            AiToolDefinition(
              name: 'list_packages',
              description: '',
              parameters: const {},
            ),
          ],
        ),
      );

      final toolDefs = notifier.state.toolDefinitions;
      final decompile =
          toolDefs.firstWhere((d) => d.name == 'decompile_class');
      final generateHook =
          toolDefs.firstWhere((d) => d.name == 'generate_so_hook');
      final listPackages =
          toolDefs.firstWhere((d) => d.name == 'list_packages');

      expect(decompile.isRisky, isTrue, reason: 'user-marked risky stays risky');
      expect(generateHook.isRisky, isFalse, reason: 'user-marked safe overrides system default');
      expect(listPackages.isRisky, isFalse, reason: 'unconfigured non-risky tool stays safe');
    },
  );

  test(
    'unconfigured tool falls back to system default',
    () {
      final container = createContainer(
        disabledTools: <String>{},
        userRiskyTools: <String, bool>{'other_tool': true},
      );

      final notifier =
          container.read(aiChatActionProvider(packageName: 'pkg').notifier);
      notifier.applyEnvironmentSnapshot(
        AiChatEnvironmentSnapshot.ready(
          scopeId: 'pkg',
          environmentVersion: '3',
          systemPrompt: '',
          toolDefinitions: [
            AiToolDefinition(
              name: 'generate_so_hook',
              description: '',
              parameters: const {},
              isRisky: true,
            ),
          ],
        ),
      );

      final generateHook = notifier.state.toolDefinitions
          .firstWhere((d) => d.name == 'generate_so_hook');
      expect(
        generateHook.isRisky,
        isTrue,
        reason: 'without user choice, system default applies — even when user configured other tools',
      );
    },
  );
}

AiConfig _testConfig() {
  return const AiConfig(
    id: 'test-config',
    name: 'Test Config',
    apiKey: '',
    apiUrl: 'http://localhost',
    moduleName: 'gpt-4o-mini',
    maxToken: 4000,
    temperature: 0.7,
    memoryRounds: 8,
    apiType: AiApiType.openai,
  );
}

class _FakeDisabledToolsStore extends DisabledToolsStore {
  _FakeDisabledToolsStore(this._initial);

  final Set<String> _initial;

  @override
  Map<String, Set<String>> build() {
    return {'test-config': _initial};
  }
}

class _FakeUserRiskyToolsStore extends UserRiskyToolsStore {
  _FakeUserRiskyToolsStore(this._initial);

  final Map<String, bool> _initial;

  @override
  Map<String, Map<String, bool>> build() {
    return {'test-config': _initial};
  }
}
