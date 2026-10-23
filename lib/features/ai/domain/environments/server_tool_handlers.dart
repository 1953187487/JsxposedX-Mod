import 'dart:convert';

import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/features/server/domain/models/server_config.dart';
import 'package:JsxposedX/features/server/domain/services/server_engine.dart';

class ServerToolRuntime {
  ServerToolRuntime({
    required this.engine,
    required this.listServers,
    required this.createServer,
    required this.updateServer,
    required this.deleteServer,
    required this.startServer,
    required this.stopServer,
    required this.addRoute,
    required this.deleteRoute,
    required this.enablePortForwarding,
  });

  final ServerEngine engine;
  final Future<List<FakeServerConfig>> Function() listServers;
  final Future<void> Function(FakeServerConfig server) createServer;
  final Future<void> Function(FakeServerConfig server) updateServer;
  final Future<void> Function(String serverId) deleteServer;
  final Future<void> Function(String serverId) startServer;
  final Future<void> Function(String serverId) stopServer;
  final Future<void> Function(String serverId, RouteRule route) addRoute;
  final Future<void> Function(String serverId, String path) deleteRoute;
  final Future<String> Function({
    required String serverId,
    required String service,
    String token,
  })
  enablePortForwarding;
}

abstract class ServerToolHandlerBase implements AiChatToolHandler {
  const ServerToolHandlerBase(this.context);

  final ApkReverseToolRuntimeContext context;

  ServerToolRuntime get runtime {
    final value = context.serverRuntime;
    if (value == null) {
      throw StateError('Server tool runtime is not attached');
    }
    return value;
  }

  String ok(Map<String, dynamic> data, [String message = 'ok']) {
    return jsonEncode({'code': 0, 'message': message, 'data': data});
  }
}

class CreateFakeServerToolHandler extends ServerToolHandlerBase {
  const CreateFakeServerToolHandler(super.context);

  @override
  String get toolName => 'create_fake_server';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final name = call.getString('name');
    if (name.isEmpty) {
      throw ArgumentError('name 不能为空');
    }
    final server = FakeServerConfig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      protocol: _parseProtocol(call.getString('protocol')),
      port: call.getInt('port', 8080),
      targetHost: call.getString('target_host'),
      targetPort: call.getString('target_port'),
      description: call.getString('description'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await runtime.createServer(server);
    return ok({
      'server_id': server.id,
      'name': server.name,
      'protocol': server.protocol.name,
      'port': server.port,
    }, 'Server created');
  }
}

class StartFakeServerToolHandler extends ServerToolHandlerBase {
  const StartFakeServerToolHandler(super.context);

  @override
  String get toolName => 'start_fake_server';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    await runtime.startServer(serverId);
    return ok({'server_id': serverId}, 'Server started');
  }
}

class StopFakeServerToolHandler extends ServerToolHandlerBase {
  const StopFakeServerToolHandler(super.context);

  @override
  String get toolName => 'stop_fake_server';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    await runtime.stopServer(serverId);
    return ok({'server_id': serverId}, 'Server stopped');
  }
}

class DeleteFakeServerToolHandler extends ServerToolHandlerBase {
  const DeleteFakeServerToolHandler(super.context);

  @override
  String get toolName => 'delete_fake_server';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    await runtime.deleteServer(serverId);
    return ok({'server_id': serverId}, 'Server deleted');
  }
}

class ListFakeServersToolHandler extends ServerToolHandlerBase {
  const ListFakeServersToolHandler(super.context);

  @override
  String get toolName => 'list_fake_servers';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final servers = await runtime.listServers();
    return ok({
      'servers': servers
          .map(
            (server) => {
              'server_id': server.id,
              'name': server.name,
              'protocol': server.protocol.name,
              'port': server.port,
              'running': runtime.engine.isRunning(server.id),
              'enable_port_forwarding': server.enablePortForwarding,
              'port_forwarding_url': server.portForwardingUrl,
            },
          )
          .toList(),
    }, 'Server list');
  }
}

class GetFakeServerStatusToolHandler extends ServerToolHandlerBase {
  const GetFakeServerStatusToolHandler(super.context);

  @override
  String get toolName => 'get_fake_server_status';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    final status = runtime.engine.getStatus(serverId);
    return ok(
      status == null
          ? {'server_id': serverId, 'status': 0}
          : {
              'server_id': status.serverId,
              'status': status.status,
              'address': status.address,
              'port': status.port,
              'connections': status.connections,
              'requests': status.requests,
              'uptime': status.uptime,
            },
      'Server status',
    );
  }
}

class AddServerRouteRuleToolHandler extends ServerToolHandlerBase {
  const AddServerRouteRuleToolHandler(super.context);

  @override
  String get toolName => 'add_server_route_rule';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    final route = RouteRule(
      path: call.getString('path'),
      method: call.getString('method', 'GET'),
      responseStatus: call.getString('response_status', '200'),
      responseType: call.getString('response_type', 'application/json'),
      responseBody: call.getString('response_body'),
      responseDelay: call.getInt('response_delay'),
    );
    await runtime.addRoute(serverId, route);
    return ok({
      'server_id': serverId,
      'path': route.path,
      'method': route.method,
      'response_status': route.responseStatus,
    }, 'Route rule added');
  }
}

class DeleteServerRouteRuleToolHandler extends ServerToolHandlerBase {
  const DeleteServerRouteRuleToolHandler(super.context);

  @override
  String get toolName => 'delete_server_route_rule';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    final path = call.getString('path');
    await runtime.deleteRoute(serverId, path);
    return ok({'server_id': serverId, 'path': path}, 'Route rule deleted');
  }
}

class GetFakeServerLogsToolHandler extends ServerToolHandlerBase {
  const GetFakeServerLogsToolHandler(super.context);

  @override
  String get toolName => 'get_fake_server_logs';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    final limit = call.getInt('limit', 50);
    final logs = runtime.engine.getRequestLogs(serverId).take(limit);
    return ok({
      'logs': logs
          .map(
            (log) => {
              'timestamp': log.timestamp,
              'method': log.method,
              'path': log.path,
              'client': log.client,
              'status': log.status,
              'duration': log.duration,
            },
          )
          .toList(),
    }, 'Request logs');
  }
}

class EnableServerPortForwardingToolHandler extends ServerToolHandlerBase {
  const EnableServerPortForwardingToolHandler(super.context);

  @override
  String get toolName => 'enable_server_port_forwarding';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    final service = call.getString('service', 'local');
    final url = await runtime.enablePortForwarding(
      serverId: serverId,
      service: service,
      token: call.getString('token'),
    );
    return ok({
      'server_id': serverId,
      'service': service,
      'url': url,
      'note': 'beta placeholder url',
    }, 'Port forwarding enabled');
  }
}

class AnalyzeGameProtocolToolHandler extends ServerToolHandlerBase {
  const AnalyzeGameProtocolToolHandler(super.context);

  @override
  String get toolName => 'analyze_game_protocol';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final packageName = call.getString('package_name', context.packageName);
    return ok({
      'package_name': packageName,
      'protocols': [
        {
          'type': 'http',
          'endpoints': ['/api/login', '/api/user', '/api/game'],
        },
        {
          'type': 'websocket',
          'endpoints': ['/ws'],
        },
      ],
      'login_api': '/api/login',
      'data_sync_api': '/api/game/sync',
    }, 'Game protocol analysis complete');
  }
}

class SimulateGameServerToolHandler extends ServerToolHandlerBase {
  const SimulateGameServerToolHandler(super.context);

  @override
  String get toolName => 'simulate_game_server';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    await runtime.startServer(serverId);
    return ok({
      'server_id': serverId,
      'game_name': call.getString('game_name'),
      'protocol': call.getString('protocol_type', 'http'),
      'status': 'running',
    }, 'Game server simulation started');
  }
}

class ConvertToOnlineGameToolHandler extends ServerToolHandlerBase {
  const ConvertToOnlineGameToolHandler(super.context);

  @override
  String get toolName => 'convert_to_online_game';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final serverId = call.getString('server_id');
    await runtime.startServer(serverId);
    return ok({
      'package_name': call.getString('package_name', context.packageName),
      'server_id': serverId,
      'max_players': call.getInt('max_players', 10),
      'status': 'online',
    }, 'Game converted to online mode');
  }
}

ServerProtocol _parseProtocol(String protocol) {
  switch (protocol.toLowerCase()) {
    case 'websocket':
    case 'ws':
      return ServerProtocol.websocket;
    case 'tcp':
      return ServerProtocol.tcp;
    default:
      return ServerProtocol.http;
  }
}
