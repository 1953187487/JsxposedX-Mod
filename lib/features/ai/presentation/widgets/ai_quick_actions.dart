import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiQuickActions extends StatelessWidget {
  final VoidCallback? onOpenAnalysis;

  /// 追加在快捷操作行末端的自定义控件（例如计划模式开关）。
  final Widget? trailing;

  const AiQuickActions({super.key, this.onOpenAnalysis, this.trailing});

  @override
  Widget build(BuildContext context) {
    if (onOpenAnalysis == null && trailing == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 36.h,
      margin: EdgeInsets.only(top: 8.h, bottom: 4.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          if (onOpenAnalysis != null)
            _QuickActionTile(
              icon: Icons.inventory_2_outlined,
              label: context.l10n.aiReverseOpenAnalysis,
              color: Colors.blueGrey,
              onTap: onOpenAnalysis!,
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: context.isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: color.withValues(alpha: 0.1), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: context.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
