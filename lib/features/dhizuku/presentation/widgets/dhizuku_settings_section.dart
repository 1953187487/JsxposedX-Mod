import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/dhizuku/presentation/providers/dhizuku_provider.dart';
import 'package:JsxposedX/features/home/presentation/widgets/settings_section.dart';
import 'package:JsxposedX/features/home/presentation/widgets/settings_tile.dart';
import 'package:JsxposedX/features/shizuku/presentation/providers/shizuku_provider.dart';
import 'package:JsxposedX/features/shizuku/presentation/widgets/shizuku_settings_section.dart';
import 'package:JsxposedX/generated/dhizuku.g.dart';
import 'package:JsxposedX/generated/shizuku.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 设置页中的免 Root 权限入口（Dhizuku / Shizuku 任一即可）。
class DhizukuSettingsSection extends ConsumerWidget {
  const DhizukuSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dhizukuStatus = ref.watch(dhizukuStatusProvider);
    final shizukuStatus = ref.watch(shizukuStatusProvider);

    final dhizukuGranted = dhizukuStatus.value?.permissionGranted ?? false;
    final shizukuGranted = shizukuStatus.value?.permissionGranted ?? false;

    return SettingsSection(
      title: context.l10n.permissionTitle,
      items: [
        SettingsTile(
          icon: Icons.admin_panel_settings_rounded,
          title: 'Dhizuku',
          subtitle: _dhizukuStatusLabel(context, dhizukuStatus, shizukuGranted),
          onTap: () => DhizukuPermissionDialog.show(context),
        ),
        const SettingsDivider(),
        SettingsTile(
          icon: Icons.bolt_rounded,
          title: 'Shizuku',
          subtitle: _shizukuStatusLabel(context, shizukuStatus, dhizukuGranted),
          onTap: () => ShizukuPermissionDialog.show(context),
        ),
      ],
    );
  }

  String _dhizukuStatusLabel(
    BuildContext context,
    AsyncValue<DhizukuStatus> status,
    bool shizukuGranted,
  ) {
    if (shizukuGranted) return context.l10n.permissionActive;
    final value = status.value;
    if (value == null) return context.l10n.dhizukuChecking;
    if (!value.installed) return context.l10n.dhizukuNotInstalled;
    if (!value.activated) return context.l10n.dhizukuNotActivated;
    if (!value.permissionGranted) return context.l10n.dhizukuNotAuthorized;
    return context.l10n.dhizukuAuthorized;
  }

  String _shizukuStatusLabel(
    BuildContext context,
    AsyncValue<ShizukuStatus> status,
    bool dhizukuGranted,
  ) {
    if (dhizukuGranted) return context.l10n.permissionActive;
    final value = status.value;
    if (value == null) return context.l10n.shizukuChecking;
    if (!value.installed) return context.l10n.shizukuNotInstalled;
    if (value.isPreV11) return context.l10n.shizukuUnsupported;
    if (!value.running) return context.l10n.shizukuNotRunning;
    if (!value.permissionGranted) return context.l10n.shizukuNotAuthorized;
    return context.l10n.shizukuAuthorized;
  }
}

/// Dhizuku 状态与授权操作弹窗。
class DhizukuPermissionDialog extends ConsumerStatefulWidget {
  const DhizukuPermissionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return CustomDialog.show<void>(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.admin_panel_settings_rounded,
            color: context.colorScheme.primary,
          ),
          SizedBox(width: 8.w),
          Text(context.l10n.dhizukuPermissionTitle),
        ],
      ),
      hasClose: true,
      width: 0.9.sw,
      child: const DhizukuPermissionDialog(),
    );
  }

  @override
  ConsumerState<DhizukuPermissionDialog> createState() =>
      _DhizukuPermissionDialogState();
}

class _DhizukuPermissionDialogState
    extends ConsumerState<DhizukuPermissionDialog> {
  bool _requesting = false;

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(dhizukuStatusProvider);
    final value = status.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (value == null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: CircularProgressIndicator()),
          )
        else ...[
          _StatusRow(
            label: context.l10n.dhizukuStatusInstalled,
            ok: value.installed,
          ),
          _StatusRow(
            label: context.l10n.dhizukuStatusActivated,
            ok: value.activated,
          ),
          _StatusRow(
            label: context.l10n.dhizukuStatusPermission,
            ok: value.permissionGranted,
          ),
          if (value.ownerPackage.isNotEmpty)
            _InfoRow(
              label: context.l10n.dhizukuOwnerPackage,
              value: value.ownerPackage,
            ),
          if (value.serverVersionName.isNotEmpty)
            _InfoRow(
              label: context.l10n.dhizukuServerVersion,
              value: value.serverVersionCode > 0
                  ? '${value.serverVersionName} (${value.serverVersionCode})'
                  : value.serverVersionName,
            ),
          SizedBox(height: 12.h),
          Text(
            _tip(context, value),
            style: context.textTheme.bodySmall?.copyWith(
              height: 1.5,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _requesting ? null : () => _onPrimaryAction(value),
                  child: _requesting
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_primaryActionLabel(context, value)),
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton(
                onPressed: _requesting
                    ? null
                    : () => ref.invalidate(dhizukuStatusProvider),
                child: Text(context.l10n.refresh),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _tip(BuildContext context, DhizukuStatus value) {
    if (!value.installed) return context.l10n.dhizukuInstallTip;
    if (!value.activated) return context.l10n.dhizukuActivationTip;
    if (!value.permissionGranted) return context.l10n.dhizukuActivationTip;
    return context.l10n.dhizukuAuthorized;
  }

  String _primaryActionLabel(BuildContext context, DhizukuStatus value) {
    if (!value.installed) return context.l10n.dhizukuDownload;
    if (!value.activated) return context.l10n.dhizukuOpenApp;
    if (!value.permissionGranted) return context.l10n.dhizukuRequestPermission;
    return context.l10n.refresh;
  }

  Future<void> _onPrimaryAction(DhizukuStatus value) async {
    final native = ref.read(dhizukuNativeProvider);
    if (value.installed && value.activated && value.permissionGranted) {
      ref.invalidate(dhizukuStatusProvider);
      return;
    }

    if (!value.installed) {
      _handleResult(await native.openDownloadPage());
      return;
    }

    if (!value.activated) {
      _handleResult(await native.openDhizuku());
      return;
    }

    setState(() => _requesting = true);
    try {
      final granted = await native.requestPermission();
      ref.invalidate(dhizukuStatusProvider);
      if (!mounted) return;
      ToastMessage.show(
        granted ? context.l10n.dhizukuGrantedToast : context.l10n.dhizukuDeniedToast,
      );
    } catch (_) {
      if (!mounted) return;
      ToastMessage.show(context.l10n.dhizukuRequestFailed);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  void _handleResult(bool success) {
    if (success) {
      ref.invalidate(dhizukuStatusProvider);
      return;
    }
    if (!mounted) return;
    ToastMessage.show(context.l10n.dhizukuRequestFailed);
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.ok});

  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final color = ok ? Colors.green : context.colorScheme.error;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle_rounded : Icons.cancel_rounded, size: 18.w, color: color),
          SizedBox(width: 8.w),
          Expanded(child: Text(label)),
          Text(
            ok ? 'OK' : '--',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.colorScheme.onSurfaceVariant),
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
