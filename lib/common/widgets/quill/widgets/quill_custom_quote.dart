import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 引用卡片渲染组件
class QuillCustomQuote extends quill.EmbedBuilder {
  @override
  String get key => 'quote';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final content = data['content'] ?? '';
    final author = data['author'] ?? '';
    final style = data['style'] ?? 'classic';

    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _buildQuoteByStyle(context, content, author, style, primaryColor),
    );
  }

  Widget _buildQuoteByStyle(
    BuildContext context,
    String content,
    String author,
    String style,
    Color primaryColor,
  ) {
    switch (style) {
      case 'modern':
        return _buildModernQuote(context, content, author, primaryColor);
      case 'minimal':
        return _buildMinimalQuote(context, content, author, primaryColor);
      default:
        return _buildClassicQuote(context, content, author, primaryColor);
    }
  }

  // 经典样式 - 左边框 + 引号图标
  Widget _buildClassicQuote(
    BuildContext context,
    String content,
    String author,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: primaryColor, width: 4),
        ),
        color: primaryColor.withOpacity(0.05),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.format_quote, color: primaryColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          if (author.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '— $author',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 现代样式 - 渐变背景 + 大引号
  Widget _buildModernQuote(
    BuildContext context,
    String content,
    String author,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            left: -5,
            child: Text(
              '"',
              style: TextStyle(
                fontSize: 60,
                color: primaryColor.withOpacity(0.2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
              if (author.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 2,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      author,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // 简约样式 - 只有左边框
  Widget _buildMinimalQuote(
    BuildContext context,
    String content,
    String author,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: primaryColor.withOpacity(0.5), width: 2),
        ),
      ),
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
            ),
          ),
          if (author.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '— $author',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: primaryColor.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
