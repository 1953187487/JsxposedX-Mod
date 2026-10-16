import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 键盘快捷键渲染组件
class QuillCustomKbd extends quill.EmbedBuilder {
  @override
  String get key => 'kbd';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final keys = data['keys']?.toString() ?? '';
    final style = data['style'] ?? 'mac';

    final keyList = keys.split('+').map((k) => k.trim()).where((k) => k.isNotEmpty).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: keyList.asMap().entries.map((entry) {
          final index = entry.key;
          final keyText = _formatKey(entry.value, style);
          final isLast = index == keyList.length - 1;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildKey(context, keyText, style),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    '+',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatKey(String key, String style) {
    final upperKey = key.toUpperCase();
    
    if (style == 'mac') {
      switch (upperKey) {
        case 'CTRL':
        case 'CONTROL':
          return '⌃';
        case 'ALT':
        case 'OPTION':
          return '⌥';
        case 'SHIFT':
          return '⇧';
        case 'CMD':
        case 'COMMAND':
          return '⌘';
        case 'ENTER':
        case 'RETURN':
          return '↵';
        case 'TAB':
          return '⇥';
        case 'ESC':
        case 'ESCAPE':
          return '⎋';
        case 'BACKSPACE':
          return '⌫';
        case 'DELETE':
          return '⌦';
        case 'UP':
          return '↑';
        case 'DOWN':
          return '↓';
        case 'LEFT':
          return '←';
        case 'RIGHT':
          return '→';
        case 'SPACE':
          return '␣';
      }
    }
    
    return key;
  }

  Widget _buildKey(BuildContext context, String keyText, String style) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (style) {
      case 'mac':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [Colors.grey.shade700, Colors.grey.shade800]
                  : [Colors.grey.shade100, Colors.grey.shade300],
            ),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            keyText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        );

      case 'win':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                offset: const Offset(2, 2),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            keyText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        );

      default: // minimal
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            keyText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'monospace',
              color: theme.colorScheme.primary,
            ),
          ),
        );
    }
  }
}
