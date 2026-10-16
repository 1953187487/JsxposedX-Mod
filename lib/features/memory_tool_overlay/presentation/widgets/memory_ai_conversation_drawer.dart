import 'dart:typed_data';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_session_view.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/ai_overlay_assistant_glyph.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 悬浮窗 AI 面板的对话列表抽屉。
///
/// 对齐 AI 逆向界面的 [AiConversationDrawer]：头部是目标进程信息 + 「对话列表」
/// 标题 + 动作按钮，列表项展示名称与相对时间，选中项高亮，左滑删除、长按更多。
/// 悬浮窗是独立引擎，宿主抽屉里的 `showModalBottomSheet` / `SmartDialog` /
/// `Share.share` 都不可用，因此这里只保留纯 Flutter 实现，删除确认与导出都
/// 交由外部用悬浮窗自有的方式承载。
class MemoryAiConversationDrawer extends StatelessWidget {
  const MemoryAiConversationDrawer({
    super.key,
    required this.processName,
    required this.packageName,
    required this.pid,
    required this.sessions,
    required this.currentSessionId,
    required this.onCreateSession,
    required this.onSessionSelected,
    required this.onRequestDelete,
    required this.onRequestExport,
    this.appIcon,
    this.isBuiltinConfig = false,
    this.onOpenQuickSettings,
    this.onClose,
  });

  final String processName;
  final String packageName;
  final int pid;
  final List<AiChatSessionView> sessions;
  final String? currentSessionId;
  final VoidCallback onCreateSession;
  final void Function(String sessionId) onSessionSelected;
  final void Function(AiChatSessionView session) onRequestDelete;

  /// 导出会话。`isMarkdown` 为 true 导出 Markdown，否则导出 JSON。
  final void Function(AiChatSessionView session, bool isMarkdown) onRequestExport;

  /// 目标进程图标（可能为空）。
  final Uint8List? appIcon;

  /// 当前是否使用内建配置，用于头部标记。
  final bool isBuiltinConfig;

  /// 打开快捷设置（模型 / 能力 / 模式）。为空时不显示入口。
  final VoidCallback? onOpenQuickSettings;

  /// 关闭抽屉。抽屉是嵌在悬浮窗面板内的普通容器，不能靠路由返回关闭。
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final scheme = context.colorScheme;
    // 抽屉背景取比面板更浅的白色调，保证文字对比度满足可读性要求。
    final isLight = scheme.brightness == Brightness.light;
    final surface = isLight
        ? Color.alphaBlend(
            Colors.white.withValues(alpha: 0.72),
            scheme.surfaceContainerHighest,
          )
        : scheme.surfaceContainerHigh;
    final outline = scheme.outlineVariant.withValues(alpha: 0.34);
    // 正文/次要文字统一提高到满足 WCAG AA 的对比度。
    final textPrimary = scheme.onSurface;
    final textSecondary = scheme.onSurfaceVariant.withValues(alpha: 0.92);

    return SizedBox(
      width: 290 * scale,
      child: Material(
        color: surface,
        child: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: outline)),
          ),
          child: SafeArea(
            right: false,
            child: Column(
              children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                16 * scale,
                14 * scale,
                10 * scale,
                10 * scale,
              ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: outline)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ProcessIcon(
                        icon: appIcon,
                        extent: 34 * scale,
                        borderRadius: 9 * scale,
                      ),
                      SizedBox(width: 10 * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              processName.trim().isEmpty
                                  ? packageName
                                  : processName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            SizedBox(height: 1 * scale),
                            Text(
                              '$packageName · PID $pid',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10 * scale,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isBuiltinConfig)
                    Padding(
                      padding: EdgeInsets.only(top: 6 * scale),
                      child: Text(
                        context.l10n.aiBuiltinConfigName,
                        style: TextStyle(
                          fontSize: 10 * scale,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(height: 12 * scale),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.isZh ? '对话列表' : 'Conversations',
                          style: TextStyle(
                            fontSize: 13 * scale,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      if (onOpenQuickSettings != null) ...[
                        _DrawerActionButton(
                          icon: Icons.settings_rounded,
                          tooltip: context.isZh ? '快捷设置' : 'Quick Settings',
                          color: context.colorScheme.secondary,
                          onTap: onOpenQuickSettings!,
                          scale: scale,
                        ),
                        SizedBox(width: 2 * scale),
                      ],
                      _DrawerActionButton(
                        icon: Icons.add_comment_rounded,
                        tooltip: context.l10n.aiNewSession,
                        onTap: onCreateSession,
                        scale: scale,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: sessions.isEmpty
                  ? _EmptyState(scale: scale)
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        10 * scale,
                        10 * scale,
                        10 * scale,
                        16 * scale,
                      ),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return Dismissible(
                          key: ValueKey('dismiss_${session.id}'),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: 18 * scale,
                            ),
                            margin: EdgeInsets.only(bottom: 5 * scale),
                            decoration: BoxDecoration(
                              color: scheme.error.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(11 * scale),
                            ),
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: scheme.onError,
                              size: 20 * scale,
                            ),
                          ),
                          confirmDismiss: (_) async {
                            onRequestDelete(session);
                            return false;
                          },
                          child: _SessionTile(
                            key: ValueKey(session.id),
                            session: session,
                            isActive: session.id == currentSessionId,
                            scale: scale,
                            onTap: () => onSessionSelected(session.id),
                            onDelete: () => onRequestDelete(session),
                            onExportMarkdown: () =>
                                onRequestExport(session, true),
                            onExportJson: () => onRequestExport(session, false),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}

class _SessionTile extends StatefulWidget {
  const _SessionTile({
    super.key,
    required this.session,
    required this.isActive,
    required this.scale,
    required this.onTap,
    required this.onDelete,
    required this.onExportMarkdown,
    required this.onExportJson,
  });

  final AiChatSessionView session;
  final bool isActive;
  final double scale;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onExportMarkdown;
  final VoidCallback onExportJson;

  @override
  State<_SessionTile> createState() => _SessionTileState();
}

class _SessionTileState extends State<_SessionTile> {
  /// 长按弹出菜单时的锚点，取最近一次按下的全局坐标。
  Offset? _lastTouchPosition;

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final isActive = widget.isActive;
    final scale = widget.scale;
    final primary = context.colorScheme.primary;
    // 次要文字提升对比度，确保在浅色抽屉背景上仍清晰可辨。
    final hint = context.colorScheme.onSurfaceVariant.withValues(alpha: 0.92);
    final surface = context.colorScheme.surface;

    return Padding(
      padding: EdgeInsets.only(bottom: 5 * scale),
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (details) => _lastTouchPosition = details.globalPosition,
        onLongPress: () =>
            _showSessionMenu(context, _lastTouchPosition ?? Offset.zero),
        borderRadius: BorderRadius.circular(11 * scale),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12 * scale,
            vertical: 11 * scale,
          ),
          decoration: BoxDecoration(
            color: isActive ? primary.withValues(alpha: 0.1) : surface,
            borderRadius: BorderRadius.circular(11 * scale),
            border: Border.all(
              color: isActive
                  ? primary.withValues(alpha: 0.28)
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isActive
                    ? Icons.chat_bubble_rounded
                    : Icons.chat_bubble_outline_rounded,
                size: 16 * scale,
                color: isActive ? primary : hint,
              ),
              SizedBox(width: 10 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13 * scale,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isActive
                            ? primary
                            : context.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2 * scale),
                    Text(
                      _formatTime(session.updatedAt, context.isZh),
                      style: TextStyle(
                        fontSize: 10 * scale,
                        color: isActive
                            ? primary.withValues(alpha: 0.72)
                            : hint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSessionMenu(BuildContext context, Offset globalPosition) {
    showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        globalPosition.dx,
        globalPosition.dy,
      ),
      items: [
        PopupMenuItem<void>(
          onTap: widget.onExportMarkdown,
          child: Row(
            children: [
              Icon(
                Icons.file_download_outlined,
                size: 18,
                color: context.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 8 * widget.scale),
              Text(context.isZh ? '导出为 Markdown' : 'Export as Markdown'),
            ],
          ),
        ),
        PopupMenuItem<void>(
          onTap: widget.onExportJson,
          child: Row(
            children: [
              Icon(
                Icons.code,
                size: 18,
                color: context.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 8 * widget.scale),
              Text(context.isZh ? '导出为 JSON' : 'Export as JSON'),
            ],
          ),
        ),
        PopupMenuItem<void>(
          onTap: widget.onDelete,
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: context.colorScheme.error,
              ),
              SizedBox(width: 8 * widget.scale),
              Text(
                context.l10n.delete,
                style: TextStyle(color: context.colorScheme.error),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 40 * scale,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          SizedBox(height: 10 * scale),
          Text(
            context.isZh ? '暂无对话' : 'No conversations',
            style: TextStyle(
              fontSize: 12 * scale,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessIcon extends StatelessWidget {
  const _ProcessIcon({
    required this.icon,
    required this.extent,
    required this.borderRadius,
  });

  final Uint8List? icon;
  final double extent;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (icon == null || icon!.isEmpty) {
      return SizedBox(
        width: extent,
        height: extent,
        child: AiOverlayAssistantGlyph(size: extent),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.memory(
        icon!,
        width: extent,
        height: extent,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      ),
    );
  }
}

class _DrawerActionButton extends StatelessWidget {
  const _DrawerActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.scale,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double scale;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9 * scale),
        child: Padding(
          padding: EdgeInsets.all(6 * scale),
          child: Icon(
            icon,
            size: 17 * scale,
            color: color ?? context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

String _formatTime(DateTime time, bool isZh) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) {
    return isZh ? '刚刚' : 'Just now';
  } else if (diff.inHours < 1) {
    return isZh ? '${diff.inMinutes} 分钟前' : '${diff.inMinutes}m ago';
  } else if (diff.inDays < 1) {
    return isZh ? '${diff.inHours} 小时前' : '${diff.inHours}h ago';
  } else if (diff.inDays < 7) {
    return isZh ? '${diff.inDays} 天前' : '${diff.inDays}d ago';
  }
  return DateFormat(isZh ? 'MM月dd日' : 'MMM dd').format(time);
}
