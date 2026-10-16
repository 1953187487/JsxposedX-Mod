import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 打字机效果嵌入按钮
class TypewriterEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'typewriter';

  @override
  Widget buttonWidget(BuildContext context) => const Text('打字机');

  @override
  String dialogTitle(BuildContext context) => '配置打字机效果';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedColor = useState('green');
        
        return FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField.formBuilder(
                  name: 'text',
                  labelText: '显示文字',
                  maxLines: 3,
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
                  initialValue: 'green',
                  builder: (field) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _colorChip('green', '绿', Colors.green, selectedColor, field),
                        _colorChip('cyan', '青', Colors.cyan, selectedColor, field),
                        _colorChip('orange', '橙', Colors.orange, selectedColor, field),
                        _colorChip('pink', '粉', Colors.pink, selectedColor, field),
                        _colorChip('purple', '紫', Colors.purple, selectedColor, field),
                        _colorChip('primary', '主色', context.theme.colorScheme.primary, selectedColor, field),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField.formBuilder(
                  name: 'speed',
                  labelText: '打字速度 (毫秒/字)',
                  hintText: '默认: 100',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                FormBuilderSwitch(
                  name: 'cursor',
                  initialValue: true,
                  title: const Text('显示光标'),
                ),
                FormBuilderSwitch(
                  name: 'loop',
                  initialValue: false,
                  title: const Text('循环播放'),
                ),
              ],
            ),
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
            BoxShadow(color: color.withOpacity(0.5), blurRadius: 6),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
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
      'color': formData['color'] ?? 'green',
      'speed': int.tryParse(formData['speed']?.toString() ?? '') ?? 100,
      'cursor': formData['cursor'] ?? true,
      'loop': formData['loop'] ?? false,
    };
  }
}
