import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 引用卡片嵌入按钮
class QuoteEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'quote';

  @override
  Widget buttonWidget(BuildContext context) => const Text('引用');

  @override
  String dialogTitle(BuildContext context) => '配置引用';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedStyle = useState('classic');
        
        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.formBuilder(
                name: 'content',
                labelText: '引用内容',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) return '内容不能为空';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextField.formBuilder(
                name: 'author',
                labelText: '作者/来源 (可选)',
              ),
              const SizedBox(height: 12),
              Text('样式', style: context.theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              FormBuilderField<String>(
                name: 'style',
                initialValue: 'classic',
                builder: (field) {
                  return Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('经典'),
                        selected: selectedStyle.value == 'classic',
                        onSelected: (_) {
                          selectedStyle.value = 'classic';
                          field.didChange('classic');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('现代'),
                        selected: selectedStyle.value == 'modern',
                        onSelected: (_) {
                          selectedStyle.value = 'modern';
                          field.didChange('modern');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('简约'),
                        selected: selectedStyle.value == 'minimal',
                        onSelected: (_) {
                          selectedStyle.value = 'minimal';
                          field.didChange('minimal');
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    return {
      'content': formData['content'] ?? '',
      'author': formData['author'] ?? '',
      'style': formData['style'] ?? 'classic',
    };
  }
}
