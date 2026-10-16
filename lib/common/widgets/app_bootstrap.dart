import 'package:JsxposedX/core/providers/locale_provider.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:JsxposedX/core/themes/app_theme.dart';
import 'package:JsxposedX/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef AppBootstrapBuilder =
    Widget Function(
      BuildContext context,
      Locale locale,
      ThemeData lightTheme,
      ThemeData darkTheme,
      ThemeMode themeMode,
    );

class AppBootstrap extends ConsumerWidget {
  const AppBootstrap({super.key, required this.builder});

  final AppBootstrapBuilder builder;

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  static const Iterable<Locale> supportedLocales = <Locale>[
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final theme = ref.watch(themeProvider);
    final lightTheme = theme.brightness == Brightness.light
        ? theme
        : AppTheme.lightTheme(theme.colorScheme.primary);
    final darkTheme = theme.brightness == Brightness.dark
        ? theme
        : AppTheme.darkTheme(theme.colorScheme.primary);
    final themeMode = theme.brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return builder(
          context,
          locale,
          lightTheme,
          darkTheme,
          themeMode,
        );
      },
    );
  }
}
