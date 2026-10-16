import 'package:JsxposedX/features/xposed/domain/models/block_node.dart';

/// 变量信息
class VariableInfo {
  final String name;
  final String source;
  final String? description;
  final bool isContext;

  const VariableInfo({
    required this.name,
    required this.source,
    this.description,
    this.isContext = false,
  });
}

/// 收集积木树中 targetId 之前所有可见变量
class BlockVariableCollector {
  static const _hookTypes = {
    BlockType.hookMethod,
    BlockType.hookBefore,
    BlockType.hookAfter,
    BlockType.hookReplace,
    BlockType.hookConstructor,
    BlockType.beforeConstructor,
    BlockType.afterConstructor,
    BlockType.hookAllMethods,
    BlockType.hookAllConstructors,
  };

  /// after 语义的 hook 类型（可访问 result/throwable）
  static const _afterTypes = {
    BlockType.hookAfter,
    BlockType.afterConstructor,
  };

  /// 收集 [targetId] 位置之前所有可见变量
  static List<VariableInfo> collect(List<BlockNode> roots, String targetId) {
    final vars = <VariableInfo>[];
    _collectFromList(roots, targetId, vars, inHookSlot: false);
    return vars;
  }

  /// 遍历节点列表，遇到 targetId 返回 true（停止）
  static bool _collectFromList(
    List<BlockNode> nodes,
    String targetId,
    List<VariableInfo> vars, {
    required bool inHookSlot,
  }) {
    for (final node in nodes) {
      if (node.id == targetId) return true;
      _collectFromNode(node, vars);
      if (_collectSlots(node, targetId, vars, inHookSlot: inHookSlot)) {
        return true;
      }
    }
    return false;
  }

  /// 收集单个节点声明的变量
  static void _collectFromNode(BlockNode node, List<VariableInfo> vars) {
    final varName = node.params['varName'];
    if (varName != null && varName.isNotEmpty) {
      vars.add(VariableInfo(
        name: varName,
        source: node.type.name,
      ));
    }
  }

  /// 递归进入节点的 slots
  static bool _collectSlots(
    BlockNode node,
    String targetId,
    List<VariableInfo> vars, {
    required bool inHookSlot,
  }) {
    final isHook = _hookTypes.contains(node.type);
    for (final entry in node.slots.entries) {
      final slotInHook = inHookSlot || isHook;
      if (isHook && !inHookSlot) {
        _injectContextVars(vars, node, entry.key);
      }
      if (_collectFromList(
        entry.value, targetId, vars,
        inHookSlot: slotInHook,
      )) {
        return true;
      }
    }
    return false;
  }

  /// 根据 hook 类型、slot 和参数类型注入上下文变量
  static void _injectContextVars(
    List<VariableInfo> vars,
    BlockNode hookNode,
    String slotKey,
  ) {
    final existing = vars.map((v) => v.name).toSet();
    void add(String name, {String? desc}) {
      if (!existing.contains(name)) {
        vars.add(VariableInfo(
          name: name,
          source: 'hook',
          description: desc,
          isContext: true,
        ));
        existing.add(name);
      }
    }

    // 基础上下文
    add('param', desc: 'Hook 回调参数对象');
    add('param.thisObject', desc: '被 Hook 的对象实例');

    // 根据 paramTypes 生成 getArg(0..N)
    final rawTypes = hookNode.params['paramTypes'] ?? '';
    if (rawTypes.trim().isNotEmpty) {
      final types = rawTypes.split(',').map((e) => e.trim()).toList();
      for (var i = 0; i < types.length; i++) {
        add('param.getArg($i)', desc: types[i]);
      }
    } else {
      add('param.getArg(0)');
    }

    // after slot 或 hookMethod 的 after slot 才注入 result/throwable
    final isAfterSlot = _isAfterContext(hookNode.type, slotKey);
    if (isAfterSlot) {
      add('param.getResult()', desc: '方法返回值');
      add('param.getThrowable()', desc: '抛出的异常');
    }
  }

  /// 判断当前 slot 是否属于 after 语义
  static bool _isAfterContext(BlockType hookType, String slotKey) {
    if (_afterTypes.contains(hookType)) return true;
    // hookMethod / hookConstructor 的 after slot
    if (hookType == BlockType.hookMethod && slotKey == 'after') return true;
    if (hookType == BlockType.hookConstructor && slotKey == 'after') return true;
    if (hookType == BlockType.hookAllMethods && slotKey == 'after') return true;
    if (hookType == BlockType.hookAllConstructors && slotKey == 'after') {
      return true;
    }
    return false;
  }
}
