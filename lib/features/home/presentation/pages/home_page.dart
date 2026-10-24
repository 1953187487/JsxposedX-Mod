import 'dart:async';

import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/status_management_provider.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:JsxposedX/core/utils/procedure_utils.dart';
import 'package:JsxposedX/features/home/presentation/pages/tabs/ai_conversation_tab.dart';
import 'package:JsxposedX/features/home/presentation/pages/tabs/settings_tab.dart';
import 'package:JsxposedX/features/home/presentation/providers/check_query_provider.dart';
import 'package:JsxposedX/features/home/presentation/utils/update_check_helper.dart';
import 'package:JsxposedX/features/home/presentation/widgets/home_bottom_bar.dart';
import 'package:JsxposedX/features/home/presentation/widgets/notice_bottom_sheet.dart';
import 'package:JsxposedX/features/home/presentation/widgets/update_check_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 主页面（beta.2）：对话 + 设置两个 Tab。
/// 原「首页」Tab 已移除，主界面直接进入 AI 对话。
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final pageController = usePageController(initialPage: 0);

    final pages = const [
      AiConversationTab(),
      SettingsTab(),
    ];

    final navItems = [
      HomeBottomNavItemData(
        label: context.l10n.chat,
        outlinedIcon: Icons.chat_bubble_outline_rounded,
        filledIcon: Icons.chat_bubble_rounded,
      ),
      HomeBottomNavItemData(
        label: context.l10n.settings,
        outlinedIcon: Icons.settings_outlined,
        filledIcon: Icons.settings,
      ),
    ];

    // 从 Dhizuku / Shizuku 授权页返回应用时，刷新 Hook 状态。
    useOnAppLifecycleStateChange((previous, current) {
      if (current == AppLifecycleState.resumed &&
          previous == AppLifecycleState.paused) {
        unawaited(ref.read(isHookProvider.notifier).refresh());
      }
    });

    useEffect(() {
      Future.microtask(() async {
        try {
          final localVersionName = await ProcedureUtils.getVersionName();
          final update = await ref.read(updateInfoProvider.future);

          if (!context.mounted) return;
          if (!shouldShowUpdateDialog(
            update: update,
            localVersionName: localVersionName,
          )) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            UpdateCheckDialog.show(context, update: update);
          });
        } catch (error, stackTrace) {
          debugPrint('Failed to check update: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        AppBottomSheet.show(
          context: context,
          title: context.l10n.notice,
          child: const NoticeBottomSheet(),
        );
      });

      return null;
    }, []);

    final appBarTitle = currentIndex.value == 0
        ? context.l10n.appName
        : context.l10n.settings;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            icon: Icon(
              context.isDark ? Icons.light_mode : Icons.dark_mode,
              size: 21,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            currentIndex.value = index;
          },
          children: pages,
        ),
      ),
      bottomNavigationBar: HomeBottomBar(
        navItems: navItems,
        currentIndex: currentIndex.value,
        onTap: (index) => _changeTab(currentIndex, pageController, index),
        height: 60.h,
      ),
    );
  }
}

void _changeTab(
  ValueNotifier<int> currentIndex,
  PageController pageController,
  int index,
) {
  currentIndex.value = index;
  pageController.animateToPage(
    index,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
