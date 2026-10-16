import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_text_input_context_menu.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef MemoryToolTypeLabelBuilder = String Function(SearchValueType type);

class MemoryToolValueEditorDialog extends StatelessWidget {
  const MemoryToolValueEditorDialog({
    super.key,
    required this.title,
    required this.selectedTypeLabel,
    required this.typeLabelBuilder,
    required this.onSelectedType,
    required this.valueController,
    required this.canSave,
    required this.onSave,
    required this.onClose,
    this.subtitle,
    this.valueHintText,
    this.isFreezeEnabled,
    this.onFreezeChanged,
    this.extraContent,
    this.metadata = const <MemoryToolValueEditorMeta>[],
    this.errorText,
    this.maxWidthPortrait,
    this.maxWidthLandscape,
    this.maxHeightPortrait,
    this.maxHeightLandscape,
  });

  final String title;
  final String? subtitle;
  final String selectedTypeLabel;
  final MemoryToolTypeLabelBuilder typeLabelBuilder;
  final ValueChanged<SearchValueType> onSelectedType;
  final TextEditingController valueController;
  final String? valueHintText;
  final bool? isFreezeEnabled;
  final ValueChanged<bool>? onFreezeChanged;
  final Widget? extraContent;
  final List<MemoryToolValueEditorMeta> metadata;
  final String? errorText;
  final bool canSave;
  final VoidCallback onSave;
  final VoidCallback onClose;
  final double? maxWidthPortrait;
  final double? maxWidthLandscape;
  final double? maxHeightPortrait;
  final double? maxHeightLandscape;

  @override
  Widget build(BuildContext context) {
    return OverlayPanelDialog.card(
      onClose: onClose,
      maxWidthPortrait: maxWidthPortrait ?? 368.r,
      maxWidthLandscape: maxWidthLandscape ?? 430.r,
      maxHeightPortrait: maxHeightPortrait ?? 360.r,
      maxHeightLandscape: maxHeightLandscape ?? 340.r,
      cardBorderRadius: 18.r,
      childBuilder: (context, viewport, layout) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(14.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (subtitle != null) ...<Widget>[
                          SizedBox(height: 4.r),
                          Text(
                            subtitle!,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.66,
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 10.r),
                  PopupMenuButton<SearchValueType>(
                    onSelected: onSelectedType,
                    itemBuilder: (context) {
                      return SearchValueType.values
                          .map(
                            (type) => PopupMenuItem<SearchValueType>(
                              value: type,
                              child: Text(typeLabelBuilder(type)),
                            ),
                          )
                          .toList(growable: false);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: 8.r,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: context.colorScheme.outlineVariant.withValues(
                            alpha: 0.34,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            selectedTypeLabel,
                            style: context.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 4.r),
                          Icon(
                            Icons.expand_more_rounded,
                            size: 18.r,
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.74,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.r),
              Text(
                context.l10n.memoryToolResultValue,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.r),
              CustomTextField(
                controller: valueController,
                labelText: context.l10n.memoryToolResultValue,
                hintText: valueHintText,
                contextMenuBuilder: buildOverlayTextInputContextMenu,
                fillColor: context.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.22),
                focusedBorderColor: context.colorScheme.primary,
                enabledBorderColor: context.colorScheme.outlineVariant
                    .withValues(alpha: 0.34),
              ),
              if (extraContent != null) ...<Widget>[
                SizedBox(height: 12.r),
                extraContent!,
              ],
              if (isFreezeEnabled != null &&
                  onFreezeChanged != null) ...<Widget>[
                SizedBox(height: 12.r),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.42),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: context.colorScheme.outlineVariant.withValues(
                        alpha: 0.34,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 6.r,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            context.l10n.memoryToolResultActionFreeze,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Switch.adaptive(
                          value: isFreezeEnabled!,
                          onChanged: onFreezeChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (metadata.isNotEmpty) ...<Widget>[
                SizedBox(height: 12.r),
                for (
                  int index = 0;
                  index < metadata.length;
                  index++
                ) ...<Widget>[
                  if (index > 0) SizedBox(height: 8.r),
                  _MemoryToolValueEditorMetaLine(
                    label: metadata[index].label,
                    value: metadata[index].value,
                  ),
                ],
              ],
              if (errorText != null && errorText!.isNotEmpty) ...<Widget>[
                SizedBox(height: 10.r),
                Text(
                  errorText!,
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
                      onPressed: onClose,
                      child: Text(context.l10n.close),
                    ),
                  ),
                  SizedBox(width: 10.r),
                  Expanded(
                    child: FilledButton(
                      onPressed: canSave ? onSave : null,
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

class MemoryToolValueEditorMeta {
  const MemoryToolValueEditorMeta({required this.label, required this.value});

  final String label;
  final String value;
}

class _MemoryToolValueEditorMetaLine extends StatelessWidget {
  const _MemoryToolValueEditorMetaLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 58.r,
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.62),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 8.r),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
