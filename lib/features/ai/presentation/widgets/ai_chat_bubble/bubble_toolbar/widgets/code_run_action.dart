import 'dart:convert';

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:JsxposedX/features/frida/presentation/providers/frida_action_provider.dart';
import 'package:JsxposedX/features/frida/presentation/providers/frida_query_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/xposed_action_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/xposed_query_provider.dart';
import 'package:JsxposedX/generated/app.g.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class CodeRunAction extends ConsumerWidget {
  final String code;
  final String? packageName;
  final String? scriptType;
  final String? suggestedFileName;

  const CodeRunAction({
    super.key,
    required this.code,
    required this.packageName,
    this.scriptType,
    this.suggestedFileName,
  });

  String _normalizeScriptFileName(String rawName) {
    final withExtension = rawName.endsWith('.js') ? rawName : '$rawName.js';
    return withExtension;
  }

  String _normalizeXposedTraditionFileName(String rawName) {
    final fileName = _normalizeScriptFileName(rawName);
    if (fileName.startsWith('[tradition]')) {
      return fileName;
    }
    return '[tradition]$fileName';
  }

  Future<void> _runScript(BuildContext context, WidgetRef ref) async {
    final pkg = packageName;
    if (pkg == null || pkg.isEmpty) {
      ToastMessage.show(context.l10n.apkNoAiSession);
      return;
    }

    if (scriptType == null) {
      ToastMessage.show(context.l10n.selectScriptType);
      return;
    }

    final defaultFileName = suggestedFileName?.isNotEmpty == true
        ? suggestedFileName!
        : 'ai_hook_${DateTime.now().millisecondsSinceEpoch}.js';

    final fileName = scriptType == 'xposed'
        ? _normalizeXposedTraditionFileName(defaultFileName)
        : _normalizeScriptFileName(defaultFileName);

    try {
      // 保存脚本
      if (scriptType == 'frida') {
        await ref.read(
          createFridaScriptProvider(
            packageName: pkg,
            localPath: fileName,
            content: code,
          ).future,
        );
        ref.invalidate(fridaScriptsProvider(packageName: pkg));
      } else {
        if (fileName == 'hook.js' || fileName == "hook") {
          ToastMessage.show(context.l10n.reservedScriptFileName);
          return;
        }
        await ref.read(
          createJsScriptProvider(
            packageName: pkg,
            localPath: fileName,
            content: code,
          ).future,
        );
        ref.invalidate(jsScriptsProvider(packageName: pkg));
      }

      // 启用脚本（切合原有逻辑）
      final source = scriptType == 'frida' ? 'frida' : 'xposed';
      final fullPath = scriptType == 'frida'
          ? '/data/local/tmp/JsxposedX/$pkg/$fileName'
          : '/data/user/0/com.jsxposed.xmod/app_flutter/flutter_assets/Projects/$pkg/JsProjects/$fileName';
      
      final switchKey = source == 'frida'
          ? 'frida_check_status_${pkg}_$fullPath'
          : 'xposed_check_status_${pkg}_$fullPath';

      final pinia = ref.read(piniaProvider);
      final logs = ref.read(scriptLogRepositoryProvider);
      final contextKey = 'jx_script_run_context_${pkg}_${source}_$fileName';
      
      // 创建运行记录
      final conversationId = 'standalone:$pkg:$source:$fileName';
      final runId = const Uuid().v4();
      final now = DateTime.now().toUtc();
      
      await logs.startRun(
        runId: runId,
        conversationId: conversationId,
        source: source,
        scriptName: fileName,
        startedAt: now,
      );

      try {
        // 保存运行上下文
        await pinia.setString(
          key: contextKey,
          value: jsonEncode({
            'runId': runId,
            'conversationId': conversationId,
            'source': source,
            'scriptName': fileName,
            'startedAt': now.toIso8601String(),
          }),
        );
        
        // 设置脚本开关
        await pinia.setBool(key: switchKey, value: true);
        
        // Frida 脚本需要重新打包
        if (scriptType == 'frida') {
          await ref.read(bundleFridaHookJsProvider(packageName: pkg).future);
          ref.invalidate(
            getFridaScriptStatusProvider(
              packageName: pkg,
              localPath: fullPath,
            ),
          );
        } else {
          ref.invalidate(
            getJsScriptStatusProvider(
              packageName: pkg,
              localPath: fullPath,
            ),
          );
        }

        // 脚本与开关就绪后拉起目标应用，注入才会生效
        try {
          await AppNative().openAppX(pkg);
        } catch (_) {
          // 拉起失败不阻断脚本运行状态
        }

        if (context.mounted) {
          ToastMessage.show(
            context.l10n.aiScriptRunning(
              scriptType == 'frida'
                  ? context.l10n.fridaProject
                  : context.l10n.xposedProject,
              fileName,
            ),
          );
        }
      } catch (e) {
        // 启用失败时清理上下文和运行记录
        try {
          await pinia.remove(key: contextKey);
        } finally {
          await logs.finishRun(
            runId,
            status: 'failed',
            finishedAt: DateTime.now().toUtc(),
          );
        }
        rethrow;
      }
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show(
          context.l10n.aiScriptSaveFailed(e.toString()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scale = AiChatCompactScope.scaleOf(context);
    final isDark = context.isDark;

    // 只在有脚本类型标记的 JS 代码块显示运行按钮
    if (scriptType == null) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: context.l10n.runScript,
      child: InkWell(
        onTap: () => _runScript(context, ref),
        borderRadius: BorderRadius.circular(4 * scale),
        child: Container(
          padding: EdgeInsets.all(4 * scale),
          child: Icon(
            Icons.play_arrow_rounded,
            size: 16 * scale,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      ),
    );
  }
}
