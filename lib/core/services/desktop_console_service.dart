import 'dart:async';

import 'package:JsxposedX/core/services/script_run_service.dart';
import 'package:JsxposedX/core/transport/android_desktop_bridge_server.dart';
import 'package:JsxposedX/features/ai/domain/repositories/script_log_repository.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/logcat_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 把 PC 端通过协议发来的控制台操作转交给手机端 `logcatProvider`。
///
/// 手机端 `logcatProvider` 是控制台状态的唯一真源：PC 端不自行维护暂停、
/// 自动滚动、搜索等状态，只做转发与渲染，状态变更再经 `console.state`
/// 事件回推。`logcatProvider` 是 autoDispose 的，而 PC 端操作时手机端
/// 日志面板可能并未挂载，因此每次操作期间显式持有订阅保活。
class DesktopConsoleService implements DesktopConsoleHost {
  DesktopConsoleService(this._container) {
    AndroidDesktopBridgeServer.instance.clientCount.addListener(
      _onClientCountChanged,
    );
  }

  final ProviderContainer _container;

  @override
  Future<Map<String, dynamic>> getState() async => _withConsole((c) async {
    return {
      'isRunning': c.isRunning,
      'isStarting': c.isStarting,
      'isPaused': c.isPaused,
      'autoScroll': c.isAutoScroll,
      'searchQuery': c.searchQuery,
      'sessionId': c.sessionId,
      'sessionConversationId': c.sessionConversationId,
      'targetPackage': c.targetPackage,
      'entryCount': _container.read(logcatProvider).length,
    };
  });

  @override
  Future<void> setPaused(bool paused) =>
      _withConsole((c) async => c.setPaused(paused));

  @override
  Future<void> setAutoScroll(bool autoScroll) =>
      _withConsole((c) async => c.setAutoScroll(autoScroll));

  @override
  Future<void> setSearch(String query) =>
      _withConsole((c) async => c.setSearchQuery(query));

  @override
  Future<void> clear() => _withConsole((c) async => c.clear());

  @override
  Future<void> start(String packageName) async {
    // 先保活再启动：否则手机端面板未挂载时 provider 会在启动后被销毁
    ScriptRunService.holdRunKeepAlive(_container);
    await _withConsole((c) async => c.start(packageName));
  }

  @override
  Future<void> stop() async {
    try {
      await _withConsole((c) async => c.stop());
    } finally {
      ScriptRunService.releaseRunKeepAlive();
    }
  }

  @override
  Future<Map<String, dynamic>> queryLogs({
    required String conversationId,
    String? before,
    int? beforeId,
    int limit = 100,
  }) async {
    return _withConsole((console) async {
      // PC 端可能刚触发过运行，先把手头待落盘的日志刷进库再查历史
      await console.flushPersistedLogs();
      final repository = _container.read(scriptLogRepositoryProvider);
      final logs = await repository.getLogs(
        conversationId: conversationId,
        before: before == null ? null : DateTime.tryParse(before),
        beforeId: beforeId,
        limit: limit,
      );
      return {
        'conversationId': conversationId,
        'logs': [for (final log in logs) _logToJson(log)],
      };
    });
  }

  @override
  Future<void> deleteHistory(String conversationId) async {
    await _withConsole((console) async {
      await console.flushPersistedLogs();
      await _container
          .read(scriptLogRepositoryProvider)
          .deleteConversationLogs(conversationId);
    });
  }

  /// PC 端全部断开时释放保活并停掉采集，避免手机端后台常驻采集进程。
  void _onClientCountChanged() {
    if (AndroidDesktopBridgeServer.instance.clientCount.value > 0) return;
    ScriptRunService.releaseRunKeepAlive();
    unawaited(_withConsole((c) async => c.stop()));
  }

  Future<T> _withConsole<T>(
    Future<T> Function(Logcat notifier) action,
  ) async {
    final keepAlive = _container.listen(logcatProvider, (_, _) {});
    try {
      return await action(_container.read(logcatProvider.notifier));
    } finally {
      keepAlive.close();
    }
  }

  static Map<String, dynamic> _logToJson(ScriptLogRecord log) => {
    'id': log.id,
    'runId': log.runId,
    'conversationId': log.conversationId,
    'source': log.source,
    'scriptName': log.scriptName,
    'level': log.level,
    'message': log.message,
    'stackTrace': log.stackTrace,
    'timestamp': log.timestamp.toIso8601String(),
  };
}
