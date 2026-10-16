import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CustomDialog extends StatelessWidget {
  final Widget title;

  final List<Widget>? action;

  final List<Widget>? actionButtons;

  final bool hasClose;

  final Widget? child;

  final double? height;

  final double? width;

  const CustomDialog({
    super.key,
    required this.title,
    this.child,
    this.hasClose = false,
    this.actionButtons,
    this.action,
    this.height,
    this.width,
  });

  static Future<T?> show<T>({
    required Widget title,
    Widget? child,
    List<Widget>? action,
    double? height,
    double? width,
    List<Widget>? actionButtons,
    bool hasClose = false,
  }) {
    return SmartDialog.show(
      builder: (context) => CustomDialog(
        title: title,
        action: action,
        width: width,
        height: height,
        actionButtons: actionButtons,
        hasClose: hasClose,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedMaxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 0.9.sw;
        final resolvedMaxHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : 0.9.sh;
        final dialogWidth = width == null
            ? resolvedMaxWidth
            : width!.clamp(0.0, resolvedMaxWidth).toDouble();
        final dialogHeight = height?.clamp(0.0, resolvedMaxHeight).toDouble();
        final content = Padding(
          padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 10.r),
          child: Column(
            mainAxisSize: dialogHeight == null
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: [
              if (child != null)
                if (dialogHeight != null) Expanded(child: child!) else child!,
              if (actionButtons != null) ...[
                if (child != null) SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 5.w,
                  children: [...actionButtons!],
                ),
              ],
            ],
          ),
        );

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final backgroundColor = isDark
            ? context.colorScheme.surfaceContainerHigh
            : context.colorScheme.surface;
        
        return Material(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: resolvedMaxWidth,
              maxHeight: resolvedMaxHeight,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
              width: dialogWidth,
              height: dialogHeight,
              child: Column(
                mainAxisSize: dialogHeight == null
                    ? MainAxisSize.min
                    : MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.r,
                      horizontal: 10.r,
                    ),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: AppFonts.primary,
                        color: context.textTheme.titleMedium!.color,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: title),
                          if (action != null) ...action!,
                          if (hasClose)
                            IconButton(
                              onPressed: () => SmartDialog.dismiss(),
                              visualDensity: VisualDensity.compact,
                              tooltip: MaterialLocalizations.of(
                                context,
                              ).closeButtonTooltip,
                              icon: const Icon(Icons.close, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (child != null) const Divider(),
                  if (dialogHeight != null)
                    Expanded(child: content)
                  else
                    content,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
