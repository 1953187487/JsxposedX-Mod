import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/audit_log.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_query_provider.dart';
import 'package:JsxposedX/features/project/presentation/widgets/audit_log_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CryptoAuditLogPage extends HookConsumerWidget {
  final String packageName;

  const CryptoAuditLogPage({super.key, required this.packageName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scrollController = useScrollController();

    // 状态管理
    final logs = useState<List<AuditLog>>([]);
    final isLoading = useState(false);
    final hasMore = useState(true);
    final offset = useState(0);
    const limit = 20;

    // 搜索状态
    final searchController = useTextEditingController();
    final keyword = useState<String?>(null);
    final isSearching = useState(false);

    // 加载逻辑
    final loadMore = useCallback(([bool isRefresh = false]) async {
      if (isLoading.value || (!isRefresh && !hasMore.value)) return;
      isLoading.value = true;

      try {
        final currentOffset = isRefresh ? 0 : offset.value;
        final newLogs = await ref.read(
          auditLogsProvider(
            packageName: packageName,
            limit: limit,
            offset: currentOffset,
            keyword: keyword.value,
          ).future,
        );

        if (isRefresh) {
          logs.value = newLogs;
          offset.value = newLogs.length;
        } else {
          logs.value = [...logs.value, ...newLogs];
          offset.value += newLogs.length;
        }
        hasMore.value = newLogs.length == limit;
      } catch (e) {
        if (context.mounted) {
          ToastMessage.show('加载失败: $e');
        }
      } finally {
        isLoading.value = false;
      }
    }, [packageName, offset.value, isLoading.value, hasMore.value, keyword.value]);

    // 下拉刷新逻辑
    Future<void> onRefresh() async {
      await loadMore(true);
    }

    // 监听界面切回
    useOnAppLifecycleStateChange((previous, current) {
      if (current == AppLifecycleState.resumed) {
        onRefresh();
      }
    });

    // 初始加载
    useEffect(() {
      loadMore();
      return null;
    }, []);

    // 滚动监听
    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200 &&
            !isLoading.value &&
            hasMore.value) {
          loadMore();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController, loadMore]);

    void showClearConfirm() {
      CustomDialog.show(
        title: Text(l10n.clear),
        child: Text(l10n.clearConfirm),
        actionButtons: [
          TextButton(
            onPressed: () => SmartDialog.dismiss(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              SmartDialog.dismiss();
              try {
                await ref.read(clearAuditLogsProvider(packageName: packageName).future);
                onRefresh();
              } catch (e) {
                if (context.mounted) {
                  ToastMessage.show('${l10n.error}: $e');
                }
              }
            },
            child: Text(
              l10n.confirm,
              style: TextStyle(color: context.theme.colorScheme.error),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: isSearching.value
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: TextStyle(color: context.theme.colorScheme.onSurface, fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: l10n.searchPlaceholder,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: context.theme.disabledColor, fontSize: 16.sp),
                ),
                onSubmitted: (value) {
                  keyword.value = value.isEmpty ? null : value;
                  onRefresh();
                },
              )
            : Text(l10n.qfAlgorithmicTracking),
        actions: [
          if (isSearching.value)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                isSearching.value = false;
                searchController.clear();
                if (keyword.value != null) {
                  keyword.value = null;
                  onRefresh();
                }
              },
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => isSearching.value = true,
            ),
            IconButton(
              icon: const Icon(Icons.edit_note_rounded),
              tooltip: '编辑加解密脚本', // TODO: 应该改成 l10n 字段
              onPressed: () {
                context.push(HomeRoute.toCryptoAuditJsEditor(packageName: packageName));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: l10n.clear,
              onPressed: showClearConfirm,
            ),
          ],
        ],
      ),
      body: logs.value.isEmpty && isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: logs.value.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 64.sp,
                            color: context.theme.disabledColor.withValues(alpha: 0.5),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            l10n.noData,
                            style: TextStyle(
                              color: context.theme.disabledColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: logs.value.length + (hasMore.value ? 1 : 0),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemBuilder: (context, index) {
                        if (index == logs.value.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final log = logs.value[index];
                        return AuditLogItem(
                          packageName: packageName,
                          log: log,
                          onDeleted: () => onRefresh(),
                        );
                      },
                    ),
            ),

    );
  }
}
