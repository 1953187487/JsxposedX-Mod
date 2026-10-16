import 'package:JsxposedX/features/xposed/domain/models/block_node.dart';

/// 不可变树操作工具
class BlockTreeOps {
  BlockTreeOps._();

  /// 递归删除指定节点
  static List<BlockNode> removeNode(List<BlockNode> roots, String nodeId) {
    return roots
        .where((n) => n.id != nodeId)
        .map((n) => n.copyWith(
              slots: n.slots.map(
                (k, v) => MapEntry(k, removeNode(v, nodeId)),
              ),
            ))
        .toList();
  }

  /// 在指定父节点的槽位中插入节点
  static List<BlockNode> insertNode(
    List<BlockNode> roots, {
    required String? parentId,
    required String slotKey,
    required int index,
    required BlockNode node,
  }) {
    // 插入到根列表
    if (parentId == null) {
      final list = [...roots];
      list.insert(index.clamp(0, list.length), node);
      return list;
    }
    // 递归查找父节点
    return roots.map((n) {
      if (n.id == parentId) {
        final slotChildren = [...(n.slots[slotKey] ?? [])];
        slotChildren.insert(index.clamp(0, slotChildren.length), node);
        return n.copyWith(
          slots: {...n.slots, slotKey: slotChildren},
        );
      }
      return n.copyWith(
        slots: n.slots.map(
          (k, v) => MapEntry(
            k,
            insertNode(v,
                parentId: parentId,
                slotKey: slotKey,
                index: index,
                node: node),
          ),
        ),
      );
    }).toList();
  }

  /// 移动节点：先删除再插入
  static List<BlockNode> moveNode(
    List<BlockNode> roots, {
    required String nodeId,
    required String? targetParentId,
    required String targetSlotKey,
    required int targetIndex,
  }) {
    final node = findNode(roots, nodeId);
    if (node == null) return roots;
    final removed = removeNode(roots, nodeId);
    return insertNode(removed,
        parentId: targetParentId,
        slotKey: targetSlotKey,
        index: targetIndex,
        node: node);
  }

  /// 更新节点参数
  static List<BlockNode> updateNodeParams(
    List<BlockNode> roots,
    String nodeId,
    Map<String, String> newParams,
  ) {
    return roots.map((n) {
      if (n.id == nodeId) {
        return n.copyWith(params: {...n.params, ...newParams});
      }
      return n.copyWith(
        slots: n.slots.map(
          (k, v) => MapEntry(k, updateNodeParams(v, nodeId, newParams)),
        ),
      );
    }).toList();
  }

  /// 切换节点启用状态
  static List<BlockNode> toggleEnabled(
    List<BlockNode> roots, String nodeId, bool enabled,
  ) {
    return roots.map((n) {
      if (n.id == nodeId) return n.copyWith(enabled: enabled);
      return n.copyWith(
        slots: n.slots.map(
          (k, v) => MapEntry(k, toggleEnabled(v, nodeId, enabled)),
        ),
      );
    }).toList();
  }

  /// 递归查找节点
  static BlockNode? findNode(List<BlockNode> roots, String nodeId) {
    for (final n in roots) {
      if (n.id == nodeId) return n;
      for (final children in n.slots.values) {
        final found = findNode(children, nodeId);
        if (found != null) return found;
      }
    }
    return null;
  }
}
