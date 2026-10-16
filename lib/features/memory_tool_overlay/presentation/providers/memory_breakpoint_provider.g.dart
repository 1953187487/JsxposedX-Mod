// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_breakpoint_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getMemoryBreakpoints)
const getMemoryBreakpointsProvider = GetMemoryBreakpointsFamily._();

final class GetMemoryBreakpointsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemoryBreakpoint>>,
          List<MemoryBreakpoint>,
          FutureOr<List<MemoryBreakpoint>>
        >
    with
        $FutureModifier<List<MemoryBreakpoint>>,
        $FutureProvider<List<MemoryBreakpoint>> {
  const GetMemoryBreakpointsProvider._({
    required GetMemoryBreakpointsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getMemoryBreakpointsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getMemoryBreakpointsHash();

  @override
  String toString() {
    return r'getMemoryBreakpointsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MemoryBreakpoint>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MemoryBreakpoint>> create(Ref ref) {
    final argument = this.argument as int;
    return getMemoryBreakpoints(ref, pid: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMemoryBreakpointsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getMemoryBreakpointsHash() =>
    r'5adb2554a6ce9a6c9bbbdc06671f2247f8663ac5';

final class GetMemoryBreakpointsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MemoryBreakpoint>>, int> {
  const GetMemoryBreakpointsFamily._()
    : super(
        retry: null,
        name: r'getMemoryBreakpointsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetMemoryBreakpointsProvider call({required int pid}) =>
      GetMemoryBreakpointsProvider._(argument: pid, from: this);

  @override
  String toString() => r'getMemoryBreakpointsProvider';
}

@ProviderFor(getMemoryBreakpointState)
const getMemoryBreakpointStateProvider = GetMemoryBreakpointStateFamily._();

final class GetMemoryBreakpointStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<MemoryBreakpointState>,
          MemoryBreakpointState,
          FutureOr<MemoryBreakpointState>
        >
    with
        $FutureModifier<MemoryBreakpointState>,
        $FutureProvider<MemoryBreakpointState> {
  const GetMemoryBreakpointStateProvider._({
    required GetMemoryBreakpointStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getMemoryBreakpointStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getMemoryBreakpointStateHash();

  @override
  String toString() {
    return r'getMemoryBreakpointStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MemoryBreakpointState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MemoryBreakpointState> create(Ref ref) {
    final argument = this.argument as int;
    return getMemoryBreakpointState(ref, pid: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMemoryBreakpointStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getMemoryBreakpointStateHash() =>
    r'6aff4f34204eb4a595b3637eaeabe85548efb3de';

final class GetMemoryBreakpointStateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MemoryBreakpointState>, int> {
  const GetMemoryBreakpointStateFamily._()
    : super(
        retry: null,
        name: r'getMemoryBreakpointStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetMemoryBreakpointStateProvider call({required int pid}) =>
      GetMemoryBreakpointStateProvider._(argument: pid, from: this);

  @override
  String toString() => r'getMemoryBreakpointStateProvider';
}

@ProviderFor(getMemoryBreakpointHits)
const getMemoryBreakpointHitsProvider = GetMemoryBreakpointHitsFamily._();

final class GetMemoryBreakpointHitsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MemoryBreakpointHit>>,
          List<MemoryBreakpointHit>,
          FutureOr<List<MemoryBreakpointHit>>
        >
    with
        $FutureModifier<List<MemoryBreakpointHit>>,
        $FutureProvider<List<MemoryBreakpointHit>> {
  const GetMemoryBreakpointHitsProvider._({
    required GetMemoryBreakpointHitsFamily super.from,
    required ({int pid, int offset, int limit}) super.argument,
  }) : super(
         retry: null,
         name: r'getMemoryBreakpointHitsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getMemoryBreakpointHitsHash();

  @override
  String toString() {
    return r'getMemoryBreakpointHitsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<MemoryBreakpointHit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MemoryBreakpointHit>> create(Ref ref) {
    final argument = this.argument as ({int pid, int offset, int limit});
    return getMemoryBreakpointHits(
      ref,
      pid: argument.pid,
      offset: argument.offset,
      limit: argument.limit,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetMemoryBreakpointHitsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getMemoryBreakpointHitsHash() =>
    r'59b42ce4878f2f39c43c8a8756a80232b742744c';

final class GetMemoryBreakpointHitsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<MemoryBreakpointHit>>,
          ({int pid, int offset, int limit})
        > {
  const GetMemoryBreakpointHitsFamily._()
    : super(
        retry: null,
        name: r'getMemoryBreakpointHitsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetMemoryBreakpointHitsProvider call({
    required int pid,
    int offset = 0,
    int limit = 100,
  }) => GetMemoryBreakpointHitsProvider._(
    argument: (pid: pid, offset: offset, limit: limit),
    from: this,
  );

  @override
  String toString() => r'getMemoryBreakpointHitsProvider';
}

@ProviderFor(MemoryBreakpointSelectedId)
const memoryBreakpointSelectedIdProvider =
    MemoryBreakpointSelectedIdProvider._();

final class MemoryBreakpointSelectedIdProvider
    extends $NotifierProvider<MemoryBreakpointSelectedId, String?> {
  const MemoryBreakpointSelectedIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryBreakpointSelectedIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryBreakpointSelectedIdHash();

  @$internal
  @override
  MemoryBreakpointSelectedId create() => MemoryBreakpointSelectedId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$memoryBreakpointSelectedIdHash() =>
    r'841a393b20b8eb4019e7a1139c9d906edde0c6ad';

abstract class _$MemoryBreakpointSelectedId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MemoryBreakpointAction)
const memoryBreakpointActionProvider = MemoryBreakpointActionProvider._();

final class MemoryBreakpointActionProvider
    extends $NotifierProvider<MemoryBreakpointAction, AsyncValue<void>> {
  const MemoryBreakpointActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryBreakpointActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryBreakpointActionHash();

  @$internal
  @override
  MemoryBreakpointAction create() => MemoryBreakpointAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$memoryBreakpointActionHash() =>
    r'ee051c7e9aa9f8e61ca31f86c711e52d05af9aa3';

abstract class _$MemoryBreakpointAction extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
