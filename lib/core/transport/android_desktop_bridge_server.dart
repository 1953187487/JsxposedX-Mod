import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:JsxposedX/core/transport/jsxposed_protocol.dart';
import 'package:JsxposedX/core/utils/path_utils.dart';
import 'package:JsxposedX/generated/pinia.g.dart';
import 'package:JsxposedX/generated/project.g.dart';
import 'package:JsxposedX/generated/status_management.g.dart';

/// 控制台能力的设备侧宿主。手机端 `logcatProvider` 是唯一真源，
/// 传输层只做转发，这里以接口注入避免反向依赖 Riverpod 与页面逻辑。
abstract interface class DesktopConsoleHost {
  /// 读取控制台当前状态（运行/暂停/自动滚动/搜索/会话/计数）
  Future<Map<String, dynamic>> getState();

  Future<void> setPaused(bool paused);

  Future<void> setAutoScroll(bool autoScroll);

  Future<void> setSearch(String query);

  Future<void> clear();

  Future<void> start(String packageName);

  Future<void> stop();

  /// 历史日志分页，cursor 为上一页最后一条的 (timestamp, id)
  Future<Map<String, dynamic>> queryLogs({
    required String conversationId,
    String? before,
    int? beforeId,
    int limit,
  });

  Future<void> deleteHistory(String conversationId);
}

class AndroidDesktopBridgeServer {
  AndroidDesktopBridgeServer._();

  static final instance = AndroidDesktopBridgeServer._();

  HttpServer? _server;
  final Set<WebSocket> _clients = {};
  final StatusManagementNative _statusManagement = StatusManagementNative();
  final ProjectNative _projectNative = ProjectNative();
  final PiniaNative _piniaNative = PiniaNative();
  Map<String, dynamic>? _deviceInfo;

  /// 当前已连接的 PC 客户端数量，供手机端界面展示电脑连接状态
  final ValueNotifier<int> clientCount = ValueNotifier<int>(0);

  /// 运行脚本要拉日志、建运行记录、必要时拉起重启应用，属于应用层职责。
  /// 这里以回调注入，避免传输层反向依赖 Riverpod 与页面逻辑。
  Future<void> Function({
    required String packageName,
    required String source,
    required String localPath,
    required bool restartApp,
  })?
  scriptRunner;

  /// 控制台能力宿主，与 [scriptRunner] 同理由应用层注入
  DesktopConsoleHost? consoleHost;

  bool get isRunning => _server != null;
  bool get hasClient => clientCount.value > 0;

  void _syncClientCount() => clientCount.value = _clients.length;

  /// 主动向所有已连接的 PC 客户端推送事件帧（如控制台日志）
  void broadcast(String event, dynamic payload) {
    if (_clients.isEmpty) return;
    final message = JsxposedMessage.event(
      event: event,
      payload: payload,
      deviceId: _deviceInfo?['deviceId'] as String?,
    ).encode();
    for (final client in _clients) {
      try {
        client.add(message);
      } catch (error) {
        debugPrint('Desktop bridge broadcast failed: $error');
      }
    }
  }

  Future<void> start() async {
    if (kIsWeb || !Platform.isAndroid || isRunning) return;
    _deviceInfo = await _loadDeviceInfo();
    try {
      final server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        jsxposedWebSocketPort,
        shared: true,
      );
      _server = server;
      unawaited(_serve(server));
    } catch (error, stackTrace) {
      debugPrint('Failed to start desktop bridge: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> stop() async {
    final clients = _clients.toList();
    _clients.clear();
    _syncClientCount();
    for (final client in clients) {
      await client.close();
    }
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _serve(HttpServer server) async {
    await for (final request in server) {
      if (!WebSocketTransformer.isUpgradeRequest(request)) {
        request.response
          ..statusCode = HttpStatus.upgradeRequired
          ..write('WebSocket upgrade required');
        await request.response.close();
        continue;
      }
      try {
        final socket = await WebSocketTransformer.upgrade(request);
        _clients.add(socket);
        _syncClientCount();
        socket.listen(
          (data) => _handleMessage(socket, data),
          onDone: () {
            _clients.remove(socket);
            _syncClientCount();
          },
          onError: (_) {
            _clients.remove(socket);
            _syncClientCount();
          },
          cancelOnError: true,
        );
      } catch (error) {
        debugPrint('Desktop bridge upgrade failed: $error');
      }
    }
  }

  Future<void> _handleMessage(WebSocket socket, dynamic data) async {
    JsxposedMessage request;
    try {
      request = JsxposedMessage.decode(data.toString());
    } catch (error) {
      socket.add(
        JsxposedMessage.response(
          id: 'unknown',
          ok: false,
          error: JsxposedError(
            code: 'SCRIPT_INVALID',
            message: 'Invalid protocol message: $error',
          ),
        ).encode(),
      );
      return;
    }

    if (request.type != 'request' || request.id == null) return;
    final startedAt = DateTime.now();
    try {
      final result = await _route(request);
      socket.add(
        JsxposedMessage.response(
          id: request.id!,
          ok: true,
          result: result,
          meta: {
            'durationMs': DateTime.now().difference(startedAt).inMilliseconds,
          },
        ).encode(),
      );
    } on _ProtocolException catch (error) {
      socket.add(
        JsxposedMessage.response(
          id: request.id!,
          ok: false,
          error: JsxposedError(code: error.code, message: error.message),
        ).encode(),
      );
    } catch (error) {
      socket.add(
        JsxposedMessage.response(
          id: request.id!,
          ok: false,
          error: JsxposedError(
            code: 'INTERNAL_ERROR',
            message: error.toString(),
          ),
        ).encode(),
      );
    }
  }

  Future<Map<String, dynamic>> _route(JsxposedMessage request) async {
    switch (request.method) {
      case JsxposedMethod.handshake:
        final requestedVersion = request.params?['protocolVersion'];
        if (requestedVersion != jsxposedProtocolVersion) {
          throw const _ProtocolException(
            JsxposedErrorCode.protocolVersionUnsupported,
            'Unsupported protocol version',
          );
        }
        return {
          'protocolVersion': jsxposedProtocolVersion,
          'server': 'JsxposedX Android',
          'deviceId': _deviceInfo?['deviceId'],
        };
      case JsxposedMethod.heartbeat:
        return {'timestamp': DateTime.now().toUtc().toIso8601String()};
      case JsxposedMethod.deviceGetInfo:
        return Map<String, dynamic>.from(_deviceInfo ?? const {});
      case JsxposedMethod.deviceGetCapabilities:
        return _loadCapabilities();
      case JsxposedMethod.deviceGetHealth:
        return {
          'status': 'ready',
          'connectedClients': _clients.length,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        };
      case JsxposedMethod.deviceSubscribeEvents:
        return {'subscribed': true};
      case JsxposedMethod.projectList:
        return _listProjects();
      case JsxposedMethod.scriptList:
        return _listScripts(request.params);
      case JsxposedMethod.scriptRead:
        return _readScript(request.params);
      case JsxposedMethod.scriptWrite:
        return _writeScript(request.params);
      case JsxposedMethod.scriptDelete:
        return _deleteScript(request.params);
      case JsxposedMethod.scriptToggle:
        return _toggleScript(request.params);
      case JsxposedMethod.scriptRun:
        return _runScript(request.params);
      case JsxposedMethod.shellExec:
        return _shellExec(request.params);
      case JsxposedMethod.shellOpen:
        return _shellOpen(request.params);
      case JsxposedMethod.shellWrite:
        return _shellWrite(request.params);
      case JsxposedMethod.shellClose:
        return _shellCloseSession();
      case JsxposedMethod.consoleGetState:
        return _consoleHost().getState();
      case JsxposedMethod.consoleSetPaused:
        await _consoleHost().setPaused(_requireBool(request.params, 'paused'));
        return {'paused': _requireBool(request.params, 'paused')};
      case JsxposedMethod.consoleSetAutoScroll:
        final autoScroll = _requireBool(request.params, 'autoScroll');
        await _consoleHost().setAutoScroll(autoScroll);
        return {'autoScroll': autoScroll};
      case JsxposedMethod.consoleSetSearch:
        await _consoleHost().setSearch(request.params?['query'] as String? ?? '');
        return {'query': request.params?['query'] as String? ?? ''};
      case JsxposedMethod.consoleClear:
        await _consoleHost().clear();
        return {'cleared': true};
      case JsxposedMethod.consoleStart:
        await _consoleHost().start(_requireString(request.params, 'packageName'));
        return {'started': true};
      case JsxposedMethod.consoleStop:
        await _consoleHost().stop();
        return {'stopped': true};
      case JsxposedMethod.logQuery:
        return _consoleHost().queryLogs(
          conversationId: _requireString(request.params, 'conversationId'),
          before: request.params?['before'] as String?,
          beforeId: (request.params?['beforeId'] as num?)?.toInt(),
          limit: (request.params?['limit'] as num?)?.toInt() ?? 100,
        );
      case JsxposedMethod.logDeleteHistory:
        await _consoleHost().deleteHistory(
          _requireString(request.params, 'conversationId'),
        );
        return {'deleted': true};
      case JsxposedMethod.requestCancel:
        return {'cancelled': request.params?['requestId']};
      default:
        throw _ProtocolException(
          JsxposedErrorCode.capabilityUnavailable,
          'Unsupported method: ${request.method}',
        );
    }
  }

  /// 供原生层调用的请求处理入口
  Future<Map<String, dynamic>> handleRequestFromNative(
    String method,
    Map<String, dynamic>? params,
  ) async {
    final request = JsxposedMessage(
      type: 'request',
      id: 'native-${DateTime.now().millisecondsSinceEpoch}',
      method: method,
      params: params,
    );
    return _route(request);
  }

  /// 项目即手机端以包名命名的脚本目录，脚本本体与启停状态都由手机端维护
  Future<Map<String, dynamic>> _listProjects() async {
    final projects = await _projectNative.getProjects();
    print('📦 Projects count: ${projects.length}');
    for (final project in projects) {
      print('📱 ${project.name}: icon=${project.icon?.length ?? 0} bytes');
    }
    return {
      'projects': [
        for (final project in projects)
          {
            'packageName': project.packageName,
            'name': project.name,
            'versionName': project.versionName,
            'versionCode': project.versionCode,
            if (project.icon != null && project.icon!.isNotEmpty)
              'iconUrl': 'data:image/png;base64,${base64Encode(project.icon!)}',
          },
      ],
    };
  }

  Future<Map<String, dynamic>> _listScripts(
    Map<String, dynamic>? params,
  ) async {
    final packageName = _requireString(params, 'packageName');
    final source = _requireScriptSource(params);
    final paths = await _scriptNames(packageName, source);
    final scripts = <Map<String, dynamic>>[];
    for (final path in paths) {
      scripts.add({
        'localPath': path,
        'name': _displayName(path, source),
        // 手机端启停键按完整路径写入，这里必须保持一致
        'enabled': await _readScriptEnabled(packageName, source, path),
      });
    }
    return {'packageName': packageName, 'source': source, 'scripts': scripts};
  }

  Future<Map<String, dynamic>> _readScript(Map<String, dynamic>? params) async {
    final packageName = _requireString(params, 'packageName');
    final source = _requireScriptSource(params);
    final localPath = _requireString(params, 'localPath');
    final paths = await _scriptNames(packageName, source);
    final found = _findScriptPath(paths, localPath);
    if (found == null) {
      throw _ProtocolException(
        JsxposedErrorCode.scriptNotFound,
        'Script not found: $localPath',
      );
    }
    final content = await _readScriptContent(
      packageName,
      source,
      PathUtils.getName(path: found),
    );
    return {
      'packageName': packageName,
      'source': source,
      'localPath': found,
      'content': content,
    };
  }

  Future<Map<String, dynamic>> _writeScript(
    Map<String, dynamic>? params,
  ) async {
    final packageName = _requireString(params, 'packageName');
    final source = _requireScriptSource(params);
    final localPath = _requireString(params, 'localPath');
    final content = params?['content'];
    if (content is! String) {
      throw const _ProtocolException(
        JsxposedErrorCode.invalidParams,
        'Missing required string parameter: content',
      );
    }
    final paths = await _scriptNames(packageName, source);
    // 已存在的脚本沿用设备上的真实路径，否则视为新建，取传入值的文件名
    final found = _findScriptPath(paths, localPath);
    await _writeScriptContent(packageName, source, found ?? localPath, content);
    return {
      'packageName': packageName,
      'source': source,
      'localPath': found ?? localPath,
    };
  }

  /// 写入脚本内容并按来源刷新手机端快照 / hook 打包
  Future<void> _writeScriptContent(
    String packageName,
    String source,
    String localPath,
    String content,
  ) async {
    final fileName = PathUtils.getName(path: localPath);
    if (source == JsxposedScriptSource.frida) {
      await _projectNative.createFridaScript(
        packageName,
        content,
        fileName,
        false,
      );
    } else {
      await _projectNative.createJsScript(
        packageName,
        content,
        fileName,
        false,
      );
    }
    // 手机端 Xposed 快照由原生 createJsScript 内部刷新，Frida hook.js 需重新打包
    if (source == JsxposedScriptSource.frida) {
      await _projectNative.bundleFridaHookJs(packageName);
    }
  }

  Future<Map<String, dynamic>> _deleteScript(
    Map<String, dynamic>? params,
  ) async {
    final packageName = _requireString(params, 'packageName');
    final source = _requireScriptSource(params);
    final localPath = _requireString(params, 'localPath');
    final paths = await _scriptNames(packageName, source);
    final found = _findScriptPath(paths, localPath);
    if (found == null) {
      throw _ProtocolException(
        JsxposedErrorCode.scriptNotFound,
        'Script not found: $localPath',
      );
    }
    if (source == JsxposedScriptSource.frida) {
      await _projectNative.deleteFridaScript(
        packageName,
        PathUtils.getName(path: found),
      );
    } else {
      await _projectNative.deleteJsScript(
        packageName,
        PathUtils.getName(path: found),
      );
    }
    await _piniaNative.remove(
      key: _scriptStatusKey(packageName, source, found),
    );
    return {'deleted': true};
  }

  Future<Map<String, dynamic>> _toggleScript(
    Map<String, dynamic>? params,
  ) async {
    final packageName = _requireString(params, 'packageName');
    final source = _requireScriptSource(params);
    final localPath = _requireString(params, 'localPath');
    final enabled = params?['enabled'];
    if (enabled is! bool) {
      throw const _ProtocolException(
        JsxposedErrorCode.invalidParams,
        'Missing required bool parameter: enabled',
      );
    }
    final paths = await _scriptNames(packageName, source);
    final found = _findScriptPath(paths, localPath);
    if (found == null) {
      throw _ProtocolException(
        JsxposedErrorCode.scriptNotFound,
        'Script not found: $localPath',
      );
    }
    await _piniaNative.setBool(
      key: _scriptStatusKey(packageName, source, found),
      value: enabled,
    );
    if (source == JsxposedScriptSource.frida) {
      await _projectNative.bundleFridaHookJs(packageName);
    }
    return {'enabled': enabled};
  }

  /// 保存并运行：先落盘再用应用层回调完成注入，
  /// restartApp 仅在 Frida 场景有意义（Xposed 必须重启应用才能生效）
  Future<Map<String, dynamic>> _runScript(Map<String, dynamic>? params) async {
    final packageName = _requireString(params, 'packageName');
    final source = _requireScriptSource(params);
    final localPath = _requireString(params, 'localPath');
    final content = _requireString(params, 'content');
    final restartApp = params?['restartApp'] as bool? ?? false;

    final paths = await _scriptNames(packageName, source);
    final found = _findScriptPath(paths, localPath);
    if (found == null) {
      throw _ProtocolException(
        JsxposedErrorCode.scriptNotFound,
        'Script not found: $localPath',
      );
    }
    await _writeScriptContent(packageName, source, found, content);

    final runner = scriptRunner;
    if (runner == null) {
      throw const _ProtocolException(
        JsxposedErrorCode.capabilityUnavailable,
        'Script runner is not available on this device',
      );
    }
    await runner(
      packageName: packageName,
      source: source,
      localPath: found,
      restartApp: restartApp,
    );
    return {'ran': true, 'restartApp': restartApp};
  }

  /// 执行 shell 命令：useSu 为真时通过 su -c 以 root 运行，默认开启。
  Future<Map<String, dynamic>> _shellExec(Map<String, dynamic>? params) async {
    final command = _requireString(params, 'command');
    final useSu = params?['useSu'] as bool? ?? true;
    try {
      // 比桌面端 120s 的请求超时稍短，超时先在设备侧返回错误
      final result = await Process.run(
        useSu ? 'su' : 'sh',
        ['-c', command],
        stdoutEncoding: utf8,
        stderrEncoding: utf8,
      ).timeout(const Duration(seconds: 100));
      return {
        'exitCode': result.exitCode,
        'stdout': result.stdout,
        'stderr': result.stderr,
      };
    } on TimeoutException {
      throw const _ProtocolException(
        JsxposedErrorCode.internalError,
        'Shell command timed out',
      );
    } on ProcessException catch (error) {
      // su/sh 不存在或执行环境异常，把原因带回给桌面端
      return {'exitCode': -1, 'stdout': '', 'stderr': error.message};
    }
  }

  Process? _shellProcess;
  StreamSubscription<String>? _shellStdoutSub;
  StreamSubscription<String>? _shellStderrSub;

  /// 常驻 shell 会话：同一进程内持续读写，使 cd/export 等状态跨命令保留。
  /// 非交互模式（不传 -i）行为确定，提示符与回显由 PC 端终端自行维护。
  Future<Map<String, dynamic>> _shellOpen(Map<String, dynamic>? params) async {
    final useSu = params?['useSu'] as bool? ?? true;
    await _shellCloseSession();
    try {
      final process = await Process.start(
        useSu ? 'su' : 'sh',
        useSu ? const ['-c', 'sh'] : const <String>[],
      );
      _shellProcess = process;
      _shellStdoutSub = process.stdout
          .transform(utf8.decoder)
          .listen((data) => _emitShellOutput('stdout', data));
      _shellStderrSub = process.stderr
          .transform(utf8.decoder)
          .listen((data) => _emitShellOutput('stderr', data));
      unawaited(
        process.exitCode.then((code) {
          // 会话自然结束（如执行 exit）时清理并通知 PC 端
          if (_shellProcess != process) return;
          unawaited(_shellStdoutSub?.cancel());
          unawaited(_shellStderrSub?.cancel());
          _shellProcess = null;
          broadcast(JsxposedEvent.shellExit, {'exitCode': code});
        }),
      );
      return {'opened': true, 'useSu': useSu};
    } on ProcessException catch (error) {
      return {'opened': false, 'stderr': error.message};
    }
  }

  Future<Map<String, dynamic>> _shellWrite(Map<String, dynamic>? params) async {
    final data = _requireString(params, 'data');
    final process = _shellProcess;
    if (process == null) {
      throw const _ProtocolException(
        JsxposedErrorCode.internalError,
        'Shell session is not open',
      );
    }
    process.stdin.write(data);
    await process.stdin.flush();
    return {'written': data.length};
  }

  Future<Map<String, dynamic>> _shellCloseSession() async {
    final process = _shellProcess;
    _shellProcess = null;
    await _shellStdoutSub?.cancel();
    await _shellStderrSub?.cancel();
    _shellStdoutSub = null;
    _shellStderrSub = null;
    if (process != null) {
      process.kill();
      await process.stdin.close();
    }
    return {'closed': true};
  }

  void _emitShellOutput(String stream, String data) {
    if (data.isEmpty) return;
    broadcast(JsxposedEvent.shellOutput, {'stream': stream, 'data': data});
  }

  Future<List<String>> _scriptNames(String packageName, String source) {
    return source == JsxposedScriptSource.frida
        ? _projectNative.getFridaScripts(packageName)
        : _projectNative.getJsScripts(packageName);
  }

  Future<String> _readScriptContent(
    String packageName,
    String source,
    String localPath,
  ) {
    // 原生读写接口只接受文件名并自行拼接项目目录，
    // 这里再兜底一次，避免上游漏传文件名时拼出重复目录
    final fileName = PathUtils.getName(path: localPath);
    return source == JsxposedScriptSource.frida
        ? _projectNative.readFridaScript(packageName, fileName)
        : _projectNative.readJsScript(packageName, fileName);
  }

  Future<bool> _readScriptEnabled(
    String packageName,
    String source,
    String localPath,
  ) {
    return _piniaNative.getBool(
      key: _scriptStatusKey(packageName, source, localPath),
      defaultValue: false,
    );
  }

  static String _scriptStatusKey(
    String packageName,
    String source,
    String localPath,
  ) {
    final prefix = source == JsxposedScriptSource.frida
        ? 'frida_check_status'
        : 'xposed_check_status';
    return '${prefix}_${packageName}_$localPath';
  }

  /// Xposed 脚本名带 `[visual]`/`[tradition]` 前缀，展示时去掉
  static String _displayName(String localPath, String source) {
    final fileName = PathUtils.getName(path: localPath);
    return source == JsxposedScriptSource.xposed
        ? PathUtils.getName(path: fileName, isXposedScript: true)
        : fileName;
  }

  static bool _samePath(String a, String b) =>
      PathUtils.getName(path: a) == PathUtils.getName(path: b);

  /// 列表接口返回完整路径（也是启停键的一部分），
  /// 而原生读写/删除接口只接受文件名并自行拼接目录，
  /// 因此按文件名匹配出设备上的真实完整路径，避免拼出重复目录。
  static String? _findScriptPath(List<String> paths, String localPath) {
    for (final path in paths) {
      if (_samePath(path, localPath)) return path;
    }
    return null;
  }

  /// 控制台宿主未注入时统一抛能力不可用，与脚本运行回调保持一致
  DesktopConsoleHost _consoleHost() {
    final host = consoleHost;
    if (host == null) {
      throw const _ProtocolException(
        JsxposedErrorCode.capabilityUnavailable,
        'Console host is not available on this device',
      );
    }
    return host;
  }

  static String _requireString(Map<String, dynamic>? params, String key) {
    final value = params?[key];
    if (value is String && value.isNotEmpty) return value;
    throw _ProtocolException(
      JsxposedErrorCode.invalidParams,
      'Missing required string parameter: $key',
    );
  }

  static bool _requireBool(Map<String, dynamic>? params, String key) {
    final value = params?[key];
    if (value is bool) return value;
    throw _ProtocolException(
      JsxposedErrorCode.invalidParams,
      'Missing required bool parameter: $key',
    );
  }

  static String _requireScriptSource(Map<String, dynamic>? params) {
    final source = _requireString(params, 'source');
    if (!JsxposedScriptSource.isValid(source)) {
      throw _ProtocolException(
        JsxposedErrorCode.invalidParams,
        'Unsupported script source: $source',
      );
    }
    return source;
  }

  Future<Map<String, dynamic>> _loadCapabilities() async {
    final results = await Future.wait<dynamic>([
      _readCapability<bool>(_statusManagement.isHook, false),
      _readCapability<bool>(_statusManagement.isRoot, false),
      _readCapability<FridaStatusData>(
        _statusManagement.isFrida,
        FridaStatusData(status: false, type: -1),
      ),
    ]);
    final isHook = results[0] as bool;
    final isRoot = results[1] as bool;
    final frida = results[2] as FridaStatusData;
    return buildDesktopBridgeCapabilities(
      deviceId: _deviceInfo?['deviceId'] as String?,
      isHook: isHook,
      isRoot: isRoot,
      isFridaReady: frida.status,
      fridaType: frida.type,
    );
  }

  Future<T> _readCapability<T>(Future<T> Function() read, T fallback) async {
    try {
      return await read();
    } catch (error) {
      debugPrint('Desktop bridge capability check failed: $error');
      return fallback;
    }
  }

  Future<Map<String, dynamic>> _loadDeviceInfo() async {
    final info = await DeviceInfoPlugin().androidInfo;
    return {
      'deviceId': info.id,
      'platform': 'android',
      'androidApi': info.version.sdkInt,
      'androidVersion': info.version.release,
      'abi': info.supportedAbis.isEmpty ? 'unknown' : info.supportedAbis.first,
      'model': info.model,
      'manufacturer': info.manufacturer,
    };
  }
}

@visibleForTesting
Map<String, dynamic> buildDesktopBridgeCapabilities({
  required String? deviceId,
  required bool isHook,
  required bool isRoot,
  required bool isFridaReady,
  required int fridaType,
}) {
  return {
    'deviceId': deviceId,
    'protocolVersion': jsxposedProtocolVersion,
    'platform': 'android',
    'capabilities': {
      'xposed': {'available': isHook, 'framework': isHook ? 'LSPosed' : null},
      'frida': {
        'available': isFridaReady,
        'installed': fridaType >= 0,
        'mode': fridaType == 1 ? 'zygisk' : null,
        'state': switch (fridaType) {
          1 => 'ready',
          0 => 'installed',
          _ => 'unavailable',
        },
      },
      'root': isRoot,
      'memory': isRoot,
      'shell': isRoot,
      'screenshot': true,
    },
  };
}

class _ProtocolException implements Exception {
  const _ProtocolException(this.code, this.message);

  final String code;
  final String message;
}
