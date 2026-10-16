// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 状态管理原生接口 Provider

@ProviderFor(statusManagementNative)
const statusManagementNativeProvider = StatusManagementNativeProvider._();

/// 状态管理原生接口 Provider

final class StatusManagementNativeProvider
    extends
        $FunctionalProvider<
          StatusManagementNative,
          StatusManagementNative,
          StatusManagementNative
        >
    with $Provider<StatusManagementNative> {
  /// 状态管理原生接口 Provider
  const StatusManagementNativeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statusManagementNativeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statusManagementNativeHash();

  @$internal
  @override
  $ProviderElement<StatusManagementNative> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StatusManagementNative create(Ref ref) {
    return statusManagementNative(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatusManagementNative value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatusManagementNative>(value),
    );
  }
}

String _$statusManagementNativeHash() =>
    r'13fdf3146fd54211c59605db3342803cad92cf24';

/// Hook 状态 Provider

@ProviderFor(isHook)
const isHookProvider = IsHookProvider._();

/// Hook 状态 Provider

final class IsHookProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Hook 状态 Provider
  const IsHookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isHookProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isHookHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isHook(ref);
  }
}

String _$isHookHash() => r'c0d301b359a17e9236325dae601804d9776e2613';

/// Root 状态 Provider（轮询检测）

@ProviderFor(IsRoot)
const isRootProvider = IsRootProvider._();

/// Root 状态 Provider（轮询检测）
final class IsRootProvider extends $AsyncNotifierProvider<IsRoot, bool> {
  /// Root 状态 Provider（轮询检测）
  const IsRootProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isRootProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isRootHash();

  @$internal
  @override
  IsRoot create() => IsRoot();
}

String _$isRootHash() => r'9814f7136248209ea423167a458a360d1346cb61';

/// Root 状态 Provider（轮询检测）

abstract class _$IsRoot extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Frida 状态 Provider（异步检测，不轮询）

@ProviderFor(IsFrida)
const isFridaProvider = IsFridaProvider._();

/// Frida 状态 Provider（异步检测，不轮询）
final class IsFridaProvider
    extends $AsyncNotifierProvider<IsFrida, FridaStatusData> {
  /// Frida 状态 Provider（异步检测，不轮询）
  const IsFridaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isFridaProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isFridaHash();

  @$internal
  @override
  IsFrida create() => IsFrida();
}

String _$isFridaHash() => r'f310a7bbc055ca9b5d14f19896bd9c0f50ce6ac1';

/// Frida 状态 Provider（异步检测，不轮询）

abstract class _$IsFrida extends $AsyncNotifier<FridaStatusData> {
  FutureOr<FridaStatusData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<FridaStatusData>, FridaStatusData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FridaStatusData>, FridaStatusData>,
              AsyncValue<FridaStatusData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
