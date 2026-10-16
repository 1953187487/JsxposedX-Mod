import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';

/// APK 逆向工具 handler 基类。
///
/// 运行时上下文见 [ApkReverseToolRuntimeContext]（ai_tool_runtime_context.dart）；
/// schema/handler/策略的配对注册见 AiToolRegistry。
/// 注意：handler 不允许内部 try/catch 吞错返回"失败"字符串，
/// 异常一律抛给 ToolExecutor 统一映射错误码（封装标准 §4.3）。
abstract class ApkReverseToolHandlerBase implements AiChatToolHandler {
  const ApkReverseToolHandlerBase(this.context);

  final ApkReverseToolRuntimeContext context;
}

class GetManifestToolHandler extends ApkReverseToolHandlerBase {
  const GetManifestToolHandler(super.context);

  @override
  String get toolName => 'get_manifest';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final manifest = await context.repo.parseManifest(context.sessionId);
    final apkContext = AiApkContext.fromManifest(manifest);
    return apkContext.toPromptText(isZh: context.isZh);
  }
}

class DecompileClassToolHandler extends ApkReverseToolHandlerBase {
  const DecompileClassToolHandler(super.context);

  @override
  String get toolName => 'decompile_class';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final className = call.getString('className');
    if (className.isEmpty) {
      throw ArgumentError('className 不能为空');
    }
    return context.repo.decompileClass(
      context.sessionId,
      context.dexPaths,
      className,
    );
  }
}

class GetSmaliToolHandler extends ApkReverseToolHandlerBase {
  const GetSmaliToolHandler(super.context);

  @override
  String get toolName => 'get_smali';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final className = call.getString('className');
    if (className.isEmpty) {
      throw ArgumentError('className 不能为空');
    }
    return context.repo.getClassSmali(
      context.sessionId,
      context.dexPaths,
      className,
    );
  }
}

class ListPackagesToolHandler extends ApkReverseToolHandlerBase {
  const ListPackagesToolHandler(super.context);

  @override
  String get toolName => 'list_packages';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final prefix = call.getString('prefix');
    final packages = await context.repo.getDexPackages(
      context.sessionId,
      context.dexPaths,
      prefix,
    );
    if (packages.isEmpty) {
      return '未找到子包 (prefix: "$prefix")';
    }
    return packages.join('\n');
  }
}

class ListClassesToolHandler extends ApkReverseToolHandlerBase {
  const ListClassesToolHandler(super.context);

  @override
  String get toolName => 'list_classes';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final packageName = call.getString('packageName');
    final classes = await context.repo.getDexClasses(
      context.sessionId,
      context.dexPaths,
      packageName,
    );
    if (classes.isEmpty) {
      return '未找到类 (package: "$packageName")';
    }

    final buffer = StringBuffer();
    for (final cls in classes) {
      final tags = <String>[];
      if (cls.isAbstract) tags.add('abstract');
      if (cls.isInterface) tags.add('interface');
      if (cls.isEnum) tags.add('enum');
      final tagStr = tags.isNotEmpty ? ' [${tags.join(", ")}]' : '';
      buffer.writeln(
        '${cls.className}$tagStr — ${cls.methodCount} methods, ${cls.fieldCount} fields',
      );
      if (cls.superClass != null && cls.superClass != 'java.lang.Object') {
        buffer.writeln('  extends ${cls.superClass}');
      }
      if (cls.interfaces.isNotEmpty) {
        final interfaces = cls.interfaces.whereType<String>().toList();
        if (interfaces.isNotEmpty) {
          buffer.writeln('  implements ${interfaces.join(", ")}');
        }
      }
    }
    return buffer.toString();
  }
}

class SearchClassesToolHandler extends ApkReverseToolHandlerBase {
  const SearchClassesToolHandler(super.context);

  @override
  String get toolName => 'search_classes';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final keyword = call.getString('keyword');
    if (keyword.isEmpty) {
      throw ArgumentError('keyword 不能为空');
    }
    final results = await context.repo.searchDexClasses(
      context.sessionId,
      context.dexPaths,
      keyword,
    );
    if (results.isEmpty) {
      return '未找到包含关键词 "$keyword" 的类';
    }
    return '共找到 ${results.length} 个匹配类：\n${results.join('\n')}';
  }
}

class ListApkFilesToolHandler extends ApkReverseToolHandlerBase {
  const ListApkFilesToolHandler(super.context);

  @override
  String get toolName => 'list_apk_files';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final path = call.getString('path');
    final items = await context.repo.getApkAssetsAt(context.sessionId, path);
    if (items.isEmpty) {
      return '目录为空: "$path"';
    }

    final buffer = StringBuffer();
    buffer.writeln('路径: "$path" 下共 ${items.length} 个条目：\n');
    for (final item in items) {
      if (item.isDirectory) {
        buffer.writeln('[DIR]  ${item.path}');
        continue;
      }
      final kb = item.size > 0
          ? ' (${(item.size / 1024).toStringAsFixed(1)}KB)'
          : '';
      buffer.writeln('[FILE] ${item.path}$kb');
    }
    return buffer.toString();
  }
}

class GetSoInfoToolHandler extends ApkReverseToolHandlerBase {
  const GetSoInfoToolHandler(super.context);

  @override
  String get toolName => 'get_so_info';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final soPath = call.getString('soPath');
    if (soPath.isEmpty) {
      throw ArgumentError('soPath 不能为空');
    }

    final header = await context.soDataSource.parseSoHeader(
      context.sessionId,
      soPath,
    );
    final deps = await context.soDataSource.getDependencies(
      context.sessionId,
      soPath,
    );
    final exportedSymbols = await context.soDataSource.getExportedSymbols(
      context.sessionId,
      soPath,
    );
    final importedSymbols = await context.soDataSource.getImportedSymbols(
      context.sessionId,
      soPath,
    );
    final jniFunctions = await context.soDataSource.getJniFunctions(
      context.sessionId,
      soPath,
    );

    final buffer = StringBuffer();
    buffer.writeln('SO 文件: $soPath');
    buffer.writeln('\n【ELF 头信息】');
    buffer.writeln('架构: ${header.machine}');
    buffer.writeln('类型: ${header.classType}');
    buffer.writeln('字节序: ${header.dataEncoding}');
    buffer.writeln('OS/ABI: ${header.osAbi}');
    buffer.writeln('文件类型: ${header.fileType}');
    buffer.writeln('入口点: 0x${header.entryPoint.toRadixString(16)}');

    if (deps.isNotEmpty) {
      buffer.writeln('\n【依赖库】(${deps.length}个)');
      for (final dep in deps) {
        buffer.writeln('  - ${dep.name}');
      }
    }

    buffer.writeln('\n【符号统计】');
    buffer.writeln('导出符号: ${exportedSymbols.length} 个');
    buffer.writeln('导入符号: ${importedSymbols.length} 个');
    buffer.writeln('JNI 函数: ${jniFunctions.length} 个');
    return buffer.toString();
  }
}

class SearchSoSymbolsToolHandler extends ApkReverseToolHandlerBase {
  const SearchSoSymbolsToolHandler(super.context);

  @override
  String get toolName => 'search_so_symbols';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final soPath = call.getString('soPath');
    final keyword = call.getString('keyword');
    if (soPath.isEmpty) {
      throw ArgumentError('soPath 不能为空');
    }
    if (keyword.isEmpty) {
      throw ArgumentError('keyword 不能为空');
    }

    final exported = await context.soDataSource.getExportedSymbols(
      context.sessionId,
      soPath,
    );
    final imported = await context.soDataSource.getImportedSymbols(
      context.sessionId,
      soPath,
    );
    final lowerKeyword = keyword.toLowerCase();
    final matchedExported = exported
        .where((symbol) => symbol.name.toLowerCase().contains(lowerKeyword))
        .take(50)
        .toList(growable: false);
    final matchedImported = imported
        .where((symbol) => symbol.name.toLowerCase().contains(lowerKeyword))
        .take(50)
        .toList(growable: false);

    if (matchedExported.isEmpty && matchedImported.isEmpty) {
      return '未找到包含关键词 "$keyword" 的符号';
    }

    final buffer = StringBuffer();
    buffer.writeln('搜索关键词: "$keyword"');
    if (matchedExported.isNotEmpty) {
      buffer.writeln('\n【导出符号】(${matchedExported.length}个)');
      for (final symbol in matchedExported) {
        buffer.writeln(symbol.name);
        buffer.writeln(
          '  类型: ${symbol.type}, 绑定: ${symbol.binding}, 地址: 0x${symbol.address.toRadixString(16)}',
        );
      }
    }
    if (matchedImported.isNotEmpty) {
      buffer.writeln('\n【导入符号】(${matchedImported.length}个)');
      for (final symbol in matchedImported) {
        buffer.writeln(symbol.name);
        buffer.writeln('  类型: ${symbol.type}, 绑定: ${symbol.binding}');
      }
    }
    return buffer.toString();
  }
}

class GetJniFunctionsToolHandler extends ApkReverseToolHandlerBase {
  const GetJniFunctionsToolHandler(super.context);

  @override
  String get toolName => 'get_jni_functions';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final soPath = call.getString('soPath');
    if (soPath.isEmpty) {
      throw ArgumentError('soPath 不能为空');
    }

    final jniFunctions = await context.soDataSource.getJniFunctions(
      context.sessionId,
      soPath,
    );
    if (jniFunctions.isEmpty) {
      return '未找到 JNI 函数';
    }

    final buffer = StringBuffer();
    buffer.writeln('共找到 ${jniFunctions.length} 个 JNI 函数：\n');
    for (final function in jniFunctions) {
      buffer.writeln('${function.javaClass}.${function.javaMethod}');
      buffer.writeln('  符号: ${function.symbolName}');
      buffer.writeln('  地址: 0x${function.address.toRadixString(16)}');
      buffer.writeln('  类型: ${function.isDynamic ? "动态注册" : "静态注册"}');
      if (function.signature != null) {
        buffer.writeln('  签名: ${function.signature}');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}

class SearchSoStringsToolHandler extends ApkReverseToolHandlerBase {
  const SearchSoStringsToolHandler(super.context);

  @override
  String get toolName => 'search_so_strings';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final soPath = call.getString('soPath');
    final keyword = call.getString('keyword');
    if (soPath.isEmpty) {
      throw ArgumentError('soPath 不能为空');
    }
    if (keyword.isEmpty) {
      throw ArgumentError('keyword 不能为空');
    }

    final strings = await context.soDataSource.getSoStrings(
      context.sessionId,
      soPath,
    );
    final lowerKeyword = keyword.toLowerCase();
    final matched = strings
        .where((value) => value.value.toLowerCase().contains(lowerKeyword))
        .take(100)
        .toList(growable: false);
    if (matched.isEmpty) {
      return '未找到包含关键词 "$keyword" 的字符串';
    }

    final buffer = StringBuffer();
    buffer.writeln('搜索关键词: "$keyword"');
    buffer.writeln('共找到 ${matched.length} 个匹配字符串：\n');
    for (final value in matched) {
      buffer.writeln('"${value.value}"');
      buffer.writeln(
        '  位置: ${value.section}, 偏移: 0x${value.offset.toRadixString(16)}',
      );
      buffer.writeln();
    }
    return buffer.toString();
  }
}

class GenerateSoHookToolHandler extends ApkReverseToolHandlerBase {
  const GenerateSoHookToolHandler(super.context);

  @override
  String get toolName => 'generate_so_hook';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final soPath = call.getString('soPath');
    final symbolName = call.getString('symbolName');
    final address = call.getString('address');
    if (soPath.isEmpty) {
      throw ArgumentError('soPath 不能为空');
    }
    if (symbolName.isEmpty) {
      throw ArgumentError('symbolName 不能为空');
    }
    if (address.isEmpty) {
      throw ArgumentError('address 不能为空');
    }

    // 解析失败抛 FormatException → 执行器映射为 E_PARAM
    final parsedAddress = int.parse(
      address.replaceFirst('0x', ''),
      radix: 16,
    );
    return context.soDataSource.generateFridaHook(
      context.sessionId,
      soPath,
      symbolName,
      parsedAddress,
    );
  }
}
