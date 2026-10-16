import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/block_l10n.dart';
import 'package:JsxposedX/features/xposed/domain/models/block_node.dart';
import 'package:JsxposedX/features/xposed/domain/models/block_registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 积木面板上下文，用于推荐相关积木
enum PaletteContext {
  root,        // 顶层
  hookBefore,  // before/body slot (非 after)
  hookAfter,   // after slot
  flow,        // if/for 内部
}

class BlockPaletteSheet extends StatefulWidget {
  final ValueChanged<BlockNode> onAdd;
  final PaletteContext paletteContext;

  const BlockPaletteSheet({
    super.key,
    required this.onAdd,
    this.paletteContext = PaletteContext.root,
  });

  static void show(
    BuildContext context, {
    required ValueChanged<BlockNode> onAdd,
    PaletteContext paletteContext = PaletteContext.root,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => BlockPaletteSheet(
        onAdd: onAdd,
        paletteContext: paletteContext,
      ),
    );
  }

  @override
  State<BlockPaletteSheet> createState() => _BlockPaletteSheetState();
}

class _BlockPaletteSheetState extends State<BlockPaletteSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _catLabels = {
    BlockCategory.hook: 'Hook',
    BlockCategory.logging: '日志',
    BlockCategory.fields: '字段',
    BlockCategory.params: '参数',
    BlockCategory.calls: '调用',
    BlockCategory.flow: '流程',
    BlockCategory.extensions: '扩展',
  };

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recs = _recommendations();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(children: [
          _handle(),
          _searchBar(),
          if (_query.isEmpty && recs.isNotEmpty) _recsRow(recs),
          Expanded(child: _query.isEmpty ? _tabView() : _searchResults()),
        ]),
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: 40.w, height: 4.h,
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: TextField(
        controller: _searchCtrl,
        style: TextStyle(fontSize: 13.sp),
        decoration: InputDecoration(
          hintText: context.l10n.search,
          prefixIcon: const Icon(Icons.search, size: 20),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          suffixIcon: _query.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchCtrl.clear();
                    setState(() => _query = '');
                  },
                  child: const Icon(Icons.close, size: 18),
                )
              : null,
        ),
        onChanged: (v) => setState(() => _query = v.trim()),
      ),
    );
  }

  List<BlockDefinition> _recommendations() {
    const beforeRecs = [
      BlockType.getArg, BlockType.log, BlockType.getField,
      BlockType.setField, BlockType.callMethod, BlockType.ifBlock,
      BlockType.varAssign,
    ];
    const afterRecs = [
      BlockType.getResult, BlockType.setResult, BlockType.log,
      BlockType.getField, BlockType.callMethod, BlockType.ifBlock,
    ];
    const flowRecs = [
      BlockType.log, BlockType.setResult, BlockType.setArg,
      BlockType.setField, BlockType.callMethod, BlockType.varAssign,
    ];
    const rootRecs = [
      BlockType.hookMethod, BlockType.hookBefore, BlockType.hookAfter,
      BlockType.hookConstructor, BlockType.hookReplace,
    ];

    final types = switch (widget.paletteContext) {
      PaletteContext.hookBefore => beforeRecs,
      PaletteContext.hookAfter => afterRecs,
      PaletteContext.flow => flowRecs,
      PaletteContext.root => rootRecs,
    };

    return types.map((t) => BlockRegistry.get(t)).toList();
  }

  Widget _recsRow(List<BlockDefinition> recs) {
    final l10n = context.l10n;
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: recs.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (_, i) {
          final d = recs[i];
          return ActionChip(
            avatar: Icon(d.icon, size: 14.r, color: d.color),
            label: Text(
              BlockL10n.resolve(l10n, d.labelKey),
              style: TextStyle(fontSize: 11.sp),
            ),
            onPressed: () {
              Navigator.pop(context);
              widget.onAdd(BlockNode(type: d.type));
            },
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  Widget _tabView() {
    return DefaultTabController(
      length: BlockCategory.values.length,
      child: Column(children: [
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: BlockCategory.values
              .map((c) => Tab(text: _catLabels[c]))
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            children: BlockCategory.values
                .map((cat) => _grid(BlockRegistry.byCategory(cat)))
                .toList(),
          ),
        ),
      ]),
    );
  }

  Widget _searchResults() {
    final l10n = context.l10n;
    final q = _query.toLowerCase();
    final all = [
      for (final cat in BlockCategory.values)
        ...BlockRegistry.byCategory(cat),
    ].where((d) =>
        BlockL10n.resolve(l10n, d.labelKey).toLowerCase().contains(q) ||
        d.type.name.toLowerCase().contains(q),
    ).toList();

    if (all.isEmpty) {
      return Center(
        child: Text(
          context.l10n.noVariablesAvailable,
          style: TextStyle(color: Colors.grey, fontSize: 13.sp),
        ),
      );
    }
    return _grid(all);
  }

  Widget _grid(List<BlockDefinition> defs) {
    final l10n = context.l10n;
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(12.w),
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      childAspectRatio: 2.4,
      children: defs.map((d) => _Tile(
        icon: d.icon,
        color: d.color,
        title: BlockL10n.resolve(l10n, d.labelKey),
        onTap: () {
          Navigator.pop(context);
          widget.onAdd(BlockNode(type: d.type));
        },
      )).toList(),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Row(children: [
          Container(
            width: 4.w,
            height: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(12.r)),
            ),
          ),
          SizedBox(width: 10.w),
          Icon(icon, color: color, size: 20.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          ),
        ]),
      ),
    );
  }
}
