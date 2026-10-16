import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/status_management_provider.dart';
import 'package:JsxposedX/features/app/presentation/widgets/app_item.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_query_provider.dart';
import 'package:JsxposedX/features/project/presentation/widgets/project_menu_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 项目 Tab
class ProjectTab extends HookConsumerWidget {
  const ProjectTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectListAsync = ref.watch(projectsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(projectsProvider.future),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            sliver: projectListAsync.when(
              data: (projects) {
                if (projects.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 48.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            context.l10n.projectListEmpty,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return AppItem(
                      app: projects[index],
                      onTap: () {
                        final isHook = ref.read(isHookProvider).value ?? false;
                        if (!isHook) {
                          ToastMessage.show(context.l10n.pleaseActivateXposed);
                          return;
                        }
                        ProjectMenuSheet.show(
                          context,
                          app: projects[index],
                        );
                      },
                      onLongPress: () => CustomDialog.show(
                        title: Text(context.l10n.confirmDelete),
                        actionButtons: [
                          ElevatedButton(
                            onPressed: () {
                              SmartDialog.dismiss();
                              Future.microtask(() async {
                                ref.read(
                                  deleteProjectProvider(
                                    packageName: projects[index].packageName,
                                  ),
                                );
                                ref.invalidate(projectsProvider);
                              });
                            },
                            child: Text(context.l10n.confirm),
                          ),
                          ElevatedButton(
                            onPressed: () => SmartDialog.dismiss(),
                            child: Text(context.l10n.cancel),
                          ),
                        ],
                      ),
                    );
                  }, childCount: projects.length),
                );
              },
              error: (error, _) => SliverFillRemaining(
                child: RefError(
                  error: error,
                  onRetry: () => ref.refresh(projectsProvider.future),
                ),
              ),
              loading: () => const SliverFillRemaining(child: Loading()),
            ),
          ),
        ],
      ),
    );
  }
}
