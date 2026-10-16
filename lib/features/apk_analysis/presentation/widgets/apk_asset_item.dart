import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/generated/apk_analysis.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApkAssetItem extends StatelessWidget {
  final ApkAsset asset;
  final VoidCallback? onTap;

  const ApkAssetItem({super.key, required this.asset, this.onTap});

  IconData get _icon {
    if (asset.isDirectory) return Icons.folder_rounded;
    final ext = asset.name.split('.').last.toLowerCase();
    return switch (ext) {
      'dex' => Icons.code_rounded,
      'xml' => Icons.description_rounded,
      'arsc' => Icons.table_chart_rounded,
      'so' => Icons.memory_rounded,
      'png' || 'jpg' || 'jpeg' || 'webp' => Icons.image_rounded,
      'kt' || 'java' => Icons.data_object_rounded,
      'json' => Icons.data_array_rounded,
      _ => Icons.insert_drive_file_rounded,
    };
  }

  Color _iconColor(BuildContext context) {
    if (asset.isDirectory) return const Color(0xFFFFC107);
    final ext = asset.name.split('.').last.toLowerCase();
    return switch (ext) {
      'dex' => context.colorScheme.primary,
      'xml' => const Color(0xFF4CAF50),
      'arsc' => const Color(0xFF9C27B0),
      'so' => const Color(0xFFFF5722),
      'png' || 'jpg' || 'jpeg' || 'webp' => const Color(0xFF2196F3),
      'kt' || 'java' => const Color(0xFFFF9800),
      'json' => const Color(0xFF00BCD4),
      _ => context.colorScheme.onSurface.withValues(alpha: 0.5),
    };
  }

  String _formatSize(int bytes) {
    if (bytes <= 0) return '-';
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _iconColor(context);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      leading: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(_icon, size: 20.sp, color: iconColor),
      ),
      title: Text(
        asset.name,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        asset.path,
        style: TextStyle(
          fontSize: 10.sp,
          color: context.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: asset.isDirectory
          ? Icon(Icons.chevron_right_rounded, size: 18.sp, color: context.theme.hintColor)
          : Text(
              _formatSize(asset.size),
              style: TextStyle(
                fontSize: 10.sp,
                color: context.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
      onTap: onTap,
    );
  }
}
