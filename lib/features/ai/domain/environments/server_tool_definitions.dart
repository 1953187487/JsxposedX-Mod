import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';

class ServerToolDefinitions {
  ServerToolDefinitions._();

  static final createServer = AiToolDefinition(
    name: 'create_fake_server',
    description: '创建一个本地伪造服务器，可以模拟游戏服务器响应。支持 HTTP、WebSocket、TCP 协议。',
    descriptionEn:
        'Create a local fake server to simulate game server responses. Supports HTTP, WebSocket, and TCP protocols.',
    parameters: (ToolParametersBuilder()
          ..addString('name', '服务器名称', required: true)
          ..addString('protocol', '协议类型：http、websocket、tcp', required: true)
          ..addInteger('port', '监听端口，如 8080', required: true)
          ..addString('target_host', '目标服务器地址（可选）')
          ..addString('target_port', '目标服务器端口（可选）')
          ..addString('description', '服务器描述'))
        .build(),
  );

  static final startServer = AiToolDefinition(
    name: 'start_fake_server',
    description: '启动指定的伪造服务器。',
    descriptionEn: 'Start the specified fake server.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true))
        .build(),
  );

  static final stopServer = AiToolDefinition(
    name: 'stop_fake_server',
    description: '停止指定的伪造服务器。',
    descriptionEn: 'Stop the specified fake server.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true))
        .build(),
  );

  static final deleteServer = AiToolDefinition(
    name: 'delete_fake_server',
    description: '删除指定的伪造服务器配置。',
    descriptionEn: 'Delete the specified fake server configuration.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true))
        .build(),
  );

  static final listServers = AiToolDefinition(
    name: 'list_fake_servers',
    description: '获取所有伪造服务器列表及其状态。',
    descriptionEn: 'Get all fake servers list and their status.',
    parameters: ToolParametersBuilder.empty(),
  );

  static final getServerStatus = AiToolDefinition(
    name: 'get_fake_server_status',
    description: '获取指定服务器的运行状态。',
    descriptionEn: 'Get the running status of the specified server.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true))
        .build(),
  );

  static final addRouteRule = AiToolDefinition(
    name: 'add_server_route_rule',
    description: '为服务器添加路由规则，定义请求路径和响应内容。',
    descriptionEn:
        'Add a route rule to the server, defining request path and response content.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true)
          ..addString('path', '请求路径，如 /api/user', required: true)
          ..addString('method', 'HTTP 方法：GET、POST、PUT、DELETE', required: true)
          ..addString('response_body', '响应内容（JSON 字符串）', required: true)
          ..addString('response_status', 'HTTP 状态码，如 200')
          ..addString('response_type', '响应类型，如 application/json')
          ..addInteger('response_delay', '响应延迟（毫秒）'))
        .build(),
  );

  static final deleteRouteRule = AiToolDefinition(
    name: 'delete_server_route_rule',
    description: '删除服务器的路由规则。',
    descriptionEn: 'Delete a server route rule.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true)
          ..addString('path', '要删除的路由路径', required: true))
        .build(),
  );

  static final getRequestLogs = AiToolDefinition(
    name: 'get_fake_server_logs',
    description: '获取服务器的请求日志，分析收到的请求。',
    descriptionEn: 'Get server request logs to analyze received requests.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true)
          ..addInteger('limit', '返回日志数量限制，默认 50'))
        .build(),
  );

  static final enablePortForwarding = AiToolDefinition(
    name: 'enable_server_port_forwarding',
    description: '为服务器启用内网穿透，让外部设备可以访问本地服务器。内测版返回占位 URL。',
    descriptionEn:
        'Enable port forwarding for the server. Beta returns a placeholder URL.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true)
          ..addString('service', '内网穿透服务：ngrok、frp、nps', required: true)
          ..addString('token', '服务 Token（如需要）'))
        .build(),
  );

  static final analyzeGameProtocol = AiToolDefinition(
    name: 'analyze_game_protocol',
    description: '分析目标游戏的网络协议，识别登录、数据同步等接口。',
    descriptionEn:
        'Analyze the target game network protocol, identifying login, data sync and other interfaces.',
    parameters: (ToolParametersBuilder()
          ..addString('package_name', '游戏包名', required: true))
        .build(),
  );

  static final simulateGameServer = AiToolDefinition(
    name: 'simulate_game_server',
    description: '根据分析结果模拟游戏服务器，返回预设数据。',
    descriptionEn:
        'Simulate game server based on analysis results, returning preset data.',
    parameters: (ToolParametersBuilder()
          ..addString('server_id', '服务器 ID', required: true)
          ..addString('game_name', '游戏名称', required: true)
          ..addString('protocol_type', '协议类型：http、websocket、tcp', required: true))
        .build(),
  );

  static final convertToOnlineGame = AiToolDefinition(
    name: 'convert_to_online_game',
    description: '将单机游戏转换为联机游戏，创建本地服务器让多个客户端连接。',
    descriptionEn:
        'Convert single-player game to online game, creating local server for multiple clients to connect.',
    parameters: (ToolParametersBuilder()
          ..addString('package_name', '游戏包名', required: true)
          ..addString('server_id', '服务器 ID', required: true)
          ..addInteger('max_players', '最大玩家数量，默认 10'))
        .build(),
  );

  static final List<AiToolDefinition> all = [
    createServer,
    startServer,
    stopServer,
    deleteServer,
    listServers,
    getServerStatus,
    addRouteRule,
    deleteRouteRule,
    getRequestLogs,
    enablePortForwarding,
    analyzeGameProtocol,
    simulateGameServer,
    convertToOnlineGame,
  ];
}
