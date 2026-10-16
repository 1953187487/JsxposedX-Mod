import 'package:JsxposedX/features/xposed/domain/models/block_node.dart';
import 'package:flutter/material.dart';

/// 参数输入类型
enum ParamInputType { text, number, dropdown, bool, multiline }

/// 参数语义：决定变量选择器的插入方式
enum ParamSemantic { expression, string }

/// 参数定义
class ParamDef {
  final String key;
  final String labelKey;
  final String hintKey;
  final ParamInputType inputType;
  final List<String>? dropdownOptions;
  final bool showVarPicker;
  final ParamSemantic semantic;
  final bool isRequired;

  const ParamDef({
    required this.key,
    required this.labelKey,
    required this.hintKey,
    this.inputType = ParamInputType.text,
    this.dropdownOptions,
    this.showVarPicker = false,
    this.semantic = ParamSemantic.expression,
    this.isRequired = false,
  });
}

/// 子槽位定义
class SlotDef {
  final String key;
  final String labelKey;

  const SlotDef({required this.key, required this.labelKey});
}

/// 积木定义 — 声明式描述每种积木的 UI 和行为
class BlockDefinition {
  final BlockType type;
  final BlockCategory category;
  final String labelKey;
  final Color color;
  final IconData icon;
  final List<ParamDef> paramDefs;
  final List<SlotDef> slotDefs;
  final bool isRequired;

  const BlockDefinition({
    required this.type,
    required this.category,
    required this.labelKey,
    required this.color,
    required this.icon,
    this.paramDefs = const [],
    this.slotDefs = const [],
    this.isRequired = false,
  });

  bool get hasSlots => slotDefs.isNotEmpty;

  /// 生成积木摘要文本（折叠时显示）
  String summary(BlockNode node) {
    final p = node.params;
    switch (type) {
      // Hook 类 — 显示 类名.方法名(参数类型)
      case BlockType.hookMethod:
      case BlockType.hookBefore:
      case BlockType.hookAfter:
      case BlockType.hookReplace:
      case BlockType.hookAllMethods:
        return _hookSummary(p);
      case BlockType.hookConstructor:
      case BlockType.beforeConstructor:
      case BlockType.afterConstructor:
      case BlockType.hookAllConstructors:
        return _ctorSummary(p);
      case BlockType.returnConst:
        final s = _hookSummary(p);
        final v = p['constValue'] ?? '';
        return v.isEmpty ? s : '$s → $v';
      case BlockType.unhook:
        return p['varName'] ?? '';
      // 字段类 — 显示 .字段名 → 变量名
      case BlockType.getField:
        return _fieldSummary(p, read: true);
      case BlockType.setField:
        return _fieldSummary(p, read: false);
      case BlockType.getInt:
      case BlockType.getBool:
      case BlockType.getLong:
      case BlockType.getFloat:
      case BlockType.getDouble:
      case BlockType.getClassName:
        return _shortFieldGet(p);
      case BlockType.setInt:
      case BlockType.setBool:
      case BlockType.setLong:
      case BlockType.setFloat:
      case BlockType.setDouble:
        return _shortFieldSet(p);
      // 日志类
      case BlockType.log:
      case BlockType.logException:
      case BlockType.consoleLog:
      case BlockType.consoleWarn:
      case BlockType.consoleError:
        return _truncate(p['message'] ?? '', 30);
      case BlockType.stackTrace:
        return p['tag'] ?? '';
      // 参数类
      case BlockType.getArg:
        final i = p['index'] ?? '';
        final v = p['varName'] ?? '';
        return v.isEmpty ? 'args[$i]' : 'args[$i] → $v';
      case BlockType.setArg:
        return 'args[${p['index'] ?? ''}] = ${_truncate(p['value'] ?? '', 20)}';
      case BlockType.getResult:
        return '→ ${p['varName'] ?? ''}';
      case BlockType.setResult:
        return '= ${_truncate(p['value'] ?? '', 20)}';
      case BlockType.getThrowable:
        return '→ ${p['varName'] ?? ''}';
      case BlockType.setThrowable:
        return _truncate(p['message'] ?? '', 25);
      // 调用类
      case BlockType.callMethod:
      case BlockType.callMethodTyped:
        return _callSummary(p);
      case BlockType.callStatic:
      case BlockType.callStaticAuto:
        return _staticCallSummary(p);
      case BlockType.newInstance:
      case BlockType.newInstanceTyped:
        return _newSummary(p);
      // 流程控制
      case BlockType.ifBlock:
        return _truncate(p['condition'] ?? '', 25);
      case BlockType.forLoop:
        final v = p['varName'] ?? 'i';
        return '$v: ${p['from'] ?? '0'}..${p['to'] ?? ''}';
      case BlockType.varAssign:
        final v = p['varName'] ?? '';
        final val = _truncate(p['value'] ?? '', 20);
        return v.isEmpty ? '' : '$v = $val';
      case BlockType.customCode:
        return _truncate(p['code'] ?? '', 30);
      // 扩展工具
      case BlockType.toast:
        return _truncate(p['message'] ?? '', 25);
      case BlockType.getApplication:
      case BlockType.getPackageName:
        return '→ ${p['varName'] ?? ''}';
      case BlockType.getSharedPrefs:
        return '${p['name'] ?? ''} → ${p['varName'] ?? ''}';
      case BlockType.getPrefString:
      case BlockType.getPrefInt:
      case BlockType.getPrefBool:
        return '${p['key'] ?? ''} → ${p['varName'] ?? ''}';
      case BlockType.getBuild:
        return '${p['fieldName'] ?? ''} → ${p['varName'] ?? ''}';
      case BlockType.startActivity:
        return shortClass(p['className'] ?? '');
      case BlockType.findClass:
      case BlockType.loadClass:
      case BlockType.getMethods:
      case BlockType.getFields:
        return '${shortClass(p['className'] ?? '')} → ${p['varName'] ?? ''}';
      case BlockType.instanceOf:
        return '${_truncate(p['value'] ?? '', 15)} is ${shortClass(p['className'] ?? '')}';
      case BlockType.setExtra:
      case BlockType.getExtra:
        return p['key'] ?? '';
      case BlockType.getSystemProp:
        return '${p['key'] ?? ''} → ${p['varName'] ?? ''}';
    }
  }

  /// 根据积木类型和已填参数，建议 varName
  String? suggestVarName(BlockNode node) {
    final p = node.params;
    switch (type) {
      case BlockType.getField:
        return _fieldVarName(p);
      case BlockType.getInt:
      case BlockType.getBool:
      case BlockType.getLong:
      case BlockType.getFloat:
      case BlockType.getDouble:
        return _fieldVarName(p);
      case BlockType.getClassName:
        return 'className';
      case BlockType.getArg:
        final i = p['index'] ?? '0';
        return 'arg$i';
      case BlockType.getResult:
        return 'result';
      case BlockType.getThrowable:
        return 'throwable';
      case BlockType.callMethod:
      case BlockType.callMethodTyped:
        final m = p['methodName'] ?? '';
        return m.isEmpty ? null : '${m}Result';
      case BlockType.callStatic:
      case BlockType.callStaticAuto:
        final m = p['methodName'] ?? '';
        return m.isEmpty ? null : '${m}Result';
      case BlockType.newInstance:
      case BlockType.newInstanceTyped:
        final cls = shortClass(p['className'] ?? '');
        if (cls.isEmpty) return null;
        return '${cls[0].toLowerCase()}${cls.substring(1)}';
      case BlockType.getApplication:
        return 'app';
      case BlockType.getPackageName:
        return 'pkgName';
      case BlockType.getSharedPrefs:
        return 'sp';
      case BlockType.getPrefString:
      case BlockType.getPrefInt:
      case BlockType.getPrefBool:
        return _keyVarName(p);
      case BlockType.getBuild:
        return _fieldVarName(p);
      case BlockType.findClass:
      case BlockType.loadClass:
        final cls = shortClass(p['className'] ?? '');
        return cls.isEmpty ? null : '${cls[0].toLowerCase()}${cls.substring(1)}Cls';
      case BlockType.getMethods:
        return 'methods';
      case BlockType.getFields:
        return 'fields';
      case BlockType.instanceOf:
        return 'isMatch';
      case BlockType.getExtra:
        return _keyVarName(p);
      default:
        return null;
    }
  }

  static String? _fieldVarName(Map<String, String> p) {
    final f = p['fieldName'] ?? '';
    if (f.isEmpty) return null;
    // 去掉 m 前缀（如 mToken → token）
    if (f.length > 1 && f.startsWith('m') && f[1] == f[1].toUpperCase()) {
      return '${f[1].toLowerCase()}${f.substring(2)}';
    }
    return f;
  }

  static String? _keyVarName(Map<String, String> p) {
    final k = p['key'] ?? '';
    return k.isEmpty ? null : k;
  }

  static String _hookSummary(Map<String, String> p) {
    final cls = shortClass(p['className'] ?? '');
    final method = p['methodName'] ?? '';
    final pts = p['paramTypes'] ?? '';
    if (cls.isEmpty && method.isEmpty) return '';
    final sig = pts.isEmpty ? '$cls.$method()' : '$cls.$method($pts)';
    return sig;
  }

  static String _ctorSummary(Map<String, String> p) {
    final cls = shortClass(p['className'] ?? '');
    final pts = p['paramTypes'] ?? '';
    return pts.isEmpty ? cls : '$cls($pts)';
  }

  static String _fieldSummary(Map<String, String> p, {required bool read}) {
    final cls = shortClass(p['className'] ?? '');
    final f = p['fieldName'] ?? '';
    final prefix = cls.isEmpty ? '.' : '$cls.';
    if (read) {
      final v = p['varName'] ?? '';
      return v.isEmpty ? '$prefix$f' : '$prefix$f → $v';
    }
    final val = _truncate(p['value'] ?? '', 15);
    return '$prefix$f = $val';
  }

  static String _shortFieldGet(Map<String, String> p) {
    final f = p['fieldName'] ?? '';
    final v = p['varName'] ?? '';
    return v.isEmpty ? '.$f' : '.$f → $v';
  }

  static String _shortFieldSet(Map<String, String> p) {
    final f = p['fieldName'] ?? '';
    final val = _truncate(p['value'] ?? '', 15);
    return '.$f = $val';
  }

  static String _callSummary(Map<String, String> p) {
    final m = p['methodName'] ?? '';
    final v = p['varName'] ?? '';
    return v.isEmpty ? '.$m()' : '.$m() → $v';
  }

  static String _staticCallSummary(Map<String, String> p) {
    final cls = shortClass(p['className'] ?? '');
    final m = p['methodName'] ?? '';
    final v = p['varName'] ?? '';
    return v.isEmpty ? '$cls.$m()' : '$cls.$m() → $v';
  }

  static String _newSummary(Map<String, String> p) {
    final cls = shortClass(p['className'] ?? '');
    final v = p['varName'] ?? '';
    return v.isEmpty ? 'new $cls' : 'new $cls → $v';
  }

  /// 取类名最后一段（如 com.example.App → App）
  static String shortClass(String cls) {
    if (cls.isEmpty) return '';
    final i = cls.lastIndexOf('.');
    return i < 0 ? cls : cls.substring(i + 1);
  }

  static String _truncate(String s, int max) {
    if (s.length <= max) return s;
    return '${s.substring(0, max)}…';
  }
}

// 常用参数定义复用
const _pClassName = ParamDef(
  key: 'className', labelKey: 'blockClassName',
  hintKey: 'blockClassNameHint', isRequired: true,
);
const _pMethodName = ParamDef(
  key: 'methodName', labelKey: 'blockMethodName',
  hintKey: 'blockMethodNameHint', isRequired: true,
);
const _pParamTypes = ParamDef(
  key: 'paramTypes', labelKey: 'blockParamTypes',
  hintKey: 'blockParamTypesHint',
);
const _pMessage = ParamDef(
  key: 'message', labelKey: 'blockMessage',
  hintKey: 'blockMessageHint', showVarPicker: true,
  semantic: ParamSemantic.string,
);
const _pFieldName = ParamDef(
  key: 'fieldName', labelKey: 'blockFieldName',
  hintKey: 'blockFieldNameHint', isRequired: true,
);
const _pValue = ParamDef(
  key: 'value', labelKey: 'blockValue',
  hintKey: 'blockValueHint', showVarPicker: true,
);
const _pIndex = ParamDef(
  key: 'index', labelKey: 'blockIndex',
  hintKey: 'blockIndexHint', inputType: ParamInputType.number,
  showVarPicker: true,
);
const _pVarName = ParamDef(
  key: 'varName', labelKey: 'blockVarName',
  hintKey: 'blockVarNameHint',
);
const _pArgs = ParamDef(
  key: 'args', labelKey: 'blockArgs',
  hintKey: 'blockArgsHint', showVarPicker: true,
);

// 常用槽位定义
const _sBody = SlotDef(key: 'body', labelKey: 'blockSlotBody');
const _sBefore = SlotDef(key: 'before', labelKey: 'blockSlotBefore');
const _sAfter = SlotDef(key: 'after', labelKey: 'blockSlotAfter');
const _sThen = SlotDef(key: 'then', labelKey: 'blockSlotThen');
const _sElse = SlotDef(key: 'else', labelKey: 'blockSlotElse');

// 颜色常量
const _cHook = Color(0xFF4C97FF);
const _cConstructor = Color(0xFF9966FF);
const _cReturn = Color(0xFF59C059);
const _cLog = Color(0xFFFFAB19);
const _cField = Color(0xFF5CB1D6);
const _cParam = Color(0xFFFF6680);
const _cCall = Color(0xFFCF63CF);
const _cFlow = Color(0xFFFFBF00);
const _cCustom = Color(0xFF6D6D6D);
const _cExt = Color(0xFFFF8C1A);

/// 积木注册表 — 所有积木类型的定义
class BlockRegistry {
  BlockRegistry._();

  static final Map<BlockType, BlockDefinition> _defs = {
    for (final d in _allDefs) d.type: d,
  };

  static BlockDefinition get(BlockType type) =>
      _defs[type] ?? _allDefs.last;

  static List<BlockDefinition> byCategory(BlockCategory cat) =>
      _allDefs.where((d) => d.category == cat).toList();

  static List<BlockDefinition> search(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return _allDefs.where((d) =>
        d.labelKey.toLowerCase().contains(q) ||
        d.type.name.toLowerCase().contains(q)).toList();
  }

  static List<BlockCategory> get categories => BlockCategory.values;
}

// ── Hook 类积木 ──
const _hookDefs = [
  BlockDefinition(
    type: BlockType.hookMethod, category: BlockCategory.hook,
    labelKey: 'blockHookMethod', color: _cHook,
    icon: Icons.functions_rounded,
    paramDefs: [_pClassName, _pMethodName, _pParamTypes],
    slotDefs: [_sBefore, _sAfter],
  ),
  BlockDefinition(
    type: BlockType.hookBefore, category: BlockCategory.hook,
    labelKey: 'blockHookBefore', color: _cHook,
    icon: Icons.arrow_back_rounded,
    paramDefs: [_pClassName, _pMethodName, _pParamTypes],
    slotDefs: [_sBody],
  ),
  BlockDefinition(
    type: BlockType.hookAfter, category: BlockCategory.hook,
    labelKey: 'blockHookAfter', color: _cHook,
    icon: Icons.arrow_forward_rounded,
    paramDefs: [_pClassName, _pMethodName, _pParamTypes],
    slotDefs: [_sBody],
  ),
  BlockDefinition(
    type: BlockType.hookReplace, category: BlockCategory.hook,
    labelKey: 'blockHookReplace', color: _cHook,
    icon: Icons.swap_horiz_rounded,
    paramDefs: [_pClassName, _pMethodName, _pParamTypes],
    slotDefs: [_sBody],
  ),
  BlockDefinition(
    type: BlockType.hookConstructor, category: BlockCategory.hook,
    labelKey: 'blockHookConstructor', color: _cConstructor,
    icon: Icons.construction_rounded,
    paramDefs: [_pClassName, _pParamTypes],
    slotDefs: [_sBefore, _sAfter],
  ),
  BlockDefinition(
    type: BlockType.beforeConstructor, category: BlockCategory.hook,
    labelKey: 'blockBeforeConstructor', color: _cConstructor,
    icon: Icons.arrow_back_rounded,
    paramDefs: [_pClassName, _pParamTypes],
    slotDefs: [_sBody],
  ),
  BlockDefinition(
    type: BlockType.afterConstructor, category: BlockCategory.hook,
    labelKey: 'blockAfterConstructor', color: _cConstructor,
    icon: Icons.arrow_forward_rounded,
    paramDefs: [_pClassName, _pParamTypes],
    slotDefs: [_sBody],
  ),
  BlockDefinition(
    type: BlockType.returnConst, category: BlockCategory.hook,
    labelKey: 'blockReturnConst', color: _cReturn,
    icon: Icons.output_rounded,
    paramDefs: [
      _pClassName, _pMethodName, _pParamTypes,
      ParamDef(
        key: 'constType', labelKey: 'blockConstType',
        hintKey: 'blockConstTypeHint',
        inputType: ParamInputType.dropdown,
        dropdownOptions: ['bool', 'string', 'int', 'null'],
      ),
      ParamDef(
        key: 'constValue', labelKey: 'blockConstValue',
        hintKey: 'blockConstValueHint',
      ),
    ],
  ),
  BlockDefinition(
    type: BlockType.hookAllMethods, category: BlockCategory.hook,
    labelKey: 'blockHookAllMethods', color: _cHook,
    icon: Icons.functions_rounded,
    paramDefs: [_pClassName, _pMethodName],
    slotDefs: [_sBefore, _sAfter],
  ),
  BlockDefinition(
    type: BlockType.hookAllConstructors, category: BlockCategory.hook,
    labelKey: 'blockHookAllConstructors', color: _cConstructor,
    icon: Icons.construction_rounded,
    paramDefs: [_pClassName],
    slotDefs: [_sBefore, _sAfter],
  ),
  BlockDefinition(
    type: BlockType.unhook, category: BlockCategory.hook,
    labelKey: 'blockUnhook', color: _cHook,
    icon: Icons.link_off_rounded,
    paramDefs: [_pVarName],
  ),
];

// ── 字段类积木 ──
const _fieldDefs = [
  BlockDefinition(
    type: BlockType.getField, category: BlockCategory.fields,
    labelKey: 'blockGetField', color: _cField,
    icon: Icons.download_rounded,
    paramDefs: [_pClassName, _pFieldName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.setField, category: BlockCategory.fields,
    labelKey: 'blockSetField', color: _cField,
    icon: Icons.upload_rounded,
    paramDefs: [_pClassName, _pFieldName, _pValue],
  ),
  BlockDefinition(
    type: BlockType.getInt, category: BlockCategory.fields,
    labelKey: 'blockGetInt', color: _cField,
    icon: Icons.pin_rounded,
    paramDefs: [_pFieldName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.setInt, category: BlockCategory.fields,
    labelKey: 'blockSetInt', color: _cField,
    icon: Icons.pin_rounded,
    paramDefs: [_pFieldName, _pValue],
  ),
  BlockDefinition(
    type: BlockType.getBool, category: BlockCategory.fields,
    labelKey: 'blockGetBool', color: _cField,
    icon: Icons.toggle_on_rounded,
    paramDefs: [_pFieldName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.setBool, category: BlockCategory.fields,
    labelKey: 'blockSetBool', color: _cField,
    icon: Icons.toggle_on_rounded,
    paramDefs: [_pFieldName, _pValue],
  ),
  BlockDefinition(
    type: BlockType.getClassName, category: BlockCategory.fields,
    labelKey: 'blockGetClassName', color: _cField,
    icon: Icons.class_rounded,
    paramDefs: [_pVarName],
  ),
  BlockDefinition(
    type: BlockType.getLong, category: BlockCategory.fields,
    labelKey: 'blockGetLong', color: _cField,
    icon: Icons.pin_rounded,
    paramDefs: [_pFieldName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.setLong, category: BlockCategory.fields,
    labelKey: 'blockSetLong', color: _cField,
    icon: Icons.pin_rounded,
    paramDefs: [_pFieldName, _pValue],
  ),
  BlockDefinition(
    type: BlockType.getFloat, category: BlockCategory.fields,
    labelKey: 'blockGetFloat', color: _cField,
    icon: Icons.pin_rounded,
    paramDefs: [_pFieldName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.setFloat, category: BlockCategory.fields,
    labelKey: 'blockSetFloat', color: _cField,
    icon: Icons.pin_rounded,
    paramDefs: [_pFieldName, _pValue],
  ),
  BlockDefinition(
    type: BlockType.getDouble, category: BlockCategory.fields,
    labelKey: 'blockGetDouble', color: _cField,
    icon: Icons.pin_rounded,
    paramDefs: [_pFieldName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.setDouble, category: BlockCategory.fields,
    labelKey: 'blockSetDouble', color: _cField,
    icon: Icons.pin_rounded,
    paramDefs: [_pFieldName, _pValue],
  ),
];// ── 日志类积木 ──
const _logDefs = [
  BlockDefinition(
    type: BlockType.log, category: BlockCategory.logging,
    labelKey: 'blockLog', color: _cLog,
    icon: Icons.text_snippet_rounded,
    paramDefs: [_pMessage],
  ),
  BlockDefinition(
    type: BlockType.logException, category: BlockCategory.logging,
    labelKey: 'blockLogException', color: _cLog,
    icon: Icons.error_outline_rounded,
    paramDefs: [_pMessage],
  ),
  BlockDefinition(
    type: BlockType.consoleLog, category: BlockCategory.logging,
    labelKey: 'blockConsoleLog', color: _cLog,
    icon: Icons.terminal_rounded,
    paramDefs: [_pMessage],
  ),
  BlockDefinition(
    type: BlockType.consoleWarn, category: BlockCategory.logging,
    labelKey: 'blockConsoleWarn', color: _cLog,
    icon: Icons.warning_amber_rounded,
    paramDefs: [_pMessage],
  ),
  BlockDefinition(
    type: BlockType.consoleError, category: BlockCategory.logging,
    labelKey: 'blockConsoleError', color: _cLog,
    icon: Icons.dangerous_rounded,
    paramDefs: [_pMessage],
  ),
  BlockDefinition(
    type: BlockType.stackTrace, category: BlockCategory.logging,
    labelKey: 'blockStackTrace', color: _cLog,
    icon: Icons.layers_rounded,
    paramDefs: [
      ParamDef(key: 'tag', labelKey: 'blockTag', hintKey: 'blockTagHint'),
    ],
  ),
];

// ── 参数类积木 ──
const _paramDefs = [
  BlockDefinition(
    type: BlockType.getArg, category: BlockCategory.params,
    labelKey: 'blockGetArg', color: _cParam,
    icon: Icons.input_rounded,
    paramDefs: [_pIndex, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.setArg, category: BlockCategory.params,
    labelKey: 'blockSetArg', color: _cParam,
    icon: Icons.edit_rounded,
    paramDefs: [_pIndex, _pValue],
  ),
  BlockDefinition(
    type: BlockType.getResult, category: BlockCategory.params,
    labelKey: 'blockGetResult', color: _cParam,
    icon: Icons.output_rounded,
    paramDefs: [_pVarName],
  ),
  BlockDefinition(
    type: BlockType.setResult, category: BlockCategory.params,
    labelKey: 'blockSetResult', color: _cParam,
    icon: Icons.published_with_changes_rounded,
    paramDefs: [_pValue],
  ),
  BlockDefinition(
    type: BlockType.getThrowable, category: BlockCategory.params,
    labelKey: 'blockGetThrowable', color: _cParam,
    icon: Icons.error_outline_rounded,
    paramDefs: [_pVarName],
  ),
  BlockDefinition(
    type: BlockType.setThrowable, category: BlockCategory.params,
    labelKey: 'blockSetThrowable', color: _cParam,
    icon: Icons.error_rounded,
    paramDefs: [_pMessage],
  ),
];

// ── 调用类积木 ──
const _callDefs = [
  BlockDefinition(
    type: BlockType.callMethod, category: BlockCategory.calls,
    labelKey: 'blockCallMethod', color: _cCall,
    icon: Icons.play_arrow_rounded,
    paramDefs: [_pMethodName, _pVarName,
      _pArgs,
    ],
  ),
  BlockDefinition(
    type: BlockType.callMethodTyped, category: BlockCategory.calls,
    labelKey: 'blockCallMethodTyped', color: _cCall,
    icon: Icons.play_arrow_rounded,
    paramDefs: [_pMethodName, _pParamTypes,
      _pArgs,
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.callStatic, category: BlockCategory.calls,
    labelKey: 'blockCallStatic', color: _cCall,
    icon: Icons.play_circle_rounded,
    paramDefs: [_pClassName, _pMethodName, _pParamTypes,
      _pArgs,
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.callStaticAuto, category: BlockCategory.calls,
    labelKey: 'blockCallStaticAuto', color: _cCall,
    icon: Icons.play_circle_outline_rounded,
    paramDefs: [_pClassName, _pMethodName,
      _pArgs,
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.newInstance, category: BlockCategory.calls,
    labelKey: 'blockNewInstance', color: _cCall,
    icon: Icons.add_box_rounded,
    paramDefs: [_pClassName,
      _pArgs,
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.newInstanceTyped, category: BlockCategory.calls,
    labelKey: 'blockNewInstanceTyped', color: _cCall,
    icon: Icons.add_box_outlined,
    paramDefs: [_pClassName, _pParamTypes,
      _pArgs,
      _pVarName,
    ],
  ),
];

// ── 流程控制积木 ──
const _flowDefs = [
  BlockDefinition(
    type: BlockType.ifBlock, category: BlockCategory.flow,
    labelKey: 'blockIf', color: _cFlow,
    icon: Icons.call_split_rounded,
    paramDefs: [
      ParamDef(key: 'condition', labelKey: 'blockCondition',
        hintKey: 'blockConditionHint', showVarPicker: true),
    ],
    slotDefs: [_sThen, _sElse],
  ),
  BlockDefinition(
    type: BlockType.forLoop, category: BlockCategory.flow,
    labelKey: 'blockForLoop', color: _cFlow,
    icon: Icons.loop_rounded,
    paramDefs: [
      _pVarName,
      ParamDef(key: 'from', labelKey: 'blockFrom',
        hintKey: 'blockFromHint', inputType: ParamInputType.number,
        showVarPicker: true),
      ParamDef(key: 'to', labelKey: 'blockTo',
        hintKey: 'blockToHint', inputType: ParamInputType.number,
        showVarPicker: true),
    ],
    slotDefs: [_sBody],
  ),
  BlockDefinition(
    type: BlockType.varAssign, category: BlockCategory.flow,
    labelKey: 'blockVarAssign', color: _cFlow,
    icon: Icons.data_object_rounded,
    paramDefs: [_pVarName, _pValue],
  ),
  BlockDefinition(
    type: BlockType.customCode, category: BlockCategory.flow,
    labelKey: 'blockCustomCode', color: _cCustom,
    icon: Icons.code_rounded,
    paramDefs: [
      ParamDef(key: 'code', labelKey: 'blockCustomJs',
        hintKey: 'blockCustomJsHint',
        inputType: ParamInputType.multiline, showVarPicker: true),
    ],
  ),
];

// ── 扩展工具积木 ──
const _extDefs = [
  BlockDefinition(
    type: BlockType.toast, category: BlockCategory.extensions,
    labelKey: 'blockToast', color: _cExt,
    icon: Icons.chat_bubble_rounded,
    paramDefs: [_pMessage],
  ),
  BlockDefinition(
    type: BlockType.getApplication, category: BlockCategory.extensions,
    labelKey: 'blockGetApplication', color: _cExt,
    icon: Icons.apps_rounded,
    paramDefs: [_pVarName],
  ),
  BlockDefinition(
    type: BlockType.getPackageName, category: BlockCategory.extensions,
    labelKey: 'blockGetPackageName', color: _cExt,
    icon: Icons.inventory_2_rounded,
    paramDefs: [_pVarName],
  ),
  BlockDefinition(
    type: BlockType.getSharedPrefs, category: BlockCategory.extensions,
    labelKey: 'blockGetSharedPrefs', color: _cExt,
    icon: Icons.storage_rounded,
    paramDefs: [
      ParamDef(key: 'name', labelKey: 'blockPrefsName',
        hintKey: 'blockPrefsNameHint'),
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.getPrefString, category: BlockCategory.extensions,
    labelKey: 'blockGetPrefString', color: _cExt,
    icon: Icons.text_fields_rounded,
    paramDefs: [
      ParamDef(key: 'key', labelKey: 'blockPrefKey',
        hintKey: 'blockPrefKeyHint'),
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.getPrefInt, category: BlockCategory.extensions,
    labelKey: 'blockGetPrefInt', color: _cExt,
    icon: Icons.pin_rounded,
    paramDefs: [
      ParamDef(key: 'key', labelKey: 'blockPrefKey',
        hintKey: 'blockPrefKeyHint'),
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.getPrefBool, category: BlockCategory.extensions,
    labelKey: 'blockGetPrefBool', color: _cExt,
    icon: Icons.toggle_on_rounded,
    paramDefs: [
      ParamDef(key: 'key', labelKey: 'blockPrefKey',
        hintKey: 'blockPrefKeyHint'),
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.getBuild, category: BlockCategory.extensions,
    labelKey: 'blockGetBuild', color: _cExt,
    icon: Icons.phone_android_rounded,
    paramDefs: [_pFieldName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.startActivity, category: BlockCategory.extensions,
    labelKey: 'blockStartActivity', color: _cExt,
    icon: Icons.launch_rounded,
    paramDefs: [_pClassName],
  ),
  BlockDefinition(
    type: BlockType.findClass, category: BlockCategory.extensions,
    labelKey: 'blockFindClass', color: _cExt,
    icon: Icons.search_rounded,
    paramDefs: [_pClassName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.loadClass, category: BlockCategory.extensions,
    labelKey: 'blockLoadClass', color: _cExt,
    icon: Icons.download_rounded,
    paramDefs: [_pClassName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.getSystemProp, category: BlockCategory.extensions,
    labelKey: 'blockGetSystemProp', color: _cExt,
    icon: Icons.settings_rounded,
    paramDefs: [
      ParamDef(key: 'key', labelKey: 'blockPrefKey',
        hintKey: 'blockPrefKeyHint'),
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.getMethods, category: BlockCategory.extensions,
    labelKey: 'blockGetMethods', color: _cExt,
    icon: Icons.list_rounded,
    paramDefs: [_pClassName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.getFields, category: BlockCategory.extensions,
    labelKey: 'blockGetFields', color: _cExt,
    icon: Icons.list_alt_rounded,
    paramDefs: [_pClassName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.instanceOf, category: BlockCategory.extensions,
    labelKey: 'blockInstanceOf', color: _cExt,
    icon: Icons.check_circle_rounded,
    paramDefs: [_pValue, _pClassName, _pVarName],
  ),
  BlockDefinition(
    type: BlockType.setExtra, category: BlockCategory.extensions,
    labelKey: 'blockSetExtra', color: _cExt,
    icon: Icons.add_circle_rounded,
    paramDefs: [_pValue,
      ParamDef(key: 'key', labelKey: 'blockPrefKey',
        hintKey: 'blockPrefKeyHint'),
      _pVarName,
    ],
  ),
  BlockDefinition(
    type: BlockType.getExtra, category: BlockCategory.extensions,
    labelKey: 'blockGetExtra', color: _cExt,
    icon: Icons.remove_circle_rounded,
    paramDefs: [_pValue,
      ParamDef(key: 'key', labelKey: 'blockPrefKey',
        hintKey: 'blockPrefKeyHint'),
      _pVarName,
    ],
  ),
];

// ── 合并所有定义 ──
const _allDefs = [
  ..._hookDefs,
  ..._logDefs,
  ..._fieldDefs,
  ..._paramDefs,
  ..._callDefs,
  ..._flowDefs,
  ..._extDefs,
];
