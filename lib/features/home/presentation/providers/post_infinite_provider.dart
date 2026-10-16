import 'package:JsxposedX/features/home/presentation/providers/repository_query_provider.dart';
import 'package:JsxposedX/features/home/presentation/states/post_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_infinite_provider.g.dart';

/// 最新帖子无限滚动
@riverpod
class NewPostsInfinite extends _$NewPostsInfinite {
  int? _initialPageSize;
  bool _initialized = false;

  @override
  PostState build() {
    return const PostState();
  }

  Future<void> initialize(int pageSize) async {
    if (_initialized) return;
    _initialized = true;
    _initialPageSize = pageSize;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(repositoryQueryRepositoryProvider);
      final offset = state.rows.length;
      final limit = offset == 0 ? (_initialPageSize ?? 10) : 10;

      final newPosts = await repository.getScriptPosts(
        offset: offset,
        limit: limit,
      );

      state = state.copyWith(
        rows: [...state.rows, ...newPosts.rows],
        currentPage: state.currentPage + 1,
        isLoading: false,
        hasMore: newPosts.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    _initialized = false;
    state = const PostState();
    await initialize(_initialPageSize ?? 10);
  }
}

/// 收藏帖子无限滚动
@riverpod
class FavoritePostsInfinite extends _$FavoritePostsInfinite {
  int? _initialPageSize;
  bool _initialized = false;

  @override
  PostState build() {
    return const PostState();
  }

  Future<void> initialize(int pageSize) async {
    if (_initialized) return;
    _initialized = true;
    _initialPageSize = pageSize;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(repositoryQueryRepositoryProvider);
      final offset = state.rows.length;
      final limit = offset == 0 ? (_initialPageSize ?? 10) : 10;

      final favoritePosts = await repository.getScriptFavoritePosts(
        offset: offset,
        limit: limit,
      );

      state = state.copyWith(
        rows: [...state.rows, ...favoritePosts.rows],
        currentPage: state.currentPage + 1,
        isLoading: false,
        hasMore: favoritePosts.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    _initialized = false;
    state = const PostState();
    await initialize(_initialPageSize ?? 10);
  }
}
