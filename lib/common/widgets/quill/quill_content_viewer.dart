import 'dart:convert';

import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/accordion_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/callout_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/carousel_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/chatbubble_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/codeblock_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/countdown_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/counter_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/custom_button_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/custom_password_box_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/divider_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/flipcard_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/highlight_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/image_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/kbd_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/list_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/neon_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/progress_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/publish_script_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quote_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/spoiler_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/steps_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/tags_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/timeline_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/typewriter_embed_button.dart';
import 'package:JsxposedX/common/widgets/quill/theme/quill_style.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_accordion.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_button.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_callout.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_carousel.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_chatbubble.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_codeblock.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_countdown.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_counter.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_divider.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_flipcard.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_highlight.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_image.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_kbd.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_list.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_neon.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_password_box.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_progress.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_publish_script.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_quote.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_spoiler.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_steps.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_tags.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_timeline.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_custom_typewriter.dart';
import 'package:JsxposedX/common/widgets/quill/widgets/quill_unknown_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:markdown/markdown.dart' as md;


/// 内容类型枚举
enum _ContentType { quillDelta, markdown, html }

/// 内容信息辅助类
class _ContentInfo {
  final _ContentType type;
  final quill.QuillController? controller;
  final String? rawContent;

  _ContentInfo({required this.type, this.controller, this.rawContent});
}

class QuillContentViewer extends HookWidget {
  final String contentDelta; // JSON 格式的 Delta
  final bool readOnly; // 是否只读，默认为 true
  final bool hideTitle;
  final quill.QuillController? externalController; // 👈 新增：外部传入的 controller
  final TextEditingController? externalTitleController;
  final bool shrinkWrap; // 👈 新增：是否自适应高度（用于 Sliver）

  const QuillContentViewer({
    super.key,
    required this.contentDelta,
    this.readOnly = true,
    this.hideTitle = false,
    this.externalController,
    this.externalTitleController,
    this.shrinkWrap = false, // 默认 false，保持原有行为
  });

  @override
  Widget build(BuildContext context) {
    final showCustomBar = useState(false);
    // 尝试解析并判断内容类型：Quill > Markdown > HTML
    final contentInfo = useMemoized(() {
      if (externalController != null) {
        return _ContentInfo(
          type: _ContentType.quillDelta,
          controller: externalController!,
        );
      }

      if (contentDelta.isEmpty) {
        final emptyController = quill.QuillController.basic();
        emptyController.readOnly = readOnly;
        return _ContentInfo(
          type: _ContentType.quillDelta,
          controller: emptyController,
        );
      }

      // 1. 先尝试解析为 Quill Delta
      try {
        final decoded = jsonDecode(contentDelta);
        final List<dynamic> ops = decoded is Map && decoded.containsKey('ops')
            ? decoded['ops'] as List<dynamic>
            : decoded as List<dynamic>;

        final doc = quill.Document.fromJson(ops);
        final controller = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
          readOnly: readOnly,
        );

        return _ContentInfo(
          type: _ContentType.quillDelta,
          controller: controller,
        );
      } catch (e) {
        debugPrint('解析 Quill Delta 失败，尝试其他格式: $e');

        if (!readOnly) {
          // 编辑模式：尝试将 HTML/Markdown 转换为 Delta
          try {
            final htmlPattern = RegExp(r'<[^>]+>');
            String htmlContent;

            if (htmlPattern.hasMatch(contentDelta)) {
              // 内容是 HTML
              debugPrint('检测到 HTML 格式内容');
              htmlContent = contentDelta;
            } else {
              // 内容是 Markdown，先转成 HTML
              debugPrint('检测到 Markdown/纯文本 格式，转换为 HTML');
              htmlContent = md.markdownToHtml(contentDelta);
            }

            // HTML 转 Delta
            final delta = HtmlToDelta().convert(htmlContent);
            final doc = quill.Document.fromDelta(delta);
            return _ContentInfo(
              type: _ContentType.quillDelta,
              controller: quill.QuillController(
                document: doc,
                selection: const TextSelection.collapsed(offset: 0),
                readOnly: readOnly,
              ),
            );
          } catch (convertError) {
            debugPrint('格式转换失败: $convertError，使用纯文本');
            // 兜底：作为纯文本
            final doc = quill.Document()..insert(0, contentDelta);
            return _ContentInfo(
              type: _ContentType.quillDelta,
              controller: quill.QuillController(
                document: doc,
                selection: const TextSelection.collapsed(offset: 0),
                readOnly: readOnly,
              ),
            );
          }
        }

        // 2. 检查是否为 Markdown（没有 HTML 标签，或者有 Markdown 特征）
        final htmlPattern = RegExp(r'<[^>]+>');
        final hasHtmlTags = htmlPattern.hasMatch(contentDelta);
        final markdownPattern = RegExp(
          r'(#{1,6}\s|```|\*\*|__|\[.*?\]\(.*?\))',
        );
        final hasMarkdownFeatures = markdownPattern.hasMatch(contentDelta);

        if (!hasHtmlTags || hasMarkdownFeatures) {
          // 优先作为 Markdown 处理
          return _ContentInfo(
            type: _ContentType.markdown,
            rawContent: contentDelta,
          );
        }

        // 3. 最后作为 HTML 处理
        return _ContentInfo(type: _ContentType.html, rawContent: contentDelta);
      }
    }, [contentDelta, readOnly, externalController]);

    // 根据内容类型选择渲染方式
    switch (contentInfo.type) {
      case _ContentType.markdown:
        return Markdown(
          data: contentInfo.rawContent!,
          selectable: true,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
        );

      case _ContentType.html:
        final processedHtml = _processBBCode(contentInfo.rawContent!);
        return SelectionArea(
          child: Html(
            data: processedHtml,
            style: {
              "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
              "p": Style(margin: Margins.only(bottom: 8)),
              "img": Style(
                display: Display.block,
                margin: Margins.symmetric(vertical: 4),
              ),
            },
            extensions: [
              TagExtension(
                tagsToExtend: {"img"},
                builder: (extensionContext) {
                  final src = extensionContext.attributes['src'];
                  if (src == null || src.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: CachedNetworkImage(
                      imageUrl: src,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                },
              ),
            ],
          ),
        );

      case _ContentType.quillDelta:
        // 使用 Quill 编辑器
        final controller = contentInfo.controller!;
        final scrollController = useScrollController();
        final focusNode = useFocusNode(canRequestFocus: !readOnly);
        final textTheme = context.theme.textTheme;
        final colorScheme = context.theme.colorScheme;
        final titleController =
            externalTitleController ?? useTextEditingController();

        final editor = quill.QuillEditor(
          controller: controller,
          scrollController: scrollController,
          focusNode: focusNode,
          config: quill.QuillEditorConfig(
            padding: EdgeInsets.zero,
            placeholder: readOnly ? '' : '请输入内容....',
            customStyles: buildCustomStyles(textTheme, colorScheme),
            embedBuilders: [
              ...quillCustomImages,
              QuillCustomImage(),
              QuillCustomButton(),
              QuillCustomCarousel(),
              QuillCustomList(),
              QuillPasswordBox(),
              QuillCustomSpoiler(),
              QuillCustomCountdown(),
              QuillCustomCallout(),
              QuillCustomProgress(),
              QuillCustomTags(),
              QuillCustomQuote(),
              QuillCustomTimeline(),
              QuillCustomAccordion(),
              QuillCustomSteps(),
              QuillCustomKbd(),
              QuillCustomDivider(),
              QuillCustomHighlight(),
              QuillCustomTypewriter(),
              QuillCustomFlipCard(),
              QuillCustomNeon(),
              QuillCustomChatBubble(),
              QuillCustomCounter(),
              QuillCustomCodeBlock(),
              QuillCustomPublishScript(),
            ],
            unknownEmbedBuilder: QuillUnknownEmbedBuilder(),
          ),
        );

        // 如果 shrinkWrap=true 或 readOnly=true，直接返回 editor，不使用 Expanded
        if (shrinkWrap || readOnly) {
          return editor;
        }

        // 否则使用原有的 Column + Expanded 布局(仅用于编辑模式)
        return Column(
          children: [
            if (!hideTitle) ...[
              CustomTextField(
                labelText: "标题",
                hintText: "请输入标题",
                controller: titleController,
              ),
              const SizedBox(height: 16),
            ],
            Expanded(child: editor),

            // 自定义组件工具栏（独立一行）
            if (showCustomBar.value)
              Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 0.5),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      PublishScriptEmbedButton().build(context, controller),
                      ImageEmbedButton().build(context, controller),
                      CarouselEmbedButton().build(context, controller),
                      CustomButtonEmbedButton().build(context, controller),
                      CustomPasswordBoxEmbedButton().build(context, controller),
                      ListEmbedButton().build(context, controller),
                      SpoilerEmbedButton().build(context, controller),
                      CountdownEmbedButton().build(context, controller),
                      CalloutEmbedButton().build(context, controller),
                      ProgressEmbedButton().build(context, controller),
                      TagsEmbedButton().build(context, controller),
                      QuoteEmbedButton().build(context, controller),
                      TimelineEmbedButton().build(context, controller),
                      AccordionEmbedButton().build(context, controller),
                      StepsEmbedButton().build(context, controller),
                      KbdEmbedButton().build(context, controller),
                      DividerEmbedButton().build(context, controller),
                      HighlightEmbedButton().build(context, controller),
                      TypewriterEmbedButton().build(context, controller),
                      FlipCardEmbedButton().build(context, controller),
                      NeonEmbedButton().build(context, controller),
                      ChatBubbleEmbedButton().build(context, controller),
                      CounterEmbedButton().build(context, controller),
                      CodeBlockEmbedButton().build(context, controller),
                    ],
                  ),
                ),
              ),
            // Quill 原生工具栏
            IntrinsicHeight(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      showCustomBar.value = !showCustomBar.value;
                    },
                    child: Text(
                      showCustomBar.value ? "收起" : "组件",
                      style: TextStyle(
                        color: context.isDark ? null : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: quill.QuillSimpleToolbar(
                      controller: controller,
                      config: quill.QuillSimpleToolbarConfig(
                        color: Colors.transparent,
                        multiRowsDisplay: false,
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

  /// 处理 BBCode 标签
  String _processBBCode(String html) {
    // 将 [hide]...[/hide] 转换为可点击展开的 HTML
    String processed = html.replaceAllMapped(
      RegExp(r'\[hide\](.*?)\[/hide\]', dotAll: true),
      (match) {
        final content = match.group(1) ?? '';
        return '<details><summary>点击查看隐藏内容</summary><div>$content</div></details>';
      },
    );

    return processed;
  }
}
