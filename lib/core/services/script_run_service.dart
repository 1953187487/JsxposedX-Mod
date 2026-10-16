import 'dart:convert';

import 'package:JsxposedX/core/transport/jsxposed_protocol.dart';
import 'package:JsxposedX/core/utils/path_utils.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/frida/presentation/providers/frida_action_provider.dart';
import 'package:JsxposedX/features/xposed/presentation/providers/logcat_provider.dart';
import 'package:JsxposedX/generated/app.g.dart';
import 'package:JsxposedX/generated/pinia.g.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

/// 承接 PC 端「保存并运行」请求：注册运行记录、拉日志、必要时重启应用。
/// 逻辑与手机端脚本编辑器的运行按钮保持一致，保证两端行为统一。
class ScriptRunService {
  ScriptRunService(this._container);

  final ProviderContainer _container;

  /// 运行期间长期持有的 `logcatProvider` 订阅。PC 端触发运行时手机端日志
  /// 面板通常未挂载，provider 是 autoDispose 的会被回收并连带停掉日志采集
  /// 进程，导致 PC 端收不到任何日志。保活只在停止运行或 PC 全部断开时释放。
  static ProviderSubscription<Object?>? _runKeepAlive;

  /// 持有保活订阅；已在保活时复用，避免重复订阅。
  static void holdRunKeepAlive(ProviderContainer container) {
    _runKeepAlive ??= container.listen(logcatProvider, (_, _) {});
  }

  /// 释放保活订阅：停止运行、再次运行或 PC 全部断开时调用。
  static void releaseRunKeepAlive() {
    _runKeepAlive?.close();
    _runKeepAlive = null;
  }

  Future<void> run({
    required String packageName,
    required String source,
    required String localPath,
    required bool restartApp,
  }) async {
    final scriptName = PathUtils.getName(path: localPath);
    // logcatProvider 是 autoDispose 的，PC 端触发时手机端日志面板并未挂载，
    // 必须长期持有订阅；此前的临时订阅会在 run 返回时释放，采集进程随之被杀
    holdRunKeepAlive(_container);
    final console = _container.read(logcatProvider.notifier);
    console.configureSession(source, scriptName);

    final logs = _container.read(scriptLogRepositoryProvider);
    final conversationId = 'standalone:$packageName:$source:$scriptName';
    final runId = const Uuid().v4();
    final startedAt = DateTime.now().toUtc();
    await logs.startRun(
      runId: runId,
      conversationId: conversationId,
      source: source,
      scriptName: scriptName,
      startedAt: startedAt,
    );
    await PiniaNative().setString(
      key: 'jx_script_run_context_${packageName}_${source}_$scriptName',
      value: jsonEncode({
        'runId': runId,
        'conversationId': conversationId,
        'source': source,
        'scriptName': scriptName,
        'startedAt': startedAt.toIso8601String(),
      }),
    );

    // Frida 的 hook.js 必须先于日志监听生成，Xposed 侧由原生写入脚本时已刷新快照
    if (source == JsxposedScriptSource.frida) {
      await _container.read(
        bundleFridaHookJsProvider(packageName: packageName).future,
      );
    }
    await console.start(packageName);

    if (restartApp) {
      // 应用需在注入挂载完成后重启，才能带上新的 hook 生效
      await AppNative().openAppX(packageName);
    }
  }
}
