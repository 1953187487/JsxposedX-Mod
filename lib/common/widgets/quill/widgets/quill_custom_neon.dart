import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 霓虹灯文字渲染组件
class QuillCustomNeon extends quill.EmbedBuilder {
  @override
  String get key => 'neon';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final text = data['text'] ?? '';
    final colorName = data['color'] ?? 'cyan';
    final animate = data['animate'] ?? true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: _NeonTextWidget(
        text: text,
        colorName: colorName,
        animate: animate,
      ),
    );
  }
}

class _NeonTextWidget extends StatefulWidget {
  final String text;
  final String colorName;
  final bool animate;

  const _NeonTextWidget({
    required this.text,
    required this.colorName,
    required this.animate,
  });

  @override
  State<_NeonTextWidget> createState() => _NeonTextWidgetState();
}

class _NeonTextWidgetState extends State<_NeonTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor() {
    switch (widget.colorName) {
      case 'pink':
        return Colors.pink;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.cyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
                shadows: [
                  Shadow(
                    color: color.withOpacity(_animation.value),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.8),
                    blurRadius: 20,
                  ),
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.6),
                    blurRadius: 40,
                  ),
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.4),
                    blurRadius: 80,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
