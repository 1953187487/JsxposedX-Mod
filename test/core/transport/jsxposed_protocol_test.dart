import 'package:JsxposedX/core/transport/jsxposed_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsxposedMessage', () {
    test('round trips a request', () {
      final request = JsxposedMessage.request(
        id: 'req-1',
        method: 'device.get_info',
        deviceId: 'device-1',
        params: const {'verbose': true},
      );

      final decoded = JsxposedMessage.decode(request.encode());

      expect(decoded.type, 'request');
      expect(decoded.id, 'req-1');
      expect(decoded.version, jsxposedProtocolVersion);
      expect(decoded.method, 'device.get_info');
      expect(decoded.deviceId, 'device-1');
      expect(decoded.params, const {'verbose': true});
    });

    test('decodes a successful response', () {
      final response = JsxposedMessage.response(
        id: 'req-2',
        ok: true,
        result: const {'status': 'ready'},
      );

      final decoded = JsxposedMessage.decode(response.encode());

      expect(decoded.isResponse, isTrue);
      expect(decoded.isSuccess, isTrue);
      expect(decoded.result, const {'status': 'ready'});
      expect(decoded.error, isNull);
    });

    test('decodes a structured error response', () {
      final response = JsxposedMessage.response(
        id: 'req-3',
        ok: false,
        error: const JsxposedError(
          code: 'CAPABILITY_UNAVAILABLE',
          message: 'Unsupported method',
          retryable: false,
        ),
      );

      final decoded = JsxposedMessage.decode(response.encode());

      expect(decoded.isSuccess, isFalse);
      expect(decoded.error?.code, 'CAPABILITY_UNAVAILABLE');
      expect(decoded.error?.message, 'Unsupported method');
      expect(decoded.error?.retryable, isFalse);
    });
  });

  group('script source', () {
    test('accepts the two sources the device exposes', () {
      expect(JsxposedScriptSource.isValid('frida'), isTrue);
      expect(JsxposedScriptSource.isValid('xposed'), isTrue);
    });

    test('rejects unknown sources', () {
      expect(JsxposedScriptSource.isValid('other'), isFalse);
      expect(JsxposedScriptSource.isValid(''), isFalse);
    });
  });
}
