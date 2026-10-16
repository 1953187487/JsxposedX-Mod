import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/app_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppItem extends StatelessWidget {
  final AppInfo app;
  final ValueChanged<AppInfo>? onSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AppItem({
    super.key,
    required this.app,
    this.onSelected,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.h),
      leading: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.colorScheme.surfaceContainer,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.memory(
            app.icon,
            fit: BoxFit.cover,
            cacheWidth: (48.w * MediaQuery.devicePixelRatioOf(context)).round(),
            cacheHeight: (48.w * MediaQuery.devicePixelRatioOf(context)).round(),
          ),
        ),
      ),
      title: Text(
        app.name,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            app.packageName,
            style: TextStyle(
              fontSize: 11.sp,
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${app.versionName} (${app.versionCode})",
            style: TextStyle(
              fontSize: 10.sp,
              color: context.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
      trailing: app.isSystemApp
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                context.l10n.systemAppLabel,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: context.colorScheme.onSecondaryContainer,
                ),
              ),
            )
          : null,
      onTap:
          onTap ??
          () {
            if (onSelected != null) {
              // 先显示加载框，再触发回调
              // 这样加载框会叠加在弹窗上，用户立刻看到反馈，不会有"假死"感
              Loading.show();
              onSelected!(app);
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context, app);
              ToastMessage.show(context.l10n.alreadySelected(app.name));
            }
          },
      onLongPress: onLongPress,
    );
  }
}
