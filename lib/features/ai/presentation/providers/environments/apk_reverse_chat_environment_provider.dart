import 'dart:async';

import 'package:JsxposedX/features/ai/domain/environments/apk_reverse_chat_environment_adapter.dart';
import 'package:JsxposedX/features/ai/domain/environments/server_tool_handlers.dart';
import 'package:JsxposedX/features/ai/presentation/providers/ai_conversation_export_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_action_provider.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:JsxposedX/features/server/presentation/providers/server_provider.dart';
import 'package:JsxposedX/features/so_analysis/presentation/providers/so_analysis_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apk_reverse_chat_environment_provider.g.dart';

class ApkReverseChatEnvironmentArgs {
  const ApkReverseChatEnvironmentArgs({
    required this.packageName,
    required this.isZh,
  });

  final String packageName;
  final bool isZh;

  @override
  bool operator ==(Object other) {
    return other is ApkReverseChatEnvironmentArgs &&
        other.packageName == packageName &&
        other.isZh == isZh;
  }

  @override
  int get hashCode => Object.hash(packageName, isZh);
}

@riverpod
ApkReverseChatEnvironmentAdapter apkReverseChatEnvironment(
  Ref ref,
  ApkReverseChatEnvironmentArgs args,
) {
  final adapter = ApkReverseChatEnvironmentAdapter(
    packageName: args.packageName,
    isZh: args.isZh,
    conversationBinding: ref.watch(scriptConversationBindingProvider),
    apkActionRepository: ref.watch(apkAnalysisActionRepositoryProvider),
    apkQueryRepository: ref.watch(apkAnalysisQueryRepositoryProvider),
    soDataSource: ref.watch(soAnalysisDatasourceProvider),
    exportService: ref.watch(aiConversationExportServiceProvider),
    serverRuntime: ServerToolRuntime(
      engine: ref.watch(serverEngineProvider),
      listServers: () => ref.read(serverListProvider.future),
      createServer: (server) =>
          ref.read(serverActionProvider.notifier).createServer(server),
      updateServer: (server) =>
          ref.read(serverActionProvider.notifier).updateServer(server),
      deleteServer: (serverId) =>
          ref.read(serverActionProvider.notifier).deleteServer(serverId),
      startServer: (serverId) =>
          ref.read(serverActionProvider.notifier).startServer(serverId),
      stopServer: (serverId) =>
          ref.read(serverActionProvider.notifier).stopServer(serverId),
      addRoute: (serverId, route) =>
          ref.read(serverActionProvider.notifier).addRoute(serverId, route),
      deleteRoute: (serverId, path) =>
          ref.read(serverActionProvider.notifier).deleteRoute(serverId, path),
      enablePortForwarding:
          ({
            required String serverId,
            required String service,
            String token = '',
          }) => ref.read(serverActionProvider.notifier).enablePortForwarding(
            serverId: serverId,
            service: service,
            token: token,
          ),
    ),
  );
  ref.onDispose(() {
    unawaited(adapter.dispose());
  });
  return adapter;
}
