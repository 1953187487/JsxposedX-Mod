import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:JsxposedX/core/utils/procedure_utils.dart';
import 'package:JsxposedX/features/home/presentation/pages/tabs/home_tab.dart';
import 'package:JsxposedX/features/home/presentation/pages/tabs/project_tab.dart';
import 'package:JsxposedX/features/home/presentation/pages/tabs/repository_tab/repository_tab.dart';
import 'package:JsxposedX/features/home/presentation/pages/tabs/settings_tab.dart';
import 'package:JsxposedX/features/home/presentation/providers/check_query_provider.dart';
import 'package:JsxposedX/features/home/presentation/utils/update_check_helper.dart';
import 'package:JsxposedX/features/home/presentation/widgets/home_bottom_bar.dart';
import 'package:JsxposedX/features/home/presentation/widgets/home_center_dock_button.dart';
import 'package:JsxposedX/features/home/presentation/widgets/notice_bottom_sheet.dart';
import 'package:JsxposedX/features/home/presentation/widgets/select_app_sheet.dart';
import 'package:JsxposedX/features/home/presentation/widgets/update_check_dialog.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/pages/memory_tool_overlay.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_action_provider.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_query_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final colorScheme = context.colorScheme;
    final fabOffsetY = 9.h;
    final fabSize = 58.w;
    final bottomBarHeight = 60.h;

    final versionCode = useState(0);
    final pageController = usePageController(initialPage: 0);
    final pages = [
      const HomeTab(),
      const ProjectTab(),
      const RepositoryTab(),
      const SettingsTab(),
    ];

    final tabTitles = [
      context.l10n.home,
      context.l10n.project,
      context.l10n.repository,
      context.l10n.settings,
    ];

    final navItems = [
      HomeBottomNavItemData(
        label: context.l10n.home,
        outlinedIcon: Icons.home_outlined,
        filledIcon: Icons.home,
      ),
      HomeBottomNavItemData(
        label: context.l10n.project,
        outlinedIcon: Icons.folder_outlined,
        filledIcon: Icons.folder,
      ),
      HomeBottomNavItemData(
        label: context.l10n.repository,
        outlinedIcon: Icons.storage_outlined,
        filledIcon: Icons.storage,
      ),
      HomeBottomNavItemData(
        label: context.l10n.settings,
        outlinedIcon: Icons.settings_outlined,
        filledIcon: Icons.settings,
      ),
    ];

    useEffect(() {
      Future.microtask(() async {
        versionCode.value = await ProcedureUtils.getBuildNumber();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        AppBottomSheet.show(
          context: context,
          title: context.l10n.notice,
          child: const NoticeBottomSheet(),
        );

        Future.microtask(() async {
          try {
            final localBuildNumber = versionCode.value > 0
                ? versionCode.value
                : await ProcedureUtils.getBuildNumber();
            final update = await ref.read(updateInfoProvider.future);

            if (!context.mounted) return;
            if (!shouldShowUpdateDialog(
              update: update,
              localBuildNumber: localBuildNumber,
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
      });

      return null;
    }, []);

    return Scaffold(
      extendBody: true,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: LowerCenterDockedFabLocation(
        offsetY: fabOffsetY,
      ),
      floatingActionButton: HomeCenterDockButton(
        colorScheme: colorScheme,
        size: fabSize,
        onPressed: () async {
          final overlay = const MemoryToolOverlay();
          ref.invalidate(overlayWindowStatusProvider);
          final status = await ref.read(overlayWindowStatusProvider.future);
          final actions = ref.read(overlayWindowActionProvider.notifier);

          if (status.isActive) {
            await actions.hide();
            return;
          }

          await actions.show(
            context,
            sceneId: overlay.overlayConfig.sceneId,
          );
        },
      ),
      appBar: AppBar(
        title: Text(tabTitles[currentIndex.value]),
        actions: [
          switch (currentIndex.value) {
            0 => IconButton(
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              icon: Icon(!context.isDark ? Icons.dark_mode : Icons.light_mode),
            ),
            1 => IconButton(
              onPressed: () {
                SelectAppSheet.show(
                  context,
                  addToLSPosedScope: true,
                  onSelected: (appInfo) async {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    Future.microtask(() async {
                      Loading.show();

                      try {
                        await ref.read(
                          createProjectProvider(
                            packageName: appInfo.packageName,
                          ).future,
                        );

                        ref.invalidate(projectsProvider);

                        if (!context.mounted) return;
                        ToastMessage.show(
                          context.l10n.alreadySelected(appInfo.name),
                        );
                      } catch (e) {
                        ToastMessage.show("error: $e");
                      } finally {
                        Loading.hide();
                      }
                    });
                  },
                );
              },
              icon: Icon(Icons.add),
            ),
            _ => SizedBox.shrink(),
          },
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
        fabSize: fabSize,
        fabOffsetY: fabOffsetY,
        height: bottomBarHeight,
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
