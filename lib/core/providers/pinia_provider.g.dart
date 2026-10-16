// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinia_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Pinia 存储服务 Provider
/// 使用 Android 原生 SharedPreferences 实现持久化存储

@ProviderFor(pinia)
const piniaProvider = PiniaProvider._();

/// Pinia 存储服务 Provider
/// 使用 Android 原生 SharedPreferences 实现持久化存储

final class PiniaProvider
    extends $FunctionalProvider<PiniaNative, PiniaNative, PiniaNative>
    with $Provider<PiniaNative> {
  /// Pinia 存储服务 Provider
  /// 使用 Android 原生 SharedPreferences 实现持久化存储
  const PiniaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'piniaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$piniaHash();

  @$internal
  @override
  $ProviderElement<PiniaNative> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PiniaNative create(Ref ref) {
    return pinia(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PiniaNative value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PiniaNative>(value),
    );
  }
}

String _$piniaHash() => r'b5f7ee46491daf195fdf393b0ffc17cc8a8b02fb';

/// 默认 Provider (type=2, RemotePreferences)

@ProviderFor(piniaStorage)
const piniaStorageProvider = PiniaStorageProvider._();

/// 默认 Provider (type=2, RemotePreferences)

final class PiniaStorageProvider
    extends $FunctionalProvider<PiniaStorage, PiniaStorage, PiniaStorage>
    with $Provider<PiniaStorage> {
  /// 默认 Provider (type=2, RemotePreferences)
  const PiniaStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'piniaStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$piniaStorageHash();

  @$internal
  @override
  $ProviderElement<PiniaStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PiniaStorage create(Ref ref) {
    return piniaStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PiniaStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PiniaStorage>(value),
    );
  }
}

String _$piniaStorageHash() => r'55a11df581f61f7abf7a8bf9efcba02fe0813eb2';

/// 传统本地存储 Provider (type=1)

@ProviderFor(piniaStorageLocal)
const piniaStorageLocalProvider = PiniaStorageLocalProvider._();

/// 传统本地存储 Provider (type=1)

final class PiniaStorageLocalProvider
    extends $FunctionalProvider<PiniaStorage, PiniaStorage, PiniaStorage>
    with $Provider<PiniaStorage> {
  /// 传统本地存储 Provider (type=1)
  const PiniaStorageLocalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'piniaStorageLocalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$piniaStorageLocalHash();

  @$internal
  @override
  $ProviderElement<PiniaStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PiniaStorage create(Ref ref) {
    return piniaStorageLocal(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PiniaStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PiniaStorage>(value),
    );
  }
}

String _$piniaStorageLocalHash() => r'f3e2fd12a898b51b07e33ffe529c384c74169faa';
