import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 分割线嵌入按钮
class DividerEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'divider';

  @override
  Widget buttonWidget(BuildContext context) => const Text('分割');

  @override
  String dialogTitle(BuildContext context) => '配置分割线';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedStyle = useState('simple');
        
        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('样式', style: context.theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              FormBuilderField<String>(
                name: 'style',
                initialValue: 'simple',
                builder: (field) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('线条'),
                        selected: selectedStyle.value == 'simple',
                        onSelected: (_) {
                          selectedStyle.value = 'simple';
                          field.didChange('simple');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('虚线'),
                        selected: selectedStyle.value == 'dashed',
                        onSelected: (_) {
                          selectedStyle.value = 'dashed';
                          field.didChange('dashed');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('渐变'),
                        selected: selectedStyle.value == 'gradient',
                        onSelected: (_) {
                          selectedStyle.value = 'gradient';
                          field.didChange('gradient');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('圆点'),
                        selected: selectedStyle.value == 'dots',
                        onSelected: (_) {
                          selectedStyle.value = 'dots';
                          field.didChange('dots');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('图标'),
                        selected: selectedStyle.value == 'icon',
                        onSelected: (_) {
                          selectedStyle.value = 'icon';
                          field.didChange('icon');
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomTextField.formBuilder(
                name: 'text',
                labelText: '中间文字 (可选)',
                hintText: '如: 或者',
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
      'style': formData['style'] ?? 'simple',
      'text': formData['text'] ?? '',
    };
  }
}
