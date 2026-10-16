import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


/// 时间线嵌入按钮
class TimelineEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'timeline';

  @override
  Widget buttonWidget(BuildContext context) => const Text('时间线');

  @override
  String dialogTitle(BuildContext context) => '配置时间线';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final items = useState<List<Map<String, String>>>([
          {'time': '', 'title': '', 'desc': ''},
        ]);

        return FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('时间线节点', style: context.theme.textTheme.titleSmall),
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
                                name: 'time_$index',
                                labelText: '时间',
                                hintText: '如: 2024年1月',
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
                          name: 'title_$index',
                          labelText: '标题',
                        ),
                        const SizedBox(height: 8),
                        CustomTextField.formBuilder(
                          name: 'desc_$index',
                          labelText: '描述 (可选)',
                        ),
                      ],
                    ),
                  ),
                );
              }),
              TextButton.icon(
                onPressed: () {
                  items.value = List.from(items.value)
                    ..add({'time': '', 'title': '', 'desc': ''});
                },
                icon: const Icon(Icons.add),
                label: const Text('添加节点'),
              ),
              // 隐藏字段存储节点数量
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
      final time = formData['time_$i']?.toString() ?? '';
      final title = formData['title_$i']?.toString() ?? '';
      final desc = formData['desc_$i']?.toString() ?? '';
      if (title.isNotEmpty || time.isNotEmpty) {
        items.add({'time': time, 'title': title, 'desc': desc});
      }
    }

    return {
      'items': items,
    };
  }
}
