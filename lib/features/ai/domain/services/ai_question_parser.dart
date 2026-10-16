import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';

/// 解析 AI 提问协议的 fenced 代码块。
///
/// 协议格式（```question 代码块）：
///
/// ```text
/// ```question
/// multiple: true
/// prompt: 你想先分析哪个方向？
/// - 登录校验流程
/// - 网络请求签名 | 涉及加解密
/// ```
/// ```
///
/// 约定：
/// - `prompt:` 开头的行为问题正文（必需）。
/// - `multiple:` 声明单选 / 多选，缺省为 false（单选）。
/// - `- ` 开头的行为选项；`|` 之后为选项补充说明（可选）。
/// - 没有选项时视为开放题，由用户在输入框自由作答。
class AiQuestionParser {
  AiQuestionParser._();

  static final RegExp _fence = RegExp(
    r'```question\s*\n([\s\S]*?)(?:\n?```|$)',
    caseSensitive: false,
  );
  static final RegExp _optionLine = RegExp(r'^\s*[-*+]\s*(\S.*)$');
  static final RegExp _promptLine = RegExp(
    r'^\s*(?:prompt|question|问题)\s*[:：]\s*(.*)$',
    caseSensitive: false,
  );
  static final RegExp _multipleLine = RegExp(
    r'^\s*(?:multiple|multi|多选)\s*[:：]\s*(true|false|yes|no|1|0)\s*$',
    caseSensitive: false,
  );

  /// 从单条文本中解析出提问；没有提问块时返回 null。
  static AiQuestion? parse(String content) {
    final match = _fence.firstMatch(content);
    if (match == null) return null;
    return _parseBlock(match.group(1) ?? '');
  }

  /// 解析代码块「内部正文」（不含 ``` 围栏）。
  ///
  /// Markdown 渲染器把 fenced 代码块交给元素构建器时只给出内部文本，
  /// 因此卡片渲染走这个入口，而不是 [parse]。
  static AiQuestion? parseBlockBody(String body) => _parseBlock(body);

  /// 解析一段 question 块正文。
  static AiQuestion? _parseBlock(String block) {
    String? prompt;
    var multiple = false;
    final options = <AiQuestionOption>[];

    for (final rawLine in block.split('\n')) {
      final line = rawLine.trimRight();
      if (line.trim().isEmpty) continue;

      final multipleMatch = _multipleLine.firstMatch(line);
      if (multipleMatch != null) {
        final value = multipleMatch.group(1)!.toLowerCase();
        multiple = value == 'true' || value == 'yes' || value == '1';
        continue;
      }

      final promptMatch = _promptLine.firstMatch(line);
      if (promptMatch != null) {
        prompt = promptMatch.group(1)!.trim();
        continue;
      }

      final optionMatch = _optionLine.firstMatch(line);
      if (optionMatch != null) {
        final body = optionMatch.group(1)!.trim();
        final separator = body.indexOf('|');
        if (separator < 0) {
          options.add(AiQuestionOption(label: body));
        } else {
          final label = body.substring(0, separator).trim();
          final detail = body.substring(separator + 1).trim();
          if (label.isNotEmpty) {
            options.add(
              AiQuestionOption(
                label: label,
                detail: detail.isEmpty ? null : detail,
              ),
            );
          }
        }
        continue;
      }

      // 既不是元信息也不是选项，且还没有正文时，退化为把首行当问题。
      prompt ??= line.trim();
    }

    if (prompt == null || prompt.isEmpty) return null;
    return AiQuestion(
      prompt: prompt,
      options: List.unmodifiable(options),
      multiple: multiple,
    );
  }
}
