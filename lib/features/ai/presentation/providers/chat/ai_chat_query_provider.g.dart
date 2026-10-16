// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiChatQueryDatasource)
const aiChatQueryDatasourceProvider = AiChatQueryDatasourceProvider._();

final class AiChatQueryDatasourceProvider
    extends
        $FunctionalProvider<
          AiChatQueryDatasource,
          AiChatQueryDatasource,
          AiChatQueryDatasource
        >
    with $Provider<AiChatQueryDatasource> {
  const AiChatQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<AiChatQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiChatQueryDatasource create(Ref ref) {
    return aiChatQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatQueryDatasource>(value),
    );
  }
}

String _$aiChatQueryDatasourceHash() =>
    r'c7b5dc4c7327fbc27da24febb554a77c9c24d0f8';

@ProviderFor(aiChatQueryRepository)
const aiChatQueryRepositoryProvider = AiChatQueryRepositoryProvider._();

final class AiChatQueryRepositoryProvider
    extends
        $FunctionalProvider<
          AiChatQueryRepository,
          AiChatQueryRepository,
          AiChatQueryRepository
        >
    with $Provider<AiChatQueryRepository> {
  const AiChatQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiChatQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiChatQueryRepository create(Ref ref) {
    return aiChatQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatQueryRepository>(value),
    );
  }
}

String _$aiChatQueryRepositoryHash() =>
    r'e9e806b8a68589822f3da1ee3ff9183a2f19280e';
