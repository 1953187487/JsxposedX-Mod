import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_text_input_context_menu.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_pointer_expression.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemoryToolLocateExpressionDialog extends HookWidget {
  const MemoryToolLocateExpressionDialog({
    super.key,
    required this.onConfirm,
    required this.onClose,
  });

  final Future<void> Function(MemoryToolPointerExpression expression) onConfirm;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final isSubmitting = useState(false);
    useListenable(controller);

    final rawInput = controller.text.trim();
    final parsedExpression = tryParseMemoryToolPointerExpression(rawInput);
    final errorText = rawInput.isEmpty || parsedExpression != null
        ? null
        : _resolveInvalidExpressionText(context);

    return OverlayPanelDialog.card(
      onClose: isSubmitting.value ? null : onClose,
      maxWidthPortrait: 380.r,
      maxWidthLandscape: 440.r,
      maxHeightPortrait: 360.r,
      maxHeightLandscape: 360.r,
      cardBorderRadius: 18.r,
      childBuilder: (context, viewport, layout) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(14.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _resolveDialogTitle(context),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 12.r),
              CustomTextField(
                controller: controller,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                labelText: _resolveFieldLabel(context),
                hintText:
                    '{so:"libil2cpp.so",memory:"Cb",addr:0xB75D28A8,offsets:[0xCD0,0x218,0x478,0x628]}',
                contextMenuBuilder: buildOverlayTextInputContextMenu,
                fillColor: context.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.22),
                focusedBorderColor: context.colorScheme.primary,
                enabledBorderColor: context.colorScheme.outlineVariant
                    .withValues(alpha: 0.34),
              ),
              if (errorText != null) ...<Widget>[
                SizedBox(height: 8.r),
                Text(
                  errorText,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              SizedBox(height: 14.r),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSubmitting.value ? null : onClose,
                      child: Text(context.l10n.close),
                    ),
                  ),
                  SizedBox(width: 10.r),
                  Expanded(
                    child: FilledButton(
                      onPressed: isSubmitting.value || parsedExpression == null
                          ? null
                          : () async {
                              isSubmitting.value = true;
                              try {
                                await onConfirm(parsedExpression);
                              } finally {
                                if (context.mounted) {
                                  isSubmitting.value = false;
                                }
                              }
                            },
                      child: Text(context.l10n.confirm),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _resolveDialogTitle(BuildContext context) {
    return context.isZh ? '表达式定位' : 'Locate by Expression';
  }

  String _resolveFieldLabel(BuildContext context) {
    return context.isZh ? '表达式' : 'Expression';
  }

  String _resolveInvalidExpressionText(BuildContext context) {
    return context.isZh ? '表达式格式无效' : 'Invalid expression format';
  }
}
