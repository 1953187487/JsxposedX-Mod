import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/providers/ai_conversation_export_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_session_view.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_quick_settings_menu.dart';
import 'package:JsxposedX/features/app/presentation/providers/app_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class AiConversationDrawer extends HookConsumerWidget {
  const AiConversationDrawer({
    super.key,
    required this.packageName,
    required this.onSessionSelected,
  });

  final String packageName;
  final void Function(String sessionId) onSessionSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(
      aiChatRuntimeProvider(packageName: packageName),
    );
    final chatNotifier = ref.read(
      aiChatRuntimeProvider(packageName: packageName).notifier,
    );
    final sessions = chatNotifier.getSessions();
    final isZh = context.isZh;
    final currentId = chatState.currentSessionId;
    final appInfoAsync = ref.watch(
      getAppByPackageNameProvider(packageName: packageName),
    );
    final activeAiConfigMeta = ref.watch(activeAiConfigMetaProvider);
    final chatSurface = context.theme.scaffoldBackgroundColor;

    return Drawer(
      width: 304.w,
      backgroundColor: chatSurface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 16.w, 12.h),
              decoration: BoxDecoration(
                color: chatSurface,
                border: Border(
                  bottom: BorderSide(color: context.colorScheme.outlineVariant),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appInfoAsync.when(
                    data: (app) => Row(
                      children: [
                        if (app?.icon != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.memory(
                              app!.icon,
                              width: 42.w,
                              height: 42.w,
                            ),
                          )
                        else
                          Icon(
                            Icons.android,
                            size: 42.w,
                            color: context.colorScheme.primary,
                          ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app?.name ?? context.l10n.aiIdentifying,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                packageName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    loading: () => const SizedBox(height: 42),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  activeAiConfigMeta.when(
                    data: (meta) => meta.isBuiltin
                        ? Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Text(
                              context.l10n.aiBuiltinConfigName,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isZh ? '对话列表' : 'Conversations',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _DrawerActionButton(
                        icon: Icons.settings_rounded,
                        tooltip: isZh ? '快捷设置' : 'Quick Settings',
                        color: context.colorScheme.secondary,
                        onTap: () {
                          Navigator.pop(context);
                          AiQuickSettingsMenu.show(
                            context,
                            packageName: packageName,
                          );
                        },
                      ),
                      SizedBox(width: 6.w),
                      _DrawerActionButton(
                        icon: Icons.add_comment_rounded,
                        tooltip: context.l10n.aiNewSession,
                        onTap: () async {
                          Navigator.pop(context);
                          final controller = TextEditingController(
                            text:
                                '${context.l10n.aiNewSession} ${DateFormat('MM-dd HH:mm').format(DateTime.now())}',
                          );
                          final name = await CustomDialog.show<String>(
                            title: Text(context.l10n.aiNewSession),
                            child: TextField(
                              controller: controller,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: context.l10n.aiSessionName,
                                hintText: context.l10n.aiSessionNameHint,
                              ),
                            ),
                            actionButtons: [
                              TextButton(
                                onPressed: () => SmartDialog.dismiss(),
                                child: Text(context.l10n.cancel),
                              ),
                              TextButton(
                                onPressed: () => SmartDialog.dismiss(
                                  result: controller.text.trim(),
                                ),
                                child: Text(context.l10n.confirm),
                              ),
                            ],
                          );
                          if (name != null && name.isNotEmpty) {
                            await chatNotifier.createSession(name);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: sessions.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48.sp,
                              color: context.theme.hintColor.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              isZh ? '暂无对话' : 'No conversations',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: context.theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 20.h),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final isActive = session.id == currentId;
                        
                        // 预计算一些值，减少重复访问 context
                        final primaryColor = context.colorScheme.primary;
                        final hintColor = context.theme.hintColor;
                        final onSurfaceVariant = context.colorScheme.onSurfaceVariant;
                        
                        return Dismissible(
                          key: ValueKey(session.id),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            final isZh = context.isZh;
                            return await showModalBottomSheet<bool>(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => Container(
                                decoration: BoxDecoration(
                                  color: context.isDark
                                      ? context.colorScheme.surfaceContainerLow
                                      : Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.r),
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  24.h,
                                  20.w,
                                  MediaQuery.of(ctx).padding.bottom + 20.h,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isZh ? '删除对话' : 'Delete Conversation',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      isZh 
                                        ? '确定要删除对话 "${session.name}" 吗？此操作不可撤销。'
                                        : 'Are you sure you want to delete conversation "${session.name}"? This action cannot be undone.',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: context.theme.hintColor,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => Navigator.pop(ctx, false),
                                            style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(vertical: 12.h),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            child: Text(context.l10n.cancel),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: FilledButton(
                                            onPressed: () => Navigator.pop(ctx, true),
                                            style: FilledButton.styleFrom(
                                              padding: EdgeInsets.symmetric(vertical: 12.h),
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            child: Text(
                                              context.l10n.confirm,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          onDismissed: (direction) async {
                            await chatNotifier.deleteSession(session.id);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                onSessionSelected(session.id);
                              },
                              onLongPress: () {
                                _showSessionMenu(context, ref, session.id, session.name);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 13.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? primaryColor.withValues(alpha: 0.1)
                                      : chatSurface,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isActive
                                          ? Icons.chat_bubble_rounded
                                          : Icons.chat_bubble_outline_rounded,
                                      size: 18.sp,
                                      color: isActive
                                          ? primaryColor
                                          : hintColor,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            session.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: isActive
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              color: isActive
                                                  ? primaryColor
                                                  : null,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            _formatTime(session.updatedAt, context.isZh),
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: isActive
                                                  ? primaryColor.withValues(alpha: 0.72)
                                                  : onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time, bool isZh) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return isZh ? '刚刚' : 'Just now';
    } else if (diff.inHours < 1) {
      return isZh ? '${diff.inMinutes} 分钟前' : '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return isZh ? '${diff.inHours} 小时前' : '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return isZh ? '${diff.inDays} 天前' : '${diff.inDays}d ago';
    } else {
      return DateFormat(isZh ? 'MM月dd日' : 'MMM dd').format(time);
    }
  }

  void _showSessionMenu(BuildContext context, WidgetRef ref, String conversationId, String sessionName) {
    final isZh = context.isZh;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.file_download_outlined),
              title: Text(isZh ? '导出为 Markdown' : 'Export as Markdown'),
              onTap: () {
                Navigator.pop(context);
                _exportSession(context, ref, conversationId, sessionName, isMarkdown: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(isZh ? '导出为 JSON' : 'Export as JSON'),
              onTap: () {
                Navigator.pop(context);
                _exportSession(context, ref, conversationId, sessionName, isMarkdown: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportSession(
    BuildContext context,
    WidgetRef ref,
    String conversationId,
    String sessionName,
    {required bool isMarkdown}
  ) async {
    final isZh = context.isZh;
    final exportService = ref.read(aiConversationExportServiceProvider);
    
    try {
      // 生成导出内容
      SmartDialog.showLoading(msg: isZh ? '正在生成导出内容...' : 'Generating export...');
      
      final content = isMarkdown
          ? await exportService.exportToMarkdown(conversationId: conversationId)
          : await exportService.exportToJson(conversationId: conversationId);
      
      SmartDialog.dismiss();
      
      // 显示操作选项
      final action = await showModalBottomSheet<String>(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  isZh ? '选择导出方式' : 'Choose export method',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: Text(isZh ? '复制到剪贴板' : 'Copy to clipboard'),
                onTap: () => Navigator.pop(context, 'copy'),
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: Text(isZh ? '分享' : 'Share'),
                onTap: () => Navigator.pop(context, 'share'),
              ),
              ListTile(
                leading: const Icon(Icons.save),
                title: Text(isZh ? '保存到文件' : 'Save to file'),
                onTap: () => Navigator.pop(context, 'save'),
              ),
            ],
          ),
        ),
      );
      
      if (action == null) return;
      
      switch (action) {
        case 'copy':
          await Clipboard.setData(ClipboardData(text: content));
          SmartDialog.showToast(isZh ? '已复制到剪贴板' : 'Copied to clipboard');
          break;
          
        case 'share':
          final ext = isMarkdown ? 'md' : 'json';
          final fileName = '${sessionName}_${DateTime.now().millisecondsSinceEpoch}.$ext';
          await Share.share(content, subject: fileName);
          break;
          
        case 'save':
          final ext = isMarkdown ? 'md' : 'json';
          final suggestedName = '${sessionName}_${DateTime.now().millisecondsSinceEpoch}.$ext'
              .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
              .replaceAll(RegExp(r'\s+'), '_');
          
          final file = await exportService.saveExportWithPicker(
            content: content,
            suggestedFileName: suggestedName,
          );
          
          if (file != null && context.mounted) {
            SmartDialog.showToast(isZh ? '已保存到 ${file.path}' : 'Saved to ${file.path}');
          }
          break;
      }
    } catch (e) {
      SmartDialog.dismiss();
      if (context.mounted) {
        SmartDialog.showToast('${isZh ? '导出失败' : 'Export failed'}: $e');
      }
    }
  }
}

class _DrawerActionButton extends StatelessWidget {
  const _DrawerActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? context.colorScheme.primary;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(7.w),
          child: Icon(icon, size: 19.sp, color: foreground),
        ),
      ),
    );
  }
}
