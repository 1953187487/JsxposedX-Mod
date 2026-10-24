import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/home/presentation/providers/check_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String _repositoryUrl = 'https://github.com/1953187487/JsxposedX-Mod';

/// 入口公告（beta.2 重写）：品牌头 + 二改声明 + 最新发布说明 + 协议确认。
class NoticeBottomSheet extends HookConsumerWidget {
  const NoticeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeAsync = ref.watch(noticeInfoProvider);
    final agreed = useState(false);
    final colorScheme = context.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.72),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colorScheme),
          SizedBox(height: 16.h),
          _buildModStatement(context, colorScheme),
          SizedBox(height: 12.h),
          Flexible(
            child: noticeAsync.when(
              data: (notice) => _buildNoticeCard(
                context,
                colorScheme,
                notice.msg.content.trim(),
              ),
              error: (error, stack) => RefError(
                error: error,
                onRetry: () => ref.invalidate(noticeInfoProvider),
              ),
              loading: () => Padding(
                padding: EdgeInsets.symmetric(vertical: 28.h),
                child: Center(
                  child: SizedBox(
                    width: 26.w,
                    height: 26.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => agreed.value = !agreed.value,
            child: Row(
              children: [
                Checkbox(
                  value: agreed.value,
                  onChanged: (v) =>
                      agreed.value = v ?? false,
                  activeColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.noticeAgreementLabel,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: agreed.value ? () => SmartDialog.dismiss() : null,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
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
                Expanded(
                  child: OutlinedButton.icon(
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
                      padding: EdgeInsets.symmetric(vertical: 14.h),
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

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.72),
              ],
            ),
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.asset(AssetsConstants.logo, fit: BoxFit.contain),
          ),
        ),
        SizedBox(width: 12.w),
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

  Widget _buildModStatement(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(
              Icons.handshake_rounded,
              size: 18.sp,
              color: colorScheme.primary,
            ),
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

  Widget _buildNoticeCard(
    BuildContext context,
    ColorScheme colorScheme,
    String content,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(
                  Icons.campaign_rounded,
                  color: colorScheme.primary,
                  size: 17.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                context.l10n.notice,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 150.h),
            child: SingleChildScrollView(
              child: Text(
                content.isEmpty ? context.l10n.noticeEmpty : content,
                style: context.textTheme.bodySmall?.copyWith(
                  height: 1.6,
                  color: context.isDark
                      ? colorScheme.onSurface
                          .withValues(alpha: 0.75)
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
