import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 代码块渲染组件
class QuillCustomCodeBlock extends quill.EmbedBuilder {
  @override
  String get key => 'codeblock';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = jsonDecode(embedContext.node.value.data);
    final language = data['language'] ?? 'dart';
    final filename = data['filename'] ?? '';
    final code = data['code'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _CodeBlockWidget(
        language: language,
        filename: filename,
        code: code,
      ),
    );
  }
}

class _CodeBlockWidget extends StatefulWidget {
  final String language;
  final String filename;
  final String code;

  const _CodeBlockWidget({
    required this.language,
    required this.filename,
    required this.code,
  });

  @override
  State<_CodeBlockWidget> createState() => _CodeBlockWidgetState();
}

class _CodeBlockWidgetState extends State<_CodeBlockWidget> {
  bool _copied = false;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Color _getLanguageColor() {
    switch (widget.language) {
      case 'dart':
        return Colors.blue;
      case 'javascript':
        return Colors.yellow.shade700;
      case 'python':
        return Colors.green;
      case 'java':
        return Colors.orange;
      case 'cpp':
        return Colors.purple;
      case 'html':
        return Colors.red;
      case 'css':
        return Colors.pink;
      case 'sql':
        return Colors.teal;
      case 'shell':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langColor = _getLanguageColor();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 顶部栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                // 三个小圆点
                Row(
                  children: [
                    _dot(Colors.red.shade400),
                    const SizedBox(width: 6),
                    _dot(Colors.yellow.shade600),
                    const SizedBox(width: 6),
                    _dot(Colors.green.shade400),
                  ],
                ),
                const SizedBox(width: 16),
                // 语言标签
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: langColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: langColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    widget.language.toUpperCase(),
                    style: TextStyle(
                      color: langColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.filename.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Text(
                    widget.filename,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ],
                const Spacer(),
                // 复制按钮
                InkWell(
                  onTap: _copyCode,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _copied ? Icons.check : Icons.copy,
                          size: 14,
                          color: _copied ? Colors.green : Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _copied ? '已复制' : '复制',
                          style: TextStyle(
                            color:
                                _copied ? Colors.green : Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 代码内容
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                widget.code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Color(0xFFD4D4D4),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
