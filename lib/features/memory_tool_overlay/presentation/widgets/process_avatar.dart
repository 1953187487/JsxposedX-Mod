import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProcessAvatar extends StatelessWidget {
  const ProcessAvatar({super.key, required this.process});

  final ProcessInfo? process;

  @override
  Widget build(BuildContext context) {
    final icon = process?.icon;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: 40.r,
        height: 40.r,
        child: icon != null && icon.isNotEmpty
            ? Image.memory(
                icon,
                fit: BoxFit.cover,
                cacheWidth:
                    (40.r * MediaQuery.devicePixelRatioOf(context)).round(),
                cacheHeight:
                    (40.r * MediaQuery.devicePixelRatioOf(context)).round(),
              )
            : ColoredBox(
                color: context.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.apps_rounded,
                  size: 20.r,
                  color: context.colorScheme.primary,
                ),
              ),
      ),
    );
  }
}
