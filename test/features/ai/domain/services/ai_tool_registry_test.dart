import 'package:JsxposedX/features/ai/domain/services/ai_tool_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiToolRegistry apkReverse()', () {
    test('registers exactly 12 tools with includeSoTools: true', () {
      final registrations = AiToolRegistry.apkReverse(includeSoTools: true);
      expect(registrations.length, 12);
    });

    test('registers exactly 7 non-SO tools with includeSoTools: false', () {
      final registrations = AiToolRegistry.apkReverse(includeSoTools: false);
      expect(registrations.length, 7);
    });

    test('all definitions have non-empty name', () {
      for (final r in AiToolRegistry.apkReverse()) {
        expect(r.definition.name, isNotEmpty);
      }
    });

    test('all definitions have descriptions', () {
      for (final r in AiToolRegistry.apkReverse()) {
        expect(r.definition.description, isNotEmpty);
      }
    });

    test('handler factories are non-null for all registrations', () {
      for (final r in AiToolRegistry.apkReverse()) {
        expect(r.handlerFactory, isNotNull);
      }
    });
  });

  group('AiToolRegistry SO tools config', () {
    test('SO tools have timeout 120s', () {
      final registrations = AiToolRegistry.apkReverse(includeSoTools: true);
      final soNames = {
        'get_so_info',
        'search_so_symbols',
        'get_jni_functions',
        'search_so_strings',
      };
      for (final r in registrations) {
        if (soNames.contains(r.definition.name)) {
          expect(
            r.timeout,
            const Duration(seconds: 120),
            reason: '${r.definition.name} should be 120s',
          );
        }
      }
    });

    test('SO query tools are retryable', () {
      final registrations = AiToolRegistry.apkReverse(includeSoTools: true);
      final retryableSoNames = {
        'get_so_info',
        'search_so_symbols',
        'get_jni_functions',
        'search_so_strings',
      };
      for (final r in registrations) {
        if (retryableSoNames.contains(r.definition.name)) {
          expect(r.retryable, isTrue,
              reason: '${r.definition.name} should be retryable');
        }
      }
    });

    test('generate_so_hook is pure danger level', () {
      final registrations = AiToolRegistry.apkReverse(includeSoTools: true);
      final gen =
          registrations.firstWhere((r) => r.definition.name == 'generate_so_hook');
      expect(gen.danger, AiToolDangerLevel.pure);
      expect(gen.timeout, const Duration(seconds: 10));
    });
  });

  group('AiToolRegistry lookup APIs', () {
    test('byName returns correct registration', () {
      final reg = AiToolRegistry.byName('get_manifest');
      expect(reg, isNotNull);
      expect(reg!.definition.name, 'get_manifest');
    });

    test('byName returns null for unknown tool', () {
      final reg = AiToolRegistry.byName('nonexistent');
      expect(reg, isNull);
    });

    test('categoryOf returns correct category', () {
      expect(AiToolRegistry.categoryOf('get_manifest'), AiToolCategory.reverse);
      expect(AiToolRegistry.categoryOf('generate_so_hook'),
          AiToolCategory.reverse);
    });

    test('categoryOf returns null for unknown tool', () {
      expect(AiToolRegistry.categoryOf('nonexistent'), isNull);
    });

    test('dangerOf returns correct danger level', () {
      expect(AiToolRegistry.dangerOf('get_manifest'), AiToolDangerLevel.read);
      expect(AiToolRegistry.dangerOf('generate_so_hook'), AiToolDangerLevel.pure);
    });

    test('dangerOf returns read as default for unknown tool', () {
      expect(AiToolRegistry.dangerOf('nonexistent'), AiToolDangerLevel.read);
    });

    test('all reverse tools are categorized as reverse', () {
      for (final r in AiToolRegistry.apkReverse()) {
        expect(r.category, AiToolCategory.reverse);
      }
    });
  });

  group('AiToolRegistry definition ↔ handler name alignment', () {
    test('every handler name matches its definition name', () {
      for (final r in AiToolRegistry.apkReverse()) {
        final byName = AiToolRegistry.byName(r.definition.name);
        expect(byName, isNotNull,
            reason: '${r.definition.name} not found via byName');
        expect(byName!.definition.name, r.definition.name);
      }
    });
  });

  group('AiToolRegistry scriptLifecycle()', () {
    test('registers exactly 8 tools', () {
      final registrations = AiToolRegistry.scriptLifecycle();
      expect(registrations.length, 8);
    });

    test('all script tools are categorized as scriptLifecycle', () {
      for (final r in AiToolRegistry.scriptLifecycle()) {
        expect(r.category, AiToolCategory.scriptLifecycle);
      }
    });

    test('generate tools are pure', () {
      expect(AiToolRegistry.dangerOf('generate_xposed_hook'),
          AiToolDangerLevel.pure);
      expect(AiToolRegistry.dangerOf('generate_frida_hook'),
          AiToolDangerLevel.pure);
    });

    test('save_script and toggle_script are write', () {
      expect(AiToolRegistry.dangerOf('save_script'), AiToolDangerLevel.write);
      expect(
          AiToolRegistry.dangerOf('toggle_script'), AiToolDangerLevel.write);
    });

    test('list_scripts is read', () {
      expect(AiToolRegistry.dangerOf('list_scripts'), AiToolDangerLevel.read);
    });

    test('validate_script is pure', () {
      expect(
          AiToolRegistry.dangerOf('validate_script'), AiToolDangerLevel.pure);
    });

    test('script tools present in _allByName lookup', () {
      for (final r in AiToolRegistry.scriptLifecycle()) {
        final byName = AiToolRegistry.byName(r.definition.name);
        expect(byName, isNotNull,
            reason: '${r.definition.name} not found via byName');
      }
    });

    test('categoryOf works for script tools', () {
      expect(AiToolRegistry.categoryOf('generate_xposed_hook'),
          AiToolCategory.scriptLifecycle);
      expect(AiToolRegistry.categoryOf('save_script'),
          AiToolCategory.scriptLifecycle);
    });
  });
}