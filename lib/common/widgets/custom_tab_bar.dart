import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:JsxposedX/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomTabBar extends HookConsumerWidget {
  final TabController tabController;
  final List<Widget> tabs;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return TabBar(
      controller: tabController,
      labelColor: AppColors.textWhite,
      //选中文字颜色
      unselectedLabelColor: isDark ? Colors.grey : AppColors.textPrimary,
      indicatorColor: isDark ? Colors.grey : AppColors.primary,
      indicator: BoxDecoration(
        color: context.colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: const EdgeInsets.symmetric(
        horizontal: -12,
        vertical: 10, // 增加这个值会让指示器变矮，减少会让它变高
      ),
      dividerColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.blue.withValues(alpha: 0.1)),

      tabs: tabs,
    );
  }
}
