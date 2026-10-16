import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'dart:developer' as developer;
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/file_picker_util.dart';
import 'package:JsxposedX/core/themes/app_colors.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_session_init_state.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_runtime_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_quick_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final aiChatPendingAttachmentsProvider =
    StateProvider.family<List<PickedFileData>, String>(
      (ref, packageName) => const [],
    );

/// 自定义弹层宿主签名。悬浮窗是独立引擎，`AppBottomSheet` 无法正确呈现，
/// 由悬浮窗侧注入基于 [OverlayPanelDialog] 的实现。
typedef AiChatInputSheetPresenter =
    Future<void> Function({
      required BuildContext context,
      required String title,
      required Widget child,
    });

class AiChatInput extends HookConsumerWidget {
  final String packageName;
  final String? systemPrompt;
  final bool useOverlayFilePicker;
  final bool showQuickActions;
  final bool isEmbedded;
  final bool isCompact;
  final Future<void> Function()? onRetryInitialization;
  final VoidCallback? onOpenAnalysis;
  final String Function(String rawText)? composeOutgoingText;
  final bool hasComposedContent;
  final VoidCallback? onSendCommitted;
  final Widget? inputTopContent;

  /// 追加在快捷操作行末端的自定义控件（例如计划模式开关）。
  final Widget? quickActionsTrailing;

  /// 自定义弹层宿主，留空时回退到 [AppBottomSheet]。
  final AiChatInputSheetPresenter? presentSheet;

  const AiChatInput({
    super.key,
    required this.packageName,
    this.systemPrompt,
    this.useOverlayFilePicker = false,
    this.showQuickActions = true,
    this.isEmbedded = false,
    this.isCompact = false,
    this.onRetryInitialization,
    this.onOpenAnalysis,
    this.composeOutgoingText,
    this.hasComposedContent = false,
    this.onSendCommitted,
    this.inputTopContent,
    this.quickActionsTrailing,
    this.presentSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scopeCompact = AiChatCompactScope.of(context);
    final scopeScale = AiChatCompactScope.scaleOf(context);
    final effectiveCompact = isCompact || scopeCompact;
    final textController = useTextEditingController();
    final pendingAttachments = ref.watch(
      aiChatPendingAttachmentsProvider(packageName),
    );
    final pendingAttachmentsNotifier = ref.read(
      aiChatPendingAttachmentsProvider(packageName).notifier,
    );
    final chatState = ref.watch(
      aiChatRuntimeProvider(packageName: packageName),
    );

    final textValue = useValueListenable(textController);
    final hasContent = textValue.text.trim().isNotEmpty;
    final hasAttachments = pendingAttachments.isNotEmpty;
    final isStreaming = chatState.isStreaming;
    final canSend =
        (hasContent || hasAttachments || hasComposedContent) &&
        chatState.canSend;
    final hasContextDetails =
        chatState.hasUserMessages ||
        chatState.sessionContext.hasStructuredMemory;
    final canRetryLastTurn =
        !hasContent && !hasAttachments && chatState.canRetryLastTurn;
    final canRetryInitialization =
        !hasContent &&
        !hasAttachments &&
        chatState.sessionInitState == AiSessionInitState.failed &&
        onRetryInitialization != null;
    final actionIcon = isStreaming
        ? Icons.stop_rounded
        : canSend
        ? Icons.arrow_upward_rounded
        : canRetryLastTurn
        ? Icons.refresh_rounded
        : canRetryInitialization
        ? Icons.replay_rounded
        : Icons.arrow_upward_rounded;
    final actionColor =
        isStreaming || canSend || canRetryLastTurn || canRetryInitialization
        ? context.colorScheme.primary
        : context.theme.disabledColor;
    final hintText = switch (chatState.sessionInitState) {
      AiSessionInitState.initializing =>
        context.l10n.aiReverseSessionInitializingHint,
      AiSessionInitState.failed => context.l10n.aiReverseSessionInitFailedHint,
      AiSessionInitState.ready => context.l10n.aiChatInputHint,
    };
    final actionLabel = isStreaming
        ? context.l10n.aiStopGeneration
        : canSend
        ? context.l10n.sendToAi
        : canRetryLastTurn
        ? (chatState.canResumeToolPhase
              ? context.l10n.aiResumeToolPhase
              : chatState.canContinueGeneration
              ? context.l10n.aiContinue
              : context.l10n.aiRetryLastTurn)
        : canRetryInitialization
        ? context.l10n.aiRetryInitialization
        : context.l10n.aiUnavailableToSend;
    final menuButtonSize = (effectiveCompact ? 30 : 36) * scopeScale;
    final menuIconSize = (effectiveCompact ? 17 : 20) * scopeScale;
    final horizontalGap = isEmbedded
        ? ((effectiveCompact ? 6 : 10) * scopeScale)
        : ((effectiveCompact ? 10 : 14) * scopeScale);
    final inputVerticalPadding = (effectiveCompact ? 6 : 10) * scopeScale;
    final inputFontSize = (effectiveCompact ? 13 : 15) * scopeScale;
    final actionButtonSize = (effectiveCompact ? 36 : 44) * scopeScale;
    final actionIconSize = (effectiveCompact ? 18 : 22) * scopeScale;
    final sendButtonMargin = (effectiveCompact ? 6 : 8) * scopeScale;
    final maxInputLines = effectiveCompact ? 3 : 5;
    final popupMenuColor = (useOverlayFilePicker || isEmbedded)
        ? context.colorScheme.surface
        : context.theme.cardColor;

    Future<void> handleSend() async {
      final notifier = ref.read(
        aiChatRuntimeProvider(packageName: packageName).notifier,
      );
      if (isStreaming) {
        await notifier.stopStreaming();
        return;
      }
      if (canSend) {
        try {
          final outgoingText =
              composeOutgoingText?.call(textController.text.trim()) ??
              textController.text.trim();
          final message = AiMultimodalMessageCodec.encodeFromPickedFiles(
            text: outgoingText,
            attachments: pendingAttachments,
          );

          textController.clear();
          pendingAttachmentsNotifier.state = const [];
          onSendCommitted?.call();

          notifier.send(message); // Fire and forget
        } catch (error, stackTrace) {
          developer.log(
            'Failed to encode pending attachments before send.',
            name: 'AiChatInput',
            error: error,
            stackTrace: stackTrace,
          );
          if (!context.mounted) {
            return;
          }
          ToastMessage.show(_formatAttachmentError(error));
        }
        return;
      }
      if (canRetryLastTurn) {
        await notifier.retryLastTurn();
        return;
      }
      if (canRetryInitialization) {
        await onRetryInitialization?.call();
      }
    }

    Future<void> handleMenuAction(_AiInputMenuAction action) async {
      switch (action) {
        case _AiInputMenuAction.previewContext:
          if (!hasContextDetails) {
            return;
          }
          final presenter = presentSheet;
          if (presenter != null) {
            await presenter(
              context: context,
              title: context.l10n.aiContextTitle,
              child: _ContextSheet(chatState: chatState),
            );
          } else {
            AppBottomSheet.show<void>(
              context: context,
              title: context.l10n.aiContextTitle,
              child: _ContextSheet(chatState: chatState),
            );
          }
          break;
        case _AiInputMenuAction.uploadImage:
          try {
            final picked = await FilePickerUtil.pickImage(
              useOverlayProxy: useOverlayFilePicker,
            );
            if (picked == null) {
              developer.log('Image picker returned null.', name: 'AiChatInput');
              return;
            }
            AiMultimodalMessageCodec.encodeFromPickedFiles(
              text: '',
              attachments: [picked],
            );
            pendingAttachmentsNotifier.state = [...pendingAttachments, picked];
            developer.log(
              'Image attachment queued: ${picked.fileName}',
              name: 'AiChatInput',
            );
          } catch (error, stackTrace) {
            developer.log(
              'Failed to pick image attachment.',
              name: 'AiChatInput',
              error: error,
              stackTrace: stackTrace,
            );
            if (!context.mounted) {
              return;
            }
            ToastMessage.show(_formatAttachmentError(error));
          }
          break;
        case _AiInputMenuAction.uploadFile:
          try {
            final picked = await FilePickerUtil.pickFile(
              useOverlayProxy: useOverlayFilePicker,
            );
            if (picked == null) {
              developer.log('File picker returned null.', name: 'AiChatInput');
              return;
            }
            AiMultimodalMessageCodec.encodeFromPickedFiles(
              text: '',
              attachments: [picked],
            );
            pendingAttachmentsNotifier.state = [...pendingAttachments, picked];
            developer.log(
              'File attachment queued: ${picked.fileName}',
              name: 'AiChatInput',
            );
          } catch (error, stackTrace) {
            developer.log(
              'Failed to pick file attachment.',
              name: 'AiChatInput',
              error: error,
              stackTrace: stackTrace,
            );
            if (!context.mounted) {
              return;
            }
            ToastMessage.show(_formatAttachmentError(error));
          }
          break;
      }
    }

    final contextStats = chatState.contextStats;
    final usageRatio = contextStats.usageRatio.clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ContextUsageIndicator(stats: contextStats, usageRatio: usageRatio),
        if (inputTopContent != null) inputTopContent!,
        if (showQuickActions)
          AiQuickActions(
            onOpenAnalysis: onOpenAnalysis,
            trailing: quickActionsTrailing,
          ),
        Container(
          padding: isEmbedded
              ? EdgeInsets.zero
              : EdgeInsets.fromLTRB(
                  16 * scopeScale,
                  4 * scopeScale,
                  16 * scopeScale,
                  20 * scopeScale,
                ),
          decoration: BoxDecoration(
            color: isEmbedded
                ? Colors.transparent
                : (context.isDark
                      ? context.theme.scaffoldBackgroundColor
                      : Colors.transparent),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isEmbedded
                  ? Colors.transparent
                  : (context.isDark
                        ? context.colorScheme.surfaceContainerLow
                        : Colors.white),
              borderRadius: BorderRadius.circular(
                isEmbedded ? 0 : 12 * scopeScale,
              ),
              boxShadow: isEmbedded
                  ? const []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Padding(
              padding: EdgeInsets.all(isEmbedded ? 0 : 4 * scopeScale),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (pendingAttachments.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isEmbedded ? 0 : 8 * scopeScale,
                        isEmbedded ? 0 : 8 * scopeScale,
                        isEmbedded ? 0 : 8 * scopeScale,
                        isEmbedded ? 8 * scopeScale : 2 * scopeScale,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 6 * scopeScale,
                          runSpacing: 6 * scopeScale,
                          children: [
                            for (
                              var index = 0;
                              index < pendingAttachments.length;
                              index++
                            )
                              _PendingAttachmentChip(
                                file: pendingAttachments[index],
                                onRemove: () {
                                  final updated = List<PickedFileData>.from(
                                    pendingAttachments,
                                  )..removeAt(index);
                                  pendingAttachmentsNotifier.state =
                                      List<PickedFileData>.unmodifiable(
                                        updated,
                                      );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    padding: isEmbedded
                        ? EdgeInsets.fromLTRB(0, 0, 0, 2 * scopeScale)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: isEmbedded ? Colors.transparent : null,
                      borderRadius: BorderRadius.circular(12 * scopeScale),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PopupMenuButton<_AiInputMenuAction>(
                          tooltip: context.isZh ? '添加内容' : 'Add content',
                          offset: Offset(0, -180 * scopeScale),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 220 * scopeScale,
                            maxWidth:
                                MediaQuery.sizeOf(context).width -
                                (32 * scopeScale),
                          ),
                          color: popupMenuColor,
                          surfaceTintColor: Colors.transparent,
                          elevation: 8,
                          shadowColor: context.colorScheme.shadow.withValues(
                            alpha: 0.22,
                          ),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              14 * scopeScale,
                            ),
                            side: BorderSide(
                              color: context.colorScheme.outlineVariant
                                  .withValues(
                                    alpha: context.isDark ? 0.65 : 0.5,
                                  ),
                            ),
                          ),
                          onSelected: handleMenuAction,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: _AiInputMenuAction.previewContext,
                              enabled: hasContextDetails,
                              child: _AiInputMenuItem(
                                icon: Icons.subject_rounded,
                                title: context.isZh
                                    ? '查看对话上下文'
                                    : 'View conversation context',
                                subtitle: context.isZh
                                    ? '预览自动压缩后的对话上下文'
                                    : 'Preview the current compressed context',
                              ),
                            ),
                            PopupMenuItem(
                              value: _AiInputMenuAction.uploadImage,
                              child: _AiInputMenuItem(
                                icon: Icons.add_photo_alternate_outlined,
                                title: context.isZh ? '添加图片' : 'Add image',
                                subtitle: context.isZh
                                    ? '添加图片到待发送附件'
                                    : 'Add an image as a pending attachment',
                              ),
                            ),
                            PopupMenuItem(
                              value: _AiInputMenuAction.uploadFile,
                              child: _AiInputMenuItem(
                                icon: Icons.note_add_outlined,
                                title: context.isZh ? '添加文件' : 'Add file',
                                subtitle: context.isZh
                                    ? '添加文件到待发送附件'
                                    : 'Add a file as a pending attachment',
                              ),
                            ),
                          ],
                          child: Container(
                            width: menuButtonSize,
                            height: menuButtonSize,
                            margin: EdgeInsets.only(
                              left: isEmbedded ? 0 : 6 * scopeScale,
                            ),
                            decoration: BoxDecoration(
                              color: context.isDark
                                  ? context.colorScheme.surfaceContainerLow
                                  : context.colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                10 * scopeScale,
                              ),
                              border: Border.all(
                                color: context.colorScheme.outlineVariant
                                    .withValues(
                                      alpha: context.isDark ? 0.55 : 0.8,
                                    ),
                              ),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              size: menuIconSize,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        SizedBox(width: horizontalGap),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: inputVerticalPadding,
                            ),
                            child: TextField(
                              controller: textController,
                              enabled:
                                  chatState.sessionInitState ==
                                  AiSessionInitState.ready,
                              onSubmitted: (_) async {
                                if (!canSend) {
                                  return;
                                }
                                await handleSend();
                              },
                              style: TextStyle(
                                fontSize: inputFontSize,
                                height: 1.4,
                                color: context.textTheme.bodyLarge?.color,
                              ),
                              decoration: InputDecoration(
                                hintText: hintText,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                isDense: true,
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: TextStyle(
                                  color: context.theme.hintColor,
                                  fontSize: inputFontSize,
                                ),
                              ),
                              maxLines: maxInputLines,
                              minLines: 1,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: handleSend,
                          child: Container(
                            width: actionButtonSize,
                            height: actionButtonSize,
                            margin: EdgeInsets.only(left: sendButtonMargin),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: actionColor,
                            ),
                            child: Tooltip(
                              message: actionLabel,
                              child: Icon(
                                actionIcon,
                                color: Colors.white,
                                size: actionIconSize,
                              ),
                            ),
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
      ],
    );
  }

  String _formatAttachmentError(Object error) {
    final raw = error.toString().trim();
    if (raw.startsWith('Exception: ')) {
      return raw.substring('Exception: '.length);
    }
    return raw;
  }
}

enum _AiInputMenuAction { previewContext, uploadImage, uploadFile }

class _AiInputMenuItem extends StatelessWidget {
  const _AiInputMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scopeScale = AiChatCompactScope.scaleOf(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 188 * scopeScale,
        maxWidth: 272 * scopeScale,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30 * scopeScale,
            height: 30 * scopeScale,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(9 * scopeScale),
            ),
            child: Icon(
              icon,
              size: 16 * scopeScale,
              color: context.colorScheme.primary,
            ),
          ),
          SizedBox(width: 10 * scopeScale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13 * scopeScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2 * scopeScale),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5 * scopeScale,
                    height: 1.35,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingAttachmentChip extends StatelessWidget {
  const _PendingAttachmentChip({required this.file, required this.onRemove});

  final PickedFileData file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scopeScale = AiChatCompactScope.scaleOf(context);
    final extension = (file.extension ?? '').toLowerCase();
    final isImage = const {
      'png',
      'jpg',
      'jpeg',
      'gif',
      'webp',
      'bmp',
      'heic',
    }.contains(extension);

    return Container(
      constraints: BoxConstraints(maxWidth: 220 * scopeScale),
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scopeScale,
        vertical: 7 * scopeScale,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: context.isDark ? 0.55 : 0.75,
        ),
        borderRadius: BorderRadius.circular(999 * scopeScale),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isImage ? Icons.image_outlined : Icons.attach_file_rounded,
            size: 14 * scopeScale,
            color: context.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 6 * scopeScale),
          Flexible(
            child: Text(
              '${file.fileName} · ${file.formattedSize}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5 * scopeScale,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 6 * scopeScale),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 14 * scopeScale,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextUsageIndicator extends HookWidget {
  const _ContextUsageIndicator({required this.stats, required this.usageRatio});

  final AiChatContextStats stats;
  final double usageRatio;

  @override
  Widget build(BuildContext context) {
    final expanded = useState(false);

    if (stats.tokenBudget <= 0 && stats.memoryEntryCount == 0) {
      return const SizedBox.shrink();
    }

    final scopeScale = AiChatCompactScope.scaleOf(context);
    final isWarning = stats.highWatermarkReached;
    final color = isWarning ? AppColors.warning : context.colorScheme.primary;
    final radius = BorderRadius.circular(8 * scopeScale);
    // 不再给整块铺实心底色，只用一条淡描边界定区域，
    // 避免在输入框上方形成突兀的色块。仅在告警时使用淡橙底强调。
    final surfaceDecoration = BoxDecoration(
      color: isWarning ? AppColors.warning.withValues(alpha: 0.10) : null,
      borderRadius: radius,
      border: Border.all(
        color: isWarning
            ? AppColors.warning.withValues(alpha: 0.35)
            : context.colorScheme.outlineVariant.withValues(alpha: 0.45),
      ),
    );

    final progressBar = ClipRRect(
      borderRadius: BorderRadius.circular(2 * scopeScale),
      child: LinearProgressIndicator(
        value: usageRatio,
        minHeight: 3 * scopeScale,
        backgroundColor: color.withValues(alpha: 0.16),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );

    final padding = EdgeInsets.fromLTRB(
      16 * scopeScale,
      4 * scopeScale,
      16 * scopeScale,
      2 * scopeScale,
    );

    // 折叠态：只保留进度条，点击卡片展开完整占用信息。
    if (!expanded.value) {
      return Padding(
        padding: padding,
        child: Tooltip(
          message:
              '${context.l10n.aiContextUsage}: ${(usageRatio * 100).round()}%',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => expanded.value = true,
            child: Container(
              decoration: surfaceDecoration,
              padding: EdgeInsets.symmetric(
                horizontal: 10 * scopeScale,
                vertical: 7 * scopeScale,
              ),
              child: progressBar,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: padding,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => expanded.value = false,
        child: Container(
          decoration: surfaceDecoration,
          padding: EdgeInsets.symmetric(
            horizontal: 10 * scopeScale,
            vertical: 6 * scopeScale,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                  children: [
                    Icon(
                      isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.data_usage_rounded,
                      size: 15 * scopeScale,
                      color: color,
                    ),
                    SizedBox(width: 6 * scopeScale),
                    Expanded(
                      child: Text(
                        '${context.l10n.aiContextUsage}: ${(usageRatio * 100).round()}%  '
                        '${stats.estimatedTokens}/${stats.tokenBudget}  '
                        '${context.l10n.aiContextMemoryEntries}: ${stats.memoryEntryCount}',
                        style: TextStyle(
                          color: isWarning
                              ? AppColors.warning
                              : context.colorScheme.onSurfaceVariant,
                          fontSize: 11 * scopeScale,
                          fontWeight: isWarning
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.expand_less_rounded,
                      size: 15 * scopeScale,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                SizedBox(height: 4 * scopeScale),
                progressBar,
                if (isWarning)
                  Padding(
                    padding: EdgeInsets.only(top: 3 * scopeScale),
                    child: Text(
                      context.l10n.aiContextHighWatermarkAlert,
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 10 * scopeScale,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
    );
  }
}

class _ContextSheet extends StatelessWidget {
  const _ContextSheet({required this.chatState});

  final AiChatRuntimeState chatState;

  @override
  Widget build(BuildContext context) {
    final scopeScale = AiChatCompactScope.scaleOf(context);
    final sessionContext = chatState.sessionContext;
    final stats = chatState.contextStats;
    final checkpoint = sessionContext.checkpoint;
    final layers = stats.includedLayers.join(' / ');
    final lastRecoveryMode = sessionContext.taskState.lastRecoveryMode;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16 * scopeScale,
          0,
          16 * scopeScale,
          16 * scopeScale,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _ContextInfoCard(
                title: context.l10n.aiContextBudget,
                rows: [
                  '${context.l10n.aiContextUsage}: ${(stats.usageRatio * 100).round()}%',
                  '${context.l10n.aiContextHighWatermark}: ${stats.highWatermarkReached ? context.l10n.aiContextHighWatermarkReached : context.l10n.aiContextHighWatermarkNotReached}',
                  '${context.l10n.aiContextMemoryEntries}: ${stats.memoryEntryCount}',
                  '${context.l10n.aiContextBudget}: ${stats.estimatedTokens}/${stats.tokenBudget}',
                  '${context.l10n.aiContextRemaining}: ${stats.remainingTokens}',
                  '${context.l10n.aiContextLayers}: ${layers.isEmpty ? '-' : layers}',
                  '${context.l10n.aiContextRecentRounds}: ${stats.recentRoundsKept}',
                  '${context.l10n.aiContextCompression}: '
                      '${_localizedCompactReason(context, stats.compactReason)}',
                  '${context.l10n.aiContextMigration}: '
                      '${stats.migratedLegacySummary ? context.l10n.aiContextMigrationDone : context.l10n.aiContextMigrationNone}',
                  '${context.l10n.aiContextToolTrace}: '
                      '${sessionContext.hasPendingToolPhase ? context.l10n.aiContextToolTracePending : context.l10n.aiContextToolTraceClear}',
                ],
              ),
              SizedBox(height: 10 * scopeScale),
              _ContextInfoCard(
                title: context.l10n.aiContextMemory,
                rows: [
                  '${context.l10n.aiContextGoals}: ${_joinList(sessionContext.sessionMemory.userGoals)}',
                  '${context.l10n.aiContextFacts}: ${_joinList(sessionContext.sessionMemory.confirmedFacts)}',
                  '${context.l10n.aiContextHypotheses}: ${_joinList(sessionContext.sessionMemory.openHypotheses)}',
                  '${context.l10n.aiContextFindings}: ${_joinList(sessionContext.sessionMemory.toolFindings)}',
                  '${context.l10n.aiContextTaskBlockers}: ${_joinList(sessionContext.sessionMemory.blockers)}',
                  '${context.l10n.aiContextTaskCurrent}: ${sessionContext.taskState.currentStep ?? context.l10n.aiSummaryEmpty}',
                  '${context.l10n.aiContextTaskNext}: ${sessionContext.taskState.nextStep ?? context.l10n.aiSummaryEmpty}',
                ],
              ),
              SizedBox(height: 10 * scopeScale),
              _ContextInfoCard(
                title: context.l10n.aiContextCheckpoint,
                rows: checkpoint == null
                    ? [context.l10n.aiContextNoCheckpoint]
                    : [
                        '${context.l10n.aiContextCheckpointTime}: ${checkpoint.createdAtIso}',
                        '${context.l10n.aiContextCheckpointPrompt}: ${checkpoint.lastUserMessage == null ? context.l10n.aiSummaryEmpty : AiMultimodalMessageCodec.toDisplayText(checkpoint.lastUserMessage!.content, isZh: context.isZh)}',
                        '${context.l10n.aiContextCheckpointMode}: ${_localizedRecoveryMode(context, lastRecoveryMode)}',
                      ],
              ),
              SizedBox(height: 10 * scopeScale),
              _ContextInfoCard(
                title: context.l10n.aiContextLastError,
                rows: [
                  sessionContext.taskState.lastError ??
                      context.l10n.aiContextNoError,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _joinList(List<String> items) {
    if (items.isEmpty) {
      return '';
    }
    return items.join(' | ');
  }

  String _localizedCompactReason(BuildContext context, String? reason) {
    return switch (reason) {
      'budget' => context.l10n.aiContextCompactReasonBudget,
      'manual' => context.l10n.aiContextCompactReasonManual,
      _ => context.l10n.aiContextCompactReasonNone,
    };
  }

  String _localizedRecoveryMode(
    BuildContext context,
    AiChatRecoveryMode recoveryMode,
  ) {
    return switch (recoveryMode) {
      AiChatRecoveryMode.retryLastTurn => context.l10n.aiRecoveryModeRetry,
      AiChatRecoveryMode.continueGeneration =>
        context.l10n.aiRecoveryModeContinue,
      AiChatRecoveryMode.resumeToolPhase => context.l10n.aiRecoveryModeTool,
      AiChatRecoveryMode.retryInitialization =>
        context.l10n.aiRetryInitialization,
      AiChatRecoveryMode.none => '-',
    };
  }
}

class _ContextInfoCard extends StatelessWidget {
  const _ContextInfoCard({required this.title, required this.rows});

  final String title;
  final List<String> rows;

  @override
  Widget build(BuildContext context) {
    final scopeScale = AiChatCompactScope.scaleOf(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12 * scopeScale),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14 * scopeScale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13 * scopeScale,
              fontWeight: FontWeight.w700,
              color: context.colorScheme.primary,
            ),
          ),
          SizedBox(height: 8 * scopeScale),
          for (final item in rows)
            Padding(
              padding: EdgeInsets.only(bottom: 6 * scopeScale),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6 * scopeScale),
                    child: Container(
                      width: 4 * scopeScale,
                      height: 4 * scopeScale,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(width: 8 * scopeScale),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 13 * scopeScale, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
