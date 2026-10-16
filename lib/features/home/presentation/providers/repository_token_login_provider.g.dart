// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_token_login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RepositoryTokenLogin)
const repositoryTokenLoginProvider = RepositoryTokenLoginProvider._();

final class RepositoryTokenLoginProvider
    extends $AsyncNotifierProvider<RepositoryTokenLogin, UserDetail?> {
  const RepositoryTokenLoginProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositoryTokenLoginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositoryTokenLoginHash();

  @$internal
  @override
  RepositoryTokenLogin create() => RepositoryTokenLogin();
}

String _$repositoryTokenLoginHash() =>
    r'2e2a7c36ea9fef87a32a9bc024d7200ad6a811b5';

abstract class _$RepositoryTokenLogin extends $AsyncNotifier<UserDetail?> {
  FutureOr<UserDetail?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserDetail?>, UserDetail?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserDetail?>, UserDetail?>,
              AsyncValue<UserDetail?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
