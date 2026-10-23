import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/locale_provider.dart';
import 'package:JsxposedX/core/providers/status_management_provider.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:JsxposedX/core/utils/procedure_utils.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/ai/presentation/pages/ai_config_page.dart';
import 'package:JsxposedX/features/dhizuku/presentation/widgets/dhizuku_settings_section.dart';
import 'package:JsxposedX/features/home/presentation/widgets/settings_section.dart';
import 'package:JsxposedX/features/home/presentation/widgets/settings_tile.dart';
import 'package:JsxposedX/features/home/presentation/widgets/theme_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String _repositoryUrl = 'https://github.com/1953187487/JsxposedX-Mod';

/// 设置 Tab
class SettingsTab extends HookConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomBarSpacing = 60.h + 10.h + bottomInset + 24.h;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        SliverToBoxAdapter(
          child: SettingsSection(
            title: context.l10n.settings,
            items: [
              SettingsTile(
                icon: Icons.translate,
                title: context.l10n.language,
                subtitle: context.isChinese
                    ? context.l10n.chinese
                    : context.l10n.english,
                onTap: () {
                  if (context.isChinese) {
                    ref.read(localeProvider.notifier).setEn();
                    return;
                  }
                  ref.read(localeProvider.notifier).setZh();
                },
              ),
              const SettingsDivider(),
              SettingsTile(
                icon: Icons.palette_rounded,
                title: context.l10n.theme,
                subtitle: context.theme.brightness == Brightness.dark
                    ? context.l10n.darkTheme
                    : context.l10n.lightTheme,
                onTap: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
              const SettingsDivider(),
              SettingsTile(
                icon: Icons.color_lens_rounded,
                title: context.l10n.themeColor,
                onTap: () => ThemeColorPicker.show(context),
              ),
              const SettingsDivider(),
              SettingsTile(
                icon: Icons.smart_toy_rounded,
                title: context.l10n.aiConfig,
                onTap: () {
                  final isHook = ref.read(isHookProvider).value ?? false;
                  if (!isHook) {
                    ToastMessage.show(context.l10n.pleaseActivateXposed);
                    return;
                  }
                  AiConfigPage.show(context);
                },
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        const SliverToBoxAdapter(child: DhizukuSettingsSection()),
        SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        SliverToBoxAdapter(
          child: SettingsSection(
            title: context.l10n.about,
            items: [
              const _AboutSummaryTile(),
              const SettingsDivider(),
              SettingsTile(
                icon: Icons.policy_rounded,
                title: context.l10n.disclaimer,
                onTap: () => _showDisclaimerDialog(context),
              ),
              const SettingsDivider(),
              SettingsTile(
                icon: Icons.handshake_rounded,
                title: context.l10n.modAgreement,
                subtitle: context.l10n.modAgreementSubtitle,
                onTap: () => _showModAgreementDialog(context),
              ),
              const SettingsDivider(),
              SettingsTile(
                icon: Icons.code_rounded,
                title: context.l10n.repository,
                subtitle: 'GitHub · JsxposedX-Mod',
                onTap: () =>
                    UrlHelper.openUrlInBrowser(url: _repositoryUrl),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: bottomBarSpacing)),
      ],
    );
  }

  Future<void> _showDisclaimerDialog(BuildContext context) {
    final colorScheme = context.colorScheme;
    final items = [
      _DisclaimerItem(
        icon: Icons.verified_user_rounded,
        title: context.l10n.disclaimerLegalTitle,
        body: context.l10n.disclaimerLegalBody,
      ),
      _DisclaimerItem(
        icon: Icons.block_rounded,
        title: context.l10n.disclaimerProhibitedTitle,
        body: context.l10n.disclaimerProhibitedBody,
      ),
      _DisclaimerItem(
        icon: Icons.assignment_turned_in_rounded,
        title: context.l10n.disclaimerResponsibilityTitle,
        body: context.l10n.disclaimerResponsibilityBody,
      ),
      _DisclaimerItem(
        icon: Icons.smart_toy_rounded,
        title: context.l10n.disclaimerAiTitle,
        body: context.l10n.disclaimerAiBody,
      ),
    ];

    return CustomDialog.show<void>(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.policy_rounded, color: colorScheme.primary),
          SizedBox(width: 8.w),
          Text(context.l10n.disclaimer),
        ],
      ),
      hasClose: true,
      width: 0.9.sw,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 0.68.sh),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.disclaimerDialogIntro,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 14.h),
              ...items.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _DisclaimerBlock(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
      actionButtons: [
        TextButton(
          onPressed: () => SmartDialog.dismiss(),
          child: Text(context.l10n.confirm),
        ),
      ],
    );
  }

  Future<void> _showModAgreementDialog(BuildContext context) {
    final colorScheme = context.colorScheme;
    final items = [
      _DisclaimerItem(
        icon: Icons.handshake_rounded,
        title: context.l10n.modAgreementIntro,
        body: context.l10n.modAgreementBody,
      ),
      _DisclaimerItem(
        icon: Icons.copyright_rounded,
        title: context.l10n.modAgreementLicenseTitle,
        body: context.l10n.modAgreementLicenseBody,
      ),
      _DisclaimerItem(
        icon: Icons.shield_rounded,
        title: context.l10n.modAgreementLiabilityTitle,
        body: context.l10n.modAgreementLiabilityBody,
      ),
    ];

    return CustomDialog.show<void>(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.handshake_rounded, color: colorScheme.primary),
          SizedBox(width: 8.w),
          Text(context.l10n.modAgreement),
        ],
      ),
      hasClose: true,
      width: 0.9.sw,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 0.68.sh),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...items.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _DisclaimerBlock(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
      actionButtons: [
        TextButton(
          onPressed: () => SmartDialog.dismiss(),
          child: Text(context.l10n.confirm),
        ),
      ],
    );
  }
}

class _DisclaimerBlock extends StatelessWidget {
  const _DisclaimerBlock({required this.item});

  final _DisclaimerItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.42),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 18.sp, color: colorScheme.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  item.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            item.body,
            style: context.textTheme.bodySmall?.copyWith(
              height: 1.55,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerItem {
  const _DisclaimerItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class _AboutSummaryTile extends StatelessWidget {
  const _AboutSummaryTile();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return FutureBuilder<String>(
      future: _buildVersionText(),
      builder: (context, snapshot) {
        final versionText = snapshot.data ?? '...';

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child: CacheImage(
                      imageUrl: AssetsConstants.logo,
                      size: 40.sp,
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
                        SizedBox(height: 6.h),
                        Text(
                          context.l10n.appSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(
                            height: 1.5,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _AboutInfoPill(
                    icon: Icons.new_releases_rounded,
                    label: versionText,
                  ),
                  _AboutInfoPill(
                    icon: Icons.verified_rounded,
                    label: 'Xposed · Frida · AI',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _buildVersionText() async {
    final version = await ProcedureUtils.getVersionName();
    final build = await ProcedureUtils.getBuildNumber();
    return 'v$version+$build';
  }
}

class _AboutInfoPill extends StatelessWidget {
  const _AboutInfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: colorScheme.primary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
