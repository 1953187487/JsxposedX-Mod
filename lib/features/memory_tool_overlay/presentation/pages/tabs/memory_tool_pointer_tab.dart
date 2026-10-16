import 'dart:async';
import 'dart:math' as math;

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/core/utils/format_utils.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_pointer_action_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_pointer_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_browse_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_tool_pointer_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/states/memory_tool_pointer_state.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_pointer_utils.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_pointer_result_list.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart'
    show
        PointerScanResult,
        PointerScanSessionState,
        PointerScanTaskState,
        SearchTaskStatus;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolPointerTab extends HookConsumerWidget {
  const MemoryToolPointerTab({super.key, required this.onOpenBrowseTab});

  final VoidCallback onOpenBrowseTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final selectedProcess = ref.watch(memoryToolSelectedProcessProvider);
    final pointerState = ref.watch(memoryToolPointerControllerProvider);
    final pointerController = ref.read(
      memoryToolPointerControllerProvider.notifier,
    );
    final taskStateAsync = ref.watch(getPointerScanTaskStateProvider);
    final sessionStateAsync = ref.watch(getPointerScanSessionStateProvider);
    final currentLayer = pointerState.currentLayer;
    final scrollController = useScrollController();
    final previousTaskStatus = useRef<SearchTaskStatus?>(null);
    final selectedRegionTypeKeys = useState<Set<String>>(<String>{});
    final isJumpingToTarget = useState(false);

    useEffect(() {
      void handleScroll() {
        if (!scrollController.hasClients) {
          return;
        }
        if (scrollController.position.extentAfter <= 320.r) {
          pointerController.loadMore();
        }
      }

      scrollController.addListener(handleScroll);
      return () {
        scrollController.removeListener(handleScroll);
      };
    }, [scrollController, pointerController]);

    final currentTaskState = taskStateAsync.asData?.value;
    final isRunningTask = currentTaskState?.status == SearchTaskStatus.running;
    final isManualScanLoading =
        !pointerState.isAutoChasing &&
        currentLayer != null &&
        (currentLayer.isLoadingInitial || currentLayer.isLoadingMore);
    final shouldShowPointerTaskMask =
        !pointerState.isAutoChasing && isRunningTask;
    useEffect(
      () {
        sessionStateAsync.whenData((sessionState) {
          if (pointerState.isAutoChasing || !sessionState.hasActiveSession) {
            return;
          }
          pointerController.ensureSessionLayerVisible(
            sessionState: sessionState,
            isLoadingInitial: isRunningTask,
          );
        });
        return null;
      },
      [
        sessionStateAsync,
        pointerState.isAutoChasing,
        pointerState.layers.length,
        isRunningTask,
        pointerController,
      ],
    );

    useEffect(() {
      taskStateAsync.whenData((taskState) {
        final previousStatus = previousTaskStatus.value;
        final shouldHandleTerminalTransition =
            taskState.status != SearchTaskStatus.running &&
            (previousStatus == SearchTaskStatus.running || isManualScanLoading);
        if (shouldHandleTerminalTransition) {
          ref.invalidate(getPointerScanSessionStateProvider);
          ref.invalidate(getPointerScanResultsProvider);
          if (taskState.status == SearchTaskStatus.completed) {
            unawaited(pointerController.handleTaskCompleted());
          } else if (taskState.status == SearchTaskStatus.failed ||
              taskState.status == SearchTaskStatus.cancelled) {
            pointerController.handleTaskStopped(
              status: taskState.status,
              message: taskState.message,
            );
          }
        }
        previousTaskStatus.value = taskState.status;
      });
      return null;
    }, [taskStateAsync, pointerController, ref, isManualScanLoading]);

    final availableRegionTypeKeys = <String>[
      if (currentLayer != null) ...{
        for (final result in currentLayer.results) result.regionTypeKey,
      },
    ];
    final availableRegionTypeSignature = availableRegionTypeKeys.join(',');
    final selectedRegionTypeSignature = selectedRegionTypeKeys.value.toList()
      ..sort();
    useEffect(() {
      final nextSelected = selectedRegionTypeKeys.value
          .where(availableRegionTypeKeys.contains)
          .toSet();
      if (nextSelected.length != selectedRegionTypeKeys.value.length) {
        selectedRegionTypeKeys.value = nextSelected;
      }
      return null;
    }, [availableRegionTypeSignature]);

    Future<void> previewAndOpenBrowse(
      Future<void> Function() previewAction,
    ) async {
      try {
        await previewAction();
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

    Future<void> jumpToTarget(PointerScanResult result) async {
      final layer = pointerState.currentLayer;
      if (layer == null) {
        return;
      }

      isJumpingToTarget.value = true;
      try {
        await previewAndOpenBrowse(
          () => ref
              .read(memoryToolBrowseControllerProvider.notifier)
              .previewFromAddress(
                sourceResult: buildSearchResultFromPointerResult(
                  result: result,
                  pointerWidth: layer.request.pointerWidth,
                ),
                targetAddress: result.targetAddress,
              ),
        );
      } finally {
        if (context.mounted) {
          isJumpingToTarget.value = false;
        }
      }
    }

    bool matchesPointerResult(PointerScanResult result) {
      if (selectedRegionTypeKeys.value.isNotEmpty &&
          !selectedRegionTypeKeys.value.contains(result.regionTypeKey)) {
        return false;
      }
      return true;
    }

    final filteredResults = currentLayer == null
        ? const <PointerScanResult>[]
        : currentLayer.results
              .where(matchesPointerResult)
              .toList(growable: false);
    final selectedPointerLoaded =
        currentLayer == null ||
        currentLayer.selectedPointerAddress == null ||
        currentLayer.results.any(
          (result) =>
              result.pointerAddress == currentLayer.selectedPointerAddress,
        );

    final shouldAutoLoadMore =
        currentLayer != null &&
        !currentLayer.isLoadingInitial &&
        !currentLayer.isLoadingMore &&
        currentLayer.hasMore &&
        ((!selectedPointerLoaded &&
                currentLayer.selectedPointerAddress != null) ||
            (selectedRegionTypeKeys.value.isNotEmpty &&
                filteredResults.length < 12));

    useEffect(
      () {
        if (!shouldAutoLoadMore) {
          return null;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          pointerController.loadMore();
        });
        return null;
      },
      [
        shouldAutoLoadMore,
        currentLayer?.results.length,
        currentLayer?.hasMore,
        currentLayer?.isLoadingInitial,
        currentLayer?.isLoadingMore,
        filteredResults.length,
        selectedPointerLoaded,
        currentLayer?.selectedPointerAddress,
        selectedRegionTypeSignature.join(','),
      ],
    );

    if (selectedProcess == null) {
      return Center(
        child: Text(
          context.l10n.selectApp,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.66),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (currentLayer != null) ...<Widget>[
                _PointerHeaderPanel(
                  state: pointerState,
                  availableRegionTypeKeys: availableRegionTypeKeys,
                  selectedRegionTypeKeys: selectedRegionTypeKeys.value,
                  onTapLayer: pointerController.selectLayer,
                  onToggleRegionTypeKey: (regionTypeKey) {
                    final nextSelected = Set<String>.from(
                      selectedRegionTypeKeys.value,
                    );
                    if (nextSelected.contains(regionTypeKey)) {
                      nextSelected.remove(regionTypeKey);
                    } else {
                      nextSelected.add(regionTypeKey);
                    }
                    selectedRegionTypeKeys.value = nextSelected;
                  },
                  onClearRegionFilters: () {
                    selectedRegionTypeKeys.value = <String>{};
                  },
                ),
              ],
              SizedBox(height: currentLayer == null ? 0 : 6.r),
              Expanded(
                child: currentLayer == null
                    ? const SizedBox.shrink()
                    : currentLayer.results.isEmpty &&
                          currentLayer.errorText != null
                    ? Center(
                        child: Text(
                          currentLayer.errorText!,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : currentLayer.results.isEmpty &&
                          !isManualScanLoading &&
                          !isRunningTask
                    ? const SizedBox.shrink()
                    : filteredResults.isEmpty &&
                          !isManualScanLoading &&
                          !isRunningTask
                    ? const SizedBox.shrink()
                    : MemoryToolPointerResultList(
                        results: filteredResults,
                        request: currentLayer.request,
                        scrollController: scrollController,
                        chainLayers: pointerState.layers,
                        currentLayerIndex: pointerState.currentLayerIndex,
                        selectedPointerAddress:
                            currentLayer.selectedPointerAddress,
                        isTerminalLayer: currentLayer.isTerminalLayer,
                        onContinueSearch: (result) async {
                          await pointerController.continueScan(
                            result: result,
                            baseRequest: currentLayer.request,
                          );
                        },
                        onJumpToTarget: jumpToTarget,
                      ),
              ),
              if (!pointerState.isAutoChasing) ...<Widget>[
                SizedBox(height: 8.r),
                _PointerFooter(
                  currentLayer: currentLayer,
                  sessionStateAsync: sessionStateAsync,
                ),
              ],
            ],
          ),
        ),
        if (pointerState.isAutoChasing)
          Positioned.fill(
            child: _MemoryToolPointerAutoChaseMask(
              taskState: currentTaskState,
              currentDepth: pointerState.autoChaseCurrentDepth,
              maxDepth: pointerState.autoChaseMaxDepth,
              message: pointerState.autoChaseMessage,
              onCancel: pointerController.cancelAutoChase,
            ),
          ),
        if (shouldShowPointerTaskMask)
          Positioned.fill(
            child: _MemoryToolPointerTaskMask(
              taskState: currentTaskState,
              onCancel: () {
                ref
                    .read(memoryPointerActionProvider.notifier)
                    .cancelPointerScan();
              },
            ),
          ),
        if (isJumpingToTarget.value)
          const Positioned.fill(child: _MemoryToolPointerJumpLoadingMask()),
      ],
    );
  }
}

class _MemoryToolPointerTaskMask extends StatelessWidget {
  const _MemoryToolPointerTaskMask({
    required this.taskState,
    required this.onCancel,
  });

  final PointerScanTaskState? taskState;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final progress = _resolvePointerTaskProgress(taskState);
    final message = taskState?.message.trim() ?? '';

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.34),
      child: SafeArea(
        minimum: EdgeInsets.all(12.r),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxPanelHeight = (constraints.maxHeight - 12.r)
                .clamp(220.r, double.infinity)
                .toDouble();

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 340.r,
                  minWidth: 240.r,
                  maxHeight: maxPanelHeight,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 18.r,
                        offset: Offset(0, 10.r),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          context.l10n.memoryToolPointerTaskRunningTitle,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 14.r),
                        progress == null
                            ? SizedBox(
                                width: 28.r,
                                height: 28.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4.r,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999.r),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 8.r,
                                    ),
                                  ),
                                  SizedBox(height: 8.r),
                                  Text(
                                    '${(progress * 100).toStringAsFixed(1)}%',
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                        if (message.isNotEmpty) ...<Widget>[
                          SizedBox(height: 12.r),
                          Text(
                            message,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.72,
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        SizedBox(height: 14.r),
                        Wrap(
                          spacing: 8.r,
                          runSpacing: 8.r,
                          children: <Widget>[
                            if ((taskState?.elapsedMilliseconds ?? 0) > 0)
                              _MemoryToolPointerTaskMetricChip(
                                label: context.l10n.memoryToolTaskElapsedLabel,
                                value: formatDurationShort(
                                  taskState!.elapsedMilliseconds,
                                ),
                              ),
                            if ((taskState?.totalRegions ?? 0) > 0)
                              _MemoryToolPointerTaskMetricChip(
                                label: context.l10n.memoryToolTaskRegionsLabel,
                                value:
                                    '${taskState!.processedRegions}/${taskState!.totalRegions}',
                              ),
                            if ((taskState?.totalEntries ?? 0) > 0)
                              _MemoryToolPointerTaskMetricChip(
                                label: context.l10n.memoryToolTaskEntriesLabel,
                                value:
                                    '${taskState!.processedEntries}/${taskState!.totalEntries}',
                              ),
                            if ((taskState?.totalBytes ?? 0) > 0)
                              _MemoryToolPointerTaskMetricChip(
                                label: context.l10n.memoryToolTaskBytesLabel,
                                value:
                                    '${formatBytesCompact(taskState!.processedBytes)}/${formatBytesCompact(taskState!.totalBytes)}',
                              ),
                            _MemoryToolPointerTaskMetricChip(
                              label:
                                  context.l10n.memoryToolTaskResultCountLabel,
                              value: (taskState?.resultCount ?? 0).toString(),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.r),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: taskState?.canCancel ?? true
                                ? onCancel
                                : null,
                            child: Text(
                              context.l10n.memoryToolTaskCancelAction,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MemoryToolPointerTaskMetricChip extends StatelessWidget {
  const _MemoryToolPointerTaskMetricChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.72,
        ),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
        child: Text(
          '$label $value',
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MemoryToolPointerAutoChaseMask extends StatelessWidget {
  const _MemoryToolPointerAutoChaseMask({
    required this.taskState,
    required this.currentDepth,
    required this.maxDepth,
    required this.message,
    required this.onCancel,
  });

  final PointerScanTaskState? taskState;
  final int currentDepth;
  final int maxDepth;
  final String? message;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final progress = _resolvePointerTaskProgress(taskState);
    final resolvedMessage = message?.trim() ?? '';

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.34),
      child: SafeArea(
        minimum: EdgeInsets.all(12.r),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxPanelHeight = (constraints.maxHeight - 12.r)
                .clamp(220.r, double.infinity)
                .toDouble();

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 340.r,
                  minWidth: 240.r,
                  maxHeight: maxPanelHeight,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 18.r,
                        offset: Offset(0, 10.r),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          context.l10n.memoryToolPointerAutoChaseTitle,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 14.r),
                        progress == null
                            ? SizedBox(
                                width: 28.r,
                                height: 28.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4.r,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999.r),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 8.r,
                                    ),
                                  ),
                                  SizedBox(height: 8.r),
                                  Text(
                                    '${(progress * 100).toStringAsFixed(1)}%',
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                        if (resolvedMessage.isNotEmpty) ...<Widget>[
                          SizedBox(height: 12.r),
                          Text(
                            resolvedMessage,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.72,
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        SizedBox(height: 14.r),
                        Wrap(
                          spacing: 8.r,
                          runSpacing: 8.r,
                          children: <Widget>[
                            _MemoryToolPointerTaskMetricChip(
                              label: 'L',
                              value:
                                  '$currentDepth${maxDepth > 0 ? '/$maxDepth' : ''}',
                            ),
                            if ((taskState?.elapsedMilliseconds ?? 0) > 0)
                              _MemoryToolPointerTaskMetricChip(
                                label: context.l10n.memoryToolTaskElapsedLabel,
                                value: formatDurationShort(
                                  taskState!.elapsedMilliseconds,
                                ),
                              ),
                            if ((taskState?.totalRegions ?? 0) > 0)
                              _MemoryToolPointerTaskMetricChip(
                                label: context.l10n.memoryToolTaskRegionsLabel,
                                value:
                                    '${taskState!.processedRegions}/${taskState!.totalRegions}',
                              ),
                            if ((taskState?.totalEntries ?? 0) > 0)
                              _MemoryToolPointerTaskMetricChip(
                                label: context.l10n.memoryToolTaskEntriesLabel,
                                value:
                                    '${taskState!.processedEntries}/${taskState!.totalEntries}',
                              ),
                            if ((taskState?.totalBytes ?? 0) > 0)
                              _MemoryToolPointerTaskMetricChip(
                                label: context.l10n.memoryToolTaskBytesLabel,
                                value:
                                    '${formatBytesCompact(taskState!.processedBytes)}/${formatBytesCompact(taskState!.totalBytes)}',
                              ),
                            _MemoryToolPointerTaskMetricChip(
                              label:
                                  context.l10n.memoryToolTaskResultCountLabel,
                              value: (taskState?.resultCount ?? 0).toString(),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.r),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: taskState?.canCancel ?? true
                                ? onCancel
                                : null,
                            child: Text(
                              context.l10n.memoryToolTaskCancelAction,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MemoryToolPointerJumpLoadingMask extends StatelessWidget {
  const _MemoryToolPointerJumpLoadingMask();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.12),
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colorScheme.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PointerHeaderPanel extends StatelessWidget {
  const _PointerHeaderPanel({
    required this.state,
    required this.availableRegionTypeKeys,
    required this.selectedRegionTypeKeys,
    required this.onTapLayer,
    required this.onToggleRegionTypeKey,
    required this.onClearRegionFilters,
  });

  final MemoryToolPointerState state;
  final List<String> availableRegionTypeKeys;
  final Set<String> selectedRegionTypeKeys;
  final ValueChanged<int> onTapLayer;
  final ValueChanged<String> onToggleRegionTypeKey;
  final VoidCallback onClearRegionFilters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.surface.withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.38),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.r, 10.r, 10.r, 10.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _PointerBreadcrumbRow(state: state, onTapLayer: onTapLayer),
              if (availableRegionTypeKeys.isNotEmpty) ...<Widget>[
                SizedBox(height: 8.r),
                _PointerFilterPanel(
                  selectedRegionTypeKeys: selectedRegionTypeKeys,
                  availableRegionTypeKeys: availableRegionTypeKeys,
                  onToggleRegionTypeKey: onToggleRegionTypeKey,
                  onClearRegionFilters: onClearRegionFilters,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PointerBreadcrumbRow extends StatelessWidget {
  const _PointerBreadcrumbRow({required this.state, required this.onTapLayer});

  final MemoryToolPointerState state;
  final ValueChanged<int> onTapLayer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.generate(state.layers.length, (index) {
          final layer = state.layers[index];
          final selected = index == state.currentLayerIndex;
          return Padding(
            padding: EdgeInsets.only(right: 6.r),
            child: ChoiceChip(
              label: Text(
                'L$index ${formatMemoryToolSearchResultAddress(layer.request.targetAddress)}',
              ),
              selected: selected,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
              onSelected: (_) {
                onTapLayer(index);
              },
            ),
          );
        }),
      ),
    );
  }
}

class _PointerFooter extends StatelessWidget {
  const _PointerFooter({
    required this.currentLayer,
    required this.sessionStateAsync,
  });

  final PointerChainLayerState? currentLayer;
  final AsyncValue<PointerScanSessionState> sessionStateAsync;

  @override
  Widget build(BuildContext context) {
    final loadedCount = currentLayer == null ? 0 : currentLayer!.results.length;
    final sessionCount = sessionStateAsync.asData?.value.resultCount ?? 0;
    final totalCount = currentLayer?.totalResultCount ?? 0;
    final resolvedTotalCount = totalCount > 0 ? totalCount : sessionCount;
    final stopReasonText = switch (currentLayer?.autoStopReasonKey) {
      'staticReached' => context.l10n.memoryToolPointerStopReasonStaticReached,
      'noMorePointers' =>
        context.l10n.memoryToolPointerStopReasonNoMorePointers,
      'maxDepth' => context.l10n.memoryToolPointerStopReasonMaxDepth,
      'cancelled' => context.l10n.memoryToolPointerStopReasonCancelled,
      'failed' => context.l10n.memoryToolPointerStopReasonFailed,
      _ => null,
    };

    if (currentLayer == null ||
        (loadedCount <= 0 &&
            resolvedTotalCount <= 0 &&
            stopReasonText == null)) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (loadedCount > 0 || resolvedTotalCount > 0)
            Text(
              context.l10n.memoryToolPointerLoadedCount(
                loadedCount,
                resolvedTotalCount,
              ),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.68),
                fontWeight: FontWeight.w700,
              ),
            ),
          if (stopReasonText != null) ...<Widget>[
            SizedBox(height: 2.r),
            Text(
              stopReasonText,
              style: context.textTheme.bodySmall?.copyWith(
                color: currentLayer?.autoStopReasonKey == 'failed'
                    ? context.colorScheme.error
                    : context.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PointerFilterPanel extends StatelessWidget {
  const _PointerFilterPanel({
    required this.selectedRegionTypeKeys,
    required this.availableRegionTypeKeys,
    required this.onToggleRegionTypeKey,
    required this.onClearRegionFilters,
  });

  final Set<String> selectedRegionTypeKeys;
  final List<String> availableRegionTypeKeys;
  final ValueChanged<String> onToggleRegionTypeKey;
  final VoidCallback onClearRegionFilters;

  @override
  Widget build(BuildContext context) {
    if (availableRegionTypeKeys.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 6.r),
            child: ChoiceChip(
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
              label: Text(context.l10n.memoryToolRangePresetAll),
              selected: selectedRegionTypeKeys.isEmpty,
              onSelected: (_) {
                onClearRegionFilters();
              },
            ),
          ),
          ...availableRegionTypeKeys.map((regionTypeKey) {
            return Padding(
              padding: EdgeInsets.only(right: 6.r),
              child: FilterChip(
                visualDensity: const VisualDensity(
                  horizontal: -2,
                  vertical: -2,
                ),
                label: Text(
                  mapMemoryToolSearchResultRegionTypeLabel(
                    context,
                    regionTypeKey,
                  ),
                ),
                selected: selectedRegionTypeKeys.contains(regionTypeKey),
                onSelected: (_) {
                  onToggleRegionTypeKey(regionTypeKey);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

double? _resolvePointerTaskProgress(PointerScanTaskState? state) {
  if (state == null) {
    return null;
  }
  if (state.totalBytes > 0) {
    return math.min(1.0, state.processedBytes / state.totalBytes);
  }
  if (state.totalEntries > 0) {
    return math.min(1.0, state.processedEntries / state.totalEntries);
  }
  if (state.totalRegions > 0) {
    return math.min(1.0, state.processedRegions / state.totalRegions);
  }
  return null;
}
