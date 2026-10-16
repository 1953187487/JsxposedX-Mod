import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/quill/data/quill_data.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// Quill 嵌入按钮抽象基类
abstract class QuillEmbed {
  String get embedKey;

  Widget buttonWidget(BuildContext context);

  String dialogTitle(BuildContext context);

  bool get needsValidation => true;

  Widget buildFormContent(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
  );

  Map<String, dynamic> buildConfigFromFormData(Map<String, dynamic> formData);

  void insertToEditor(
    quill.QuillController controller,
    Map<String, dynamic> config,
  ) {
    final item = QuillDataItem(key: embedKey, config: config);
    final index = controller.selection.baseOffset;
    controller.document.insert(index, item.toQuill());
    controller.updateSelection(
      TextSelection.collapsed(offset: index + 1),
      quill.ChangeSource.local,
    );
    SmartDialog.dismiss();
  }

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
                if (needsValidation) {
                  if (!(formKey.currentState?.saveAndValidate() ?? false)) {
                    return;
                  }
                } else {
                  formKey.currentState?.save();
                }
                final formData = formKey.currentState?.value ?? {};
                final config = buildConfigFromFormData(formData);
                insertToEditor(controller, config);
              },
              child: Text(context.l10n.confirm),
            ),
          ],
        );
      },
    );
  }
}
