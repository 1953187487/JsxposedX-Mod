import 'package:JsxposedX/core/models/app_info.dart';
import 'package:JsxposedX/features/app/presentation/widgets/app_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickFunctionAppCard extends StatelessWidget {
  final AppInfo app;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const QuickFunctionAppCard({
    super.key,
    required this.app,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () => onToggle(!isEnabled),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: AppItem(app: app, onTap: () {}),
                    ),
                  ),
                  Switch.adaptive(
                    value: isEnabled,
                    onChanged: onToggle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
