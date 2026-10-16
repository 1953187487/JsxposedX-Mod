import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/widgets/code_save_action.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/widgets/code_run_action.dart';

abstract class BaseBubbleToolbarPart {
  const BaseBubbleToolbarPart();

  /// 是否支持系统分享。悬浮窗为独立引擎，share_plus 需要宿主 Activity，
  /// 子类可覆写为 false 以隐藏「系统分享」入口。
  @protected
  bool get supportsSystemShare => true;

  /// 统一的弹层宿主。宿主 App 走底部弹窗，悬浮窗子类可覆写为
  /// [OverlayPanelDialog] 等悬浮窗内的安全实现。
  @protected
  Future<void> presentSheet({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return AppBottomSheet.show<void>(
      context: context,
      title: title,
      child: child,
    );
  }

  void handleCopyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ToastMessage.show(context.l10n.codeCopied);
  }

  Future<void> showTextActionsSheet(
    BuildContext context, {
    required String title,
    required String text,
    VoidCallback? onRetry,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onRegenerate,
    VoidCallback? onQuote,
    String? rawDetails,
  }) async {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return;
    }

    await presentSheet(
      context: context,
      title: context.l10n.aiBubbleActionsTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BubbleActionTile(
            icon: Icons.copy_all_rounded,
            title: context.l10n.aiBubbleCopyCurrent,
            onTap: () {
              Navigator.of(context).pop();
              handleCopyToClipboard(context, normalized);
            },
          ),
          if (supportsSystemShare)
            BubbleActionTile(
              icon: Icons.share_rounded,
              title: context.isZh ? '系统分享' : 'Share',
              onTap: () async {
                Navigator.of(context).pop();
                await Share.share(normalized, subject: title);
              },
            ),
          if (onRetry != null)
            BubbleActionTile(
              icon: Icons.refresh_rounded,
              title: context.l10n.retry,
              onTap: () {
                Navigator.of(context).pop();
                onRetry();
              },
            ),
          if (onEdit != null)
            BubbleActionTile(
              icon: Icons.edit_rounded,
              title: context.isZh ? '编辑并重新发送' : 'Edit and resend',
              onTap: () {
                Navigator.of(context).pop();
                onEdit();
              },
            ),
          if (onQuote != null)
            BubbleActionTile(
              icon: Icons.format_quote_rounded,
              title: context.isZh ? '引用回复' : 'Quote reply',
              onTap: () {
                Navigator.of(context).pop();
                onQuote();
              },
            ),
          if (onRegenerate != null)
            BubbleActionTile(
              icon: Icons.replay_rounded,
              title: context.isZh ? '从此处重新生成' : 'Regenerate from here',
              onTap: () {
                Navigator.of(context).pop();
                onRegenerate();
              },
            ),
      if (rawDetails != null && rawDetails.trim().isNotEmpty)
            BubbleActionTile(
              icon: Icons.receipt_long_rounded,
              title: context.isZh ? '查看原始响应 (Trace)' : 'View raw response (Trace)',
              onTap: () {
                Navigator.of(context).pop();
                showRawResponseSheet(
                  context,
                  title: context.isZh ? '原始响应' : 'Raw response',
                  text: rawDetails,
                );
              },
            ),
          BubbleActionTile(
            icon: Icons.text_fields_rounded,
            title: context.l10n.aiBubbleSelectText,
            onTap: () {
              Navigator.of(context).pop();
              showTextSelectionSheet(context, title: title, text: normalized);
            },
          ),
          if (onDelete != null)
            BubbleActionTile(
              icon: Icons.delete_outline_rounded,
              title: context.isZh ? '删除消息' : 'Delete message',
              onTap: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
        ],
      ),
    );
  }

  Future<void> showTextSelectionSheet(
    BuildContext context, {
    required String title,
    required String text,
  }) async {
    final scale = AiChatCompactScope.scaleOf(context);
    await presentSheet(
      context: context,
      title: title,
      child: SingleChildScrollView(
        child: SelectableText(
          text,
          style: TextStyle(fontSize: 14 * scale, height: 1.5),
        ),
      ),
    );
  }

  Future<void> showRawResponseSheet(
    BuildContext context, {
    required String title,
    required String text,
  }) async {
    final scale = AiChatCompactScope.scaleOf(context);
    await presentSheet(
      context: context,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => handleCopyToClipboard(context, text),
              icon: const Icon(Icons.copy_rounded),
              label: Text(context.isZh ? '复制全部' : 'Copy all'),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: SingleChildScrollView(
              child: SelectableText(
                text,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12 * scale,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildCodeActions({
    required BubbleState state,
    required String language,
    required String code,
    String? scriptType,
    String? suggestedFileName,
  }) {
    return const [];
  }
}

class DefaultBubbleToolbarPart extends BaseBubbleToolbarPart {
  const DefaultBubbleToolbarPart();

  @override
  List<Widget> buildCodeActions({
    required BubbleState state,
    required String language,
    required String code,
    String? scriptType,
    String? suggestedFileName,
  }) {
    return [
      CodeRunAction(
        code: code,
        packageName: state.packageName,
        scriptType: scriptType,
        suggestedFileName: suggestedFileName,
      ),
      CodeSaveAction(
        code: code,
        packageName: state.packageName,
        language: language,
        scriptType: scriptType,
        suggestedFileName: suggestedFileName,
      ),
      const SizedBox(width: 4),
    ];
  }
}

class BubbleActionTile extends StatelessWidget {
  const BubbleActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20 * scale),
      title: Text(title, style: TextStyle(fontSize: 14 * scale)),
      onTap: onTap,
    );
  }
}
