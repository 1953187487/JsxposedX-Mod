// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_tool_saved_items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(savedItemsForSelectedProcess)
const savedItemsForSelectedProcessProvider =
    SavedItemsForSelectedProcessProvider._();

final class SavedItemsForSelectedProcessProvider
    extends
        $FunctionalProvider<
          List<MemoryToolSavedItem>,
          List<MemoryToolSavedItem>,
          List<MemoryToolSavedItem>
        >
    with $Provider<List<MemoryToolSavedItem>> {
  const SavedItemsForSelectedProcessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedItemsForSelectedProcessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedItemsForSelectedProcessHash();

  @$internal
  @override
  $ProviderElement<List<MemoryToolSavedItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<MemoryToolSavedItem> create(Ref ref) {
    return savedItemsForSelectedProcess(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MemoryToolSavedItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MemoryToolSavedItem>>(value),
    );
  }
}

String _$savedItemsForSelectedProcessHash() =>
    r'c0bd46039b343b787ebaea7bcc84f98b38e5d6fe';

@ProviderFor(currentSavedItemLivePreviews)
const currentSavedItemLivePreviewsProvider =
    CurrentSavedItemLivePreviewsProvider._();

final class CurrentSavedItemLivePreviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, MemoryValuePreview>>,
          Map<int, MemoryValuePreview>,
          FutureOr<Map<int, MemoryValuePreview>>
        >
    with
        $FutureModifier<Map<int, MemoryValuePreview>>,
        $FutureProvider<Map<int, MemoryValuePreview>> {
  const CurrentSavedItemLivePreviewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSavedItemLivePreviewsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSavedItemLivePreviewsHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, MemoryValuePreview>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, MemoryValuePreview>> create(Ref ref) {
    return currentSavedItemLivePreviews(ref);
  }
}

String _$currentSavedItemLivePreviewsHash() =>
    r'5d8263c70a8cc7c21721d81a1639ce49c47406e0';

@ProviderFor(MemoryToolSavedItems)
const memoryToolSavedItemsProvider = MemoryToolSavedItemsProvider._();

final class MemoryToolSavedItemsProvider
    extends $NotifierProvider<MemoryToolSavedItems, MemoryToolSavedItemsState> {
  const MemoryToolSavedItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryToolSavedItemsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryToolSavedItemsHash();

  @$internal
  @override
  MemoryToolSavedItems create() => MemoryToolSavedItems();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryToolSavedItemsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoryToolSavedItemsState>(value),
    );
  }
}

String _$memoryToolSavedItemsHash() =>
    r'2de4457d1d5244e615658872d71b30c0d8602a4c';

abstract class _$MemoryToolSavedItems
    extends $Notifier<MemoryToolSavedItemsState> {
  MemoryToolSavedItemsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<MemoryToolSavedItemsState, MemoryToolSavedItemsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MemoryToolSavedItemsState, MemoryToolSavedItemsState>,
              MemoryToolSavedItemsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MemoryToolSavedItemSelection)
const memoryToolSavedItemSelectionProvider =
    MemoryToolSavedItemSelectionProvider._();

final class MemoryToolSavedItemSelectionProvider
    extends
        $NotifierProvider<
          MemoryToolSavedItemSelection,
          MemoryToolSavedItemSelectionState
        > {
  const MemoryToolSavedItemSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryToolSavedItemSelectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryToolSavedItemSelectionHash();

  @$internal
  @override
  MemoryToolSavedItemSelection create() => MemoryToolSavedItemSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryToolSavedItemSelectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoryToolSavedItemSelectionState>(
        value,
      ),
    );
  }
}

String _$memoryToolSavedItemSelectionHash() =>
    r'225bdc35c51a8c1f4a7a97eda33d0326a9453e32';

abstract class _$MemoryToolSavedItemSelection
    extends $Notifier<MemoryToolSavedItemSelectionState> {
  MemoryToolSavedItemSelectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              MemoryToolSavedItemSelectionState,
              MemoryToolSavedItemSelectionState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                MemoryToolSavedItemSelectionState,
                MemoryToolSavedItemSelectionState
              >,
              MemoryToolSavedItemSelectionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
