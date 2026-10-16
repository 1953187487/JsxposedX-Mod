// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_catalog_actions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiCatalogActionsV2)
const aiCatalogActionsV2Provider = AiCatalogActionsV2Provider._();

final class AiCatalogActionsV2Provider
    extends $NotifierProvider<AiCatalogActionsV2, AsyncValue<void>> {
  const AiCatalogActionsV2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiCatalogActionsV2Provider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiCatalogActionsV2Hash();

  @$internal
  @override
  AiCatalogActionsV2 create() => AiCatalogActionsV2();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$aiCatalogActionsV2Hash() =>
    r'67d579db0c5624cad1f5eecbe23369db3a8b1a2e';

abstract class _$AiCatalogActionsV2 extends $Notifier<AsyncValue<void>> {
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
