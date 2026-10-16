import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_entry_kind.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_action_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_saved_items_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_value_editor_dialog.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolSearchResultDialog extends HookConsumerWidget {
  const MemoryToolSearchResultDialog({
    super.key,
    required this.result,
    required this.displayValue,
    required this.livePreviewsAsync,
    this.processPid,
    this.initialFrozenState,
    required this.onClose,
  });

  final SearchResult result;
  final String displayValue;
  final AsyncValue<Map<int, MemoryValuePreview>> livePreviewsAsync;
  final int? processPid;
  final bool? initialFrozenState;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = useState<SearchValueType>(result.type);
    final freezeEnabled = useState<bool>(false);
    final previousValueEntry = ref.watch(
      memoryValueHistoryProvider.select((state) => state[result.address]),
    );
    final livePreview = livePreviewsAsync.asData?.value[result.address];
    final sourceRawBytes = livePreview?.rawBytes ?? result.rawBytes;
    final sourceType = livePreview?.type ?? result.type;
    final sourceDisplayValue = resolveMemoryToolPreferredDisplayValue(
      result: result,
      livePreview: livePreview,
      fallbackDisplayValue: displayValue,
    );
    final sourceBytesLength = sourceRawBytes.length;
    final searchSessionStateAsync = ref.watch(getSearchSessionStateProvider);
    final frozenValuesAsync = ref.watch(currentFrozenMemoryValuesProvider);
    final valueActionState = ref.watch(memoryValueActionProvider);
    final valueActionNotifier = ref.read(memoryValueActionProvider.notifier);
    final savedItemsNotifier = ref.read(memoryToolSavedItemsProvider.notifier);
    final readRequests = useMemoized(
      () => <MemoryReadRequest>[
        MemoryReadRequest(
          pid: processPid ?? 0,
          address: result.address,
          type: selectedType.value,
          length: resolveMemoryToolReadLengthForType(
            type: selectedType.value,
            bytesLength: sourceBytesLength,
          ),
        ),
      ],
      <Object>[
        processPid ?? 0,
        result.address,
        selectedType.value,
        sourceBytesLength,
      ],
    );
    final selectedPreviewAsync = processPid == null
        ? const AsyncValue.data(<MemoryValuePreview>[])
        : ref.watch(readMemoryValuesProvider(requests: readRequests));
    final selectedPreviewList = selectedPreviewAsync.asData?.value;
    final selectedPreview =
        selectedPreviewList == null || selectedPreviewList.isEmpty
        ? null
        : selectedPreviewList.first;
    final selectedDisplayValue = selectedType.value == sourceType
        ? sourceDisplayValue
        : selectedPreview?.displayValue ?? '';
    final isFrozen =
        frozenValuesAsync.asData?.value.any(
          (value) =>
              value.address == result.address &&
              (processPid == null || value.pid == processPid),
        ) ??
        initialFrozenState ??
        false;
    final valueController = useTextEditingController(
      text: selectedDisplayValue,
    );
    useListenable(valueController);
    useEffect(() {
      freezeEnabled.value = isFrozen;
      return null;
    }, <Object?>[isFrozen]);
    useEffect(() {
      valueController.value = TextEditingValue(
        text: selectedDisplayValue,
        selection: TextSelection.collapsed(offset: selectedDisplayValue.length),
      );
      return null;
    }, <Object?>[selectedType.value, selectedDisplayValue]);
    final selectedTypeLabel = mapMemoryToolSearchResultTypeLabel(
      type: selectedType.value,
      displayValue: selectedDisplayValue,
    );
    final isResolvingAlternateType =
        selectedType.value != sourceType && selectedPreviewAsync.isLoading;
    final previousPreview = selectedType.value == sourceType
        ? MemoryValuePreview(
            address: result.address,
            type: sourceType,
            rawBytes: sourceRawBytes,
            displayValue: sourceDisplayValue,
          )
        : selectedPreview;
    final canSave =
        valueController.text.trim().isNotEmpty &&
        !valueActionState.isLoading &&
        !isResolvingAlternateType &&
        previousPreview != null;

    Future<void> handleSave() async {
      try {
        final sessionState = await ref.read(
          getSearchSessionStateProvider.future,
        );
        final writeSourcePreview = previousPreview!;
        final writeValue = buildMemoryToolWriteValue(
          type: selectedType.value,
          input: valueController.text,
          littleEndian: sessionState.littleEndian,
          sourceType: writeSourcePreview.type,
          sourceRawBytes: writeSourcePreview.rawBytes,
          sourceDisplayValue: writeSourcePreview.displayValue,
        );

        await valueActionNotifier.writeMemoryValue(
          request: MemoryWriteRequest(
            address: result.address,
            value: writeValue,
          ),
          previousPreview: writeSourcePreview,
        );
        await valueActionNotifier.setMemoryFreeze(
          request: MemoryFreezeRequest(
            address: result.address,
            value: writeValue,
            enabled: freezeEnabled.value,
          ),
        );
        final selectedPid = ref.read(memoryToolSelectedProcessProvider)?.pid;
        if (selectedPid != null) {
          final updatedPreviewRequest = MemoryReadRequest(
            pid: selectedPid,
            address: result.address,
            type: selectedType.value,
            length: resolveMemoryToolReadLengthForType(
              type: selectedType.value,
              bytesLength: sourceBytesLength,
            ),
          );
          final updatedPreviews = await ref
              .read(memoryQueryRepositoryProvider)
              .readMemoryValues(
                requests: <MemoryReadRequest>[updatedPreviewRequest],
              );
          final updatedPreview = updatedPreviews.isNotEmpty
              ? updatedPreviews.first
              : MemoryValuePreview(
                  address: result.address,
                  type: selectedType.value,
                  rawBytes: sourceRawBytes,
                  displayValue: valueController.text.trim(),
                );
          savedItemsNotifier.saveEntry(
            pid: selectedPid,
            result: result,
            preview: updatedPreview,
            isFrozen: freezeEnabled.value,
            entryKind: MemoryToolEntryKind.value,
          );
        }

        if (!context.mounted) {
          return;
        }
        onClose();
      } catch (_) {
        return;
      }
    }

    return MemoryToolValueEditorDialog(
      title: context.l10n.memoryToolResultDetailTitle,
      selectedTypeLabel: selectedTypeLabel,
      typeLabelBuilder: (type) {
        return mapMemoryToolSearchResultTypeLabel(
          type: type,
          displayValue: type == SearchValueType.bytes ? sourceDisplayValue : '',
        );
      },
      onSelectedType: (value) {
        selectedType.value = value;
      },
      valueController: valueController,
      valueHintText: selectedType.value == sourceType
          ? null
          : selectedPreviewAsync.isLoading
          ? '...'
          : null,
      isFreezeEnabled: freezeEnabled.value,
      onFreezeChanged: valueActionState.isLoading
          ? null
          : (value) {
              freezeEnabled.value = value;
            },
      metadata: <MemoryToolValueEditorMeta>[
        MemoryToolValueEditorMeta(
          label: context.l10n.memoryToolResultType,
          value: selectedTypeLabel,
        ),
        MemoryToolValueEditorMeta(
          label: context.l10n.memoryToolResultAddress,
          value: formatMemoryToolSearchResultAddress(result.address),
        ),
        MemoryToolValueEditorMeta(
          label: context.l10n.memoryToolResultRegion,
          value: mapMemoryToolSearchResultRegionTypeLabel(
            context,
            result.regionTypeKey,
          ),
        ),
        if (previousValueEntry != null)
          MemoryToolValueEditorMeta(
            label: context.l10n.memoryToolResultPreviousValue,
            value: previousValueEntry.displayValue,
          ),
      ],
      errorText:
          valueActionState.error?.toString() ??
          frozenValuesAsync.error?.toString() ??
          searchSessionStateAsync.error?.toString(),
      canSave: canSave,
      onSave: handleSave,
      onClose: onClose,
    );
  }
}
