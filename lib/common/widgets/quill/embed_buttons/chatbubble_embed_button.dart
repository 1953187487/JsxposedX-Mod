import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 对话气泡嵌入按钮
class ChatBubbleEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'chatbubble';

  @override
  Widget buttonWidget(BuildContext context) => const Text('气泡');

  @override
  String dialogTitle(BuildContext context) => '配置对话气泡';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return HookBuilder(
      builder: (context) {
        final isRight = useState(false);
        
        return FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField.formBuilder(
                  name: 'name',
                  labelText: '发送者名称',
                  hintText: '如: 小明',
                ),
                const SizedBox(height: 12),
                CustomTextField.formBuilder(
                  name: 'message',
                  labelText: '消息内容',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '请输入消息';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text('气泡位置', style: context.theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                FormBuilderField<bool>(
                  name: 'isRight',
                  initialValue: false,
                  builder: (field) {
                    return Row(
                      children: [
                        ChoiceChip(
                          label: const Text('左侧'),
                          selected: !isRight.value,
                          onSelected: (_) {
                            isRight.value = false;
                            field.didChange(false);
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('右侧'),
                          selected: isRight.value,
                          onSelected: (_) {
                            isRight.value = true;
                            field.didChange(true);
                          },
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
    return {
      'name': formData['name'] ?? '',
      'message': formData['message'] ?? '',
      'isRight': formData['isRight'] ?? false,
    };
  }
}
