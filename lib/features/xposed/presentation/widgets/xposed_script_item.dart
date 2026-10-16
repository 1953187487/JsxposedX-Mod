import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XposedScriptItem extends StatelessWidget {
  final String path;
  final bool enabled;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onLongClick;
  final VoidCallback? onClick;

  const XposedScriptItem({
    super.key,
    required this.path,
    this.enabled = false,
    this.onToggle,
    this.onLongClick,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final name = PathUtils.getName(path: path);
    final scriptType = PathUtils.getType(name);
    final isVisual = scriptType == 'visual';

    // 提取公共样式变量
    final themeColor = isVisual ? Colors.purple : Colors.blue;
    final displayIcon = isVisual ? Icons.auto_awesome : Icons.code;
    final displayName = PathUtils.getName(path: name, isXposedScript: true);

    return ListTile(
      onTap: onClick,
      onLongPress: onLongClick,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      leading: CircleAvatar(
        backgroundColor: themeColor.withValues(alpha: 0.1),
        child: Icon(displayIcon, color: themeColor, size: 20.r),
      ),
      title: Text(
        displayName,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              scriptType ?? 'unknown',
              style: TextStyle(
                color: themeColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: enabled,
          onChanged: onToggle,
          activeColor: themeColor,
          activeTrackColor: themeColor.withValues(alpha: 0.2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
