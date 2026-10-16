import 'dart:async';
import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_browse_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_pointer_expression.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_jump_address_dialog.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_locate_expression_dialog.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_dialog.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_result_card.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_task_feedback.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_action_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_search_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_task_panel.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolSearchTab extends HookConsumerWidget {
  const MemoryToolSearchTab({
    super.key,
    required this.onOpenBrowseTab,
    required this.onOpenPointerTab,
    required this.onOpenDebugTab,
    required this.onOpenSavedTab,
  });

  final VoidCallback onOpenBrowseTab;
  final VoidCallback onOpenPointerTab;
  final VoidCallback onOpenDebugTab;
  final VoidCallback onOpenSavedTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final isSearchDialogVisible = useState(false);
    final isJumpAddressDialogVisible = useState(false);
    final isLocateExpressionDialogVisible = useState(false);
    final isLocateExpressionLoading = useState(false);
    final selectedPid = ref.watch(memoryToolSelectedProcessProvider)?.pid;
    final sessionStateAsync = ref.watch(getSearchSessionStateProvider);
    final taskStateAsync = ref.watch(getSearchTaskStateProvider);
    final hasMatchingSession = ref.watch(hasMatchingSearchSessionProvider);
    final previousTaskStatus = useRef<SearchTaskStatus?>(null);
    final previousSelectedPid = useRef<int?>(selectedPid);
    final previousSessionPid = useRef<int?>(null);

    void scheduleSelectionClear() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        ref.read(memoryToolResultSelectionProvider.notifier).clear();
      });
    }

    void scheduleSearchRefresh() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        ref.invalidate(getSearchSessionStateProvider);
        ref.invalidate(getSearchTaskStateProvider);
        ref.invalidate(getSearchResultsProvider);
        ref.invalidate(hasMatchingSearchSessionProvider);
        ref.invalidate(currentSearchResultsProvider);
        ref.invalidate(currentSearchResultLivePreviewsProvider);
      });
    }

    useEffect(() {
      taskStateAsync.whenData((state) {
        final previousStatus = previousTaskStatus.value;
        final currentStatus = state.status;
        final isTerminalStatus =
            currentStatus == SearchTaskStatus.completed ||
            currentStatus == SearchTaskStatus.cancelled ||
            currentStatus == SearchTaskStatus.failed;
        final didEnterTerminalStatus =
            isTerminalStatus && previousStatus != currentStatus;
        if (didEnterTerminalStatus) {
          scheduleSearchRefresh();
          scheduleSelectionClear();
          if (currentStatus == SearchTaskStatus.failed) {
            final message = state.message.trim().isEmpty
                ? context.l10n.memoryToolTaskFailedFallback
                : state.message.trim();
            unawaited(
              ToastOverlayMessage.show(
                message,
                duration: const Duration(milliseconds: 2200),
              ),
            );
          }
        }
        previousTaskStatus.value = currentStatus;
      });
      return null;
    }, [taskStateAsync]);

    useEffect(() {
      final previousPid = previousSelectedPid.value;
      if (previousPid != null && previousPid != selectedPid) {
        scheduleSelectionClear();
      }
      previousSelectedPid.value = selectedPid;
      return null;
    }, [selectedPid]);

    useEffect(() {
      sessionStateAsync.whenData((state) {
        final previousPid = previousSessionPid.value;
        final currentSessionPid = state.hasActiveSession ? state.pid : null;
        final hadMatchingSession =
            selectedPid != null &&
            previousPid != null &&
            previousPid == selectedPid;
        final hasExactMatchingSession =
            state.hasActiveSession &&
            selectedPid != null &&
            state.pid == selectedPid;

        if (hadMatchingSession && !hasExactMatchingSession) {
          scheduleSelectionClear();
        }

        previousSessionPid.value = currentSessionPid;
      });
      return null;
    }, [sessionStateAsync, selectedPid]);

    void stopLocateExpressionLoading() {
      if (!context.mounted || !isLocateExpressionLoading.value) {
        return;
      }
      isLocateExpressionLoading.value = false;
    }

    Future<void> jumpToAddress(int targetAddress) async {
      if (selectedPid == null) {
        return;
      }

      try {
        await ref
            .read(memoryToolBrowseControllerProvider.notifier)
            .previewRawAddress(targetAddress: targetAddress);
        if (!context.mounted) {
          return;
        }
        onOpenBrowseTab();
      } catch (_) {
        if (!context.mounted) {
          return;
        }
        await ToastOverlayMessage.show(
          context.l10n.memoryToolOffsetPreviewUnreadable,
          duration: const Duration(milliseconds: 1200),
        );
      }
    }

    final resultCard = MemoryToolSearchResultCard(
      hasMatchingSession: hasMatchingSession,
      sessionStateAsync: sessionStateAsync,
      onRetry: () {
        ref.invalidate(getSearchSessionStateProvider);
        ref.invalidate(getSearchResultsProvider);
        ref.invalidate(hasMatchingSearchSessionProvider);
        ref.invalidate(currentSearchResultsProvider);
      },
      onOpenSearch: () {
        isSearchDialogVisible.value = true;
      },
      onOpenJumpAddress: () {
        isJumpAddressDialogVisible.value = true;
      },
      onOpenLocateExpression: () {
        isLocateExpressionDialogVisible.value = true;
      },
      onOpenBrowseTab: onOpenBrowseTab,
      onOpenPointerTab: onOpenPointerTab,
      onOpenDebugTab: onOpenDebugTab,
      onOpenSavedTab: onOpenSavedTab,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.r;
        final padding = EdgeInsets.all(
          constraints.maxHeight < 320 ? 8.r : 12.r,
        );
        final hasTaskFeedback = taskStateAsync.maybeWhen(
          data: (state) =>
              state.status == SearchTaskStatus.cancelled ||
              state.status == SearchTaskStatus.failed,
          orElse: () => false,
        );
        final content = Padding(
          padding: padding,
          child: Column(
            children: <Widget>[
              if (hasTaskFeedback) ...<Widget>[
                MemoryToolSearchTaskFeedback(taskStateAsync: taskStateAsync),
                SizedBox(height: spacing),
              ],
              Expanded(child: resultCard),
            ],
          ),
        );

        return Stack(
          children: <Widget>[
            Positioned.fill(child: content),
            if (isSearchDialogVisible.value)
              Positioned.fill(
                child: MemoryToolSearchDialog(
                  onOpenBrowseTab: onOpenBrowseTab,
                  onClose: () {
                    isSearchDialogVisible.value = false;
                  },
                ),
              ),
            if (isJumpAddressDialogVisible.value)
              Positioned.fill(
                child: MemoryToolJumpAddressDialog(
                  onConfirm: (targetAddress) async {
                    isJumpAddressDialogVisible.value = false;
                    await jumpToAddress(targetAddress);
                  },
                  onClose: () {
                    isJumpAddressDialogVisible.value = false;
                  },
                ),
              ),
            if (isLocateExpressionDialogVisible.value)
              Positioned.fill(
                child: MemoryToolLocateExpressionDialog(
                  onConfirm: (expression) async {
                    isLocateExpressionDialogVisible.value = false;
                    if (selectedPid == null) {
                      return;
                    }
                    isLocateExpressionLoading.value = true;
                    try {
                      final browseNotifier = ref.read(
                        memoryToolBrowseControllerProvider.notifier,
                      );
                      final readableRegions = await browseNotifier
                          .ensureReadableRegions(pid: selectedPid);
                      final targetAddress =
                          await resolveMemoryToolPointerExpressionTargetAddress(
                            repository: ref.read(memoryQueryRepositoryProvider),
                            pid: selectedPid,
                            expression: expression,
                            readableRegions: readableRegions,
                          );
                      stopLocateExpressionLoading();
                      await jumpToAddress(targetAddress);
                    } catch (_) {
                      stopLocateExpressionLoading();
                      if (context.mounted) {
                        unawaited(
                          ToastOverlayMessage.show(
                            context.l10n.memoryToolOffsetPreviewUnreadable,
                            duration: const Duration(milliseconds: 1200),
                          ),
                        );
                      }
                    } finally {
                      stopLocateExpressionLoading();
                    }
                  },
                  onClose: () {
                    isLocateExpressionDialogVisible.value = false;
                  },
                ),
              ),
            if (isLocateExpressionLoading.value)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.34),
                  child: Center(
                    child: Container(
                      width: 180.r,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.r,
                        vertical: 16.r,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: context.colorScheme.outlineVariant.withValues(
                            alpha: 0.42,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: 52.r,
                            height: 52.r,
                            child: const Loading(),
                          ),
                          SizedBox(height: 10.r),
                          Text(
                            _resolveExpressionLoadingText(context),
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            taskStateAsync.when(
              skipLoadingOnRefresh: true,
              data: (state) {
                if (state.status != SearchTaskStatus.running) {
                  return const SizedBox.shrink();
                }

                return Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.34),
                    child: MemoryToolSearchTaskPanel(
                      state: state,
                      onCancel: () {
                        ref
                            .read(memorySearchActionProvider.notifier)
                            .cancelSearch();
                      },
                    ),
                  ),
                );
              },
              error: (_, _) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

String _resolveExpressionLoadingText(BuildContext context) {
  return context.isZh ? '表达式定位中...' : 'Locating expression...';
}
