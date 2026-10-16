// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dio 实例 Provider

@ProviderFor(dio)
const dioProvider = DioProvider._();

/// Dio 实例 Provider

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio 实例 Provider
  const DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'5f9941b159630d10760abec9f36ab8fd75bc9a96';

/// HttpService Provider

@ProviderFor(httpService)
const httpServiceProvider = HttpServiceProvider._();

/// HttpService Provider

final class HttpServiceProvider
    extends $FunctionalProvider<HttpService, HttpService, HttpService>
    with $Provider<HttpService> {
  /// HttpService Provider
  const HttpServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpServiceHash();

  @$internal
  @override
  $ProviderElement<HttpService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HttpService create(Ref ref) {
    return httpService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpService>(value),
    );
  }
}

String _$httpServiceHash() => r'c33ce10ab50d03431c3e562b71d4a605be029417';
