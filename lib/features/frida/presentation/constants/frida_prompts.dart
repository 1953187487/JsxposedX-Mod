import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/javascript.dart';

// ============================================================
// 分类 A — Fx. 核心方法 (relatedPrompts["Fx"])
// ============================================================

/// 语法糖入口
const _fxSugarPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'use', type: 'ClassProxy', parameters: {'className': 'String'}),
  CodeFunctionPrompt(word: 'wrap', type: 'InstanceProxy', parameters: {'obj': 'Object'}),
  CodeFieldPrompt(word: 'ext', type: 'ExtTools'),
  CodeFunctionPrompt(word: 'hookNative', type: 'InvocationListener', parameters: {'moduleName': 'String', 'exportName': 'String', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'choose', type: 'void', parameters: {'className': 'String', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'cast', type: 'Wrapper', parameters: {'obj': 'Object', 'className': 'String'}),
  CodeFunctionPrompt(word: 'enumerateClasses', type: 'void', parameters: {'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'enumerateClassLoaders', type: 'void', parameters: {'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'scheduleOnMainThread', type: 'void', parameters: {'fn': 'Function'}),
  CodeFunctionPrompt(word: 'findExport', type: 'NativePointer', parameters: {'exportName': 'String'}, optionalParameters: {'moduleName': 'String'}),
  CodeFunctionPrompt(word: 'findBase', type: 'NativePointer', parameters: {'moduleName': 'String'}),
  CodeFunctionPrompt(word: 'enumerateExports', type: 'Array', parameters: {'moduleName': 'String'}),
  CodeFunctionPrompt(word: 'enumerateImports', type: 'Array', parameters: {'moduleName': 'String'}),
  CodeFunctionPrompt(word: 'attach', type: 'InvocationListener', parameters: {'target': 'NativePointer', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'replace', type: 'void', parameters: {'target': 'NativePointer', 'replacement': 'NativeCallback'}),
  CodeFunctionPrompt(word: 'readUtf8', type: 'String', parameters: {'address': 'NativePointer'}, optionalParameters: {'length': 'int'}),
  CodeFunctionPrompt(word: 'writeUtf8', type: 'void', parameters: {'address': 'NativePointer', 'str': 'String'}),
  CodeFunctionPrompt(word: 'readBytes', type: 'ArrayBuffer', parameters: {'address': 'NativePointer', 'length': 'int'}),
  CodeFunctionPrompt(word: 'writeBytes', type: 'void', parameters: {'address': 'NativePointer', 'bytes': 'ArrayBuffer'}),
  CodeFunctionPrompt(word: 'alloc', type: 'NativePointer', parameters: {'size': 'int'}),
  CodeFunctionPrompt(word: 'scan', type: 'void', parameters: {'address': 'NativePointer', 'size': 'int', 'pattern': 'String', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'enumerateModules', type: 'Array', parameters: {}),
  CodeFunctionPrompt(word: 'enumerateThreads', type: 'Array', parameters: {}),
  CodeFunctionPrompt(word: 'getCurrentThreadId', type: 'int', parameters: {}),
  CodeFunctionPrompt(word: 'log', type: 'void', parameters: {'message': 'any'}),
  CodeFunctionPrompt(word: 'logError', type: 'void', parameters: {'message': 'any'}),
];

// ============================================================
// 分类 B — Fx.ext. 扩展工具 (relatedPrompts["ext"])
// ============================================================

const _extPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'toJava', type: 'Object', parameters: {'value': 'any'}),
  CodeFunctionPrompt(word: 'toast', type: 'void', parameters: {'text': 'String'}, optionalParameters: {'duration': 'int'}),
  CodeFunctionPrompt(word: 'getApplication', type: 'Application', parameters: {}),
  CodeFunctionPrompt(word: 'getPackageName', type: 'String', parameters: {}),
  CodeFunctionPrompt(word: 'getSharedPrefs', type: 'SharedPreferences', parameters: {'name': 'String'}, optionalParameters: {'mode': 'int'}),
  CodeFunctionPrompt(word: 'getPrefString', type: 'String', parameters: {'prefs': 'SharedPreferences', 'key': 'String'}, optionalParameters: {'def': 'String'}),
  CodeFunctionPrompt(word: 'getPrefInt', type: 'int', parameters: {'prefs': 'SharedPreferences', 'key': 'String'}, optionalParameters: {'def': 'int'}),
  CodeFunctionPrompt(word: 'getPrefBool', type: 'boolean', parameters: {'prefs': 'SharedPreferences', 'key': 'String'}, optionalParameters: {'def': 'boolean'}),
  CodeFunctionPrompt(word: 'getSystemProp', type: 'String', parameters: {'key': 'String'}),
  CodeFunctionPrompt(word: 'getBuild', type: 'String', parameters: {'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'startActivity', type: 'void', parameters: {'className': 'String'}),
  CodeFunctionPrompt(word: 'stackTrace', type: 'void', optionalParameters: {'tag': 'String'}),
];

// ============================================================
// 分类 C — Java. 原生 API (relatedPrompts["Java"])
// ============================================================

const _javaPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'perform', type: 'void', parameters: {'fn': 'Function'}),
  CodeFunctionPrompt(word: 'use', type: 'Wrapper', parameters: {'className': 'String'}),
  CodeFunctionPrompt(word: 'choose', type: 'void', parameters: {'className': 'String', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'cast', type: 'Wrapper', parameters: {'handle': 'Object', 'klass': 'Wrapper'}),
  CodeFieldPrompt(word: 'available', type: 'boolean'),
  CodeFunctionPrompt(word: 'enumerateLoadedClasses', type: 'void', parameters: {'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'enumerateClassLoaders', type: 'void', parameters: {'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'scheduleOnMainThread', type: 'void', parameters: {'fn': 'Function'}),
];

// ============================================================
// 分类 D — Interceptor. 原生 API (relatedPrompts["Interceptor"])
// ============================================================

const _interceptorPrompts = <CodePrompt>[
  CodeFunctionPrompt(
    word: 'attach',
    type: 'InvocationListener',
    parameters: {'target': 'NativePointer', 'callbacks': 'Object'},
  ),
  CodeFunctionPrompt(
    word: 'replace',
    type: 'void',
    parameters: {'target': 'NativePointer', 'replacement': 'NativeCallback'},
  ),
  CodeFunctionPrompt(word: 'detachAll', type: 'void', parameters: {}),
  CodeFunctionPrompt(word: 'flush', type: 'void', parameters: {}),
  CodeFunctionPrompt(word: 'revert', type: 'void', parameters: {'target': 'NativePointer'}),
];

// ============================================================
// 分类 E — Module. 原生 API (relatedPrompts["Module"])
// ============================================================

const _modulePrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'findExportByName', type: 'NativePointer', parameters: {'moduleName': 'String?', 'exportName': 'String'}),
  CodeFunctionPrompt(word: 'findBaseAddress', type: 'NativePointer', parameters: {'name': 'String'}),
  CodeFunctionPrompt(word: 'enumerateExports', type: 'Array', parameters: {'name': 'String'}),
  CodeFunctionPrompt(word: 'enumerateImports', type: 'Array', parameters: {'name': 'String'}),
  CodeFunctionPrompt(word: 'load', type: 'Module', parameters: {'path': 'String'}),
];

// ============================================================
// 分类 F — console. 方法 (relatedPrompts["console"])
// ============================================================

const _consolePrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'log', type: 'void', parameters: {'message': 'any'}),
  CodeFunctionPrompt(word: 'warn', type: 'void', parameters: {'message': 'any'}),
  CodeFunctionPrompt(word: 'error', type: 'void', parameters: {'message': 'any'}),
];

// ============================================================
// 分类 G — Memory. 原生 API (relatedPrompts["Memory"])
// ============================================================

const _memoryPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'alloc', type: 'NativePointer', parameters: {'size': 'int'}),
  CodeFunctionPrompt(word: 'allocUtf8String', type: 'NativePointer', parameters: {'str': 'String'}),
  CodeFunctionPrompt(word: 'readPointer', type: 'NativePointer', parameters: {'address': 'NativePointer'}),
  CodeFunctionPrompt(word: 'writePointer', type: 'void', parameters: {'address': 'NativePointer', 'value': 'NativePointer'}),
  CodeFunctionPrompt(word: 'readUtf8String', type: 'String', parameters: {'address': 'NativePointer'}),
  CodeFunctionPrompt(word: 'writeUtf8String', type: 'void', parameters: {'address': 'NativePointer', 'str': 'String'}),
  CodeFunctionPrompt(word: 'readByteArray', type: 'ArrayBuffer', parameters: {'address': 'NativePointer', 'length': 'int'}),
  CodeFunctionPrompt(word: 'writeByteArray', type: 'void', parameters: {'address': 'NativePointer', 'bytes': 'ArrayBuffer'}),
  CodeFunctionPrompt(word: 'scan', type: 'void', parameters: {'address': 'NativePointer', 'size': 'int', 'pattern': 'String', 'callbacks': 'Object'}),
];

// ============================================================
// 分类 H — Process. 原生 API (relatedPrompts["Process"])
// ============================================================

const _processPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'enumerateModules', type: 'Array', parameters: {}),
  CodeFunctionPrompt(word: 'enumerateThreads', type: 'Array', parameters: {}),
  CodeFunctionPrompt(word: 'getCurrentThreadId', type: 'int', parameters: {}),
  CodeFunctionPrompt(word: 'findModuleByName', type: 'Module', parameters: {'name': 'String'}),
  CodeFieldPrompt(word: 'arch', type: 'String'),
  CodeFieldPrompt(word: 'platform', type: 'String'),
  CodeFieldPrompt(word: 'pageSize', type: 'int'),
  CodeFieldPrompt(word: 'pointerSize', type: 'int'),
];

// ============================================================
// 分类 I — Fx.use() 返回的 ClassProxy (relatedPrompts["cls"])
// ============================================================

const _classProxyPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'call', type: 'Object', parameters: {'methodName': 'String', '...args': 'any'}),
  CodeFunctionPrompt(word: 'getField', type: 'Object', parameters: {'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setField', type: 'void', parameters: {'fieldName': 'String', 'value': 'any'}),
  CodeFunctionPrompt(word: 'newInstance', type: 'Object', parameters: {'...args': 'any'}),
  CodeFunctionPrompt(word: 'hook', type: 'void', parameters: {'methodName': 'String', 'overloadTypes': 'Array?', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'before', type: 'void', parameters: {'methodName': 'String', 'overloadTypes': 'Array?', 'fn': 'Function'}),
  CodeFunctionPrompt(word: 'after', type: 'void', parameters: {'methodName': 'String', 'overloadTypes': 'Array?', 'fn': 'Function'}),
  CodeFunctionPrompt(word: 'replace', type: 'void', parameters: {'methodName': 'String', 'overloadTypes': 'Array?', 'fn': 'Function'}),
  CodeFunctionPrompt(word: 'returnConst', type: 'void', parameters: {'methodName': 'String', 'overloadTypes': 'Array?', 'value': 'any'}),
  CodeFunctionPrompt(word: 'hookConstructor', type: 'void', parameters: {'overloadTypes': 'Array?', 'callbacks': 'Object'}),
  CodeFunctionPrompt(word: 'hookAll', type: 'void', parameters: {'methodName': 'String', 'callbacks': 'Object'}),
];

// ============================================================
// 分类 H — Fx.wrap() 返回的 InstanceProxy (relatedPrompts["w"])
// ============================================================

const _instanceProxyPrompts = <CodePrompt>[
  CodeFunctionPrompt(word: 'call', type: 'Object', parameters: {'methodName': 'String', '...args': 'any'}),
  CodeFunctionPrompt(word: 'getField', type: 'Object', parameters: {'fieldName': 'String'}),
  CodeFunctionPrompt(word: 'setField', type: 'void', parameters: {'fieldName': 'String', 'value': 'any'}),
  CodeFunctionPrompt(word: 'getClassName', type: 'String', parameters: {}),
  CodeFunctionPrompt(word: 'cast', type: 'InstanceProxy', parameters: {'className': 'String'}),
];

// ============================================================
// 分类 I — directPrompts 顶级入口
// ============================================================

const _directPrompts = <CodePrompt>[
  CodeFieldPrompt(word: 'Fx', type: 'FridaSugar'),
  CodeFieldPrompt(word: 'Java', type: 'JavaAPI'),
  CodeFieldPrompt(word: 'Interceptor', type: 'InterceptorAPI'),
  CodeFieldPrompt(word: 'Module', type: 'ModuleAPI'),
  CodeFieldPrompt(word: 'Memory', type: 'MemoryAPI'),
  CodeFieldPrompt(word: 'Process', type: 'ProcessAPI'),
  CodeFieldPrompt(word: 'console', type: 'Console'),
];

// ============================================================
// 组装入口
// ============================================================

/// 构建 Frida 专用的代码补全 PromptsBuilder。
///
/// 支持：
/// - 输入 `Fx.` 触发语法糖 API 提示
/// - 输入 `Fx.ext.` 触发扩展工具提示
/// - 输入 `Java.` 触发 Frida Java API 提示
/// - 输入 `Interceptor.` 触发 Native Hook 提示
/// - 输入 `Module.` 触发模块操作提示
/// - 输入 `Memory.` 触发内存操作提示
/// - 输入 `Process.` 触发进程操作提示
/// - 输入 `console.` 触发日志方法提示
/// - 输入 `cls.` 触发 Fx.use() 返回对象方法提示
/// - 输入 `w.` 触发 Fx.wrap() 返回对象方法提示
DefaultCodeAutocompletePromptsBuilder buildFridaPromptsBuilder() {
  return DefaultCodeAutocompletePromptsBuilder(
    language: langJavascript,
    directPrompts: _directPrompts,
    relatedPrompts: {
      'Fx': _fxSugarPrompts,
      'ext': _extPrompts,
      'Java': _javaPrompts,
      'Interceptor': _interceptorPrompts,
      'Module': _modulePrompts,
      'Memory': _memoryPrompts,
      'Process': _processPrompts,
      'console': _consolePrompts,
      'cls': _classProxyPrompts,
      'w': _instanceProxyPrompts,
    },
  );
}

