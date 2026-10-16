import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/features/ai/domain/repositories/script_log_repository.dart';
import 'package:JsxposedX/generated/pinia.g.dart';
import 'package:JsxposedX/generated/project.g.dart';

// ═══ Xposed Hook 模板常量（严格对齐 JsSugar.kt 的真实签名） ═══
//
// Jx 链式 API 的真实形态：
//   Jx.use(cls).hook(methodName, paramTypes, { before/after/replace: function(param) })
//   Jx.use(cls).before/after/replace(methodName, paramTypes, function(param))
//   Jx.use(cls).returnConst(methodName, paramTypes, value)
//   Jx.use(cls).hookConstructor(paramTypes, { before/after: function(param) })
// 回调只有一个参数 param（不是 self + 展开参数），param 上可用：
//   thisObject / getArg(i) / setArg(i, v) / getResult() / setResult(v)
//   / hasThrowable() / getThrowable() / setThrowable()

const _xposedHookBeforeAfter = r'''
(function () {
  try {
    Jx.use("{className}").hook("{methodName}", [{paramList}], {
      before: function(param) {
        try {
          Jx.log("[Hook] {methodName} argsLength=" + param.argsLength);
        } catch (e) {
          Jx.logException(e);
        }
      },
      after: function(param) {
        try {
          Jx.log("[Hook] {methodName} 返回: " + param.getResult());
        } catch (e) {
          Jx.logException(e);
        }
      }
    });
    Jx.log("[Init] {className}.{methodName} hook installed");
  } catch (e) {
    Jx.logException(e);
  }
})();
''';

const _xposedHookBefore = r'''
(function () {
  try {
    Jx.use("{className}").hook("{methodName}", [{paramList}], {
      before: function(param) {
        try {
          Jx.log("[Hook] {methodName} argsLength=" + param.argsLength);
        } catch (e) {
          Jx.logException(e);
        }
      }
    });
    Jx.log("[Init] {className}.{methodName} hook installed");
  } catch (e) {
    Jx.logException(e);
  }
})();
''';

const _xposedHookAfter = r'''
(function () {
  try {
    Jx.use("{className}").hook("{methodName}", [{paramList}], {
      after: function(param) {
        try {
          Jx.log("[Hook] {methodName} 返回: " + param.getResult());
        } catch (e) {
          Jx.logException(e);
        }
      }
    });
    Jx.log("[Init] {className}.{methodName} hook installed");
  } catch (e) {
    Jx.logException(e);
  }
})();
''';

const _xposedHookReplace = r'''
(function () {
  try {
    Jx.use("{className}").hook("{methodName}", [{paramList}], {
      before: function(param) {
        try {
          Jx.log("[Hook] {methodName} 已拦截");
          param.setResult(null);
        } catch (e) {
          Jx.logException(e);
        }
      }
    });
    Jx.log("[Init] {className}.{methodName} hook installed");
  } catch (e) {
    Jx.logException(e);
  }
})();
''';

const _xposedMethodEnumTemplate = r'''
// {className} 的方法列表：
// {methodList}
//
// 以下为每个方法生成的 Hook 骨架：
{methodSkeletons}
''';

const _xposedMethodSkeleton = r'''
// --- {methodName}({paramTypes}) ---
Jx.use("{className}").hook("{methodName}", [{paramListStr}], {
  before: function(param) {
    try {
      Jx.log("[Hook] {className}.{methodName} argsLength=" + param.argsLength);
    } catch (e) {
      Jx.logException(e);
    }
  }
});
''';

// ═══ Frida Hook 模板常量（严格对齐 FridaSugar.kt 的真实签名） ═══
//
// Fx 链式 API 的真实形态：
//   Fx.use(cls).hook(methodName, overloadTypes, { before/after/replace: fn })
//   Fx.use(cls).before/after/replace(methodName, overloadTypes, fn)
//   Fx.use(cls).returnConst(methodName, overloadTypes, value)
//   Fx.use(cls).hookConstructor(overloadTypes, { before/after: fn })
//   Fx.use(cls).hookAll(methodName, callbacks)
// 注意：Fx.use() 返回的是普通 JS 对象，**不存在** ".方法名.overload(...)" 这种
// 原生 Java.use 写法，overload 类型只通过第 2 个参数传入。
// 回调签名：before/replace(args, thisObj)、after(retval, args, thisObj)。

const _fridaJavaMethod = r'''
// Fx 糖 Java 方法 Hook
try {
  Fx.use("{className}").hook("{methodName}", [{overloadArgs}], {
    before: function(args, thisObj) {
      try {
        console.log("[Fx] {methodName} 参数数量: " + args.length);
      } catch (e) {
        console.log("[Fx] before error: " + e);
      }
    },
    after: function(retval, args, thisObj) {
      try {
        console.log("[Fx] {methodName} 返回: " + retval);
      } catch (e) {
        console.log("[Fx] after error: " + e);
      }
    }
  });
  console.log("[Init] {className}.{methodName} hook installed");
} catch (e) {
  console.log("[Fx] init error: " + e);
}
''';

const _fridaJniSymbol = r'''
// Fx 糖 JNI 原生符号 Hook
try {
  Fx.hookNative("{soName}", "{symbolName}", {
    onEnter: function(args) {
      try {
        console.log("[Fx] {symbolName} 进入, arg0=" + args[0]);
      } catch (e) {
        console.log("[Fx] onEnter error: " + e);
      }
    },
    onLeave: function(retval) {
      try {
        console.log("[Fx] {symbolName} 返回: " + retval);
      } catch (e) {
        console.log("[Fx] onLeave error: " + e);
      }
    }
  });
  console.log("[Init] {soName}!{symbolName} hook installed");
} catch (e) {
  console.log("[Fx] init error: " + e);
}
''';

const _fridaAddress = r'''
// Fx 糖地址 Hook（{address}）
try {
  const moduleBase = Fx.module.findBase("{soName}");
  if (moduleBase === null) {
    throw new Error("模块未加载: {soName}");
  }
  const targetAddr = moduleBase.add({offset});
  Fx.interceptor.attach(targetAddr, {
    onEnter: function(args) {
      try {
        console.log("[Fx] 地址 Hook 进入: {address}, arg0=" + args[0]);
      } catch (e) {
        console.log("[Fx] onEnter error: " + e);
      }
    },
    onLeave: function(retval) {
      try {
        console.log("[Fx] 地址 Hook 返回: " + retval);
      } catch (e) {
        console.log("[Fx] onLeave error: " + e);
      }
    }
  });
  console.log("[Init] {soName}+{offset} hook installed");
} catch (e) {
  console.log("[Fx] init error: " + e);
}
''';

// ═══ Handler 基类 ═══

/// 脚本生命周期工具 handler 基类。
///
/// 使用 [ApkReverseToolRuntimeContext] 获取 packageName/isZh，
/// 通过 Pigeon [ProjectNative]/[PiniaNative] 访问原生脚本管理能力。
abstract class ScriptLifecycleToolHandler implements AiChatToolHandler {
  const ScriptLifecycleToolHandler(this.context);

  final ApkReverseToolRuntimeContext context;

  ProjectNative get _projectNative => ProjectNative();

  PiniaNative get _piniaNative => PiniaNative();

  String get _pkg => context.packageName;

  bool get _isZh => context.isZh;

  /// 校验 packageName 不为空
  void _requirePackage() {
    if (_pkg.isEmpty) {
      throw ArgumentError(
        _isZh
            ? '当前无目标应用，请先在 APK 逆向会话中打开一个应用'
            : 'No target app. Please open an APK in an APK reverse session first.',
      );
    }
  }

  String _runContextKey(String source, String scriptName) =>
      'jx_script_run_context_${_pkg}_${source}_$scriptName';

  /// 脚本启用开关 key。
  ///
  /// 两个引擎的原生消费端都用「项目目录 + 纯文件名」的完整路径作为 key：
  /// - Xposed：`ScriptLoader` 用快照里的 `localPath` 拼 `xposed_check_status_` 前缀。
  /// - Frida：`FridaInjector` 用 `getFridaScripts` 返回的完整路径拼 `frida_check_status_` 前缀。
  /// 因此这里必须还原为完整路径，不能用纯文件名。
  String _switchKey(String source, String relativePath) {
    if (source == 'frida') {
      return 'frida_check_status_${_pkg}_/data/local/tmp/JsxposedX/$_pkg/$relativePath';
    }
    return 'xposed_check_status_${_pkg}_'
        '/data/user/0/com.jsxposed.xmod/app_flutter/flutter_assets/Projects/$_pkg/JsProjects/$relativePath';
  }

  /// 把原生返回的脚本路径归一化为「纯文件名 + 完整路径」。
  ///
  /// `Project.getFridaScripts` / `getJsScripts` 返回的 `Shell.getFileList` 结果是完整路径，
  /// 而 AI 工具的入参、run context key 和脚本读取都使用纯文件名。
  List<({String name, String path})> _normalizeScripts(List<String> raw) {
    return raw.map((item) {
      final name = item.split('/').last;
      return (name: name, path: item);
    }).toList();
  }

  String? _findScriptPath(
    List<({String name, String path})> scripts,
    String fileName,
  ) {
    for (final script in scripts) {
      if (script.name == fileName) return script.path;
    }
    return null;
  }

  Future<({String runId, bool created})> _startScriptRun(
    String source,
    String scriptName,
  ) async {
    final conversationId = context.conversationBinding.conversationId;
    if (conversationId == null || conversationId.isEmpty) {
      throw StateError(
        _isZh ? '当前会话无法关联脚本运行' : 'No conversation is bound to this script run.',
      );
    }

    final existingRaw = await _piniaNative.getString(
      key: _runContextKey(source, scriptName),
      defaultValue: '',
    );
    if (existingRaw.isNotEmpty) {
      final existing = jsonDecode(existingRaw) as Map<String, dynamic>;
      final existingRunId = existing['runId'] as String?;
      final existingConversationId = existing['conversationId'] as String?;
      if (existingRunId != null && existingRunId.isNotEmpty) {
        final existingRun = await context.conversationBinding.logs.getRun(
          existingRunId,
        );
        if (existingRun == null || existingRun.status != 'running') {
          await _piniaNative.remove(key: _runContextKey(source, scriptName));
        } else {
          if (existingConversationId == conversationId) {
            return (runId: existingRunId, created: false);
          }
          throw StateError(
            _isZh
                ? '脚本 $scriptName 已在其他会话中运行，请先停用'
                : 'Script $scriptName is already running in another conversation.',
          );
        }
      }
    }

    final runId = const Uuid().v4();
    final startedAt = DateTime.now().toUtc();
    final runContext = {
      'runId': runId,
      'conversationId': conversationId,
      'source': source,
      'scriptName': scriptName,
      'startedAt': startedAt.toIso8601String(),
    };
    await context.conversationBinding.logs.startRun(
      runId: runId,
      conversationId: conversationId,
      source: source,
      scriptName: scriptName,
      startedAt: startedAt,
    );
    try {
      await _piniaNative.setString(
        key: _runContextKey(source, scriptName),
        value: jsonEncode(runContext),
      );
    } catch (_) {
      try {
        await _piniaNative.remove(key: _runContextKey(source, scriptName));
      } finally {
        await context.conversationBinding.logs.finishRun(
          runId,
          status: 'failed',
          finishedAt: DateTime.now().toUtc(),
        );
      }
      rethrow;
    }
    return (runId: runId, created: true);
  }

  Future<void> _failScriptRun({
    required String source,
    required String scriptName,
    required String runId,
    required String toggleKey,
  }) async {
    try {
      await _piniaNative.setBool(key: toggleKey, value: false);
    } finally {
      try {
        await context.conversationBinding.logs.finishRun(
          runId,
          status: 'failed',
          finishedAt: DateTime.now().toUtc(),
        );
      } finally {
        await _piniaNative.remove(key: _runContextKey(source, scriptName));
      }
    }
  }

  Future<void> _finishScriptRun(String source, String scriptName) async {
    final key = _runContextKey(source, scriptName);
    final raw = await _piniaNative.getString(key: key, defaultValue: '');
    try {
      if (raw.isNotEmpty) {
        final value = jsonDecode(raw) as Map<String, dynamic>;
        final runId = value['runId'] as String?;
        if (runId != null && runId.isNotEmpty) {
          await context.conversationBinding.logs.finishRun(
            runId,
            status: 'stopped',
            finishedAt: DateTime.now().toUtc(),
          );
        }
      }
    } finally {
      await _piniaNative.remove(key: key);
    }
  }
}

class GetScriptLogsHandler extends ScriptLifecycleToolHandler {
  const GetScriptLogsHandler(super.context);

  @override
  String get toolName => 'get_script_logs';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final conversationId = context.conversationBinding.conversationId;
    if (conversationId == null || conversationId.isEmpty) {
      return _isZh
          ? '当前会话暂无脚本日志。'
          : 'No script logs for the current conversation.';
    }
    final before = DateTime.tryParse(call.getString('before'))?.toUtc();
    final beforeId = call.getInt('beforeId');
    final runId = call.getString('runId');
    final scriptName = call.getString('scriptName');
    final source = call.getString('source');
    final level = call.getString('level');
    final beforeIdValue = beforeId == 0 ? null : beforeId;
    final limit = call.getInt('limit', 50);
    Future<List<ScriptLogRecord>> query(
      String queryConversationId,
      String? querySource,
      String? queryScriptName,
    ) {
      return context.conversationBinding.logs.getLogs(
        conversationId: queryConversationId,
        runId: runId.isEmpty ? null : runId,
        scriptName: queryScriptName?.isEmpty == true ? null : queryScriptName,
        source: querySource?.isEmpty == true ? null : querySource,
        level: level.isEmpty ? null : level,
        before: before,
        beforeId: beforeIdValue,
        limit: limit,
      );
    }

    var logs = await query(conversationId, source, scriptName);
    if (logs.isEmpty && runId.isEmpty && context.packageName.isNotEmpty) {
      logs = await context.conversationBinding.logs.getStandaloneLogs(
        packageName: context.packageName,
        scriptName: scriptName.isEmpty ? null : scriptName,
        source: source.isEmpty ? null : source,
        level: level.isEmpty ? null : level,
        before: before,
        beforeId: beforeIdValue,
        limit: limit,
      );
    }
    if (logs.isEmpty) {
      return _isZh
          ? '当前会话暂无匹配的脚本日志。若脚本使用独立运行记录，请同时提供 scriptName。'
          : 'No matching script logs. For standalone runs, provide scriptName.';
    }
    return logs
        .map((log) {
          final time = log.timestamp.toUtc().toIso8601String();
          final stack = log.stackTrace.isEmpty ? '' : '\n${log.stackTrace}';
          return '[$time] [${log.source}/${log.level}] ${log.scriptName} '
              '(run ${log.runId}): ${log.message}$stack';
        })
        .join('\n');
  }
}

// ═══ A1. generate_xposed_hook ═══

class GenerateXposedHookHandler extends ScriptLifecycleToolHandler {
  const GenerateXposedHookHandler(super.context);

  @override
  String get toolName => 'generate_xposed_hook';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final className = call.getString('className');
    if (className.isEmpty) {
      throw ArgumentError('className 不能为空 / className is required');
    }

    final methodName = call.getString('methodName');
    final paramTypes = call.getStringList('parameterTypes');
    final hookType = call.getString('hookType', 'before_after');

    if (methodName.isNotEmpty) {
      return _genSingleMethod(className, methodName, paramTypes, hookType);
    } else {
      return _genAllMethods(className, paramTypes);
    }
  }

  String _genSingleMethod(
    String cls,
    String method,
    List<String> params,
    String hookType,
  ) {
    final paramList = params.join(', ');
    String template;
    switch (hookType) {
      case 'before':
        template = _xposedHookBefore;
      case 'after':
        template = _xposedHookAfter;
      case 'replace':
        template = _xposedHookReplace;
      case 'before_after':
      default:
        template = _xposedHookBeforeAfter;
    }
    return template
        .replaceAll('{className}', cls)
        .replaceAll('{methodName}', method)
        .replaceAll('{paramList}', paramList);
  }

  String _genAllMethods(String cls, List<String> params) {
    final paramListStr = params.join(', ');
    // 无 methodName 时生成方法枚举提示 + 骨架
    return _xposedMethodEnumTemplate
        .replaceAll('{className}', cls)
        .replaceAll(
          '{methodList}',
          _isZh
              ? '请先用 decompile_class 或 list_classes 查看 $cls 的方法列表，然后带 methodName 重新调用本工具'
              : 'Use decompile_class or list_classes to view methods of $cls, then call this tool again with methodName',
        )
        .replaceAll(
          '{methodSkeletons}',
          _xposedMethodSkeleton
              .replaceAll('{className}', cls)
              .replaceAll('{methodName}', 'methodName')
              .replaceAll('{paramTypes}', paramListStr)
              .replaceAll('{paramListStr}', paramListStr),
        );
  }
}

// ═══ A2. generate_frida_hook（升级版，替换 generate_so_hook） ═══

class GenerateFridaHookHandler extends ScriptLifecycleToolHandler {
  const GenerateFridaHookHandler(super.context);

  @override
  String get toolName => 'generate_frida_hook';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final mode = call.getString('mode', 'javaMethod');

    switch (mode) {
      case 'javaMethod':
        return _genJavaMethod(call);
      case 'jniSymbol':
        return _genJniSymbol(call);
      case 'address':
        return _genAddress(call);
      default:
        throw ArgumentError(
          'mode 非法，仅支持 javaMethod/jniSymbol/address / '
          'Invalid mode, only javaMethod/jniSymbol/address supported',
        );
    }
  }

  String _genJavaMethod(AiToolCall call) {
    final className = call.getString('className');
    final methodName = call.getString('methodName');
    final paramTypes = call.getStringList('parameterTypes');

    if (className.isEmpty) throw ArgumentError('className 不能为空');
    if (methodName.isEmpty) throw ArgumentError('methodName 不能为空');

    final overloadArgs = paramTypes.isNotEmpty
        ? paramTypes.map((t) => "'$t'").join(', ')
        : '';

    return _fridaJavaMethod
        .replaceAll('{className}', className)
        .replaceAll('{methodName}', methodName)
        .replaceAll('{overloadArgs}', overloadArgs);
  }

  String _genJniSymbol(AiToolCall call) {
    final soPath = call.getString('soPath');
    final symbolName = call.getString('symbolName');

    if (soPath.isEmpty) throw ArgumentError('soPath 不能为空');
    if (symbolName.isEmpty) throw ArgumentError('symbolName 不能为空');

    final soName = soPath.split('/').last;

    return _fridaJniSymbol
        .replaceAll('{soName}', soName)
        .replaceAll('{symbolName}', symbolName);
  }

  String _genAddress(AiToolCall call) {
    final soPath = call.getString('soPath');
    final addressStr = call.getString('address');

    if (soPath.isEmpty) throw ArgumentError('soPath 不能为空');
    if (addressStr.isEmpty) throw ArgumentError('address 不能为空');

    final soName = soPath.split('/').last;
    final cleaned = addressStr.replaceFirst(
      RegExp(r'^0x', caseSensitive: false),
      '',
    );
    final addr = int.tryParse(cleaned, radix: 16);
    if (addr == null) {
      throw ArgumentError(
        'address 需为十六进制，如 0x1234 / address must be hexadecimal, e.g. 0x1234',
      );
    }

    return _fridaAddress
        .replaceAll('{soName}', soName)
        .replaceAll('{address}', addressStr)
        .replaceAll('{offset}', '0x${addr.toRadixString(16)}');
  }
}

// ═══ A4. save_script ═══

class SaveScriptHandler extends ScriptLifecycleToolHandler {
  const SaveScriptHandler(super.context);

  @override
  String get toolName => 'save_script';

  static const _reservedFrida = {'hook.js', 'loader.js'};
  static const _reservedXposed = {'hook.js', 'loader.js'};

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    _requirePackage();

    final useLastGenerated = call.getBool('use_last_generated', false);
    String scriptType;
    String fileName;
    String code;
    
    if (useLastGenerated) {
      final cachedCode = context.conversationBinding.lastGeneratedCode;
      final cachedType = context.conversationBinding.lastGeneratedScriptType;
      final cachedName = context.conversationBinding.lastGeneratedFileName;
      
      if (cachedCode == null || cachedCode.isEmpty) {
        throw ArgumentError(
          _isZh
              ? '未找到最近生成的脚本，请先生成脚本或直接传入完整参数'
              : 'No recently generated script found. Generate a script first or pass all parameters.',
        );
      }
      
      code = cachedCode;
      scriptType = cachedType ?? 'xposed';
      fileName = cachedName ?? 'ai_hook_${DateTime.now().millisecondsSinceEpoch}';
    } else {
      scriptType = call.getString('scriptType');
      fileName = call.getString('fileName');
      code = call.getString('code');
      if (scriptType.isEmpty || fileName.isEmpty || code.isEmpty) {
        throw ArgumentError('scriptType、fileName、code 都不能为空');
      }
    }
    
    final overwrite = call.getBool('overwrite');

    if (scriptType != 'frida' && scriptType != 'xposed') {
      throw ArgumentError(
        'scriptType 仅支持 frida/xposed / scriptType must be frida or xposed',
      );
    }

    // 校验保留名
    if (scriptType == 'frida' && _reservedFrida.contains(fileName) ||
        scriptType == 'xposed' && _reservedXposed.contains(fileName)) {
      throw ArgumentError(
        _isZh
            ? '$fileName 是保留文件名，请换一个 / $fileName is a reserved name'
            : '$fileName is a reserved name, please choose another',
      );
    }

    // 处理文件名：Frida 自动补 .js，Xposed 自动加 [tradition] 前缀
    String finalName;
    if (scriptType == 'frida') {
      finalName = fileName.endsWith('.js') ? fileName : '$fileName.js';
    } else {
      // xposed
      final base = fileName.endsWith('.js') ? fileName : '$fileName.js';
      finalName = base.startsWith('[') ? base : '[tradition]$base';
    }

    // 检查是否已存在（不 overwrite 时）
    if (!overwrite) {
      final existing = _normalizeScripts(
        scriptType == 'frida'
            ? await _projectNative.getFridaScripts(_pkg)
            : await _projectNative.getJsScripts(_pkg),
      );
      if (_findScriptPath(existing, finalName) != null) {
        throw ArgumentError(
          _isZh
              ? '脚本 $finalName 已存在。设置 overwrite=true 覆盖 / '
                    'Script $finalName already exists. Set overwrite=true to overwrite'
              : 'Script $finalName already exists. Set overwrite=true to overwrite',
        );
      }
    }

    final runKey = _runContextKey(scriptType, finalName);
    final currentRunContext = await _piniaNative.getString(
      key: runKey,
      defaultValue: '',
    );
    if (overwrite && currentRunContext.isNotEmpty) {
      final current = jsonDecode(currentRunContext) as Map<String, dynamic>;
      final currentRunId = current['runId'] as String?;
      final currentRun = currentRunId == null
          ? null
          : await context.conversationBinding.logs.getRun(currentRunId);
      if (currentRun?.status == 'running') {
        throw StateError(
          _isZh
              ? '脚本 $finalName 正在运行，不能覆盖'
              : 'Cannot overwrite $finalName while it is running.',
        );
      }
    }

    // 建立日志归属后再启用，失败时不留下已启用但无 run 的状态。
    final run = await _startScriptRun(scriptType, finalName);
    if (!run.created) {
      return _isZh
          ? '脚本 $finalName 已在当前会话中运行'
          : 'Script $finalName is already running in this conversation.';
    }
    final toggleKey = _switchKey(scriptType, finalName);
    try {
      if (scriptType == 'frida') {
        await _projectNative.createFridaScript(_pkg, code, finalName, false);
      } else {
        await _projectNative.createJsScript(_pkg, code, finalName, false);
      }
      final savedCode = scriptType == 'frida'
          ? await _projectNative.readFridaScript(_pkg, finalName)
          : await _projectNative.readJsScript(_pkg, finalName);
      if (savedCode.trim() != code.trim()) {
        throw StateError(
          _isZh
              ? '脚本写入后校验失败，磁盘内容与提交内容不一致'
              : 'Post-write verification failed: saved content differs from submitted code',
        );
      }
      await _piniaNative.setBool(key: toggleKey, value: true);
    } catch (_) {
      await _failScriptRun(
        source: scriptType,
        scriptName: finalName,
        runId: run.runId,
        toggleKey: toggleKey,
      );
      rethrow;
    }

    return _isZh
        ? '脚本 $finalName 已保存并启用'
        : 'Script $finalName saved and enabled';
  }
}

// ═══ A5. list_scripts ═══

class ListScriptsHandler extends ScriptLifecycleToolHandler {
  const ListScriptsHandler(super.context);

  @override
  String get toolName => 'list_scripts';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    _requirePackage();

    final scriptType = call.getString('scriptType');
    if (scriptType != '' && scriptType != 'frida' && scriptType != 'xposed') {
      throw ArgumentError(
        'scriptType 仅支持 frida/xposed / scriptType must be frida or xposed',
      );
    }
    final showFrida = scriptType.isEmpty || scriptType == 'frida';
    final showXposed = scriptType.isEmpty || scriptType == 'xposed';

    final buf = StringBuffer();
    if (_isZh) {
      buf.writeln('## 脚本列表 - $_pkg\n');
    } else {
      buf.writeln('## Script List - $_pkg\n');
    }

    if (showFrida) {
      buf.writeln(_isZh ? '### Frida 脚本' : '### Frida Scripts');
      try {
        final fridaScripts = _normalizeScripts(
          await _projectNative.getFridaScripts(_pkg),
        );
        if (fridaScripts.isEmpty) {
          buf.writeln(_isZh ? '（无）\n' : '(none)\n');
        } else {
          for (final script in fridaScripts) {
            final enabled = await _piniaNative.getBool(
              key: _switchKey('frida', script.name),
              defaultValue: false,
            );
            buf.writeln(
              '- ${script.name} ${enabled ? (_isZh ? '✅ 启用' : '✅ enabled') : (_isZh ? '⏸️ 停用' : '⏸️ disabled')}',
            );
          }
          buf.writeln();
        }
      } catch (e) {
        buf.writeln('${_isZh ? '加载失败' : 'Load failed'}: $e\n');
      }
    }

    if (showXposed) {
      buf.writeln(_isZh ? '### Xposed 脚本' : '### Xposed Scripts');
      try {
        final xposedScripts = _normalizeScripts(
          await _projectNative.getJsScripts(_pkg),
        );
        if (xposedScripts.isEmpty) {
          buf.writeln(_isZh ? '（无）\n' : '(none)\n');
        } else {
          for (final script in xposedScripts) {
            final enabled = await _piniaNative.getBool(
              key: _switchKey('xposed', script.name),
              defaultValue: false,
            );
            buf.writeln(
              '- ${script.name} ${enabled ? (_isZh ? '✅ 启用' : '✅ enabled') : (_isZh ? '⏸️ 停用' : '⏸️ disabled')}',
            );
          }
          buf.writeln();
        }
      } catch (e) {
        buf.writeln('${_isZh ? '加载失败' : 'Load failed'}: $e\n');
      }
    }

    return buf.toString().trimRight();
  }
}

// ═══ A6. toggle_script ═══

class ToggleScriptHandler extends ScriptLifecycleToolHandler {
  const ToggleScriptHandler(super.context);

  @override
  String get toolName => 'toggle_script';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    _requirePackage();

    final scriptType = call.getString('scriptType');
    final fileName = call.getString('fileName');
    final enabled = call.getBool('enabled', true);

    if (scriptType != 'frida' && scriptType != 'xposed') {
      throw ArgumentError(
        'scriptType 仅支持 frida/xposed / scriptType must be frida or xposed',
      );
    }
    if (fileName.isEmpty) throw ArgumentError('fileName 不能为空');

    // 验证脚本存在
    final scripts = _normalizeScripts(
      scriptType == 'frida'
          ? await _projectNative.getFridaScripts(_pkg)
          : await _projectNative.getJsScripts(_pkg),
    );
    if (_findScriptPath(scripts, fileName) == null) {
      throw ArgumentError(
        _isZh
            ? '脚本 $fileName 不存在 / Script $fileName not found'
            : 'Script $fileName not found',
      );
    }

    final toggleKey = _switchKey(scriptType, fileName);
    if (enabled) {
      final run = await _startScriptRun(scriptType, fileName);
      if (!run.created) {
        return _isZh
            ? '脚本 $fileName 已在当前会话中运行'
            : 'Script $fileName is already running in this conversation.';
      }
      try {
        await _piniaNative.setBool(key: toggleKey, value: true);
      } catch (_) {
        await _failScriptRun(
          source: scriptType,
          scriptName: fileName,
          runId: run.runId,
          toggleKey: toggleKey,
        );
        rethrow;
      }
    } else {
      try {
        await _piniaNative.setBool(key: toggleKey, value: false);
      } finally {
        await _finishScriptRun(scriptType, fileName);
      }
    }

    return _isZh
        ? '脚本 $fileName 已${enabled ? "启用" : "停用"}'
        : 'Script $fileName ${enabled ? "enabled" : "disabled"}';
  }
}

// ═══ A3. validate_script（P1） ═══

class ValidateScriptHandler extends ScriptLifecycleToolHandler {
  const ValidateScriptHandler(super.context);

  @override
  String get toolName => 'validate_script';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final useLastGenerated = call.getBool('use_last_generated', false);
    String code;
    String engine;
    
    if (useLastGenerated) {
      final cached = context.conversationBinding.lastGeneratedCode;
      if (cached == null || cached.isEmpty) {
        throw ArgumentError(
          _isZh
              ? '未找到最近生成的脚本，请先生成脚本或直接传入 code 参数'
              : 'No recently generated script found. Generate a script first or pass the code parameter.',
        );
      }
      code = cached;
      engine = context.conversationBinding.lastGeneratedScriptType ?? 'frida';
    } else {
      code = call.getString('code');
      engine = call.getString('engine', 'frida');
      if (code.isEmpty) throw ArgumentError('code 不能为空');
    }

    final issues = <String>[];

    // ═══ 通用 JS 语法校验 ═══
    _checkBrackets(code, issues);
    _checkQuotes(code, issues);
    _checkKeywords(code, issues);
    _checkSyntax(code, engine, issues);

    if (issues.isEmpty) {
      return _isZh
          ? '校验通过，未发现语法问题。'
          : 'Validation passed, no syntax issues found.';
    }

    final buf = StringBuffer();
    if (_isZh) {
      buf.writeln('发现 ${issues.length} 个问题：\n');
    } else {
      buf.writeln('Found ${issues.length} issues:\n');
    }
    for (final issue in issues) {
      buf.writeln('- $issue');
    }
    return buf.toString().trimRight();
  }

  void _checkBrackets(String code, List<String> issues) {
    int brace = 0, bracket = 0, paren = 0;
    for (var i = 0; i < code.length; i++) {
      switch (code[i]) {
        case '{':
          brace++;
          break;
        case '}':
          brace--;
          break;
        case '[':
          bracket++;
          break;
        case ']':
          bracket--;
          break;
        case '(':
          paren++;
          break;
        case ')':
          paren--;
          break;
      }
    }
    if (brace != 0) {
      issues.add(
        '${_isZh ? "花括号 {}" : "Braces {}"} ${_isZh ? "不匹配" : "unmatched"} (差值/$brace)',
      );
    }
    if (bracket != 0) {
      issues.add(
        '${_isZh ? "方括号 []" : "Brackets []"} ${_isZh ? "不匹配" : "unmatched"} (差值/$bracket)',
      );
    }
    if (paren != 0) {
      issues.add(
        '${_isZh ? "圆括号 ()" : "Parentheses ()"} ${_isZh ? "不匹配" : "unmatched"} (差值/$paren)',
      );
    }
  }

  void _checkQuotes(String code, List<String> issues) {
    bool inSingle = false, inDouble = false, inBacktick = false;
    for (var i = 0; i < code.length; i++) {
      final c = code[i];
      final prev = i > 0 ? code[i - 1] : '';
      final escaped = prev == '\\';

      if (!escaped) {
        if (c == "'" && !inDouble && !inBacktick) inSingle = !inSingle;
        if (c == '"' && !inSingle && !inBacktick) inDouble = !inDouble;
        if (c == '`' && !inSingle && !inDouble) inBacktick = !inBacktick;
      }
    }
    if (inSingle) issues.add(_isZh ? '单引号未闭合' : 'Unclosed single quote');
    if (inDouble) issues.add(_isZh ? '双引号未闭合' : 'Unclosed double quote');
    if (inBacktick) {
      issues.add(_isZh ? '模板字符串未闭合' : 'Unclosed template literal');
    }
  }

  void _checkKeywords(String code, List<String> issues) {
    if (code.contains('```')) {
      issues.add(
        _isZh
            ? '脚本包含 Markdown 代码围栏，请只提交纯 JavaScript'
            : 'Script contains Markdown fences; submit plain JavaScript only.',
      );
    }
    if (RegExp(r'\bTODO\b|自定义返回值|添加业务逻辑|处理参数|处理返回值').hasMatch(code)) {
      issues.add(
        _isZh
            ? '脚本仍包含 TODO 或占位逻辑，请提交完整可运行实现'
            : 'Script still contains TODO or placeholder logic; submit a complete runnable implementation.',
      );
    }
    // Fx 糖特有校验
    if (code.contains('Java.use(') ||
        code.contains('Java.perform(') ||
        code.contains('Java.cast(') ||
        code.contains('Interceptor.attach(')) {
      issues.add(
        _isZh
            ? '发现原生 Frida API，请使用 Fx 糖 API (Fx.use/Fx.hookNative/Fx.interceptor) 替代'
            : 'Found raw Frida API. Use Fx sugar APIs (Fx.use/Fx.hookNative/Fx.interceptor) instead.',
      );
    }
    // Jx 糖特有校验
    if (code.contains('XposedBridge') || code.contains('XposedHelpers')) {
      issues.add(
        _isZh
            ? '发现原生 Xposed API，请使用 Jx 糖 API (Jx.use) 替代'
            : 'Found raw Xposed API. Use Jx sugar API (Jx.use) instead.',
      );
    }
  }

  void _checkSyntax(String code, String engine, List<String> issues) {
    // engine 特定校验
    if (engine == 'xposed') {
      // [tradition] 是脚本「文件名」前缀，且 save_script 会自动补全，
      // 不应出现在脚本体内容里。若模型把它写进代码，提示移除。
      if (code.contains('[tradition]')) {
        issues.add(
          _isZh
              ? '[tradition] 前缀由 save_script 自动添加，请从脚本内容中移除'
              : 'The [tradition] prefix is added automatically by save_script; remove it from the script body',
        );
      }
    }
  }
}

// ═══ A7. read_script ═══

class ReadScriptHandler extends ScriptLifecycleToolHandler {
  const ReadScriptHandler(super.context);

  @override
  String get toolName => 'read_script';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    _requirePackage();

    final scriptType = call.getString('scriptType');
    final fileName = call.getString('fileName');

    if (scriptType != 'frida' && scriptType != 'xposed') {
      throw ArgumentError(
        'scriptType 仅支持 frida/xposed / scriptType must be frida or xposed',
      );
    }
    if (fileName.isEmpty) throw ArgumentError('fileName 不能为空');

    final scripts = _normalizeScripts(
      scriptType == 'frida'
          ? await _projectNative.getFridaScripts(_pkg)
          : await _projectNative.getJsScripts(_pkg),
    );
    if (_findScriptPath(scripts, fileName) == null) {
      throw ArgumentError(
        '${_isZh ? "脚本 $fileName 不存在" : "Script $fileName not found"}',
      );
    }

    final content = scriptType == 'frida'
        ? await _projectNative.readFridaScript(_pkg, fileName)
        : await _projectNative.readJsScript(_pkg, fileName);

    return content;
  }
}

// ═══ A8. delete_script ═══

class DeleteScriptHandler extends ScriptLifecycleToolHandler {
  const DeleteScriptHandler(super.context);

  @override
  String get toolName => 'delete_script';

  static const _reservedNames = {'hook.js', 'loader.js'};

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    _requirePackage();

    final scriptType = call.getString('scriptType');
    final fileName = call.getString('fileName');
    final confirm = call.getBool('confirm');

    if (scriptType != 'frida' && scriptType != 'xposed') {
      throw ArgumentError(
        'scriptType 仅支持 frida/xposed / scriptType must be frida or xposed',
      );
    }
    if (fileName.isEmpty) throw ArgumentError('fileName 不能为空');
    if (!confirm) {
      throw ArgumentError(
        _isZh ? '删除操作需 confirm=true 确认' : 'Delete requires confirm=true',
      );
    }

    if (_reservedNames.contains(fileName)) {
      throw ArgumentError(
        _isZh ? '不能删除保留文件 $fileName' : 'Cannot delete reserved file $fileName',
      );
    }

    final scripts = _normalizeScripts(
      scriptType == 'frida'
          ? await _projectNative.getFridaScripts(_pkg)
          : await _projectNative.getJsScripts(_pkg),
    );
    if (_findScriptPath(scripts, fileName) == null) {
      throw ArgumentError(
        '${_isZh ? "脚本 $fileName 不存在" : "Script $fileName not found"}',
      );
    }

    final contextKey = _runContextKey(scriptType, fileName);
    final runContext = await _piniaNative.getString(
      key: contextKey,
      defaultValue: '',
    );
    if (runContext.isNotEmpty) {
      final value = jsonDecode(runContext) as Map<String, dynamic>;
      final runId = value['runId'] as String?;
      final run = runId == null
          ? null
          : await context.conversationBinding.logs.getRun(runId);
      if (run?.status == 'running') {
        throw StateError(
          _isZh
              ? '脚本 $fileName 正在运行，请先停用'
              : 'Script $fileName is running. Stop it before deleting it.',
        );
      }
    }

    if (scriptType == 'frida') {
      await _projectNative.deleteFridaScript(_pkg, fileName);
    } else {
      await _projectNative.deleteJsScript(_pkg, fileName);
    }
    if (runContext.isNotEmpty) {
      await _piniaNative.remove(key: contextKey);
    }

    return _isZh ? '脚本 $fileName 已删除' : 'Script $fileName deleted';
  }
}
