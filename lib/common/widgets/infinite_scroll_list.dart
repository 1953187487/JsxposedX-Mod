import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// 通用无限滚动列表组件
///
/// 完整的无限滚动解决方案，包含下拉刷新、初始加载、空状态等
///
/// 使用示例：
/// ```dart
/// // 列表模式
/// InfiniteScrollList<App>(
///   items: state.apps,
///   isLoading: state.isLoading,
///   hasMore: state.hasMore,
///   onLoadMore: () => ref.read(xxxProvider.notifier).loadMore(),
///   onRefresh: () async => await ref.read(xxxProvider.notifier).refresh(),
///   itemBuilder: (context, app) => SimpleAppCard(app: app),
///   emptyBuilder: (context) => EmptyState(),
/// )
///
/// // 网格模式
/// InfiniteScrollList.grid<Post>(
///   items: state.post,
///   isLoading: state.isLoading,
///   hasMore: state.hasMore,
///   onLoadMore: () => ref.read(xxxProvider.notifier).loadMore(),
///   onRefresh: () async => await ref.read(xxxProvider.notifier).refresh(),
///   itemBuilder: (context, post) => PostCard(post: post),
///   crossAxisCount: 2,
/// )
/// ```
class InfiniteScrollList<T> extends StatelessWidget {
  /// 数据列表
  final List<T> items;

  /// 是否正在加载
  final bool isLoading;

  /// 是否还有更多数据
  final bool hasMore;

  /// 加载更多回调
  final VoidCallback onLoadMore;

  /// 下拉刷新回调
  final Future<void> Function()? onRefresh;

  /// 列表项构建器
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// 空状态构建器
  final Widget Function(BuildContext context)? emptyBuilder;

  /// 滚动控制器
  final ScrollController? scrollController;

  /// 页面存储key
  final PageStorageKey? storageKey;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 触发加载更多的偏移量（距离底部多少项时触发）
  final int loadMoreOffset;

  /// 加载完成提示文字
  final String? completeMessage;

  /// 是否显示分割线（仅列表模式）
  final bool showDivider;

  /// 分割线构建器（仅列表模式）
  final Widget Function()? dividerBuilder;

  /// 网格列数（仅网格模式）
  final int? crossAxisCount;

  /// 主轴间距（仅网格模式）
  final double? mainAxisSpacing;

  /// 交叉轴间距（仅网格模式）
  final double? crossAxisSpacing;

  /// 是否为网格模式
  final bool _isGrid;

  /// 是否为独立模式（包含 RefreshIndicator + CustomScrollView）
  final bool _isIndependent;

  /// 列表模式构造函数
  const InfiniteScrollList({
    super.key,
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    required this.itemBuilder,
    this.onRefresh,
    this.emptyBuilder,
    this.scrollController,
    this.storageKey,
    this.padding,
    this.loadMoreOffset = 2,
    this.completeMessage,
    this.showDivider = false,
    this.dividerBuilder,
  }) : _isGrid = false,
       _isIndependent = false,
       crossAxisCount = null,
       mainAxisSpacing = null,
       crossAxisSpacing = null;

  /// 网格模式构造函数
  const InfiniteScrollList.grid({
    super.key,
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    required this.itemBuilder,
    this.onRefresh,
    this.emptyBuilder,
    this.scrollController,
    this.storageKey,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.padding,
    this.loadMoreOffset = 2,
    this.completeMessage,
  }) : _isGrid = true,
       _isIndependent = false,
       showDivider = false,
       dividerBuilder = null;

  /// 独立模式构造函数 - 列表（完整的滚动方案）
  const InfiniteScrollList.independent({
    super.key,
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    required this.itemBuilder,
    this.onRefresh,
    this.emptyBuilder,
    this.scrollController,
    this.storageKey,
    this.padding,
    this.loadMoreOffset = 2,
    this.completeMessage,
    this.showDivider = false,
    this.dividerBuilder,
  }) : _isGrid = false,
       _isIndependent = true,
       crossAxisCount = null,
       mainAxisSpacing = null,
       crossAxisSpacing = null;

  /// 独立模式构造函数 - 网格（完整的滚动方案）
  const InfiniteScrollList.gridIndependent({
    super.key,
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    required this.itemBuilder,
    this.onRefresh,
    this.emptyBuilder,
    this.scrollController,
    this.storageKey,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.padding,
    this.loadMoreOffset = 2,
    this.completeMessage,
  }) : _isGrid = true,
       _isIndependent = true,
       showDivider = false,
       dividerBuilder = null;

  @override
  Widget build(BuildContext context) {
    return _LoadMoreGate(
      itemCount: items.length,
      isLoading: isLoading,
      hasMore: hasMore,
      onLoadMore: onLoadMore,
      builder: (requestLoadMore) => _build(context, requestLoadMore),
    );
  }

  Widget _build(BuildContext context, VoidCallback requestLoadMore) {
    if (_isIndependent) {
      // 独立模式：返回完整的滚动方案
      // 初始加载状态
      if (items.isEmpty && isLoading) {
        return const Center(child: Loading());
      }

      // 构建内容
      final content = CustomScrollView(
        key: storageKey,
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // 空状态
          if (items.isEmpty && !isLoading)
            SliverFillRemaining(
              child:
                  emptyBuilder?.call(context) ??
                  const Center(child: Text('No data')),
            )
          // 列表/网格内容
          else if (_isGrid)
            _buildGridView(context, requestLoadMore)
          else
            _buildListView(context, requestLoadMore),
        ],
      );

      // 包裹 RefreshIndicator
      if (onRefresh != null) {
        return RefreshIndicator(onRefresh: onRefresh!, child: content);
      }

      return content;
    } else {
      // Sliver 模式：直接返回 Sliver widget
      if (_isGrid) {
        return _buildGridView(context, requestLoadMore);
      } else {
        return _buildListView(context, requestLoadMore);
      }
    }
  }

  /// 构建列表视图
  Widget _buildListView(BuildContext context, VoidCallback requestLoadMore) {
    if (items.isEmpty) {
      if (isLoading) {
        return const SliverFillRemaining(child: Center(child: Loading()));
      }

      return SliverFillRemaining(
        hasScrollBody: false,
        child:
            emptyBuilder?.call(context) ?? const Center(child: Text('No data')),
      );
    }

    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          // 触发加载更多
          final loadTriggerIndex = items.length - loadMoreOffset;
          if (index == loadTriggerIndex && hasMore && !isLoading) {
            requestLoadMore();
          }

          // 渲染列表项
          if (index < items.length) {
            final item = items[index];
            return Column(
              children: [
                itemBuilder(context, item),
                // 分割线
                if (showDivider && index < items.length - 1)
                  dividerBuilder?.call() ?? const Divider(height: 1),
              ],
            );
          }

          // 加载指示器
          if (isLoading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // 加载完成提示
          if (!hasMore && items.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  completeMessage ?? 'Loaded all ${items.length} items',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        }, childCount: items.length + (isLoading || !hasMore ? 1 : 0)),
      ),
    );
  }

  /// 构建网格视图
  Widget _buildGridView(BuildContext context, VoidCallback requestLoadMore) {
    if (items.isEmpty) {
      if (isLoading) {
        return const SliverFillRemaining(child: Center(child: Loading()));
      }

      return SliverFillRemaining(
        hasScrollBody: false,
        child:
            emptyBuilder?.call(context) ?? const Center(child: Text('No data')),
      );
    }

    return SliverPadding(
      padding: padding ?? EdgeInsets.zero,
      sliver: SliverMainAxisGroup(
        slivers: [
          // 网格内容
          SliverMasonryGrid.count(
            crossAxisCount: crossAxisCount!,
            mainAxisSpacing: mainAxisSpacing ?? 0,
            crossAxisSpacing: crossAxisSpacing ?? 0,
            childCount: items.length,
            itemBuilder: (context, index) {
              // 触发加载更多
              final loadTriggerIndex = items.length - loadMoreOffset;
              if (index == loadTriggerIndex && hasMore && !isLoading) {
                requestLoadMore();
              }

              return itemBuilder(context, items[index]);
            },
          ),
          // 加载指示器或完成提示
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: isLoading
                    ? const Loading()
                    : !hasMore && items.isNotEmpty
                    ? Text(
                        completeMessage ?? 'Loaded all ${items.length} items',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget emptyTip(
    String title, {
    required VoidCallback onRetry,
    required BuildContext context,
  }) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.article_outlined, size: 80.sp, color: Colors.grey[400]),
        SizedBox(height: 16.h),
        Text(
          title,
          style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
        ),
        SizedBox(height: 16.h),
        ElevatedButton(onPressed: onRetry, child: Text(context.l10n.retry)),
      ],
    ),
  );
}

class InfiniteScrollListBox<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final int loadMoreOffset;
  final String? completeMessage;
  final bool showDivider;
  final Widget Function()? dividerBuilder;

  const InfiniteScrollListBox({
    super.key,
    required this.items,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    required this.itemBuilder,
    this.padding,
    this.loadMoreOffset = 2,
    this.completeMessage,
    this.showDivider = false,
    this.dividerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return _LoadMoreGate(
      itemCount: items.length,
      isLoading: isLoading,
      hasMore: hasMore,
      onLoadMore: onLoadMore,
      builder: (requestLoadMore) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: items.length + (isLoading || !hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // 触发加载更多
          final loadTriggerIndex = items.length - loadMoreOffset;
          if (index == loadTriggerIndex && hasMore && !isLoading) {
            requestLoadMore();
          }

          // 渲染列表项
          if (index < items.length) {
            final item = items[index];
            return Column(
              children: [
                itemBuilder(context, item),
                if (showDivider && index < items.length - 1)
                  dividerBuilder?.call() ?? const Divider(height: 1),
              ],
            );
          }

          // 加载指示器
          if (isLoading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Loading()),
            );
          }

          // 加载完成提示
          if (!hasMore && items.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  completeMessage ?? 'Loaded all ${items.length} items',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LoadMoreGate extends StatefulWidget {
  const _LoadMoreGate({
    required this.itemCount,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    required this.builder,
  });

  final int itemCount;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Widget Function(VoidCallback requestLoadMore) builder;

  @override
  State<_LoadMoreGate> createState() => _LoadMoreGateState();
}

class _LoadMoreGateState extends State<_LoadMoreGate> {
  bool _requested = false;

  @override
  void didUpdateWidget(covariant _LoadMoreGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount != oldWidget.itemCount ||
        widget.hasMore != oldWidget.hasMore) {
      _requested = false;
    }
  }

  void _requestLoadMore() {
    if (_requested || widget.isLoading || !widget.hasMore) {
      return;
    }
    _requested = true;
    Future.microtask(widget.onLoadMore);
  }

  @override
  Widget build(BuildContext context) => widget.builder(_requestLoadMore);
}
