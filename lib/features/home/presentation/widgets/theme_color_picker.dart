import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 专门负责显示主题颜色选择的逻辑，它只提供内部的 GridView 内容
class ThemeColorPicker extends ConsumerWidget {
  const ThemeColorPicker({super.key});

  /// 调用此方法来显示调色盘
  static void show(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: context.l10n.selectThemeColor,
      child: const ThemeColorPicker(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = [
      const Color(0xFF98D2D5), // 默认
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.green,
      const Color(0xFF4CAF50), // Success Green
      Colors.teal,
      Colors.brown,
      Colors.blueGrey,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 15.h,
        crossAxisSpacing: 15.w,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        return GestureDetector(
          onTap: () {
            ref.read(themeProvider.notifier).updatePrimaryColor(color);
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
