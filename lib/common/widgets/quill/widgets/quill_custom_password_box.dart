import 'dart:convert';

import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/encrypt_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class QuillPasswordBox extends quill.EmbedBuilder {
  @override
  String get key => 'custom_password_box';

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = embedContext.node.value.data;
    final Map<String, dynamic> buttonData = jsonDecode(data);

    final description = buttonData["description"] ?? "介绍";
    final result =
        buttonData["result"] ??
        "49lg6xQkKAJ4MlMK5TxUPvPpRuHYUnskaIeR0FMV3K1hrwCwUAnNX2cIE78Wk6R1";

    return HookBuilder(
      builder: (context) {
        final formKey = GlobalKey<FormBuilderState>();
        final isSuccess = useState(false);
        final plaintext = useState("");

        return UnconstrainedBox(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              isSuccess.value = false;
              plaintext.value = '';

              StateSetter? dialogSetState;

              CustomDialog.show(
                title: const Text('输入密码以解密'),
                hasClose: true,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    dialogSetState = setState;

                    return FormBuilder(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField.formBuilder(
                            name: "password",
                            labelText: "密码",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入密码';
                              }
                              final password = value.toString();
                              try {
                                EncryptUtil.aesDecrypt(result, password);
                                return null;
                              } catch (e) {
                                return "密码错误";
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          if (isSuccess.value)
                            CustomTextField(
                              labelText: "解密结果",
                              maxLines: 3,
                              controller: TextEditingController(
                                text: plaintext.value,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                actionButtons: [
                  TextButton(
                    onPressed: SmartDialog.dismiss,
                    child: Text(context.l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState?.saveAndValidate() == true) {
                        final password =
                            formKey.currentState?.fields["password"]?.value;
                        if (password != null) {
                          try {
                            plaintext.value = EncryptUtil.aesDecrypt(
                              result,
                              password,
                            );
                            isSuccess.value = true;
                            dialogSetState?.call(() {});
                          } catch (e) {
                            isSuccess.value = false;
                            dialogSetState?.call(() {});
                          }
                        }
                      }
                    },
                    child: const Text('解密'),
                  ),
                ],
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.theme.colorScheme.primary.withValues(alpha: 0.08),
                    context.theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.12,
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.theme.colorScheme.primary.withValues(
                    alpha: 0.15,
                  ),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 28,
                        color: context.theme.colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '密码盒子',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.theme.colorScheme.onSurface,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '点击解锁',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.theme.colorScheme.primary.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
