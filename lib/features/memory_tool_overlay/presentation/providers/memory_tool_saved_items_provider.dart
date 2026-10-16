import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_saved_item.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_entry_kind.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_host_runtime_provider.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memory_tool_saved_items_provider.g.dart';

class MemoryToolSavedItemsState {
  const MemoryToolSavedItemsState({
    this.itemsByPid = const <int, Map<int, MemoryToolSavedItem>>{},
  });

  final Map<int, Map<int, MemoryToolSavedItem>> itemsByPid;

  MemoryToolSavedItemsState copyWith({
    Map<int, Map<int, MemoryToolSavedItem>>? itemsByPid,
  }) {
    return MemoryToolSavedItemsState(itemsByPid: itemsByPid ?? this.itemsByPid);
  }
}

class MemoryToolSavedItemSelectionState {
  const MemoryToolSavedItemSelectionState({
    this.selectedAddresses = const <int>[],
  });

  final List<int> selectedAddresses;

  int get selectedCount => selectedAddresses.length;

  bool contains(int address) {
    return selectedAddresses.contains(address);
  }

  MemoryToolSavedItemSelectionState copyWith({List<int>? selectedAddresses}) {
    return MemoryToolSavedItemSelectionState(
      selectedAddresses: selectedAddresses ?? this.selectedAddresses,
    );
  }
}

@riverpod
List<MemoryToolSavedItem> savedItemsForSelectedProcess(Ref ref) {
  final selectedProcess = ref.watch(memoryToolSelectedProcessProvider);
  if (selectedProcess == null) {
    return const <MemoryToolSavedItem>[];
  }

  final itemsByAddress = ref
      .watch(memoryToolSavedItemsProvider)
      .itemsByPid[selectedProcess.pid];
  if (itemsByAddress == null || itemsByAddress.isEmpty) {
    return const <MemoryToolSavedItem>[];
  }

  final sortedItems = itemsByAddress.values.toList(growable: false)
    ..sort((left, right) => left.address.compareTo(right.address));
  return sortedItems;
}

@riverpod
Future<Map<int, MemoryValuePreview>> currentSavedItemLivePreviews(
  Ref ref,
) async {
  final savedItems = ref.watch(savedItemsForSelectedProcessProvider);
  final selectedProcess = ref.watch(memoryToolSelectedProcessProvider);
  final isPanelVisible = ref.watch(
    overlayWindowHostRuntimeProvider.select(
      (state) => state.payload.isPanel && !state.isTransitioningToPanel,
    ),
  );
  if (!isPanelVisible || savedItems.isEmpty || selectedProcess == null) {
    return const <int, MemoryValuePreview>{};
  }

  final valueItems = savedItems
      .where((item) => !item.isInstruction)
      .toList(growable: false);
  if (valueItems.isEmpty) {
    return const <int, MemoryValuePreview>{};
  }

  final previews = await ref
      .watch(memoryQueryRepositoryProvider)
      .readMemoryValues(
        requests: valueItems
            .map(
              (item) => MemoryReadRequest(
                pid: selectedProcess.pid,
                address: item.address,
                type: item.type,
                length: resolveMemoryToolReadLengthForType(
                  type: item.type,
                  bytesLength: item.rawBytes.length,
                ),
              ),
            )
            .toList(growable: false),
      );

  return <int, MemoryValuePreview>{
    for (final preview in previews) preview.address: preview,
  };
}

final currentSavedInstructionPreviewsProvider =
    FutureProvider<Map<int, MemoryInstructionPreview>>((ref) async {
      final savedItems = ref.watch(savedItemsForSelectedProcessProvider);
      final selectedProcess = ref.watch(memoryToolSelectedProcessProvider);
      final isPanelVisible = ref.watch(
        overlayWindowHostRuntimeProvider.select(
          (state) => state.payload.isPanel && !state.isTransitioningToPanel,
        ),
      );
      if (!isPanelVisible || savedItems.isEmpty || selectedProcess == null) {
        return const <int, MemoryInstructionPreview>{};
      }

      final instructionItems = savedItems
          .where((item) => item.isInstruction)
          .toList(growable: false);
      if (instructionItems.isEmpty) {
        return const <int, MemoryInstructionPreview>{};
      }

      final previews = await ref
          .watch(memoryQueryRepositoryProvider)
          .disassembleMemory(
            pid: selectedProcess.pid,
            addresses: instructionItems
                .map((item) => item.address)
                .toList(growable: false),
          );

      return <int, MemoryInstructionPreview>{
        for (final preview in previews) preview.address: preview,
      };
    });

@Riverpod(keepAlive: true)
class MemoryToolSavedItems extends _$MemoryToolSavedItems {
  @override
  MemoryToolSavedItemsState build() {
    return const MemoryToolSavedItemsState();
  }

  Future<void> saveResultAsValue({
    required int pid,
    required SearchResult result,
    bool isFrozen = false,
    SearchValueType? type,
    int? bytesLength,
  }) async {
    final resolvedType = type ?? result.type;
    final resolvedLength =
        bytesLength ??
        resolveMemoryToolReadLengthForType(
          type: resolvedType,
          bytesLength: result.rawBytes.length,
        );
    final previews = await ref
        .read(memoryQueryRepositoryProvider)
        .readMemoryValues(
          requests: <MemoryReadRequest>[
            MemoryReadRequest(
              pid: pid,
              address: result.address,
              type: resolvedType,
              length: resolvedLength,
            ),
          ],
        );
    final preview = previews.isEmpty ? null : previews.first;
    final nextResult = preview == null
        ? SearchResult(
            address: result.address,
            regionStart: result.regionStart,
            regionTypeKey: result.regionTypeKey,
            type: resolvedType,
            rawBytes: result.rawBytes,
            displayValue: result.displayValue,
          )
        : SearchResult(
            address: result.address,
            regionStart: result.regionStart,
            regionTypeKey: result.regionTypeKey,
            type: preview.type,
            rawBytes: preview.rawBytes,
            displayValue: preview.displayValue,
          );
    saveEntry(
      pid: pid,
      result: nextResult,
      preview: preview,
      isFrozen: isFrozen,
      entryKind: MemoryToolEntryKind.value,
    );
  }

  Future<void> saveResultAsInstruction({
    required int pid,
    required SearchResult result,
  }) async {
    final previews = await ref
        .read(memoryQueryRepositoryProvider)
        .disassembleMemory(pid: pid, addresses: <int>[result.address]);
    if (previews.isEmpty) {
      throw Exception('Target address is unreadable.');
    }
    final preview = previews.first;
    saveEntry(
      pid: pid,
      result: SearchResult(
        address: result.address,
        regionStart: result.regionStart,
        regionTypeKey: result.regionTypeKey,
        type: SearchValueType.bytes,
        rawBytes: preview.rawBytes,
        displayValue: preview.instructionText,
      ),
      isFrozen: false,
      entryKind: MemoryToolEntryKind.instruction,
      instructionText: preview.instructionText,
    );
  }

  void saveEntry({
    required int pid,
    required SearchResult result,
    MemoryValuePreview? preview,
    required bool isFrozen,
    required MemoryToolEntryKind entryKind,
    String? instructionText,
  }) {
    final nextItemsByPid = _copyItemsByPid();
    final nextItemsByAddress = <int, MemoryToolSavedItem>{
      ...(nextItemsByPid[pid] ?? const <int, MemoryToolSavedItem>{}),
      result.address: MemoryToolSavedItem.fromSearchResult(
        pid: pid,
        result: result,
        preview: preview,
        isFrozen: isFrozen,
        entryKind: entryKind,
        instructionText: instructionText,
      ),
    };
    nextItemsByPid[pid] = nextItemsByAddress;
    state = state.copyWith(itemsByPid: nextItemsByPid);
  }

  void saveEntries({
    required int pid,
    required List<SearchResult> results,
    Map<int, MemoryValuePreview> previewsByAddress =
        const <int, MemoryValuePreview>{},
    Set<int> frozenAddresses = const <int>{},
    Map<int, MemoryToolEntryKind> entryKindsByAddress =
        const <int, MemoryToolEntryKind>{},
    Map<int, String> instructionTextsByAddress = const <int, String>{},
  }) {
    if (results.isEmpty) {
      return;
    }

    final nextItemsByPid = _copyItemsByPid();
    final nextItemsByAddress = <int, MemoryToolSavedItem>{
      ...(nextItemsByPid[pid] ?? const <int, MemoryToolSavedItem>{}),
    };

    for (final result in results) {
      nextItemsByAddress[result.address] = MemoryToolSavedItem.fromSearchResult(
        pid: pid,
        result: result,
        preview: previewsByAddress[result.address],
        isFrozen: frozenAddresses.contains(result.address),
        entryKind:
            entryKindsByAddress[result.address] ?? MemoryToolEntryKind.value,
        instructionText: instructionTextsByAddress[result.address],
      );
    }

    nextItemsByPid[pid] = nextItemsByAddress;
    state = state.copyWith(itemsByPid: nextItemsByPid);
  }

  void removeOne({required int pid, required int address}) {
    final currentItemsByAddress = state.itemsByPid[pid];
    if (currentItemsByAddress == null ||
        !currentItemsByAddress.containsKey(address)) {
      return;
    }

    final nextItemsByPid = _copyItemsByPid();
    final nextItemsByAddress = <int, MemoryToolSavedItem>{
      ...currentItemsByAddress,
    }..remove(address);
    if (nextItemsByAddress.isEmpty) {
      nextItemsByPid.remove(pid);
    } else {
      nextItemsByPid[pid] = nextItemsByAddress;
    }
    state = state.copyWith(itemsByPid: nextItemsByPid);
  }

  void removeSelected({required int pid, required Iterable<int> addresses}) {
    final currentItemsByAddress = state.itemsByPid[pid];
    if (currentItemsByAddress == null || currentItemsByAddress.isEmpty) {
      return;
    }

    final nextItemsByAddress = <int, MemoryToolSavedItem>{
      ...currentItemsByAddress,
    };
    var changed = false;
    for (final address in addresses) {
      changed = nextItemsByAddress.remove(address) != null || changed;
    }
    if (!changed) {
      return;
    }

    final nextItemsByPid = _copyItemsByPid();
    if (nextItemsByAddress.isEmpty) {
      nextItemsByPid.remove(pid);
    } else {
      nextItemsByPid[pid] = nextItemsByAddress;
    }
    state = state.copyWith(itemsByPid: nextItemsByPid);
  }

  void clearProcess(int pid) {
    if (!state.itemsByPid.containsKey(pid)) {
      return;
    }

    final nextItemsByPid = _copyItemsByPid()..remove(pid);
    state = state.copyWith(itemsByPid: nextItemsByPid);
  }

  void syncValuePreviews({
    required int pid,
    required Iterable<MemoryValuePreview> previews,
    Map<int, bool> frozenStatesByAddress = const <int, bool>{},
  }) {
    final currentItemsByAddress = state.itemsByPid[pid];
    if (currentItemsByAddress == null || currentItemsByAddress.isEmpty) {
      return;
    }

    final previewByAddress = <int, MemoryValuePreview>{
      for (final preview in previews) preview.address: preview,
    };
    if (previewByAddress.isEmpty && frozenStatesByAddress.isEmpty) {
      return;
    }

    final nextItemsByAddress = <int, MemoryToolSavedItem>{
      ...currentItemsByAddress,
    };
    var changed = false;

    for (final entry in currentItemsByAddress.entries) {
      final item = entry.value;
      final preview = previewByAddress[item.address];
      final nextFrozen = frozenStatesByAddress[item.address];
      if (preview == null && nextFrozen == null) {
        continue;
      }
      if (item.isInstruction && preview != null) {
        continue;
      }

      final nextItem = item.copyWith(
        type: preview?.type ?? item.type,
        rawBytes: preview?.rawBytes ?? item.rawBytes,
        displayValue: preview?.displayValue ?? item.displayValue,
        isFrozen: nextFrozen ?? item.isFrozen,
      );
      if (listEquals(nextItem.rawBytes, item.rawBytes) &&
          nextItem.displayValue == item.displayValue &&
          nextItem.type == item.type &&
          nextItem.isFrozen == item.isFrozen) {
        continue;
      }
      nextItemsByAddress[item.address] = nextItem;
      changed = true;
    }

    if (!changed) {
      return;
    }

    final nextItemsByPid = _copyItemsByPid();
    nextItemsByPid[pid] = nextItemsByAddress;
    state = state.copyWith(itemsByPid: nextItemsByPid);
  }

  Map<int, Map<int, MemoryToolSavedItem>> _copyItemsByPid() {
    return <int, Map<int, MemoryToolSavedItem>>{
      for (final entry in state.itemsByPid.entries)
        entry.key: <int, MemoryToolSavedItem>{...entry.value},
    };
  }

  void syncInstructionPreviews({
    required int pid,
    required Iterable<MemoryInstructionPreview> previews,
  }) {
    final currentItemsByAddress = state.itemsByPid[pid];
    if (currentItemsByAddress == null || currentItemsByAddress.isEmpty) {
      return;
    }

    final previewByAddress = <int, MemoryInstructionPreview>{
      for (final preview in previews) preview.address: preview,
    };
    if (previewByAddress.isEmpty) {
      return;
    }

    final nextItemsByAddress = <int, MemoryToolSavedItem>{
      ...currentItemsByAddress,
    };
    var changed = false;

    for (final previewEntry in previewByAddress.entries) {
      final item = currentItemsByAddress[previewEntry.key];
      if (item == null || !item.isInstruction) {
        continue;
      }
      final preview = previewEntry.value;
      final nextItem = item.copyWith(
        type: SearchValueType.bytes,
        rawBytes: preview.rawBytes,
        displayValue: preview.instructionText,
        isFrozen: false,
        entryKind: MemoryToolEntryKind.instruction,
        instructionText: preview.instructionText,
      );
      if (listEquals(nextItem.rawBytes, item.rawBytes) &&
          nextItem.displayValue == item.displayValue &&
          nextItem.instructionText == item.instructionText &&
          nextItem.type == item.type &&
          nextItem.entryKind == item.entryKind &&
          nextItem.isFrozen == item.isFrozen) {
        continue;
      }
      nextItemsByAddress[item.address] = nextItem;
      changed = true;
    }

    if (!changed) {
      return;
    }

    final nextItemsByPid = _copyItemsByPid();
    nextItemsByPid[pid] = nextItemsByAddress;
    state = state.copyWith(itemsByPid: nextItemsByPid);
  }
}

@Riverpod(keepAlive: true)
class MemoryToolSavedItemSelection extends _$MemoryToolSavedItemSelection {
  @override
  MemoryToolSavedItemSelectionState build() {
    return const MemoryToolSavedItemSelectionState();
  }

  void toggle(int address) {
    final selected = List<int>.from(state.selectedAddresses);
    final existingIndex = selected.indexOf(address);
    if (existingIndex >= 0) {
      selected.removeAt(existingIndex);
    } else {
      selected.add(address);
    }
    state = state.copyWith(selectedAddresses: selected);
  }

  void selectVisible(Iterable<int> addresses) {
    state = state.copyWith(
      selectedAddresses: addresses.toList(growable: false),
    );
  }

  void invertVisible(Iterable<int> addresses) {
    final visibleAddresses = addresses.toSet();
    final selected = state.selectedAddresses.toSet();
    final nextSelected = <int>[
      for (final address in state.selectedAddresses)
        if (!visibleAddresses.contains(address)) address,
      for (final address in visibleAddresses)
        if (!selected.contains(address)) address,
    ];
    state = state.copyWith(selectedAddresses: nextSelected);
  }

  void retainVisible(Iterable<int> addresses) {
    final visibleAddresses = addresses.toSet();
    final nextSelected = state.selectedAddresses
        .where(visibleAddresses.contains)
        .toList(growable: false);
    if (nextSelected.length == state.selectedAddresses.length) {
      return;
    }
    state = state.copyWith(selectedAddresses: nextSelected);
  }

  void removeAddress(int address) {
    if (!state.selectedAddresses.contains(address)) {
      return;
    }

    state = state.copyWith(
      selectedAddresses: state.selectedAddresses
          .where((selectedAddress) => selectedAddress != address)
          .toList(growable: false),
    );
  }

  void clearSelection() {
    if (state.selectedAddresses.isEmpty) {
      return;
    }
    state = const MemoryToolSavedItemSelectionState();
  }
}
