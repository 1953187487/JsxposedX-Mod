import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// 轮播嵌入按钮
class CarouselEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'custom_carousel';

  @override
  Widget buttonWidget(BuildContext context) => const Text('轮播');

  @override
  String dialogTitle(BuildContext context) => '配置轮播';

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
            const Text('最多支持 3 张图片 URL'),
            const SizedBox(height: 8),
            CustomTextField.formBuilder(
              name: 'image_url_1',
              labelText: '图片 1',
              hintText: '请输入图片 1 的 URL',
            ),
            const SizedBox(height: 8),
            CustomTextField.formBuilder(
              name: 'image_url_2',
              labelText: '图片 2',
              hintText: '请输入图片 2 的 URL',
            ),
            const SizedBox(height: 8),
            CustomTextField.formBuilder(
              name: 'image_url_3',
              labelText: '图片 3',
              hintText: '请输入图片 3 的 URL',
            ),
            const SizedBox(height: 8),
            FormBuilderDropdown<double>(
              name: 'aspect_radio',
              initialValue: 16 / 9,
              decoration: const InputDecoration(labelText: '比例'),
              items: const [
                DropdownMenuItem(value: 16 / 9, child: Text('16/9')),
                DropdownMenuItem(value: 4 / 3, child: Text('4/3')),
              ],
            ),
            const SizedBox(height: 8),
            FormBuilderDropdown<String>(
              name: 'scroll_direction',
              initialValue: 'horizontal',
              decoration: const InputDecoration(labelText: '滚动方向'),
              items: const [
                DropdownMenuItem(value: 'horizontal', child: Text('横向')),
                DropdownMenuItem(value: 'vertical', child: Text('纵向')),
              ],
            ),
            const SizedBox(height: 8),
            CustomTextField.formBuilder(
              name: 'height',
              labelText: '输入高度',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '高度不能为空';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    final imgsList = [
      formData['image_url_1']?.toString().trim() ?? '',
      formData['image_url_2']?.toString().trim() ?? '',
      formData['image_url_3']?.toString().trim() ?? '',
    ].where((url) => url.isNotEmpty).toList();

    return {
      'height': formData['height'],
      'scroll_direction': formData['scroll_direction'] ?? 'horizontal',
      'aspect_radio': formData['aspect_radio'] ?? 16 / 9,
      'imgs': imgsList,
    };
  }
}
