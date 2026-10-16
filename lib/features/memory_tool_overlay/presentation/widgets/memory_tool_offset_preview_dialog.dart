import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_text_input_context_menu.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolOffsetPreviewDialog extends HookConsumerWidget {
  const MemoryToolOffsetPreviewDialog({
    super.key,
    required this.result,
    required this.displayValue,
    required this.livePreviewsAsync,
    required this.onConfirm,
    required this.onClose,
  });

  final SearchResult result;
  final String displayValue;
  final AsyncValue<Map<int, MemoryValuePreview>> livePreviewsAsync;
  final Future<void> Function(int targetAddress) onConfirm;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPid = ref.watch(memoryToolSelectedProcessProvider)?.pid;
    final sourcePreview = livePreviewsAsync.asData?.value[result.address];
    final sourceRawBytes = sourcePreview?.rawBytes ?? result.rawBytes;
    final previewLength = sourceRawBytes.isEmpty ? 1 : sourceRawBytes.length;
    final offsetController = useTextEditingController(text: '0');
    final isHex = useState(true);
    useListenable(offsetController);

    final rawOffsetInput = offsetController.text.trim();
    final resolvedOffset = _tryParseOffset(
      rawOffsetInput,
      isHex: isHex.value,
    );
    final targetAddress = resolvedOffset == null
        ? null
        : result.address + resolvedOffset;
    final hasValidTargetAddress = targetAddress != null && targetAddress >= 0;
    final previewRequests = useMemoized(
      () => hasValidTargetAddress && selectedPid != null
          ? <MemoryReadRequest>[
              MemoryReadRequest(
                pid: selectedPid,
                address: targetAddress,
                type: SearchValueType.bytes,
                length: previewLength,
              ),
            ]
          : const <MemoryReadRequest>[],
      <Object>[
        hasValidTargetAddress,
        selectedPid ?? -1,
        targetAddress ?? -1,
        previewLength,
      ],
    );
    final targetPreviewAsync = hasValidTargetAddress && selectedPid != null
        ? ref.watch(readMemoryValuesProvider(requests: previewRequests))
        : const AsyncValue.data(<MemoryValuePreview>[]);
    final targetPreviewList = targetPreviewAsync.asData?.value;
    final targetPreview =
        targetPreviewList == null || targetPreviewList.isEmpty
        ? null
        : targetPreviewList.first;
    final targetDisplayValue = targetPreview == null
        ? null
        : resolveMemoryToolSearchResultValueByType(
            type: result.type,
            rawBytes: targetPreview.rawBytes,
            fallbackDisplayValue: displayValue,
          );
    final canConfirm = hasValidTargetAddress;
    final previewValueText = targetPreviewAsync.isLoading
        ? context.l10n.loading
        : targetDisplayValue ?? context.l10n.memoryToolOffsetPreviewUnreadable;
    final previewErrorText =
        rawOffsetInput.isEmpty || resolvedOffset == null || !hasValidTargetAddress
        ? context.l10n.memoryToolOffsetPreviewInvalid
        : null;

    return OverlayPanelDialog.card(
      onClose: onClose,
      maxWidthPortrait: 368.r,
      maxWidthLandscape: 420.r,
      maxHeightPortrait: 320.r,
      maxHeightLandscape: 320.r,
      cardBorderRadius: 18.r,
      childBuilder: (context, viewport, layout) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(14.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.memoryToolOffsetPreviewTitle,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 12.r),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: CustomTextField(
                      controller: offsetController,
                      keyboardType: TextInputType.text,
                      labelText: context.l10n.memoryToolOffsetPreviewOffsetLabel,
                      contextMenuBuilder: buildOverlayTextInputContextMenu,
                      fillColor: context.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.22),
                      focusedBorderColor: context.colorScheme.primary,
                      enabledBorderColor: context.colorScheme.outlineVariant
                          .withValues(alpha: 0.34),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          isHex.value
                              ? RegExp(r'[0-9a-fA-FxX+\-]')
                              : RegExp(r'[0-9+\-]'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.r),
                  SizedBox(
                    height: 56.r,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          isHex.value = !isHex.value;
                        },
                        child: Ink(
                          padding: EdgeInsets.symmetric(horizontal: 14.r),
                          decoration: BoxDecoration(
                            color: context.colorScheme.surfaceContainerHighest
                                .withValues(alpha: isHex.value ? 0.56 : 0.32),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isHex.value
                                  ? context.colorScheme.primary
                                  : context.colorScheme.outlineVariant
                                        .withValues(alpha: 0.34),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                isHex.value
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                                size: 18.r,
                                color: isHex.value
                                    ? context.colorScheme.primary
                                    : context.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.72),
                              ),
                              SizedBox(width: 8.r),
                              Text(
                                context.l10n.memoryToolOffsetPreviewHexLabel,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (previewErrorText != null) ...<Widget>[
                SizedBox(height: 8.r),
                Text(
                  previewErrorText,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              SizedBox(height: 12.r),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: context.colorScheme.outlineVariant.withValues(
                      alpha: 0.34,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _MemoryToolOffsetPreviewLine(
                      label: context.l10n.memoryToolOffsetPreviewTargetAddress,
                      value: hasValidTargetAddress
                          ? formatMemoryToolSearchResultAddress(targetAddress)
                          : '--',
                    ),
                    SizedBox(height: 8.r),
                    _MemoryToolOffsetPreviewLine(
                      label: context.l10n.memoryToolOffsetPreviewTargetValue,
                      value: previewValueText,
                    ),
                  ],
                ),
              ),
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
                      onPressed: canConfirm
                          ? () async {
                              await onConfirm(targetAddress);
                            }
                          : null,
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
}

class _MemoryToolOffsetPreviewLine extends StatelessWidget {
  const _MemoryToolOffsetPreviewLine({
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
          width: 64.r,
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
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

int? _tryParseOffset(String input, {required bool isHex}) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  var sign = 1;
  var valueText = trimmed;
  if (valueText.startsWith('+')) {
    valueText = valueText.substring(1);
  } else if (valueText.startsWith('-')) {
    sign = -1;
    valueText = valueText.substring(1);
  }

  if (valueText.isEmpty) {
    return null;
  }

  if (isHex) {
    valueText = valueText.replaceFirst(RegExp(r'^0x', caseSensitive: false), '');
    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(valueText)) {
      return null;
    }
    final parsed = int.tryParse(valueText, radix: 16);
    return parsed == null ? null : parsed * sign;
  }

  if (!RegExp(r'^\d+$').hasMatch(valueText)) {
    return null;
  }
  final parsed = int.tryParse(valueText);
  return parsed == null ? null : parsed * sign;
}
