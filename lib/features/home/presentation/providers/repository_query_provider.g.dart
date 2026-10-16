// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(repositoryQueryRepository)
const repositoryQueryRepositoryProvider = RepositoryQueryRepositoryProvider._();

final class RepositoryQueryRepositoryProvider
    extends
        $FunctionalProvider<
          RepositoryQueryRepository,
          RepositoryQueryRepository,
          RepositoryQueryRepository
        >
    with $Provider<RepositoryQueryRepository> {
  const RepositoryQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repositoryQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repositoryQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<RepositoryQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RepositoryQueryRepository create(Ref ref) {
    return repositoryQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RepositoryQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RepositoryQueryRepository>(value),
    );
  }
}

String _$repositoryQueryRepositoryHash() =>
    r'808e24d929c7402fe77b5d176846afce832fb088';

@ProviderFor(getScriptDetail)
const getScriptDetailProvider = GetScriptDetailFamily._();

final class GetScriptDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<PostDetail>,
          PostDetail,
          FutureOr<PostDetail>
        >
    with $FutureModifier<PostDetail>, $FutureProvider<PostDetail> {
  const GetScriptDetailProvider._({
    required GetScriptDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getScriptDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getScriptDetailHash();

  @override
  String toString() {
    return r'getScriptDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PostDetail> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PostDetail> create(Ref ref) {
    final argument = this.argument as int;
    return getScriptDetail(ref, id: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetScriptDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getScriptDetailHash() => r'c88b47abb45a2a166eb4ff84d5115d31b834ab71';

final class GetScriptDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PostDetail>, int> {
  const GetScriptDetailFamily._()
    : super(
        retry: null,
        name: r'getScriptDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetScriptDetailProvider call({required int id}) =>
      GetScriptDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'getScriptDetailProvider';
}

@ProviderFor(getScriptPosts)
const getScriptPostsProvider = GetScriptPostsFamily._();

final class GetScriptPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PageResult<Post>>,
          PageResult<Post>,
          FutureOr<PageResult<Post>>
        >
    with $FutureModifier<PageResult<Post>>, $FutureProvider<PageResult<Post>> {
  const GetScriptPostsProvider._({
    required GetScriptPostsFamily super.from,
    required ({int limit, int offset}) super.argument,
  }) : super(
         retry: null,
         name: r'getScriptPostsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getScriptPostsHash();

  @override
  String toString() {
    return r'getScriptPostsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PageResult<Post>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PageResult<Post>> create(Ref ref) {
    final argument = this.argument as ({int limit, int offset});
    return getScriptPosts(ref, limit: argument.limit, offset: argument.offset);
  }

  @override
  bool operator ==(Object other) {
    return other is GetScriptPostsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getScriptPostsHash() => r'6b1ead43585e865adfa5b5a5966eb08a7f8f805d';

final class GetScriptPostsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PageResult<Post>>,
          ({int limit, int offset})
        > {
  const GetScriptPostsFamily._()
    : super(
        retry: null,
        name: r'getScriptPostsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetScriptPostsProvider call({required int limit, required int offset}) =>
      GetScriptPostsProvider._(
        argument: (limit: limit, offset: offset),
        from: this,
      );

  @override
  String toString() => r'getScriptPostsProvider';
}

@ProviderFor(getScriptFavoritePosts)
const getScriptFavoritePostsProvider = GetScriptFavoritePostsFamily._();

final class GetScriptFavoritePostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PageResult<Post>>,
          PageResult<Post>,
          FutureOr<PageResult<Post>>
        >
    with $FutureModifier<PageResult<Post>>, $FutureProvider<PageResult<Post>> {
  const GetScriptFavoritePostsProvider._({
    required GetScriptFavoritePostsFamily super.from,
    required ({int limit, int offset}) super.argument,
  }) : super(
         retry: null,
         name: r'getScriptFavoritePostsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getScriptFavoritePostsHash();

  @override
  String toString() {
    return r'getScriptFavoritePostsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PageResult<Post>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PageResult<Post>> create(Ref ref) {
    final argument = this.argument as ({int limit, int offset});
    return getScriptFavoritePosts(
      ref,
      limit: argument.limit,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetScriptFavoritePostsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getScriptFavoritePostsHash() =>
    r'c1e3bd06e8f4dcae06c14366fa988fc0aed3c933';

final class GetScriptFavoritePostsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PageResult<Post>>,
          ({int limit, int offset})
        > {
  const GetScriptFavoritePostsFamily._()
    : super(
        retry: null,
        name: r'getScriptFavoritePostsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetScriptFavoritePostsProvider call({
    required int limit,
    required int offset,
  }) => GetScriptFavoritePostsProvider._(
    argument: (limit: limit, offset: offset),
    from: this,
  );

  @override
  String toString() => r'getScriptFavoritePostsProvider';
}

@ProviderFor(getMyUserDetail)
const getMyUserDetailProvider = GetMyUserDetailFamily._();

final class GetMyUserDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserDetail>,
          UserDetail,
          FutureOr<UserDetail>
        >
    with $FutureModifier<UserDetail>, $FutureProvider<UserDetail> {
  const GetMyUserDetailProvider._({
    required GetMyUserDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getMyUserDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getMyUserDetailHash();

  @override
  String toString() {
    return r'getMyUserDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserDetail> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserDetail> create(Ref ref) {
    final argument = this.argument as String;
    return getMyUserDetail(ref, token: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMyUserDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getMyUserDetailHash() => r'24885bb314922a450bcea9e7ca8fc97adb1da837';

final class GetMyUserDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserDetail>, String> {
  const GetMyUserDetailFamily._()
    : super(
        retry: null,
        name: r'getMyUserDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetMyUserDetailProvider call({required String token}) =>
      GetMyUserDetailProvider._(argument: token, from: this);

  @override
  String toString() => r'getMyUserDetailProvider';
}
