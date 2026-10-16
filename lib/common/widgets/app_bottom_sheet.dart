import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 通用的底部弹窗外壳组件
class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? action;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.height,
    this.padding,
    this.action,
  });

  /// 静态显示方法，方便直接调用
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    List<Widget> action = const [],
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    final resolvedBackgroundColor =
        Theme.of(context).bottomSheetTheme.backgroundColor ??
        context.colorScheme.surface;
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: resolvedBackgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => AppBottomSheet(
        title: title,
        padding: padding,
        height: height,
        action: action,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final resolvedBackgroundColor =
        Theme.of(context).bottomSheetTheme.backgroundColor ??
        context.colorScheme.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Container(
        height: height,
        padding: (padding as EdgeInsets? ?? EdgeInsets.all(20.w)).copyWith(
          bottom:
              (padding as EdgeInsets? ?? EdgeInsets.all(20.w)).bottom +
              bottomInset,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部装饰条（指示器）
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // 标题
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (action != null) ...action!,
                ],
              ),
              SizedBox(height: 20.h),

              // 内容
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
