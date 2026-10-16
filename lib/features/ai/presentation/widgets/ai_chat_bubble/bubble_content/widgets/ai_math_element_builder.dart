import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// 行内公式语法的占位标签，由 [AiMathInlineSyntax] 生成。
const String kAiMathInlineTag = 'ai-math-inline';

/// 块级公式语法的占位标签，由 [AiMathBlockSyntax] 生成。
const String kAiMathBlockTag = 'ai-math-block';

/// 行内公式：`$...$` 或 `\(...\)`。
///
/// 为避免误吞普通文本中的货币符号（如 `$100`），
/// 要求 `$` 起始后不能紧跟空白、且 `$` 结束前不能是空白。
class AiMathInlineSyntax extends md.InlineSyntax {
  AiMathInlineSyntax()
      : super(r'\$([^\s$](?:[^$\n]*[^\s$])?)\$|\\\((.+?)\\\)');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final tex = (match.group(1) ?? match.group(2) ?? '').trim();
    if (tex.isEmpty) {
      return false;
    }
    final element = md.Element.text(kAiMathInlineTag, tex);
    element.attributes['display'] = 'false';
    parser.addNode(element);
    return true;
  }
}

/// 块级公式：独占一行的 `$$...$$`。
class AiMathBlockSyntax extends md.BlockSyntax {
  AiMathBlockSyntax();

  static final RegExp _pattern = RegExp(r'^\s*\$\$(.+?)\$\$\s*$');

  @override
  RegExp get pattern => _pattern;

  @override
  md.Node? parse(md.BlockParser parser) {
    final line = parser.current.content;
    final match = _pattern.firstMatch(line);
    if (match == null) {
      return null;
    }
    final tex = match.group(1)?.trim() ?? '';
    parser.advance();
    if (tex.isEmpty) {
      return null;
    }
    final element = md.Element.text(kAiMathBlockTag, tex);
    element.attributes['display'] = 'true';
    return element;
  }
}

/// 将 LaTeX 公式节点渲染为 [Math.tex] 组件。
///
/// 解析失败时原样回退展示源码，避免由于公式不完整导致整段内容渲染异常。
class AiMathElementBuilder extends MarkdownElementBuilder {
  AiMathElementBuilder({required this.uiScale});

  final double uiScale;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final tex = element.textContent.trim();
    if (tex.isEmpty) {
      return null;
    }
    final display = element.attributes['display'] == 'true';
    final style = (preferredStyle ?? parentStyle ?? const TextStyle()).copyWith(
      color: context.isDark ? Colors.white.withValues(alpha: 0.92) : null,
    );

    final rendered = Math.tex(
      tex,
      mathStyle: display ? MathStyle.display : MathStyle.text,
      textStyle: style.copyWith(fontSize: (style.fontSize ?? 15) * uiScale),
      onErrorFallback: (error) => _Fallback(tex: tex, uiScale: uiScale),
    );

    if (!display) {
      return rendered;
    }
    // 块级公式：水平居中并允许超长公式横向滚动。
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6 * uiScale),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: rendered,
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.tex, required this.uiScale});

  final String tex;
  final double uiScale;

  @override
  Widget build(BuildContext context) {
    return Text(
      tex,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12.5 * uiScale,
        color: context.colorScheme.error,
      ),
    );
  }
}
