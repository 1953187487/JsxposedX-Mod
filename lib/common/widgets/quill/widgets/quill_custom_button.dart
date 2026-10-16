import 'dart:convert';

import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class QuillCustomButton extends quill.EmbedBuilder {
  @override
  String get key => 'custom_button';

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = embedContext.node.value.data;
    final Map<String, dynamic> buttonData = jsonDecode(data);

    final width = double.parse(buttonData["width"]?.toString() ?? "100");
    final height = double.parse(buttonData["height"]?.toString() ?? "40");
    final text = buttonData["title"] ?? "按钮";
    final url = buttonData["url"] ?? "";
    return UnconstrainedBox(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: width > MediaQuery.of(context).size.width * 0.9
            ? MediaQuery.of(context).size.width * 0.9
            : width,
        height: height > 600 ? 600 : height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            UrlHelper.openUrlInBrowser(url: url);
          },
          child: Text(text, overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
      ),
    );
  }
}
