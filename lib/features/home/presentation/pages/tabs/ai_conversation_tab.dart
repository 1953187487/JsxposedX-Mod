import 'dart:async';

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/core/providers/status_management_provider.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:JsxposedX/features/home/domain/models/post.dart';
import 'package:JsxposedX/features/home/domain/models/user_detail.dart';
import 'package:JsxposedX/features/home/presentation/pages/widgets/repository_token_dialog.dart';
import 'package:JsxposedX/features/home/presentation/providers/repository_query_provider.dart';
import 'package:JsxposedX/features/home/presentation/providers/repository_token_login_provider.dart';
import 'package:JsxposedX/features/home/presentation/widgets/select_app_sheet.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_query_provider.dart';
import 'package:JsxposedX/features/project/presentation/widgets/project_menu_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// 对话页：上方项目/仓库列表，下方 AI 对话输入框。
///
/// 替代原「项目 Tab + 仓库 Tab + 中间悬浮按钮」的组合，
/// 把项目、仓库与 AI 对话合并到同一个入口。
class AiConversationTab extends HookConsumerWidget {
  const AiConversationTab({super.key});

  /// 当前正在创建的项目包名（null 表示未在创建）。
  /// 用于替换原「全屏 Loading」，改为内联进度动画。
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creatingPackage = useState<String?>(null);
    final segment = useState(0); // 0 = 项目，1 = 仓库
    final selectedProject = useState<AppInfo?>(null);
    final draftController = useTextEditingController();

    void send(String text) {
      final trimmed = text.trim();
      final project = selectedProject.value;
      draftController.clear();

      if (project != null) {
        _navigateToAi(
          context,
          packageName: project.packageName,
          draft: trimmed,
        );
        return;
      }

      SelectAppSheet.show(
        context,
        addToLSPosedScope: true,
        onSelected: (appInfo) async {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          selectedProject.value = appInfo;
          await _ensureProject(
            context,
            ref,
            creatingPackage,
            packageName: appInfo.packageName,
            name: appInfo.name,
            draft: trimmed,
          );
        },
      );
    }

    return Column(
      children: [
        _SegmentedBar(
          selected: segment.value,
          labels: [context.l10n.project, context.l10n.repository],
          onChanged: (i) => segment.value = i,
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: segment.value == 0
              ? _ProjectSection(
                  creatingPackage: creatingPackage,
                  selectedProject: selectedProject,
                )
              : const _RepositorySection(),
        ),
        SizedBox(height: 8.h),
        if (selectedProject.value != null)
          _SelectedProjectChip(
            project: selectedProject.value!,
            onClear: () => selectedProject.value = null,
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: _ChatInputBar(
            controller: draftController,
            hint: context.l10n.chatInputHint,
            onSend: send,
          ),
        ),
      ],
    );
  }

  Future<void> _ensureProject(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<String?> creatingPackage, {
    required String packageName,
    required String name,
    String draft = '',
  }) async {
    creatingPackage.value = packageName;
    try {
      await ref.read(createProjectProvider(packageName: packageName).future);
      ref.invalidate(projectsProvider);
      if (!context.mounted) return;
      ToastMessage.show(context.l10n.alreadySelected(name));
      _navigateToAi(context, packageName: packageName, draft: draft);
    } catch (e) {
      if (context.mounted) ToastMessage.show('error: $e');
    } finally {
      if (creatingPackage.value == packageName) {
        creatingPackage.value = null;
      }
    }
  }

  void _navigateToAi(
    BuildContext context, {
    required String packageName,
    String draft = '',
  }) {
    final route = HomeRoute.toAiReverse(packageName: packageName);
    if (draft.isEmpty) {
      context.push(route);
    } else {
      context.push(route, extra: draft);
    }
  }
}

class _SegmentedBar extends StatelessWidget {
  const _SegmentedBar({
    required this.selected,
    required this.labels,
    required this.onChanged,
  });

  final int selected;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        padding: EdgeInsets.all(4.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: selected == i
                        ? colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => onChanged(i),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Center(
                          child: Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: selected == i
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected == i
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProjectSection extends HookConsumerWidget {
  const _ProjectSection({
    required this.creatingPackage,
    required this.selectedProject,
  });

  final ValueNotifier<String?> creatingPackage;
  final ValueNotifier<AppInfo?> selectedProject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return ValueListenableBuilder<String?>(
          valueListenable: creatingPackage,
          builder: (context, pkg, _) {
            final isCreating = pkg != null;
            return Column(
              children: [
                if (isCreating) _CreatingProjectBanner(packageName: pkg),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.refresh(projectsProvider.future),
                    child: projectsAsync.when(
                      data: (projects) {
                        if (projects.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    size: 40.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    context.l10n.projectListEmpty,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final app = projects[index];
                            return _ProjectRow(
                              app: app,
                              selected:
                                  selectedProject.value?.packageName ==
                                  app.packageName,
                              onSelect: () => selectedProject.value = app,
                              onMenu: () => ProjectMenuSheet.show(
                                context,
                                app: app,
                              ),
                              onDelete: () => _confirmDelete(context, ref, app),
                            );
                          },
                        );
                      },
                      error: (error, _) => Center(
                        child: Text(context.l10n.projectLoadFailed('$error')),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ],
            );
          },
        );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, AppInfo app) {
    CustomDialog.show(
      title: Text(context.l10n.confirmDelete),
      actionButtons: [
        ElevatedButton(
          onPressed: () {
            SmartDialog.dismiss();
            Future.microtask(() async {
              ref.read(deleteProjectProvider(packageName: app.packageName));
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
    );
  }
}

class _CreatingProjectBanner extends StatelessWidget {
  const _CreatingProjectBanner({required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18.w,
            height: 18.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.creatingProject,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  packageName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: null,
            color: colorScheme.primary,
            backgroundColor: colorScheme.onSurface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(2),
            minHeight: 4.h,
          ),
        ],
      ),
    );
  }
}

class _ProjectRow extends ConsumerWidget {
  const _ProjectRow({
    required this.app,
    required this.selected,
    required this.onSelect,
    required this.onMenu,
    required this.onDelete,
  });

  final AppInfo app;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onMenu;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final isHook = ref.watch(isHookProvider).value ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: selected
            ? colorScheme.primaryContainer.withValues(alpha: 0.4)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.6)
              : colorScheme.outlineVariant.withValues(alpha: 0.25),
          width: selected ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          if (!isHook) {
            ToastMessage.show(context.l10n.pleaseActivateXposed);
            return;
          }
          onSelect();
        },
        onLongPress: onDelete,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: colorScheme.surfaceContainer,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.memory(
                    app.icon,
                    fit: BoxFit.cover,
                    cacheWidth:
                        (44.w * MediaQuery.devicePixelRatioOf(context)).round(),
                    cacheHeight:
                        (44.w * MediaQuery.devicePixelRatioOf(context)).round(),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      app.packageName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (selected)
                Padding(
                  padding: EdgeInsets.only(left: 6.w),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 20.sp,
                    color: colorScheme.primary,
                  ),
                ),
              IconButton(
                icon: Icon(Icons.more_vert_rounded, size: 20.sp),
                onPressed: onMenu,
                tooltip: context.l10n.project,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedProjectChip extends StatelessWidget {
  const _SelectedProjectChip({required this.project, required this.onClear});

  final AppInfo project;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.chat_bubble_rounded,
              size: 14.sp,
              color: colorScheme.primary,
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                '@${project.name}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, size: 16.sp),
              color: colorScheme.primary,
              onPressed: onClear,
            ),
          ],
        ),
      ),
    );
  }
}

class _RepositorySection extends HookConsumerWidget {
  const _RepositorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(repositoryTokenLoginProvider);
    final releases = ref.watch(getScriptPostsProvider(limit: 30, offset: 0));

    return Column(
      children: [
        _RepositoryHeader(
          loginState: loginState,
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: releases.when(
            data: (result) {
              final rows = result.rows;
              if (rows.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      context.l10n.projectListEmpty,
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                itemCount: rows.length,
                itemBuilder: (context, index) =>
                    _ReleaseRow(post: rows[index]),
              );
            },
            error: (error, _) => Center(
              child: Text(context.l10n.projectLoadFailed('$error')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}

class _RepositoryHeader extends HookConsumerWidget {
  const _RepositoryHeader({required this.loginState});

  final AsyncValue<UserDetail?> loginState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = loginState.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Icon(
            Icons.campaign_rounded,
            size: 16.sp,
            color: context.colorScheme.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              context.l10n.repositoryReleases,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          loginState.when(
            data: (_) => _RepositoryAvatar(
              imageUrl: user?.avatarUrl,
              size: 32.sp,
              onTap: () => RepositoryTokenDialog.show(
                context,
                isReplace: user != null,
                user: user,
              ),
            ),
            loading: () => _RepositoryAvatar(
              imageUrl: null,
              size: 32.sp,
              isLoading: true,
            ),
            error: (_, __) => _RepositoryAvatar(
              imageUrl: null,
              size: 32.sp,
              onTap: () => RepositoryTokenDialog.show(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _RepositoryAvatar extends StatelessWidget {
  const _RepositoryAvatar({
    required this.imageUrl,
    required this.size,
    this.onTap,
    this.isLoading = false,
  });

  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = imageUrl?.trim() ?? '';
    final Widget avatar = resolvedUrl.isNotEmpty
        ? ClipOval(child: CacheImage(imageUrl: resolvedUrl, size: size))
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: size * 0.58,
              color: context.colorScheme.primary,
            ),
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Stack(
        alignment: Alignment.center,
        children: [
          avatar,
          if (isLoading)
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}

class _ReleaseRow extends StatelessWidget {
  const _ReleaseRow({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final downloads = post.postStats.viewCount;
    final publishMs = post.publishTime > 0
        ? post.publishTime * 1000
        : 0;
    final dateText = publishMs > 0
        ? DateFormat('yyyy-MM-dd').format(
            DateTime.fromMillisecondsSinceEpoch(publishMs),
          )
        : '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => context.push(HomeRoute.toScriptDetail(id: post.id)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (dateText.isNotEmpty)
                    Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: colorScheme.onSurface
                            .withValues(alpha: 0.45),
                      ),
                    ),
                ],
              ),
              if (post.description.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  post.description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.download_rounded,
                    size: 12.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$downloads',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.hint,
    required this.onSend,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final text = controller.text.trim();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                fontSize: 13.sp,
                color: colorScheme.onSurface,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: false,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
              ),
              minLines: 1,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (text) => onSend(text),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: text.isEmpty
                  ? colorScheme.onSurface.withValues(alpha: 0.3)
                  : colorScheme.primary,
            ),
            onPressed: text.isEmpty ? null : () => onSend(controller.text),
          ),
        ],
      ),
    );
  }
}
