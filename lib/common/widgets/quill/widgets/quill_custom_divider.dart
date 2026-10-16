import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 分割线渲染组件
class QuillCustomDivider extends quill.EmbedBuilder {
  @override
  String get key => 'divider';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final style = data['style'] ?? 'simple';
    final text = data['text'] ?? '';

    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: _buildDivider(context, style, text, primaryColor),
    );
  }

  Widget _buildDivider(
    BuildContext context,
    String style,
    String text,
    Color primaryColor,
  ) {
    switch (style) {
      case 'dashed':
        return _buildDashedDivider(context, text);
      case 'gradient':
        return _buildGradientDivider(context, primaryColor, text);
      case 'dots':
        return _buildDotsDivider(primaryColor);
      case 'icon':
        return _buildIconDivider(context, primaryColor, text);
      default:
        return _buildSimpleDivider(context, text);
    }
  }

  // 简单线条
  Widget _buildSimpleDivider(BuildContext context, String text) {
    if (text.isEmpty) {
      return const Divider();
    }
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  // 虚线
  Widget _buildDashedDivider(BuildContext context, String text) {
    final dashedLine = LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 5.0;
        final dashSpace = 3.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1,
              color: Colors.grey.shade400,
            );
          }),
        );
      },
    );

    if (text.isEmpty) {
      return dashedLine;
    }

    return Row(
      children: [
        Expanded(child: dashedLine),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(child: dashedLine),
      ],
    );
  }

  // 渐变
  Widget _buildGradientDivider(BuildContext context, Color primaryColor, String text) {
    final gradientLine = Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            primaryColor,
            Colors.transparent,
          ],
        ),
      ),
    );

    if (text.isEmpty) {
      return gradientLine;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        gradientLine,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Text(
            text,
            style: TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // 圆点
  Widget _buildDotsDivider(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.5 + index * 0.2),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  // 带图标
  Widget _buildIconDivider(BuildContext context, Color primaryColor, String text) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, primaryColor.withOpacity(0.3)],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: text.isNotEmpty
              ? Text(
                  text,
                  style: TextStyle(color: primaryColor, fontSize: 12),
                )
              : Icon(Icons.star, color: primaryColor, size: 16),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.3), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
