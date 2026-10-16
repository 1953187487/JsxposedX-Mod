import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';

/// 标签云嵌入按钮
class TagsEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'tags';

  @override
  Widget buttonWidget(BuildContext context) => const Text('标签');

  @override
  String dialogTitle(BuildContext context) => '配置标签云';

  @override
  bool get needsValidation => true;

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final tags = useState<List<String>>(['']);
        final colorScheme = Theme.of(context).colorScheme;

        return FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('标签列表', style: Theme.of(context).textTheme.titleSmall),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
                    onPressed: () {
                      tags.value = [...tags.value, ''];
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...tags.value.asMap().entries.map((entry) {
                final index = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _getTagColor(index),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomTextField.formBuilder(
                          name: 'tag_$index',
                          labelText: '标签 ${index + 1}',
                          validator: (value) {
                            if (index == 0 && (value == null || value.isEmpty)) {
                              return '至少输入一个标签';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (tags.value.length > 1)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () {
                            final newTags = [...tags.value];
                            newTags.removeAt(index);
                            tags.value = newTags;
                          },
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Color _getTagColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    final tags = <String>[];
    int index = 0;
    while (formData.containsKey('tag_$index')) {
      final tag = formData['tag_$index']?.toString() ?? '';
      if (tag.isNotEmpty) {
        tags.add(tag);
      }
      index++;
    }

    return {
      'tags': tags,
    };
  }
}
