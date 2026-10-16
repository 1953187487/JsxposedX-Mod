import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/javascript.dart';

// ============================================================
// 分类 A — Jx. 核心方法 (relatedPrompts["Jx"])
// ============================================================

/// 日志相关
const _jxLogPrompts = [
  CodeFunctionPrompt(word: 'log', type: 'void', parameters: {'message': 'String'}),
  CodeFunctionPrompt(word: 'logException', type: 'void', parameters: {'message': 'String'}),
];

/// 类操作
const _jxClassPrompts = [
  CodeFunctionPrompt(word: 'findClass', type: 'boolean', parameters: {'className': 'String'}),
  CodeFunctionPrompt(
    word: 'newInstance',
    type: 'Object',
    parameters: {'className': 'String', 'paramTypes': 'Array', 'paramValues': 'Array'},
  ),
];

/// 方法调用
const _jxMethodPrompts = [
  CodeFunctionPrompt(
    word: 'callMethod',
    type: 'Object',
    parameters: {'obj': 'Object', 'methodName': 'String', 'paramTypes': 'Array', 'paramValues': 'Array'},
  ),
  CodeFunctionPrompt(
    word: 'callStaticMethod',
    type: 'Object',
    parameters: {'className': 'String', 'methodName': 'String', 'paramTypes': 'Array', 'paramValues': 'Array'},
  ),
];

/// 字段读写 — 实例
const _jxFieldPrompts = [
  CodeFunctionPrompt(word: 'getObjectField', type: 'Object', parameters: {'obj': 'Object', 'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setObjectField', type: 'void', parameters: {'obj': 'Object', 'fieldName': 'String', 'value': 'Object'}),
  CodeFunctionPrompt(word: 'getIntField', type: 'int', parameters: {'obj': 'Object', 'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setIntField', type: 'void', parameters: {'obj': 'Object', 'fieldName': 'String', 'value': 'int'}),
  CodeFunctionPrompt(word: 'getBooleanField', type: 'boolean', parameters: {'obj': 'Object', 'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setBooleanField', type: 'void', parameters: {'obj': 'Object', 'fieldName': 'String', 'value': 'boolean'}),
];

/// 字段读写 — 静态
const _jxStaticFieldPrompts = [
  CodeFunctionPrompt(word: 'getStaticObjectField', type: 'Object', parameters: {'className': 'String', 'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setStaticObjectField', type: 'void', parameters: {'className': 'String', 'fieldName': 'String', 'value': 'Object'}),
];

/// Hook
const _jxHookPrompts = [
  CodeFunctionPrompt(
    word: 'hookMethod',
    type: 'void',
    parameters: {'className': 'String', 'methodName': 'String', 'paramTypes': 'Array', 'callbacks': 'Object'},
  ),
  CodeFunctionPrompt(
    word: 'hookConstructor',
    type: 'void',
    parameters: {'className': 'String', 'paramTypes': 'Array', 'callbacks': 'Object'},
  ),
];

/// 语法糖入口
const _jxSugarPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'use', type: 'ClassProxy', parameters: {'className': 'String'}),
  CodeFunctionPrompt(word: 'wrap', type: 'InstanceProxy', parameters: {'obj': 'Object'}),
  CodeFieldPrompt(word: 'ext', type: 'ExtTools'),
];

// ============================================================
// 分类 B — Jx.ext. 扩展工具 (relatedPrompts["ext"])
// ============================================================

const _extPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'toast', type: 'void', parameters: {'context': 'Context', 'text': 'String'}, optionalParameters: {'duration': 'int'}),
  CodeFunctionPrompt(word: 'getApplication', type: 'Application', parameters: {}),
  CodeFunctionPrompt(word: 'getPackageName', type: 'String', parameters: {'context': 'Context'}),
  CodeFunctionPrompt(word: 'getSharedPrefs', type: 'SharedPreferences', parameters: {'context': 'Context', 'name': 'String'}, optionalParameters: {'mode': 'int'}),
  CodeFunctionPrompt(word: 'getPrefString', type: 'String', parameters: {'prefs': 'SharedPreferences', 'key': 'String'}, optionalParameters: {'defaultValue': 'String'}),
  CodeFunctionPrompt(word: 'getPrefInt', type: 'int', parameters: {'prefs': 'SharedPreferences', 'key': 'String'}, optionalParameters: {'defaultValue': 'int'}),
  CodeFunctionPrompt(word: 'getPrefBool', type: 'boolean', parameters: {'prefs': 'SharedPreferences', 'key': 'String'}, optionalParameters: {'defaultValue': 'boolean'}),
  CodeFunctionPrompt(word: 'getSystemProp', type: 'String', parameters: {'key': 'String'}),
  CodeFunctionPrompt(word: 'getBuild', type: 'String', parameters: {'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'startActivity', type: 'void', parameters: {'context': 'Context', 'className': 'String'}),
  CodeFunctionPrompt(word: 'stackTrace', type: 'void', optionalParameters: {'tag': 'String'}),
];

// ============================================================
// 分类 C — console. 方法 (relatedPrompts["console"])
// ============================================================

const _consolePrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'log', type: 'void', parameters: {'message': 'any'}),
  CodeFunctionPrompt(word: 'info', type: 'void', parameters: {'message': 'any'}),
  CodeFunctionPrompt(word: 'warn', type: 'void', parameters: {'message': 'any'}),
  CodeFunctionPrompt(word: 'error', type: 'void', parameters: {'message': 'any'}),
];

// ============================================================
// 分类 D — param. Hook 回调对象 (relatedPrompts["param"])
// ============================================================

const _paramPrompts = <CodePrompt>[
  CodeFieldPrompt(word: 'thisObject', type: 'Object'),
  CodeFieldPrompt(word: 'raw', type: 'MethodHookParam'),
  CodeFieldPrompt(word: 'argsLength', type: 'int'),
  CodeFunctionPrompt(word: 'getArg', type: 'Object', parameters: {'index': 'int'}),
  CodeFunctionPrompt(word: 'setArg', type: 'void', parameters: {'index': 'int', 'value': 'any'}),
  CodeFunctionPrompt(word: 'getResult', type: 'Object', parameters: {}),
  CodeFunctionPrompt(word: 'setResult', type: 'void', parameters: {'value': 'any'}),
];

// ============================================================
// 分类 E — directPrompts 顶级入口
// ============================================================

const _directPrompts = <CodePrompt>[
  CodeFieldPrompt(word: 'Jx', type: 'JsXposed'),
  CodeFieldPrompt(word: 'console', type: 'Console'),
  CodeFieldPrompt(word: 'param', type: 'HookParam'),
];

// ============================================================
// 分类 F — Jx.use() 返回的 ClassProxy 方法 (relatedPrompts["cls"])
// ============================================================

const _classProxyPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'call', type: 'Object', parameters: {'methodName': 'String', '...args': 'any'}),
  CodeFunctionPrompt(word: 'callTyped', type: 'Object', parameters: {'methodName': 'String', 'paramTypes': 'Array', 'paramValues': 'Array'}),
  CodeFunctionPrompt(word: 'getField', type: 'Object', parameters: {'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setField', type: 'void', parameters: {'fieldName': 'String', 'value': 'any'}),
  CodeFunctionPrompt(word: 'newInstance', type: 'Object', parameters: {'...args': 'any'}),
  CodeFunctionPrompt(word: 'newInstanceTyped', type: 'Object', parameters: {'paramTypes': 'Array', 'paramValues': 'Array'}),
  CodeFunctionPrompt(word: 'hook', type: 'void', parameters: {'methodName': 'String', 'paramTypes': 'Array', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'before', type: 'void', parameters: {'methodName': 'String', 'paramTypes': 'Array', 'callback': 'Function'}),
  CodeFunctionPrompt(word: 'after', type: 'void', parameters: {'methodName': 'String', 'paramTypes': 'Array', 'callback': 'Function'}),
  CodeFunctionPrompt(word: 'replace', type: 'void', parameters: {'methodName': 'String', 'paramTypes': 'Array', 'callback': 'Function'}),
  CodeFunctionPrompt(word: 'returnConst', type: 'void', parameters: {'methodName': 'String', 'paramTypes': 'Array', 'value': 'any'}),
  CodeFunctionPrompt(word: 'hookConstructor', type: 'void', parameters: {'paramTypes': 'Array', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'beforeConstructor', type: 'void', parameters: {'paramTypes': 'Array', 'callback': 'Function'}),
  CodeFunctionPrompt(word: 'afterConstructor', type: 'void', parameters: {'paramTypes': 'Array', 'callback': 'Function'}),
];

// ============================================================
// 分类 G — Jx.wrap() 返回的 InstanceProxy 方法 (relatedPrompts["w"])
// ============================================================

const _instanceProxyPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'call', type: 'Object', parameters: {'methodName': 'String', '...args': 'any'}),
  CodeFunctionPrompt(word: 'callTyped', type: 'Object', parameters: {'methodName': 'String', 'paramTypes': 'Array', 'paramValues': 'Array'}),
  CodeFunctionPrompt(word: 'getField', type: 'Object', parameters: {'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setField', type: 'void', parameters: {'fieldName': 'String', 'value': 'any'}),
  CodeFunctionPrompt(word: 'getInt', type: 'int', parameters: {'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setInt', type: 'void', parameters: {'fieldName': 'String', 'value': 'int'}),
  CodeFunctionPrompt(word: 'getBool', type: 'boolean', parameters: {'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setBool', type: 'void', parameters: {'fieldName': 'String', 'value': 'boolean'}),
  CodeFunctionPrompt(word: 'getClassName', type: 'String', parameters: {}),
];

// ============================================================
// 组装入口
// ============================================================

/// 构建 JsXposed 专用的代码补全 PromptsBuilder。
///
/// 支持：
/// - 输入 `Jx.` 触发核心 API 提示
/// - 输入 `Jx.ext.` 触发扩展工具提示
/// - 输入 `console.` 触发日志方法提示
/// - 输入 `param.` 触发 Hook 回调对象提示
/// - 输入 `cls.` 触发 Jx.use() 返回对象方法提示
/// - 输入 `w.` 触发 Jx.wrap() 返回对象方法提示
DefaultCodeAutocompletePromptsBuilder buildJsxposedPromptsBuilder() {
  // 合并 Jx. 下所有核心方法
  final jxPrompts = <CodePrompt>[
    ..._jxLogPrompts,
    ..._jxClassPrompts,
    ..._jxMethodPrompts,
    ..._jxFieldPrompts,
    ..._jxStaticFieldPrompts,
    ..._jxHookPrompts,
    ..._jxSugarPrompts,
  ];

  return DefaultCodeAutocompletePromptsBuilder(
    language: langJavascript,
    directPrompts: _directPrompts,
    relatedPrompts: {
      'Jx': jxPrompts,
      'ext': _extPrompts,
      'console': _consolePrompts,
      'param': _paramPrompts,
      'cls': _classProxyPrompts,
      'w': _instanceProxyPrompts,
    },
  );
}
