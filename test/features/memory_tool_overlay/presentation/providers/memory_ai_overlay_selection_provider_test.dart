import 'dart:typed_data';

import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_display_item.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_entry_kind.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_saved_item.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_ai_overlay_selection_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_browse_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_saved_items_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_search_provider.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _hasMatchingSearchSessionStateProvider =
    NotifierProvider<_BoolTestNotifier, bool>(_BoolTestNotifier.new);
final _browseResultsStateProvider =
    NotifierProvider<_BrowseResultsTestNotifier, List<MemoryToolDisplayItem>>(
      _BrowseResultsTestNotifier.new,
    );
final _savedItemsStateProvider =
    NotifierProvider<_SavedItemsTestNotifier, List<MemoryToolSavedItem>>(
      _SavedItemsTestNotifier.new,
    );

void main() {
  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        hasMatchingSearchSessionProvider.overrideWith(
          (ref) => ref.watch(_hasMatchingSearchSessionStateProvider),
        ),
        currentBrowseResultsProvider.overrideWith(
          (ref) => ref.watch(_browseResultsStateProvider),
        ),
        savedItemsForSelectedProcessProvider.overrideWith(
          (ref) => ref.watch(_savedItemsStateProvider),
        ),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(memoryToolSelectedProcessProvider.notifier)
        .select(_processInfo(pid: 1001));
    return container;
  }

  test('returns true when only search has selected values', () {
    final container = createContainer();

    container.read(_hasMatchingSearchSessionStateProvider.notifier).set(true);
    container
        .read(memoryToolResultSelectionProvider.notifier)
        .toggle(_searchResult(address: 0x1000));

    expect(container.read(memoryAiOverlayHasSelectedValueProvider), isTrue);
  });

  test('returns true when only browse has selected values', () {
    final container = createContainer();
    final item = _displayItem(address: 0x2000);

    container.read(_browseResultsStateProvider.notifier).set(
      <MemoryToolDisplayItem>[item],
    );
    container.read(memoryToolBrowseControllerProvider.notifier).toggle(item);

    expect(container.read(memoryAiOverlayHasSelectedValueProvider), isTrue);
  });

  test('returns true when only saved has selected values', () {
    final container = createContainer();
    final item = _savedItem(pid: 1001, address: 0x3000);

    container.read(_savedItemsStateProvider.notifier).set(<MemoryToolSavedItem>[
      item,
    ]);
    container
        .read(memoryToolSavedItemSelectionProvider.notifier)
        .toggle(item.address);

    expect(container.read(memoryAiOverlayHasSelectedValueProvider), isTrue);
  });

  test('returns false when all selections are empty', () {
    final container = createContainer();

    expect(container.read(memoryAiOverlayHasSelectedValueProvider), isFalse);
  });

  test('returns false after switching process or clearing selection', () {
    final container = createContainer();
    final item = _savedItem(pid: 1001, address: 0x3000);

    container.read(_savedItemsStateProvider.notifier).set(<MemoryToolSavedItem>[
      item,
    ]);
    container
        .read(memoryToolSavedItemSelectionProvider.notifier)
        .toggle(item.address);
    expect(container.read(memoryAiOverlayHasSelectedValueProvider), isTrue);

    container
        .read(memoryToolSelectedProcessProvider.notifier)
        .select(_processInfo(pid: 2002));
    container
        .read(_savedItemsStateProvider.notifier)
        .set(const <MemoryToolSavedItem>[]);

    expect(container.read(memoryAiOverlayHasSelectedValueProvider), isFalse);

    container
        .read(memoryToolSavedItemSelectionProvider.notifier)
        .clearSelection();
    expect(container.read(memoryAiOverlayHasSelectedValueProvider), isFalse);
  });
}

ProcessInfo _processInfo({required int pid}) {
  return ProcessInfo(pid: pid, name: 'proc_$pid', packageName: 'pkg.$pid');
}

class _BoolTestNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }
}

class _BrowseResultsTestNotifier extends Notifier<List<MemoryToolDisplayItem>> {
  @override
  List<MemoryToolDisplayItem> build() => const <MemoryToolDisplayItem>[];

  void set(List<MemoryToolDisplayItem> value) {
    state = value;
  }
}

class _SavedItemsTestNotifier extends Notifier<List<MemoryToolSavedItem>> {
  @override
  List<MemoryToolSavedItem> build() => const <MemoryToolSavedItem>[];

  void set(List<MemoryToolSavedItem> value) {
    state = value;
  }
}

SearchResult _searchResult({required int address}) {
  return SearchResult(
    address: address,
    regionStart: address,
    regionTypeKey: 'anonymous',
    type: SearchValueType.i32,
    rawBytes: Uint8List.fromList(<int>[0x01, 0x00, 0x00, 0x00]),
    displayValue: '1',
  );
}

MemoryToolDisplayItem _displayItem({required int address}) {
  return MemoryToolDisplayItem(
    address: address,
    regionStart: address,
    regionTypeKey: 'anonymous',
    type: SearchValueType.i32,
    rawBytes: Uint8List.fromList(<int>[0x01, 0x00, 0x00, 0x00]),
    displayValue: '1',
  );
}

MemoryToolSavedItem _savedItem({required int pid, required int address}) {
  return MemoryToolSavedItem(
    pid: pid,
    address: address,
    regionStart: address,
    regionTypeKey: 'anonymous',
    type: SearchValueType.i32,
    rawBytes: Uint8List.fromList(<int>[0x01, 0x00, 0x00, 0x00]),
    displayValue: '1',
    isFrozen: false,
    entryKind: MemoryToolEntryKind.value,
  );
}
