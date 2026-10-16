import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:JsxposedX/core/transport/jsxposed_protocol.dart';

/// PC 端与手机端的连接状态
enum DesktopConnectionStatus { disconnected, connecting, connected }

@immutable
class DesktopDeviceInfo {
  const DesktopDeviceInfo({
    required this.deviceId,
    required this.platform,
    required this.androidApi,
    required this.abi,
    this.model,
    this.manufacturer,
  });

  final String deviceId;
  final String platform;
  final int androidApi;
  final String abi;
  final String? model;
  final String? manufacturer;

  factory DesktopDeviceInfo.fromJson(Map<String, dynamic> json) =>
      DesktopDeviceInfo(
        deviceId: json['deviceId'] as String? ?? '',
        platform: json['platform'] as String? ?? 'android',
        androidApi: (json['androidApi'] as num?)?.toInt() ?? 0,
        abi: json['abi'] as String? ?? 'unknown',
        model: json['model'] as String?,
        manufacturer: json['manufacturer'] as String?,
      );
}

@immutable
class DesktopDeviceCapabilities {
  const DesktopDeviceCapabilities({required this.values});

  final Map<String, dynamic> values;

  factory DesktopDeviceCapabilities.fromJson(Map<String, dynamic> json) =>
      DesktopDeviceCapabilities(values: Map<String, dynamic>.from(json));
}

@immutable
class DesktopAdbDevice {
  const DesktopAdbDevice({
    required this.serial,
    required this.state,
    this.model,
  });

  final String serial;
  final String state;
  final String? model;

  bool get isAuthorized => state == 'device';

  String get displayName => model == null ? serial : '$model ($serial)';
}

@immutable
class AdbCommandResult {
  const AdbCommandResult({
    required this.command,
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  final String command;
  final int exitCode;
  final String stdout;
  final String stderr;

  bool get isSuccess => exitCode == 0;

  String get details {
    final lines = <String>['> $command', 'exit code: $exitCode'];
    if (stdout.isNotEmpty) lines.add('stdout:\n$stdout');
    if (stderr.isNotEmpty) lines.add('stderr:\n$stderr');
    return lines.join('\n');
  }
}

/// 设备端 shell 命令执行结果
@immutable
class DesktopShellResult {
  const DesktopShellResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  final int exitCode;
  final String stdout;
  final String stderr;
}

@immutable
class DesktopProject {
  const DesktopProject({
    required this.packageName,
    required this.name,
    this.versionName,
    this.versionCode,
    this.iconUrl,
  });

  final String packageName;
  final String name;
  final String? versionName;
  final int? versionCode;
  final String? iconUrl;

  factory DesktopProject.fromJson(Map<String, dynamic> json) => DesktopProject(
    packageName: json['packageName'] as String? ?? '',
    name: json['name'] as String? ?? '',
    versionName: json['versionName'] as String?,
    versionCode: (json['versionCode'] as num?)?.toInt(),
    iconUrl: json['iconUrl'] as String?,
  );
}

@immutable
class DesktopScript {
  const DesktopScript({
    required this.localPath,
    required this.name,
    required this.enabled,
  });

  final String localPath;
  final String name;
  final bool enabled;

  factory DesktopScript.fromJson(Map<String, dynamic> json) => DesktopScript(
    localPath: json['localPath'] as String? ?? '',
    name: json['name'] as String? ?? json['localPath'] as String? ?? '',
    enabled: json['enabled'] as bool? ?? false,
  );
}

@immutable
class DesktopConnectionState {
  const DesktopConnectionState({
    this.status = DesktopConnectionStatus.disconnected,
    this.address = '',
    this.error,
    this.adbDevices = const [],
    this.selectedAdbSerial,
    this.deviceInfo,
    this.capabilities,
    this.lastResponse,
  });

  final DesktopConnectionStatus status;
  final String address;
  final String? error;
  final List<DesktopAdbDevice> adbDevices;
  final String? selectedAdbSerial;
  final DesktopDeviceInfo? deviceInfo;
  final DesktopDeviceCapabilities? capabilities;
  final JsxposedMessage? lastResponse;

  bool get isConnected => status == DesktopConnectionStatus.connected;

  bool get isConnecting => status == DesktopConnectionStatus.connecting;

  DesktopConnectionState copyWith({
    DesktopConnectionStatus? status,
    String? address,
    String? error,
    bool clearError = false,
    List<DesktopAdbDevice>? adbDevices,
    String? selectedAdbSerial,
    bool clearSelectedAdbSerial = false,
    DesktopDeviceInfo? deviceInfo,
    bool clearDeviceInfo = false,
    DesktopDeviceCapabilities? capabilities,
    bool clearCapabilities = false,
    JsxposedMessage? lastResponse,
  }) {
    return DesktopConnectionState(
      status: status ?? this.status,
      address: address ?? this.address,
      error: clearError ? null : (error ?? this.error),
      adbDevices: adbDevices ?? this.adbDevices,
      selectedAdbSerial: clearSelectedAdbSerial
          ? null
          : (selectedAdbSerial ?? this.selectedAdbSerial),
      deviceInfo: clearDeviceInfo ? null : (deviceInfo ?? this.deviceInfo),
      capabilities: clearCapabilities
          ? null
          : (capabilities ?? this.capabilities),
      lastResponse: lastResponse ?? this.lastResponse,
    );
  }
}

final desktopConnectionProvider =
    NotifierProvider<DesktopConnectionNotifier, DesktopConnectionState>(
      DesktopConnectionNotifier.new,
    );

/// 通过 WebSocket（HTTP 升级）与手机端保持即时双向连接
class DesktopConnectionNotifier extends Notifier<DesktopConnectionState> {
  WebSocket? _socket;
  StreamSubscription<dynamic>? _socketSubscription;
  Timer? _heartbeatTimer;
  String? _adbForwardSerial;
  String? _adbPathCache;
  final Map<String, Completer<JsxposedMessage>> _pendingRequests = {};

  Stream<JsxposedMessage> get events => _eventController.stream;
  final _eventController = StreamController<JsxposedMessage>.broadcast();

  /// 连接上下文发生变化时自增，供 PC 端脚本树重新拉取
  final ValueNotifier<int> contextRevision = ValueNotifier<int>(0);

  @override
  DesktopConnectionState build() {
    ref.onDispose(() {
      unawaited(_close());
      unawaited(_eventController.close());
      contextRevision.dispose();
    });
    return const DesktopConnectionState();
  }

  Future<void> scanAdbDevices() async {
    try {
      final result = await Process.run(_adbExecutable, ['devices', '-l']);
      if (result.exitCode != 0) {
        throw Exception(result.stderr.toString().trim());
      }

      final devices = <DesktopAdbDevice>[];
      for (final line in result.stdout.toString().split('\n').skip(1)) {
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length < 2 || parts.first.isEmpty) continue;
        final modelPart = parts
            .where((part) => part.startsWith('model:'))
            .firstOrNull;
        devices.add(
          DesktopAdbDevice(
            serial: parts.first,
            state: parts[1],
            model: modelPart?.substring('model:'.length).replaceAll('_', ' '),
          ),
        );
      }

      final selected =
          state.selectedAdbSerial != null &&
              devices.any((device) => device.serial == state.selectedAdbSerial)
          ? state.selectedAdbSerial
          : null;
      state = state.copyWith(
        adbDevices: devices,
        selectedAdbSerial: selected,
        clearSelectedAdbSerial: selected == null,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(adbDevices: const [], error: error.toString());
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void selectAdbDevice(String serial) {
    if (state.isConnecting) return;
    state = state.copyWith(selectedAdbSerial: serial, clearError: true);
  }

  /// 切换到另一台设备：断开当前连接后重新连接目标设备
  Future<void> switchAdbDevice(String serial) async {
    if (state.isConnecting) return;
    if (state.selectedAdbSerial == serial && state.isConnected) return;
    await _close();
    state = state.copyWith(
      status: DesktopConnectionStatus.disconnected,
      selectedAdbSerial: serial,
      clearError: true,
      clearDeviceInfo: true,
      clearCapabilities: true,
    );
    await connectAdb();
  }

  Future<AdbCommandResult> pairAdb(String address, String pairingCode) async {
    final normalizedAddress = address.trim();
    final normalizedCode = pairingCode.trim();
    return _runAdbCommand(
      ['pair', normalizedAddress, normalizedCode],
      displayArguments: ['pair', normalizedAddress, '******'],
    );
  }

  Future<AdbCommandResult> connectAdbWireless(String address) async {
    final normalizedAddress = address.trim();
    final result = await _runAdbCommand(['connect', normalizedAddress]);
    final output = '${result.stdout}\n${result.stderr}'.toLowerCase();
    final commandReportedFailure =
        output.contains('failed') ||
        output.contains('unable') ||
        output.contains('cannot') ||
        output.contains('refused');
    final deviceConnected = state.adbDevices.any(
      (device) => device.serial == normalizedAddress && device.isAuthorized,
    );
    if (result.isSuccess && !commandReportedFailure && deviceConnected) {
      state = state.copyWith(
        selectedAdbSerial: normalizedAddress,
        clearError: true,
      );
      return result;
    }
    return AdbCommandResult(
      command: result.command,
      exitCode: result.exitCode == 0 ? 1 : result.exitCode,
      stdout: result.stdout,
      stderr: result.stderr.isEmpty && !deviceConnected
          ? 'ADB command completed, but the device did not appear in adb devices -l.'
          : result.stderr,
    );
  }

  Future<AdbCommandResult> _runAdbCommand(
    List<String> arguments, {
    List<String>? displayArguments,
  }) async {
    final visibleArguments = displayArguments ?? arguments;
    final executable = _adbExecutable;
    final command = [executable, ...visibleArguments].join(' ');
    try {
      final result = await Process.run(executable, arguments);
      final commandResult = AdbCommandResult(
        command: command,
        exitCode: result.exitCode,
        stdout: result.stdout.toString().trim(),
        stderr: result.stderr.toString().trim(),
      );
      if (commandResult.isSuccess) await scanAdbDevices();
      return commandResult;
    } on ProcessException catch (error) {
      return AdbCommandResult(
        command: command,
        exitCode: error.errorCode,
        stdout: '',
        stderr: error.toString(),
      );
    }
  }

  Future<void> connectAdb() async {
    final serial = state.selectedAdbSerial;
    if (serial == null) {
      _handleError('No ADB device selected');
      return;
    }

    if (!state.adbDevices.any(
      (device) => device.serial == serial && device.isAuthorized,
    )) {
      _handleError('Selected ADB device is not authorized');
      return;
    }

    try {
      final result = await Process.run(_adbExecutable, [
        '-s',
        serial,
        'forward',
        'tcp:8765',
        'tcp:8765',
      ]);
      if (result.exitCode != 0) {
        throw Exception(result.stderr.toString().trim());
      }
      _adbForwardSerial = serial;
      await connect('ws://127.0.0.1:8765');
    } catch (error) {
      _handleError(error.toString());
    }
  }

  /// 快捷刷新并自动连接：重新扫描设备后优先连回上次选中的设备，
  /// 否则连接第一台已授权设备。
  Future<void> quickConnectAdb() async {
    if (state.isConnecting || state.isConnected) return;
    await scanAdbDevices();
    final authorized = state.adbDevices
        .where((device) => device.isAuthorized)
        .toList();
    if (authorized.isEmpty) return;
    final preferred = authorized
        .where((device) => device.serial == state.selectedAdbSerial)
        .firstOrNull;
    final target = preferred ?? authorized.first;
    state = state.copyWith(selectedAdbSerial: target.serial, clearError: true);
    await connectAdb();
  }

  /// 连接手机端，[address] 形如 ws://192.168.1.2:8765
  Future<void> connect(String address) async {
    if (state.isConnecting || state.isConnected) return;

    state = state.copyWith(
      status: DesktopConnectionStatus.connecting,
      address: address,
      clearError: true,
    );

    try {
      final socket = await WebSocket.connect(
        address,
      ).timeout(const Duration(seconds: 10));
      _socket = socket;
      _socketSubscription = socket.listen(
        _handleMessage,
        onDone: _handleClosed,
        onError: (Object error) => _handleError(error.toString()),
        cancelOnError: true,
      );

      final handshake = await request(
        'handshake',
        params: {
          'client': 'JsxposedX Desktop',
          'protocolVersion': jsxposedProtocolVersion,
        },
      );
      if (!handshake.isSuccess) {
        throw Exception(handshake.error?.message ?? 'Handshake failed');
      }
      final infoResponse = await request('device.get_info');
      final capabilitiesResponse = await request('device.get_capabilities');
      state = state.copyWith(
        status: DesktopConnectionStatus.connected,
        deviceInfo: _deviceInfoFromResponse(infoResponse),
        capabilities: _capabilitiesFromResponse(capabilitiesResponse),
        lastResponse: capabilitiesResponse,
        clearError: true,
      );
      _heartbeatTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        unawaited(_sendHeartbeat());
      });
      contextRevision.value++;
    } catch (error) {
      await _close();
      _handleError(error.toString());
    }
  }

  Future<void> _sendHeartbeat() async {
    try {
      await request('heartbeat', timeout: const Duration(seconds: 5));
    } catch (error) {
      _handleError('Heartbeat failed: $error');
      await _close();
    }
  }

  Future<void> refreshDeviceContext() async {
    final infoResponse = await request('device.get_info');
    final capabilitiesResponse = await request('device.get_capabilities');
    state = state.copyWith(
      deviceInfo: _deviceInfoFromResponse(infoResponse),
      capabilities: _capabilitiesFromResponse(capabilitiesResponse),
      lastResponse: capabilitiesResponse,
    );
  }

  /// 拉取手机端项目列表（项目即包名目录）
  Future<List<DesktopProject>> listProjects() async {
    final response = await request(JsxposedMethod.projectList);
    return _listFromResponse(response, DesktopProject.fromJson);
  }

  /// 拉取指定项目下的脚本，source 取 frida / xposed
  Future<List<DesktopScript>> listScripts({
    required String packageName,
    required String source,
  }) async {
    final response = await request(
      JsxposedMethod.scriptList,
      params: {'packageName': packageName, 'source': source},
    );
    return _listFromResponse(response, DesktopScript.fromJson);
  }

  Future<String> readScript({
    required String packageName,
    required String source,
    required String localPath,
  }) async {
    final response = await request(
      JsxposedMethod.scriptRead,
      params: {
        'packageName': packageName,
        'source': source,
        'localPath': localPath,
      },
    );
    final result = _resultMap(response);
    return result['content'] as String? ?? '';
  }

  Future<void> writeScript({
    required String packageName,
    required String source,
    required String localPath,
    required String content,
  }) async {
    await request(
      JsxposedMethod.scriptWrite,
      params: {
        'packageName': packageName,
        'source': source,
        'localPath': localPath,
        'content': content,
      },
    );
    contextRevision.value++;
  }

  Future<void> deleteScript({
    required String packageName,
    required String source,
    required String localPath,
  }) async {
    await request(
      JsxposedMethod.scriptDelete,
      params: {
        'packageName': packageName,
        'source': source,
        'localPath': localPath,
      },
    );
    contextRevision.value++;
  }

  Future<void> toggleScript({
    required String packageName,
    required String source,
    required String localPath,
    required bool enabled,
  }) async {
    await request(
      JsxposedMethod.scriptToggle,
      params: {
        'packageName': packageName,
        'source': source,
        'localPath': localPath,
        'enabled': enabled,
      },
    );
  }

  /// 查询单个脚本在设备端的启停状态（开关状态真源在设备端）
  Future<bool> getScriptEnabled({
    required String packageName,
    required String source,
    required String localPath,
  }) async {
    final response = await request(
      JsxposedMethod.scriptGetEnabled,
      params: {
        'packageName': packageName,
        'source': source,
        'localPath': localPath,
      },
    );
    final result = _resultMap(response);
    return result['enabled'] as bool? ?? false;
  }

  /// 在设备端执行 shell 命令，默认以 su（root）运行
  Future<DesktopShellResult> execShell({
    required String command,
    bool useSu = true,
  }) async {
    // 设备端 Process.run 自身 100s 超时，这里留出协议往返余量
    final response = await request(
      JsxposedMethod.shellExec,
      params: {'command': command, 'useSu': useSu},
      timeout: const Duration(seconds: 120),
    );
    final result = _resultMap(response);
    return DesktopShellResult(
      exitCode: (result['exitCode'] as num?)?.toInt() ?? -1,
      stdout: result['stdout'] as String? ?? '',
      stderr: result['stderr'] as String? ?? '',
    );
  }

  /// 开启设备端常驻 shell 会话，同一会话内 cd/export 等状态持续保留
  Future<bool> openShellSession({bool useSu = true}) async {
    final response = await request(
      JsxposedMethod.shellOpen,
      params: {'useSu': useSu},
    );
    final result = _resultMap(response);
    return result['opened'] as bool? ?? false;
  }

  /// 向常驻会话写入数据，输出由 shell.output 事件异步推送
  Future<void> writeShellSession(String data) async {
    await request(JsxposedMethod.shellWrite, params: {'data': data});
  }

  /// 关闭常驻 shell 会话
  Future<void> closeShellSession() async {
    await request(JsxposedMethod.shellClose);
  }

  /// 保存并运行：内容先落到手机端，再由手机端完成注入。
  /// restartApp 仅对 Frida 有意义，Xposed 侧恒为 true。
  Future<void> runScript({
    required String packageName,
    required String source,
    required String localPath,
    required String content,
    required bool restartApp,
  }) async {
    await request(
      JsxposedMethod.scriptRun,
      params: {
        'packageName': packageName,
        'source': source,
        'localPath': localPath,
        'content': content,
        'restartApp': restartApp,
      },
    );
  }

  /// 读取控制台状态。手机端 logcatProvider 是唯一真源，PC 端不自行维护。
  Future<Map<String, dynamic>> getConsoleState() async {
    final response = await request(JsxposedMethod.consoleGetState);
    return _resultMap(response);
  }

  Future<void> setConsolePaused(bool paused) async {
    await request(JsxposedMethod.consoleSetPaused, params: {'paused': paused});
  }

  Future<void> setConsoleAutoScroll(bool autoScroll) async {
    await request(
      JsxposedMethod.consoleSetAutoScroll,
      params: {'autoScroll': autoScroll},
    );
  }

  Future<void> setConsoleSearch(String query) async {
    await request(JsxposedMethod.consoleSetSearch, params: {'query': query});
  }

  Future<void> setConsoleLevel(String level) async {
    await request(JsxposedMethod.consoleSetLevel, params: {'level': level});
  }

  Future<void> setConsoleSource(String source) async {
    await request(JsxposedMethod.consoleSetSource, params: {'source': source});
  }

  Future<void> clearConsole() async {
    await request(JsxposedMethod.consoleClear);
  }

  Future<void> startConsole(String packageName) async {
    await request(
      JsxposedMethod.consoleStart,
      params: {'packageName': packageName},
    );
  }

  Future<void> stopConsole() async {
    await request(JsxposedMethod.consoleStop);
  }

  /// 历史日志分页。before/beforeId 取自上一页最后一条记录，作为游标。
  Future<List<Map<String, dynamic>>> queryLogs({
    required String conversationId,
    String? before,
    int? beforeId,
    int limit = 100,
  }) async {
    final response = await request(
      JsxposedMethod.logQuery,
      params: {
        'conversationId': conversationId,
        if (before != null) 'before': before,
        if (beforeId != null) 'beforeId': beforeId,
        'limit': limit,
      },
    );
    final result = _resultMap(response);
    final logs = result['logs'];
    if (logs is! List) return const [];
    return [
      for (final log in logs)
        if (log is Map) log.cast<String, dynamic>(),
    ];
  }

  Future<void> deleteConsoleHistory(String conversationId) async {
    await request(
      JsxposedMethod.logDeleteHistory,
      params: {'conversationId': conversationId},
    );
  }

  List<T> _listFromResponse<T>(
    JsxposedMessage response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final result = _resultMap(response);
    final key = result.containsKey('projects') ? 'projects' : 'scripts';
    final raw = result[key];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map) fromJson(item.cast<String, dynamic>()),
    ];
  }

  Map<String, dynamic> _resultMap(JsxposedMessage response) {
    if (!response.isSuccess) {
      throw StateError(response.error?.message ?? 'Request failed');
    }
    final result = response.result;
    return result is Map ? result.cast<String, dynamic>() : const {};
  }

  Future<JsxposedMessage> request(
    String method, {
    Map<String, dynamic>? params,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final socket = _socket;
    if (socket == null) {
      throw StateError('WebSocket is not connected');
    }
    final id = newJsxposedRequestId();
    final completer = Completer<JsxposedMessage>();
    _pendingRequests[id] = completer;
    socket.add(
      JsxposedMessage.request(
        id: id,
        method: method,
        deviceId: state.deviceInfo?.deviceId ?? state.selectedAdbSerial,
        params: params,
        timeoutMs: timeout.inMilliseconds,
      ).encode(),
    );
    try {
      final response = await completer.future.timeout(timeout);
      state = state.copyWith(lastResponse: response);
      return response;
    } on TimeoutException {
      _pendingRequests.remove(id);
      if (_socket != null) {
        _socket!.add(
          JsxposedMessage.request(
            id: newJsxposedRequestId(),
            method: 'request.cancel',
            params: {'requestId': id},
          ).encode(),
        );
      }
      throw TimeoutException('$method timed out', timeout);
    }
  }

  void _handleMessage(dynamic data) {
    try {
      final message = JsxposedMessage.decode(data.toString());
      if (message.isResponse && message.id != null) {
        _pendingRequests.remove(message.id)?.complete(message);
        return;
      }
      // 事件一律通过 events 流分发，避免高频日志触发整棵工作台重建
      if (message.isEvent) {
        _eventController.add(message);
      }
    } catch (error) {
      state = state.copyWith(error: 'Invalid protocol message: $error');
    }
  }

  DesktopDeviceInfo? _deviceInfoFromResponse(JsxposedMessage response) {
    final result = response.result;
    return response.isSuccess && result is Map
        ? DesktopDeviceInfo.fromJson(result.cast<String, dynamic>())
        : null;
  }

  DesktopDeviceCapabilities? _capabilitiesFromResponse(
    JsxposedMessage response,
  ) {
    final result = response.result;
    if (!response.isSuccess || result is! Map) return null;
    final json = result.cast<String, dynamic>();
    final capabilities = json['capabilities'];
    return capabilities is Map
        ? DesktopDeviceCapabilities.fromJson(
            capabilities.cast<String, dynamic>(),
          )
        : DesktopDeviceCapabilities.fromJson(json);
  }

  /// 断开连接
  Future<void> disconnect() async {
    await _close();
    state = state.copyWith(status: DesktopConnectionStatus.disconnected);
    contextRevision.value++;
  }

  void _handleClosed() {
    _socket = null;
    _heartbeatTimer?.cancel();
    _failPendingRequests('Connection closed');
    state = state.copyWith(
      status: DesktopConnectionStatus.disconnected,
      clearDeviceInfo: true,
      clearCapabilities: true,
    );
    contextRevision.value++;
  }

  void _handleError(String message) {
    _socket = null;
    _heartbeatTimer?.cancel();
    _failPendingRequests(message);
    state = state.copyWith(
      status: DesktopConnectionStatus.disconnected,
      error: message,
      clearDeviceInfo: true,
      clearCapabilities: true,
    );
    contextRevision.value++;
  }

  void _failPendingRequests(String message) {
    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) completer.completeError(StateError(message));
    }
    _pendingRequests.clear();
  }

  Future<void> _close() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    final subscription = _socketSubscription;
    _socketSubscription = null;
    await subscription?.cancel();
    final socket = _socket;
    _socket = null;
    _failPendingRequests('Connection closed');
    await socket?.close();
    final serial = _adbForwardSerial;
    _adbForwardSerial = null;
    if (serial != null) {
      try {
        await Process.run(_adbExecutable, [
          '-s',
          serial,
          'forward',
          '--remove',
          'tcp:8765',
        ]);
      } on ProcessException {
        // adb 不可用时忽略清理失败，避免中断断开流程
      }
    }
  }

  /// 解析 adb 可执行文件路径。
  ///
  /// 从 Finder / 资源管理器双击启动的 GUI 进程不会继承终端的环境变量，
  /// 直接调用 `adb` 会因 PATH 缺失而失败，因此这里显式探测常见安装位置。
  String get _adbExecutable {
    final cached = _adbPathCache;
    if (cached != null) return cached;

    final exeDir = File(Platform.resolvedExecutable).parent.path;
    final exeName = Platform.isWindows ? 'adb.exe' : 'adb';
    final candidates = <String>[
      // 随安装包内置的 platform-tools 优先，避免依赖用户本机是否装了 SDK
      p.join(exeDir, 'platform-tools', exeName),
      // macOS .app 布局：可执行文件在 Contents/MacOS，资源在 Contents/Resources
      p.join(p.dirname(exeDir), 'Resources', 'platform-tools', exeName),
    ];

    for (final key in const ['ANDROID_HOME', 'ANDROID_SDK_ROOT']) {
      final root = Platform.environment[key];
      if (root != null && root.isNotEmpty) {
        candidates.add(p.join(root, 'platform-tools', exeName));
      }
    }

    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home != null && home.isNotEmpty) {
      candidates
        ..add(
          p.join(home, 'Library', 'Android', 'sdk', 'platform-tools', exeName),
        )
        ..add(p.join(home, 'Android', 'Sdk', 'platform-tools', exeName))
        ..add(
          p.join(
            home,
            'AppData',
            'Local',
            'Android',
            'Sdk',
            'platform-tools',
            exeName,
          ),
        );
    }

    if (Platform.isMacOS) {
      candidates
        ..add('/usr/local/share/android-sdk/platform-tools/$exeName')
        ..add(
          '/opt/homebrew/share/android-commandlinetools/platform-tools/$exeName',
        )
        ..add('/opt/homebrew/bin/$exeName');
    }

    for (final candidate in candidates) {
      if (File(candidate).existsSync()) {
        _adbPathCache = candidate;
        return candidate;
      }
    }

    // 均未命中时交回 PATH 解析，且不缓存，便于安装 adb 后无需重启即可生效
    return exeName;
  }
}
