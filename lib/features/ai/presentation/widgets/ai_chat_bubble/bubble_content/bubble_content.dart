import 'dart:convert';
import 'dart:typed_data';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_thinking_markup.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_plan_parser.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/bubble_toolbar.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_content/widgets/ai_code_element_builder.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_content/widgets/ai_math_element_builder.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_content/widgets/dot_loading_indicator.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_content/widgets/tool_result_card.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/clickable_path_text.dart';
import 'package:markdown/markdown.dart' as md;

const String _streamingCursorMarker = '\uE000streaming_cursor\uE000';

abstract class BaseBubbleContentPart {
  const BaseBubbleContentPart();

  Widget build(
    BuildContext context,
    BubbleState state, {
    required BaseBubbleToolbarPart toolbarPart,
  }) {
    Widget body;
    if (state.isUser && AiMultimodalMessageCodec.isEncoded(state.content)) {
      body = buildUserAttachments(context, state, toolbarPart: toolbarPart);
    } else if (state.isSystem) {
      body = buildSystemHint(context, state);
    } else if (state.isLoading) {
      body = buildLoading(context, state);
    } else if (state.toolInvocations.isNotEmpty) {
      body = buildToolInvocations(context, state);
    } else if (state.isToolResult) {
      body = buildToolResult(context, state);
    } else {
      body = buildMarkdown(context, state, toolbarPart: toolbarPart);
    }
    final hint = state.errorHint?.trim() ?? '';
    if (hint.isEmpty || state.isUser) {
      return body;
    }
    // 非侵入式错误提示：已输出部分内容后流式中断/失败时，在气泡内容
    // 下方附加提示条；不改变气泡边框、阴影与已有内容。
    final scale = AiChatCompactScope.scaleOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        body,
        SizedBox(height: 8 * scale),
        _StreamErrorHint(hint: hint),
      ],
    );
  }

  @protected
  Widget buildLoading(BuildContext context, BubbleState state) {
    return DotLoadingIndicator(statusText: state.loadingHint);
  }

  /// 系统提示：居中、小字、弱化的纯文本展示（如上下文压缩回执）。
  @protected
  Widget buildSystemHint(BuildContext context, BubbleState state) {
    final isCompact = AiChatCompactScope.of(context);
    final scale = AiChatCompactScope.scaleOf(context);
    return Text(
      state.content,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: (isCompact ? 11 : 12) * scale,
        height: 1.4,
        color: context.colorScheme.onSurface.withValues(alpha: 0.62),
      ),
    );
  }

  @protected
  Widget buildToolResult(BuildContext context, BubbleState state) {
    return ToolResultCard(content: state.content);
  }

  @protected
  Widget buildToolInvocations(BuildContext context, BubbleState state) {
    final scale = AiChatCompactScope.scaleOf(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < state.toolInvocations.length; index++) ...[
            if (index > 0) SizedBox(height: 8 * scale),
            ToolResultCard(
              content: state.content,
              invocation: state.toolInvocations[index],
              onRetry: state.onRetry,
              onApprove: state.onToolApprove,
              onReject: state.onToolReject,
            ),
          ],
        ],
      );
    }

  @protected
  Widget buildUserAttachments(
    BuildContext context,
    BubbleState state, {
    required BaseBubbleToolbarPart toolbarPart,
  }) {
    final scale = AiChatCompactScope.scaleOf(context);
    final parsed = AiMultimodalMessageCodec.parse(state.content);
    if (parsed == null) {
      return buildMarkdown(context, state, toolbarPart: toolbarPart);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (parsed.hasText)
          _buildMarkdownBody(
            context,
            state,
            toolbarPart: toolbarPart,
            markdown: parsed.text,
            actionTitle: context.l10n.aiBubbleUserTextTitle,
            showStreamingCursor: false,
          ),
        for (final attachment in parsed.attachments) ...[
          if (parsed.hasText || attachment != parsed.attachments.first)
            SizedBox(height: 10 * scale),
          if (attachment.isImage)
            _UserImageAttachmentCard(attachment: attachment)
          else
            _UserFileAttachmentCard(attachment: attachment),
        ],
      ],
    );
  }

  @protected
  Widget buildMarkdown(
    BuildContext context,
    BubbleState state, {
    required BaseBubbleToolbarPart toolbarPart,
  }) {
    final parts = AiThinkingMarkup.split(resolveMarkdownData(context, state));
    if (parts.hasThinking) {
      final thinking = _ThinkingMarkdownContent(
        state: state,
        toolbarPart: toolbarPart,
        contentPart: this,
        thinkingContent: parts.thinking,
        answerContent: parts.answer,
        duration: parts.duration,
        theme: buildMarkdownTheme(context, state),
      );
      if (state.imageSources.isEmpty) {
        return thinking;
      }
      final scale = AiChatCompactScope.scaleOf(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          thinking,
          SizedBox(height: 8 * scale),
          _buildAssistantImages(context, state),
        ],
      );
    }

    final body = _buildMarkdownBody(
      context,
      state,
      toolbarPart: toolbarPart,
      markdown: parts.answer,
      actionTitle: state.isUser
          ? context.l10n.aiBubbleUserTextTitle
          : context.l10n.aiBubbleAssistantTextTitle,
      showStreamingCursor: state.streaming && !state.isUser,
    );
    if (state.imageSources.isEmpty) {
      return body;
    }
    final scale = AiChatCompactScope.scaleOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        body,
        SizedBox(height: 8 * scale),
        _buildAssistantImages(context, state),
      ],
    );
  }

  /// 处理 Markdown 链接点击：绝对文件路径跳转文件查看器，其余走外部浏览器。
  ///
  /// 悬浮窗等无路由环境的子类可覆写为安全实现。
  @protected
  void handleMarkdownLink(BuildContext context, String? href) {
    _handleMarkdownLink(context, href);
  }

  /// 打开本地绝对路径图片。悬浮窗等无路由环境的子类可覆写为安全实现。
  @protected
  void openLocalImage(BuildContext context, String src) {
    if (GoRouter.maybeOf(context) == null) {
      return;
    }
    context.push(HomeRoute.toFileViewer(path: src));
  }

  /// 渲染 AI 回复携带的图片。复用 [_MarkdownImage] 的三态能力
  /// （网络链接 / data URI / 本地绝对路径）。
  Widget _buildAssistantImages(BuildContext context, BubbleState state) {
    final scale = AiChatCompactScope.scaleOf(context);
    return Wrap(
      spacing: 8 * scale,
      runSpacing: 8 * scale,
      children: [
        for (final source in state.imageSources)
          _MarkdownImage(
            src: source,
            uiScale: scale,
            onOpenLocal: (src) => openLocalImage(context, src),
          ),
      ],
    );
  }

  @protected
  String resolveMarkdownData(BuildContext context, BubbleState state) {
    if (state.isError && state.content.isEmpty) {
      return context.l10n.aiMessageSendFailed;
    }
    if (state.isUser || state.isToolResult) {
      return state.content;
    }
    // 计划模式下 AI 会在正文里附带「执行计划」清单，该清单已由右侧计划
    // 菜单单独呈现，这里摘掉以免同一份内容重复渲染在气泡中。
    // 注意：提问块不能在这里摘掉——它需要保留 fenced 代码块原样交给
    // Markdown 渲染，再由 AiCodeElementBuilder 替换成选项卡片。
    return AiPlanParser.stripPlanSection(state.content);
  }

  @protected
  MarkdownStyleSheet buildMarkdownTheme(
    BuildContext context,
    BubbleState state,
  ) {
    final isCompact = AiChatCompactScope.of(context);
    final scale = AiChatCompactScope.scaleOf(context);
    return MarkdownStyleSheet.fromTheme(context.theme).copyWith(
      p: TextStyle(
        color: state.isUser
            ? Colors.white
            : (context.isDark
                  ? Colors.white.withValues(alpha: 0.9)
                  : context.textTheme.bodyLarge?.color),
        fontSize: (isCompact ? 13 : 15) * scale,
        height: 1.5,
      ),
      code: TextStyle(
        fontSize: (isCompact ? 12 : 14) * scale,
        fontFamily: 'monospace',
        backgroundColor: context.isDark
            ? Colors.black26
            : Colors.black.withValues(alpha: 0.05),
        color: state.isUser
            ? Colors.white
            : (context.isDark
                  ? context.colorScheme.secondaryContainer
                  : Colors.deepOrange),
      ),
      codeblockDecoration: const BoxDecoration(),
      blockquote: TextStyle(
        color: state.isUser
            ? Colors.white.withValues(alpha: 0.92)
            : (context.isDark
                  ? Colors.white.withValues(alpha: 0.85)
                  : Colors.black.withValues(alpha: 0.75)),
        fontSize: (isCompact ? 13 : 15) * scale,
        height: 1.5,
      ),
      blockquoteDecoration: BoxDecoration(
        color: state.isUser
            ? Colors.white.withValues(alpha: 0.16)
            : (context.isDark ? Colors.white10 : Colors.grey[200]),
        borderRadius: BorderRadius.circular(4),
      ),
      blockquotePadding: EdgeInsets.symmetric(
        horizontal: 10 * scale,
        vertical: 8 * scale,
      ),
      listBullet: TextStyle(
        color: state.isUser ? Colors.white : context.colorScheme.primary,
      ),
      tableBorder: TableBorder.all(
        color: context.theme.dividerColor.withValues(alpha: 0.2),
        width: 1,
      ),
      tableBody: TextStyle(
        fontSize: (isCompact ? 12 : 14) * scale,
        color: context.isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black87,
      ),
      tableHead: TextStyle(
        fontSize: (isCompact ? 12 : 14) * scale,
        fontWeight: FontWeight.w600,
        color: context.isDark ? Colors.white : Colors.black,
      ),
      tableCellsPadding: EdgeInsets.all(8 * scale),
    );
  }

  Widget _buildMarkdownBody(
    BuildContext context,
    BubbleState state, {
    required BaseBubbleToolbarPart toolbarPart,
    required String markdown,
    String? actionTitle,
    bool showStreamingCursor = false,
  }) {
    final theme = buildMarkdownTheme(context, state);
    final cursorEnabled = showStreamingCursor && markdown.trim().isNotEmpty;
    final body = GestureDetector(
      onLongPress: () => toolbarPart.showTextActionsSheet(
        context,
        title: actionTitle ?? context.l10n.aiBubbleAssistantTextTitle,
        text: markdown,
        onRetry: state.isUser ? null : state.onRetry,
        onEdit: state.isUser ? state.onEdit : null,
        onDelete: state.onDelete,
        onRegenerate: state.isUser ? state.onRegenerate : null,
        onQuote: state.onQuote,
        rawDetails: state.rawDetails,
      ),
      child: MarkdownBody(
        data: cursorEnabled ? _withStreamingCursor(markdown) : markdown,
        styleSheet: theme,
        selectable: false,
        onTapLink: (text, href, title) => handleMarkdownLink(context, href),
        inlineSyntaxes: <md.InlineSyntax>[
          ...buildMathInlineSyntaxes(),
          if (cursorEnabled) _StreamingCursorSyntax(),
        ],
        blockSyntaxes: buildMathBlockSyntaxes(),
        builders: {
          ...buildMarkdownBuilders(
            context,
            state,
            toolbarPart: toolbarPart,
            contentPart: this,
          ),
          if (cursorEnabled) 'streaming-cursor': _StreamingCursorBuilder(),
        },
        shrinkWrap: true,
        fitContent: true,
      ),
    );
    return body;
  }

}

/// 注册可在多处复用的 Markdown 元素构造器（代码块 / 表格 / 图片）。
Map<String, MarkdownElementBuilder> buildMarkdownBuilders(
  BuildContext context,
  BubbleState state, {
  required BaseBubbleToolbarPart toolbarPart,
  required BaseBubbleContentPart contentPart,
}) {
  final scale = AiChatCompactScope.scaleOf(context);
  return {
    'code': AiCodeElementBuilder(
      state: state,
      toolbarPart: toolbarPart,
      uiScale: scale,
    ),
    'table': _TableElementBuilder(uiScale: scale),
    'img': _MarkdownImageElementBuilder(
      uiScale: scale,
      onOpenLocal: (src) => contentPart.openLocalImage(context, src),
    ),
    kAiMathInlineTag: AiMathElementBuilder(uiScale: scale),
    kAiMathBlockTag: AiMathElementBuilder(uiScale: scale),
  };
}

/// 注册 LaTeX 公式语法（行内 `$...$` / 块级 `$$...$$`）。
List<md.InlineSyntax> buildMathInlineSyntaxes() => <md.InlineSyntax>[
  AiMathInlineSyntax(),
];

List<md.BlockSyntax> buildMathBlockSyntaxes() => <md.BlockSyntax>[
  AiMathBlockSyntax(),
];

/// 处理 Markdown 链接点击：绝对文件路径跳转文件查看器，其余走外部浏览器。
///
/// 通过 [GoRouter.maybeOf] 探测路由能力：悬浮窗（独立引擎、无 go_router）
/// 直接退化为外部打开，避免 `context.push` 抛错导致整条气泡渲染失败。
void _handleMarkdownLink(BuildContext context, String? href) {
  final target = href?.trim() ?? '';
  if (target.isEmpty) {
    return;
  }
  if (target.startsWith('/') &&
      containsClickablePath(target) &&
      GoRouter.maybeOf(context) != null) {
    context.push(HomeRoute.toFileViewer(path: target));
    return;
  }
  UrlHelper.openUrlInBrowser(url: target);
}

class DefaultBubbleContentPart extends BaseBubbleContentPart {
  const DefaultBubbleContentPart();
}

/// 流式中断/失败的非侵入式提示条。仅在气泡已有正常内容时附加，
/// 不改变气泡本身的样式（边框、阴影、背景均保持正常状态）。
class _StreamErrorHint extends StatelessWidget {
  const _StreamErrorHint({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final color = context.colorScheme.error;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scale,
        vertical: 8 * scale,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8 * scale),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1 * scale),
            child: Icon(
              Icons.info_outline_rounded,
              size: 14 * scale,
              color: color,
            ),
          ),
          SizedBox(width: 6 * scale),
          Expanded(
            child: Text(
              hint,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5 * scale,
                height: 1.35,
                color: context.colorScheme.onErrorContainer.withValues(
                  alpha: 0.9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _withStreamingCursor(String markdown) {
  if (markdown.endsWith('\n')) {
    return '$markdown$_streamingCursorMarker';
  }
  return '$markdown\u200A$_streamingCursorMarker';
}

class _StreamingCursorSyntax extends md.InlineSyntax {
  _StreamingCursorSyntax() : super(_streamingCursorMarker);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element.empty('streaming-cursor'));
    return true;
  }
}

class _StreamingCursorBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final style =
        preferredStyle ?? parentStyle ?? DefaultTextStyle.of(context).style;
    return _MarkdownStreamingCursor(style: style);
  }
}

/// 流式输出光标：以闪烁动画提示「仍在持续生成」。
class _MarkdownStreamingCursor extends HookWidget {
  const _MarkdownStreamingCursor({required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 900),
    );
    useEffect(() {
      controller.repeat(reverse: true);
      // useAnimationController 会自行 dispose，这里不能再手动 dispose。
      return null;
    }, const <Object>[]);
    final animation = useMemoized(
      () => Tween<double>(begin: 0.25, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      ),
      <Object>[controller],
    );
    return FadeTransition(
      opacity: animation,
      child: Text(
        '▌',
        style: style.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontSize: (style.fontSize ?? 15) * 1.08,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ThinkingMarkdownContent extends HookWidget {
  const _ThinkingMarkdownContent({
    required this.state,
    required this.toolbarPart,
    required this.contentPart,
    required this.thinkingContent,
    required this.answerContent,
    required this.duration,
    required this.theme,
  });

  final BubbleState state;
  final BaseBubbleToolbarPart toolbarPart;
  final BaseBubbleContentPart contentPart;
  final String thinkingContent;
  final String answerContent;
  final Duration? duration;
  final MarkdownStyleSheet theme;

  @override
  Widget build(BuildContext context) {
    final isCompact = AiChatCompactScope.of(context);
    final scale = AiChatCompactScope.scaleOf(context);
    final expanded = useState(false);
    final cardColor = context.isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.035);
    final borderColor = context.colorScheme.primary.withValues(alpha: 0.18);
    final title = state.streaming
        ? (context.isZh ? '正在思考…' : 'Thinking…')
        : (context.isZh ? '思考完成' : 'Thinking complete');
    final showAnswerCursor = state.streaming && answerContent.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            bottom: answerContent.isNotEmpty ? 10 * scale : 0,
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular((isCompact ? 10 : 12) * scale),
            border: Border.all(color: borderColor),
          ),
          child: InkWell(
            onTap: () => expanded.value = !expanded.value,
            borderRadius: BorderRadius.circular((isCompact ? 10 : 12) * scale),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (isCompact ? 10 : 12) * scale,
                vertical: (isCompact ? 8 : 10) * scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology_alt_outlined,
                        size: (isCompact ? 14 : 16) * scale,
                        color: context.colorScheme.primary,
                      ),
                      SizedBox(width: 8 * scale),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: (isCompact ? 11 : 12.5) * scale,
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                      if (duration != null) ...[
                        Text(
                          '${(duration!.inMilliseconds / 1000).toStringAsFixed(1)}s',
                          style: TextStyle(
                            fontSize: (isCompact ? 10.5 : 11.5) * scale,
                            fontFamily: 'monospace',
                            color: context.colorScheme.primary.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(width: 8 * scale),
                      ],
                      Icon(
                        expanded.value ? Icons.expand_less : Icons.expand_more,
                        size: (isCompact ? 14 : 16) * scale,
                        color: context.colorScheme.primary,
                      ),
                    ],
                  ),
                  if (expanded.value) ...[
                    SizedBox(height: (isCompact ? 8 : 10) * scale),
                    GestureDetector(
                      onLongPress: () => toolbarPart.showTextActionsSheet(
                        context,
                        title: context.l10n.aiBubbleThinkingTitle,
                        text: thinkingContent,
                        onRetry: state.isUser ? null : state.onRetry,
                        onEdit: null,
                        onDelete: state.onDelete,
                        onRegenerate: null,
                        onQuote: state.onQuote,
                        rawDetails: state.rawDetails,
                      ),
                      child: MarkdownBody(
                        data: thinkingContent,
                        styleSheet: theme,
                        selectable: false,
                        onTapLink: (text, href, title) =>
                            contentPart.handleMarkdownLink(context, href),
                        builders: buildMarkdownBuilders(
                          context,
                          state,
                          toolbarPart: toolbarPart,
                          contentPart: contentPart,
                        ),
                        shrinkWrap: true,
                        fitContent: true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (answerContent.isNotEmpty)
          GestureDetector(
            onLongPress: () => toolbarPart.showTextActionsSheet(
              context,
              title: context.l10n.aiBubbleAnswerTitle,
              text: answerContent,
              onRetry: state.isUser ? null : state.onRetry,
              onEdit: null,
              onDelete: state.onDelete,
              onRegenerate: null,
              onQuote: state.onQuote,
              rawDetails: state.rawDetails,
            ),
            child: MarkdownBody(
              data: showAnswerCursor
                  ? _withStreamingCursor(answerContent)
                  : answerContent,
              styleSheet: theme,
              selectable: false,
              onTapLink: (text, href, title) =>
                  contentPart.handleMarkdownLink(context, href),
              inlineSyntaxes: <md.InlineSyntax>[
                ...buildMathInlineSyntaxes(),
                if (showAnswerCursor) _StreamingCursorSyntax(),
              ],
              blockSyntaxes: buildMathBlockSyntaxes(),
              builders: {
                ...buildMarkdownBuilders(
                  context,
                  state,
                  toolbarPart: toolbarPart,
                  contentPart: contentPart,
                ),
                if (showAnswerCursor)
                  'streaming-cursor': _StreamingCursorBuilder(),
              },
              shrinkWrap: true,
              fitContent: true,
            ),
          )
        else if (!state.isError && state.streaming) ...[
          SizedBox(height: 8 * scale),
          DotLoadingIndicator(
            statusText: context.isZh
                ? 'AI 正在深度思考...'
                : 'AI is thinking deeply...',
          ),
        ],
      ],
    );
  }
}

class _MarkdownImageElementBuilder extends MarkdownElementBuilder {
  _MarkdownImageElementBuilder({required this.uiScale, required this.onOpenLocal});

  final double uiScale;
  final void Function(String src) onOpenLocal;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final src = element.attributes['src']?.trim() ?? '';
    if (src.isEmpty) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6 * uiScale),
      child: _MarkdownImage(
        src: src,
        uiScale: uiScale,
        onOpenLocal: onOpenLocal,
      ),
    );
  }
}

/// Markdown 内嵌图片：支持网络图片与本地绝对路径（经文件查看器兜底）。
class _MarkdownImage extends StatelessWidget {
  const _MarkdownImage({
    required this.src,
    required this.uiScale,
    this.onOpenLocal,
  });

  final String src;
  final double uiScale;
  final void Function(String src)? onOpenLocal;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10 * uiScale);
    final placeholder = _fallback(context);
    return ClipRRect(
      borderRadius: radius,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 320 * uiScale,
          maxHeight: 320 * uiScale,
        ),
        child: src.startsWith('http://') || src.startsWith('https://')
            ? Image.network(
                src,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => placeholder,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }
                  return SizedBox(
                    width: 160 * uiScale,
                    height: 120 * uiScale,
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
              )
            : src.startsWith('data:image/')
            ? Image.memory(
                _decodeDataUrl(src) ?? Uint8List(0),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => placeholder,
              )
            : _localImage(context),
      ),
    );
  }

  Widget _localImage(BuildContext context) {
    if (!src.startsWith('/')) {
      return _fallback(context);
    }
    return InkWell(
      onTap: () {
        final handler = onOpenLocal;
        if (handler != null) {
          handler(src);
        } else {
          context.push(HomeRoute.toFileViewer(path: src));
        }
      },
      child: Padding(
        padding: EdgeInsets.all(10 * uiScale),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_outlined,
              size: 16 * uiScale,
              color: context.colorScheme.primary,
            ),
            SizedBox(width: 6 * uiScale),
            Flexible(
              child: Text(
                src,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5 * uiScale,
                  color: context.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: context.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    return Container(
      width: 160 * uiScale,
      height: 100 * uiScale,
      alignment: Alignment.center,
      color: context.isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.05),
      child: Icon(
        Icons.broken_image_outlined,
        size: 24 * uiScale,
        color: context.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  static Uint8List? _decodeDataUrl(String dataUrl) {
    final commaIndex = dataUrl.indexOf(',');
    if (commaIndex == -1) {
      return null;
    }
    try {
      return base64Decode(dataUrl.substring(commaIndex + 1));
    } catch (_) {
      return null;
    }
  }
}

class _TableElementBuilder extends MarkdownElementBuilder {
  _TableElementBuilder({required this.uiScale});

  final double uiScale;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        border: TableBorder.all(
          color: context.theme.dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
        children: _parseTableRows(element, context),
      ),
    );
  }

  List<TableRow> _parseTableRows(md.Element tableElement, BuildContext context) {
    final rows = <TableRow>[];
    for (final child in tableElement.children!) {
      if (child is md.Element) {
        if (child.tag == 'thead') {
          rows.addAll(_parseRows(child, context, isHeader: true));
        } else if (child.tag == 'tbody') {
          rows.addAll(_parseRows(child, context, isHeader: false));
        }
      }
    }
    return rows;
  }

  List<TableRow> _parseRows(md.Element parent, BuildContext context, {required bool isHeader}) {
    final rows = <TableRow>[];
    for (final child in parent.children!) {
      if (child is md.Element && child.tag == 'tr') {
        final cells = <Widget>[];
        for (final cell in child.children!) {
          if (cell is md.Element) {
            cells.add(
              Padding(
                padding: EdgeInsets.all(8.0 * uiScale),
                child: Text(
                  cell.textContent,
                  style: TextStyle(
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13.0 * uiScale,
                  ),
                ),
              ),
            );
          }
        }
        rows.add(TableRow(children: cells));
      }
    }
    return rows;
  }
}

class _UserImageAttachmentCard extends StatelessWidget {
  const _UserImageAttachmentCard({required this.attachment});

  final AiMultimodalAttachmentData attachment;

  @override
  Widget build(BuildContext context) {
    final isCompact = AiChatCompactScope.of(context);
    final scale = AiChatCompactScope.scaleOf(context);
    final bytes = attachment.imageBytes;
    if (bytes == null) {
      return _UserFileAttachmentCard(attachment: attachment);
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: (isCompact ? 220.0 : 300.0) * scale,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return AspectRatio(
                aspectRatio: 1.2,
                child: ColoredBox(
                  color: Colors.white.withValues(alpha: 0.10),
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white.withValues(alpha: 0.90),
                      size: 28 * scale,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 12 * scale,
              vertical: 10 * scale,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.64),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attachment.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  attachment.formattedSize,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontSize: 11 * scale,
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

class _UserFileAttachmentCard extends StatelessWidget {
  const _UserFileAttachmentCard({required this.attachment});

  final AiMultimodalAttachmentData attachment;

  @override
  Widget build(BuildContext context) {
    final isCompact = AiChatCompactScope.of(context);
    final scale = AiChatCompactScope.scaleOf(context);
    final preview = (attachment.textContent ?? '').trim();
    final excerpt = preview.length <= 180
        ? preview
        : '${preview.substring(0, 180)}...';

    return Container(
      constraints: BoxConstraints(
        maxWidth: (isCompact ? 228.0 : 320.0) * scale,
      ),
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36 * scale,
            height: 36 * scale,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10 * scale),
            ),
            child: Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 18 * scale,
            ),
          ),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attachment.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  '${attachment.mimeType} · ${attachment.formattedSize}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 11 * scale,
                  ),
                ),
                if (excerpt.isNotEmpty) ...[
                  SizedBox(height: 8 * scale),
                  Text(
                    excerpt,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 11.5 * scale,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
