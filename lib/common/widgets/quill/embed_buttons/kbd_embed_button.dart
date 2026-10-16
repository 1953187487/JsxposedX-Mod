import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 键盘快捷键嵌入按钮
class KbdEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'kbd';

  @override
  Widget buttonWidget(BuildContext context) => const Text('按键');

  @override
  String dialogTitle(BuildContext context) => '配置快捷键';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedStyle = useState('mac');
        
        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.formBuilder(
                name: 'keys',
                labelText: '按键组合 (用 + 分隔)',
                hintText: '如: Ctrl + Shift + P',
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入按键';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text('样式', style: context.theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              FormBuilderField<String>(
                name: 'style',
                initialValue: 'mac',
                builder: (field) {
                  return Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Mac'),
                        selected: selectedStyle.value == 'mac',
                        onSelected: (_) {
                          selectedStyle.value = 'mac';
                          field.didChange('mac');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Windows'),
                        selected: selectedStyle.value == 'win',
                        onSelected: (_) {
                          selectedStyle.value = 'win';
                          field.didChange('win');
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
      'keys': formData['keys'] ?? '',
      'style': formData['style'] ?? 'mac',
    };
  }
}
