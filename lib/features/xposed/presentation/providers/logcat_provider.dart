import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:JsxposedX/core/transport/android_desktop_bridge_server.dart';
import 'package:JsxposedX/core/transport/jsxposed_protocol.dart';
import 'package:JsxposedX/features/ai/domain/repositories/script_log_repository.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/xposed/domain/services/jxconsole_log_protocol.dart';

part 'logcat_provider.g.dart';

DateTime _logcatTimestamp(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed != null) return parsed.toUtc();
  final match = RegExp(
    r'^(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})\.(\d+)$',
  ).firstMatch(value);
  if (match == null) return DateTime.now().toUtc();
  final now = DateTime.now();
  final fraction = match.group(6)!.padRight(6, '0').substring(0, 6);
  final candidates = [now.year - 1, now.year, now.year + 1].map(
    (year) => DateTime(
      year,
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(fraction.substring(0, 3)),
      int.parse(fraction.substring(3, 6)),
    ),
  );
  return candidates
      .reduce(
        (a, b) => a.difference(now).abs() <= b.difference(now).abs() ? a : b,
      )
      .toUtc();
}

class LogcatEntry {
  final String rawLine;
  final String level;
  final String tag;
  final String message;
  final String timestamp;
  final String source;
  final String scriptName;
  final String runId;
  final String sessionId;
  final String pid;
  final String tid;
  final String stackTrace;
  late final String searchText;
  late final String searchTextRaw;

  LogcatEntry({
    required this.rawLine,
    required this.level,
    this.tag = '',
    this.message = '',
    this.timestamp = '',
    this.source = 'system',
    this.scriptName = '',
    this.runId = '',
    this.sessionId = '',
    this.pid = '',
    this.tid = '',
    this.stackTrace = '',
  }) {
    // searchText 供默认的忽略大小写检索，searchTextRaw 供大小写敏感检索。
    searchTextRaw = [
      rawLine,
      message,
      source,
      scriptName,
      runId,
      tag,
      stackTrace,
      pid,
    ].join('\n');
    searchText = searchTextRaw.toLowerCase();
  }

  /// 供桌面端桥接推送的序列化形式，字段与手机端控制台展示保持一致
  Map<String, dynamic> toJson() => {
    'rawLine': rawLine,
    'level': level,
    'tag': tag,
    'message': message,
    'timestamp': timestamp,
    'source': source,
    'scriptName': scriptName,
    'runId': runId,
    'sessionId': sessionId,
    'pid': pid,
    'tid': tid,
    'stackTrace': stackTrace,
  };
}

@riverpod
class Logcat extends _$Logcat {
  static const _maxEntries = 2000;
  static const _maxPausedEntries = 4000;
  static const _flushBatchSize = 32;
  static const _flushInterval = Duration(milliseconds: 50);
  static const _scriptLogFlushInterval = Duration(milliseconds: 250);

  Process? _process;
  int _processGeneration = 0;
  bool _isStarting = false;
  StreamSubscription<String>? _stdoutSubscription;
  StreamSubscription<String>? _stderrSubscription;
  Timer? _flushTimer;
  Timer? _scriptLogFlushTimer;
  final List<LogcatEntry> _pendingEntries = <LogcatEntry>[];
  final List<LogcatEntry> _pausedEntries = <LogcatEntry>[];
  final StreamController<LogcatEntry> _structuredLogController =
      StreamController<LogcatEntry>.broadcast();
  final Map<String, ScriptRunRecord> _knownRuns = {};
  final List<ScriptLogRecord> _pendingScriptLogs = [];
  Future<void> _structuredLogChain = Future<void>.value();
  Future<void> _scriptLogWriteChain = Future<void>.value();
  bool _hasReportedPersistenceError = false;
  bool _isAutoScroll = true;
  bool _isPaused = false;
  int _droppedPausedEntries = 0;
  String _targetPackage = '';
  String _searchQuery = '';
  String _sessionId = '';
  String _sessionSource = 'all';
  String _sessionScriptName = '';
  String? _sessionConversationId;
  bool _isDisposed = false;

  @override
  List<LogcatEntry> build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _stopProcess();
      _scriptLogFlushTimer?.cancel();
      _structuredLogController.close();
      _pendingEntries.clear();
      _pausedEntries.clear();
    });
    return [];
  }

  bool get isAutoScroll => _isAutoScroll;

  /// PC 端控制台状态全部来源于此，手机端为唯一真源。
  /// 无客户端连接时 broadcast 内部直接返回，避免无谓序列化。
  void _broadcastState() {
    if (_isDisposed) return;
    AndroidDesktopBridgeServer.instance.broadcast(
      JsxposedEvent.consoleState,
      {
        'isRunning': isRunning,
        'isStarting': _isStarting,
        'isPaused': _isPaused,
        'autoScroll': _isAutoScroll,
        'searchQuery': _searchQuery,
        'sessionId': _sessionId,
        'sessionConversationId': _sessionConversationId,
        'targetPackage': _targetPackage,
        'entryCount': state.length,
      },
    );
  }

  /// 结构化脚本日志广播流。
  ///
  /// 该流在 UI 过滤、暂停、清屏之前发出，供持久化 recorder 独立消费，
  /// 不受控制台视图状态影响。仅推送带 runId 的可识别结构化日志。
  Stream<LogcatEntry> get structuredLogs => _structuredLogController.stream;

  bool get isPaused => _isPaused;
  bool get isRunning => _process != null;
  bool get isStarting => _isStarting;
  String get searchQuery => _searchQuery;
  String get sessionId => _sessionId;
  String get sessionSource => _sessionSource;
  String get sessionScriptName => _sessionScriptName;
  String? get sessionConversationId => _sessionConversationId;
  String get targetPackage => _targetPackage;

  void setAutoScroll(bool value) {
    if (_isAutoScroll == value) return;
    _isAutoScroll = value;
    // This is a low-frequency UI action; notify consumers without mutating entries.
    state = List<LogcatEntry>.unmodifiable(state);
    _broadcastState();
  }

  void setPaused(bool value) {
    if (_isPaused == value) return;
    if (value) {
      _flushPending();
      _isPaused = true;
    } else {
      _isPaused = false;
      // 暂停期间超出上限被丢弃的日志不能静默消失，恢复时补一条占位说明。
      if (_droppedPausedEntries > 0) {
        _pausedEntries.insert(
          0,
          LogcatEntry(
            rawLine: '',
            level: 'W',
            message:
                '暂停期间有 $_droppedPausedEntries 条日志因超出缓存上限被丢弃'
                ' / $_droppedPausedEntries entries were dropped while paused',
            source: _sessionSource,
            scriptName: _sessionScriptName,
            sessionId: _sessionId,
            tag: 'console',
          ),
        );
        _droppedPausedEntries = 0;
      }
      if (_pausedEntries.isNotEmpty) {
        _pendingEntries.addAll(_pausedEntries);
        _pausedEntries.clear();
      }
      _flushPending();
    }
    state = List<LogcatEntry>.unmodifiable(state);
    _broadcastState();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    // Search changes are user-driven and infrequent compared with log events.
    state = List<LogcatEntry>.unmodifiable(state);
    _broadcastState();
  }

  void configureSession(
    String source,
    String scriptName, {
    String? conversationId,
  }) {
    _sessionSource = source;
    _sessionScriptName = scriptName;
    _sessionConversationId = conversationId;
  }

  Future<void> _persistStructuredLog(LogcatEntry entry) async {
    if (entry.runId.isEmpty) return;
    try {
      final repository = ref.read(scriptLogRepositoryProvider);
      var run = _knownRuns[entry.runId];
      run ??= await repository.getRun(entry.runId);
      final entryScriptName = entry.scriptName.split('/').last;
      if (run == null) {
        _reportPersistenceError('run-missing', 'runId=${entry.runId}');
        return;
      }
      if (run.source != entry.source ||
          run.scriptName.split('/').last != entryScriptName) {
        _reportPersistenceError(
          'metadata-mismatch',
          'expected ${run.source}/${run.scriptName}, '
              'received ${entry.source}/${entry.scriptName}',
        );
        return;
      }
      _knownRuns[entry.runId] = run;
      _pendingScriptLogs.add(
        ScriptLogRecord(
          id: 0,
          runId: run.runId,
          conversationId: run.conversationId,
          source: entry.source,
          scriptName: run.scriptName,
          level: entry.level,
          message: entry.message,
          stackTrace: entry.stackTrace,
          timestamp: _logcatTimestamp(entry.timestamp),
        ),
      );
      if (_pendingScriptLogs.length >= _flushBatchSize) {
        await _flushScriptLogs();
      } else {
        _scheduleScriptLogFlush();
      }
    } catch (error, stackTrace) {
      debugPrint('Script log persistence lookup failed: $error\n$stackTrace');
      _reportPersistenceError('lookup-error', error.toString());
    }
  }

  void _scheduleScriptLogFlush() {
    if (_scriptLogFlushTimer != null || _isDisposed) return;
    _scriptLogFlushTimer = Timer(_scriptLogFlushInterval, () {
      _scriptLogFlushTimer = null;
      unawaited(_flushScriptLogs());
    });
  }

  Future<void> _flushScriptLogs() {
    _scriptLogFlushTimer?.cancel();
    _scriptLogFlushTimer = null;
    if (_pendingScriptLogs.isEmpty) return _scriptLogWriteChain;
    final batch = List<ScriptLogRecord>.of(_pendingScriptLogs);
    _pendingScriptLogs.clear();
    final repository = ref.read(scriptLogRepositoryProvider);
    _scriptLogWriteChain = _scriptLogWriteChain.catchError((_) {}).then((
      _,
    ) async {
      try {
        await repository.appendLogs(batch);
        _hasReportedPersistenceError = false;
      } catch (error, stackTrace) {
        _pendingScriptLogs.insertAll(0, batch);
        debugPrint('Script log persistence write failed: $error\n$stackTrace');
        _reportPersistenceError('write-error', error.toString());
      }
    });
    return _scriptLogWriteChain;
  }

  /// 脚本日志未持久化时的诊断提示。
  ///
  /// [reason] 用于区分失败环节，便于定位是运行记录缺失、元数据不一致，
  /// 还是数据库读写本身出错。
  void _reportPersistenceError(String reason, String detail) {
    if (_hasReportedPersistenceError || _isDisposed) return;
    _hasReportedPersistenceError = true;
    _enqueueEntry(
      LogcatEntry(
        rawLine: detail,
        level: 'E',
        message:
            '脚本日志未持久化（$reason）/ Script log not persisted '
            '($reason): $detail',
        source: 'session',
        scriptName: _sessionScriptName,
        sessionId: _sessionId,
        tag: 'persistence',
      ),
    );
  }

  void _queueStructuredLog(LogcatEntry entry) {
    _structuredLogChain = _structuredLogChain.then((_) async {
      await _persistStructuredLog(entry);
      if (!_structuredLogController.isClosed) {
        _structuredLogController.add(entry);
      }
    });
  }

  Future<void> _flushAllScriptLogs() async {
    await _structuredLogChain;
    await _flushScriptLogs();
  }

  Future<void> start(String packageName) async {
    if (_targetPackage != packageName && (_process != null || _isStarting)) {
      _targetPackage = packageName;
      await _flushScriptLogs();
      _stopProcess();
    } else {
      _targetPackage = packageName;
    }
    if (_process != null || _isStarting) return;
    _isStarting = true;
    final generation = ++_processGeneration;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _isPaused = false;

    // Auto clear on start.
    _pendingEntries.clear();
    _pausedEntries.clear();
    _droppedPausedEntries = 0;
    _flushTimer?.cancel();
    _flushTimer = null;
    state = const [];

    try {
      // threadtime exposes pid/tid, which lets the Dart side classify entries reliably.
      final process = await Process.start('su', [
        '-c',
        'logcat -v threadtime -T 1',
      ]);
      if (_isDisposed || generation != _processGeneration) {
        process.kill();
        return;
      }
      _process = process;
      _stdoutSubscription = process.stdout
          .transform(const Utf8Decoder(allowMalformed: true))
          .transform(const LineSplitter())
          .listen(
            (line) {
              if (_isDisposed || generation != _processGeneration) return;
              final entry = _parseLine(line);
              if (entry.runId.isNotEmpty) {
                _queueStructuredLog(entry);
              }
              if (!_passesFilter(entry)) return;
              if (_isPaused) {
                _pausedEntries.add(entry);
                if (_pausedEntries.length > _maxPausedEntries) {
                  final overflow = _pausedEntries.length - _maxPausedEntries;
                  _pausedEntries.removeRange(0, overflow);
                  _droppedPausedEntries += overflow;
                }
                return;
              }
              _pendingEntries.add(entry);
              if (_pendingEntries.length >= _flushBatchSize) {
                _flushPending();
              } else {
                _scheduleFlush();
              }
            },
            onDone: () => _handleProcessDone(process),
            onError: (_, __) => _handleProcessDone(process),
          );
      _stderrSubscription = process.stderr
          .transform(const Utf8Decoder(allowMalformed: true))
          .transform(const LineSplitter())
          .listen((line) {
            if (line.trim().isEmpty) return;
            _enqueueEntry(
              LogcatEntry(
                rawLine: line,
                level: 'E',
                message: _describeCaptureStderr(line),
                source: 'session',
                sessionId: _sessionId,
                scriptName: _sessionScriptName,
                tag: 'logcat',
              ),
            );
          });
      _enqueueEntry(
        LogcatEntry(
          rawLine: '',
          level: 'I',
          message: 'Console connected to $packageName',
          source: 'session',
          scriptName: _sessionScriptName,
          sessionId: _sessionId,
          tag: _sessionSource,
        ),
      );
      unawaited(
        process.exitCode.then((code) {
          final isUserStopped = _isDisposed || generation != _processGeneration;
          if (!isUserStopped && code != 0) {
            _enqueueEntry(
              LogcatEntry(
                rawLine: 'exit code $code',
                level: 'E',
                message: _describeCaptureExit(code),
                source: 'session',
                scriptName: _sessionScriptName,
                sessionId: _sessionId,
                tag: _sessionSource,
              ),
            );
          }
          _handleProcessDone(process);
        }),
      );
    } catch (e) {
      debugPrint("Logcat error: $e");
      _enqueueEntry(
        LogcatEntry(
          rawLine: e.toString(),
          level: 'E',
          message: _describeCaptureStartFailure(e),
          source: 'session',
          scriptName: _sessionScriptName,
          sessionId: _sessionId,
          tag: _sessionSource,
        ),
      );
    } finally {
      if (generation == _processGeneration) {
        _isStarting = false;
      }
      _broadcastState();
    }
  }

  void stop() {
    _flushPending();
    unawaited(_flushScriptLogs());
    _stopProcess();
    _broadcastState();
  }

  Future<void> flushPersistedLogs() => _flushAllScriptLogs();

  void clear() {
    _pendingEntries.clear();
    _pausedEntries.clear();
    _droppedPausedEntries = 0;
    _flushTimer?.cancel();
    _flushTimer = null;
    if (state.isNotEmpty) state = const [];
    _broadcastState();
  }

  void addSessionEvent({
    required String message,
    String level = 'I',
    String? source,
    String? scriptName,
  }) {
    _enqueueEntry(
      LogcatEntry(
        rawLine: message,
        level: level,
        message: message,
        source: 'session',
        scriptName: scriptName ?? _sessionScriptName,
        sessionId: _sessionId,
        tag: source ?? _sessionSource,
      ),
    );
  }

  /// 采集进程 stderr 的常见 root 环境错误，转成可操作的提示。
  String _describeCaptureStderr(String line) {
    final lower = line.toLowerCase();
    if (lower.contains('permission denied') || lower.contains('not allowed')) {
      return 'su 授权被拒绝，请在 root 管理器中允许本应用'
          ' / su permission denied: $line';
    }
    if (lower.contains('no such file') || lower.contains('not found')) {
      return '未找到 su 或 logcat 命令 / su or logcat not found: $line';
    }
    return line;
  }

  /// 采集进程非用户主动停止时的异常退出提示。
  String _describeCaptureExit(int code) {
    if (code == 1 || code == 255) {
      return 'su 授权被拒绝或 logcat 不可用（退出码 $code）'
          ' / su denied or logcat unavailable (exit code $code)';
    }
    return '日志采集进程异常退出（退出码 $code）'
        ' / Log capture exited abnormally (exit code $code)';
  }

  /// 采集进程无法启动时的原因分类。
  String _describeCaptureStartFailure(Object error) {
    if (error is ProcessException) {
      final message = error.message.toLowerCase();
      if (error.errorCode == 2 || message.contains('no such file')) {
        return '未找到 su 可执行文件，请确认 root 管理工具已正确安装'
            ' / su executable not found; verify your root manager is installed';
      }
      if (error.errorCode == 13 || message.contains('permission denied')) {
        return 'su 执行被拒绝，请在 root 管理器中允许本应用'
            ' / su execution denied; allow this app in your root manager';
      }
      return '无法启动日志采集（${error.message}）'
          ' / Unable to start log capture (${error.message})';
    }
    return '无法启动日志采集：$error / Unable to start log capture: $error';
  }

  void _scheduleFlush() {
    if (_flushTimer != null || _isDisposed) return;
    _flushTimer = Timer(_flushInterval, () {
      _flushTimer = null;
      _flushPending();
    });
  }

  void _flushPending() {
    if (_pendingEntries.isEmpty || _isDisposed) return;
    final pending = List<LogcatEntry>.from(_pendingEntries, growable: false);
    _pendingEntries.clear();
    // PC 端控制台镜像手机端可见日志；无客户端连接时 broadcast 内部直接返回
    for (final entry in pending) {
      AndroidDesktopBridgeServer.instance.broadcast(
        JsxposedEvent.logEntry,
        entry.toJson(),
      );
    }
    final combined = <LogcatEntry>[...state, ...pending];
    final start = combined.length > _maxEntries
        ? combined.length - _maxEntries
        : 0;
    state = List<LogcatEntry>.unmodifiable(combined.sublist(start));
  }

  void _handleProcessDone(Process process) {
    if (_isDisposed || !identical(_process, process)) return;
    _flushPending();
    unawaited(_flushAllScriptLogs());
    _stdoutSubscription = null;
    _stderrSubscription?.cancel();
    _stderrSubscription = null;
    _process = null;
    state = List<LogcatEntry>.unmodifiable(state);
  }

  void _stopProcess() {
    _processGeneration += 1;
    _isStarting = false;
    _flushTimer?.cancel();
    _flushTimer = null;
    _stdoutSubscription?.cancel();
    _stdoutSubscription = null;
    _stderrSubscription?.cancel();
    _stderrSubscription = null;
    _process?.kill();
    _process = null;
  }

  void _enqueueEntry(LogcatEntry entry) {
    if (_isPaused) {
      _pausedEntries.add(entry);
      if (_pausedEntries.length > _maxPausedEntries) {
        _pausedEntries.removeRange(
          0,
          _pausedEntries.length - _maxPausedEntries,
        );
      }
      return;
    }
    _pendingEntries.add(entry);
    if (_pendingEntries.length >= _flushBatchSize) {
      _flushPending();
    } else {
      _scheduleFlush();
    }
  }

  bool _passesFilter(LogcatEntry entry) {
    if (entry.rawLine.isEmpty && entry.message.isEmpty) return false;

    // Script markers are session-scoped. A Frida console must not display
    // Xposed output (and vice versa), even though both share Logcat.
    if (entry.source == 'frida' || entry.source == 'xposed') {
      return _sessionSource == 'all' || entry.source == _sessionSource;
    }

    // Core filter for JsxposedX 业务日志
    bool isRelevant =
        entry.rawLine.contains('JsxposedX') || // LogX 统一日志
        entry.rawLine.contains('FridaInjectTest') || // Frida 注入日志
        entry.rawLine.contains('HookJsXposed') || // Xposed Hook 日志
        entry.rawLine.contains('JsxposedProvider') || // Provider 日志
        entry.rawLine.contains('AttachHooker') || // Hook 附加日志
        entry.rawLine.contains('StatusManagement') || // 状态管理日志
        entry.rawLine.contains('AuditLogProvider');

    // 包含目标应用包名的日志也显示
    if (_targetPackage.isNotEmpty && entry.rawLine.contains(_targetPackage)) {
      isRelevant = true;
    }

    return isRelevant;
  }

  static final _threadtimeRegex = RegExp(
    r'^(\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+)\s+(\d+)\s+(\d+)\s+([VDIWEF])\s+([^:]+):\s?(.*)$',
  );
  static final _timeRegex = RegExp(
    r'^(\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+)\s+([VDIWEF])\/([^(:]+)(?:\(\s*(\d+)\))?:\s?(.*)$',
  );

  LogcatEntry _parseLine(String line) {
    final threadMatch = _threadtimeRegex.firstMatch(line);
    final timeMatch = _timeRegex.firstMatch(line);
    final timestamp = threadMatch?.group(1) ?? timeMatch?.group(1) ?? '';
    final pid = threadMatch?.group(2) ?? timeMatch?.group(4) ?? '';
    final tid = threadMatch?.group(3) ?? '';
    final level = threadMatch?.group(4) ?? timeMatch?.group(2) ?? 'I';
    final tag = (threadMatch?.group(5) ?? timeMatch?.group(3) ?? '').trim();
    final message = threadMatch?.group(6) ?? timeMatch?.group(5) ?? line;

    var entry = LogcatEntry(
      rawLine: line,
      level: level,
      timestamp: timestamp,
      tag: tag,
      message: message,
      source: _sourceForTag(tag),
      sessionId: _sessionId,
      pid: pid,
      tid: tid,
    );

    final marker = _protocol.parse(message);
    if (marker != null) {
      entry = LogcatEntry(
        rawLine: line,
        level: marker.level,
        timestamp: timestamp,
        tag: tag,
        message: marker.message,
        source: marker.source,
        scriptName: marker.scriptName,
        runId: marker.runId,
        sessionId: _sessionId,
        pid: pid,
        tid: tid,
        stackTrace: marker.stackTrace,
      );
    }
    return entry;
  }

  String _sourceForTag(String tag) {
    final normalized = tag.toLowerCase();
    if (normalized.contains('frida')) return 'frida';
    if (normalized.contains('jsxposed')) return 'framework';
    if (normalized.contains('xposed') || normalized.contains('lsposed')) {
      return 'xposed';
    }
    if (_targetPackage.isNotEmpty &&
        normalized.contains(_targetPackage.toLowerCase())) {
      return 'app';
    }
    return 'system';
  }

  static const _protocol = JxConsoleLogProtocol();
}
