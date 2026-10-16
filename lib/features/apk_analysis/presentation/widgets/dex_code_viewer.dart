import 'package:JsxposedX/common/widgets/app_code_editor/widgets/selection_toolbar.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/java.dart';
import 'package:re_highlight/languages/smali.dart';
import 'package:re_highlight/styles/github-dark.dart';
import 'package:re_highlight/styles/github.dart';

class DexCodeViewer extends HookWidget {
  final String code;
  final String language;
  final void Function(String selectedText)? onSendToAi;

  const DexCodeViewer({super.key, required this.code, required this.language, this.onSendToAi});

  @override
  Widget build(BuildContext context) {
    final fontSize = useState(13.sp);
    final baseFontSize = useRef(fontSize.value);
    final verticalScroller = useScrollController();
    final horizontalScroller = useScrollController();

    final ctrl = useMemoized(() => CodeLineEditingController.fromText(code), [
      code,
    ]);
    useEffect(() => ctrl.dispose, [ctrl]);

    final toolbarController = useMemoized(
      () => SystemSelectionToolbarController(
        customActionLabel: onSendToAi != null ? context.l10n.sendToAi : null,
        onCustomAction: onSendToAi,
      ),
      [onSendToAi],
    );

    final isDark = context.isDark;
    final syntaxTheme = isDark ? githubDarkTheme : githubTheme;
    final mode = language == 'java' ? langJava : langSmali;

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onScaleStart: (details) {
            if (details.pointerCount >= 2) {
              baseFontSize.value = fontSize.value;
            }
          },
          onScaleUpdate: (details) {
            if (details.pointerCount >= 2 && details.scale != 1.0) {
              final newFontSize = (baseFontSize.value * details.scale).clamp(
                8.sp,
                32.sp,
              );
              if ((newFontSize - fontSize.value).abs() > 0.2) {
                fontSize.value = newFontSize;
              }
            }
          },
          child: CodeEditor(
            controller: ctrl,
            toolbarController: toolbarController,
            scrollController: CodeScrollController(
              verticalScroller: verticalScroller,
              horizontalScroller: horizontalScroller,
            ),
            style: CodeEditorStyle(
              fontSize: fontSize.value,
              fontFamily: 'monospace',
              codeTheme: CodeHighlightTheme(
                languages: {language: CodeHighlightThemeMode(mode: mode)},
                theme: syntaxTheme,
              ),
            ),
            wordWrap: false,
            readOnly: true,
            indicatorBuilder:
                (context, editingController, chunkController, notifier) {
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
                    ],
                  );
                },
          ),
        ),
      ],
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String code;
  final bool isDark;

  const _CopyButton({required this.code, required this.isDark});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: widget.code));
        setState(() => _copied = true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _copied = false);
      },
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: widget.isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: widget.isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _copied ? Icons.check_rounded : Icons.copy_rounded,
              size: 14.sp,
              color: _copied
                  ? const Color(0xFF4CAF50)
                  : (widget.isDark ? Colors.white70 : Colors.black54),
            ),
            SizedBox(width: 4.w),
            Text(
              _copied ? 'Copied' : 'Copy',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: _copied
                    ? const Color(0xFF4CAF50)
                    : (widget.isDark ? Colors.white70 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
