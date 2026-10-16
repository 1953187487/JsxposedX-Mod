import 'package:JsxposedX/common/widgets/overlay_window/overlay_text_input_context_menu.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemoryToolResultSelectionDialog extends HookWidget {
  const MemoryToolResultSelectionDialog({
    super.key,
    required this.initialLimit,
    required this.title,
    required this.fieldLabel,
    required this.onClose,
    required this.onConfirm,
  });

  final int initialLimit;
  final String title;
  final String fieldLabel;
  final VoidCallback onClose;
  final ValueChanged<int> onConfirm;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialLimit.toString());
    final textValue = useValueListenable(controller);
    final rawText = textValue.text.trim();
    final parsedLimit = int.tryParse(rawText);
    final validationMessage = rawText.isEmpty
        ? context.l10n.memoryToolResultSelectionRequired
        : parsedLimit == null || parsedLimit <= 0
        ? context.l10n.memoryToolResultSelectionInvalid
        : null;
    final canConfirm = validationMessage == null && parsedLimit != null;
    const presetValues = <int>[50, 100, 200];

    return OverlayPanelDialog.card(
      onClose: onClose,
      barrierOpacity: 0.32,
      maxWidthPortrait: 320.r,
      maxWidthLandscape: 320.r,
      maxHeightPortrait: 360.r,
      maxHeightLandscape: 360.r,
      landscapeHeightFactor: 1.0,
      cardMinWidth: 240.r,
      cardMaxWidth: 320.r,
      cardBorderRadius: 16.r,
      childBuilder: (context, viewport, layout) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(14.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.r),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                enableInteractiveSelection: true,
                contextMenuBuilder: buildOverlayTextInputContextMenu,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: fieldLabel,
                  hintText: initialLimit.toString(),
                  errorText: validationMessage,
                  suffixText: context.l10n.memoryToolResultSelectionUnit,
                  filled: true,
                  fillColor: context.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.42),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 12.r,
                  ),
                ),
              ),
              SizedBox(height: 10.r),
              Text(
                context.l10n.memoryToolResultSelectionPresetLabel,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.r),
              Wrap(
                spacing: 8.r,
                runSpacing: 8.r,
                children: presetValues.map((value) {
                  final selected = rawText == value.toString();
                  return ChoiceChip(
                    label: Text(value.toString()),
                    selected: selected,
                    onSelected: (_) {
                      controller.value = TextEditingValue(
                        text: value.toString(),
                        selection: TextSelection.collapsed(
                          offset: value.toString().length,
                        ),
                      );
                    },
                  );
                }).toList(growable: false),
              ),
              SizedBox(height: 14.r),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onClose,
                      child: Text(context.l10n.cancel),
                    ),
                  ),
                  SizedBox(width: 10.r),
                  Expanded(
                    child: FilledButton(
                      onPressed: canConfirm
                          ? () => onConfirm(parsedLimit)
                          : null,
                      child: Text(context.l10n.save),
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
}
