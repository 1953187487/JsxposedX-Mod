import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:JsxposedX/generated/apk_analysis.g.dart';
import 'package:JsxposedX/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ApkManifestPage extends ConsumerWidget {
  final String? sessionId;

  const ApkManifestPage({super.key, this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sid = sessionId;
    if (sid == null || sid.isEmpty) return const Loading();
    final manifestAsync = ref.watch(parseManifestProvider(sessionId: sid));

    return manifestAsync.when(
      data: (manifest) => ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children: [
          _InfoCard(manifest: manifest),
          SizedBox(height: 12.h),
          _PermissionsSection(permissions: manifest.permissions),
          SizedBox(height: 12.h),
          _ComponentsSection(title: AppLocalizations.of(context)!.manifestActivities, components: manifest.activities),
          SizedBox(height: 12.h),
          _ComponentsSection(title: AppLocalizations.of(context)!.manifestServices, components: manifest.services),
          SizedBox(height: 12.h),
          _ComponentsSection(title: AppLocalizations.of(context)!.manifestReceivers, components: manifest.receivers),
          SizedBox(height: 12.h),
          _ComponentsSection(title: AppLocalizations.of(context)!.manifestProviders, components: manifest.providers),
          SizedBox(height: 16.h),
        ],
      ),
      error: (error, stack) => RefError(
        onRetry: () => ref.invalidate(parseManifestProvider(sessionId: sid)),
      ),
      loading: () => const Loading(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final ApkManifest manifest;

  const _InfoCard({required this.manifest});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _Section(
      title: l.manifestBasicInfo,
      child: Column(
        children: [
          _InfoRow(l.manifestPackage, manifest.packageName),
          _InfoRow(l.version, '${manifest.versionName} (${manifest.versionCode})'),
          _InfoRow(l.manifestMinSdk, manifest.minSdk.toString()),
          _InfoRow(l.manifestTargetSdk, manifest.targetSdk.toString()),
          _InfoRow(l.manifestDebuggable, manifest.debuggable ? 'true' : 'false',
              valueColor: manifest.debuggable ? Colors.orange : null),
          _InfoRow(l.manifestAllowBackup, manifest.allowBackup ? 'true' : 'false'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionsSection extends StatelessWidget {
  final List<String?> permissions;

  const _PermissionsSection({required this.permissions});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return _Section(
      title: l.manifestPermissions(permissions.length),
      child: permissions.isEmpty
          ? _EmptyHint(l.manifestNoPermissions)
          : Column(
              children: permissions
                  .whereType<String>()
                  .map((p) => _PermissionItem(permission: p))
                  .toList(),
            ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final String permission;

  const _PermissionItem({required this.permission});

  @override
  Widget build(BuildContext context) {
    final short = permission.contains('.')
        ? permission.substring(permission.lastIndexOf('.') + 1)
        : permission;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            Icons.security_rounded,
            size: 14.sp,
            color: context.colorScheme.primary.withValues(alpha: 0.7),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  short,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
                Text(
                  permission,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentsSection extends StatelessWidget {
  final String title;
  final List<ApkComponent?> components;

  const _ComponentsSection({required this.title, required this.components});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: '$title (${components.length})',
      child: components.isEmpty
          ? _EmptyHint(AppLocalizations.of(context)!.manifestNoItems(title))
          : Column(
              children: components
                  .whereType<ApkComponent>()
                  .map((c) => _ComponentItem(component: c))
                  .toList(),
            ),
    );
  }
}

class _ComponentItem extends StatelessWidget {
  final ApkComponent component;

  const _ComponentItem({required this.component});

  @override
  Widget build(BuildContext context) {
    final short = component.name.contains('.')
        ? component.name.substring(component.name.lastIndexOf('.') + 1)
        : component.name;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  short,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (component.exported)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.manifestExported,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            component.name,
            style: TextStyle(
              fontSize: 10.sp,
              color: context.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (component.process != null)
            Text(
              'process: ${component.process}',
              style: TextStyle(
                fontSize: 10.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ),
          if (component.intentActions.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Wrap(
                spacing: 4.w,
                runSpacing: 2.h,
                children: component.intentActions
                    .whereType<String>()
                    .map(
                      (a) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          a.contains('.') ? a.substring(a.lastIndexOf('.') + 1) : a,
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          Divider(height: 10.h, thickness: 0.5),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface.withValues(alpha: 0.55),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: context.colorScheme.onSurface.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
