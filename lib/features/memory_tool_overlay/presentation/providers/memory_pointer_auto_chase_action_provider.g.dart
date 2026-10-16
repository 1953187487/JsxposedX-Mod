// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_pointer_auto_chase_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memoryPointerAutoChaseActionDatasource)
const memoryPointerAutoChaseActionDatasourceProvider =
    MemoryPointerAutoChaseActionDatasourceProvider._();

final class MemoryPointerAutoChaseActionDatasourceProvider
    extends
        $FunctionalProvider<
          MemoryPointerAutoChaseActionDatasource,
          MemoryPointerAutoChaseActionDatasource,
          MemoryPointerAutoChaseActionDatasource
        >
    with $Provider<MemoryPointerAutoChaseActionDatasource> {
  const MemoryPointerAutoChaseActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryPointerAutoChaseActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$memoryPointerAutoChaseActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<MemoryPointerAutoChaseActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MemoryPointerAutoChaseActionDatasource create(Ref ref) {
    return memoryPointerAutoChaseActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryPointerAutoChaseActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<MemoryPointerAutoChaseActionDatasource>(value),
    );
  }
}

String _$memoryPointerAutoChaseActionDatasourceHash() =>
    r'c42bc56030bd4cbdd3014d5d41097c68c5c049f8';

@ProviderFor(memoryPointerAutoChaseActionRepository)
const memoryPointerAutoChaseActionRepositoryProvider =
    MemoryPointerAutoChaseActionRepositoryProvider._();

final class MemoryPointerAutoChaseActionRepositoryProvider
    extends
        $FunctionalProvider<
          MemoryPointerAutoChaseActionRepository,
          MemoryPointerAutoChaseActionRepository,
          MemoryPointerAutoChaseActionRepository
        >
    with $Provider<MemoryPointerAutoChaseActionRepository> {
  const MemoryPointerAutoChaseActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryPointerAutoChaseActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$memoryPointerAutoChaseActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<MemoryPointerAutoChaseActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MemoryPointerAutoChaseActionRepository create(Ref ref) {
    return memoryPointerAutoChaseActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryPointerAutoChaseActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<MemoryPointerAutoChaseActionRepository>(value),
    );
  }
}

String _$memoryPointerAutoChaseActionRepositoryHash() =>
    r'd1bd3b6c3121cf241e2ea89db5fcabbab83887c5';

@ProviderFor(MemoryPointerAutoChaseAction)
const memoryPointerAutoChaseActionProvider =
    MemoryPointerAutoChaseActionProvider._();

final class MemoryPointerAutoChaseActionProvider
    extends $NotifierProvider<MemoryPointerAutoChaseAction, AsyncValue<void>> {
  const MemoryPointerAutoChaseActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryPointerAutoChaseActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryPointerAutoChaseActionHash();

  @$internal
  @override
  MemoryPointerAutoChaseAction create() => MemoryPointerAutoChaseAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$memoryPointerAutoChaseActionHash() =>
    r'1a757903bb399dba617e652200eb39be0d56bd15';

abstract class _$MemoryPointerAutoChaseAction
    extends $Notifier<AsyncValue<void>> {
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
