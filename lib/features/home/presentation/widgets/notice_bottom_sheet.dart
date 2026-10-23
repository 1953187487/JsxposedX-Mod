import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/home/presentation/providers/check_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String _repositoryUrl = 'https://github.com/1953187487/JsxposedX-Mod';

/// 入口公告：展示二改声明 + 仓库公告，用户勾选确认后进入应用。
class NoticeBottomSheet extends HookConsumerWidget {
  const NoticeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(noticeInfoProvider);
    final agreed = useState(false);
    final colorScheme = context.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 14.h),
          _buildModStatement(context),
          SizedBox(height: 12.h),
          Flexible(
            child: Expanded(
              child: noticeAsync.when(
                data: (notice) => _buildNoticeCard(
                  context,
                  notice.msg.content.trim(),
                ),
                error: (error, stack) => RefError(
                  error: error,
                  onRetry: () => ref.invalidate(noticeInfoProvider),
                ),
                loading: () => Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => agreed.value = !agreed.value,
            child: Row(
              children: [
                Checkbox(
                  value: agreed.value,
                  onChanged: (v) => agreed.value = v ?? false,
                ),
                Expanded(
                  child: Text(
                    context.l10n.noticeAgreementLabel,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 4.h),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: agreed.value
                        ? () => SmartDialog.dismiss()
                        : null,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      context.l10n.noticeContinue,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                OutlinedButton.icon(
                  onPressed: () {
                    ToastMessage.show(context.l10n.openingBrowser);
                    UrlHelper.openUrlInBrowser(url: _repositoryUrl);
                  },
                  icon: Icon(Icons.code_rounded, size: 16.sp),
                  label: Text(context.l10n.noticeRepository),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.35),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.handyman_rounded,
            color: colorScheme.primary,
            size: 22.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.appName,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                context.l10n.modAgreementSubtitle,
                style: context.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModStatement(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.handshake_rounded,
            size: 18.sp,
            color: colorScheme.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              context.l10n.modAgreementBody,
              style: context.textTheme.bodySmall?.copyWith(
                height: 1.55,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(BuildContext context, String content) {
    final colorScheme = context.colorScheme;
    final title = context.l10n.notice;
    final emptyText = context.l10n.noticeEmpty;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.campaign_rounded,
                  color: colorScheme.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              content.isEmpty ? emptyText : content,
              style: context.textTheme.bodySmall?.copyWith(
                height: 1.6,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
