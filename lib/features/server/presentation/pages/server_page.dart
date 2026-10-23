import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/server/domain/models/server_config.dart';
import 'package:JsxposedX/features/server/domain/models/server_status.dart';
import 'package:JsxposedX/features/server/presentation/providers/server_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServerPage extends HookConsumerWidget {
  const ServerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servers = ref.watch(serverListProvider);
    final activeServer = ref.watch(activeServerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.serverManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateServerDialog(context),
            tooltip: context.l10n.createServer,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(serverListProvider.notifier).refresh(),
            tooltip: context.l10n.refresh,
          ),
        ],
      ),
      body: servers.when(
        data: (serverList) => serverList.isEmpty
            ? _EmptyState(onCreate: () => _showCreateServerDialog(context))
            : ListView.builder(
                padding: EdgeInsets.all(12.w),
                itemCount: serverList.length,
                itemBuilder: (context, index) => _ServerCard(
                  server: serverList[index],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('${context.l10n.error}: $error')),
      ),
      bottomNavigationBar: activeServer == null
          ? null
          : _ActiveServerBar(server: activeServer),
    );
  }

  void _showCreateServerDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _CreateServerSheet(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_outlined,
            size: 80.sp,
            color: context.colorScheme.primary.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            context.l10n.noServers,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.noServersHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 24.h),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.createServer),
          ),
        ],
      ),
    );
  }
}

class _ServerCard extends HookConsumerWidget {
  const _ServerCard({required this.server});

  final FakeServerConfig server;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(serverRuntimeStatusProvider(server.id));
    final isRunning = status.value?.status == 1;

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isRunning ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${server.protocol.name}://0.0.0.0:${server.port}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (server.enablePortForwarding &&
                      server.portForwardingUrl.isNotEmpty)
                    Text(
                      server.portForwardingUrl,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontSize: 10.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
              onPressed: () => _toggleServer(context, ref, isRunning),
              tooltip: isRunning
                  ? context.l10n.stopServer
                  : context.l10n.startServer,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteServer(context, ref),
              tooltip: context.l10n.delete,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleServer(
    BuildContext context,
    WidgetRef ref,
    bool isRunning,
  ) async {
    final actions = ref.read(serverActionProvider.notifier);
    try {
      if (isRunning) {
        await actions.stopServer(server.id);
        ToastMessage.show(context.l10n.serverStopped);
      } else {
        await actions.startServer(server.id);
        ToastMessage.show(context.l10n.serverStarted);
      }
    } catch (e) {
      ToastMessage.show('${context.l10n.error}: $e');
    }
  }

  Future<void> _deleteServer(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.confirmDelete),
        content: Text(context.l10n.confirmDeleteServer(server.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(serverActionProvider.notifier).deleteServer(server.id);
        ToastMessage.show(context.l10n.serverDeleted);
      } catch (e) {
        ToastMessage.show('${context.l10n.error}: $e');
      }
    }
  }
}

class _ActiveServerBar extends HookConsumerWidget {
  const _ActiveServerBar({required this.server});

  final FakeServerStatus server;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: context.colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.cloud_done, color: Colors.green, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        server.address,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        '${server.connections} ${context.l10n.connections}, ${server.requests} ${context.l10n.requests}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(serverActionProvider.notifier)
                      .stopServer(server.serverId),
                  child: Text(context.l10n.stopServer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateServerSheet extends HookConsumerWidget {
  const _CreateServerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final portController = useTextEditingController(text: '8080');
    final targetHostController = useTextEditingController();
    final targetPortController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final protocol = useState(ServerProtocol.http);
    final enablePortForwarding = useState(false);
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h + viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.createServer,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.l10n.serverName,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ServerProtocol>(
                    initialValue: protocol.value,
                    items: const [
                      DropdownMenuItem(
                        value: ServerProtocol.http,
                        child: Text('HTTP'),
                      ),
                      DropdownMenuItem(
                        value: ServerProtocol.websocket,
                        child: Text('WebSocket'),
                      ),
                      DropdownMenuItem(
                        value: ServerProtocol.tcp,
                        child: Text('TCP'),
                      ),
                    ],
                    onChanged: (value) =>
                        protocol.value = value ?? ServerProtocol.http,
                    decoration: InputDecoration(
                      labelText: context.l10n.protocol,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: portController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.l10n.port,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: targetHostController,
              decoration: InputDecoration(
                labelText: context.l10n.targetHost,
                hintText: context.l10n.targetHostHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: targetPortController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: context.l10n.targetPort,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: context.l10n.description,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SwitchListTile(
              value: enablePortForwarding.value,
              onChanged: (value) => enablePortForwarding.value = value,
              title: Text(context.l10n.enablePortForwarding),
              subtitle: Text(context.l10n.enablePortForwardingHint),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.l10n.cancel),
                ),
                SizedBox(width: 12.w),
                FilledButton.icon(
                  onPressed: () => _createServer(
                    context,
                    ref,
                    nameController: nameController,
                    portController: portController,
                    targetHostController: targetHostController,
                    targetPortController: targetPortController,
                    descriptionController: descriptionController,
                    protocol: protocol.value,
                    enablePortForwarding: enablePortForwarding.value,
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(context.l10n.create),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createServer(
    BuildContext context,
    WidgetRef ref, {
    required TextEditingController nameController,
    required TextEditingController portController,
    required TextEditingController targetHostController,
    required TextEditingController targetPortController,
    required TextEditingController descriptionController,
    required ServerProtocol protocol,
    required bool enablePortForwarding,
  }) async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ToastMessage.show(context.l10n.serverNameRequired);
      return;
    }

    final server = FakeServerConfig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      protocol: protocol,
      port: int.tryParse(portController.text.trim()) ?? 8080,
      targetHost: targetHostController.text.trim(),
      targetPort: targetPortController.text.trim(),
      description: descriptionController.text.trim(),
      enablePortForwarding: enablePortForwarding,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    try {
      await ref.read(serverActionProvider.notifier).createServer(server);
      ToastMessage.show(context.l10n.serverCreated);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ToastMessage.show('${context.l10n.error}: $e');
    }
  }
}
