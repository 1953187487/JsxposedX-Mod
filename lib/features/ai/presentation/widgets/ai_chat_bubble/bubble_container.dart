import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';

import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_content/bubble_content.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/bubble_toolbar.dart';

abstract class BaseBubbleContainerPart {
  const BaseBubbleContainerPart();

  Widget build(
    BuildContext context,
    BubbleState state, {
    required BaseBubbleContentPart contentPart,
    required BaseBubbleToolbarPart toolbarPart,
  }) {
    final isCompact = AiChatCompactScope.of(context);
    final scopeScale = AiChatCompactScope.scaleOf(context);
    final bubbleChild = contentPart.build(
      context,
      state,
      toolbarPart: toolbarPart,
    );

    return Row(
      mainAxisAlignment: resolveMainAxisAlignment(state),
      crossAxisAlignment: resolveCrossAxisAlignment(state),
      children: [
        ...buildLeadingWidgets(context, state),
        Flexible(
          child: Align(
            alignment: resolveBubbleAlignment(state),
            child: Container(
              margin: resolveBubbleMargin(
                state,
                isCompact: isCompact,
                scale: scopeScale,
              ),
              padding: resolveBubblePadding(
                state,
                isCompact: isCompact,
                scale: scopeScale,
              ),
              constraints: resolveBubbleConstraints(
                state,
                isCompact: isCompact,
                scale: scopeScale,
              ),
              decoration: buildBubbleDecoration(
                context,
                state,
                isCompact: isCompact,
                scale: scopeScale,
              ),
              child: bubbleChild,
            ),
          ),
        ),
        ...buildTrailingWidgets(context, state),
      ],
    );
  }

  @protected
  MainAxisAlignment resolveMainAxisAlignment(BubbleState state) {
    if (state.isSystem) {
      return MainAxisAlignment.center;
    }
    return state.isUser ? MainAxisAlignment.end : MainAxisAlignment.start;
  }

  @protected
  CrossAxisAlignment resolveCrossAxisAlignment(BubbleState state) {
    if (state.isSystem) {
      return CrossAxisAlignment.center;
    }
    return CrossAxisAlignment.end;
  }

  @protected
  Alignment resolveBubbleAlignment(BubbleState state) {
    if (state.isSystem) {
      return Alignment.center;
    }
    return state.isUser ? Alignment.centerRight : Alignment.centerLeft;
  }

  @protected
  EdgeInsetsGeometry resolveBubbleMargin(
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    if (state.isSystem) {
      return EdgeInsets.symmetric(
        vertical: (isCompact ? 6 : 8) * scale,
        horizontal: (isCompact ? 12 : 16) * scale,
      );
    }
    return EdgeInsets.only(bottom: (isCompact ? 12 : 20) * scale);
  }

  @protected
  EdgeInsetsGeometry resolveBubblePadding(
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    if (state.isSystem) {
      return EdgeInsets.symmetric(
        horizontal: (isCompact ? 10 : 12) * scale,
        vertical: (isCompact ? 4 : 5) * scale,
      );
    }
    return EdgeInsets.symmetric(
      horizontal: state.isToolResult
          ? 0
          : ((isCompact ? 12 : 16) * scale),
      vertical: state.isLoading
          ? ((isCompact ? 10 : 14) * scale)
          : (state.isToolResult
                ? 0
                : ((isCompact ? 9 : 12) * scale)),
    );
  }

  @protected
  BoxConstraints resolveBubbleConstraints(
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    return BoxConstraints(
      maxWidth: (isCompact ? 320.0 : 560.0) * scale,
    );
  }

  @protected
  Decoration? buildBubbleDecoration(
    BuildContext context,
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    if (state.isToolResult) {
      return null;
    }

    // 系统提示（如上下文压缩、角色设定回执）：居中胶囊样式，
    // 弱化背景与字体，与用户/AI 对话气泡明确区分。
    if (state.isSystem) {
      return BoxDecoration(
        color: context.isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999 * scale),
      );
    }

    return BoxDecoration(
      color: state.isUser
          ? context.colorScheme.primary
          : (context.isDark
                ? context.colorScheme.surfaceContainer
                : Colors.white),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((isCompact ? 16 : 20) * scale),
        topRight: Radius.circular((isCompact ? 16 : 20) * scale),
        bottomLeft: Radius.circular(
          state.isUser ? ((isCompact ? 16 : 20) * scale) : 6 * scale,
        ),
        bottomRight: Radius.circular(
          state.isUser ? 6 * scale : ((isCompact ? 16 : 20) * scale),
        ),
      ),
      border: state.isError
          ? Border.all(
              color: Colors.redAccent.withValues(alpha: 0.3),
              width: 1,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color:
              (state.isUser
                      ? context.colorScheme.primary
                      : (state.isError ? Colors.red : Colors.black))
                  .withValues(alpha: 0.08),
          blurRadius: (isCompact ? 8 : 12) * scale,
          offset: Offset(0, (isCompact ? 3 : 4) * scale),
        ),
      ],
    );
  }

  @protected
  List<Widget> buildLeadingWidgets(BuildContext context, BubbleState state) {
    if (!state.isUser && state.isError) {
      return [buildRetryAction(context, state, isLeading: true)];
    }
    return const [];
  }

  @protected
  List<Widget> buildTrailingWidgets(BuildContext context, BubbleState state) {
    if (state.isUser && state.isError) {
      return [buildRetryAction(context, state, isLeading: false)];
    }
    return const [];
  }

  @protected
  Widget buildRetryAction(
    BuildContext context,
    BubbleState state, {
    required bool isLeading,
  }) {
    final scale = AiChatCompactScope.scaleOf(context);
    return GestureDetector(
      onTap: state.onRetry,
      child: Padding(
        padding: EdgeInsets.only(
          right: isLeading ? 8 * scale : 0,
          left: isLeading ? 0 : 8 * scale,
          bottom: 20 * scale,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8 * scale,
            vertical: 6 * scale,
          ),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999 * scale),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.refresh_rounded,
                color: Colors.redAccent,
                size: 14 * scale,
              ),
              SizedBox(width: 4 * scale),
              Text(
                state.retryLabel ?? context.l10n.retry,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11 * scale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultBubbleContainerPart extends BaseBubbleContainerPart {
  const DefaultBubbleContainerPart();
}
