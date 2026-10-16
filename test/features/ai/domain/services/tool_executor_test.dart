import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_tool_registry.dart';
import 'package:JsxposedX/features/ai/domain/services/tool_executor.dart';
import 'package:flutter_test/flutter_test.dart';

// ---- 测试用 Mock handler ----

class _MockHandler implements AiChatToolHandler {
  _MockHandler(this.toolName, this._result);

  @override
  final String toolName;
  final Future<String> Function(AiToolCall) _result;

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) =>
      _result(call);
}

AiToolCall _call(String name) => AiToolCall(id: 'call-1', name: name, arguments: {});

// ---- 测试 ----

void main() {
  group('ToolExecutor normal execution', () {
    test('returns ok result on success', () async {
      final executor = ToolExecutor(
        handlers: {
          'test_tool': _MockHandler('test_tool', (_) async => 'result content'),
        },
      );

      final result = await executor.execute(_call('test_tool'));

      expect(result.status, AiToolStatus.ok);
      expect(result.success, isTrue);
      expect(result.content, 'result content');
      expect(result.errorCode, isNull);
      expect(result.meta.durationMs, greaterThanOrEqualTo(0));
      expect(result.meta.retryCount, 0);
    });

    test('returns error for unknown tool', () async {
      final executor = ToolExecutor(handlers: {});

      final result = await executor.execute(_call('nonexistent'));

      expect(result.success, isFalse);
      expect(result.errorCode, AiToolErrorCode.eInternal);
      expect(result.content, contains('未知工具'));
    });
  });

  group('ToolExecutor error code mapping (§4.3)', () {
    test('ArgumentError → E_PARAM', () async {
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async => throw ArgumentError('bad arg')),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.success, isFalse);
      expect(result.errorCode, AiToolErrorCode.eParam);
      expect(result.content, contains('bad arg'));
    });

    test('RangeError → E_PARAM', () async {
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async => throw RangeError('out of range')),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.success, isFalse);
      expect(result.errorCode, AiToolErrorCode.eParam);
    });

    test('FormatException → E_PARAM', () async {
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler(
            'tool',
            (_) async => throw FormatException('invalid format'),
          ),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.success, isFalse);
      expect(result.errorCode, AiToolErrorCode.eParam);
    });

    test('TimeoutException → E_TIMEOUT', () async {
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async {
            await Future<void>.delayed(const Duration(seconds: 1));
            return 'too late';
          }),
        },
        registrations: {
          'tool': AiToolRegistration(
            definition: AiToolDefinition(
              name: 'tool',
              description: '',
              descriptionEn: '',
              parameters: ToolParametersBuilder.empty(),
            ),
            category: AiToolCategory.reverse,
            danger: AiToolDangerLevel.read,
            handlerFactory: (_) => _MockHandler('tool', (_) async => 'ok'),
            timeout: const Duration(milliseconds: 10),
          ),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.success, isFalse);
      expect(result.errorCode, AiToolErrorCode.eTimeout);
    });

    test('generic exception → E_INTERNAL', () async {
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async => throw Exception('boom')),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.success, isFalse);
      expect(result.errorCode, AiToolErrorCode.eInternal);
      expect(result.content, contains('boom'));
    });
  });

  group('ToolExecutor retry matrix (§4.2)', () {
    test('retryable + E_NATIVE: auto retry once with 500ms backoff', () async {
      int attempt = 0;
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async {
            attempt++;
            if (attempt == 1) throw Exception('[NATIVE] transient error');
            return 'recovered';
          }),
        },
        registrations: {
          'tool': AiToolRegistration(
            definition: AiToolDefinition(
              name: 'tool',
              description: '',
              descriptionEn: '',
              parameters: ToolParametersBuilder.empty(),
            ),
            category: AiToolCategory.reverse,
            danger: AiToolDangerLevel.read,
            handlerFactory: (_) => _MockHandler('tool', (_) async => 'ok'),
            timeout: const Duration(seconds: 30),
            retryable: true,
          ),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(attempt, 2);
      expect(result.success, isTrue);
      expect(result.content, 'recovered');
      expect(result.meta.retryCount, 1);
      expect(result.meta.durationMs, greaterThanOrEqualTo(500));
    });

    test('retryable but non-E_NATIVE: no retry', () async {
      int attempt = 0;
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async {
            attempt++;
            throw Exception('generic error');
          }),
        },
        registrations: {
          'tool': AiToolRegistration(
            definition: AiToolDefinition(
              name: 'tool',
              description: '',
              descriptionEn: '',
              parameters: ToolParametersBuilder.empty(),
            ),
            category: AiToolCategory.reverse,
            danger: AiToolDangerLevel.read,
            handlerFactory: (_) => _MockHandler('tool', (_) async => 'ok'),
            timeout: const Duration(seconds: 30),
            retryable: true,
          ),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(attempt, 1);
      expect(result.success, isFalse);
      expect(result.errorCode, AiToolErrorCode.eInternal);
      expect(result.meta.retryCount, 0);
    });

    test('E_PARAM: no retry even if retryable', () async {
      int attempt = 0;
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async {
            attempt++;
            throw ArgumentError('bad param');
          }),
        },
        registrations: {
          'tool': AiToolRegistration(
            definition: AiToolDefinition(
              name: 'tool',
              description: '',
              descriptionEn: '',
              parameters: ToolParametersBuilder.empty(),
            ),
            category: AiToolCategory.reverse,
            danger: AiToolDangerLevel.read,
            handlerFactory: (_) => _MockHandler('tool', (_) async => 'ok'),
            timeout: const Duration(seconds: 30),
            retryable: true,
          ),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(attempt, 1);
      expect(result.errorCode, AiToolErrorCode.eParam);
    });
  });

  group('ToolExecutor 24K truncation (§1.3)', () {
    test('content < 24K: returns ok', () async {
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async => 'short'),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.status, AiToolStatus.ok);
      expect(result.content, 'short');
      expect(result.meta.truncated, isFalse);
    });

    test('content > 24K: returns partial with truncation', () async {
      final longContent = 'X' * 30000;
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async => longContent),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.status, AiToolStatus.partial);
      expect(result.success, isTrue);
      expect(result.content.length, lessThanOrEqualTo(24500));
      expect(result.content, contains('[已截断'));
      expect(result.content, contains('重新调用本工具可继续读取'));
      expect(result.meta.truncated, isTrue);
      expect(result.meta.totalSize, 30000);
      expect(result.meta.nextPageToken, isNotNull);
    });
  });

  group('ToolExecutor meta', () {
    test('durationMs is populated', () async {
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async => 'ok'),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.meta.durationMs, greaterThanOrEqualTo(0));
    });

    test('error message truncated to 500 chars', () async {
      final longMsg = 'E' * 1000;
      final executor = ToolExecutor(
        handlers: {
          'tool': _MockHandler('tool', (_) async => throw Exception(longMsg)),
        },
      );

      final result = await executor.execute(_call('tool'));

      expect(result.content.length, lessThanOrEqualTo(500));
      expect(result.content, endsWith('...'));
    });
  });
}