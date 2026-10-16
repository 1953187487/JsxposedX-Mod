import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';

/// 进度条颜色主题
enum ProgressTheme {
  blue('blue', '蓝色', Colors.blue),
  green('green', '绿色', Colors.green),
  orange('orange', '橙色', Colors.orange),
  purple('purple', '紫色', Colors.purple),
  red('red', '红色', Colors.red),
  teal('teal', '青色', Colors.teal);

  final String value;
  final String label;
  final Color color;
  const ProgressTheme(this.value, this.label, this.color);
}

/// 进度条嵌入按钮
class ProgressEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'progress';

  @override
  Widget buttonWidget(BuildContext context) => const Text('进度');

  @override
  String dialogTitle(BuildContext context) => '配置进度条';

  @override
  bool get needsValidation => true;

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedTheme = useState<String>('blue');
        final percentage = useState<double>(50);

        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField.formBuilder(
                name: 'title',
                labelText: '标题 (如: 任务进度)',
                validator: (value) {
                  if (value == null || value.isEmpty) return '标题不能为空';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 百分比滑块
              Text('进度: ${percentage.value.toInt()}%'),
              FormBuilderField<double>(
                name: 'percentage',
                initialValue: percentage.value,
                builder: (field) {
                  return Slider(
                    value: percentage.value,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${percentage.value.toInt()}%',
                    onChanged: (value) {
                      percentage.value = value;
                      field.didChange(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              // 颜色主题
              Text('颜色主题', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              FormBuilderField<String>(
                name: 'theme',
                initialValue: selectedTheme.value,
                builder: (field) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ProgressTheme.values.map((theme) {
                      final isSelected = selectedTheme.value == theme.value;
                      return GestureDetector(
                        onTap: () {
                          selectedTheme.value = theme.value;
                          field.didChange(theme.value);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.color : theme.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.color),
                          ),
                          child: Text(
                            theme.label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : theme.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomTextField.formBuilder(
                name: 'subtitle',
                labelText: '副标题 (可选, 如: 3/10 已完成)',
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
      'title': formData['title'] ?? '进度',
      'percentage': formData['percentage'] ?? 50.0,
      'theme': formData['theme'] ?? 'blue',
      'subtitle': formData['subtitle'] ?? '',
    };
  }
}
