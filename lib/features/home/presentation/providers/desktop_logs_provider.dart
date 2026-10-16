import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:JsxposedX/core/transport/jsxposed_protocol.dart';
import 'package:JsxposedX/features/home/presentation/providers/desktop_connection_provider.dart';

/// 手机端推送的控制台日志条目，字段与 LogcatEntry 对齐
@immutable
class DesktopLogEntry {
  const DesktopLogEntry({
    required this.rawLine,
    required this.level,
    this.tag = '',
    this.message = '',
    this.timestamp = '',
    this.source = 'system',
    this.scriptName = '',
    this.runId = '',
    this.pid = '',
    this.stackTrace = '',
  });

  final String rawLine;
  final String level;
  final String tag;
  final String message;
  final String timestamp;
  final String source;
  final String scriptName;
  final String runId;
  final String pid;
  final String stackTrace;

  /// 展示用文本：结构化条目用 message，否则回退到原始行
  String get displayText => message.isEmpty ? rawLine : message;

  /// 检索用文本，与手机端控制台保持一致（覆盖 source/scriptName/tag/message）
  String get searchText =>
      [source, scriptName, tag, message.isEmpty ? rawLine : message].join('\n');

  factory DesktopLogEntry.fromJson(Map<String, dynamic> json) =>
      DesktopLogEntry(
        rawLine: json['rawLine'] as String? ?? '',
        level: json['level'] as String? ?? 'I',
        tag: json['tag'] as String? ?? '',
        message: json['message'] as String? ?? '',
        timestamp: json['timestamp'] as String? ?? '',
        source: json['source'] as String? ?? 'system',
        scriptName: json['scriptName'] as String? ?? '',
        runId: json['runId'] as String? ?? '',
        pid: json['pid'] as String? ?? '',
        stackTrace: json['stackTrace'] as String? ?? '',
      );
}

/// 历史日志条目，来自手机端 log.query 持久化记录
@immutable
class DesktopHistoryLog {
  const DesktopHistoryLog({
    required this.id,
    required this.runId,
    required this.conversationId,
    required this.source,
    required this.scriptName,
    required this.level,
    required this.message,
    required this.stackTrace,
    required this.timestamp,
  });

  final int id;
  final String runId;
  final String conversationId;
  final String source;
  final String scriptName;
  final String level;
  final String message;
  final String stackTrace;
  final DateTime timestamp;

  factory DesktopHistoryLog.fromJson(Map<String, dynamic> json) =>
      DesktopHistoryLog(
        id: (json['id'] as num?)?.toInt() ?? 0,
        runId: json['runId'] as String? ?? '',
        conversationId: json['conversationId'] as String? ?? '',
        source: json['source'] as String? ?? 'session',
        scriptName: json['scriptName'] as String? ?? '',
        level: json['level'] as String? ?? 'I',
        message: json['message'] as String? ?? '',
        stackTrace: json['stackTrace'] as String? ?? '',
        timestamp:
            DateTime.tryParse(json['timestamp'] as String? ?? '') ??
            DateTime.now().toUtc(),
      );
}

/// 控制台状态，全部由手机端 `console.state` 事件与 `console.get_state` 回包驱动，
/// PC 端不自行推断，保证与手机端完全一致。
@immutable
class DesktopConsoleState {
  const DesktopConsoleState({
    this.isRunning = false,
    this.isStarting = false,
    this.isPaused = false,
    this.autoScroll = true,
    this.searchQuery = '',
    this.filterLevel = 'V',
    this.sessionId = '',
    this.sessionConversationId,
    this.targetPackage = '',
    this.entryCount = 0,
  });

  final bool isRunning;
  final bool isStarting;
  final bool isPaused;
  final bool autoScroll;
  final String searchQuery;
  final String filterLevel;
  final String sessionId;
  final String? sessionConversationId;
  final String targetPackage;
  final int entryCount;

  factory DesktopConsoleState.fromJson(Map<String, dynamic> json) =>
      DesktopConsoleState(
        isRunning: json['isRunning'] as bool? ?? false,
        isStarting: json['isStarting'] as bool? ?? false,
        isPaused: json['isPaused'] as bool? ?? false,
        autoScroll: json['autoScroll'] as bool? ?? true,
        searchQuery: json['searchQuery'] as String? ?? '',
        filterLevel: json['filterLevel'] as String? ?? 'V',
        sessionId: json['sessionId'] as String? ?? '',
        sessionConversationId: json['sessionConversationId'] as String?,
        targetPackage: json['targetPackage'] as String? ?? '',
        entryCount: (json['entryCount'] as num?)?.toInt() ?? 0,
      );
}

/// PC 端控制台镜像状态：日志缓存 + 手机端状态 + 历史分页游标
@immutable
class DesktopConsoleMirror {
  const DesktopConsoleMirror({
    this.entries = const [],
    this.state = const DesktopConsoleState(),
    this.historyLogs = const [],
    this.historyHasMore = false,
    this.historyLoading = false,
    this.historyError,
  });

  final List<DesktopLogEntry> entries;
  final DesktopConsoleState state;
  final List<DesktopHistoryLog> historyLogs;
  final bool historyHasMore;
  final bool historyLoading;
  final String? historyError;

  DesktopConsoleMirror copyWith({
    List<DesktopLogEntry>? entries,
    DesktopConsoleState? state,
    List<DesktopHistoryLog>? historyLogs,
    bool? historyHasMore,
    bool? historyLoading,
    String? historyError,
    bool clearHistoryError = false,
  }) => DesktopConsoleMirror(
    entries: entries ?? this.entries,
    state: state ?? this.state,
    historyLogs: historyLogs ?? this.historyLogs,
    historyHasMore: historyHasMore ?? this.historyHasMore,
    historyLoading: historyLoading ?? this.historyLoading,
    historyError: clearHistoryError ? null : (historyError ?? this.historyError),
  );
}

final desktopLogsProvider =
    NotifierProvider<DesktopLogsNotifier, DesktopConsoleMirror>(
      DesktopLogsNotifier.new,
    );

class DesktopLogsNotifier extends Notifier<DesktopConsoleMirror> {
  static const _maxEntries = 2000;
  static const _historyPageSize = 100;

  StreamSubscription<JsxposedMessage>? _subscription;

  @override
  DesktopConsoleMirror build() {
    final notifier = ref.read(desktopConnectionProvider.notifier);
    _subscription = notifier.events.listen(_handleEvent);
    ref.onDispose(() {
      unawaited(_subscription?.cancel());
      _subscription = null;
    });
    return const DesktopConsoleMirror();
  }

  void _handleEvent(JsxposedMessage message) {
    switch (message.event) {
      case JsxposedEvent.logEntry:
        _appendLog(message.result);
      case JsxposedEvent.consoleState:
        final payload = message.result;
        if (payload is! Map) return;
        state = state.copyWith(
          state: DesktopConsoleState.fromJson(
            payload.cast<String, dynamic>(),
          ),
        );
    }
  }

  void _appendLog(dynamic payload) {
    if (payload is! Map) return;
    final entry = DesktopLogEntry.fromJson(payload.cast<String, dynamic>());
    final combined = <DesktopLogEntry>[...state.entries, entry];
    state = state.copyWith(
      entries: combined.length > _maxEntries
          ? combined.sublist(combined.length - _maxEntries)
          : combined,
    );
  }

  /// 连接成功后同步一次手机端控制台状态，作为初始镜像
  Future<void> syncState() async {
    try {
      final json = await ref
          .read(desktopConnectionProvider.notifier)
          .getConsoleState();
      state = state.copyWith(state: DesktopConsoleState.fromJson(json));
    } catch (error) {
      debugPrint('Failed to sync console state: $error');
    }
  }

  Future<void> setPaused(bool paused) => ref
      .read(desktopConnectionProvider.notifier)
      .setConsolePaused(paused);

  Future<void> setAutoScroll(bool autoScroll) => ref
      .read(desktopConnectionProvider.notifier)
      .setConsoleAutoScroll(autoScroll);

  Future<void> setSearch(String query) => ref
      .read(desktopConnectionProvider.notifier)
      .setConsoleSearch(query);

  Future<void> setLevel(String level) => ref
      .read(desktopConnectionProvider.notifier)
      .setConsoleLevel(level);

  Future<void> setSource(String source) => ref
      .read(desktopConnectionProvider.notifier)
      .setConsoleSource(source);

  /// 清空控制台。本地先乐观清空已缓存日志，再通知手机端清空真源，
  /// 否则手机端清空后广播的 consoleState 不携带日志，PC 列表会残留。
  Future<void> clear() async {
    state = state.copyWith(entries: const [], historyLogs: const []);
    await ref.read(desktopConnectionProvider.notifier).clearConsole();
  }

  Future<void> start(String packageName) =>
      ref.read(desktopConnectionProvider.notifier).startConsole(packageName);

  Future<void> stop() =>
      ref.read(desktopConnectionProvider.notifier).stopConsole();

  /// 加载历史日志分页。首次加载取最新一页，后续以最后一条为游标向前翻。
  Future<void> loadHistory({bool older = false}) async {
    final conversationId = state.state.sessionConversationId;
    if (conversationId == null || conversationId.isEmpty) return;
    if (state.historyLoading) return;

    final existing = older ? state.historyLogs : const <DesktopHistoryLog>[];
    final cursor = existing.isEmpty ? null : existing.last;
    state = state.copyWith(historyLoading: true, clearHistoryError: true);
    try {
      final logs = await ref
          .read(desktopConnectionProvider.notifier)
          .queryLogs(
            conversationId: conversationId,
            before: cursor?.timestamp.toIso8601String(),
            beforeId: cursor?.id,
            limit: _historyPageSize,
          );
      final parsed = [for (final log in logs) DesktopHistoryLog.fromJson(log)];
      state = state.copyWith(
        historyLogs: [...existing, ...parsed],
        historyHasMore: parsed.length >= _historyPageSize,
        historyLoading: false,
      );
    } catch (error) {
      state = state.copyWith(historyLoading: false, historyError: '$error');
    }
  }

  Future<void> deleteHistory() async {
    final conversationId = state.state.sessionConversationId;
    if (conversationId == null || conversationId.isEmpty) return;
    await ref
        .read(desktopConnectionProvider.notifier)
        .deleteConsoleHistory(conversationId);
    state = state.copyWith(historyLogs: const [], historyHasMore: false);
  }
}
