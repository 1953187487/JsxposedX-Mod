import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';

/// 3D 翻转卡片嵌入按钮
class FlipCardEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'flipcard';

  @override
  Widget buttonWidget(BuildContext context) => const Text('翻转卡');

  @override
  String dialogTitle(BuildContext context) => '配置翻转卡片';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField.formBuilder(
              name: 'front_title',
              labelText: '正面标题',
              validator: (value) {
                if (value == null || value.isEmpty) return '请输入标题';
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextField.formBuilder(
              name: 'front_content',
              labelText: '正面内容',
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            CustomTextField.formBuilder(
              name: 'back_title',
              labelText: '背面标题',
              validator: (value) {
                if (value == null || value.isEmpty) return '请输入标题';
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextField.formBuilder(
              name: 'back_content',
              labelText: '背面内容',
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    return {
      'front_title': formData['front_title'] ?? '',
      'front_content': formData['front_content'] ?? '',
      'back_title': formData['back_title'] ?? '',
      'back_content': formData['back_content'] ?? '',
    };
  }
}
