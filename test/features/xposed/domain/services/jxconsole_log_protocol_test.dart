import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/xposed/domain/services/jxconsole_log_protocol.dart';

void main() {
  const protocol = JxConsoleLogProtocol();

  group('JxConsoleLogProtocol', () {
    test('parses v1 messages without a run id', () {
      final record = protocol.parse(
        'JXCONSOLE|v1|xposed|hook.js|I|hello%20world',
      );

      expect(record, isNotNull);
      expect(record!.protocolVersion, 'v1');
      expect(record.source, 'xposed');
      expect(record.runId, isEmpty);
      expect(record.scriptName, 'hook.js');
      expect(record.message, 'hello world');
      expect(record.level, 'I');
    });

    test('parses v2 messages with an encoded run id', () {
      final record = protocol.parse(
        'JXCONSOLE|v2|frida|run%2F123|hook%20one.js|W|warning',
      );

      expect(record, isNotNull);
      expect(record!.protocolVersion, 'v2');
      expect(record.source, 'frida');
      expect(record.runId, 'run/123');
      expect(record.scriptName, 'hook one.js');
      expect(record.level, 'W');
      expect(record.message, 'warning');
    });

    test('splits the stack trace from the message', () {
      final record = protocol.parse(
        'JXCONSOLE|v2|xposed|run-1|hook.js|E|failed%0A--STACK--%0Aline%201',
      );

      expect(record!.message, 'failed');
      expect(record.stackTrace, 'line 1');
      expect(record.hasStackTrace, isTrue);
    });

    test('rejects non-protocol and incomplete messages', () {
      expect(protocol.parse('ordinary log'), isNull);
      expect(protocol.parse('JXCONSOLE|v1|xposed'), isNull);
      expect(protocol.parse('JXCONSOLE|v3|xposed|run|hook|I|message'), isNull);
    });
  });
}
