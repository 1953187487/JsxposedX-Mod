import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToolbarTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ToolbarTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      focusNode: FocusNode(canRequestFocus: false),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: context.theme.colorScheme.onSurfaceVariant,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
        minimumSize: Size(32.w, 36.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
