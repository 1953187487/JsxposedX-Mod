import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 高亮文本渲染组件
class QuillCustomHighlight extends quill.EmbedBuilder {
  @override
  String get key => 'highlight';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final text = data['text'] ?? '';
    final colorName = data['color'] ?? 'yellow';
    final style = data['style'] ?? 'marker';

    final color = _getColor(colorName);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: _buildHighlight(context, text, color, style),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'green':
        return Colors.green.shade300;
      case 'blue':
        return Colors.blue.shade300;
      case 'pink':
        return Colors.pink.shade200;
      case 'orange':
        return Colors.orange.shade300;
      case 'purple':
        return Colors.purple.shade300;
      default:
        return Colors.yellow.shade300;
    }
  }

  Widget _buildHighlight(
    BuildContext context,
    String text,
    Color color,
    String style,
  ) {
    switch (style) {
      case 'underline':
        return _buildUnderlineHighlight(context, text, color);
      case 'box':
        return _buildBoxHighlight(context, text, color);
      default:
        return _buildMarkerHighlight(context, text, color);
    }
  }

  // 荧光笔效果
  Widget _buildMarkerHighlight(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.4, 1.0],
          colors: [
            Colors.transparent,
            Colors.transparent,
            color.withOpacity(0.5),
            color.withOpacity(0.5),
          ],
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 下划线效果
  Widget _buildUnderlineHighlight(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color,
            width: 3,
          ),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 方框效果
  Widget _buildBoxHighlight(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: color.computeLuminance() > 0.5 ? Colors.black87 : null,
        ),
      ),
    );
  }
}
