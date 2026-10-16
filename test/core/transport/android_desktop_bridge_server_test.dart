import 'package:JsxposedX/core/transport/android_desktop_bridge_server.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildDesktopBridgeCapabilities', () {
    test('maps ready native capabilities', () {
      final result = buildDesktopBridgeCapabilities(
        deviceId: 'device-1',
        isHook: true,
        isRoot: true,
        isFridaReady: true,
        fridaType: 1,
      );
      final capabilities = result['capabilities'] as Map<String, dynamic>;

      expect(capabilities['root'], isTrue);
      expect(capabilities['memory'], isTrue);
      expect(capabilities['shell'], isTrue);
      expect(capabilities['xposed'], {
        'available': true,
        'framework': 'LSPosed',
      });
      expect(capabilities['frida'], {
        'available': true,
        'installed': true,
        'mode': 'zygisk',
        'state': 'ready',
      });
    });

    test('distinguishes installed Frida from ready Frida', () {
      final result = buildDesktopBridgeCapabilities(
        deviceId: null,
        isHook: false,
        isRoot: false,
        isFridaReady: false,
        fridaType: 0,
      );
      final capabilities = result['capabilities'] as Map<String, dynamic>;
      final frida = capabilities['frida'] as Map<String, dynamic>;

      expect(frida['available'], isFalse);
      expect(frida['installed'], isTrue);
      expect(frida['state'], 'installed');
      expect(capabilities['memory'], isFalse);
      expect(capabilities['shell'], isFalse);
    });
  });
}
