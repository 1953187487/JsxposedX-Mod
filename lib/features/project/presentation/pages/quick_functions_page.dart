import 'package:JsxposedX/common/widgets/run_app_button.dart';
import 'package:JsxposedX/core/enums/project/quick_functions_enum.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/features/project/presentation/providers/quick_functions_config_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/quick_functions_config_query_provider.dart';
import 'package:JsxposedX/features/project/presentation/widgets/quick_function_app_card.dart';
import 'package:JsxposedX/features/project/presentation/widgets/quick_function_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuickFunctionsPage extends ConsumerWidget {
  final AppInfo app;

  const QuickFunctionsPage({super.key, required this.app});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final basicItems = [
      (
        functionKey: QuickFunctionsEnum.removeDialogs,
        name: l10n.qfRemoveDialogs,
        icon: Icons.block_rounded,
      ),
      (
        functionKey: QuickFunctionsEnum.removeScreenshotDetection,
        name: l10n.qfRemoveScreenshotDetection,
        icon: Icons.screenshot_rounded,
      ),
      (
        functionKey: QuickFunctionsEnum.removeCaptureDetection,
        name: l10n.qfRemoveCaptureDetection,
        icon: Icons.network_check_rounded,
      ),
      (
        functionKey: QuickFunctionsEnum.injectTip,
        name: l10n.qfInjectTip,
        icon: Icons.info_rounded,
      ),
      (
        functionKey: QuickFunctionsEnum.modifiedVersion,
        name: l10n.qfModifiedVersion,
        icon: Icons.update_disabled,
      ),
    ];

    // final envItems = [
    //   (functionKey: QuickFunctionsEnum.hideXposed, name: l10n.qfHideXposed, icon: Icons.security_rounded),
    //   (functionKey: QuickFunctionsEnum.hideRoot, name: l10n.qfHideRoot, icon: Icons.admin_panel_settings_rounded),
    //   (functionKey: QuickFunctionsEnum.hideApps, name: l10n.qfHideApps, icon: Icons.visibility_off_rounded),
    // ];

    final cryptoItems = [
      (
        functionKey: QuickFunctionsEnum.algorithmicTracking,
        name: l10n.qfAlgorithmicTracking,
        icon: Icons.account_tree_rounded,
      ),
    ];

    final masterAsync = ref.watch(
      getQuickFunctionStatusProvider(
        packageName: app.packageName,
        name: QuickFunctionsEnum.masterSwitch,
      ),
    );

    void toggleMaster(bool val) {
      Future.microtask(() async {
        await ref.read(
          setQuickFunctionStatusProvider(
            packageName: app.packageName,
            name: QuickFunctionsEnum.masterSwitch,
            status: val,
          ).future,
        );
        ref.invalidate(
          getQuickFunctionStatusProvider(
            packageName: app.packageName,
            name: QuickFunctionsEnum.masterSwitch,
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qfPageTitle),
        actions: [RunAppButton(packageName: app.packageName)],
      ),
      body: CustomScrollView(
        slivers: [
          // ── App 信息卡片 + 总开关 ────────────────────────────
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: masterAsync.when(
              data: (val) => QuickFunctionAppCard(
                app: app,
                isEnabled: val,
                onToggle: toggleMaster,
              ),
              loading: () => QuickFunctionAppCard(
                app: app,
                isEnabled: false,
                onToggle: toggleMaster,
              ),
              error: (_, __) => QuickFunctionAppCard(
                app: app,
                isEnabled: false,
                onToggle: toggleMaster,
              ),
            ),
          ),

          // ── 功能板块 ─────────────────────────────────────────
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: QuickFunctionSection(
              title: l10n.qfSectionBasic,
              items: basicItems,
              packageName: app.packageName,
            ),
          ),
          // SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          // SliverToBoxAdapter(
          //   child: QuickFunctionSection(
          //     title: l10n.qfSectionEnv,
          //     items: envItems,
          //     packageName: app.packageName,
          //   ),
          // ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: QuickFunctionSection(
              title: l10n.qfSectionCrypto,
              items: cryptoItems,
              packageName: app.packageName,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 30.h)),
        ],
      ),
    );
  }
}
