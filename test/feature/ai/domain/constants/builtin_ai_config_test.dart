import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('builtin ai config', () {
    test('uses v2 domain as the builtin base url', () {
      expect(builtinAiConfigBaseUrl, 'https://v2.muxueai.pro');
      expect(defaultBuiltinAiConfigSpec.apiUrl, builtinAiConfigBaseUrl);
    });

    test('purchase url points at the muxue site', () {
      expect(defaultBuiltinAiConfigSpec.purchaseUrl, 'https://muxueai.pro');
    });

    group('normalizeBuiltinAiConfigUrl', () {
      test('upgrades the legacy host', () {
        expect(
          normalizeBuiltinAiConfigUrl('https://muxueai.pro'),
          'https://v2.muxueai.pro',
        );
      });

      test('preserves path, port and query', () {
        expect(
          normalizeBuiltinAiConfigUrl('https://muxueai.pro/v1?a=1'),
          'https://v2.muxueai.pro/v1?a=1',
        );
        expect(
          normalizeBuiltinAiConfigUrl('https://muxueai.pro:8443/v1'),
          'https://v2.muxueai.pro:8443/v1',
        );
      });

      test('is case insensitive on host', () {
        expect(
          normalizeBuiltinAiConfigUrl('https://MuXueAi.Pro/v1'),
          'https://v2.muxueai.pro/v1',
        );
      });

      test('leaves the current domain untouched', () {
        expect(
          normalizeBuiltinAiConfigUrl('https://v2.muxueai.pro/v1'),
          'https://v2.muxueai.pro/v1',
        );
      });

      test('leaves third party urls untouched', () {
        expect(
          normalizeBuiltinAiConfigUrl('https://api.openai.com/v1'),
          'https://api.openai.com/v1',
        );
      });

      test('returns malformed input as-is', () {
        expect(normalizeBuiltinAiConfigUrl(''), '');
        expect(normalizeBuiltinAiConfigUrl('not a url'), 'not a url');
      });
    });
  });
}
