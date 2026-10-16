import 'dart:async';

import 'package:JsxposedX/common/widgets/app_code_editor/app_code_editor.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/block_l10n.dart';
import 'package:JsxposedX/core/utils/block_variable_collector.dart';
import 'package:JsxposedX/features/xposed/domain/models/block_node.dart';
import 'package:JsxposedX/features/xposed/domain/models/block_registry.dart';
import 'package:JsxposedX/features/xposed/presentation/constants/jsxposed_prompts.dart';
import 'package:JsxposedX/features/xposed/presentation/widgets/block_palette_sheet.dart';
import 'package:JsxposedX/features/xposed/presentation/widgets/variable_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:re_editor/re_editor.dart';

class BlockNodeWidget extends HookConsumerWidget {
  final BlockNode node;
  final List<BlockNode> allRoots;
  final ValueChanged<BlockNode> onUpdate;
  final VoidCallback onDelete;

  /// 复制积木回调
  final ValueChanged<BlockNode>? onCopy;

  /// Atomic move: (dropped, targetNodeId, targetSlotKey)
  /// Top-level handler does remove + add in ONE state update.
  final void Function(
      BlockNode dropped, String targetNodeId, String targetSlotKey)?
      onMoveToSlot;
  final int depth;

  /// 父级上下文（如 className），供子积木继承
  final Map<String, String> parentContext;

  /// 一键折叠/展开：gen 变化时重置，target 指定目标状态
  final int collapseGen;
  final bool collapseTarget;

  const BlockNodeWidget({
    super.key,
    required this.node,
    required this.allRoots,
    required this.onUpdate,
    required this.onDelete,
    this.onCopy,
    this.onMoveToSlot,
    this.depth = 0,
    this.parentContext = const {},
    this.collapseGen = 0,
    this.collapseTarget = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final def = BlockRegistry.get(node.type);
    final c = def.color;
    final dc = Color.lerp(c, Colors.black, 0.25)!;
    String l(String key) => BlockL10n.resolve(context.l10n, key);

    // --- State ---
    final expanded = useState(true);
    final lastGen = useRef(0);
    final controllers = useRef(<String, TextEditingController>{});
    final codeControllers = useRef(<String, CodeLineEditingController>{});
    final codeUpdateTimers = useRef(<String, Timer>{});
    final syncingCode = useRef(false);
    final focusedKey = useRef(<String>{});
    final latestNode = useRef(node)..value = node;
    final latestOnUpdate = useRef(onUpdate)..value = onUpdate;
    final promptsBuilder = useMemoized(() => buildJsxposedPromptsBuilder());

    // 折叠代数变化时重置
    if (collapseGen != lastGen.value) {
      lastGen.value = collapseGen;
      expanded.value = collapseTarget;
    }

    // Dispose controllers on unmount
    useEffect(() {
      return () {
        for (final timer in codeUpdateTimers.value.values) {
          timer.cancel();
        }
        for (final c in controllers.value.values) {
          c.dispose();
        }
        for (final c in codeControllers.value.values) {
          c.dispose();
        }
      };
    }, []);

    // --- Controller helpers ---
    TextEditingController ctrl(String key, String value) {
      final map = controllers.value;
      final tc = map.putIfAbsent(
        key,
        () => TextEditingController(text: value),
      );
      if (tc.text != value && !focusedKey.value.contains(key)) {
        tc.text = value;
      }
      return tc;
    }

    CodeLineEditingController codeCtrl(String key, String value) {
      var isNew = false;
      final map = codeControllers.value;
      final cc = map.putIfAbsent(
        key,
        () {
          isNew = true;
          final ct = CodeLineEditingController.fromText(value);
          ct.addListener(() {
            if (!syncingCode.value && ct.text != (node.params[key] ?? '')) {
              codeUpdateTimers.value[key]?.cancel();
              codeUpdateTimers.value[key] = Timer(
                const Duration(milliseconds: 250),
                () {
                  final content = ct.text;
                  final currentNode = latestNode.value;
                  if (content != (currentNode.params[key] ?? '')) {
                    latestOnUpdate.value(
                      currentNode.copyWith(
                        params: {...currentNode.params, key: content},
                      ),
                    );
                  }
                },
              );
            }
          });
          return ct;
        },
      );
      if (!isNew && cc.text != value) {
        syncingCode.value = true;
        cc.text = value;
        syncingCode.value = false;
      }
      return cc;
    }

    void up(String key, String val) {
      onUpdate(node.copyWith(params: {...node.params, key: val}));
    }

    // --- Widgets ---

    Widget summaryText() {
      final s = def.summary(node);
      if (s.isEmpty) return const SizedBox.shrink();
      return Text(
        s,
        style: TextStyle(color: Colors.white70, fontSize: 10.sp),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget varPickerBtn(ParamDef pd) {
      final key = pd.key;
      final value = node.params[key] ?? '';
      final isCode = node.type == BlockType.customCode && key == 'code';
      return GestureDetector(
        onTap: () {
          // 弹Sheet前记住光标位置
          int? savedPos;
          if (isCode) {
            final cc = codeControllers.value[key];
            if (cc != null) {
              final sel = cc.selection;
              savedPos = sel.baseOffset >= 0 ? sel.baseOffset : cc.text.length;
            }
          }

          final vars = BlockVariableCollector.collect(allRoots, node.id);
          VariablePickerSheet.show(
            context,
            variables: vars,
            onSelect: (name) {
              final insert = pd.semantic == ParamSemantic.string
                  ? '\${$name}'
                  : name;
              if (isCode) {
                final cc = codeControllers.value[key];
                if (cc != null) {
                  final pos = savedPos ?? cc.text.length;
                  final text = cc.text;
                  final newText =
                      text.substring(0, pos) + insert + text.substring(pos);
                  cc.text = newText;
                }
              } else {
                final tc = ctrl(key, value);
                final sel = tc.selection;
                final pos = sel.isValid ? sel.baseOffset : tc.text.length;
                final text = tc.text;
                final newText =
                    text.substring(0, pos) + insert + text.substring(pos);
                tc.text = newText;
                tc.selection = TextSelection.collapsed(
                  offset: pos + insert.length,
                );
                up(key, newText);
              }
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.only(right: 6.w),
          child: Icon(
            Icons.data_object_rounded,
            size: 16.r,
            color: Colors.blueGrey,
          ),
        ),
      );
    }

    Widget suggestBtn(String key, String suggestion) {
      return GestureDetector(
        onTap: () {
          ctrl(key, '').text = suggestion;
          up(key, suggestion);
        },
        child: Container(
          margin: EdgeInsets.only(right: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            suggestion,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    Widget inheritBtn(String key, String value) {
      final short = BlockDefinition.shortClass(value);
      return GestureDetector(
        onTap: () {
          ctrl(key, '').text = value;
          up(key, value);
        },
        child: Container(
          margin: EdgeInsets.only(right: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '↑$short',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    Widget? buildSuffix(ParamDef pd, bool showInherit, String? inheritVal) {
      final hasVarPicker = pd.showVarPicker;
      String? suggestion;
      if (pd.key == 'varName' && (node.params['varName'] ?? '').isEmpty) {
        suggestion = def.suggestVarName(node);
      }
      if (!showInherit && !hasVarPicker && suggestion == null) return null;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (suggestion != null) suggestBtn('varName', suggestion),
          if (showInherit) inheritBtn(pd.key, inheritVal!),
          if (hasVarPicker) varPickerBtn(pd),
        ],
      );
    }

    Widget codeEditorField(ParamDef pd, String value) {
      final key = pd.key;
      final cc = codeCtrl(key, value);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l(pd.labelKey),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (pd.showVarPicker) varPickerBtn(pd),
            ],
          ),
          SizedBox(height: 6.h),
          SizedBox(
            height: 200.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: AppCodeEditor(
                controller: cc,
                promptsBuilder: promptsBuilder,
              ),
            ),
          ),
        ],
      );
    }

    Widget textField(ParamDef pd, String value, {int maxLines = 1}) {
      final key = pd.key;
      final inheritVal = parentContext[key];
      final showInherit =
          inheritVal != null && inheritVal.isNotEmpty && value.isEmpty;

      return Row(
        children: [
          SizedBox(
            width: 60.w,
            child: Text(
              l(pd.labelKey),
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    focusedKey.value.add(key);
                  } else {
                    focusedKey.value.remove(key);
                  }
                },
                child: TextField(
                  controller: ctrl(key, value),
                  maxLines: maxLines,
                  style: TextStyle(fontSize: 12.sp),
                  decoration: InputDecoration(
                    hintText: l(pd.hintKey),
                    isDense: true,
                    hintStyle:
                        TextStyle(fontSize: 11.sp, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    border: InputBorder.none,
                    suffixIcon: buildSuffix(pd, showInherit, inheritVal),
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 28.w, minHeight: 28.h,
                    ),
                  ),
                  onChanged: (v) => up(key, v),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget dropdown(ParamDef pd, String val) {
      final opts = pd.dropdownOptions ?? [];
      return Row(
        children: [
          SizedBox(
            width: 60.w,
            child: Text(
              l(pd.labelKey),
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: opts.contains(val) ? val : opts.first,
                isDense: true,
                style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                items: opts
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) up(pd.key, v);
                },
              ),
            ),
          ),
        ],
      );
    }

    Widget boolSwitch(String key, String val) {
      return Row(
        children: [
          Text(key,
              style: TextStyle(color: Colors.white, fontSize: 12.sp)),
          const Spacer(),
          SizedBox(
            height: 28.h,
            child: Switch(
              value: val.toLowerCase() == 'true',
              onChanged: (v) => up(key, v.toString()),
              activeColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      );
    }

    Widget paramInput(ParamDef pd) {
      final val = node.params[pd.key] ?? '';
      if (pd.inputType == ParamInputType.dropdown) return dropdown(pd, val);
      if (pd.inputType == ParamInputType.bool) return boolSwitch(pd.key, val);
      if (node.type == BlockType.customCode && pd.key == 'code') {
        return codeEditorField(pd, val);
      }
      return textField(
        pd, val,
        maxLines: pd.inputType == ParamInputType.multiline ? 4 : 1,
      );
    }

    Widget params() {
      return Container(
        margin: EdgeInsets.fromLTRB(6.w, 0, 6.w, 6.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: dc.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          children: [
            for (int i = 0; i < def.paramDefs.length; i++) ...[
              if (i > 0) SizedBox(height: 8.h),
              paramInput(def.paramDefs[i]),
            ],
          ],
        ),
      );
    }

    Widget header() {
      return GestureDetector(
        onTap: () => expanded.value = !expanded.value,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              Icon(Icons.drag_handle_rounded,
                  color: Colors.white70, size: 18.r),
              SizedBox(width: 6.w),
              Icon(def.icon, size: 18.r, color: Colors.white),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l(def.labelKey),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    if (!expanded.value) summaryText(),
                  ],
                ),
              ),
              SizedBox(
                height: 28.h,
                child: Switch(
                  value: node.enabled,
                  onChanged: (v) => onUpdate(node.copyWith(enabled: v)),
                  activeColor: Colors.white,
                  activeTrackColor: dc,
                  inactiveTrackColor: dc.withValues(alpha: 0.5),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(Icons.close_rounded,
                      color: Colors.white70, size: 18.r),
                ),
              ),
              if (onCopy != null)
                GestureDetector(
                  onTap: () => onCopy!(node.deepCopy()),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Icon(Icons.copy_rounded,
                        color: Colors.white70, size: 16.r),
                  ),
                ),
              Icon(
                expanded.value ? Icons.expand_less : Icons.expand_more,
                size: 18.r,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      );
    }

    PaletteContext resolvePaletteContext(String slotKey) {
      const hookTypes = {
        BlockType.hookMethod, BlockType.hookBefore, BlockType.hookAfter,
        BlockType.hookReplace, BlockType.hookConstructor,
        BlockType.beforeConstructor, BlockType.afterConstructor,
        BlockType.hookAllMethods, BlockType.hookAllConstructors,
      };
      const afterHooks = {
        BlockType.hookAfter, BlockType.afterConstructor,
      };
      if (hookTypes.contains(node.type)) {
        if (afterHooks.contains(node.type)) return PaletteContext.hookAfter;
        if (slotKey == 'after') return PaletteContext.hookAfter;
        return PaletteContext.hookBefore;
      }
      if (node.type == BlockType.ifBlock || node.type == BlockType.forLoop) {
        return PaletteContext.flow;
      }
      return PaletteContext.hookBefore;
    }

    List<Widget> slots() {
      final ctx = <String, String>{...parentContext};
      final cls = node.params['className'];
      if (cls != null && cls.isNotEmpty) ctx['className'] = cls;

      return def.slotDefs.map((sd) {
        final children = node.slots[sd.key] ?? [];
        final palCtx = resolvePaletteContext(sd.key);
        return _SlotArea(
          labelKey: sd.labelKey,
          color: dc,
          children: children,
          allRoots: allRoots,
          depth: depth,
          onMoveToSlot: onMoveToSlot,
          parentNodeId: node.id,
          slotKey: sd.key,
          parentContext: ctx,
          paletteContext: palCtx,
          collapseGen: collapseGen,
          collapseTarget: collapseTarget,
          onChildUpdate: (i, updated) {
            final list = [...children];
            list[i] = updated;
            onUpdate(node.copyWith(slots: {...node.slots, sd.key: list}));
          },
          onChildDelete: (i) {
            final list = [...children];
            list.removeAt(i);
            onUpdate(node.copyWith(slots: {...node.slots, sd.key: list}));
          },
          onChildCopy: (i, copied) {
            final list = [...children];
            list.insert(i + 1, copied);
            onUpdate(node.copyWith(slots: {...node.slots, sd.key: list}));
          },
          onAddNew: (block) {
            onUpdate(
              node.copyWith(
                slots: {
                  ...node.slots,
                  sd.key: [...children, block],
                },
              ),
            );
          },
        );
      }).toList();
    }

    Widget block() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.w),
            width: 30.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: c,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(3.r)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: dc.withValues(alpha: 0.4),
                  offset: Offset(0, 3.h),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                header(),
                if (expanded.value) ...[
                  if (def.paramDefs.isNotEmpty) params(),
                  ...slots(),
                ],
              ],
            ),
          ),
        ],
      );
    }

    return LongPressDraggable<BlockNode>(
      data: node,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 200.w,
          child: Opacity(opacity: 0.8, child: block()),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: block()),
      child: block(),
    );
  }
}

class _SlotArea extends StatelessWidget {
  final String labelKey;
  final Color color;
  final List<BlockNode> children;
  final List<BlockNode> allRoots;
  final int depth;
  final String parentNodeId;
  final String slotKey;
  final Map<String, String> parentContext;
  final PaletteContext paletteContext;
  final void Function(int, BlockNode) onChildUpdate;
  final void Function(int) onChildDelete;
  final void Function(int, BlockNode) onChildCopy;
  final ValueChanged<BlockNode> onAddNew;
  final void Function(
      BlockNode dropped, String targetNodeId, String targetSlotKey)?
      onMoveToSlot;
  final int collapseGen;
  final bool collapseTarget;

  const _SlotArea({
    required this.labelKey,
    required this.color,
    required this.children,
    required this.allRoots,
    required this.depth,
    required this.parentNodeId,
    required this.slotKey,
    required this.parentContext,
    required this.paletteContext,
    required this.onChildUpdate,
    required this.onChildDelete,
    required this.onChildCopy,
    required this.onAddNew,
    this.onMoveToSlot,
    this.collapseGen = 0,
    this.collapseTarget = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(6.w, 0, 6.w, 6.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _slotHeader(context),
          SizedBox(height: 4.h),
          ...List.generate(children.length, (i) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: BlockNodeWidget(
                node: children[i],
                allRoots: allRoots,
                depth: depth + 1,
                onUpdate: (n) => onChildUpdate(i, n),
                onDelete: () => onChildDelete(i),
                onCopy: (copied) => onChildCopy(i, copied),
                onMoveToSlot: onMoveToSlot,
                parentContext: parentContext,
                collapseGen: collapseGen,
                collapseTarget: collapseTarget,
              ),
            );
          }),
          _dropZone(),
        ],
      ),
    );
  }

  Widget _slotHeader(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Text(
            BlockL10n.resolve(l10n, labelKey),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => BlockPaletteSheet.show(
            context,
            onAdd: onAddNew,
            paletteContext: paletteContext,
          ),
          child: Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.white54,
            size: 18.r,
          ),
        ),
      ],
    );
  }

  Widget _dropZone() {
    final childIds = children.map((c) => c.id).toSet();
    return DragTarget<BlockNode>(
      onWillAcceptWithDetails: (d) =>
          !childIds.contains(d.data.id) &&
          d.data.id != parentNodeId &&
          !d.data.containsId(parentNodeId),
      onAcceptWithDetails: (d) {
        if (onMoveToSlot != null) {
          onMoveToSlot!(d.data, parentNodeId, slotKey);
        } else {
          onAddNew(d.data);
        }
      },
      builder: (ctx, candidates, rejects) {
        final active = candidates.isNotEmpty;
        return Container(
          height: 32.h,
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: Colors.white
                  .withValues(alpha: active ? 0.5 : 0.15),
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.add_rounded,
              color: Colors.white
                  .withValues(alpha: active ? 0.6 : 0.2),
              size: 18.r,
            ),
          ),
        );
      },
    );
  }
}
