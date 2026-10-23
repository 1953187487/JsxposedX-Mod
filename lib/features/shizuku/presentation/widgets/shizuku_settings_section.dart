import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/custom_dIalog.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/home/presentation/widgets/settings_section.dart';
import 'package:JsxposedX/features/home/presentation/widgets/settings_tile.dart';
import 'package:JsxposedX/features/shizuku/presentation/providers/shizuku_provider.dart';
import 'package:JsxposedX/generated/shizuku.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 设置页中的 Shizuku 权限入口。
class ShizukuSettingsSection extends ConsumerWidget {
  const ShizukuSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(shizukuStatusProvider);
    return SettingsSection(
      title: context.l10n.shizukuPermissionTitle,
      items: [
        SettingsTile(
          icon: Icons.bolt_rounded,
          title: 'Shizuku',
          subtitle: _statusLabel(context, status),
          onTap: () => ShizukuPermissionDialog.show(context),
        ),
      ],
    );
  }

  String _statusLabel(BuildContext context, AsyncValue<ShizukuStatus> status) {
    final value = status.value;
    if (value == null) return context.l10n.shizukuChecking;
    if (!value.installed) return context.l10n.shizukuNotInstalled;
    if (value.isPreV11) return context.l10n.shizukuUnsupported;
    if (!value.running) return context.l10n.shizukuNotRunning;
    if (!value.permissionGranted) return context.l10n.shizukuNotAuthorized;
    return context.l10n.shizukuAuthorized;
  }
}

/// Shizuku 状态与授权操作弹窗。
class ShizukuPermissionDialog extends ConsumerStatefulWidget {
  const ShizukuPermissionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return CustomDialog.show<void>(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            color: context.colorScheme.primary,
          ),
          SizedBox(width: 8.w),
          Text(context.l10n.shizukuPermissionTitle),
        ],
      ),
      hasClose: true,
      width: 0.9.sw,
      child: const ShizukuPermissionDialog(),
    );
  }

  @override
  ConsumerState<ShizukuPermissionDialog> createState() =>
      _ShizukuPermissionDialogState();
}

class _ShizukuPermissionDialogState
    extends ConsumerState<ShizukuPermissionDialog> {
  bool _requesting = false;

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(shizukuStatusProvider);
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
            label: context.l10n.shizukuStatusInstalled,
            ok: value.installed,
          ),
          if (!value.isPreV11)
            _StatusRow(
              label: context.l10n.shizukuStatusRunning,
              ok: value.running,
            ),
          _StatusRow(
            label: context.l10n.shizukuStatusPermission,
            ok: value.permissionGranted,
          ),
          if (value.version > 0)
            _InfoRow(
              label: context.l10n.shizukuVersion,
              value: '${value.version}',
            ),
          if (value.selinuxContext.isNotEmpty)
            _InfoRow(
              label: context.l10n.shizukuSelinuxContext,
              value: value.selinuxContext,
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
                    : () => ref.invalidate(shizukuStatusProvider),
                child: Text(context.l10n.refresh),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _tip(BuildContext context, ShizukuStatus value) {
    if (!value.installed) return context.l10n.shizukuInstallTip;
    if (value.isPreV11) return context.l10n.shizukuUnsupportedTip;
    if (!value.running) return context.l10n.shizukuStartTip;
    if (!value.permissionGranted) return context.l10n.shizukuPermissionTip;
    return context.l10n.shizukuAuthorized;
  }

  String _primaryActionLabel(BuildContext context, ShizukuStatus value) {
    if (!value.installed) return context.l10n.shizukuDownload;
    if (value.isPreV11) return context.l10n.shizukuUnsupported;
    if (!value.running) return context.l10n.shizukuOpenApp;
    if (!value.permissionGranted) return context.l10n.shizukuRequestPermission;
    return context.l10n.refresh;
  }

  Future<void> _onPrimaryAction(ShizukuStatus value) async {
    final native = ref.read(shizukuNativeProvider);
    if (value.installed && value.running && value.permissionGranted) {
      ref.invalidate(shizukuStatusProvider);
      return;
    }

    if (!value.installed) {
      _handleResult(await native.openDownloadPage());
      return;
    }

    if (!value.running) {
      _handleResult(await native.openShizuku());
      return;
    }

    setState(() => _requesting = true);
    try {
      final granted = await native.requestPermission();
      ref.invalidate(shizukuStatusProvider);
      if (!mounted) return;
      ToastMessage.show(
        granted ? context.l10n.shizukuGrantedToast : context.l10n.shizukuDeniedToast,
      );
    } catch (_) {
      if (!mounted) return;
      ToastMessage.show(context.l10n.shizukuRequestFailed);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  void _handleResult(bool success) {
    if (success) {
      ref.invalidate(shizukuStatusProvider);
      return;
    }
    if (!mounted) return;
    ToastMessage.show(context.l10n.shizukuRequestFailed);
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
