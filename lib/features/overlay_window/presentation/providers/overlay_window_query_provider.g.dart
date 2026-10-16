// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_window_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(overlayWindowPlatformGateway)
const overlayWindowPlatformGatewayProvider =
    OverlayWindowPlatformGatewayProvider._();

final class OverlayWindowPlatformGatewayProvider
    extends
        $FunctionalProvider<
          OverlayWindowPlatformGateway,
          OverlayWindowPlatformGateway,
          OverlayWindowPlatformGateway
        >
    with $Provider<OverlayWindowPlatformGateway> {
  const OverlayWindowPlatformGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overlayWindowPlatformGatewayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overlayWindowPlatformGatewayHash();

  @$internal
  @override
  $ProviderElement<OverlayWindowPlatformGateway> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OverlayWindowPlatformGateway create(Ref ref) {
    return overlayWindowPlatformGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverlayWindowPlatformGateway value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverlayWindowPlatformGateway>(value),
    );
  }
}

String _$overlayWindowPlatformGatewayHash() =>
    r'2b6c8053fc0dfec8e7e5960a8959d1768a08db8a';

@ProviderFor(overlayWindowQueryDatasource)
const overlayWindowQueryDatasourceProvider =
    OverlayWindowQueryDatasourceProvider._();

final class OverlayWindowQueryDatasourceProvider
    extends
        $FunctionalProvider<
          OverlayWindowQueryDatasource,
          OverlayWindowQueryDatasource,
          OverlayWindowQueryDatasource
        >
    with $Provider<OverlayWindowQueryDatasource> {
  const OverlayWindowQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overlayWindowQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overlayWindowQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<OverlayWindowQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OverlayWindowQueryDatasource create(Ref ref) {
    return overlayWindowQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverlayWindowQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverlayWindowQueryDatasource>(value),
    );
  }
}

String _$overlayWindowQueryDatasourceHash() =>
    r'e2a6d5a217cbb799f6cd643c6d3ad2585e720a57';

@ProviderFor(overlayWindowQueryRepository)
const overlayWindowQueryRepositoryProvider =
    OverlayWindowQueryRepositoryProvider._();

final class OverlayWindowQueryRepositoryProvider
    extends
        $FunctionalProvider<
          OverlayWindowQueryRepository,
          OverlayWindowQueryRepository,
          OverlayWindowQueryRepository
        >
    with $Provider<OverlayWindowQueryRepository> {
  const OverlayWindowQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overlayWindowQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overlayWindowQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<OverlayWindowQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OverlayWindowQueryRepository create(Ref ref) {
    return overlayWindowQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverlayWindowQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverlayWindowQueryRepository>(value),
    );
  }
}

String _$overlayWindowQueryRepositoryHash() =>
    r'8990e5da327da9d1fb71a482139166a2c58bd953';

@ProviderFor(overlayWindowStatus)
const overlayWindowStatusProvider = OverlayWindowStatusProvider._();

final class OverlayWindowStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<OverlayWindowStatus>,
          OverlayWindowStatus,
          FutureOr<OverlayWindowStatus>
        >
    with
        $FutureModifier<OverlayWindowStatus>,
        $FutureProvider<OverlayWindowStatus> {
  const OverlayWindowStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overlayWindowStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overlayWindowStatusHash();

  @$internal
  @override
  $FutureProviderElement<OverlayWindowStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OverlayWindowStatus> create(Ref ref) {
    return overlayWindowStatus(ref);
  }
}

String _$overlayWindowStatusHash() =>
    r'e965038d080d959a3c875660646a59403f053cd1';
