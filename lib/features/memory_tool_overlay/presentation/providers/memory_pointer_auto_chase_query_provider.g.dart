// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_pointer_auto_chase_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memoryPointerAutoChaseQueryRepository)
const memoryPointerAutoChaseQueryRepositoryProvider =
    MemoryPointerAutoChaseQueryRepositoryProvider._();

final class MemoryPointerAutoChaseQueryRepositoryProvider
    extends
        $FunctionalProvider<
          MemoryPointerAutoChaseQueryRepository,
          MemoryPointerAutoChaseQueryRepository,
          MemoryPointerAutoChaseQueryRepository
        >
    with $Provider<MemoryPointerAutoChaseQueryRepository> {
  const MemoryPointerAutoChaseQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryPointerAutoChaseQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$memoryPointerAutoChaseQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<MemoryPointerAutoChaseQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MemoryPointerAutoChaseQueryRepository create(Ref ref) {
    return memoryPointerAutoChaseQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryPointerAutoChaseQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<MemoryPointerAutoChaseQueryRepository>(value),
    );
  }
}

String _$memoryPointerAutoChaseQueryRepositoryHash() =>
    r'4e50217989134f578986b671986e5eb05eaeec6b';

@ProviderFor(getPointerAutoChaseState)
const getPointerAutoChaseStateProvider = GetPointerAutoChaseStateProvider._();

final class GetPointerAutoChaseStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<PointerAutoChaseState>,
          PointerAutoChaseState,
          FutureOr<PointerAutoChaseState>
        >
    with
        $FutureModifier<PointerAutoChaseState>,
        $FutureProvider<PointerAutoChaseState> {
  const GetPointerAutoChaseStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPointerAutoChaseStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPointerAutoChaseStateHash();

  @$internal
  @override
  $FutureProviderElement<PointerAutoChaseState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PointerAutoChaseState> create(Ref ref) {
    return getPointerAutoChaseState(ref);
  }
}

String _$getPointerAutoChaseStateHash() =>
    r'fc68a401fc599326208fe278ea8a607a03b22963';

@ProviderFor(getPointerAutoChaseLayerResults)
const getPointerAutoChaseLayerResultsProvider =
    GetPointerAutoChaseLayerResultsFamily._();

final class GetPointerAutoChaseLayerResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PointerScanResult>>,
          List<PointerScanResult>,
          FutureOr<List<PointerScanResult>>
        >
    with
        $FutureModifier<List<PointerScanResult>>,
        $FutureProvider<List<PointerScanResult>> {
  const GetPointerAutoChaseLayerResultsProvider._({
    required GetPointerAutoChaseLayerResultsFamily super.from,
    required ({int layerIndex, int offset, int limit}) super.argument,
  }) : super(
         retry: null,
         name: r'getPointerAutoChaseLayerResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getPointerAutoChaseLayerResultsHash();

  @override
  String toString() {
    return r'getPointerAutoChaseLayerResultsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<PointerScanResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PointerScanResult>> create(Ref ref) {
    final argument = this.argument as ({int layerIndex, int offset, int limit});
    return getPointerAutoChaseLayerResults(
      ref,
      layerIndex: argument.layerIndex,
      offset: argument.offset,
      limit: argument.limit,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetPointerAutoChaseLayerResultsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getPointerAutoChaseLayerResultsHash() =>
    r'e9ad238689514546dc8b8d13dcdc7450a1af8da6';

final class GetPointerAutoChaseLayerResultsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<PointerScanResult>>,
          ({int layerIndex, int offset, int limit})
        > {
  const GetPointerAutoChaseLayerResultsFamily._()
    : super(
        retry: null,
        name: r'getPointerAutoChaseLayerResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetPointerAutoChaseLayerResultsProvider call({
    required int layerIndex,
    required int offset,
    required int limit,
  }) => GetPointerAutoChaseLayerResultsProvider._(
    argument: (layerIndex: layerIndex, offset: offset, limit: limit),
    from: this,
  );

  @override
  String toString() => r'getPointerAutoChaseLayerResultsProvider';
}
