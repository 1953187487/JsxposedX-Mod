import 'dart:async';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_response_issue.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_session_init_state.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/ai_chat_bubble.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_view_message.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_tool_invocation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef AiChatBubbleBuilder =
    Widget Function({
      required AiChatViewMessage message,
      required String retryLabel,
      required VoidCallback onRetry,
      required String packageName,
      VoidCallback? onEdit,
      VoidCallback? onRegenerate,
      VoidCallback? onDelete,
      VoidCallback? onQuote,
      Object? rawDetails,
      List<AiToolInvocationView> toolInvocations,
      VoidCallback? onToolApprove,
      VoidCallback? onToolReject,
      List<String> imageSources,
      AiQuestion? pendingQuestion,
      ValueChanged<List<String>>? onAnswer,
    });

typedef AiChatStreamingBubbleBuilder =
    Widget Function({
      required AiChatViewMessage message,
      required String retryLabel,
      required VoidCallback onRetry,
      required String packageName,
      required Stream<String> streamingContentStream,
      required Stream<bool> streamingThinkingStream,
      VoidCallback? onQuote,
      List<AiToolInvocationView> toolInvocations,
      VoidCallback? onToolApprove,
      VoidCallback? onToolReject,
      AiQuestion? pendingQuestion,
      ValueChanged<List<String>>? onAnswer,
    });

class AiChatList extends HookConsumerWidget {
  const AiChatList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.packageName,
    this.isCompact = false,
    this.systemPrompt,
    this.customTitle,
    this.customSubtitle,
    this.bubbleBuilder,
    this.streamingBubbleBuilder,
    this.onQuote,
    this.highlightedMessageId,
  });

  final List<AiChatViewMessage> messages;
  final ScrollController scrollController;
  final String packageName;
  final bool isCompact;
  final String? systemPrompt;
  final String? customTitle;
  final String? customSubtitle;
  final AiChatBubbleBuilder? bubbleBuilder;
  final AiChatStreamingBubbleBuilder? streamingBubbleBuilder;

  /// 引用回复回调：用户选择「引用回复」时把消息回传给页面，
  /// 由页面负责在输入框上方展示引用卡片。
  final ValueChanged<AiChatViewMessage>? onQuote;

  /// 需要高亮标出的消息 ID（用于搜索结果定位），为空时不产生任何视觉差异。
  final String? highlightedMessageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scopeCompact = AiChatCompactScope.of(context);
    final scopeScale = AiChatCompactScope.scaleOf(context);
    final effectiveCompact = isCompact || scopeCompact;
    final chatState = ref.watch(
      aiChatRuntimeProvider(packageName: packageName),
    );
    final activeConfig = ref.watch(aiConfigProvider).value;
    final chatNotifier = ref.read(
      aiChatRuntimeProvider(packageName: packageName).notifier,
    );
    final showJumpToLatest = useState(false);
    final unreadMessageCount = useState(0);
    final wasNearLatest = useRef(true);
    final previousMessageIds = useRef<List<String>>(<String>[]);
    final previousSessionId = useRef(chatState.currentSessionId);
    // 记录需要播放入场动画的消息（仅新追加的消息，历史加载不播放）。
    final enteringMessageIds = useRef<Set<String>>(<String>{});
    // 搜索结果定位用的锚点 key，挂在目标消息上以便滚动到它。
    final focusMessageKey = useMemoized(() => GlobalKey(), const []);

    // 搜索结果被选中后，把目标消息滚动到视口中央。
    //
    // revealMessage 会把目标放到可见窗口的最前端，在 reverse 列表里它位于
    // 列表末端（maxScrollExtent 一侧）。因此这里直接朝列表末端收敛：每帧
    // jumpTo(maxScrollExtent) 推进，直到目标被构建后交给 ensureVisible 居中。
    // 相比按屏试探，方向是确定的，且 maxScrollExtent 随构建增长时会自动继续推进。
    useEffect(() {
      final targetId = highlightedMessageId;
      if (targetId == null) return null;
      var remainingFrames = 40;

      void reveal() {
        if (remainingFrames-- <= 0) return;
        final targetContext = focusMessageKey.currentContext;
        if (targetContext != null && targetContext.mounted) {
          Scrollable.ensureVisible(
            targetContext,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: 0.5,
          );
          return;
        }
        if (!scrollController.hasClients) return;
        final position = scrollController.position;
        if (scrollController.offset < position.maxScrollExtent - 0.5) {
          scrollController.jumpTo(position.maxScrollExtent);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => reveal());
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => reveal());
      return null;
    }, [highlightedMessageId, focusMessageKey, scrollController]);

    useEffect(() {
      void updateJumpButton() {
        if (!scrollController.hasClients) return;
        final nearLatest = scrollController.offset <= 80;
        wasNearLatest.value = nearLatest;
        final shouldShow = !nearLatest;
        if (showJumpToLatest.value != shouldShow) {
          showJumpToLatest.value = shouldShow;
        }
        if (nearLatest && unreadMessageCount.value != 0) {
          unreadMessageCount.value = 0;
        }
      }

      scrollController.addListener(updateJumpButton);
      updateJumpButton();
      return () => scrollController.removeListener(updateJumpButton);
    }, [scrollController]);

    final messageIds = messages
        .map((message) => message.id)
        .toList(growable: false);
    useEffect(() {
      final sessionChanged =
          previousSessionId.value != chatState.currentSessionId;
      previousSessionId.value = chatState.currentSessionId;
      final previousIds = previousMessageIds.value;
      previousMessageIds.value = messageIds;
      if (sessionChanged) {
        enteringMessageIds.value = <String>{};
        unreadMessageCount.value = 0;
        wasNearLatest.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) scrollController.jumpTo(0);
        });
        return null;
      }

      final addedCount = appendedMessageCount(previousIds, messageIds);
      if (addedCount == 0) return null;
      enteringMessageIds.value.addAll(
        messageIds.sublist(messageIds.length - addedCount),
      );
      if (wasNearLatest.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients && wasNearLatest.value) {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
            );
          }
        });
      } else {
        unreadMessageCount.value += addedCount;
      }
      return null;
    }, [chatState.currentSessionId, Object.hashAll(messageIds)]);

    if (messages.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final isCompactLayout =
              effectiveCompact || constraints.maxHeight < (220 * scopeScale);
          final horizontalPadding = (effectiveCompact ? 12 : 20) * scopeScale;
          final topPadding = (isCompactLayout ? 10 : 18) * scopeScale;
          final bottomPadding = 12 * scopeScale;
          final minHeight = constraints.maxHeight - topPadding - bottomPadding;

          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              topPadding,
              horizontalPadding,
              bottomPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minHeight > 0 ? minHeight : 0,
              ),
              child: Align(
                alignment: isCompactLayout
                    ? Alignment.topLeft
                    : Alignment.centerLeft,
                child: _EmptyChatState(
                  isCompact: isCompactLayout,
                  brand: AiBrand.resolve(
                    apiUrl: activeConfig?.apiUrl,
                    modelName: activeConfig?.moduleName,
                    name: activeConfig?.name,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    final totalVisibleCount = chatState.totalVisibleMessagesCount;
    final hasMore =
        chatState.hasOlderMessages || messages.length < totalVisibleCount;
    final remainingCount =
        (totalVisibleCount - messages.length).clamp(0, totalVisibleCount) +
        (chatState.hasOlderMessages ? 1 : 0);
    final reversedMessages = messages.reversed.toList(growable: false);

    /// 仅对新追加的消息播放入场动画；已渲染过的消息直接返回原 child。
    Widget wrapEntryAnimation(String messageId, Widget child) {
      if (!enteringMessageIds.value.contains(messageId)) {
        return child;
      }
      return _BubbleEnterTransition(
        onCompleted: () => enteringMessageIds.value.remove(messageId),
        child: child,
      );
    }

    final retryLabel =
        chatState.lastResponseIssue == AiResponseIssue.partialResponse
        ? (chatState.sessionContext.hasPendingToolPhase
              ? context.l10n.aiResumeToolPhase
              : context.l10n.aiContinue)
        : context.l10n.retry;

    final responseError =
        chatState.error != null &&
        !chatState.isStreaming &&
        chatState.lastResponseIssue != null &&
        chatState.sessionInitState == AiSessionInitState.ready;

    return Column(
      children: [
        if (responseError)
          _ChatErrorBanner(
            detail: chatState.error!,
            retryLabel: retryLabel,
            onRetry: chatState.canRetryLastTurn
                ? chatNotifier.retryLastTurn
                : null,
            // 带图片的请求失败：直接把「该模型是否支持图片」的选择摆在
            // 错误旁边，让用户从错误本身完成配置，避免整轮对话作废。
            visionConfigPromptPending: chatState.hasVisionConfigPrompt,
            onMarkVisionSupported: () =>
                chatNotifier.markVisionCapability(supported: true),
            onMarkVisionUnsupported: () =>
                chatNotifier.markVisionCapability(supported: false),
            onResendWithoutImage: chatNotifier.resendLastTurnWithoutImage,
            onDismissVisionPrompt: chatNotifier.dismissVisionConfigPrompt,
          ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: EdgeInsets.symmetric(
                  horizontal: (effectiveCompact ? 12 : 20) * scopeScale,
                  vertical: (effectiveCompact ? 6 : 10) * scopeScale,
                ),
                itemCount: reversedMessages.length + (hasMore ? 1 : 0),
                cacheExtent: 500,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
                itemBuilder: (context, index) {
                  if (index == reversedMessages.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8 * scopeScale),
                      child: TextButton(
                        onPressed: chatNotifier.loadMore,
                        child: Text(
                          context.l10n.aiShowMoreMessages(remainingCount),
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                      ),
                    );
                  }

                  final message = reversedMessages[index];
                  final shouldShowStreaming =
                      index == 0 &&
                      chatState.isStreaming &&
                      message.role == 'assistant' &&
                      !message.isError &&
                      !message.isToolResultBubble;

                  if (shouldShowStreaming) {
                    if (streamingBubbleBuilder != null) {
                      final streamingCustomHasApproval =
                          chatNotifier.hasPendingToolApproval &&
                          message.toolInvocations.any(
                            (inv) =>
                                inv.status ==
                                AiToolInvocationViewStatus.awaitingApproval,
                          );
                      return RepaintBoundary(
                        child: streamingBubbleBuilder!(
                          message: message,
                          retryLabel: retryLabel,
                          onRetry: () =>
                              chatNotifier.retryByMessageId(message.id),
                          packageName: packageName,
                          streamingContentStream:
                              chatNotifier.streamingContentStream,
                          streamingThinkingStream:
                              chatNotifier.streamingThinkingStream,
                          toolInvocations: message.toolInvocations,
                          onToolApprove: streamingCustomHasApproval
                              ? () => chatNotifier.approvePendingTools()
                              : null,
                          onToolReject: streamingCustomHasApproval
                              ? () => chatNotifier.rejectPendingTools()
                              : null,
                          pendingQuestion: chatState.pendingQuestion,
                          onAnswer: (answers) =>
                              chatNotifier.submitAnswer(answers),
                          onQuote: onQuote == null
                              ? null
                              : () => onQuote!(message),
                        ),
                      );
                    }
                    final streamingHasApproval =
                        chatNotifier.hasPendingToolApproval &&
                        message.toolInvocations.any(
                          (inv) =>
                              inv.status ==
                              AiToolInvocationViewStatus.awaitingApproval,
                        );
                    return wrapEntryAnimation(
                      message.id,
                      _AssistantMessageWithIcon(
                        brand: AiBrand.resolve(
                          apiUrl: activeConfig?.apiUrl,
                          modelName: activeConfig?.moduleName,
                          name: activeConfig?.name,
                        ),
                        name: activeConfig?.moduleName.trim().isNotEmpty == true
                            ? activeConfig!.moduleName
                            : (activeConfig?.name ?? 'AI'),
                        child: _StreamingAiChatBubble(
                          key: ValueKey(message.id),
                          initialContent: message.content,
                          role: message.role,
                          isError: message.isError,
                          errorHint: message.errorHint,
                          retryLabel: retryLabel,
                          streamingContentStream:
                              chatNotifier.streamingContentStream,
                          streamingThinkingStream:
                              chatNotifier.streamingThinkingStream,
                          toolInvocations: message.toolInvocations,
                          onRetry: () =>
                              chatNotifier.retryByMessageId(message.id),
                          packageName: packageName,
                          onToolApprove: streamingHasApproval
                              ? () => chatNotifier.approvePendingTools()
                              : null,
                          onToolReject: streamingHasApproval
                              ? () => chatNotifier.rejectPendingTools()
                              : null,
                          pendingQuestion: chatState.pendingQuestion,
                          onAnswer: (answers) =>
                              chatNotifier.submitAnswer(answers),
                          onQuote: onQuote == null
                              ? null
                              : () => onQuote!(message),
                        ),
                      ),
                    );
                  }

                  final hasApprovalActions =
                      chatNotifier.hasPendingToolApproval &&
                      message.toolInvocations.any(
                        (inv) =>
                            inv.status ==
                            AiToolInvocationViewStatus.awaitingApproval,
                      );

                  final isHighlighted = message.id == highlightedMessageId;
                  return wrapEntryAnimation(
                    message.id,
                    RepaintBoundary(
                      child: _AssistantMessageWithIcon(
                        visible:
                            message.role == 'assistant' &&
                            !message.isToolResultBubble,
                        brand: AiBrand.resolve(
                          apiUrl: activeConfig?.apiUrl,
                          modelName: activeConfig?.moduleName,
                          name: activeConfig?.name,
                        ),
                        name: activeConfig?.moduleName.trim().isNotEmpty == true
                            ? activeConfig!.moduleName
                            : (activeConfig?.name ?? 'AI'),
                        child: _MessageHighlight(
                          key: ValueKey('highlight-${message.id}'),
                          active: isHighlighted,
                          anchorKey: isHighlighted ? focusMessageKey : null,
                          child: bubbleBuilder != null
                              ? bubbleBuilder!(
                                  message: message,
                                  retryLabel: retryLabel,
                                  onRetry: () => chatNotifier.retryByMessageId(
                                    message.sourceMessageId ?? message.id,
                                  ),
                                  packageName: packageName,
                                  onEdit: message.role == 'user'
                                      ? () => _editAndResendMessage(
                                          context,
                                          message,
                                          chatNotifier.editUserMessageAndResend,
                                        )
                                      : null,
                                  onRegenerate:
                                      message.role == 'user' &&
                                          !chatState.isStreaming
                                      ? () => _confirmMessageAction(
                                          context,
                                          title: context.isZh
                                              ? '从此处重新生成？'
                                              : 'Regenerate from here?',
                                          detail: context.isZh
                                              ? '此消息之后的回复将被移除并重新生成。'
                                              : 'Messages after this one will be removed and regenerated.',
                                          confirmLabel: context.isZh
                                              ? '重新生成'
                                              : 'Regenerate',
                                          action: () =>
                                              chatNotifier.retryByMessageId(
                                                message.sourceMessageId ??
                                                    message.id,
                                              ),
                                        )
                                      : null,
                                  onDelete:
                                      !chatState.isStreaming &&
                                          message.sourceMessageId != null
                                      ? () => _confirmMessageAction(
                                          context,
                                          title: context.isZh
                                              ? '删除这条消息？'
                                              : 'Delete this message?',
                                          detail: context.isZh
                                              ? '此操作无法撤销。'
                                              : 'This action cannot be undone.',
                                          confirmLabel: context.l10n.delete,
                                          destructive: true,
                                          action: () =>
                                              chatNotifier.deleteMessage(
                                                message.sourceMessageId!,
                                              ),
                                        )
                                      : null,
                                  rawDetails: message.rawDetails,
                                  toolInvocations: message.toolInvocations,
                                  imageSources: message.imageSources,
                                  onToolApprove: hasApprovalActions
                                      ? () => chatNotifier.approvePendingTools()
                                      : null,
                                  onToolReject: hasApprovalActions
                                      ? () => chatNotifier.rejectPendingTools()
                                      : null,
                                  pendingQuestion: chatState.pendingQuestion,
                                  onAnswer: (answers) =>
                                      chatNotifier.submitAnswer(answers),
                                  onQuote: onQuote == null
                                      ? null
                                      : () => onQuote!(message),
                                )
                              : AiChatBubble(
                                  key: ValueKey(message.id),
                                  content: message.content,
                                  role: message.role,
                                  isError: message.isError,
                                  errorHint: message.errorHint,
                                  retryLabel: retryLabel,
                                  onRetry: () => chatNotifier.retryByMessageId(
                                    message.sourceMessageId ?? message.id,
                                  ),
                                  packageName: packageName,
                                  onEdit: message.role == 'user'
                                      ? () => _editAndResendMessage(
                                          context,
                                          message,
                                          chatNotifier.editUserMessageAndResend,
                                        )
                                      : null,
                                  onRegenerate:
                                      message.role == 'user' &&
                                          !chatState.isStreaming
                                      ? () => _confirmMessageAction(
                                          context,
                                          title: context.isZh
                                              ? '从此处重新生成？'
                                              : 'Regenerate from here?',
                                          detail: context.isZh
                                              ? '此消息之后的回复将被移除并重新生成。'
                                              : 'Messages after this one will be removed and regenerated.',
                                          confirmLabel: context.isZh
                                              ? '重新生成'
                                              : 'Regenerate',
                                          action: () =>
                                              chatNotifier.retryByMessageId(
                                                message.sourceMessageId ??
                                                    message.id,
                                              ),
                                        )
                                      : null,
                                  onDelete:
                                      !chatState.isStreaming &&
                                          message.sourceMessageId != null
                                      ? () => _confirmMessageAction(
                                          context,
                                          title: context.isZh
                                              ? '删除这条消息？'
                                              : 'Delete this message?',
                                          detail: context.isZh
                                              ? '此操作无法撤销。'
                                              : 'This action cannot be undone.',
                                          confirmLabel: context.l10n.delete,
                                          destructive: true,
                                          action: () =>
                                              chatNotifier.deleteMessage(
                                                message.sourceMessageId!,
                                              ),
                                        )
                                      : null,
                                  rawDetails: message.rawDetails,
                                  toolInvocations: message.toolInvocations,
                                  imageSources: message.imageSources,
                                  onToolApprove: hasApprovalActions
                                      ? () => chatNotifier.approvePendingTools()
                                      : null,
                                  onToolReject: hasApprovalActions
                                      ? () => chatNotifier.rejectPendingTools()
                                      : null,
                                  pendingQuestion: chatState.pendingQuestion,
                                  onAnswer: (answers) =>
                                      chatNotifier.submitAnswer(answers),
                                  onQuote: onQuote == null
                                      ? null
                                      : () => onQuote!(message),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                right: (effectiveCompact ? 14 : 20) * scopeScale,
                bottom: (effectiveCompact ? 10 : 16) * scopeScale,
                child: AnimatedScale(
                  scale: showJumpToLatest.value ? 1 : 0,
                  duration: const Duration(milliseconds: 160),
                  child: IgnorePointer(
                    ignoring: !showJumpToLatest.value,
                    child: FloatingActionButton.small(
                      heroTag: null,
                      tooltip: context.isZh ? '回到最新消息' : 'Jump to latest',
                      onPressed: () {
                        unreadMessageCount.value = 0;
                        scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: unreadMessageCount.value > 0
                          ? _UnreadMessageBadge(count: unreadMessageCount.value)
                          : const Icon(Icons.keyboard_double_arrow_down),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

@visibleForTesting
int appendedMessageCount(List<String> previousIds, List<String> currentIds) {
  if (previousIds.isEmpty || currentIds.isEmpty) return 0;
  for (var index = previousIds.length - 1; index >= 0; index--) {
    final sharedIndex = currentIds.indexOf(previousIds[index]);
    if (sharedIndex >= 0) {
      return currentIds.length - sharedIndex - 1;
    }
  }
  return 0;
}

class _MessageHighlight extends StatelessWidget {
  const _MessageHighlight({
    super.key,
    required this.active,
    required this.child,
    this.anchorKey,
  });

  final bool active;
  final Widget child;

  /// 定位锚点。仅目标消息持有，用于把该条滚动到视口中央。
  final GlobalKey? anchorKey;

  @override
  Widget build(BuildContext context) {
    if (anchorKey != null) {
      return KeyedSubtree(key: anchorKey, child: _buildHighlighted(context));
    }
    return _buildHighlighted(context);
  }

  Widget _buildHighlighted(BuildContext context) {
    if (!active) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        if (value <= 0) return child!;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.16 * value),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _UnreadMessageBadge extends StatelessWidget {
  const _UnreadMessageBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Semantics(
      label: context.isZh ? '$count 条新消息' : '$count new messages',
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

Future<void> _confirmMessageAction(
  BuildContext context, {
  required String title,
  required String detail,
  required String confirmLabel,
  required Future<void> Function() action,
  bool destructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(detail),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: context.colorScheme.error,
                  foregroundColor: context.colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  if (confirmed == true) await action();
}

Future<void> _editAndResendMessage(
  BuildContext context,
  AiChatViewMessage message,
  Future<void> Function({
    required String messageId,
    required String updatedText,
  })
  onSubmit,
) async {
  final controller = TextEditingController(text: message.content);
  final updated = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(context.isZh ? '编辑消息' : 'Edit message'),
      content: TextField(
        controller: controller,
        autofocus: true,
        minLines: 2,
        maxLines: 8,
        decoration: InputDecoration(
          hintText: context.isZh ? '输入新内容' : 'Enter new content',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, controller.text),
          child: Text(context.isZh ? '发送' : 'Send'),
        ),
      ],
    ),
  );
  controller.dispose();
  if (updated == null || updated.trim().isEmpty || updated == message.content) {
    return;
  }
  await onSubmit(messageId: message.id, updatedText: updated.trim());
}

class _ChatErrorBanner extends HookWidget {
  const _ChatErrorBanner({
    required this.detail,
    required this.retryLabel,
    required this.onRetry,
    this.visionConfigPromptPending = false,
    this.onMarkVisionSupported,
    this.onMarkVisionUnsupported,
    this.onResendWithoutImage,
    this.onDismissVisionPrompt,
  });

  final String detail;
  final String retryLabel;
  final VoidCallback? onRetry;

  /// 本次失败是否由「带图片的消息」引起，若是则展开图片能力配置区。
  final bool visionConfigPromptPending;
  final VoidCallback? onMarkVisionSupported;
  final VoidCallback? onMarkVisionUnsupported;
  final VoidCallback? onResendWithoutImage;
  final VoidCallback? onDismissVisionPrompt;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final expanded = useState(false);
    final color = context.colorScheme.error;
    final canExpand = detail.length > 180;
    final lines = detail.split('\n');
    final title = lines.first;
    final body = lines.length > 1 ? lines.skip(1).join('\n') : detail;
    final isZh = context.isZh;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16 * scale, 8 * scale, 16 * scale, 0),
      padding: EdgeInsets.fromLTRB(12 * scale, 9 * scale, 8 * scale, 9 * scale),
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(10 * scale),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1 * scale),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 18 * scale,
                  color: color,
                ),
              ),
              SizedBox(width: 8 * scale),
              Expanded(
                child: GestureDetector(
                  onTap: canExpand
                      ? () => expanded.value = !expanded.value
                      : null,
                  onLongPress: () async {
                    await Clipboard.setData(ClipboardData(text: detail));
                    if (context.mounted) {
                      ToastMessage.show(
                        isZh ? '错误详情已复制' : 'Error details copied',
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: expanded.value ? null : (canExpand ? 2 : 3),
                        overflow: expanded.value ? null : TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.colorScheme.onErrorContainer,
                          fontSize: 12 * scale,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                      if (expanded.value && body != title) ...[
                        SizedBox(height: 6 * scale),
                        Text(
                          body,
                          style: TextStyle(
                            color: context.colorScheme.onErrorContainer
                                .withValues(alpha: 0.8),
                            fontSize: 11.5 * scale,
                            fontFamily: 'monospace',
                            height: 1.45,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (canExpand)
                IconButton(
                  onPressed: () => expanded.value = !expanded.value,
                  tooltip: expanded.value
                      ? (isZh ? '收起详情' : 'Collapse details')
                      : (isZh ? '展开详情' : 'Expand details'),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 30 * scale,
                    minHeight: 30 * scale,
                  ),
                  icon: Icon(
                    expanded.value ? Icons.expand_less : Icons.expand_more,
                    size: 18 * scale,
                    color: color,
                  ),
                ),
              if (onRetry != null)
                IconButton(
                  onPressed: onRetry,
                  tooltip: retryLabel,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 30 * scale,
                    minHeight: 30 * scale,
                  ),
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 18 * scale,
                    color: color,
                  ),
                ),
            ],
          ),
          if (visionConfigPromptPending) ...[
            SizedBox(height: 8 * scale),
            _VisionConfigPrompt(
              scale: scale,
              isZh: isZh,
              onMarkSupported: onMarkVisionSupported,
              onMarkUnsupported: onMarkVisionUnsupported,
              onResendWithoutImage: onResendWithoutImage,
              onDismiss: onDismissVisionPrompt,
            ),
          ],
        ],
      ),
    );
  }
}

/// 错误旁的「模型图片能力」配置区。
///
/// 直接内联在错误提示里，不依赖任何弹层 API，因此宿主 App 与悬浮窗
/// 两个引擎都能正常呈现。
class _VisionConfigPrompt extends StatelessWidget {
  const _VisionConfigPrompt({
    required this.scale,
    required this.isZh,
    this.onMarkSupported,
    this.onMarkUnsupported,
    this.onResendWithoutImage,
    this.onDismiss,
  });

  final double scale;
  final bool isZh;
  final VoidCallback? onMarkSupported;
  final VoidCallback? onMarkUnsupported;
  final VoidCallback? onResendWithoutImage;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      padding: EdgeInsets.all(10 * scale),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isZh
                ? '刚才的消息带图片，但当前模型未开启图片输入能力，图片不会被发送。'
                : 'The message contained an image, but this model has image input '
                      'disabled, so the image was not sent.',
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 11.5 * scale,
              height: 1.4,
            ),
          ),
          SizedBox(height: 4 * scale),
          Text(
            isZh
                ? '确认当前模型是否支持图片；已开启图片输入能力后，图片才会随消息发送。'
                : 'Confirm whether this model supports images. Images are sent '
                      'only after image input is enabled.',
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 11 * scale,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8 * scale),
          Wrap(
            spacing: 8 * scale,
            runSpacing: 6 * scale,
            children: [
              FilledButton.tonalIcon(
                onPressed: onMarkSupported,
                icon: Icon(Icons.image_rounded, size: 16 * scale),
                label: Text(
                  isZh ? '支持图片输入' : 'Supports images',
                  style: TextStyle(fontSize: 12 * scale),
                ),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onMarkUnsupported,
                icon: Icon(Icons.image_not_supported_rounded, size: 16 * scale),
                label: Text(
                  isZh ? '不支持图片' : 'No image support',
                  style: TextStyle(fontSize: 12 * scale),
                ),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                ),
              ),
              if (onResendWithoutImage != null)
                TextButton.icon(
                  onPressed: onResendWithoutImage,
                  icon: Icon(Icons.text_fields_rounded, size: 16 * scale),
                  label: Text(
                    isZh ? '去掉图片重发' : 'Resend without image',
                    style: TextStyle(fontSize: 12 * scale),
                  ),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                  ),
                ),
              if (onDismiss != null)
                TextButton(
                  onPressed: onDismiss,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                  ),
                  child: Text(
                    isZh ? '忽略' : 'Ignore',
                    style: TextStyle(fontSize: 12 * scale),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssistantMessageWithIcon extends StatelessWidget {
  const _AssistantMessageWithIcon({
    required this.brand,
    required this.name,
    required this.child,
    this.visible = true,
  });

  final AiBrand? brand;
  final String name;
  final Widget child;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;
    final scale = AiChatCompactScope.scaleOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4 * scale, bottom: 6 * scale),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AiBrandIcon(
                brand: brand,
                size: 16 * scale,
                fallbackIcon: Icons.auto_awesome_rounded,
              ),
              SizedBox(width: 6 * scale),
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

/// 空会话问候里展示的模型品牌，与文案一一对应
const List<(AiBrand, String)> _emptyStateBrands = <(AiBrand, String)>[
  (AiBrand.openai, 'ChatGPT'),
  (AiBrand.claude, 'Claude'),
  (AiBrand.glm, 'GLM'),
  (AiBrand.deepseek, 'DeepSeek'),
  (AiBrand.moonshot, 'Kimi'),
  (AiBrand.gemini, 'Gemini'),
  (AiBrand.qwen, '千问'),
];

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState({
    required this.isCompact,
    required this.brand,
    this.title,
    this.subtitle,
  });

  final bool isCompact;
  final AiBrand? brand;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final scopeScale = AiChatCompactScope.scaleOf(context);
    final lines = context.isZh ? const ['欢迎使用'] : const ['Welcome'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: (isCompact ? 24 : 28) * scopeScale,
              height: (isCompact ? 24 : 28) * scopeScale,
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AiBrandIcon(
                  brand: brand,
                  size: (isCompact ? 14 : 16) * scopeScale,
                  fallbackIcon: Icons.auto_awesome_rounded,
                ),
              ),
            ),
            SizedBox(width: 8 * scopeScale),
            Text(
              context.isZh ? '助手' : 'Assistant',
              style: TextStyle(
                fontSize: (isCompact ? 11 : 12) * scopeScale,
                fontWeight: FontWeight.w700,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: (isCompact ? 8 : 10) * scopeScale),
        Container(
          constraints: BoxConstraints(
            maxWidth: (isCompact ? 240 : 320) * scopeScale,
          ),
          padding: EdgeInsets.fromLTRB(
            (isCompact ? 12 : 16) * scopeScale,
            (isCompact ? 10 : 14) * scopeScale,
            (isCompact ? 12 : 16) * scopeScale,
            (isCompact ? 10 : 14) * scopeScale,
          ),
          decoration: BoxDecoration(
            color: context.isDark
                ? context.colorScheme.surfaceContainer
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20 * scopeScale),
              topRight: Radius.circular(20 * scopeScale),
              bottomLeft: Radius.circular(6 * scopeScale),
              bottomRight: Radius.circular(20 * scopeScale),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12 * scopeScale,
                offset: Offset(0, 4 * scopeScale),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < lines.length; index++) ...[
                if (index > 0)
                  SizedBox(height: (isCompact ? 6 : 8) * scopeScale),
                Text(
                  lines[index],
                  style: TextStyle(
                    fontSize: (isCompact ? 13 : 15) * scopeScale,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ],
              SizedBox(height: (isCompact ? 6 : 8) * scopeScale),
              Text(
                context.isZh
                    ? '支持 ChatGPT、Claude、GLM、DeepSeek、Kimi、Gemini、千问等模型'
                    : 'Supports ChatGPT, Claude, GLM, DeepSeek, Kimi, Gemini, Qwen and more',
                style: TextStyle(
                  fontSize: (isCompact ? 12 : 13) * scopeScale,
                  height: 1.35,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: (isCompact ? 8 : 10) * scopeScale),
              Wrap(
                spacing: (isCompact ? 6 : 8) * scopeScale,
                runSpacing: (isCompact ? 6 : 8) * scopeScale,
                children: [
                  for (final (brand, label) in _emptyStateBrands)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: (isCompact ? 6 : 8) * scopeScale,
                        vertical: (isCompact ? 4 : 5) * scopeScale,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.06,
                        ),
                        borderRadius: BorderRadius.circular(20 * scopeScale),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AiBrandIcon(
                            brand: brand,
                            size: isCompact ? 14 : 16,
                          ),
                          SizedBox(width: 4 * scopeScale),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: (isCompact ? 11 : 12) * scopeScale,
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: (isCompact ? 10 : 12) * scopeScale),
              OutlinedButton(
                onPressed: () {
                  UrlHelper.openUrlInBrowser(url: builtinAiConfigBaseUrl);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: (isCompact ? 10 : 12) * scopeScale,
                    vertical: (isCompact ? 8 : 10) * scopeScale,
                  ),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide(
                    color: context.colorScheme.primary.withValues(alpha: 0.35),
                  ),
                  foregroundColor: context.colorScheme.primary,
                  textStyle: TextStyle(
                    fontSize: (isCompact ? 11 : 12) * scopeScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('沐雪 AI 站点'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StreamingAiChatBubble extends HookWidget {
  const _StreamingAiChatBubble({
    super.key,
    required this.initialContent,
    required this.role,
    required this.isError,
    required this.retryLabel,
    required this.streamingContentStream,
    required this.streamingThinkingStream,
    this.errorHint,
    this.toolInvocations = const <AiToolInvocationView>[],
    this.onRetry,
    this.packageName,
    this.onToolApprove,
    this.onToolReject,
    this.onQuote,
    this.pendingQuestion,
    this.onAnswer,
  });

  final String initialContent;
  final String role;
  final bool isError;
  final String? errorHint;
  final String retryLabel;
  final Stream<String> streamingContentStream;
  final Stream<bool> streamingThinkingStream;
  final List<AiToolInvocationView> toolInvocations;
  final VoidCallback? onRetry;
  final String? packageName;
  final VoidCallback? onToolApprove;
  final VoidCallback? onToolReject;
  final VoidCallback? onQuote;
  final AiQuestion? pendingQuestion;
  final ValueChanged<List<String>>? onAnswer;

  @override
  Widget build(BuildContext context) {
    final content = useState(initialContent);
    final pendingContent = useRef<String?>(null);
    final flushTimer = useRef<Timer?>(null);
    final isThinking = useState(false);

    // The provider emits a new cumulative snapshot for every delta. Keep the
    // bubble synchronized from props as well as the broadcast stream so a
    // rebuild cannot miss an event delivered before subscription.
    useEffect(() {
      if (content.value != initialContent) {
        content.value = initialContent;
      }
      return null;
    }, [initialContent]);

    useEffect(() {
      final subscription = streamingContentStream.listen((data) {
        if (!context.mounted) {
          return;
        }

        if (data == content.value) return;
        pendingContent.value = data;
        if (flushTimer.value == null) {
          flushTimer.value = Timer(const Duration(milliseconds: 24), () {
            flushTimer.value = null;
            final next = pendingContent.value;
            pendingContent.value = null;
            if (next != null && context.mounted) {
              content.value = next;
            }
          });
        }
      });

      return () {
        flushTimer.value?.cancel();
        flushTimer.value = null;
        unawaited(subscription.cancel());
      };
    }, [streamingContentStream]);

    useEffect(() {
      final subscription = streamingThinkingStream.listen((value) {
        if (!context.mounted) {
          return;
        }
        isThinking.value = value;
      });

      return subscription.cancel;
    }, [streamingThinkingStream]);

    return RepaintBoundary(
      child: AiChatBubble(
        key: const ValueKey('streaming-bubble'),
        content: content.value,
        role: role,
        isError: isError,
        errorHint: errorHint,
        retryLabel: retryLabel,
        onRetry: onRetry,
        packageName: packageName,
        streaming: true,
        loadingHint: isThinking.value
            ? (context.isZh ? 'AI 正在深度思考...' : 'AI is thinking deeply...')
            : null,
        rawDetails: null,
        toolInvocations: toolInvocations,
        onToolApprove: onToolApprove,
        onToolReject: onToolReject,
        onQuote: onQuote,
        pendingQuestion: pendingQuestion,
        onAnswer: onAnswer,
      ),
    );
  }
}

/// 气泡入场动画：淡入 + 轻微上移，仅播放一次。
class _BubbleEnterTransition extends HookWidget {
  const _BubbleEnterTransition({required this.child, this.onCompleted});

  final Widget child;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 260),
    );
    useEffect(() {
      controller.forward().whenComplete(() => onCompleted?.call());
      // useAnimationController 会自行 dispose，这里不能再手动 dispose。
      return null;
    }, const <Object>[]);
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
