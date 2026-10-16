import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// 图片嵌入按钮
class ImageEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'custom_image';

  @override
  Widget buttonWidget(BuildContext context) => const Icon(Icons.image);

  @override
  String dialogTitle(BuildContext context) => '插入图片';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return FormBuilder(
      key: formKey,
      child: CustomTextField.formBuilder(
        name: 'image_url',
        labelText: '图片地址',
        hintText: '请输入可访问的图片 URL',
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '图片地址不能为空';
          }
          return null;
        },
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    final imageUrl = formData['image_url']?.toString().trim();
    if (imageUrl == null || imageUrl.isEmpty) {
      return {};
    }
    return {'url': imageUrl};
  }
}
