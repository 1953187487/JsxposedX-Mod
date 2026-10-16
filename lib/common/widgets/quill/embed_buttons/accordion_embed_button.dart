import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


/// 折叠面板嵌入按钮
class AccordionEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'accordion';

  @override
  Widget buttonWidget(BuildContext context) => const Text('折叠');

  @override
  String dialogTitle(BuildContext context) => '配置折叠面板';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final items = useState<List<Map<String, String>>>([
          {'title': '', 'content': ''},
        ]);

        return FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('折叠项', style: context.theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              ...items.value.asMap().entries.map((entry) {
                final index = entry.key;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: context.theme.colorScheme.primary,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomTextField.formBuilder(
                                name: 'title_$index',
                                labelText: '标题',
                              ),
                            ),
                            if (items.value.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                onPressed: () {
                                  items.value = List.from(items.value)..removeAt(index);
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomTextField.formBuilder(
                          name: 'content_$index',
                          labelText: '内容',
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              TextButton.icon(
                onPressed: () {
                  items.value = List.from(items.value)
                    ..add({'title': '', 'content': ''});
                },
                icon: const Icon(Icons.add),
                label: const Text('添加折叠项'),
              ),
              FormBuilderField<int>(
                name: 'item_count',
                initialValue: items.value.length,
                builder: (field) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    field.didChange(items.value.length);
                  });
                  return const SizedBox.shrink();
                },
              ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    final count = formData['item_count'] as int? ?? 1;
    final items = <Map<String, String>>[];
    
    for (int i = 0; i < count; i++) {
      final title = formData['title_$i']?.toString() ?? '';
      final content = formData['content_$i']?.toString() ?? '';
      if (title.isNotEmpty) {
        items.add({'title': title, 'content': content});
      }
    }

    return {
      'items': items,
    };
  }
}
