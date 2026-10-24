import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 主题颜色选择：圆角方块色卡 + 当前主色高亮
class ThemeColorPicker extends ConsumerWidget {
  const ThemeColorPicker({super.key});

  static const List<Color> _palette = [
    Color(0xFF6366F1), // 默认 · AI 靛蓝
    const Color(0xFF3B82F6), // 天蓝
    const Color(0xFF06B6D4), // 青
    const Color(0xFF22C55E), // 绿
    const Color(0xFF84CC16), // 草绿
    const Color(0xFFEAB308), // 金
    const Color(0xFFF97316), // 橙
    const Color(0xFFEF4444), // 红
    const Color(0xFFEC4899), // 粉
    const Color(0xFFA855F7), // 紫
  ];

  static void show(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      title: context.l10n.selectThemeColor,
      child: const ThemeColorPicker(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final currentColor = theme.colorScheme.primary;
    final colorScheme = context.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisExtent: 56.h,
          mainAxisSpacing: 14.h,
          crossAxisSpacing: 12.w,
        ),
        itemCount: _palette.length,
        itemBuilder: (context, index) {
          final color = _palette[index];
          final isSelected = _isSameColor(currentColor, color);
          return GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).updatePrimaryColor(color);
              Navigator.pop(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.onSurface
                      : Colors.transparent,
                  width: 2.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isSelected ? 0.45 : 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size: 24.sp,
                      color: color.computeLuminance() > 0.55
                          ? const Color(0xFF10131A)
                          : Colors.white,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  bool _isSameColor(Color a, Color b) {
    final da = a.toDouble();
    final db = b.toDouble();
    return (da - db).abs() < 2;
  }
}

extension on Color {
  double toDouble() => toARGB32().toDouble();
}
