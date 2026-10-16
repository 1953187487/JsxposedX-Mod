import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 代码块嵌入按钮
class CodeBlockEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'codeblock';

  @override
  Widget buttonWidget(BuildContext context) => const Text('代码');

  @override
  String dialogTitle(BuildContext context) => '配置代码块';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedLang = useState('dart');
        
        return FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('编程语言', style: context.theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                FormBuilderField<String>(
                  name: 'language',
                  initialValue: 'dart',
                  builder: (field) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _langChip('dart', 'Dart', selectedLang, field),
                        _langChip('javascript', 'JS', selectedLang, field),
                        _langChip('python', 'Python', selectedLang, field),
                        _langChip('java', 'Java', selectedLang, field),
                        _langChip('cpp', 'C++', selectedLang, field),
                        _langChip('html', 'HTML', selectedLang, field),
                        _langChip('css', 'CSS', selectedLang, field),
                        _langChip('sql', 'SQL', selectedLang, field),
                        _langChip('shell', 'Shell', selectedLang, field),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField.formBuilder(
                  name: 'filename',
                  labelText: '文件名 (可选)',
                  hintText: '如: main.dart',
                ),
                const SizedBox(height: 12),
                CustomTextField.formBuilder(
                  name: 'code',
                  labelText: '代码内容',
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '请输入代码';
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _langChip(
    String value,
    String label,
    ValueNotifier<String> selected,
    FormFieldState<String> field,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: selected.value == value,
      onSelected: (_) {
        selected.value = value;
        field.didChange(value);
      },
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    return {
      'language': formData['language'] ?? 'dart',
      'filename': formData['filename'] ?? '',
      'code': formData['code'] ?? '',
    };
  }
}
