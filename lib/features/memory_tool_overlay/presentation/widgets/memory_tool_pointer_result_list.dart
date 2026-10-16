import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/states/memory_tool_pointer_state.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_host_runtime_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_region_owner_resolver.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_result_badge.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_tool_search_result_action_dialog.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart'
    show PointerScanRequest, PointerScanResult;
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolPointerResultList extends HookConsumerWidget {
  const MemoryToolPointerResultList({
    super.key,
    required this.results,
    required this.request,
    required this.scrollController,
    required this.chainLayers,
    required this.currentLayerIndex,
    this.selectedPointerAddress,
    this.isTerminalLayer = false,
    required this.onContinueSearch,
    required this.onJumpToTarget,
  });

  final List<PointerScanResult> results;
  final PointerScanRequest request;
  final ScrollController scrollController;
  final List<PointerChainLayerState> chainLayers;
  final int currentLayerIndex;
  final int? selectedPointerAddress;
  final bool isTerminalLayer;
  final Future<void> Function(PointerScanResult result) onContinueSearch;
  final Future<void> Function(PointerScanResult result) onJumpToTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeActionDialog = useState<PointerScanResult?>(null);
    Future<void> copyText(String value) async {
      final copied = await FlutterOverlayWindow.setClipboardData(value);
      ref.read(overlayWindowHostRuntimeProvider.notifier).showToast(
        copied ? context.l10n.codeCopied : context.l10n.error,
      );
    }

    return Stack(
      children: <Widget>[
        ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.zero,
          itemCount: results.length,
          separatorBuilder: (_, index) =>
              SizedBox(height: index == results.length - 1 ? 6.r : 4.r),
          itemBuilder: (context, index) {
            final result = results[index];
            return _MemoryToolPointerResultTile(
              result: result,
              pointerWidth: request.pointerWidth,
              isAutoSelected: selectedPointerAddress == result.pointerAddress,
              showStaticBadge:
                  isTerminalLayer && selectedPointerAddress == result.pointerAddress,
              onOpenActions: () {
                activeActionDialog.value = result;
              },
            );
          },
        ),
        if (activeActionDialog.value case final result?)
          Positioned.fill(
            child: MemoryToolSearchResultActionDialog(
              actions: <MemoryToolSearchResultActionItemData>[
                MemoryToolSearchResultActionItemData(
                  icon: Icons.account_tree_rounded,
                  title: context.l10n.memoryToolPointerActionContinueSearch,
                  onTap: () async {
                    await onContinueSearch(result);
                    activeActionDialog.value = null;
                  },
                ),
                MemoryToolSearchResultActionItemData(
                  icon: Icons.subdirectory_arrow_right_rounded,
                  title: context.l10n.memoryToolPointerActionJumpToTarget,
                  onTap: () async {
                    await onJumpToTarget(result);
                    activeActionDialog.value = null;
                  },
                ),
                MemoryToolSearchResultActionItemData(
                  icon: Icons.data_object_rounded,
                  title: context.l10n.memoryToolPointerActionCopyExpression,
                  onTap: () async {
                    final soName = await resolveMemoryToolRegionOwnerSoName(
                      repository: ref.read(memoryQueryRepositoryProvider),
                      pid: request.pid,
                      regionStart: result.regionStart,
                    );
                    await copyText(
                      _buildPointerExpression(
                        result,
                        soName: soName,
                        chainLayers: chainLayers,
                        currentLayerIndex: currentLayerIndex,
                      ),
                    );
                    activeActionDialog.value = null;
                  },
                ),
                MemoryToolSearchResultActionItemData(
                  icon: Icons.copy_all_rounded,
                  title:
                      '${context.l10n.memoryToolPointerActionCopyPointerAddress}: ${formatMemoryToolSearchResultAddress(result.pointerAddress)}',
                  onTap: () async {
                    await copyText(
                      formatMemoryToolSearchResultAddress(result.pointerAddress),
                    );
                    activeActionDialog.value = null;
                  },
                ),
                MemoryToolSearchResultActionItemData(
                  icon: Icons.my_location_rounded,
                  title:
                      '${context.l10n.memoryToolPointerActionCopyPointedAddress}: ${formatMemoryToolSearchResultAddress(result.baseAddress)}',
                  onTap: () async {
                    await copyText(
                      formatMemoryToolSearchResultAddress(result.baseAddress),
                    );
                    activeActionDialog.value = null;
                  },
                ),
                MemoryToolSearchResultActionItemData(
                  icon: Icons.adjust_rounded,
                  title:
                      '${context.l10n.memoryToolPointerActionCopyTargetAddress}: ${formatMemoryToolSearchResultAddress(result.targetAddress)}',
                  onTap: () async {
                    await copyText(
                      formatMemoryToolSearchResultAddress(result.targetAddress),
                    );
                    activeActionDialog.value = null;
                  },
                ),
              ],
              onClose: () {
                activeActionDialog.value = null;
              },
            ),
          ),
      ],
    );
  }
}

class _MemoryToolPointerResultTile extends StatelessWidget {
  const _MemoryToolPointerResultTile({
    required this.result,
    required this.pointerWidth,
    required this.isAutoSelected,
    required this.showStaticBadge,
    required this.onOpenActions,
  });

  final PointerScanResult result;
  final int pointerWidth;
  final bool isAutoSelected;
  final bool showStaticBadge;
  final VoidCallback onOpenActions;

  @override
  Widget build(BuildContext context) {
    final offsetHex = result.offset.toRadixString(16).toUpperCase();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpenActions,
        onLongPress: onOpenActions,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          decoration: BoxDecoration(
            color: isAutoSelected
                ? context.colorScheme.primaryContainer.withValues(alpha: 0.5)
                : context.colorScheme.surface.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isAutoSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.42),
              width: isAutoSelected ? 1.4 : 1,
            ),
          ),
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${context.l10n.memoryToolPointerOffsetLabel}: +0x$offsetHex',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4.r),
                    Text(
                      '${_resolvePointerBaseLabel(context)}: ${formatMemoryToolSearchResultAddress(result.baseAddress)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.r),
                    Text(
                      '${context.l10n.memoryToolPointerTargetAddressLabel}: ${formatMemoryToolSearchResultAddress(result.targetAddress)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withValues(alpha: 0.68),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.r),
                    Wrap(
                      spacing: 6.r,
                      runSpacing: 6.r,
                      children: <Widget>[
                        MemoryToolResultBadge(
                          label: 'PTR$pointerWidth',
                          backgroundColor: const Color(0xFFEAF2FF),
                          foregroundColor: const Color(0xFF3157C8),
                        ),
                        if (isAutoSelected)
                          MemoryToolResultBadge(
                            label: context.l10n.memoryToolPointerBadgeAuto,
                            backgroundColor: const Color(0xFFE9F8EF),
                            foregroundColor: const Color(0xFF167C44),
                          ),
                        if (showStaticBadge)
                          MemoryToolResultBadge(
                            label: context.l10n.memoryToolPointerBadgeStatic,
                            backgroundColor: const Color(0xFFFFF0CC),
                            foregroundColor: const Color(0xFFB56A00),
                          ),
                        MemoryToolResultBadge(
                          label: mapMemoryToolSearchResultRegionTypeLabel(
                            context,
                            result.regionTypeKey,
                          ),
                          backgroundColor:
                              mapMemoryToolSearchResultRegionBadgeBackground(
                                result.regionTypeKey,
                              ),
                          foregroundColor:
                              mapMemoryToolSearchResultRegionBadgeForeground(
                                result.regionTypeKey,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.r),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    formatMemoryToolSearchResultAddress(result.pointerAddress),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.r),
                  Text(
                    context.l10n.memoryToolPointerPointerAddressLabel,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.62),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resolvePointerBaseLabel(BuildContext context) {
    if (context.isZh) {
      return '指向地址';
    }
    return 'Pointed Address';
  }
}

String _buildPointerExpression(
  PointerScanResult result, {
  required String soName,
  required List<PointerChainLayerState> chainLayers,
  required int currentLayerIndex,
}) {
  final addr = '0x${formatMemoryToolSearchResultAddress(result.pointerAddress)}';
  final offsets = _resolvePointerExpressionOffsets(
    result: result,
    chainLayers: chainLayers,
    currentLayerIndex: currentLayerIndex,
  );
  final offsetsLiteral = offsets
      .map((offset) => '0x${offset.toRadixString(16).toUpperCase()}')
      .join(',');
  return '{so:"$soName",memory:"${_resolvePointerExpressionMemory(result.regionTypeKey)}",addr:$addr,offsets:[$offsetsLiteral]}';
}

List<int> _resolvePointerExpressionOffsets({
  required PointerScanResult result,
  required List<PointerChainLayerState> chainLayers,
  required int currentLayerIndex,
}) {
  final offsets = <int>[result.offset];
  if (currentLayerIndex <= 0 || currentLayerIndex >= chainLayers.length) {
    return offsets;
  }

  for (var layerIndex = currentLayerIndex - 1; layerIndex >= 0; layerIndex -= 1) {
    final sourceResult = chainLayers[layerIndex + 1].sourceResult;
    if (sourceResult == null) {
      break;
    }
    offsets.add(sourceResult.offset);
  }
  return offsets;
}

String _resolvePointerExpressionMemory(String regionTypeKey) {
  return switch (regionTypeKey) {
    'cBss' => 'Cb',
    'cData' => 'Cd',
    'cAlloc' => 'Ca',
    'cHeap' => 'Ch',
    'codeApp' => 'Xa',
    'codeSys' => 'Xs',
    'java' => 'J',
    'javaHeap' => 'Jh',
    'stack' => 'S',
    'ashmem' => 'As',
    'bad' => 'B',
    'other' => 'O',
    _ => 'A',
  };
}
