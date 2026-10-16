import 'dart:convert';

import 'package:JsxposedX/features/xposed/domain/models/block_node.dart';
import 'package:flutter/foundation.dart';

/// 递归代码生成器 — 从 BlockNode 树生成 JS 代码
class BlockCodeGenerator {
  static const _treeStart = '/* === BLOCK_TREE ===';
  static const _treeEnd = '=== END_BLOCK_TREE === */';

  /// 从 JS 代码中解析积木树
  static List<BlockNode> parseTree(String jsCode) {
    if (!jsCode.contains(_treeStart)) return [];
    try {
      final s = jsCode.indexOf(_treeStart) + _treeStart.length;
      final e = jsCode.indexOf(_treeEnd);
      if (s >= 0 && e > s) {
        final json = jsCode.substring(s, e).trim();
        final list = jsonDecode(json) as List;
        return list
            .map((e) => BlockNode.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Failed to parse block tree: $e');
    }
    return [];
  }

  /// 生成完整 JS 代码
  static String generateJs(List<BlockNode> roots) {
    final buf = StringBuffer();
    // 嵌入 JSON 配置
    final json = jsonEncode(roots.map((n) => n.toJson()).toList());
    buf.writeln('$_treeStart\n$json\n$_treeEnd');
    buf.writeln();
    // 生成代码
    for (final node in roots) {
      if (!node.enabled) continue;
      buf.writeln(_genNode(node, 0));
    }
    return buf.toString();
  }

  static String _indent(int level) => '  ' * level;

  static String _p(BlockNode n, String key) => n.params[key] ?? '';

  static String _paramTypesArr(BlockNode n) {
    final raw = _p(n, 'paramTypes');
    if (raw.isEmpty) return '[]';
    final types = raw.split(',').map((e) => '"${e.trim()}"').join(', ');
    return '[$types]';
  }

  static String _genSlot(BlockNode n, String key, int indent) {
    final children = n.slots[key] ?? [];
    if (children.isEmpty) return '';
    final buf = StringBuffer();
    for (final child in children) {
      if (!child.enabled) continue;
      buf.writeln(_genNode(child, indent));
    }
    return buf.toString();
  }

  static String _genNode(BlockNode n, int level) {
    final i = _indent(level);
    switch (n.type) {
      // Hook 类
      case BlockType.hookMethod:
        return _genHookMethod(n, i, level);
      case BlockType.hookBefore:
        return _genHookSingle(n, i, level, 'before');
      case BlockType.hookAfter:
        return _genHookSingle(n, i, level, 'after');
      case BlockType.hookReplace:
        return _genHookSingle(n, i, level, 'replace');
      case BlockType.hookConstructor:
        return _genHookConstructor(n, i, level);
      case BlockType.beforeConstructor:
        return _genConstructorSingle(n, i, level, 'beforeConstructor');
      case BlockType.afterConstructor:
        return _genConstructorSingle(n, i, level, 'afterConstructor');
      case BlockType.returnConst:
        return _genReturnConst(n, i);
      case BlockType.hookAllMethods:
        return _genHookAllMethods(n, i, level);
      case BlockType.hookAllConstructors:
        return _genHookAllConstructors(n, i, level);
      case BlockType.unhook:
        return '${i}Jx.unhook(${_p(n, 'varName')});';
      // 日志类
      case BlockType.log:
        return '${i}Jx.log(${_strVal(n, 'message')});';
      case BlockType.logException:
        return '${i}Jx.logException(${_strVal(n, 'message')});';
      case BlockType.consoleLog:
        return '${i}console.log(${_strVal(n, 'message')});';
      case BlockType.consoleWarn:
        return '${i}console.warn(${_strVal(n, 'message')});';
      case BlockType.consoleError:
        return '${i}console.error(${_strVal(n, 'message')});';
      case BlockType.stackTrace:
        return '${i}Jx.ext.stackTrace(${_strVal(n, 'tag')});';
      // 字段类
      case BlockType.getField:
        return _genGetField(n, i);
      case BlockType.setField:
        return _genSetField(n, i);
      case BlockType.getInt:
        return '${i}var ${_p(n, 'varName')} = Jx.wrap(param.thisObject).getInt("${_p(n, 'fieldName')}");';
      case BlockType.setInt:
        return '${i}Jx.wrap(param.thisObject).setInt("${_p(n, 'fieldName')}", ${_p(n, 'value')});';
      case BlockType.getBool:
        return '${i}var ${_p(n, 'varName')} = Jx.wrap(param.thisObject).getBool("${_p(n, 'fieldName')}");';
      case BlockType.setBool:
        return '${i}Jx.wrap(param.thisObject).setBool("${_p(n, 'fieldName')}", ${_p(n, 'value')});';
      case BlockType.getClassName:
        return '${i}var ${_p(n, 'varName')} = Jx.wrap(param.thisObject).getClassName();';
      case BlockType.getLong:
        return '${i}var ${_p(n, 'varName')} = Jx.wrap(param.thisObject).getLong("${_p(n, 'fieldName')}");';
      case BlockType.setLong:
        return '${i}Jx.wrap(param.thisObject).setLong("${_p(n, 'fieldName')}", ${_p(n, 'value')});';
      case BlockType.getFloat:
        return '${i}var ${_p(n, 'varName')} = Jx.wrap(param.thisObject).getFloat("${_p(n, 'fieldName')}");';
      case BlockType.setFloat:
        return '${i}Jx.wrap(param.thisObject).setFloat("${_p(n, 'fieldName')}", ${_p(n, 'value')});';
      case BlockType.getDouble:
        return '${i}var ${_p(n, 'varName')} = Jx.wrap(param.thisObject).getDouble("${_p(n, 'fieldName')}");';
      case BlockType.setDouble:
        return '${i}Jx.wrap(param.thisObject).setDouble("${_p(n, 'fieldName')}", ${_p(n, 'value')});';
      // 参数类
      case BlockType.getArg:
        return '${i}var ${_p(n, 'varName')} = param.getArg(${_p(n, 'index')});';
      case BlockType.setArg:
        return '${i}param.setArg(${_p(n, 'index')}, ${_p(n, 'value')});';
      case BlockType.getResult:
        return '${i}var ${_p(n, 'varName')} = param.getResult();';
      case BlockType.setResult:
        return '${i}param.setResult(${_p(n, 'value')});';
      case BlockType.getThrowable:
        return '${i}var ${_p(n, 'varName')} = param.getThrowable();';
      case BlockType.setThrowable:
        return '${i}param.setThrowable(${_strVal(n, 'message')});';
      // 调用类
      case BlockType.callMethod:
        return _genCallMethod(n, i);
      case BlockType.callMethodTyped:
        return _genCallMethodTyped(n, i);
      case BlockType.callStatic:
        return _genCallStatic(n, i);
      case BlockType.callStaticAuto:
        return _genCallStaticAuto(n, i);
      case BlockType.newInstance:
        return _genNewInstance(n, i);
      case BlockType.newInstanceTyped:
        return _genNewInstanceTyped(n, i);
      // 流程控制
      case BlockType.ifBlock:
        return _genIfBlock(n, i, level);
      case BlockType.forLoop:
        return _genForLoop(n, i, level);
      case BlockType.varAssign:
        return '${i}var ${_p(n, 'varName')} = ${_p(n, 'value')};';
      case BlockType.customCode:
        return '$i${_p(n, 'code')}';
      // 扩展工具
      case BlockType.toast:
        return '${i}Jx.ext.toast(param.thisObject, ${_strVal(n, 'message')});';
      case BlockType.getApplication:
        return '${i}var ${_p(n, 'varName')} = Jx.ext.getApplication();';
      case BlockType.getPackageName:
        return '${i}var ${_p(n, 'varName')} = Jx.ext.getPackageName(Jx.ext.getApplication());';
      case BlockType.getSharedPrefs:
        return '${i}var ${_p(n, 'varName')} = Jx.ext.getSharedPrefs(Jx.ext.getApplication(), ${_strVal(n, 'name')});';
      case BlockType.getPrefString:
        return '${i}var ${_p(n, 'varName')} = Jx.ext.getPrefString(sp, ${_strVal(n, 'key')}, "");';
      case BlockType.getPrefInt:
        return '${i}var ${_p(n, 'varName')} = Jx.ext.getPrefInt(sp, ${_strVal(n, 'key')}, 0);';
      case BlockType.getPrefBool:
        return '${i}var ${_p(n, 'varName')} = Jx.ext.getPrefBool(sp, ${_strVal(n, 'key')}, false);';
      case BlockType.getBuild:
        return '${i}var ${_p(n, 'varName')} = Jx.ext.getBuild("${_p(n, 'fieldName')}");';
      case BlockType.startActivity:
        return '${i}Jx.ext.startActivity(param.thisObject, "${_p(n, 'className')}");';
      case BlockType.findClass:
        return '${i}var ${_p(n, 'varName')} = Jx.findClass("${_p(n, 'className')}");';
      case BlockType.loadClass:
        return '${i}var ${_p(n, 'varName')} = Jx.loadClass("${_p(n, 'className')}");';
      case BlockType.getMethods:
        return '${i}var ${_p(n, 'varName')} = Jx.getMethods("${_p(n, 'className')}");';
      case BlockType.getFields:
        return '${i}var ${_p(n, 'varName')} = Jx.getFields("${_p(n, 'className')}");';
      case BlockType.instanceOf:
        return '${i}var ${_p(n, 'varName')} = Jx.instanceOf(${_p(n, 'value')}, "${_p(n, 'className')}");';
      case BlockType.setExtra:
        return '${i}Jx.setExtra(${_p(n, 'value')}, ${_strVal(n, 'key')}, ${_p(n, 'varName')});';
      case BlockType.getExtra:
        return '${i}var ${_p(n, 'varName')} = Jx.getExtra(${_p(n, 'value')}, ${_strVal(n, 'key')});';
      case BlockType.getSystemProp:
        return '${i}var ${_p(n, 'varName')} = Jx.ext.getSystemProp(${_strVal(n, 'key')});';
    }
  }

  static final _varRefPattern = RegExp(r'\$\{(.+?)\}');

  static String _strVal(BlockNode n, String key) {
    final v = _p(n, key);
    if (!_varRefPattern.hasMatch(v)) return '"$v"';
    // 纯变量引用: ${param.thisObject}
    final m = _varRefPattern.firstMatch(v);
    if (m != null && m.group(0) == v) return m.group(1)!;
    // 混合内容: 用 JS 模板字符串
    final escaped = v.replaceAllMapped(_varRefPattern, (m) => '\${${m.group(1)}}');
    return '`$escaped`';
  }

  // ── Hook 生成器 ──

  static String _genHookMethod(BlockNode n, String i, int level) {
    final cls = _p(n, 'className');
    final method = _p(n, 'methodName');
    final pts = _paramTypesArr(n);
    final v = '_cls_${n.id}';
    final beforeBody = _genSlot(n, 'before', level + 2);
    final afterBody = _genSlot(n, 'after', level + 2);
    return '${i}var $v = Jx.use("$cls");\n'
        '$i$v.hook("$method", $pts, {\n'
        '${_indent(level + 1)}before: function(param) {\n'
        '$beforeBody'
        '${_indent(level + 1)}},\n'
        '${_indent(level + 1)}after: function(param) {\n'
        '$afterBody'
        '${_indent(level + 1)}}\n'
        '$i});';
  }

  static String _genHookSingle(BlockNode n, String i, int level, String timing) {
    final cls = _p(n, 'className');
    final method = _p(n, 'methodName');
    final pts = _paramTypesArr(n);
    final v = '_cls_${n.id}';
    final body = _genSlot(n, 'body', level + 1);
    return '${i}var $v = Jx.use("$cls");\n'
        '$i$v.$timing("$method", $pts, function(param) {\n'
        '$body'
        '$i});';
  }

  static String _genHookConstructor(BlockNode n, String i, int level) {
    final cls = _p(n, 'className');
    final pts = _paramTypesArr(n);
    final v = '_cls_${n.id}';
    final beforeBody = _genSlot(n, 'before', level + 2);
    final afterBody = _genSlot(n, 'after', level + 2);
    return '${i}var $v = Jx.use("$cls");\n'
        '$i$v.hookConstructor($pts, {\n'
        '${_indent(level + 1)}before: function(param) {\n'
        '$beforeBody'
        '${_indent(level + 1)}},\n'
        '${_indent(level + 1)}after: function(param) {\n'
        '$afterBody'
        '${_indent(level + 1)}}\n'
        '$i});';
  }

  static String _genConstructorSingle(
    BlockNode n, String i, int level, String fn,
  ) {
    final cls = _p(n, 'className');
    final pts = _paramTypesArr(n);
    final v = '_cls_${n.id}';
    final body = _genSlot(n, 'body', level + 1);
    return '${i}var $v = Jx.use("$cls");\n'
        '$i$v.$fn($pts, function(param) {\n'
        '$body'
        '$i});';
  }

  static String _genHookAllMethods(BlockNode n, String i, int level) {
    final cls = _p(n, 'className');
    final method = _p(n, 'methodName');
    final v = '_cls_${n.id}';
    final beforeBody = _genSlot(n, 'before', level + 2);
    final afterBody = _genSlot(n, 'after', level + 2);
    return '${i}var $v = Jx.use("$cls");\n'
        '$i$v.hookAllMethods("$method", {\n'
        '${_indent(level + 1)}before: function(param) {\n'
        '$beforeBody'
        '${_indent(level + 1)}},\n'
        '${_indent(level + 1)}after: function(param) {\n'
        '$afterBody'
        '${_indent(level + 1)}}\n'
        '$i});';
  }

  static String _genHookAllConstructors(BlockNode n, String i, int level) {
    final cls = _p(n, 'className');
    final v = '_cls_${n.id}';
    final beforeBody = _genSlot(n, 'before', level + 2);
    final afterBody = _genSlot(n, 'after', level + 2);
    return '${i}var $v = Jx.use("$cls");\n'
        '$i$v.hookAllConstructors({\n'
        '${_indent(level + 1)}before: function(param) {\n'
        '$beforeBody'
        '${_indent(level + 1)}},\n'
        '${_indent(level + 1)}after: function(param) {\n'
        '$afterBody'
        '${_indent(level + 1)}}\n'
        '$i});';
  }

  static String _genReturnConst(BlockNode n, String i) {
    final cls = _p(n, 'className');
    final method = _p(n, 'methodName');
    final pts = _paramTypesArr(n);
    final ct = _p(n, 'constType');
    final cv = _p(n, 'constValue');
    String jsVal;
    switch (ct) {
      case 'string': jsVal = jsonEncode(cv);
      case 'null': jsVal = 'null';
      case 'bool': jsVal = cv.toLowerCase() == 'true' ? 'true' : 'false';
      default: jsVal = cv.isEmpty ? '0' : cv;
    }
    return '${i}Jx.use("$cls").returnConst("$method", $pts, $jsVal);';
  }

  static String _genGetField(BlockNode n, String i) {
    final cls = _p(n, 'className');
    final f = _p(n, 'fieldName');
    final v = _p(n, 'varName');
    if (cls.isNotEmpty) return '${i}var $v = Jx.use("$cls").getField("$f");';
    return '${i}var $v = Jx.wrap(param.thisObject).getField("$f");';
  }

  static String _genSetField(BlockNode n, String i) {
    final cls = _p(n, 'className');
    final f = _p(n, 'fieldName');
    final val = _p(n, 'value');
    if (cls.isNotEmpty) return '${i}Jx.use("$cls").setField("$f", $val);';
    return '${i}Jx.wrap(param.thisObject).setField("$f", $val);';
  }

  static String _genCallMethod(BlockNode n, String i) {
    final m = _p(n, 'methodName');
    final args = _p(n, 'args');
    final v = _p(n, 'varName');
    final call = 'Jx.wrap(param.thisObject).call("$m"${args.isNotEmpty ? ', $args' : ''})';
    return v.isNotEmpty ? '${i}var $v = $call;' : '$i$call;';
  }

  static String _genCallMethodTyped(BlockNode n, String i) {
    final m = _p(n, 'methodName');
    final pts = _paramTypesArr(n);
    final args = _p(n, 'args');
    final v = _p(n, 'varName');
    final call = 'Jx.wrap(param.thisObject).callTyped("$m", $pts, [$args])';
    return v.isNotEmpty ? '${i}var $v = $call;' : '$i$call;';
  }

  static String _genCallStatic(BlockNode n, String i) {
    final cls = _p(n, 'className');
    final m = _p(n, 'methodName');
    final pts = _paramTypesArr(n);
    final args = _p(n, 'args');
    final v = _p(n, 'varName');
    final call = 'Jx.use("$cls").callTyped("$m", $pts, [$args])';
    return v.isNotEmpty ? '${i}var $v = $call;' : '$i$call;';
  }

  static String _genCallStaticAuto(BlockNode n, String i) {
    final cls = _p(n, 'className');
    final m = _p(n, 'methodName');
    final args = _p(n, 'args');
    final v = _p(n, 'varName');
    final call = 'Jx.use("$cls").call("$m"${args.isNotEmpty ? ', $args' : ''})';
    return v.isNotEmpty ? '${i}var $v = $call;' : '$i$call;';
  }

  static String _genNewInstance(BlockNode n, String i) {
    final cls = _p(n, 'className');
    final args = _p(n, 'args');
    final v = _p(n, 'varName');
    return '${i}var $v = Jx.use("$cls").newInstance($args);';
  }

  static String _genNewInstanceTyped(BlockNode n, String i) {
    final cls = _p(n, 'className');
    final pts = _paramTypesArr(n);
    final args = _p(n, 'args');
    final v = _p(n, 'varName');
    return '${i}var $v = Jx.use("$cls").newInstanceTyped($pts, [$args]);';
  }

  static String _genIfBlock(BlockNode n, String i, int level) {
    final cond = _p(n, 'condition');
    final thenBody = _genSlot(n, 'then', level + 1);
    final elseBody = _genSlot(n, 'else', level + 1);
    final buf = StringBuffer();
    buf.writeln('${i}if ($cond) {');
    buf.write(thenBody);
    if (elseBody.isNotEmpty) {
      buf.writeln('$i} else {');
      buf.write(elseBody);
    }
    buf.write('$i}');
    return buf.toString();
  }

  static String _genForLoop(BlockNode n, String i, int level) {
    final v = _p(n, 'varName');
    final from = _p(n, 'from');
    final to = _p(n, 'to');
    final body = _genSlot(n, 'body', level + 1);
    return '${i}for (var $v = $from; $v < $to; $v++) {\n'
        '$body'
        '$i}';
  }
}