import 'dart:async';

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/app_bootstrap.dart';
import 'package:JsxposedX/core/providers/locale_provider.dart';
import 'package:JsxposedX/core/transport/android_desktop_bridge_server.dart';
import 'package:JsxposedX/core/transport/desktop_bridge_handler.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:JsxposedX/core/routes/app_router.dart';
import 'package:JsxposedX/core/services/desktop_console_service.dart';
import 'package:JsxposedX/core/services/script_run_service.dart';
import 'package:JsxposedX/features/home/presentation/pages/desktop_app.dart';
import 'package:JsxposedX/features/overlay_window/presentation/pages/overlay_sub_app.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_action_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // PC 端使用独立启动链，与手机端 Android 原生业务完全隔离
  if (isDesktopPlatform) {
    runApp(const ProviderScope(child: DesktopApp()));
    return;
  }
  
  // Android 端：注册桌面桥接处理器，供前台服务调用
  // 注意：WebSocket 服务器现在由前台服务中的原生实现托管，不再在主 Activity 中启动 Dart 版本
  final container = ProviderContainer();
  setupDesktopBridgeHandler(container);
  // 监听原生前台服务上报的连接数，首页据此显示电脑端连接状态
  const desktopConnectionChannel = MethodChannel('com.jsxposed.xmod/desktop_connection');
  desktopConnectionChannel.setMethodCallHandler((call) async {
    if (call.method == 'onConnectionCountChange') {
      AndroidDesktopBridgeServer.instance.clientCount.value =
          call.arguments as int? ?? 0;
    }
  });
  
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MainApp(),
  ));
}

/// 后台服务专用入口：只注册桥接处理器，不启动 UI
@pragma('vm:entry-point')
Future<void> backgroundServiceEntry() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  setupDesktopBridgeHandler(container);
  debugPrint('[DesktopBridge] Background service handler initialized');
}

@pragma('vm:entry-point')
Future<void> overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 悬浮窗是独立引擎，SmartDialog 未初始化，复用宿主 UI 的组件若直接调用
  // ToastMessage.show 不会显示任何内容。这里统一切到 overlay 通道提示。
  ToastMessage.override = (msg) => unawaited(ToastOverlayMessage.show(msg));
  runApp(const ProviderScope(child: OverlaySubApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    unawaited(ref.read(scriptLogRepositoryProvider).recoverInterruptedRuns());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // PC 端通过协议触发的「保存并运行」交给应用层完成注入编排。
    // 这里用 container 而非 widget ref，便于在运行期间持有 provider 订阅。
    final container = ProviderScope.containerOf(context, listen: false);
    AndroidDesktopBridgeServer.instance.scriptRunner =
        ({
          required packageName,
          required source,
          required localPath,
          required restartApp,
        }) => ScriptRunService(container).run(
          packageName: packageName,
          source: source,
          localPath: localPath,
          restartApp: restartApp,
        );
    // 控制台能力同样交给应用层：手机端 logcatProvider 是唯一真源，
    // PC 端仅通过协议转发操作并接收状态回推。
    AndroidDesktopBridgeServer.instance.consoleHost = DesktopConsoleService(
      container,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(localeProvider, (_, __) {
      unawaited(
        ref.read(overlayWindowActionProvider.notifier).syncEnvironment(),
      );
    });
    ref.listen(themeProvider, (_, __) {
      unawaited(
        ref.read(overlayWindowActionProvider.notifier).syncEnvironment(),
      );
    });
    final router = ref.watch(appRouterProvider);

    return AppBootstrap(
      builder: (context, locale, lightTheme, darkTheme, themeMode) {
        return MaterialApp.router(
          title: 'JsxposedX',
          locale: locale,
          localizationsDelegates: AppBootstrap.localizationsDelegates,
          supportedLocales: AppBootstrap.supportedLocales,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return locale;
          },
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          builder: FlutterSmartDialog.init(),
        );
      },
    );
  }
}
