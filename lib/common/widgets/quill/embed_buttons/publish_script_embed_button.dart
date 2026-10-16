import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

enum _PublishScriptType {
  xposedJs('xposed_js', 'Xposed JS'),
  fridaJs('frida_js', 'Frida JS');

  final String value;
  final String label;

  const _PublishScriptType(this.value, this.label);
}

class PublishScriptEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'publish_script';

  @override
  Widget buttonWidget(BuildContext context) => const Text('脚本');

  @override
  String dialogTitle(BuildContext context) => '配置发布脚本';

  @override
  Widget build(BuildContext context, quill.QuillController controller) {
    final formKey = GlobalKey<FormBuilderState>();

    return IconButton(
      icon: buttonWidget(context),
      onPressed: () {
        CustomDialog.show(
          title: Text(dialogTitle(context)),
          hasClose: true,
          child: buildFormContent(context, formKey),
          actionButtons: [
            TextButton(
              onPressed: SmartDialog.dismiss,
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.saveAndValidate() ?? false)) {
                  return;
                }

                final formData = formKey.currentState?.value ?? {};
                final config = buildConfigFromFormData(formData);
                SmartDialog.dismiss();

                Future.microtask(() {
                  CustomDialog.show(
                    title: const Text('发布提示'),
                    hasClose: true,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('请务必只选择 JsXposed 板块下的“脚本分享”板块。'),
                        SizedBox(height: 12),
                        Text('每个帖子只允许发布一个脚本。'),
                      ],
                    ),
                    actionButtons: [
                      TextButton(
                        onPressed: SmartDialog.dismiss,
                        child: const Text('取消'),
                      ),
                      FilledButton(
                        onPressed: () => insertToEditor(controller, config),
                        child: Text(context.l10n.confirm),
                      ),
                    ],
                  );
                });
              },
              child: Text(context.l10n.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final selectedType = useState(_PublishScriptType.xposedJs.value);

        return FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField.formBuilder(
                  name: 'title',
                  labelText: '脚本标题',
                  hintText: '请输入脚本标题',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入脚本标题';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text('脚本分类', style: context.theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                FormBuilderField<String>(
                  name: 'scriptType',
                  initialValue: selectedType.value,
                  builder: (field) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _PublishScriptType.values.map((type) {
                        final isSelected = selectedType.value == type.value;
                        return ChoiceChip(
                          label: Text(type.label),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (!selected) {
                              return;
                            }
                            selectedType.value = type.value;
                            field.didChange(type.value);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField.formBuilder(
                  name: 'targetName',
                  labelText: '目标软件名称',
                  hintText: '请输入目标软件名称',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入目标软件名称';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField.formBuilder(
                  name: 'packageName',
                  labelText: '目标软件包名',
                  hintText: '请输入目标软件包名',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入目标软件包名';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField.formBuilder(
                  name: 'description',
                  labelText: '介绍',
                  hintText: '简单介绍这个脚本是做什么的',
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                CustomTextField.formBuilder(
                  name: 'script',
                  labelText: 'JS 脚本内容',
                  hintText: '例如：Java.perform(function () { ... })',
                  maxLines: 12,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入脚本内容';
                    }
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

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    return {
      'title': _readString(formData['title']),
      'scriptType': _readString(
        formData['scriptType'],
        fallback: _PublishScriptType.xposedJs.value,
      ),
      'targetName': _readString(formData['targetName']),
      'packageName': _readString(formData['packageName']),
      'description': _readString(formData['description']),
      'script': _readString(formData['script']),
    };
  }

  String _readString(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) {
      return fallback;
    }
    return text;
  }
}
