import 'dart:io';

import 'package:JsxposedX/core/routes/app_router.dart';
import 'package:JsxposedX/features/home/presentation/providers/desktop_locale_provider.dart';
import 'package:JsxposedX/features/home/presentation/providers/desktop_theme_provider.dart';
import 'package:JsxposedX/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 是否为 PC（桌面）平台
bool get isDesktopPlatform =>
    !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

/// PC 端独立 App 入口
///
/// 与手机端 MainApp 完全隔离，不经过 AppBootstrap / PiniaNative /
/// overlay / scriptLog 等 Android 原生业务链路。
/// 仅提供主题、语言、路由所需的最小依赖。
class DesktopApp extends ConsumerWidget {
  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(desktopThemeModeProvider);
    final lightTheme = ref.watch(desktopLightThemeProvider);
    final darkTheme = ref.watch(desktopDarkThemeProvider);
    final locale = ref.watch(desktopLocaleProvider);
    final router = ref.watch(appRouterProvider);
    final view = View.of(context);
    final windowSize = view.physicalSize / view.devicePixelRatio;

    return ScreenUtilInit(
      designSize: windowSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        title: 'JsxposedX Desktop',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        locale: locale,
        supportedLocales: const <Locale>[
          Locale('zh', 'CN'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        builder: FlutterSmartDialog.init(),
        // 关闭主题过渡动画，避免切换时逐帧 lerp 两份 ThemeData 造成卡顿
        themeAnimationDuration: Duration.zero,
      ),
    );
  }
}
