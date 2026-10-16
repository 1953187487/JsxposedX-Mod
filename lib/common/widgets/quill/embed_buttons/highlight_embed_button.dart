import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 高亮文本嵌入按钮
class HighlightEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'highlight';

  @override
  Widget buttonWidget(BuildContext context) => const Text('高亮');

  @override
  String dialogTitle(BuildContext context) => '配置高亮文本';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedColor = useState('yellow');
        final selectedStyle = useState('marker');
        
        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.formBuilder(
                name: 'text',
                labelText: '高亮文本',
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入文本';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text('颜色', style: context.theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              FormBuilderField<String>(
                name: 'color',
                initialValue: 'yellow',
                builder: (field) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _colorChip('yellow', '黄', Colors.yellow.shade300, selectedColor, field),
                      _colorChip('green', '绿', Colors.green.shade300, selectedColor, field),
                      _colorChip('blue', '蓝', Colors.blue.shade300, selectedColor, field),
                      _colorChip('pink', '粉', Colors.pink.shade200, selectedColor, field),
                      _colorChip('orange', '橙', Colors.orange.shade300, selectedColor, field),
                      _colorChip('purple', '紫', Colors.purple.shade300, selectedColor, field),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              Text('样式', style: context.theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              FormBuilderField<String>(
                name: 'style',
                initialValue: 'marker',
                builder: (field) {
                  return Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('荧光笔'),
                        selected: selectedStyle.value == 'marker',
                        onSelected: (_) {
                          selectedStyle.value = 'marker';
                          field.didChange('marker');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('下划线'),
                        selected: selectedStyle.value == 'underline',
                        onSelected: (_) {
                          selectedStyle.value = 'underline';
                          field.didChange('underline');
                        },
                      ),
                      ChoiceChip(
                        label: const Text('方框'),
                        selected: selectedStyle.value == 'box',
                        onSelected: (_) {
                          selectedStyle.value = 'box';
                          field.didChange('box');
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
  
  Widget _colorChip(
    String value,
    String label,
    Color color,
    ValueNotifier<String> selected,
    FormFieldState<String> field,
  ) {
    return GestureDetector(
      onTap: () {
        selected.value = value;
        field.didChange(value);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected.value == value
              ? Border.all(color: Colors.black, width: 2)
              : null,
          boxShadow: selected.value == value
              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    return {
      'text': formData['text'] ?? '',
      'color': formData['color'] ?? 'yellow',
      'style': formData['style'] ?? 'marker',
    };
  }
}
