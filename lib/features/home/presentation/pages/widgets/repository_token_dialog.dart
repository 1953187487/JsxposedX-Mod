import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/home/domain/models/user_detail.dart';
import 'package:JsxposedX/features/home/presentation/providers/repository_token_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 仓库 Token 登录/更换弹窗（合并页内复用）。
class RepositoryTokenDialog extends HookConsumerWidget {
  const RepositoryTokenDialog({
    super.key,
    this.isReplace = false,
    this.user,
  });

  final bool isReplace;
  final UserDetail? user;

  static void show(
    BuildContext context, {
    bool isReplace = false,
    UserDetail? user,
  }) {
    SmartDialog.show(
      builder: (_) =>
          RepositoryTokenDialog(isReplace: isReplace, user: user),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (user != null && isReplace) {
      return _UserInfoContent(
        user: user!,
        isReplace: isReplace,
      );
    }
    return _TokenLoginContent(isReplace: isReplace);
  }
}

class _TokenLoginContent extends HookConsumerWidget {
  const _TokenLoginContent({required this.isReplace});

  final bool isReplace;

  static const String _repositoryTutorialUrl =
      'https://muxueai.pro';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenController = useTextEditingController();
    final isSubmitting = useState(false);

    return CustomDialog(
      title: Text(
        isReplace
            ? context.l10n.repositoryReplaceToken
            : context.l10n.repositoryTokenLogin,
      ),
      hasClose: !isSubmitting.value,
      width: 0.86.sw,
      actionButtons: [
        TextButton(
          onPressed: isSubmitting.value
              ? null
              : () => UrlHelper.openUrlInBrowser(url: _repositoryTutorialUrl),
          child: Text(context.l10n.aiTutorial),
        ),
        TextButton(
          onPressed: isSubmitting.value ? null : () => SmartDialog.dismiss(),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: isSubmitting.value
              ? null
              : () async {
                  final token = tokenController.text.trim();
                  if (token.isEmpty) {
                    ToastMessage.show(context.l10n.repositoryTokenEmpty);
                    return;
                  }

                  isSubmitting.value = true;
                  try {
                    final notifier = ref.read(
                      repositoryTokenLoginProvider.notifier,
                    );
                    final user = await notifier.loginWithToken(token);

                    if (!context.mounted) {
                      return;
                    }

                    ToastMessage.show(
                      context.l10n.repositoryTokenLoginSuccess,
                    );
                    await SmartDialog.dismiss();
                  } catch (_) {
                    if (!context.mounted) {
                      return;
                    }
                    ToastMessage.show(context.l10n.repositoryTokenInvalid);
                  } finally {
                    if (context.mounted) {
                      isSubmitting.value = false;
                    }
                  }
                },
          child: isSubmitting.value
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child:
                      CircularProgressIndicator(strokeWidth: 2.w),
                )
              : Text(context.l10n.repositoryVerifyAndLogin),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: tokenController,
            labelText: 'Token',
            hintText: context.l10n.repositoryTokenHint,
          ),
        ],
      ),
    );
  }
}

class _UserInfoContent extends HookConsumerWidget {
  const _UserInfoContent({required this.user, required this.isReplace});

  final UserDetail user;
  final bool isReplace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog(
      title: Text(context.l10n.repositoryAccountInfo),
      hasClose: true,
      width: 0.86.sw,
      child: _UserInfoBody(user: user),
      actionButtons: [
        TextButton(
          onPressed: () => SmartDialog.dismiss(),
          child: Text(context.l10n.close),
        ),
        TextButton(
          onPressed: () async {
            await SmartDialog.dismiss();
            RepositoryTokenDialog.show(context);
          },
          child: Text(context.l10n.repositoryReplaceToken),
        ),
      ],
    );
  }
}

class _UserInfoBody extends StatelessWidget {
  const _UserInfoBody({required this.user});

  final UserDetail user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Avatar(imageUrl: user.avatarUrl, size: 64.sp),
        SizedBox(height: 14.h),
        Text(
          user.nickname.isEmpty
              ? context.l10n.repositoryUnnamedUser
              : user.nickname,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.h),
        _InfoRow(
          label: context.l10n.repositoryMxid,
          value: user.mxid.isEmpty ? '-' : user.mxid,
        ),
        SizedBox(height: 10.h),
        _InfoRow(
          label: context.l10n.repositoryVip,
          value: user.isVip
              ? context.l10n.repositoryVipActive
              : context.l10n.repositoryVipInactive,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64.w,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.size});

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = imageUrl?.trim() ?? '';
    if (resolvedUrl.isNotEmpty) {
      return ClipOval(
        child: CacheImage(imageUrl: resolvedUrl, size: size),
      );
    }
    return Container(
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
  }
}
