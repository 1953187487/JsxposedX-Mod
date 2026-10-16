import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_tool_invocation_view.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/clickable_path_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ToolResultCard extends HookWidget {
  final String content;
  final AiToolInvocationView? invocation;
  final VoidCallback? onRetry;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ToolResultCard({
    super.key,
    required this.content,
    this.invocation,
    this.onRetry,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final structured = invocation;
    if (structured != null) {
      return _StructuredToolInvocationCard(
        invocation: structured,
        onRetry: onRetry,
        onApprove: onApprove,
        onReject: onReject,
      );
    }
    return _LegacyToolResultCard(content: content);
  }
}

class _LegacyToolResultCard extends HookWidget {
  const _LegacyToolResultCard({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final expanded = useState(false);
    final isSuccess = content.startsWith('✅');
    final lines = content.split('\n');
    final summary = lines.first;
    final detail = lines.length > 1 ? lines.skip(1).join('\n').trim() : '';
    final color = isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final bgColor = isSuccess
        ? (context.isDark ? const Color(0xFF1B2E1B) : const Color(0xFFF1F8F1))
        : (context.isDark ? const Color(0xFF2E1B1B) : const Color(0xFFFFF1F1));

    return Container(
      margin: EdgeInsets.only(bottom: 20 * scale),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: detail.isNotEmpty
                ? () => expanded.value = !expanded.value
                : null,
            borderRadius: BorderRadius.circular(12 * scale),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: 10 * scale,
              ),
              child: Row(
                children: [
                  Icon(
                    isSuccess
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: color,
                    size: 16 * scale,
                  ),
                  SizedBox(width: 8 * scale),
                  Expanded(
                    child: Text(
                      summary,
                      style: TextStyle(
                        fontSize: 12.5 * scale,
                        color: color,
                        fontFamily: 'monospace',
                      ),
                      maxLines: expanded.value ? null : 2,
                      overflow: expanded.value ? null : TextOverflow.ellipsis,
                    ),
                  ),
                  if (detail.isNotEmpty) ...[
                    SizedBox(width: 4 * scale),
                    Icon(
                      expanded.value ? Icons.expand_less : Icons.expand_more,
                      size: 16 * scale,
                      color: color.withValues(alpha: 0.7),
                    ),
                  ],
                  IconButton(
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: content)),
                    tooltip: context.isZh ? '复制结果' : 'Copy result',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 16 * scale,
                      color: color.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded.value && detail.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                12 * scale,
                0,
                12 * scale,
                10 * scale,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: color.withValues(alpha: 0.15)),
                ),
              ),
              child: ClickablePathText(
                text: detail,
                style: TextStyle(
                  fontSize: 11.5 * scale,
                  color: context.isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.black54,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StructuredToolInvocationCard extends HookWidget {
  const _StructuredToolInvocationCard({
    required this.invocation,
    required this.onRetry,
    this.onApprove,
    this.onReject,
  });

  final AiToolInvocationView invocation;
  final VoidCallback? onRetry;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final argumentsExpanded = useState(false);
    final resultExpanded = useState(false);
    final color = _statusColor(invocation.status);
    final bgColor = _statusBackgroundColor(context, invocation.status);
    final result = invocation.resultContent?.trim() ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 20 * scale),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(12 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _StatusIcon(status: invocation.status, color: color),
                SizedBox(width: 8 * scale),
                Expanded(
                  child: Text(
                    '${_statusText(context, invocation.status)} · ${invocation.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5 * scale,
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6 * scale),
            Wrap(
              spacing: 8 * scale,
              runSpacing: 4 * scale,
              children: [
                _MetaChip(label: 'call_id', value: invocation.callId),
                if (invocation.duration case final duration?)
                  _MetaChip(
                    label: context.isZh ? '耗时' : 'duration',
                    value: _formatDuration(duration),
                  ),
              ],
            ),
            if (invocation.hasArguments) ...[
              SizedBox(height: 8 * scale),
              _ExpandableToolSection(
                title: context.isZh ? '参数 JSON' : 'Arguments JSON',
                text: invocation.argumentsJson.trim(),
                expanded: argumentsExpanded.value,
                onToggle: () =>
                    argumentsExpanded.value = !argumentsExpanded.value,
              ),
            ],
            if (result.isNotEmpty) ...[
              SizedBox(height: 8 * scale),
              _ExpandableToolSection(
                title: context.isZh ? '工具结果' : 'Tool result',
                text: result,
                expanded: resultExpanded.value,
                onToggle: () => resultExpanded.value = !resultExpanded.value,
              ),
            ],
            if (invocation.status == AiToolInvocationViewStatus.awaitingApproval) ...[
              SizedBox(height: 12 * scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: onReject,
                    icon: Icon(Icons.close_rounded, size: 16 * scale),
                    label: Text(context.isZh ? '拒绝' : 'Reject'),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      textStyle: TextStyle(fontSize: 12 * scale),
                      foregroundColor: const Color(0xFFF44336),
                      side: const BorderSide(color: Color(0xFFF44336)),
                    ),
                  ),
                  SizedBox(width: 10 * scale),
                  FilledButton.icon(
                    onPressed: onApprove,
                    icon: Icon(Icons.check_rounded, size: 16 * scale),
                    label: Text(context.isZh ? '同意执行' : 'Approve'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      textStyle: TextStyle(fontSize: 12 * scale),
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
            if (invocation.status == AiToolInvocationViewStatus.failed &&
                onRetry != null) ...[
              SizedBox(height: 10 * scale),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh_rounded, size: 16 * scale),
                  label: Text(context.isZh ? '重试工具' : 'Retry tool'),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    textStyle: TextStyle(fontSize: 12 * scale),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Color _statusColor(AiToolInvocationViewStatus status) {
    return switch (status) {
      AiToolInvocationViewStatus.preparing => const Color(0xFF7E57C2),
      AiToolInvocationViewStatus.running => const Color(0xFF1976D2),
      AiToolInvocationViewStatus.succeeded => const Color(0xFF4CAF50),
      AiToolInvocationViewStatus.failed => const Color(0xFFF44336),
      AiToolInvocationViewStatus.awaitingApproval => const Color(0xFFFF9800),
    };
  }

  static Color _statusBackgroundColor(
    BuildContext context,
    AiToolInvocationViewStatus status,
  ) {
    final color = _statusColor(status);
    return context.isDark
        ? color.withValues(alpha: 0.16)
        : color.withValues(alpha: 0.08);
  }

  static String _statusText(
    BuildContext context,
    AiToolInvocationViewStatus status,
  ) {
    return switch (status) {
      AiToolInvocationViewStatus.preparing =>
        context.isZh ? '准备参数' : 'Preparing',
      AiToolInvocationViewStatus.running => context.isZh ? '执行中' : 'Running',
      AiToolInvocationViewStatus.succeeded =>
        context.isZh ? '执行成功' : 'Succeeded',
      AiToolInvocationViewStatus.failed => context.isZh ? '执行失败' : 'Failed',
      AiToolInvocationViewStatus.awaitingApproval =>
        context.isZh ? '等待审批' : 'Awaiting Approval',
    };
  }

  static String _formatDuration(Duration duration) {
    if (duration.inMilliseconds < 1000) {
      return '${duration.inMilliseconds} ms';
    }
    final seconds = duration.inMilliseconds / 1000;
    return '${seconds.toStringAsFixed(seconds >= 10 ? 0 : 1)} s';
  }
}

class _StatusIcon extends HookWidget {
  const _StatusIcon({required this.status, required this.color});

  final AiToolInvocationViewStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    if (status == AiToolInvocationViewStatus.running ||
        status == AiToolInvocationViewStatus.preparing) {
      final controller = useAnimationController(
        duration: const Duration(milliseconds: 1200),
      )..repeat();
      return RotationTransition(
        turns: controller,
        child: Icon(Icons.settings_outlined, color: color, size: 16 * scale),
      );
    }
    if (status == AiToolInvocationViewStatus.awaitingApproval) {
      return Icon(Icons.help_outline_rounded, color: color, size: 16 * scale);
    }
    return Icon(
      status == AiToolInvocationViewStatus.succeeded
          ? Icons.check_circle_outline
          : Icons.error_outline,
      color: color,
      size: 16 * scale,
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 3 * scale),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withValues(alpha: 0.64),
        borderRadius: BorderRadius.circular(999 * scale),
        border: Border.all(
          color: context.theme.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 10.5 * scale,
          color: context.textTheme.bodySmall?.color,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _ExpandableToolSection extends StatelessWidget {
  const _ExpandableToolSection({
    required this.title,
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  final String title;
  final String text;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    return Container(
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.black.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8 * scale),
        border: Border.all(
          color: context.theme.dividerColor.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8 * scale),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10 * scale,
                vertical: 7 * scale,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 11.5 * scale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: text));
                      if (context.mounted) {
                        ToastMessage.show(context.isZh ? '已复制' : 'Copied');
                      }
                    },
                    tooltip: context.isZh ? '复制' : 'Copy',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 28 * scale,
                      minHeight: 28 * scale,
                    ),
                    icon: Icon(Icons.copy_rounded, size: 15 * scale),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 16 * scale,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                10 * scale,
                0,
                10 * scale,
                9 * scale,
              ),
              child: ClickablePathText(
                text: text,
                style: TextStyle(
                  fontSize: 11.5 * scale,
                  height: 1.45,
                  fontFamily: 'monospace',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
