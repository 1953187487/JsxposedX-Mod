import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';

/// 提示卡片类型
enum CalloutType {
  info('info', '信息', Icons.info_outline, Colors.blue),
  success('success', '成功', Icons.check_circle_outline, Colors.green),
  warning('warning', '警告', Icons.warning_amber, Colors.orange),
  error('error', '错误', Icons.error_outline, Colors.red);

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const CalloutType(this.value, this.label, this.icon, this.color);
}

/// 提示卡片嵌入按钮
class CalloutEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'callout';

  @override
  Widget buttonWidget(BuildContext context) => const Text('提示');

  @override
  String dialogTitle(BuildContext context) => '配置提示卡片';

  @override
  bool get needsValidation => true;

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedType = useState<String>('info');

        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 类型选择
              Text('类型', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              FormBuilderField<String>(
                name: 'type',
                initialValue: selectedType.value,
                builder: (field) {
                  return Wrap(
                    spacing: 8,
                    children: CalloutType.values.map((type) {
                      final isSelected = selectedType.value == type.value;
                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(type.icon, size: 16, color: isSelected ? Colors.white : type.color),
                            const SizedBox(width: 4),
                            Text(type.label),
                          ],
                        ),
                        selected: isSelected,
                        selectedColor: type.color,
                        onSelected: (selected) {
                          if (selected) {
                            selectedType.value = type.value;
                            field.didChange(type.value);
                          }
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomTextField.formBuilder(
                name: 'title',
                labelText: '标题 (可选)',
              ),
              const SizedBox(height: 12),
              CustomTextField.formBuilder(
                name: 'content',
                labelText: '内容',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) return '内容不能为空';
                  return null;
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
      'type': formData['type'] ?? 'info',
      'title': formData['title'] ?? '',
      'content': formData['content'] ?? '',
    };
  }
}
