import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 霓虹灯文字嵌入按钮
class NeonEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'neon';

  @override
  Widget buttonWidget(BuildContext context) => const Text('霓虹');

  @override
  String dialogTitle(BuildContext context) => '配置霓虹文字';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedColor = useState('cyan');
        
        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.formBuilder(
                name: 'text',
                labelText: '霓虹文字',
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入文字';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Text('颜色', style: context.theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              FormBuilderField<String>(
                name: 'color',
                initialValue: 'cyan',
                builder: (field) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _colorChip('cyan', '青', Colors.cyan, selectedColor, field),
                      _colorChip('pink', '粉', Colors.pink, selectedColor, field),
                      _colorChip('green', '绿', Colors.green, selectedColor, field),
                      _colorChip('purple', '紫', Colors.purple, selectedColor, field),
                      _colorChip('orange', '橙', Colors.orange, selectedColor, field),
                      _colorChip('red', '红', Colors.red, selectedColor, field),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              FormBuilderSwitch(
                name: 'animate',
                initialValue: true,
                title: const Text('闪烁动画'),
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
              ? Border.all(color: Colors.white, width: 2)
              : null,
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.6), blurRadius: 8),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    return {
      'text': formData['text'] ?? '',
      'color': formData['color'] ?? 'cyan',
      'animate': formData['animate'] ?? true,
    };
  }
}
