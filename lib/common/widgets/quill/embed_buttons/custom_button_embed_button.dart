import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 可用的应用内路由列表
const List<Map<String, String>> _appRoutes = [
  {'label': '首页', 'route': '/home'},
  {'label': '搜索', 'route': '/search'},
  {'label': '通知', 'route': '/notification'},
  {'label': '设置', 'route': '/setup'},
  {'label': '商城', 'route': '/shop'},
  {'label': '我的收藏', 'route': '/my-favorite'},
  {'label': '我的门票', 'route': '/my-tickets'},
  {'label': 'VIP购买', 'route': '/vip-purchase'},
  {'label': '每日推荐', 'route': '/app-daily-recommend'},
  {'label': '盒子推荐', 'route': '/app-box-recommend'},
  {'label': '商务合作', 'route': '/handshake'},
  {'label': '板块列表', 'route': '/post-category-list'},
  {'label': '兑换商城', 'route': '/exchange-shop'},
  {'label': '钱包', 'route': '/wallet'},
  {'label': '任务中心', 'route': '/mission'},
  {'label': '创作中心', 'route': '/creator'},
];

/// 自定义按钮嵌入按钮
class CustomButtonEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'custom_button';

  @override
  Widget buttonWidget(BuildContext context) => const Text('按钮');

  @override
  String dialogTitle(BuildContext context) => '配置按钮';

  @override
  bool get needsValidation => true;

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    int selectedType = 1;
    String? selectedRoute;

    return StatefulBuilder(
      builder: (context, setState) {
        return FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField.formBuilder(
                  name: 'title',
                  labelText: '输入按钮标题',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '按钮标题不能为空';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CustomTextField.formBuilder(
                  name: 'width',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  labelText: '输入宽度',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '宽度不能为空';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                CustomTextField.formBuilder(
                  name: 'height',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  labelText: '输入高度',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '高度不能为空';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text('跳转类型', style: context.theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('外部链接'),
                      selected: selectedType == 1,
                      onSelected: (_) {
                        setState(() => selectedType = 1);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('应用内页面'),
                      selected: selectedType == 2,
                      onSelected: (_) {
                        setState(() => selectedType = 2);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (selectedType == 1)
                  CustomTextField.formBuilder(
                    name: 'url',
                    labelText: '输入链接',
                    hintText: 'https://...',
                  )
                else
                  FormBuilderField<String>(
                    name: 'route',
                    initialValue: selectedRoute,
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('选择页面', style: context.theme.textTheme.bodySmall),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _appRoutes.map((r) {
                              final isSelected = selectedRoute == r['route'];
                              return ChoiceChip(
                                label: Text(r['label']!),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() => selectedRoute = r['route']);
                                  field.didChange(r['route']);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      );
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
    final type = formData['route'] != null ? 2 : 1;
    return {
      'width': formData['width'],
      'height': formData['height'],
      'title': formData['title'],
      'url': formData['url'],
      'route': formData['route'],
      'type': type,
    };
  }
}
