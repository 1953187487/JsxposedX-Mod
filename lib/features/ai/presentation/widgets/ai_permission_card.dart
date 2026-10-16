import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';

/// 权限列表卡片
///
/// 解析 ```permissions``` 块，每行一条，字段用 | 分隔：
/// name: android.permission.CAMERA | level: dangerous | desc: 访问摄像头
/// level 可选：normal / dangerous / signature（默认 normal）
class AiPermissionCard extends StatelessWidget {
  final String rawContent;
  const AiPermissionCard({super.key, required this.rawContent});

  static List<_PermItem> _parse(String raw) {
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
              if (fields['name'] == null) fields['name'] = part.trim();
            }
          }
          return _PermItem(
            name: fields['name'] ?? fields['permission'] ?? line,
            level: fields['level'] ?? fields['protection'] ?? 'normal',
            desc: fields['desc'] ?? fields['description'],
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
          _PermTile(item: items[i], isLast: i == items.length - 1),
      ],
    );
  }
}

class _PermItem {
  final String name;
  final String level;
  final String? desc;
  const _PermItem({required this.name, required this.level, this.desc});
}

class _PermTile extends StatelessWidget {
  final _PermItem item;
  final bool isLast;
  const _PermTile({required this.item, required this.isLast});

  static _LevelStyle _style(_PermItem item, BuildContext ctx) {
    switch (item.level.toLowerCase()) {
      case 'dangerous':
        return _LevelStyle(
          color: const Color(0xFFF44336),
          bg: const Color(0xFFFFF1F1),
          bgDark: const Color(0xFF2E1B1B),
          label: '危险',
          icon: Icons.warning_amber_rounded,
        );
      case 'signature':
        return _LevelStyle(
          color: const Color(0xFFFF9800),
          bg: const Color(0xFFFFF8F0),
          bgDark: const Color(0xFF2E2318),
          label: '签名',
          icon: Icons.lock_outline,
        );
      default:
        return _LevelStyle(
          color: const Color(0xFF4CAF50),
          bg: const Color(0xFFF1F8F1),
          bgDark: const Color(0xFF1B2E1B),
          label: '普通',
          icon: Icons.info_outline,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = AiChatCompactScope.scaleOf(context);
    final isDark = context.isDark;
    final s = _style(item, context);
    final shortName = item.name.contains('.')
        ? item.name.split('.').last
        : item.name;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 5 * scale),
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 9 * scale,
      ),
      decoration: BoxDecoration(
        color: isDark ? s.bgDark : s.bg,
        borderRadius: BorderRadius.circular(10 * scale),
        border:
            Border.all(color: s.color.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Row(
        children: [
          Icon(s.icon, size: 15 * scale, color: s.color),
          SizedBox(width: 8 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortName,
                  style: TextStyle(
                    fontSize: 12.5 * scale,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.9)
                        : context.textTheme.bodyMedium?.color,
                  ),
                ),
                if (item.desc != null) ...[  
                  SizedBox(height: 2 * scale),
                  Text(
                    item.desc!,
                    style: TextStyle(
                      fontSize: 11 * scale,
                      color: context.theme.hintColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8 * scale),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 7 * scale,
              vertical: 2 * scale,
            ),
            decoration: BoxDecoration(
              color: s.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4 * scale),
            ),
            child: Text(
              s.label,
              style: TextStyle(
                fontSize: 10 * scale,
                color: s.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelStyle {
  final Color color;
  final Color bg;
  final Color bgDark;
  final String label;
  final IconData icon;
  const _LevelStyle({
    required this.color,
    required this.bg,
    required this.bgDark,
    required this.label,
    required this.icon,
  });
}
