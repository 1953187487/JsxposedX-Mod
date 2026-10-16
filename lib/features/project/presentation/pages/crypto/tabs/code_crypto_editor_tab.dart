import 'package:JsxposedX/common/widgets/app_code_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:re_editor/re_editor.dart';

class CodeCryptoEditorTab extends HookWidget {
  final CodeLineEditingController controller;
  final List<String> customKeywords;

  const CodeCryptoEditorTab({
    super.key,
    required this.controller,
    required this.customKeywords,
  });

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    return AppCodeEditor(
      controller: controller,
      language: 'javascript',
      customKeywords: customKeywords,
    );
  }
}
