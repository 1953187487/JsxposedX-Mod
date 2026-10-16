import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_file_store.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/generated/shell.g.dart';

Future<ShellResult> _executeRootShell(
  String command, {
  int timeoutSeconds = 20,
}) {
  return ShellNative().executeShell(command, true, timeoutSeconds);
}

String _formatShellFailure(ShellResult result, {required bool isZh}) {
  final detail = result.stderr.trim().isNotEmpty
      ? result.stderr.trim()
      : result.stdout.trim();
  return isZh
      ? 'root shell 执行失败（退出码 ${result.exitCode}）：$detail'
      : 'Root shell failed (exit code ${result.exitCode}): $detail';
}

// ═══ 基类 ═══

abstract class MultimodalHandler implements AiChatToolHandler {
  const MultimodalHandler(this.context);

  final ApkReverseToolRuntimeContext context;

  String get _pkg => context.packageName;

  bool get _isZh => context.isZh;
}

// ═══ E1. capture_screenshot（P2） ═══

class CaptureScreenshotHandler extends MultimodalHandler {
  const CaptureScreenshotHandler(super.context);

  @override
  String get toolName => 'capture_screenshot';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final fileName = AiToolFileStore.timestamped('shot', 'png');
    final targetPath = await AiToolFileStore.preparePath(
      category: 'screenshots',
      fileName: fileName,
    );

    // root shell 以 screencap 直接写入应用私有目录；失败时回退到 tmp 再拷贝。
    final direct = await _executeRootShell('screencap -p "$targetPath"');
    if (direct.exitCode != 0) {
      final tmpPath = '/data/local/tmp/$fileName';
      final fallback = await _executeRootShell(
        'screencap -p "$tmpPath" && cp "$tmpPath" "$targetPath" && rm -f "$tmpPath"',
      );
      if (fallback.exitCode != 0) {
        return _formatShellFailure(fallback, isZh: _isZh);
      }
    }

    final bytes = await AiToolFileStore.readBytes(targetPath);
    if (bytes == null || bytes.isEmpty) {
      return _isZh
          ? '截图失败：未生成有效文件，请确认设备已 root'
          : 'Screenshot failed: no valid file produced. Ensure the device is rooted.';
    }

    final sizeKb = (bytes.length / 1024).toStringAsFixed(1);
    return _isZh
        ? '截图已保存到: $targetPath\n文件大小: $sizeKb KB\n提示：该文件为 PNG 图像，可使用图片查看器打开。'
        : 'Screenshot saved to: $targetPath\nFile size: $sizeKb KB\nTip: PNG image; open with an image viewer.';
  }
}

// ═══ E2. dump_ui_hierarchy（P2） ═══

class DumpUiHierarchyHandler extends MultimodalHandler {
  const DumpUiHierarchyHandler(super.context);

  @override
  String get toolName => 'dump_ui_hierarchy';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final maxDepth = call.getInt('maxDepth', 0);
    final filterById = call.getString('filterById').trim();

    final tmpPath = '/data/local/tmp/ui_dump_${DateTime.now().millisecondsSinceEpoch}.xml';
    final result = await _executeRootShell(
      'uiautomator dump "$tmpPath" >/dev/null 2>&1 && cat "$tmpPath" && rm -f "$tmpPath"',
      timeoutSeconds: 30,
    );
    if (result.exitCode != 0 || result.stdout.trim().isEmpty) {
      return _isZh
          ? 'UI 层级 dump 失败：uiautomator 不可用或当前无可 dump 的界面'
          : 'UI hierarchy dump failed: uiautomator unavailable or no dumpable UI';
    }

    final xml = result.stdout.trim();
    final formatted = _formatHierarchy(
      xml,
      maxDepth: maxDepth,
      filterById: filterById,
    );

    // 同时落盘一份供后续查看
    final fileName = AiToolFileStore.timestamped('ui_dump', 'xml');
    final file = await AiToolFileStore.writeText(
      category: 'ui_dumps',
      fileName: fileName,
      content: xml,
    );

    final header = _isZh
        ? 'UI 层级已 dump（完整 XML 已保存到: ${file.path}）：\n\n'
        : 'UI hierarchy dumped (full XML saved to: ${file.path}):\n\n';
    return '$header$formatted';
  }

  /// 将 uiautomator XML 转为缩进的类名/id/文本清单，支持深度与 id 过滤。
  String _formatHierarchy(
    String xml, {
    required int maxDepth,
    required String filterById,
  }) {
    final tokenRegex = RegExp(r'<node\b[^>]*>|</node>');
    final attrRegex = RegExp(r'(\w[\w-]*)="([^"]*)"');
    final buffer = StringBuffer();
    var depth = 0;
    var count = 0;

    for (final match in tokenRegex.allMatches(xml)) {
      final token = match.group(0)!;
      if (token == '</node>') {
        if (depth > 0) depth--;
        continue;
      }

      final attrs = <String, String>{};
      for (final attr in attrRegex.allMatches(token)) {
        attrs[attr.group(1)!] = attr.group(2)!;
      }
      final id = attrs['resource-id'] ?? '';
      final cls = attrs['class'] ?? '';
      final text = attrs['text'] ?? '';
      final desc = attrs['content-desc'] ?? '';

      final matchesFilter = filterById.isEmpty || id.contains(filterById);
      final withinDepth = maxDepth <= 0 || depth < maxDepth;
      if (matchesFilter && withinDepth) {
        final shortCls = cls.contains('.') ? cls.split('.').last : cls;
        final parts = <String>[
          if (shortCls.isNotEmpty) shortCls,
          if (id.isNotEmpty) '#$id',
          if (text.isNotEmpty) 'text="$text"',
          if (desc.isNotEmpty) 'desc="$desc"',
        ];
        buffer.writeln('${'  ' * depth}- ${parts.join(' ')}');
        count++;
      }
      depth++;
    }

    if (count == 0) {
      return _isZh ? '（无匹配节点）' : '(no matching nodes)';
    }
    return buffer.toString().trimRight();
  }
}

// ═══ E3. extract_apk_resource（P2） ═══

class ExtractApkResourceHandler extends MultimodalHandler {
  const ExtractApkResourceHandler(super.context);

  @override
  String get toolName => 'extract_apk_resource';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final resourcePath = call.getString('resourcePath').trim();
    if (resourcePath.isEmpty) {
      throw ArgumentError(_isZh ? 'resourcePath 不能为空' : 'resourcePath is required');
    }
    if (_pkg.isEmpty) {
      throw ArgumentError(_isZh ? '当前无目标应用' : 'No target app');
    }

    // 1. 定位 APK 路径（pm path 输出形如 package:/data/app/.../base.apk）
    final pathResult = await _executeRootShell('pm path $_pkg');
    if (pathResult.exitCode != 0) {
      return _formatShellFailure(pathResult, isZh: _isZh);
    }
    final apkPath = pathResult.stdout
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.startsWith('package:'))
        .map((line) => line.substring('package:'.length))
        .firstOrNull;
    if (apkPath == null || apkPath.isEmpty) {
      return _isZh ? '未找到目标应用 APK 路径: $_pkg' : 'APK path not found for: $_pkg';
    }

    // 2. 用 unzip 从 APK 中提取指定资源（-p 输出到 stdout）
    final innerPath = resourcePath.replaceFirst(RegExp(r'^/'), '');
    final fileName = AiToolFileStore.sanitizeFileName(
      innerPath.replaceAll('/', '_'),
    );
    final targetPath = await AiToolFileStore.preparePath(
      category: 'apk_resources',
      fileName: fileName,
    );

    final unzip = await _executeRootShell(
      'unzip -p "$apkPath" "$innerPath" > "$targetPath"',
      timeoutSeconds: 30,
    );
    if (unzip.exitCode != 0) {
      return _isZh
          ? '资源提取失败：APK 中可能不存在 "$resourcePath"（或设备缺 unzip）'
          : 'Extraction failed: "$resourcePath" not found in APK (or unzip missing)';
    }

    final bytes = await AiToolFileStore.readBytes(targetPath);
    if (bytes == null || bytes.isEmpty) {
      return _isZh
          ? '资源提取失败：APK 中未找到 "$resourcePath"'
          : 'Extraction failed: "$resourcePath" not found in APK';
    }

    final sizeKb = (bytes.length / 1024).toStringAsFixed(1);
    return _isZh
        ? '资源已提取到: $targetPath\n来源 APK: $apkPath\n内部路径: $innerPath\n文件大小: $sizeKb KB'
        : 'Resource extracted to: $targetPath\nSource APK: $apkPath\nInner path: $innerPath\nFile size: $sizeKb KB';
  }
}
