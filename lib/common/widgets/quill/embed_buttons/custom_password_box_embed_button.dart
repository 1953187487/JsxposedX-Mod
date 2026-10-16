import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/quill/embed_buttons/quill_embed.dart';
import 'package:JsxposedX/core/utils/encrypt_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomPasswordBoxEmbedButton extends QuillEmbed {
  @override
  String get embedKey => 'custom_password_box';

  @override
  Widget buttonWidget(BuildContext context) => const Text('密码盒子');

  @override
  String dialogTitle(BuildContext context) => '配置密码盒子';

  @override
  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField.formBuilder(
            name: "password",
            labelText: "输入密码",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "密码不能为空";
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          CustomTextField.formBuilder(
            name: "description",
            maxLines: 3,
            labelText: "输入描述",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "描述不能为空";
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          CustomTextField.formBuilder(
            name: "result",
            labelText: "输入明文",
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "明文不能为空";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData) {
    final password = (formData['password'] ?? '').toString();
    final description = (formData['description'] ?? '').toString();
    final result = (formData['result'] ?? '').toString();
    final encryptedResult = EncryptUtil.aesEncrypt(result, password);
    return {'description': description, 'result': encryptedResult};
  }
}
