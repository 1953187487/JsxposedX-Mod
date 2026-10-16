import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';

/// 剧透盒嵌入按钮
class SpoilerEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'spoiler';

  @override
  Widget buttonWidget(BuildContext context) => const Text('剧透');

  @override
  String dialogTitle(BuildContext context) => '配置剧透盒';

  @override
  bool get needsValidation => true;

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField.formBuilder(
            name: 'title',
            labelText: '标题 (如: 剧透警告)',
            validator: (value) {
              if (value == null || value.isEmpty) return '标题不能为空';
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextField.formBuilder(
            name: 'content',
            labelText: '隐藏内容',
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) return '内容不能为空';
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextField.formBuilder(
            name: 'hint',
            labelText: '提示语 (如: 点击查看)',
          ),
        ],
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    return {
      'title': formData['title'] ?? '剧透警告',
      'content': formData['content'] ?? '',
      'hint': formData['hint'] ?? '点击查看',
    };
  }
}
