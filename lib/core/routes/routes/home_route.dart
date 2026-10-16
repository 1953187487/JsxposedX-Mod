import 'package:JsxposedX/common/pages/splash_page.dart';
import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/features/ai/presentation/pages/ai_reverse_page.dart';
import 'package:JsxposedX/features/ai/presentation/pages/file_viewer_page.dart';
import 'package:JsxposedX/features/home/presentation/pages/desktop_home_page.dart';
import 'package:JsxposedX/features/home/presentation/pages/tabs/repository_tab/pages/script_detail_page.dart';
import 'package:JsxposedX/features/so_analysis/presentation/pages/so_analysis_page.dart';
import 'package:JsxposedX/features/home/presentation/pages/home_page.dart';
import 'package:JsxposedX/features/project/presentation/pages/crypto/crypto_audit_js_editor_page.dart';
import 'package:JsxposedX/features/project/presentation/pages/crypto/crypto_audit_log_page.dart';
import 'package:JsxposedX/features/frida/presentation/pages/frida_api_manual_page.dart';
import 'package:JsxposedX/features/frida/presentation/pages/frida_editor_page.dart';
import 'package:JsxposedX/features/frida/presentation/pages/frida_project_page.dart';
import 'package:JsxposedX/features/project/presentation/pages/quick_functions_page.dart';
import 'package:JsxposedX/features/xposed/presentation/pages/ai_api_manual_page.dart';
import 'package:JsxposedX/features/xposed/presentation/pages/api_manual_page.dart';
import 'package:JsxposedX/features/xposed/presentation/pages/xposed_editor_page.dart';
import 'package:JsxposedX/features/xposed/presentation/pages/xposed_project_page.dart';
import 'package:JsxposedX/features/xposed/presentation/pages/xposed_visual_editor_page.dart';
import 'package:go_router/go_router.dart';

/// 主要功能路由
class HomeRoute {
  HomeRoute._();

  static const splash = '/';
  static const desktop = '/desktop';
  static const home = '/home';

  static const quickFunctions = '/quickFunctions';
  static const xposedProject = '/xposedProject/:packageName';
  static const xposedEditor = '/xposedEditor/:packageName';
  static const xposedVisualEditor = '/xposedVisualEditor/:packageName';
  static const fridaProject = '/fridaProject/:packageName';
  static const fridaEditor = '/fridaEditor/:packageName';
  static const aiReverse = '/aiReverse/:packageName';
  static const cryptoAuditLog = '/cryptoAuditLog/:packageName';
  static const cryptoAuditJsEditor = '/cryptoAuditJsEditor/:packageName';
  static const apiManual = '/apiManual';
  static const aiApiManual = '/aiApiManual/:apiType';
  static const fridaApiManual = '/fridaApiManual';
  static const soAnalysis = '/soAnalysis/:packageName';
  static const scriptDetail = '/scriptDetail/:id';
  static const fileViewer = '/fileViewer';
  static const login = 'login';

  static String toQuickFunctions({required AppInfo app}) => '/quickFunctions';

  static String toXposedProject({required String packageName}) =>
      '/xposedProject/$packageName';

  static String toXposedEditor({required String packageName}) =>
      '/xposedEditor/$packageName';

  static String toXposedVisualEditor({required String packageName}) =>
      '/xposedVisualEditor/$packageName';

  static String toFridaProject({required String packageName}) =>
      '/fridaProject/$packageName';

  static String toFridaEditor({required String packageName}) =>
      '/fridaEditor/$packageName';

  static String toAiReverse({required String packageName}) =>
      '/aiReverse/$packageName';

  static String toCryptoAuditLog({required String packageName}) =>
      '/cryptoAuditLog/$packageName';

  static String toCryptoAuditJsEditor({required String packageName}) =>
      '/cryptoAuditJsEditor/$packageName';

  static String toSoAnalysis({required String packageName}) =>
      '/soAnalysis/$packageName';

  static String toScriptDetail({required int id}) => '/scriptDetail/$id';

  static String toFileViewer({required String path}) => '/fileViewer';
}

List<GoRoute> homeRoutes = [
  GoRoute(
    path: HomeRoute.splash,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: HomeRoute.desktop,
    builder: (context, state) => const DesktopHomePage(),
  ),
  GoRoute(
    path: HomeRoute.home,
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: HomeRoute.quickFunctions,
    builder: (context, state) {
      final app = state.extra as AppInfo;
      return QuickFunctionsPage(app: app);
    },
  ),
  GoRoute(
    path: HomeRoute.xposedProject,
    builder: (context, state) {
      final packageName = state.pathParameters["packageName"]!;
      return XposedProjectPage(packageName: packageName);
    },
  ),
  GoRoute(
    path: HomeRoute.xposedEditor,
    builder: (context, state) {
      final path = state.extra as String;
      final packageName = state.pathParameters["packageName"]!;
      return XposedEditorPage(path: path, packageName: packageName);
    },
  ),
  GoRoute(
    path: HomeRoute.xposedVisualEditor,
    builder: (context, state) {
      final path = state.extra as String;
      final packageName = state.pathParameters["packageName"]!;
      return XposedVisualEditorPage(path: path, packageName: packageName);
    },
  ),
  GoRoute(
    path: HomeRoute.fridaProject,
    builder: (context, state) {
      final packageName = state.pathParameters["packageName"]!;
      return FridaProjectPage(packageName: packageName);
    },
  ),
  GoRoute(
    path: HomeRoute.fridaEditor,
    builder: (context, state) {
      final path = state.extra as String;
      final packageName = state.pathParameters["packageName"]!;
      return FridaEditorPage(path: path, packageName: packageName);
    },
  ),
  GoRoute(
    path: HomeRoute.aiReverse,
    builder: (context, state) {
      final packageName = state.pathParameters["packageName"]!;
      return AiReversePage(packageName: packageName);
    },
  ),
  GoRoute(
    path: HomeRoute.cryptoAuditLog,
    builder: (context, state) {
      final packageName = state.pathParameters["packageName"]!;
      return CryptoAuditLogPage(packageName: packageName);
    },
  ),
  GoRoute(
    path: HomeRoute.cryptoAuditJsEditor,
    builder: (context, state) {
      final packageName = state.pathParameters["packageName"]!;
      return CryptoAuditJsEditorPage(packageName: packageName);
    },
  ),
  GoRoute(
    path: HomeRoute.apiManual,
    builder: (context, state) => const ApiManualPage(),
  ),
  GoRoute(
    path: HomeRoute.aiApiManual,
    builder: (context, state) {
      final apiType = state.pathParameters['apiType'] ?? 'xposed';
      return AiApiManualPage(initialApiType: apiType);
    },
  ),
  GoRoute(
    path: HomeRoute.fridaApiManual,
    builder: (context, state) => const FridaApiManualPage(),
  ),
  GoRoute(
    path: HomeRoute.soAnalysis,
    builder: (context, state) {
      final packageName = state.pathParameters['packageName']!;
      final extra = state.extra as Map<String, String>;
      return SoAnalysisPage(
        sessionId: extra['sessionId']!,
        soPath: extra['soPath']!,
        packageName: packageName,
      );
    },
  ),
  GoRoute(
    path: HomeRoute.scriptDetail,
    builder: (context, state) {
      final id = state.pathParameters["id"]!;
      return ScriptDetailPage(id: int.tryParse(id) ?? -1);
    },
  ),
  GoRoute(
    path: HomeRoute.fileViewer,
    builder: (context, state) {
      final extra = state.extra;
      if (extra is Map) {
        return FileViewerPage(
          path: extra['path'] as String? ?? '',
          title: extra['title'] as String?,
        );
      }
      return FileViewerPage(path: extra as String? ?? '');
    },
  ),
];
