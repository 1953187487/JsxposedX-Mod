// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'f04ae52b39f02c2fb9c884b17023fd6113b8f67a';

/// 通用存储服务，用于存放 UI 层持久化数据（如聊天记录）
/// 区别于 PiniaNative (专用于 Xposed 跨进程配置)

@ProviderFor(AppStorage)
const appStorageProvider = AppStorageProvider._();

/// 通用存储服务，用于存放 UI 层持久化数据（如聊天记录）
/// 区别于 PiniaNative (专用于 Xposed 跨进程配置)
final class AppStorageProvider
    extends $AsyncNotifierProvider<AppStorage, void> {
  /// 通用存储服务，用于存放 UI 层持久化数据（如聊天记录）
  /// 区别于 PiniaNative (专用于 Xposed 跨进程配置)
  const AppStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStorageHash();

  @$internal
  @override
  AppStorage create() => AppStorage();
}

String _$appStorageHash() => r'92ce3e8fd423116f3bf8af1a3c9ff75e8b602545';

/// 通用存储服务，用于存放 UI 层持久化数据（如聊天记录）
/// 区别于 PiniaNative (专用于 Xposed 跨进程配置)

abstract class _$AppStorage extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
