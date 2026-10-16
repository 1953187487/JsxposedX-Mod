import 'dart:async';
import 'dart:convert';

import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_executor_contract.dart';
import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_tool_registry.dart';

/// 工具执行器：统一超时包装、错误码映射、E_NATIVE 自动重试、24K 截断。
///
/// handler 侧不允许内部 try/catch 吞错（封装标准 §4.3），异常一律冒到本层统一映射。
class ToolExecutor implements AiChatToolExecutorContract {
  ToolExecutor({
    required Map<String, AiChatToolHandler> handlers,
    Map<String, AiToolRegistration>? registrations,
  }) : _handlers = handlers,
       _registrations = registrations ?? const {};

  final Map<String, AiChatToolHandler> _handlers;
  final Map<String, AiToolRegistration> _registrations;

  /// 单工具输出文本硬上限（封装标准 §1.3）
  static const int _maxOutputChars = 24000;

  @override
  Future<AiToolResult> execute(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final handler = _handlers[call.name];
    if (handler == null) {
      return AiToolResult.error(
        call.id,
        call.name,
        '未知工具: ${call.name}',
        errorCode: AiToolErrorCode.eInternal,
      );
    }

    final reg = _registrations[call.name];
    final timeout = reg?.timeout ?? const Duration(seconds: 30);
    final retryable = reg?.retryable ?? false;

    final sw = Stopwatch()..start();
    int retryCount = 0;
    String? content;

    while (true) {
      try {
        content = await handler
            .handle(call, onProgress: onProgress)
            .timeout(timeout);
        break; // 成功，跳出重试循环
      } on TimeoutException {
        sw.stop();
        return _error(
          call,
          AiToolErrorCode.eTimeout,
          '执行超时（${timeout.inSeconds}秒）',
          durationMs: sw.elapsedMilliseconds,
          retryCount: retryCount,
        );
      } on ArgumentError catch (e) {
        sw.stop();
        return _error(call, AiToolErrorCode.eParam, _truncateMsg(e.toString()),
            durationMs: sw.elapsedMilliseconds, retryCount: retryCount);
      } on RangeError catch (e) {
        sw.stop();
        return _error(call, AiToolErrorCode.eParam, _truncateMsg(e.toString()),
            durationMs: sw.elapsedMilliseconds, retryCount: retryCount);
      } on FormatException catch (e) {
        sw.stop();
        return _error(call, AiToolErrorCode.eParam, _truncateMsg(e.toString()),
            durationMs: sw.elapsedMilliseconds, retryCount: retryCount);
      } catch (e, st) {
        // 非超时/非参数异常：判断是否可重试
        final isNativeError =
            _isNativeError(e); // E_NATIVE = native 层原始异常
        if (retryable && retryCount == 0 && isNativeError) {
          retryCount++;
          await Future<void>.delayed(const Duration(milliseconds: 500));
          continue; // 退避 500ms 后重试 1 次
        }

        sw.stop();
        final errorCode = isNativeError
            ? AiToolErrorCode.eNative
            : AiToolErrorCode.eInternal;
        return _error(
          call,
          errorCode,
          _truncateMsg(e.toString()),
          durationMs: sw.elapsedMilliseconds,
          retryCount: retryCount,
        );
      }
    }

    sw.stop();

    // ---- 成功：24K 截断检查 ----
    if (content!.length > _maxOutputChars) {
      final totalSize = content.length;
      final truncated = content.substring(0, _maxOutputChars);
      final pct = ((totalSize - _maxOutputChars) / totalSize * 100).round();
      final nextPageToken =
          base64Encode(utf8.encode('{"offset":$_maxOutputChars}'));
      final tailNote =
          '\n\n[已截断 $pct%，共 $totalSize 字符。带 cursor:"$nextPageToken" 重新调用本工具可继续读取]';
      return AiToolResult.partial(
        call.id,
        call.name,
        truncatedContent: '$truncated$tailNote',
        totalSize: totalSize,
        nextPageToken: nextPageToken,
      )._withMeta(
        durationMs: sw.elapsedMilliseconds,
        retryCount: retryCount,
      );
    }

    return _ok(call, content,
        durationMs: sw.elapsedMilliseconds, retryCount: retryCount);
  }

  Future<List<AiToolResult>> executeAll(List<AiToolCall> calls) async {
    final results = <AiToolResult>[];
    for (final call in calls) {
      results.add(await execute(call));
    }
    return results;
  }

  // ---- 内部工厂 ----

  AiToolResult _ok(AiToolCall call, String content,
          {required int durationMs, required int retryCount}) =>
      AiToolResult.ok(call.id, call.name, content)
          ._withMeta(durationMs: durationMs, retryCount: retryCount);

  AiToolResult _error(AiToolCall call, String errorCode, String message,
          {required int durationMs, required int retryCount}) =>
      AiToolResult.error(call.id, call.name, message, errorCode: errorCode)
          ._withMeta(durationMs: durationMs, retryCount: retryCount);

  /// 错误信息截断至 500 字符（封装标准 §4.3）
  static String _truncateMsg(String msg) =>
      msg.length <= 500 ? msg : '${msg.substring(0, 497)}...';

  /// 检查异常是否为 native 层原始错误（E_NATIVE）。
  ///
  /// 通过异常类型名或消息特征判断。handler 应抛出携带
  /// `[NATIVE]` 前缀的 [Exception]/[StateError] 等原生异常而非吞错。
  static bool _isNativeError(Object e) {
    final msg = e.toString();
    return msg.contains('[NATIVE]') ||
        e.runtimeType.toString().contains('Native') ||
        e.runtimeType.toString().contains('Jni') ||
        e is UnsupportedError; // native FFI 失败常见类型
  }
}

/// 为 [AiToolResult] 补充 meta（durationMs / retryCount）。
///
/// 避免修改 model 层 public API，仅在 executor 内部使用。
extension _ToolResultMetaExt on AiToolResult {
  AiToolResult _withMeta({required int durationMs, required int retryCount}) =>
      AiToolResult(
        toolCallId: toolCallId,
        toolName: toolName,
        success: success,
        content: content,
        status: status,
        errorCode: errorCode,
        data: data,
        meta: AiToolResultMeta(
          truncated: meta.truncated,
          totalSize: meta.totalSize,
          nextPageToken: meta.nextPageToken,
          durationMs: durationMs,
          retryCount: retryCount,
          note: meta.note,
        ),
      );
}