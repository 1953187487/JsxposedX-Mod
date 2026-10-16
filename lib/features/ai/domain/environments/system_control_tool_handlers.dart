import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';
import 'package:JsxposedX/generated/shell.g.dart';

Future<ShellResult> _executeRootShell(
  String command, {
  int timeoutSeconds = 15,
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

abstract class SystemControlHandler implements AiChatToolHandler {
  const SystemControlHandler(this.context);

  final ApkReverseToolRuntimeContext context;

  String get _pkg => context.packageName;

  bool get _isZh => context.isZh;
}

// ═══ D1. read_file ═══

class ReadFileToolHandler extends SystemControlHandler {
  const ReadFileToolHandler(super.context);

  @override
  String get toolName => 'read_file';

  static const _imageExts = {
    '.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp',
  };

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final path = call.getString('path').trim();
    if (path.isEmpty) {
      throw ArgumentError(_isZh ? 'path 不能为空' : 'path is required');
    }
    final maxBytes = call.getInt('maxBytes', 65536).clamp(1024, 2 * 1024 * 1024);

    final lower = path.toLowerCase();
    final isImage = _imageExts.any(lower.endsWith);

    // 先探测文件是否存在与大小
    final stat = await _executeRootShell(
      'if [ -f "$path" ]; then stat -c "%s" "$path"; elif [ -d "$path" ]; then echo DIR; else echo MISSING; fi',
    );
    if (stat.exitCode != 0) {
      return _formatShellFailure(stat, isZh: _isZh);
    }
    final statOut = stat.stdout.trim();
    if (statOut == 'MISSING') {
      return _isZh ? '文件不存在: $path' : 'File not found: $path';
    }
    if (statOut == 'DIR') {
      final ls = await _executeRootShell('ls -la "$path"');
      return _isZh
          ? '这是一目录，其内容如下：\n\n${ls.stdout.trim()}'
          : 'This is a directory. Contents:\n\n${ls.stdout.trim()}';
    }

    if (isImage) {
      return _isZh
          ? '这是一个图片文件: $path\n大小: ${_humanSize(int.tryParse(statOut) ?? 0)}\n提示：图片无法以文本返回，可在对话中点击该路径查看。'
          : 'This is an image file: $path\nSize: ${_humanSize(int.tryParse(statOut) ?? 0)}\nTip: images cannot be returned as text; tap the path in chat to view.';
    }

    // 文本类：截断到 maxBytes，避免超大文件撑爆上下文
    final total = int.tryParse(statOut) ?? 0;
    final result = await _executeRootShell(
      'head -c $maxBytes "$path"',
      timeoutSeconds: 20,
    );
    if (result.exitCode != 0) {
      return _formatShellFailure(result, isZh: _isZh);
    }
    final truncated = total > maxBytes;
    final header = _isZh
        ? '文件: $path\n大小: ${_humanSize(total)}${truncated ? "（已截断至 ${_humanSize(maxBytes)}）" : ""}\n\n'
        : 'File: $path\nSize: ${_humanSize(total)}${truncated ? " (truncated to ${_humanSize(maxBytes)})" : ""}\n\n';
    return '$header${result.stdout}';
  }

  String _humanSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

// ═══ D2. get_device_info（P1） ═══

class GetDeviceInfoHandler extends SystemControlHandler {
  const GetDeviceInfoHandler(super.context);

  @override
  String get toolName => 'get_device_info';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final buf = StringBuffer();
    buf.writeln(_isZh ? '## 设备信息\n' : '## Device Info\n');

    buf.writeln(_isZh ? '- **目标包**: $_pkg' : '- **Target**: $_pkg');

    buf.writeln(
      _isZh
          ? '- **设备架构/ABI**: arm64-v8a (默认)'
          : '- **Arch/ABI**: arm64-v8a (default)',
    );
    final result = await _executeRootShell(
      'printf "ANDROID_VERSION="; getprop ro.build.version.release; '
      'printf "ROOT_ID="; id; '
      'printf "ABI="; getprop ro.product.cpu.abi; '
      'printf "ZYGISK="; getprop ro.product.mod_device; '
      'printf "LSPOSED="; pm list packages | grep -E "lsp|zygisk" || true',
    );
    if (result.exitCode != 0) {
      buf.writeln(_formatShellFailure(result, isZh: _isZh));
    } else {
      buf.writeln(result.stdout.trim());
    }

    return buf.toString().trimRight();
  }
}

// ═══ D2. launch/stop_target_app（P1） ═══

class TargetAppControlHandler extends SystemControlHandler {
  const TargetAppControlHandler(super.context);

  @override
  String get toolName => 'target_app_control';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    if (_pkg.isEmpty) {
      throw ArgumentError(_isZh ? '当前无目标应用' : 'No target app');
    }

    final action = call.getString('action', 'launch');

    final command = switch (action) {
      'launch' => 'monkey -p $_pkg -c android.intent.category.LAUNCHER 1',
      'stop' => 'am force-stop $_pkg',
      'restart' =>
        'am force-stop $_pkg; monkey -p $_pkg -c android.intent.category.LAUNCHER 1',
      _ => throw ArgumentError(
        _isZh
            ? 'action 仅支持 launch/stop/restart'
            : 'action must be launch/stop/restart',
      ),
    };
    final result = await _executeRootShell(command);
    if (result.exitCode != 0) {
      return _formatShellFailure(result, isZh: _isZh);
    }
    return _isZh ? '$action $_pkg 执行成功' : '$action $_pkg succeeded';
  }
}

// ═══ D3. list_installed_apps（P2） ═══

class ListInstalledAppsHandler extends SystemControlHandler {
  const ListInstalledAppsHandler(super.context);

  @override
  String get toolName => 'list_installed_apps';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final keyword = call.getString('keyword').trim();
    final includeSystem = call.getBool('includeSystem');
    final result = await _executeRootShell('pm list packages');
    if (result.exitCode != 0) {
      return _formatShellFailure(result, isZh: _isZh);
    }

    var packages = result.stdout
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.startsWith('package:'))
        .map((line) => line.substring('package:'.length))
        .where(
          (packageName) =>
              includeSystem || !packageName.startsWith('com.android.'),
        )
        .where(
          (packageName) => keyword.isEmpty || packageName.contains(keyword),
        )
        .toList();
    packages.sort();
    return packages.isEmpty
        ? (_isZh ? '未找到匹配的已装应用' : 'No matching installed apps')
        : packages.join('\n');
  }
}

// ═══ D4. read_target_logs（P2） ═══

class ReadTargetLogsHandler extends SystemControlHandler {
  const ReadTargetLogsHandler(super.context);

  @override
  String get toolName => 'read_target_logs';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    if (_pkg.isEmpty) {
      throw ArgumentError(_isZh ? '当前无目标应用' : 'No target app');
    }

    final keyword = call.getString('keyword').trim();
    final level = call.getString('level').trim().toUpperCase();
    final limit = call.getInt('limit', 200).clamp(1, 1000);
    final includeFramework = call.getBool('includeFramework');

    final pidResult = await _executeRootShell('pidof $_pkg');
    if (pidResult.exitCode != 0 || pidResult.stdout.trim().isEmpty) {
      return _isZh
          ? '目标应用当前未运行，无法按进程读取日志：$_pkg'
          : 'Target app is not running; cannot read process logs: $_pkg';
    }
    final pids = pidResult.stdout.trim().split(RegExp(r'\s+')).toSet();
    final captureLimit = (limit * 10).clamp(200, 5000);
    final result = await _executeRootShell(
      'logcat -d -v threadtime -t $captureLimit',
      timeoutSeconds: 20,
    );
    if (result.exitCode != 0) {
      return _formatShellFailure(result, isZh: _isZh);
    }

    final lines = result.stdout
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .where((line) {
          if (includeFramework) {
            // 包含框架日志：匹配目标应用 PID 或框架相关 tag
            final columns = line.trim().split(RegExp(r'\s+'));
            final hasPid = columns.length >= 4 && pids.contains(columns[2]);
            final hasFrameworkTag = line.contains('JsxposedX') ||
                line.contains('Jsxposed') ||
                line.contains('Xposed') ||
                line.contains('EdXposed') ||
                line.contains('LSPosed');
            return hasPid || hasFrameworkTag;
          } else {
            // 仅目标应用进程日志
            final columns = line.trim().split(RegExp(r'\s+'));
            return columns.length >= 4 && pids.contains(columns[2]);
          }
        })
        .where(
          (line) =>
              level.isEmpty ||
              RegExp('\\s${RegExp.escape(level)}\\s').hasMatch(line),
        )
        .where(
          (line) =>
              keyword.isEmpty ||
              line.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();
    if (lines.isEmpty) {
      return _isZh ? '未找到匹配的日志' : 'No matching logs found';
    }
    final start = lines.length > limit ? lines.length - limit : 0;
    return lines.sublist(start).join('\n');
  }
}

// ═══ D5. read_framework_logs（P2） ═══

class ReadFrameworkLogsHandler extends SystemControlHandler {
  const ReadFrameworkLogsHandler(super.context);

  @override
  String get toolName => 'read_framework_logs';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final keyword = call.getString('keyword').trim();
    final level = call.getString('level').trim().toUpperCase();
    final limit = call.getInt('limit', 200).clamp(1, 1000);
    final scriptType = call.getString('scriptType').trim().toLowerCase();

    final captureLimit = (limit * 10).clamp(200, 5000);
    final result = await _executeRootShell(
      'logcat -d -v threadtime -t $captureLimit',
      timeoutSeconds: 20,
    );
    if (result.exitCode != 0) {
      return _formatShellFailure(result, isZh: _isZh);
    }

    final lines = result.stdout
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .where((line) {
          // 匹配框架相关的 tag 或内容
          if (scriptType == 'xposed') {
            return line.contains('JsxposedX') ||
                line.contains('Jsxposed') ||
                line.contains('Xposed') ||
                line.contains('EdXposed') ||
                line.contains('LSPosed');
          } else if (scriptType == 'frida') {
            return line.contains('Frida') || line.contains('frida');
          } else {
            // 两者都包含
            return line.contains('JsxposedX') ||
                line.contains('Jsxposed') ||
                line.contains('Xposed') ||
                line.contains('EdXposed') ||
                line.contains('LSPosed') ||
                line.contains('Frida') ||
                line.contains('frida');
          }
        })
        .where(
          (line) =>
              level.isEmpty ||
              RegExp('\\s${RegExp.escape(level)}\\s').hasMatch(line),
        )
        .where(
          (line) =>
              keyword.isEmpty ||
              line.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();

    if (lines.isEmpty) {
      return _isZh
          ? '未找到匹配的框架日志\n提示：确保 Xposed/Frida 框架正在运行且脚本已启用'
          : 'No matching framework logs found\nTip: Ensure Xposed/Frida framework is running and scripts are enabled';
    }
    final start = lines.length > limit ? lines.length - limit : 0;
    return lines.sublist(start).join('\n');
  }
}
