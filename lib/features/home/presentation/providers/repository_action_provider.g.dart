// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(repositoryActionRepository)
const repositoryActionRepositoryProvider =
    RepositoryActionRepositoryProvider._();

final class RepositoryActionRepositoryProvider
    extends
        $FunctionalProvider<
          RepositoryActionRepository,
          RepositoryActionRepository,
          RepositoryActionRepository
        >
    with $Provider<RepositoryActionRepository> {
  const RepositoryActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositoryActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositoryActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<RepositoryActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RepositoryActionRepository create(Ref ref) {
    return repositoryActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RepositoryActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RepositoryActionRepository>(value),
    );
  }
}

String _$repositoryActionRepositoryHash() =>
    r'7d1e4daae66659d55a8e878ba5318df2a5dae2e1';
