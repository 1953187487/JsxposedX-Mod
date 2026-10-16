// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disabled_tools_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 持久化每个 configId 对应的被禁用工具名称集合

@ProviderFor(DisabledToolsStore)
const disabledToolsStoreProvider = DisabledToolsStoreProvider._();

/// 持久化每个 configId 对应的被禁用工具名称集合
final class DisabledToolsStoreProvider
    extends $NotifierProvider<DisabledToolsStore, Map<String, Set<String>>> {
  /// 持久化每个 configId 对应的被禁用工具名称集合
  const DisabledToolsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disabledToolsStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disabledToolsStoreHash();

  @$internal
  @override
  DisabledToolsStore create() => DisabledToolsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Set<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Set<String>>>(value),
    );
  }
}

String _$disabledToolsStoreHash() =>
    r'a05f1f0479ae80ef3ccfa92ab3b82189a6e2ac98';

/// 持久化每个 configId 对应的被禁用工具名称集合

abstract class _$DisabledToolsStore
    extends $Notifier<Map<String, Set<String>>> {
  Map<String, Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Map<String, Set<String>>, Map<String, Set<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, Set<String>>, Map<String, Set<String>>>,
              Map<String, Set<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
