import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart' as quill;

class QuillData {
  final List<QuillDataItem> items;

  QuillData({required this.items});

  String toQuillData() {
    final ops = <Map<String, dynamic>>[];
    for (var item in items) {
      ops.add(item.toQuillWidget());
      ops.add({"insert": "\n\n"});
    }
    final json = jsonEncode({"ops": ops});
    return json;
  }
}

class QuillDataItem {
  final String key;
  final Map<String, dynamic> config;

  QuillDataItem({required this.key, required this.config});

  Map<String, dynamic> toQuillWidget() {
    //适用测试文本环境
    return {
      "insert": {key: jsonEncode(config)},
    };
  }

  quill.BlockEmbed toQuill() {
    //适用实际使用环境
    return quill.BlockEmbed.custom(
      quill.CustomBlockEmbed(key, jsonEncode(config)),
    );
  }

  @override
  String toString() {
    return 'QuillDataItem{key: $key, config: $config}';
  }
}
