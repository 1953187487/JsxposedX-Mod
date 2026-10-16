// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiConfigActionRepository)
const aiConfigActionRepositoryProvider = AiConfigActionRepositoryProvider._();

final class AiConfigActionRepositoryProvider
    extends
        $FunctionalProvider<
          AiConfigActionRepository,
          AiConfigActionRepository,
          AiConfigActionRepository
        >
    with $Provider<AiConfigActionRepository> {
  const AiConfigActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiConfigActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiConfigActionRepository create(Ref ref) {
    return aiConfigActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConfigActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConfigActionRepository>(value),
    );
  }
}

String _$aiConfigActionRepositoryHash() =>
    r'ecc47854ab1933c33fa3c0d0aafefa09dd4425ea';

/// 保存 AI 配置 Action Provider

@ProviderFor(AiConfigAction)
const aiConfigActionProvider = AiConfigActionProvider._();

/// 保存 AI 配置 Action Provider
final class AiConfigActionProvider
    extends $NotifierProvider<AiConfigAction, AsyncValue<void>> {
  /// 保存 AI 配置 Action Provider
  const AiConfigActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConfigActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConfigActionHash();

  @$internal
  @override
  AiConfigAction create() => AiConfigAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$aiConfigActionHash() => r'dc878c1080b3495fd504bc95ae458741ace230af';

/// 保存 AI 配置 Action Provider

abstract class _$AiConfigAction extends $Notifier<AsyncValue<void>> {
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
