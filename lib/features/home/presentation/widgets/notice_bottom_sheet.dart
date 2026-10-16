import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/home/presentation/providers/check_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoticeBottomSheet extends HookConsumerWidget {
  const NoticeBottomSheet({super.key});

  static const String _afdianUrl = 'https://afdian.com/a/wanfengyyds/plan';
  static const String _paypalUrl =
      'https://www.paypal.com/qrcodes/p2pqrc/6Q6REWSAVE4VC';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(noticeInfoProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.55),
      child: noticeAsync.when(
        data: (notice) {
          final content = notice.msg.content.trim();

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSponsorButton(context),
                SizedBox(height: 12.h),
                _buildNoticeCard(context, content),
              ],
            ),
          );
        },
        error: (error, stack) => RefError(
          error: error,
          onRetry: () => ref.invalidate(noticeInfoProvider),
        ),
        loading: () => const Loading(),
      ),
    );
  }

  Widget _buildNoticeCard(BuildContext context, String content) {
    final colorScheme = context.colorScheme;
    final title = context.isZh ? '最新公告' : 'Latest Notice';
    final emptyText = context.isZh
        ? '当前暂无新的公告内容。'
        : 'No notice available right now.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.campaign_rounded,
                  color: colorScheme.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            content.isEmpty ? emptyText : content,
            style: context.textTheme.bodyMedium?.copyWith(height: 1.65),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _showSponsorDialog(context),
        icon: Icon(Icons.favorite_rounded, size: 18.sp),
        label: Text(context.isZh ? '立即赞助作者' : 'Sponsor Now'),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFFD7E6),
          foregroundColor: const Color(0xFFB4235A),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 13.h),
          textStyle: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }

  Future<void> _showSponsorDialog(BuildContext context) {
    final colorScheme = context.colorScheme;
    final title = context.isZh ? '选择赞助方式' : 'Choose a Sponsor Method';
    final subtitle = context.isZh ? '感谢支持。' : 'Thanks for the support.';

    return CustomDialog.show<void>(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.volunteer_activism_rounded, color: colorScheme.primary),
          SizedBox(width: 8.w),
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      hasClose: true,
      width: 0.84.sw,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                await SmartDialog.dismiss();
                await UrlHelper.openUrlInBrowser(url: _afdianUrl);
              },
              icon: Icon(Icons.favorite_rounded, size: 18.sp),
              label: Text(context.isZh ? '爱发电' : 'Afdian'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await SmartDialog.dismiss();
                await UrlHelper.openUrlInBrowser(url: _paypalUrl);
              },
              icon: Icon(Icons.payments_rounded, size: 18.sp),
              label: const Text('PayPal'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(
                  color: colorScheme.primary.withValues(alpha: 0.35),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
