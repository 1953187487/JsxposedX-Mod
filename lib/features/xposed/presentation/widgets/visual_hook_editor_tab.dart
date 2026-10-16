import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/xposed/domain/models/block_node.dart';
import 'package:JsxposedX/features/xposed/presentation/widgets/block_node_widget.dart';
import 'package:JsxposedX/features/xposed/presentation/widgets/block_palette_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VisualHookEditorTab extends HookWidget {
  final List<BlockNode> blocks;
  final ValueChanged<List<BlockNode>> onBlocksChanged;

  const VisualHookEditorTab({
    super.key,
    required this.blocks,
    required this.onBlocksChanged,
  });

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    final collapseGen = useState(0);
    final collapseTarget = useState(true);

    if (blocks.isEmpty) return _empty(context);
    return _list(context, collapseGen, collapseTarget);
  }

  Widget _empty(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.widgets_outlined, size: 64.sp,
            color: context.colorScheme.outlineVariant),
          SizedBox(height: 16.h),
          Text(l10n.noBlocks, style: TextStyle(
            color: context.colorScheme.outline,
            fontSize: 15.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 6.h),
          Text(l10n.noBlocksHint, style: TextStyle(
            color: context.colorScheme.outline.withValues(alpha: 0.6),
            fontSize: 12.sp)),
          SizedBox(height: 24.h),
          _addBtn(context),
        ],
      ),
    );
  }

  List<BlockNode> _removeFromTree(List<BlockNode> tree, String targetId) {
    final result = <BlockNode>[];
    for (final node in tree) {
      if (node.id == targetId) continue;
      final cleaned = node.removeChildById(targetId);
      if (cleaned != null) result.add(cleaned);
    }
    return result;
  }

  void _moveToSlot(
    BlockNode dropped, String targetNodeId, String targetSlotKey,
  ) {
    var cleaned = _removeFromTree(blocks, dropped.id);
    cleaned = cleaned
        .map((n) => n.insertIntoSlot(targetNodeId, targetSlotKey, dropped))
        .toList();
    onBlocksChanged(cleaned);
  }

  Widget _list(
    BuildContext context,
    ValueNotifier<int> collapseGen,
    ValueNotifier<bool> collapseTarget,
  ) {
    return Column(children: [
      Expanded(
        child: DragTarget<BlockNode>(
          onWillAcceptWithDetails: (d) =>
            !blocks.any((b) => b.id == d.data.id),
          onAcceptWithDetails: (d) {
            final cleaned = _removeFromTree(blocks, d.data.id);
            onBlocksChanged([...cleaned, d.data]);
          },
          builder: (ctx, candidates, rejects) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w, vertical: 8.h),
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                final block = blocks[index];
                return Padding(
                  key: ValueKey(block.id),
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: BlockNodeWidget(
                    node: block,
                    allRoots: blocks,
                    collapseGen: collapseGen.value,
                    collapseTarget: collapseTarget.value,
                    onUpdate: (updated) {
                      final list = [...blocks];
                      list[index] = updated;
                      onBlocksChanged(list);
                    },
                    onDelete: () {
                      final list = [...blocks];
                      list.removeAt(index);
                      onBlocksChanged(list);
                    },
                    onCopy: (copied) {
                      final list = [...blocks];
                      list.insert(index + 1, copied);
                      onBlocksChanged(list);
                    },
                    onMoveToSlot: _moveToSlot,
                  ),
                );
              },
            );
          },
        ),
      ),
      _bottomBar(context, collapseGen, collapseTarget),
    ]);
  }

  Widget _bottomBar(
    BuildContext context,
    ValueNotifier<int> collapseGen,
    ValueNotifier<bool> collapseTarget,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 12.h),
      child: Row(
        children: [
          Expanded(child: _addBtn(context)),
          SizedBox(width: 8.w),
          _collapseBtn(context, collapseGen, collapseTarget, false),
          SizedBox(width: 4.w),
          _collapseBtn(context, collapseGen, collapseTarget, true),
        ],
      ),
    );
  }

  Widget _collapseBtn(
    BuildContext context,
    ValueNotifier<int> collapseGen,
    ValueNotifier<bool> collapseTarget,
    bool expand,
  ) {
    return IconButton.outlined(
      onPressed: () {
        collapseTarget.value = expand;
        collapseGen.value++;
      },
      icon: Icon(
        expand ? Icons.unfold_more_rounded : Icons.unfold_less_rounded,
        size: 20.r,
      ),
      tooltip: expand ? context.l10n.expandAll : context.l10n.collapseAll,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(12.h),
      ),
    );
  }

  Widget _addBtn(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => BlockPaletteSheet.show(
          context,
          onAdd: (block) =>
            onBlocksChanged([...blocks, block]),
        ),
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.addBlock),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12.r)),
        ),
      ),
    );
  }
}
