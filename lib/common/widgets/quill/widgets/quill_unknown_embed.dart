import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// 处理未知嵌入类型的 Builder，避免崩溃
class QuillUnknownEmbedBuilder extends quill.EmbedBuilder {
  @override
  String get key => 'unknown';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    // 返回空组件，忽略未知嵌入
    return const Text(
      "组件解析失败",
      style: TextStyle(color: Colors.redAccent, fontStyle: FontStyle.italic),
    );
  }
}
