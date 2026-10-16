import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/dialog_keyword.dart';
import 'package:JsxposedX/features/project/presentation/providers/quick_functions_config_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/quick_functions_config_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DialogKeywordSheet extends HookConsumerWidget {
  final String packageName;
  final String functionKey;

  const DialogKeywordSheet({
    super.key,
    required this.packageName,
    required this.functionKey,
  });

  static void show(
    BuildContext context, {
    required String packageName,
    required String functionKey,
  }) {
    AppBottomSheet.show(
      context: context,
      title: context.l10n.keywordManagement,
      child: DialogKeywordSheet(
        packageName: packageName,
        functionKey: functionKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final keywordsAsync = ref.watch(
      getDialogKeywordsProvider(packageName: packageName, name: functionKey),
    );

    final newKeywordController = useTextEditingController();

    Future<void> addKeyword() async {
      final text = newKeywordController.text.trim();
      if (text.isEmpty) return;

      await ref.read(
        addDialogKeywordProvider(
          packageName: packageName,
          name: functionKey,
          keyword: DialogKeyword(keyword: text, isCheck: true),
        ).future,
      );

      newKeywordController.clear();
      ref.invalidate(
        getDialogKeywordsProvider(packageName: packageName, name: functionKey),
      );
    }

    Future<void> toggleCheck(String keyword, bool isCheck) async {
      await ref.read(
        updateDialogKeywordCheckProvider(
          packageName: packageName,
          name: functionKey,
          keyword: keyword,
          isCheck: isCheck,
        ).future,
      );
      ref.invalidate(
        getDialogKeywordsProvider(packageName: packageName, name: functionKey),
      );
    }

    Future<void> removeKeyword(String keyword) async {
      await ref.read(
        removeDialogKeywordProvider(
          packageName: packageName,
          name: functionKey,
          keyword: keyword,
        ).future,
      );
      ref.invalidate(
        getDialogKeywordsProvider(packageName: packageName, name: functionKey),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  name: "new_keyword",
                  controller: newKeywordController,
                  hintText: l10n.keywordPlaceholder,
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                height: 48.h,
                child: FilledButton.icon(
                  onPressed: addKeyword,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.add),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        SizedBox(height: 5.h),
        Expanded(
          child: keywordsAsync.when(
            data: (keywords) {
              if (keywords.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 64.sp,
                        color: context.colorScheme.outlineVariant,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.noKeywords,
                        style: TextStyle(
                          color: context.colorScheme.outline,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                itemCount: keywords.length,
                separatorBuilder: (context, index) => SizedBox(height: 5.h),
                itemBuilder: (context, index) {
                  final item = keywords[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 16.w, right: 8.w),
                      title: Text(
                        item.keyword,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch.adaptive(
                            value: item.isCheck,
                            onChanged: (val) => toggleCheck(item.keyword, val),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_sweep_outlined,
                              color: context.colorScheme.error,
                              size: 22.sp,
                            ),
                            onPressed: () => removeKeyword(item.keyword),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: Loading()),
            error: (err, stack) => Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: context.colorScheme.error,
                      size: 48.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      err.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.colorScheme.error),
                    ),
                    SizedBox(height: 16.h),
                    TextButton.icon(
                      onPressed: () => ref.invalidate(
                        getDialogKeywordsProvider(
                          packageName: packageName,
                          name: functionKey,
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(context.l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
