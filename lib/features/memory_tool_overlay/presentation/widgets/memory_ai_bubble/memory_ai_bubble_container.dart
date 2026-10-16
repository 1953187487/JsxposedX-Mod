import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_container.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_bubble/memory_ai_bubble_state.dart';
import 'package:flutter/material.dart';

class MemoryAiBubbleContainerPart extends BaseBubbleContainerPart {
  const MemoryAiBubbleContainerPart();

  @override
  MainAxisAlignment resolveMainAxisAlignment(BubbleState state) {
    if (state is MemoryAiBubbleState && state.isSystem) {
      return MainAxisAlignment.center;
    }
    return super.resolveMainAxisAlignment(state);
  }

  @override
  Alignment resolveBubbleAlignment(BubbleState state) {
    if (state is MemoryAiBubbleState && state.isSystem) {
      return Alignment.center;
    }
    return super.resolveBubbleAlignment(state);
  }

  @override
  EdgeInsetsGeometry resolveBubbleMargin(
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    return EdgeInsets.only(bottom: (isCompact ? 10 : 16) * scale);
  }

  @override
  BoxConstraints resolveBubbleConstraints(
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    return BoxConstraints(maxWidth: (isCompact ? 328.0 : 540.0) * scale);
  }

  @override
  Decoration? buildBubbleDecoration(
    BuildContext context,
    BubbleState state, {
    required bool isCompact,
    required double scale,
  }) {
    if (state.isToolResult) {
      return null;
    }

    if (state is MemoryAiBubbleState && state.isSystem) {
      return BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        borderRadius: BorderRadius.circular((isCompact ? 12 : 14) * scale),
      );
    }

    if (state.isUser) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            context.colorScheme.primary,
            context.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular((isCompact ? 16 : 20) * scale),
          topRight: Radius.circular((isCompact ? 16 : 20) * scale),
          bottomLeft: Radius.circular((isCompact ? 16 : 20) * scale),
          bottomRight: Radius.circular(6 * scale),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.14),
            blurRadius: (isCompact ? 9 : 12) * scale,
            offset: Offset(0, (isCompact ? 3 : 4) * scale),
          ),
        ],
      );
    }

    return BoxDecoration(
      color: state.isError
          ? context.colorScheme.errorContainer.withValues(alpha: 0.74)
          : context.colorScheme.surface.withValues(alpha: 0.96),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((isCompact ? 16 : 20) * scale),
        topRight: Radius.circular((isCompact ? 16 : 20) * scale),
        bottomLeft: Radius.circular(6 * scale),
        bottomRight: Radius.circular((isCompact ? 16 : 20) * scale),
      ),
      border: Border.all(
        color: state.isError
            ? context.colorScheme.error.withValues(alpha: 0.26)
            : context.colorScheme.outlineVariant.withValues(alpha: 0.24),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: (isCompact ? 8 : 12) * scale,
          offset: Offset(0, (isCompact ? 3 : 4) * scale),
        ),
      ],
    );
  }
}
