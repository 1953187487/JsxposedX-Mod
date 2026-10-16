import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 文本中绝对文件路径的识别正则。
///
/// 匹配以 `/` 开头、至少包含两段的路径，最后一段带扩展名或为常见文件；
/// 允许中文与常见符号（不含空白与引号）。
final _pathPattern = RegExp(
  r'(?<![\w/])(/(?:[\w.\-@]+/)*[\w.\-@]+\.[A-Za-z0-9]{1,8})(?![\w])',
);

/// 把一段纯文本渲染为富文本：其中的文件路径可点击，跳转到文件查看器。
class ClickablePathText extends StatefulWidget {
  const ClickablePathText({
    super.key,
    required this.text,
    required this.style,
    this.pathStyle,
  });

  final String text;
  final TextStyle style;

  /// 路径片段的样式，默认在 [style] 基础上加下划线并用主题色。
  final TextStyle? pathStyle;

  @override
  State<ClickablePathText> createState() => _ClickablePathTextState();
}

class _ClickablePathTextState extends State<ClickablePathText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  void _openPath(BuildContext context, String path) {
    context.push(HomeRoute.toFileViewer(path: path));
  }

  @override
  Widget build(BuildContext context) {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final linkStyle =
        widget.pathStyle ??
        widget.style.copyWith(
          color: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
          decorationColor: Theme.of(context).colorScheme.primary,
        );

    final spans = <InlineSpan>[];
    final text = widget.text;
    var last = 0;
    for (final match in _pathPattern.allMatches(text)) {
      final value = match.group(0)!;
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      final recognizer = TapGestureRecognizer()
        ..onTap = () => _openPath(context, value);
      _recognizers.add(recognizer);
      spans.add(
        TextSpan(text: value, style: linkStyle, recognizer: recognizer),
      );
      last = match.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return Text.rich(TextSpan(style: widget.style, children: spans));
  }
}

/// 判断文本中是否包含可点击的绝对路径。
bool containsClickablePath(String text) => _pathPattern.hasMatch(text);
