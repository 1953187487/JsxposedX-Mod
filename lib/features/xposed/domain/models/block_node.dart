import 'package:uuid/uuid.dart';

/// 积木类型枚举 — 覆盖 JsxposedX API 手册所有方法
enum BlockType {
  // Hook 类
  hookMethod,
  hookBefore,
  hookAfter,
  hookReplace,
  hookConstructor,
  beforeConstructor,
  afterConstructor,
  returnConst,
  hookAllMethods,
  hookAllConstructors,
  unhook,

  // 日志类
  log,
  logException,
  consoleLog,
  consoleWarn,
  consoleError,
  stackTrace,

  // 字段类
  getField,
  setField,
  getInt,
  setInt,
  getBool,
  setBool,
  getClassName,
  getLong,
  setLong,
  getFloat,
  setFloat,
  getDouble,
  setDouble,

  // 参数类 (hook 回调内)
  getArg,
  setArg,
  getResult,
  setResult,
  getThrowable,
  setThrowable,

  // 调用类
  callMethod,
  callMethodTyped,
  callStatic,
  callStaticAuto,
  newInstance,
  newInstanceTyped,

  // 流程控制
  ifBlock,
  forLoop,
  varAssign,
  customCode,

  // 扩展工具
  toast,
  getApplication,
  getPackageName,
  getSharedPrefs,
  getPrefString,
  getPrefInt,
  getPrefBool,
  getSystemProp,
  getBuild,
  startActivity,
  findClass,
  loadClass,
  getMethods,
  getFields,
  instanceOf,
  setExtra,
  getExtra,
}

/// 积木分类
enum BlockCategory {
  hook,
  logging,
  fields,
  params,
  calls,
  flow,
  extensions,
}

/// 递归积木节点
class BlockNode {
  final String id;
  final BlockType type;
  final bool enabled;
  final Map<String, String> params;
  final Map<String, List<BlockNode>> slots;

  BlockNode({
    String? id,
    required this.type,
    this.enabled = true,
    this.params = const {},
    this.slots = const {},
  }) : id = id ?? const Uuid().v4().replaceAll('-', '').substring(0, 8);

  BlockNode copyWith({
    BlockType? type,
    bool? enabled,
    Map<String, String>? params,
    Map<String, List<BlockNode>>? slots,
  }) {
    return BlockNode(
      id: id,
      type: type ?? this.type,
      enabled: enabled ?? this.enabled,
      params: params ?? this.params,
      slots: slots ?? this.slots,
    );
  }

  /// 检查此节点的子树中是否包含指定 id
  bool containsId(String targetId) {
    for (final children in slots.values) {
      for (final child in children) {
        if (child.id == targetId || child.containsId(targetId)) return true;
      }
    }
    return false;
  }

  /// Recursively remove a child block by id from all slots.
  /// Returns a new BlockNode with the child removed, or null if this node itself is the target.
  BlockNode? removeChildById(String targetId) {
    final newSlots = <String, List<BlockNode>>{};
    for (final entry in slots.entries) {
      final filtered = <BlockNode>[];
      for (final child in entry.value) {
        if (child.id == targetId) continue;
        final cleaned = child.removeChildById(targetId);
        if (cleaned != null) filtered.add(cleaned);
      }
      newSlots[entry.key] = filtered;
    }
    return copyWith(slots: newSlots);
  }

  /// Recursively find the node with [targetId] and append [block] to its [slotKey].
  BlockNode insertIntoSlot(String targetId, String slotKey, BlockNode block) {
    if (id == targetId) {
      final existing = slots[slotKey] ?? [];
      return copyWith(slots: {...slots, slotKey: [...existing, block]});
    }
    final newSlots = <String, List<BlockNode>>{};
    for (final entry in slots.entries) {
      newSlots[entry.key] = entry.value
          .map((child) => child.insertIntoSlot(targetId, slotKey, block))
          .toList();
    }
    return copyWith(slots: newSlots);
  }

  /// 深拷贝：递归复制整棵子树，所有节点生成新 id
  BlockNode deepCopy() {
    return BlockNode(
      type: type,
      enabled: enabled,
      params: Map.of(params),
      slots: slots.map(
        (k, v) => MapEntry(k, v.map((n) => n.deepCopy()).toList()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'enabled': enabled,
        'params': params,
        'slots': slots.map(
          (k, v) => MapEntry(k, v.map((n) => n.toJson()).toList()),
        ),
      };

  factory BlockNode.fromJson(Map<String, dynamic> json) {
    return BlockNode(
      id: json['id'] as String?,
      type: BlockType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BlockType.customCode,
      ),
      enabled: json['enabled'] as bool? ?? true,
      params: (json['params'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      slots: (json['slots'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
              k,
              (v as List)
                  .map((e) => BlockNode.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          ) ??
          {},
    );
  }
}
