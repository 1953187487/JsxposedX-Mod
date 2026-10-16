// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_window_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(overlayWindowActionDatasource)
const overlayWindowActionDatasourceProvider =
    OverlayWindowActionDatasourceProvider._();

final class OverlayWindowActionDatasourceProvider
    extends
        $FunctionalProvider<
          OverlayWindowActionDatasource,
          OverlayWindowActionDatasource,
          OverlayWindowActionDatasource
        >
    with $Provider<OverlayWindowActionDatasource> {
  const OverlayWindowActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overlayWindowActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overlayWindowActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<OverlayWindowActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OverlayWindowActionDatasource create(Ref ref) {
    return overlayWindowActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverlayWindowActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverlayWindowActionDatasource>(
        value,
      ),
    );
  }
}

String _$overlayWindowActionDatasourceHash() =>
    r'38f3892631caf44442327a22b1e5fb6d6d54d520';

@ProviderFor(overlayWindowActionRepository)
const overlayWindowActionRepositoryProvider =
    OverlayWindowActionRepositoryProvider._();

final class OverlayWindowActionRepositoryProvider
    extends
        $FunctionalProvider<
          OverlayWindowActionRepository,
          OverlayWindowActionRepository,
          OverlayWindowActionRepository
        >
    with $Provider<OverlayWindowActionRepository> {
  const OverlayWindowActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overlayWindowActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overlayWindowActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<OverlayWindowActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OverlayWindowActionRepository create(Ref ref) {
    return overlayWindowActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverlayWindowActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverlayWindowActionRepository>(
        value,
      ),
    );
  }
}

String _$overlayWindowActionRepositoryHash() =>
    r'71906a0c93b8767322b635ef4c49915ab412eae8';

@ProviderFor(OverlayWindowAction)
const overlayWindowActionProvider = OverlayWindowActionProvider._();

final class OverlayWindowActionProvider
    extends $NotifierProvider<OverlayWindowAction, AsyncValue<void>> {
  const OverlayWindowActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overlayWindowActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overlayWindowActionHash();

  @$internal
  @override
  OverlayWindowAction create() => OverlayWindowAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$overlayWindowActionHash() =>
    r'0eed6436f359345726e1f29c0752adb5b4ac779c';

abstract class _$OverlayWindowAction extends $Notifier<AsyncValue<void>> {
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
