import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const ToolbarIcon({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      focusNode: FocusNode(canRequestFocus: false),
      icon: Icon(icon, size: 20.sp),
      tooltip: tooltip,
      onPressed: onPressed,
      color: context.theme.colorScheme.onSurfaceVariant,
      disabledColor: context.theme.disabledColor,
      splashRadius: 20.r,
      constraints: BoxConstraints(
        minWidth: 36.w, 
        minHeight: 36.h,
      ),
      padding: EdgeInsets.zero,
    );
  }
}
