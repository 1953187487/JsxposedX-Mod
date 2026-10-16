import 'package:JsxposedX/features/memory_tool_overlay/data/datasources/memory_action_datasource.dart';
import 'package:JsxposedX/features/memory_tool_overlay/data/repositories/memory_action_repository_impl.dart';
import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_action_repository.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_breakpoint_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_browse_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_saved_items_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/states/memory_tool_value_history_state.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_search_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memory_action_provider.g.dart';

@riverpod
MemoryActionDatasource memoryActionDatasource(Ref ref) {
  return MemoryActionDatasource();
}

@riverpod
MemoryActionRepository memoryActionRepository(Ref ref) {
  final dataSource = ref.watch(memoryActionDatasourceProvider);
  return MemoryActionRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<List<FrozenMemoryValue>> currentFrozenMemoryValues(Ref ref) async {
  return await ref
      .watch(memoryActionRepositoryProvider)
      .getFrozenMemoryValues();
}

@riverpod
Future<bool> processPaused(Ref ref, {required int pid}) async {
  return await ref
      .watch(memoryActionRepositoryProvider)
      .isProcessPaused(pid: pid);
}

@Riverpod(keepAlive: true)
class MemoryValueHistory extends _$MemoryValueHistory {
  @override
  Map<int, MemoryToolValueHistoryEntryState> build() {
    return const <int, MemoryToolValueHistoryEntryState>{};
  }

  void recordPreview(MemoryValuePreview preview) {
    state = <int, MemoryToolValueHistoryEntryState>{
      ...state,
      preview.address: MemoryToolValueHistoryEntryState.fromPreview(preview),
    };
  }

  void remove(int address) {
    if (!state.containsKey(address)) {
      return;
    }

    final nextState = Map<int, MemoryToolValueHistoryEntryState>.from(state);
    nextState.remove(address);
    state = nextState;
  }

  void clear() {
    if (state.isEmpty) {
      return;
    }
    state = const <int, MemoryToolValueHistoryEntryState>{};
  }
}

@Riverpod(keepAlive: true)
class MemorySearchAction extends _$MemorySearchAction {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> firstScan({required FirstScanRequest request}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(memoryActionRepositoryProvider)
          .firstScan(request: request);
      ref.read(memoryValueHistoryProvider.notifier).clear();
      ref.read(memoryToolRemovedResultProvider.notifier).clear();
      _invalidateSearchQueries();
    });
  }

  Future<void> nextScan({required NextScanRequest request}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(memoryActionRepositoryProvider).nextScan(request: request);
      _invalidateSearchQueries();
    });
  }

  Future<void> cancelSearch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(memoryActionRepositoryProvider).cancelSearch();
      _invalidateSearchQueries();
    });
  }

  Future<void> resetSearchSession() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(memoryActionRepositoryProvider).resetSearchSession();
      ref.read(memoryValueHistoryProvider.notifier).clear();
      ref.read(memoryToolRemovedResultProvider.notifier).clear();
      _invalidateSearchQueries();
    });
  }

  void _invalidateSearchQueries() {
    ref.invalidate(getSearchSessionStateProvider);
    ref.invalidate(getSearchTaskStateProvider);
    ref.invalidate(getSearchResultsProvider);
    ref.invalidate(hasMatchingSearchSessionProvider);
    ref.invalidate(currentSearchResultsProvider);
    ref.invalidate(currentSearchResultLivePreviewsProvider);
  }
}

@Riverpod(keepAlive: true)
class MemoryValueAction extends _$MemoryValueAction {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> writeMemoryValue({
    required MemoryWriteRequest request,
    MemoryValuePreview? previousPreview,
    int? syncPid,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      await ref
          .read(memoryActionRepositoryProvider)
          .writeMemoryValue(request: request);
      if (previousPreview != null) {
        ref
            .read(memoryValueHistoryProvider.notifier)
            .recordPreview(previousPreview);
      }
      await _syncSavedItemsForPid(
        pid: syncPid,
        addresses: <int>[request.address],
        valueTypesByAddress: <int, SearchValueType>{
          request.address: request.value.type,
        },
      );
      _invalidateValueQueries();
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }

  Future<MemoryInstructionPatchResult> patchMemoryInstruction({
    required MemoryInstructionPatchRequest request,
    int? syncPid,
  }) async {
    state = const AsyncValue.loading();
    MemoryInstructionPatchResult? result;
    final nextState = await AsyncValue.guard(() async {
      result = await ref
          .read(memoryActionRepositoryProvider)
          .patchMemoryInstruction(request: request);
      await _syncInstructionEntriesForPid(
        pid: syncPid,
        addresses: <int>[request.address],
      );
      ref.invalidate(getMemoryBreakpointStateProvider(pid: request.pid));
      ref.invalidate(getMemoryBreakpointsProvider(pid: request.pid));
      ref.invalidate(getMemoryBreakpointHitsProvider(pid: request.pid));
      _invalidateValueQueries();
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
    return result!;
  }

  Future<void> setMemoryFreeze({
    required MemoryFreezeRequest request,
    int? syncPid,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      await ref
          .read(memoryActionRepositoryProvider)
          .setMemoryFreeze(request: request);
      await _syncSavedItemsForPid(
        pid: syncPid,
        addresses: <int>[request.address],
        frozenStatesByAddress: <int, bool>{request.address: request.enabled},
        valueTypesByAddress: <int, SearchValueType>{
          request.address: request.value.type,
        },
      );
      _invalidateValueQueries();
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }

  Future<void> setMemoryFreezes({
    required List<MemoryFreezeRequest> requests,
    int? syncPid,
  }) async {
    if (requests.isEmpty) {
      return;
    }

    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      final repository = ref.read(memoryActionRepositoryProvider);
      for (final request in requests) {
        await repository.setMemoryFreeze(request: request);
      }
      await _syncSavedItemsForPid(
        pid: syncPid,
        addresses: requests.map((request) => request.address),
        frozenStatesByAddress: <int, bool>{
          for (final request in requests) request.address: request.enabled,
        },
        valueTypesByAddress: <int, SearchValueType>{
          for (final request in requests) request.address: request.value.type,
        },
      );
      _invalidateValueQueries();
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }

  Future<void> writeMemoryValues({
    required List<MemoryWriteRequest> requests,
    required List<MemoryValuePreview> previousPreviews,
    int? syncPid,
  }) async {
    if (requests.isEmpty) {
      return;
    }

    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      final repository = ref.read(memoryActionRepositoryProvider);
      final historyController = ref.read(memoryValueHistoryProvider.notifier);
      final previousPreviewByAddress = <int, MemoryValuePreview>{
        for (final preview in previousPreviews) preview.address: preview,
      };

      for (final request in requests) {
        await repository.writeMemoryValue(request: request);
        final previousPreview = previousPreviewByAddress[request.address];
        if (previousPreview != null) {
          historyController.recordPreview(previousPreview);
        }
      }

      await _syncSavedItemsForPid(
        pid: syncPid,
        addresses: requests.map((request) => request.address),
        valueTypesByAddress: <int, SearchValueType>{
          for (final request in requests) request.address: request.value.type,
        },
      );
      _invalidateValueQueries();
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }

  Future<int> restorePreviousValues({
    required List<int> addresses,
    required bool littleEndian,
    int? pidOverride,
  }) async {
    final selectedPid = pidOverride ?? ref.read(memoryToolSelectedProcessProvider)?.pid;
    if (selectedPid == null) {
      return 0;
    }
    final historyState = ref.read(memoryValueHistoryProvider);
    final historyEntries = addresses
        .map((address) => historyState[address])
        .whereType<MemoryToolValueHistoryEntryState>()
        .toList(growable: false);
    if (historyEntries.isEmpty) {
      return 0;
    }

    int restoredCount = 0;
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      final currentPreviews = await ref
          .read(memoryQueryRepositoryProvider)
          .readMemoryValues(
            requests: historyEntries
                .map(
                  (entry) => MemoryReadRequest(
                    pid: selectedPid,
                    address: entry.address,
                    type: entry.type,
                    length: resolveMemoryToolReadLengthForType(
                      type: entry.type,
                      bytesLength: entry.rawBytes.length,
                    ),
                  ),
                )
                .toList(growable: false),
          );
      final currentPreviewByAddress = <int, MemoryValuePreview>{
        for (final preview in currentPreviews) preview.address: preview,
      };
      final repository = ref.read(memoryActionRepositoryProvider);
      final historyController = ref.read(memoryValueHistoryProvider.notifier);

      for (final entry in historyEntries) {
        final previousPreview = entry.toPreview();
        final restoreValue = buildMemoryToolWriteValue(
          type: previousPreview.type,
          input: previousPreview.displayValue,
          littleEndian: littleEndian,
          sourceType: previousPreview.type,
          sourceRawBytes: previousPreview.rawBytes,
          sourceDisplayValue: previousPreview.displayValue,
        );
        await repository.writeMemoryValue(
          request: MemoryWriteRequest(
            address: entry.address,
            value: restoreValue,
          ),
        );

        final currentPreview = currentPreviewByAddress[entry.address];
        if (currentPreview != null) {
          historyController.recordPreview(currentPreview);
        } else {
          historyController.remove(entry.address);
        }
        restoredCount += 1;
      }

      await _syncSavedItemsForPid(
        pid: selectedPid,
        addresses: historyEntries.map((entry) => entry.address),
        valueTypesByAddress: <int, SearchValueType>{
          for (final entry in historyEntries) entry.address: entry.type,
        },
      );
      _invalidateValueQueries();
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
    return restoredCount;
  }

  void _invalidateValueQueries() {
    ref.invalidate(readMemoryValuesProvider);
    ref.invalidate(currentSearchResultLivePreviewsProvider);
    ref.invalidate(currentBrowseResultLivePreviewsProvider);
    ref.invalidate(currentSavedItemLivePreviewsProvider);
    ref.invalidate(currentSavedInstructionPreviewsProvider);
    ref.invalidate(currentFrozenMemoryValuesProvider);
  }

  Future<void> _syncSavedItemsForPid({
    int? pid,
    required Iterable<int> addresses,
    Map<int, bool> frozenStatesByAddress = const <int, bool>{},
    Map<int, SearchValueType> valueTypesByAddress =
        const <int, SearchValueType>{},
  }) async {
    final selectedPid = pid ?? ref.read(memoryToolSelectedProcessProvider)?.pid;
    if (selectedPid == null) {
      return;
    }

    final itemsByAddress = ref
        .read(memoryToolSavedItemsProvider)
        .itemsByPid[selectedPid];
    if (itemsByAddress == null || itemsByAddress.isEmpty) {
      return;
    }

    final targetAddresses = addresses.toSet()
      ..removeWhere((address) => !itemsByAddress.containsKey(address));
    if (targetAddresses.isEmpty && frozenStatesByAddress.isEmpty) {
      return;
    }

    final previewRequests = <MemoryReadRequest>[
      for (final address in targetAddresses)
        if (itemsByAddress[address] case final item? when !item.isInstruction)
          MemoryReadRequest(
            pid: selectedPid,
            address: item.address,
            type: valueTypesByAddress[item.address] ?? item.type,
            length: resolveMemoryToolReadLengthForType(
              type: valueTypesByAddress[item.address] ?? item.type,
              bytesLength: item.rawBytes.length,
            ),
          ),
    ];

    try {
      final previews = previewRequests.isEmpty
          ? const <MemoryValuePreview>[]
          : await ref
                .read(memoryQueryRepositoryProvider)
                .readMemoryValues(requests: previewRequests);
      ref
          .read(memoryToolSavedItemsProvider.notifier)
          .syncValuePreviews(
            pid: selectedPid,
            previews: previews,
            frozenStatesByAddress: <int, bool>{
              for (final entry in frozenStatesByAddress.entries)
                if (itemsByAddress.containsKey(entry.key)) entry.key: entry.value,
            },
          );
    } catch (_) {
      // Best effort only. The write/freeze itself has already succeeded.
    }
  }

  Future<void> _syncInstructionEntriesForPid({
    int? pid,
    required Iterable<int> addresses,
  }) async {
    final selectedPid = pid ?? ref.read(memoryToolSelectedProcessProvider)?.pid;
    if (selectedPid == null) {
      return;
    }

    final itemsByAddress = ref
        .read(memoryToolSavedItemsProvider)
        .itemsByPid[selectedPid];
    if (itemsByAddress == null || itemsByAddress.isEmpty) {
      return;
    }

    final targetAddresses = addresses
        .where((address) {
          final item = itemsByAddress[address];
          return item?.isInstruction ?? false;
        })
        .toSet();
    if (targetAddresses.isEmpty) {
      await ref
          .read(memoryToolBrowseControllerProvider.notifier)
          .refreshVisibleInstructionResults(addresses: addresses);
      return;
    }

    try {
      final previews = await ref
          .read(memoryQueryRepositoryProvider)
          .disassembleMemory(
            pid: selectedPid,
            addresses: targetAddresses.toList(growable: false),
          );
      ref
          .read(memoryToolSavedItemsProvider.notifier)
          .syncInstructionPreviews(pid: selectedPid, previews: previews);
    } catch (_) {
      // Best effort only. The patch itself has already succeeded.
    }

    await ref
        .read(memoryToolBrowseControllerProvider.notifier)
        .refreshVisibleInstructionResults(addresses: addresses);
  }
}

@Riverpod(keepAlive: true)
class MemoryProcessControlAction extends _$MemoryProcessControlAction {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> setProcessPaused({
    required int pid,
    required bool paused,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      await ref
          .read(memoryActionRepositoryProvider)
          .setProcessPaused(pid: pid, paused: paused);
      ref.invalidate(processPausedProvider(pid: pid));
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }
}
