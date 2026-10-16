import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_content/bubble_content.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/bubble_toolbar.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_bubble/memory_ai_bubble_state.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_bubble/memory_ai_tool_result_cards.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_bubble/memory_ai_tool_result_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MemoryAiBubbleContentPart extends BaseBubbleContentPart {
  const MemoryAiBubbleContentPart();

  @override
  Widget build(
    BuildContext context,
    BubbleState state, {
    required BaseBubbleToolbarPart toolbarPart,
  }) {
    if (state.toolInvocations.isNotEmpty) {
      return buildToolInvocations(context, state);
    }
    if (state.isToolResult) {
      return GestureDetector(
        onLongPress: () => toolbarPart.showTextActionsSheet(
          context,
          title: _toolResultSheetTitle(context),
          text: state.content,
        ),
        child: MemoryAiToolResultView(
          data: MemoryAiToolResultParser.parse(state.content),
          packageName: state.packageName,
        ),
      );
    }
    return super.build(context, state, toolbarPart: toolbarPart);
  }

  @override
  MarkdownStyleSheet buildMarkdownTheme(
    BuildContext context,
    BubbleState state,
  ) {
    final isCompact = AiChatCompactScope.of(context);
    final scale = AiChatCompactScope.scaleOf(context);
    final isSystem = state is MemoryAiBubbleState && state.isSystem;
    final bodyColor = isSystem
        ? context.colorScheme.onSurfaceVariant
        : state.isUser
        ? context.colorScheme.onPrimary
        : state.isError
        ? context.colorScheme.onErrorContainer
        : context.colorScheme.onSurface;

    return MarkdownStyleSheet.fromTheme(context.theme).copyWith(
      p: TextStyle(
        color: bodyColor,
        fontSize:
            (isCompact ? (isSystem ? 11 : 13) : (isSystem ? 12 : 15)) * scale,
        height: 1.48,
        fontWeight: isSystem ? FontWeight.w600 : FontWeight.w500,
      ),
      h1: TextStyle(
        color: bodyColor,
        fontSize: (isCompact ? 16 : 18) * scale,
        fontWeight: FontWeight.w800,
      ),
      h2: TextStyle(
        color: bodyColor,
        fontSize: (isCompact ? 14 : 16) * scale,
        fontWeight: FontWeight.w800,
      ),
      strong: TextStyle(color: bodyColor, fontWeight: FontWeight.w800),
      code: TextStyle(
        fontSize: (isCompact ? 12 : 13.5) * scale,
        fontFamily: 'monospace',
        backgroundColor: state.isUser
            ? Colors.white.withValues(alpha: 0.14)
            : context.colorScheme.primary.withValues(alpha: 0.08),
        color: state.isUser
            ? context.colorScheme.onPrimary
            : context.colorScheme.primary,
      ),
      codeblockDecoration: BoxDecoration(
        color: state.isUser
            ? Colors.black.withValues(alpha: 0.16)
            : context.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
        borderRadius: BorderRadius.circular(12 * scale),
      ),
      blockquoteDecoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.34,
        ),
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      listBullet: TextStyle(
        color: state.isUser
            ? context.colorScheme.onPrimary
            : context.colorScheme.primary,
        fontWeight: FontWeight.w800,
      ),
      a: TextStyle(
        color: state.isUser
            ? context.colorScheme.onPrimary
            : context.colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

String _toolResultSheetTitle(BuildContext context) {
  return context.isZh ? '内存工具结果' : 'Memory Tool Result';
}
