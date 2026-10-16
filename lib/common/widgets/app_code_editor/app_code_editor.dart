import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/styles/github-dark.dart';
import 'package:re_highlight/styles/github.dart';

import 'styles/app_code_editor_style.dart';
import 'widgets/app_code_editor_toolbar.dart';
import 'widgets/custom_autocomplete_view.dart';
import 'widgets/selection_toolbar.dart';

class AppCodeEditor extends HookWidget {
  final CodeLineEditingController controller;
  final CodeFindController? findController;
  final CodeFindBuilder? findBuilder;
  final String language;
  final bool readOnly;
  final double? initialFontSize;
  final ValueChanged<String>? onChanged;

  /// 自定义代码提示词汇。如果想添加自己的 API 提示，可以穿入这里。
  final List<String>? customKeywords;

  /// 完整的代码补全 PromptsBuilder。当传入时优先使用，忽略 [customKeywords]。
  final CodeAutocompletePromptsBuilder? promptsBuilder;

  /// 只读模式顶栏额外操作按钮（插在复制按钮左侧）
  final List<Widget>? extraActions;
  final bool showReadOnlyToolbar;
  final bool decorateReadOnly;
  final String? readOnlyToolbarLabel;
  final double? readOnlyMaxHeight;

  /// 是否显示底部符号工具栏。桌面端用物理键盘，不需要符号输入栏。
  final bool showToolbar;

  /// Ctrl/Cmd+S 保存回调
  final VoidCallback? onSave;

  const AppCodeEditor({
    super.key,
    required this.controller,
    this.findController,
    this.findBuilder,
    this.language = 'javascript',
    this.readOnly = false,
    this.initialFontSize,
    this.onChanged,
    this.customKeywords,
    this.promptsBuilder,
    this.extraActions,
    this.showReadOnlyToolbar = true,
    this.decorateReadOnly = true,
    this.readOnlyToolbarLabel,
    this.readOnlyMaxHeight,
    this.showToolbar = true,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // 使用 Hook 管理字体大小伸缩，默认 14.sp
    final fontSize = useState(initialFontSize ?? 14.sp);
    // 记录双指缩放操作开始时的基础字号
    final baseFontSize = useRef(fontSize.value);

    // 支持横向和纵向滚动
    final verticalScroller = useScrollController();
    final horizontalScroller = useScrollController();

    // 为只读模式（展示模式）计算自适应高度
    double? editorHeight;
    if (readOnly) {
      final lineCount = controller.text.split('\n').length;
      final toolbarHeight = showReadOnlyToolbar ? 36.h : 0.0;
      // 1.5 倍行高比例 + 工具栏 + padding + 额外缓冲空间
      final contentHeight =
          (lineCount * fontSize.value * 1.5) + toolbarHeight + 20.h;
      final maxHeight = readOnlyMaxHeight ?? 400.h;
      editorHeight = contentHeight > maxHeight ? maxHeight : contentHeight;
    }

    final isDark = context.isDark;
    final syntaxTheme = isDark ? githubDarkTheme : githubTheme;

    final mode = AppCodeEditorStyle.getLangMode(language);

    final toolbarController = useMemoized(
      () => SystemSelectionToolbarController(),
    );

    Widget editor = CodeEditor(
      controller: controller,
      toolbarController: toolbarController,
      findController: findController,
      findBuilder: findBuilder,
      scrollController: CodeScrollController(
        verticalScroller: verticalScroller,
        horizontalScroller: horizontalScroller,
      ),
      style: CodeEditorStyle(
        fontSize: fontSize.value,
        fontFamily: 'monospace',
        codeTheme: CodeHighlightTheme(
          languages: mode != null
              ? {language: CodeHighlightThemeMode(mode: mode)}
              : {},
          theme: syntaxTheme,
        ),
      ),
      wordWrap: false,
      readOnly: readOnly,
      shortcutOverrideActions: onSave != null
          ? {
              CodeShortcutSaveIntent: CallbackAction<CodeShortcutSaveIntent>(
                onInvoke: (_) {
                  onSave?.call();
                  return null;
                },
              ),
            }
          : null,
      indicatorBuilder: readOnly
          ? null
          : (context, editingController, chunkController, notifier) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultCodeLineNumber(
                    controller: editingController,
                    notifier: notifier,
                    textStyle: TextStyle(
                      color: context.theme.colorScheme.outline.withValues(
                        alpha: 0.5,
                      ),
                      fontSize: fontSize.value,
                      fontFamily: 'monospace',
                    ),
                  ),
                  DefaultCodeChunkIndicator(
                    width: 20,
                    controller: chunkController,
                    notifier: notifier,
                  ),
                ],
              );
            },
    );

    // 只读模式下由 re_editor 处理选择，不需要外层 SelectionArea
    // 否则会拦截事件导致 toolbarController 无法正常触发

    // 增强版手势缩放支持 (Pinch to Zoom)
    // 强制声明为透明背景以确保不拦截点击，但捕获缩放
    editor = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onScaleStart: (details) {
        if (details.pointerCount >= 2) {
          baseFontSize.value = fontSize.value;
        }
      },
      onScaleUpdate: (details) {
        // 双指操作时，通过 details.scale 进行缩放
        if (details.pointerCount >= 2 && details.scale != 1.0) {
          final double newFontSize = (baseFontSize.value * details.scale).clamp(
            8.sp,
            48.sp,
          );
          if ((newFontSize - fontSize.value).abs() > 0.2) {
            fontSize.value = newFontSize;
          }
        }
      },
      child: editor,
    );

    if (!readOnly) {
      editor = CodeAutocomplete(
        viewBuilder: (context, notifier, onSelected) {
          return CustomAutocompleteView(
            notifier: notifier,
            onSelected: onSelected,
          );
        },
        promptsBuilder:
            promptsBuilder ??
            DefaultCodeAutocompletePromptsBuilder(
              language: mode,
              keywordPrompts: (customKeywords ?? [])
                  .map((word) => CodeKeywordPrompt(word: word))
                  .toList(),
            ),
        child: editor,
      );
    }

    // 配色定义
    final bgColor = isDark
        ? context.colorScheme.surfaceContainerHigh
        : const Color(0xFFF5F7F9);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.05);

    return Container(
      height: editorHeight, // 只读模式下使用计算高度
      decoration: readOnly && decorateReadOnly
          ? BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : null,
      clipBehavior: readOnly && decorateReadOnly ? Clip.antiAlias : Clip.none,
      child: Column(
        children: [
          if (readOnly && showReadOnlyToolbar)
            // 只读模式的顶部工具栏 (显示预览信息)
            Container(
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.03),
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Text(
                    (readOnlyToolbarLabel ?? language.toUpperCase()),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      height: 1.0,
                      color: (isDark ? Colors.white70 : Colors.black54)
                          .withValues(alpha: 0.8),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const Spacer(),
                  if (extraActions != null) ...extraActions!,
                  _ToolbarButton(
                    icon: Icons.copy_rounded,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: controller.text));
                      ToastMessage.show(context.l10n.codeCopied);
                    },
                  ),
                ],
              ),
            ),

          // 编辑器主体
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(readOnly ? 4.w : 8.w),
              child: editor,
            ),
          ),

          if (!readOnly && showToolbar)
            // 编辑模式的工具栏 (底部)
            AppCodeEditorToolbar(controller: controller),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ToolbarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Icon(
          icon,
          size: 16.sp,
          color: isDark ? Colors.white54 : Colors.black45,
        ),
      ),
    );
  }
}
