import 'package:JsxposedX/common/widgets/back_to_top_button.dart';
import 'package:JsxposedX/common/widgets/infinite_scroll_list.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/script_card.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/home/domain/models/post.dart';
import 'package:JsxposedX/features/home/presentation/providers/post_infinite_provider.dart';
import 'package:JsxposedX/features/home/presentation/providers/repository_token_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StarScriptTab extends HookConsumerWidget {
  const StarScriptTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final loginState = ref.watch(repositoryTokenLoginProvider);
    final state = ref.watch(favoritePostsInfiniteProvider);
    final showBackToTop = useState(false);
    final scrollController = useScrollController();

    useEffect(() {
      final currentUser = loginState.asData?.value;
      if (currentUser != null && state.rows.isEmpty && !state.isLoading) {
        Future.microtask(() {
          ref.read(favoritePostsInfiniteProvider.notifier).loadMore();
        });
      }
      return null;
    }, [loginState.asData?.value?.id]);

    useEffect(() {
      void onScroll() {
        if (scrollController.hasClients) {
          final currentScroll = scrollController.position.pixels;
          if (currentScroll > 300.h && !showBackToTop.value) {
            showBackToTop.value = true;
          } else if (currentScroll <= 300.h && showBackToTop.value) {
            showBackToTop.value = false;
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return loginState.when(
      loading: () => const Loading(),
      error: (_, _) => const _FavoriteLoginRequired(),
      data: (user) {
        if (user == null) {
          return const _FavoriteLoginRequired();
        }

        return Stack(
          children: [
            InfiniteScrollList<Post>.independent(
              items: state.rows,
              isLoading: state.isLoading,
              hasMore: state.hasMore,
              onLoadMore: () {
                ref.read(favoritePostsInfiniteProvider.notifier).loadMore();
              },
              onRefresh: () async {
                await ref.read(favoritePostsInfiniteProvider.notifier).refresh();
              },
              itemBuilder: (context, post) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: ScriptCard(post: post),
                );
              },
              emptyBuilder: (context) => InfiniteScrollList.emptyTip(
                context.l10n.noData,
                context: context,
                onRetry: () {
                  ref.read(favoritePostsInfiniteProvider.notifier).refresh();
                },
              ),
              scrollController: scrollController,
              storageKey: const PageStorageKey('favorite_scripts_list'),
              completeMessage: context.l10n.noData,
            ),
            BackToTopButton(
              visible: showBackToTop.value,
              scrollController: scrollController,
              onRefresh: () async {
                await ref.read(favoritePostsInfiniteProvider.notifier).refresh();
              },
              right: 16.w,
              bottom: 88.h,
              fadeDuration: const Duration(milliseconds: 300),
              scrollDuration: const Duration(milliseconds: 1000),
              heroTag: 'back_to_top_favorite_scripts',
            ),
          ],
        );
      },
    );
  }
}

class _FavoriteLoginRequired extends StatelessWidget {
  const _FavoriteLoginRequired();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 64.sp,
              color: context.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              context.l10n.repositoryFavoriteLoginRequired,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              context.l10n.repositoryFavoriteLoginHint,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
