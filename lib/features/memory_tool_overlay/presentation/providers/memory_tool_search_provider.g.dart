// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_tool_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hasMatchingSearchSession)
const hasMatchingSearchSessionProvider = HasMatchingSearchSessionProvider._();

final class HasMatchingSearchSessionProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const HasMatchingSearchSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasMatchingSearchSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasMatchingSearchSessionHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasMatchingSearchSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasMatchingSearchSessionHash() =>
    r'64de4e9ebae599d1bc7cb1d90eb8ff682202f130';

@ProviderFor(hasRunningSearchTask)
const hasRunningSearchTaskProvider = HasRunningSearchTaskProvider._();

final class HasRunningSearchTaskProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const HasRunningSearchTaskProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasRunningSearchTaskProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasRunningSearchTaskHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasRunningSearchTask(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasRunningSearchTaskHash() =>
    r'7eee66a056808bfa565a6e27a2ae4380acd927a6';

@ProviderFor(currentSearchResults)
const currentSearchResultsProvider = CurrentSearchResultsProvider._();

final class CurrentSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SearchResult>>,
          AsyncValue<List<SearchResult>>,
          AsyncValue<List<SearchResult>>
        >
    with $Provider<AsyncValue<List<SearchResult>>> {
  const CurrentSearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSearchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSearchResultsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<SearchResult>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<SearchResult>> create(Ref ref) {
    return currentSearchResults(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<SearchResult>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<SearchResult>>>(
        value,
      ),
    );
  }
}

String _$currentSearchResultsHash() =>
    r'9ee3aa19905020badfd4764dc6e98126067c8136';

@ProviderFor(currentSearchResultLivePreviews)
const currentSearchResultLivePreviewsProvider =
    CurrentSearchResultLivePreviewsProvider._();

final class CurrentSearchResultLivePreviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, MemoryValuePreview>>,
          Map<int, MemoryValuePreview>,
          FutureOr<Map<int, MemoryValuePreview>>
        >
    with
        $FutureModifier<Map<int, MemoryValuePreview>>,
        $FutureProvider<Map<int, MemoryValuePreview>> {
  const CurrentSearchResultLivePreviewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSearchResultLivePreviewsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSearchResultLivePreviewsHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, MemoryValuePreview>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, MemoryValuePreview>> create(Ref ref) {
    return currentSearchResultLivePreviews(ref);
  }
}

String _$currentSearchResultLivePreviewsHash() =>
    r'115ebeeb7ecdc0c66f0836bddbfaf22bf830dc30';

@ProviderFor(MemoryToolResultSelection)
const memoryToolResultSelectionProvider = MemoryToolResultSelectionProvider._();

final class MemoryToolResultSelectionProvider
    extends
        $NotifierProvider<
          MemoryToolResultSelection,
          MemoryToolResultSelectionState
        > {
  const MemoryToolResultSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryToolResultSelectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryToolResultSelectionHash();

  @$internal
  @override
  MemoryToolResultSelection create() => MemoryToolResultSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryToolResultSelectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoryToolResultSelectionState>(
        value,
      ),
    );
  }
}

String _$memoryToolResultSelectionHash() =>
    r'29b6662008cccf0af1900546c47cfa37edbb6d9f';

abstract class _$MemoryToolResultSelection
    extends $Notifier<MemoryToolResultSelectionState> {
  MemoryToolResultSelectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              MemoryToolResultSelectionState,
              MemoryToolResultSelectionState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                MemoryToolResultSelectionState,
                MemoryToolResultSelectionState
              >,
              MemoryToolResultSelectionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MemoryToolRemovedResult)
const memoryToolRemovedResultProvider = MemoryToolRemovedResultProvider._();

final class MemoryToolRemovedResultProvider
    extends
        $NotifierProvider<
          MemoryToolRemovedResult,
          MemoryToolRemovedResultState
        > {
  const MemoryToolRemovedResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryToolRemovedResultProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryToolRemovedResultHash();

  @$internal
  @override
  MemoryToolRemovedResult create() => MemoryToolRemovedResult();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryToolRemovedResultState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoryToolRemovedResultState>(value),
    );
  }
}

String _$memoryToolRemovedResultHash() =>
    r'47041611a0da6d4569364e4de46e77e2162e4b83';

abstract class _$MemoryToolRemovedResult
    extends $Notifier<MemoryToolRemovedResultState> {
  MemoryToolRemovedResultState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<MemoryToolRemovedResultState, MemoryToolRemovedResultState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                MemoryToolRemovedResultState,
                MemoryToolRemovedResultState
              >,
              MemoryToolRemovedResultState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MemoryToolSearchForm)
const memoryToolSearchFormProvider = MemoryToolSearchFormProvider._();

final class MemoryToolSearchFormProvider
    extends $NotifierProvider<MemoryToolSearchForm, MemoryToolSearchState> {
  const MemoryToolSearchFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryToolSearchFormProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryToolSearchFormHash();

  @$internal
  @override
  MemoryToolSearchForm create() => MemoryToolSearchForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryToolSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoryToolSearchState>(value),
    );
  }
}

String _$memoryToolSearchFormHash() =>
    r'e36336a9f10350c97b6d90eff670cd286d065793';

abstract class _$MemoryToolSearchForm extends $Notifier<MemoryToolSearchState> {
  MemoryToolSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MemoryToolSearchState, MemoryToolSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MemoryToolSearchState, MemoryToolSearchState>,
              MemoryToolSearchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
