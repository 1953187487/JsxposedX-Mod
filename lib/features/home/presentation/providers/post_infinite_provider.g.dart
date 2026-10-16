// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_infinite_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 最新帖子无限滚动

@ProviderFor(NewPostsInfinite)
const newPostsInfiniteProvider = NewPostsInfiniteProvider._();

/// 最新帖子无限滚动
final class NewPostsInfiniteProvider
    extends $NotifierProvider<NewPostsInfinite, PostState> {
  /// 最新帖子无限滚动
  const NewPostsInfiniteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newPostsInfiniteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newPostsInfiniteHash();

  @$internal
  @override
  NewPostsInfinite create() => NewPostsInfinite();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostState>(value),
    );
  }
}

String _$newPostsInfiniteHash() => r'2c4d25021d39467fc9c7ea6c780318cd84bed4ab';

/// 最新帖子无限滚动

abstract class _$NewPostsInfinite extends $Notifier<PostState> {
  PostState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PostState, PostState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostState, PostState>,
              PostState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 收藏帖子无限滚动

@ProviderFor(FavoritePostsInfinite)
const favoritePostsInfiniteProvider = FavoritePostsInfiniteProvider._();

/// 收藏帖子无限滚动
final class FavoritePostsInfiniteProvider
    extends $NotifierProvider<FavoritePostsInfinite, PostState> {
  /// 收藏帖子无限滚动
  const FavoritePostsInfiniteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritePostsInfiniteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritePostsInfiniteHash();

  @$internal
  @override
  FavoritePostsInfinite create() => FavoritePostsInfinite();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostState>(value),
    );
  }
}

String _$favoritePostsInfiniteHash() =>
    r'd499b0193720311b742a4d3e11a53218f9910604';

/// 收藏帖子无限滚动

abstract class _$FavoritePostsInfinite extends $Notifier<PostState> {
  PostState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PostState, PostState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostState, PostState>,
              PostState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
