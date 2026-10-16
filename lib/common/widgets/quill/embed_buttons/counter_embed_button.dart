import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';

/// 动画计数器嵌入按钮
class CounterEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'counter';

  @override
  Widget buttonWidget(BuildContext context) => const Text('计数');

  @override
  String dialogTitle(BuildContext context) => '配置动画计数器';

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
            name: 'value',
            labelText: '目标数值',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入数值';
              if (int.tryParse(value) == null) return '请输入有效数字';
              return null;
            },
          ),
          const SizedBox(height: 12),
          CustomTextField.formBuilder(
            name: 'prefix',
            labelText: '前缀 (可选)',
            hintText: '如: ¥',
          ),
          const SizedBox(height: 12),
          CustomTextField.formBuilder(
            name: 'suffix',
            labelText: '后缀 (可选)',
            hintText: '如: 人、次、+',
          ),
          const SizedBox(height: 12),
          CustomTextField.formBuilder(
            name: 'label',
            labelText: '标签说明 (可选)',
            hintText: '如: 用户数量',
          ),
          const SizedBox(height: 12),
          CustomTextField.formBuilder(
            name: 'duration',
            labelText: '动画时长 (毫秒)',
            hintText: '默认: 2000',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    return {
      'value': int.tryParse(formData['value']?.toString() ?? '') ?? 0,
      'prefix': formData['prefix'] ?? '',
      'suffix': formData['suffix'] ?? '',
      'label': formData['label'] ?? '',
      'duration': int.tryParse(formData['duration']?.toString() ?? '') ?? 2000,
    };
  }
}
