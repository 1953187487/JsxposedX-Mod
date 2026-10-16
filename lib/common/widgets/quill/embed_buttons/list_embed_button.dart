import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';

/// 列表项类型
/// 1 = 弹窗显示内容, 2 = 跳转URL
enum ListItemType {
  dialog(1, '弹窗显示'),
  url(2, '跳转链接');

  final int value;
  final String label;
  const ListItemType(this.value, this.label);
}

/// 列表嵌入按钮
class ListEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'list';

  @override
  Widget buttonWidget(BuildContext context) => const Text('列表');

  @override
  String dialogTitle(BuildContext context) => '配置列表';

  @override
  bool get needsValidation => true;

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final scrollDirection = useState<String>('vertical');
        final itemTypes = useState<List<int>>([1]); // 每个 item 的类型
        final itemCount = useState<int>(1);

        return FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 滚动方向选择
                FormBuilderField<String>(
                  name: 'scroll_direction',
                  initialValue: scrollDirection.value,
                  builder: (field) {
                    return DropdownMenu<String>(
                      initialSelection: scrollDirection.value,
                      expandedInsets: EdgeInsets.zero,
                      hintText: '滚动方向',
                      requestFocusOnTap: false,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: 'vertical', label: '纵向'),
                        DropdownMenuEntry(value: 'horizontal', label: '横向'),
                      ],
                      onSelected: (value) {
                        final newValue = value ?? 'vertical';
                        scrollDirection.value = newValue;
                        field.didChange(newValue);
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField.formBuilder(
                        name: 'width',
                        labelText: '宽度',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value == null || value.isEmpty) return '必填';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField.formBuilder(
                        name: 'height',
                        labelText: '高度',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value == null || value.isEmpty) return '必填';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField.formBuilder(
                        name: 'gap',
                        labelText: '间距',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 列表项标题
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('列表项', style: Theme.of(context).textTheme.titleMedium),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        itemCount.value++;
                        itemTypes.value = [...itemTypes.value, 1];
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 动态列表项
                ...List.generate(itemCount.value, (index) {
                  return _buildItemForm(context, index, itemCount, itemTypes);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemForm(
    BuildContext context,
    int index,
    ValueNotifier<int> itemCount,
    ValueNotifier<List<int>> itemTypes,
  ) {
    final currentType = index < itemTypes.value.length ? itemTypes.value[index] : 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行：序号 + 类型选择 + 删除
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FormBuilderField<int>(
                  name: 'item_type_$index',
                  initialValue: currentType,
                  builder: (field) {
                    return DropdownMenu<int>(
                      initialSelection: currentType,
                      expandedInsets: EdgeInsets.zero,
                      hintText: '类型',
                      requestFocusOnTap: false,
                      dropdownMenuEntries: ListItemType.values
                          .map((e) => DropdownMenuEntry(value: e.value, label: e.label))
                          .toList(),
                      onSelected: (value) {
                        final newValue = value ?? 1;
                        final newTypes = [...itemTypes.value];
                        while (newTypes.length <= index) {
                          newTypes.add(1);
                        }
                        newTypes[index] = newValue;
                        itemTypes.value = newTypes;
                        field.didChange(newValue);
                      },
                    );
                  },
                ),
              ),
              if (itemCount.value > 1)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  onPressed: () {
                    itemCount.value--;
                    final newTypes = [...itemTypes.value];
                    if (index < newTypes.length) newTypes.removeAt(index);
                    itemTypes.value = newTypes;
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          // 标题
          CustomTextField.formBuilder(
            name: 'item_title_$index',
            labelText: '标题',
            validator: (value) {
              if (value == null || value.isEmpty) return '标题不能为空';
              return null;
            },
          ),
          const SizedBox(height: 8),
          // 副标题
          CustomTextField.formBuilder(
            name: 'item_subtitle_$index',
            labelText: '副标题 (可选)',
          ),
          const SizedBox(height: 8),
          // 根据类型显示不同字段
          if (currentType == ListItemType.dialog.value)
            CustomTextField.formBuilder(
              name: 'item_content_$index',
              labelText: '弹窗内容',
              maxLines: 3,
            )
          else
            CustomTextField.formBuilder(
              name: 'item_url_$index',
              labelText: '跳转链接',
              keyboardType: TextInputType.url,
            ),
        ],
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    final items = <Map<String, dynamic>>[];
    int index = 0;
    while (formData.containsKey('item_title_$index')) {
      final title = formData['item_title_$index']?.toString() ?? '';
      if (title.isNotEmpty) {
        final type = formData['item_type_$index'] ?? 1;
        items.add({
          'title': title,
          'subtitle': formData['item_subtitle_$index']?.toString() ?? '',
          'type': type,
          'content': type == ListItemType.dialog.value
              ? formData['item_content_$index']?.toString() ?? ''
              : formData['item_url_$index']?.toString() ?? '',
        });
      }
      index++;
    }

    return {
      'width': formData['width'],
      'height': formData['height'],
      'gap': formData['gap'] ?? '8',
      'scroll_direction': formData['scroll_direction'] ?? 'vertical',
      'items': items,
    };
  }
}
