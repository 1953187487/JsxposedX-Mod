import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 动画计数器渲染组件
class QuillCustomCounter extends quill.EmbedBuilder {
  @override
  String get key => 'counter';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final value = data['value'] ?? 0;
    final prefix = data['prefix'] ?? '';
    final suffix = data['suffix'] ?? '';
    final label = data['label'] ?? '';
    final duration = data['duration'] ?? 2000;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: _CounterWidget(
        value: value,
        prefix: prefix,
        suffix: suffix,
        label: label,
        duration: duration,
      ),
    );
  }
}

class _CounterWidget extends StatefulWidget {
  final int value;
  final String prefix;
  final String suffix;
  final String label;
  final int duration;

  const _CounterWidget({
    required this.value,
    required this.prefix,
    required this.suffix,
    required this.label,
    required this.duration,
  });

  @override
  State<_CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<_CounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  if (widget.prefix.isNotEmpty)
                    Text(
                      widget.prefix,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: widget.value.toDouble()),
                    duration: Duration(milliseconds: widget.duration),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text(
                        _formatNumber(value.toInt()),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          height: 1,
                        ),
                      );
                    },
                  ),
                  if (widget.suffix.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        widget.suffix,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          if (widget.label.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
