import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 提示卡片类型配置
class _CalloutConfig {
  final IconData icon;
  final Color color;

  const _CalloutConfig(this.icon, this.color);

  static _CalloutConfig fromType(String type) {
    switch (type) {
      case 'success':
        return const _CalloutConfig(Icons.check_circle_outline, Colors.green);
      case 'warning':
        return const _CalloutConfig(Icons.warning_amber, Colors.orange);
      case 'error':
        return const _CalloutConfig(Icons.error_outline, Colors.red);
      case 'info':
      default:
        return const _CalloutConfig(Icons.info_outline, Colors.blue);
    }
  }
}

/// 提示卡片组件 - Info/Success/Warning/Error
class QuillCustomCallout extends quill.EmbedBuilder {
  @override
  String get key => 'callout';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final Map<String, dynamic> data = jsonDecode(embedContext.node.value.data);
    final type = data['type']?.toString() ?? 'info';
    final title = data['title']?.toString() ?? '';
    final content = data['content']?.toString() ?? '';

    final config = _CalloutConfig.fromType(type);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: config.color,
            width: 4,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图标
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: config.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                color: config.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty) ...[
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: config.color.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.85),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
