import 'dart:convert';

import 'package:JsxposedX/core/services/app_storage.dart';
import 'package:JsxposedX/features/server/domain/models/server_config.dart';
import 'package:JsxposedX/features/server/domain/models/server_status.dart';
import 'package:JsxposedX/features/server/domain/services/server_engine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_provider.g.dart';

const serverListStorageKey = 'server_list';

@Riverpod(keepAlive: true)
class ServerList extends _$ServerList {
  @override
  Future<List<FakeServerConfig>> build() async {
    await ref.watch(sharedPreferencesProvider.future);
    return _load();
  }

  List<FakeServerConfig> _load() {
    final storage = ref.read(appStorageProvider.notifier);
    final json = storage.getString(serverListStorageKey) ?? '[]';
    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map(
            (item) => FakeServerConfig.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> refresh() async {
    state = AsyncData(_load());
  }

  Future<void> save(List<FakeServerConfig> servers) async {
    final storage = ref.read(appStorageProvider.notifier);
    await storage.setString(
      serverListStorageKey,
      jsonEncode(servers.map((server) => server.toJson()).toList()),
    );
    state = AsyncData(servers);
  }
}

@Riverpod(keepAlive: true)
class ActiveServer extends _$ActiveServer {
  @override
  FakeServerStatus? build() => null;

  void setActive(FakeServerStatus status) {
    state = status;
  }

  void clear() {
    state = null;
  }
}

@Riverpod(keepAlive: true)
class ServerRuntimeStatus extends _$ServerRuntimeStatus {
  @override
  Future<FakeServerStatus?> build(String serverId) async {
    return ref.read(serverEngineProvider).getStatus(serverId);
  }

  Future<void> markStatus(FakeServerStatus status) async {
    state = AsyncData(status);
  }
}

@Riverpod(keepAlive: true)
class ServerAction extends _$ServerAction {
  @override
  Future<void> build() async {}

  Future<void> createServer(FakeServerConfig server) async {
    final servers = [...await ref.read(serverListProvider.future), server];
    await ref.read(serverListProvider.notifier).save(servers);
  }

  Future<void> updateServer(FakeServerConfig server) async {
    final servers = await ref.read(serverListProvider.future);
    final next = servers
        .map((item) => item.id == server.id ? server : item)
        .toList();
    await ref.read(serverListProvider.notifier).save(next);
  }

  Future<void> deleteServer(String serverId) async {
    final engine = ref.read(serverEngineProvider);
    if (engine.isRunning(serverId)) {
      await engine.stop(serverId);
    }
    final servers = await ref.read(serverListProvider.future);
    await ref
        .read(serverListProvider.notifier)
        .save(servers.where((server) => server.id != serverId).toList());
    ref.read(activeServerProvider.notifier).clear();
  }

  Future<void> startServer(String serverId) async {
    final servers = await ref.read(serverListProvider.future);
    final server = servers.firstWhere((item) => item.id == serverId);
    final engine = ref.read(serverEngineProvider);
    await engine.start(server);
    final status =
        engine.getStatus(server.id) ??
        FakeServerStatus(
          serverId: server.id,
          status: 1,
          address: 'http://0.0.0.0:${server.port}',
          port: server.port,
        );
    await ref
        .read(serverRuntimeStatusProvider(server.id).notifier)
        .markStatus(status);
    ref.read(activeServerProvider.notifier).setActive(status);
  }

  Future<void> stopServer(String serverId) async {
    final engine = ref.read(serverEngineProvider);
    await engine.stop(serverId);
    final status = FakeServerStatus(
      serverId: serverId,
      status: 0,
      address: '',
      port: 0,
    );
    await ref
        .read(serverRuntimeStatusProvider(serverId).notifier)
        .markStatus(status);
    final active = ref.read(activeServerProvider);
    if (active?.serverId == serverId) {
      ref.read(activeServerProvider.notifier).clear();
    }
  }

  Future<void> addRoute(String serverId, RouteRule route) async {
    final servers = await ref.read(serverListProvider.future);
    final next = servers.map((server) {
      if (server.id != serverId) return server;
      return server.copyWith(
        routes: [...server.routes, route],
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
    }).toList();
    await ref.read(serverListProvider.notifier).save(next);
  }

  Future<void> deleteRoute(String serverId, String path) async {
    final servers = await ref.read(serverListProvider.future);
    final next = servers.map((server) {
      if (server.id != serverId) return server;
      return server.copyWith(
        routes: server.routes.where((route) => route.path != path).toList(),
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
    }).toList();
    await ref.read(serverListProvider.notifier).save(next);
  }

  Future<String> enablePortForwarding({
    required String serverId,
    required String service,
    String token = '',
  }) async {
    final servers = await ref.read(serverListProvider.future);
    final server = servers.firstWhere((item) => item.id == serverId);
    final url = 'https://$serverId.${service.isEmpty ? 'local' : service}.app';
    await updateServer(
      server.copyWith(
        enablePortForwarding: true,
        portForwardingService: service,
        portForwardingToken: token,
        portForwardingUrl: url,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    return url;
  }
}

@Riverpod(keepAlive: true)
ServerEngine serverEngine(Ref ref) {
  final engine = ServerEngine();
  ref.onDispose(() {
    engine.stopAll();
  });
  return engine;
}
