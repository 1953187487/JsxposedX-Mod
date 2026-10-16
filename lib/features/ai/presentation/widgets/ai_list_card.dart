import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AI 输出的结构化列表组件
///
/// 解析如下格式（每行一条，字段用 | 分隔，字段格式为 `key: value`）：
/// ```list
/// title: com.example.VipManager | desc: VIP管理类 | tag: vip
/// title: com.example.PayManager | desc: 支付管理
/// ```
/// 若无 | 分隔，则整行作为 title 显示。
class AiListCard extends StatelessWidget {
  final String rawContent;

  const AiListCard({super.key, required this.rawContent});

  static List<_ListItem> _parse(String raw) {
    return raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map((line) {
          final fields = <String, String>{};
          final parts = line.split('|');
          for (final part in parts) {
            final idx = part.indexOf(':');
            if (idx > 0) {
              final key = part.substring(0, idx).trim();
              final value = part.substring(idx + 1).trim();
              fields[key] = value;
            } else {
              fields['title'] = part.trim();
            }
          }
          return _ListItem(
            title: fields['title'] ?? fields.values.firstOrNull ?? line,
            desc: fields['desc'] ?? fields['description'],
            tag: fields['tag'] ?? fields['type'],
            extra: fields['extra'] ?? fields['info'],
          );
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _parse(rawContent);
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < items.length; i++)
          _AiListItemTile(
            item: items[i],
            isLast: i == items.length - 1,
          ),
      ],
    );
  }
}

class _ListItem {
  final String title;
  final String? desc;
  final String? tag;
  final String? extra;

  const _ListItem({
    required this.title,
    this.desc,
    this.tag,
    this.extra,
  });
}

class _AiListItemTile extends StatelessWidget {
  final _ListItem item;
  final bool isLast;

  const _AiListItemTile({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final primaryColor = context.colorScheme.primary;
    final isDark = context.isDark;

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: item.title));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '已复制: ${item.title}',
              style: TextStyle(fontSize: 13 * scale),
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8 * scale),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 6 * scale),
        padding: EdgeInsets.symmetric(
          horizontal: 12 * scale,
          vertical: 10 * scale,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? primaryColor.withValues(alpha: 0.08)
              : primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10 * scale),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.15),
            width: 0.8,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 4 * scale),
              width: 6 * scale,
              height: 6 * scale,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13 * scale,
                            fontFamily: 'monospace',
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.9)
                                : context.textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (item.tag != null) ...[  
                        SizedBox(width: 8 * scale),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6 * scale,
                            vertical: 2 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4 * scale),
                          ),
                          child: Text(
                            item.tag!,
                            style: TextStyle(
                              fontSize: 10 * scale,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.desc != null) ...[  
                    SizedBox(height: 3 * scale),
                    Text(
                      item.desc!,
                      style: TextStyle(
                        fontSize: 12 * scale,
                        color: context.theme.hintColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (item.extra != null) ...[  
                    SizedBox(height: 2 * scale),
                    Text(
                      item.extra!,
                      style: TextStyle(
                        fontSize: 11 * scale,
                        color: context.theme.hintColor.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
