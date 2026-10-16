import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/utils/memory_tool_search_result_presenter.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoryToolAssemblyPreviewDialog extends HookConsumerWidget {
  const MemoryToolAssemblyPreviewDialog({
    super.key,
    required this.pid,
    required this.addresses,
    required this.onClose,
  });

  final int pid;
  final List<int> addresses;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedAddresses = useMemoized(
      () => addresses.toSet().toList(growable: false)..sort(),
      <Object>[addresses.join(',')],
    );
    final future = useMemoized(
      () => ref
          .read(memoryQueryRepositoryProvider)
          .disassembleMemory(pid: pid, addresses: sortedAddresses),
      <Object>[pid, sortedAddresses.join(',')],
    );
    final snapshot = useFuture(future);

    return OverlayPanelDialog.card(
      onClose: onClose,
      maxWidthPortrait: 420.r,
      maxWidthLandscape: 520.r,
      maxHeightPortrait: 520.r,
      maxHeightLandscape: 420.r,
      cardBorderRadius: 18.r,
      childBuilder: (context, viewport, layout) {
        return Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.l10n.memoryToolAssemblyPreviewTitle,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4.r),
              Text(
                context.l10n.memoryToolAssemblyPreviewCount(
                  sortedAddresses.length,
                ),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.r),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: context.colorScheme.outlineVariant.withValues(
                        alpha: 0.34,
                      ),
                    ),
                  ),
                  child: _buildBody(context, snapshot),
                ),
              ),
              SizedBox(height: 12.r),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onClose,
                  child: Text(context.l10n.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<List<MemoryInstructionPreview>> snapshot,
  ) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Center(child: Loading());
    }

    if (snapshot.hasError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Text(
            snapshot.error.toString(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    final instructions = snapshot.data ?? const <MemoryInstructionPreview>[];
    if (instructions.isEmpty) {
      return Center(
        child: Text(
          context.l10n.memoryToolAssemblyPreviewEmpty,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.62),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(10.r),
      itemCount: instructions.length,
      separatorBuilder: (_, _) => SizedBox(height: 8.r),
      itemBuilder: (context, index) {
        final instruction = instructions[index];
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.surface.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  formatMemoryToolSearchResultAddress(instruction.address),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.r),
                Text(
                  _formatBytes(instruction.rawBytes),
                  style: context.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: context.colorScheme.onSurface.withValues(
                      alpha: 0.68,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.r),
                Text(
                  instruction.instructionText,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _formatBytes(List<int> bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ');
}
