import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';

/// 步骤卡片
///
/// 解析 ```steps``` 块，每行一个步骤，字段用 | 分隔：
/// title: 搜索关键类 | desc: 调用 search_classes | status: done
/// status 可选：done / doing / todo（默认 todo）
class AiStepsCard extends StatelessWidget {
  final String rawContent;
  const AiStepsCard({super.key, required this.rawContent});

  static List<_StepItem> _parse(String raw) {
    int index = 0;
    return raw
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .map((line) {
          final fields = <String, String>{};
          for (final part in line.split('|')) {
            final idx = part.indexOf(':');
            if (idx > 0) {
              fields[part.substring(0, idx).trim()] =
                  part.substring(idx + 1).trim();
            } else {
              if (fields['title'] == null) fields['title'] = part.trim();
            }
          }
          return _StepItem(
            index: ++index,
            title: fields['title'] ?? line,
            desc: fields['desc'] ?? fields['description'],
            status: fields['status'] ?? 'todo',
          );
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final items = _parse(rawContent);
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: context.isDark
            ? context.colorScheme.surfaceContainer
            : Colors.white,
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            _StepTile(
              item: items[i],
              isLast: i == items.length - 1,
            ),
        ],
      ),
    );
  }
}

class _StepItem {
  final int index;
  final String title;
  final String? desc;
  final String status;
  const _StepItem(
      {required this.index,
      required this.title,
      this.desc,
      required this.status});
}

class _StepTile extends StatelessWidget {
  final _StepItem item;
  final bool isLast;
  const _StepTile({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final primary = context.colorScheme.primary;
    final isDark = context.isDark;

    final Color dotColor;
    final IconData dotIcon;
    switch (item.status) {
      case 'done':
        dotColor = const Color(0xFF4CAF50);
        dotIcon = Icons.check_circle;
        break;
      case 'doing':
        dotColor = primary;
        dotIcon = Icons.radio_button_checked;
        break;
      default:
        dotColor = isDark ? Colors.white24 : Colors.grey.shade300;
        dotIcon = Icons.radio_button_unchecked;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 16 * scale),
          Column(
            children: [
              SizedBox(height: 14 * scale),
              Icon(dotIcon, size: 16 * scale, color: dotColor),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: isDark
                        ? Colors.white12
                        : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 10 * scale,
                bottom: isLast ? 12 * scale : 10 * scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 18 * scale,
                        height: 18 * scale,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: dotColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${item.index}',
                          style: TextStyle(
                            fontSize: 10 * scale,
                            color: dotColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 8 * scale),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13 * scale,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.9)
                                : context.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item.desc != null) ...[  
                    SizedBox(height: 3 * scale),
                    Padding(
                      padding: EdgeInsets.only(left: 26 * scale),
                      child: Text(
                        item.desc!,
                        style: TextStyle(
                          fontSize: 12 * scale,
                          color: context.theme.hintColor,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(width: 12 * scale),
        ],
      ),
    );
  }
}
