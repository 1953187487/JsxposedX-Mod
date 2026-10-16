import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';

/// AI 提问卡片：渲染问答模式的 ```question 块，并提供选项作答。
///
/// - [onSubmit] 非空时表示该问题正在等待用户作答，卡片可交互；
///   为空（历史消息回看）时只做只读展示。
/// - [question.multiple] 由 AI 声明，决定渲染单选还是多选控件。
class AiQuestionCard extends StatefulWidget {
  const AiQuestionCard({
    super.key,
    required this.question,
    this.onSubmit,
  });

  final AiQuestion question;
  final ValueChanged<List<String>>? onSubmit;

  @override
  State<AiQuestionCard> createState() => _AiQuestionCardState();
}

class _AiQuestionCardState extends State<AiQuestionCard> {
  final Set<String> _selected = <String>{};

  bool get _interactive => widget.onSubmit != null;

  void _handleTap(AiQuestionOption option) {
    if (!_interactive) return;
    if (widget.question.multiple) {
      setState(() {
        if (!_selected.remove(option.label)) {
          _selected.add(option.label);
        }
      });
      return;
    }
    // 单选：点选即作答。
    setState(() {
      _selected
        ..clear()
        ..add(option.label);
    });
    widget.onSubmit!(<String>[option.label]);
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final scale = AiChatCompactScope.scaleOf(context);
    final isDark = context.isDark;
    final accent = context.colorScheme.primary;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4 * scale),
      padding: EdgeInsets.fromLTRB(12 * scale, 10 * scale, 12 * scale, 10 * scale),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(10 * scale),
        border: Border.all(color: accent.withValues(alpha: 0.18), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.help_outline_rounded,
                size: 15 * scale,
                color: accent,
              ),
              SizedBox(width: 6 * scale),
              Expanded(
                child: Text(
                  question.prompt,
                  style: TextStyle(
                    fontSize: 13 * scale,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: context.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
          if (question.multiple && _interactive) ...[
            SizedBox(height: 6 * scale),
            Text(
              context.isZh ? '可多选，选好后点击提交' : 'Multi-select, then submit',
              style: TextStyle(
                fontSize: 11 * scale,
                color: context.theme.hintColor,
              ),
            ),
          ],
          if (question.options.isNotEmpty) ...[
            SizedBox(height: 8 * scale),
            for (final option in question.options)
              _OptionTile(
                option: option,
                multiple: question.multiple,
                selected: _selected.contains(option.label),
                interactive: _interactive,
                onTap: () => _handleTap(option),
              ),
          ],
          if (question.multiple && _interactive) ...[
            SizedBox(height: 6 * scale),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _selected.isEmpty
                    ? null
                    : () => widget.onSubmit!(_selected.toList(growable: false)),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scale,
                    vertical: 6 * scale,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  context.isZh ? '提交' : 'Submit',
                  style: TextStyle(fontSize: 12 * scale),
                ),
              ),
            ),
          ],
          if (question.isOpenEnded && _interactive) ...[
            SizedBox(height: 6 * scale),
            Text(
              context.isZh ? '直接在下方的输入框里回答即可' : 'Answer in the input box below',
              style: TextStyle(
                fontSize: 11 * scale,
                color: context.theme.hintColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.multiple,
    required this.selected,
    required this.interactive,
    required this.onTap,
  });

  final AiQuestionOption option;
  final bool multiple;
  final bool selected;
  final bool interactive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final isDark = context.isDark;
    final accent = context.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(bottom: 6 * scale),
      child: InkWell(
        onTap: interactive ? onTap : null,
        borderRadius: BorderRadius.circular(8 * scale),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: 10 * scale,
            vertical: 8 * scale,
          ),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: isDark ? 0.18 : 0.12)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.white.withValues(alpha: 0.9)),
            borderRadius: BorderRadius.circular(8 * scale),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: 0.5)
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: selected ? 1 : 0.6,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1 * scale),
                child: Icon(
                  multiple
                      ? (selected
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded)
                      : (selected
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded),
                  size: 15 * scale,
                  color: selected
                      ? accent
                      : context.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                ),
              ),
              SizedBox(width: 8 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 12.5 * scale,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: context.textTheme.bodyMedium?.color,
                      ),
                    ),
                    if (option.detail != null) ...[
                      SizedBox(height: 2 * scale),
                      Text(
                        option.detail!,
                        style: TextStyle(
                          fontSize: 11 * scale,
                          height: 1.35,
                          color: context.theme.hintColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
