import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:JsxposedX/features/server/domain/models/server_config.dart';
import 'package:JsxposedX/features/server/domain/models/server_status.dart';

class ServerEngine {
  final Map<String, FakeServerConfig> _runningServers = {};
  final Map<String, _ServerContext> _contexts = {};
  final Map<String, List<ServerRequestLog>> _requestLogs = {};
  final Map<String, HttpServer> _httpServers = {};
  final Map<String, ServerSocket> _tcpServers = {};
  final Map<String, List<WebSocket>> _webSockets = {};

  Future<void> start(FakeServerConfig config) async {
    if (_runningServers.containsKey(config.id)) {
      await stop(config.id);
    }

    switch (config.protocol) {
      case ServerProtocol.http:
      case ServerProtocol.websocket:
        await _startHttpServer(config);
      case ServerProtocol.tcp:
        await _startTcpServer(config);
    }

    _runningServers[config.id] = config;
    _contexts[config.id] = _ServerContext(config);
    _requestLogs.putIfAbsent(config.id, () => <ServerRequestLog>[]);
  }

  Future<void> stop(String serverId) async {
    final config = _runningServers[serverId];
    if (config == null) return;

    final httpServer = _httpServers.remove(serverId);
    await httpServer?.close(force: true);

    final sockets = _webSockets.remove(serverId) ?? const <WebSocket>[];
    for (final ws in sockets) {
      await ws.close();
    }

    final tcpServer = _tcpServers.remove(serverId);
    await tcpServer?.close();

    _runningServers.remove(serverId);
    _contexts.remove(serverId);
  }

  Future<void> stopAll() async {
    final ids = _runningServers.keys.toList();
    for (final id in ids) {
      await stop(id);
    }
  }

  FakeServerStatus? getStatus(String serverId) {
    final config = _runningServers[serverId];
    if (config == null) return null;

    final context = _contexts[serverId];
    final now = DateTime.now().millisecondsSinceEpoch;
    return FakeServerStatus(
      serverId: serverId,
      status: 1,
      address: '${_scheme(config)}://0.0.0.0:${config.port}',
      port: config.port,
      connections: context?.connectionCount ?? 0,
      requests: context?.requestCount ?? 0,
      uptime: now - (context?.startTime ?? now),
    );
  }

  List<ServerRequestLog> getRequestLogs(String serverId) {
    return List<ServerRequestLog>.from(_requestLogs[serverId] ?? const []);
  }

  List<FakeServerConfig> getRunningServers() {
    return _runningServers.values.toList();
  }

  bool isRunning(String serverId) => _runningServers.containsKey(serverId);

  String _scheme(FakeServerConfig config) {
    switch (config.protocol) {
      case ServerProtocol.http:
        return 'http';
      case ServerProtocol.websocket:
        return 'ws';
      case ServerProtocol.tcp:
        return 'tcp';
    }
  }

  Future<void> _startHttpServer(FakeServerConfig config) async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, config.port);
    _httpServers[config.id] = server;
    server.listen((request) {
      unawaited(_handleHttpRequest(config.id, request));
    });
  }

  Future<void> _startTcpServer(FakeServerConfig config) async {
    final server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      config.port,
    );
    _tcpServers[config.id] = server;
    server.listen((socket) {
      _handleTcpConnection(config, socket);
    });
  }

  Future<void> _handleHttpRequest(String serverId, HttpRequest request) async {
    final context = _contexts[serverId];
    final config = _runningServers[serverId];
    if (context == null || config == null) {
      request.response.statusCode = HttpStatus.serviceUnavailable;
      await request.response.close();
      return;
    }

    context.connectionCount++;
    context.requestCount++;

    final path = request.uri.path;
    final method = request.method;
    final startTime = DateTime.now();
    var statusCode = 200;
    var responseBody = '';

    try {
      if (WebSocketTransformer.isUpgradeRequest(request) &&
          config.protocol == ServerProtocol.websocket) {
        final ws = await WebSocketTransformer.upgrade(request);
        _webSockets.putIfAbsent(serverId, () => <WebSocket>[]).add(ws);
        ws.listen(
          (data) {
            _handleWebSocketMessage(config, ws, data);
          },
          onDone: () {
            _webSockets[serverId]?.remove(ws);
          },
        );
        statusCode = 101;
        responseBody = 'websocket upgrade';
      } else {
        final route = _findMatchingRoute(config, path, method);
        if (path == '/login' || path == '/api/login') {
          final result = await _handleLoginRequest(request);
          statusCode = result.statusCode;
          responseBody = result.body;
          request.response.statusCode = statusCode;
          request.response.headers.contentType = ContentType.json;
          request.response.write(responseBody);
        } else if (route != null) {
          statusCode = int.tryParse(route.responseStatus) ?? 200;
          request.response.statusCode = statusCode;
          request.response.headers.contentType = ContentType.parse(
            route.responseType.isEmpty
                ? 'application/json'
                : route.responseType,
          );
          if (route.responseDelay > 0) {
            await Future<void>.delayed(
              Duration(milliseconds: route.responseDelay),
            );
          }
          responseBody = route.responseBody;
          request.response.write(responseBody);
        } else {
          statusCode = 404;
          responseBody = jsonEncode({
            'code': 404,
            'message': 'Route not found',
            'path': path,
          });
          request.response.statusCode = statusCode;
          request.response.headers.contentType = ContentType.json;
          request.response.write(responseBody);
        }
        await request.response.close();
      }
    } catch (error) {
      statusCode = 500;
      responseBody = jsonEncode({
        'code': 500,
        'message': error.toString(),
      });
      try {
        request.response.statusCode = statusCode;
        request.response.headers.contentType = ContentType.json;
        request.response.write(responseBody);
        await request.response.close();
      } catch (_) {}
    }

    final duration = DateTime.now().difference(startTime).inMilliseconds;
    _logRequest(
      serverId: serverId,
      method: method,
      path: path,
      client: request.connectionInfo?.remoteAddress.address ?? '',
      status: statusCode,
      duration: duration,
      responseBody: responseBody,
    );
  }

  Future<_LoginResult> _handleLoginRequest(HttpRequest request) async {
    final requestBody = await utf8.decodeStream(request);
    Map<String, dynamic> data = const {};
    if (requestBody.trim().isNotEmpty) {
      final decoded = jsonDecode(requestBody);
      if (decoded is Map<String, dynamic>) {
        data = decoded;
      }
    }

    final username = '${data['username'] ?? data['account'] ?? ''}';
    final password = '${data['password'] ?? ''}';
    final isValid = username.isNotEmpty && password.isNotEmpty;
    final token = _generateToken(username);

    return _LoginResult(
      statusCode: isValid ? 200 : 401,
      body: jsonEncode({
        'code': isValid ? 0 : 401,
        'message': isValid ? 'Login successful' : 'Invalid credentials',
        'data': isValid
            ? {
                'token': token,
                'expiresIn': 86400,
                'user': {
                  'username': username,
                  'id': username.hashCode,
                },
              }
            : null,
      }),
    );
  }

  RouteRule? _findMatchingRoute(
    FakeServerConfig config,
    String path,
    String method,
  ) {
    for (final route in config.routes) {
      if (route.path == path &&
          route.method.toUpperCase() == method.toUpperCase()) {
        return route;
      }
    }
    for (final route in config.routes) {
      if (route.path == '/*' || route.path == '*') {
        return route;
      }
    }
    return null;
  }

  void _handleWebSocketMessage(
    FakeServerConfig config,
    WebSocket socket,
    dynamic data,
  ) {
    final context = _contexts[config.id];
    context?.requestCount++;

    Map<String, dynamic> payload = const {};
    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          payload = decoded;
        }
      } catch (_) {}
    }

    final action = '${payload['action'] ?? payload['cmd'] ?? ''}';
    if (action == 'login') {
      final username = '${payload['username'] ?? ''}';
      socket.add(
        jsonEncode({
          'code': 0,
          'message': 'Login successful',
          'data': {
            'token': _generateToken(username),
            'expiresIn': 86400,
          },
        }),
      );
      return;
    }

    socket.add(
      jsonEncode({
        'code': 0,
        'message': 'ok',
        'echo': data is String ? data : data.toString(),
      }),
    );
  }

  void _handleTcpConnection(FakeServerConfig config, Socket socket) {
    final context = _contexts[config.id];
    if (context != null) {
      context.connectionCount++;
    }

    socket.listen((data) {
      context?.requestCount++;
      socket.write('OK\n');
    });
  }

  String _generateToken(String username) {
    return '${username}_${DateTime.now().millisecondsSinceEpoch}_${_randomString(16)}';
  }

  String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  void _logRequest({
    required String serverId,
    required String method,
    required String path,
    required String client,
    required int status,
    required int duration,
    String responseBody = '',
  }) {
    final logs = _requestLogs.putIfAbsent(serverId, () => <ServerRequestLog>[]);
    logs.insert(
      0,
      ServerRequestLog(
        id: DateTime.now().microsecondsSinceEpoch,
        serverId: serverId,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        method: method,
        path: path,
        client: client,
        status: status,
        duration: duration,
        responseBody: responseBody,
      ),
    );
    if (logs.length > 200) {
      logs.removeRange(200, logs.length);
    }
  }
}

class _ServerContext {
  _ServerContext(this.serverConfig)
    : startTime = DateTime.now().millisecondsSinceEpoch;

  final FakeServerConfig serverConfig;
  final int startTime;
  int connectionCount = 0;
  int requestCount = 0;
}

class _LoginResult {
  const _LoginResult({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}
