import 'package:JsxposedX/core/themes/app_colors.dart';
import 'package:JsxposedX/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';

/// 应用主题配置（beta.2 全面重写：更深的表面层次、更大的圆角、更现代的暗色）
class AppTheme {
  AppTheme._();

  static Color _onPrimaryFor(Color seed) {
    return seed.computeLuminance() > 0.55 ? const Color(0xFF10131A) : Colors.white;
  }

  /// 亮色主题
  static ThemeData lightTheme(Color seedColor) {
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    final colorScheme = base.copyWith(
      primary: seedColor,
      onPrimary: _onPrimaryFor(seedColor),
      secondary: AppColors.secondary,
      surface: const Color(0xFFF7F8FC),
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLow: const Color(0xFFF2F4FA),
      surfaceContainer: AppColors.surfaceVariant,
      surfaceContainerHigh: const Color(0xFFE9EDF5),
      surfaceContainerHighest: const Color(0xFFE3E7F0),
      outline: const Color(0xFFD4D9E4),
      outlineVariant: AppColors.divider,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.primary,

      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,

      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: seedColor,
        unselectedItemColor: AppColors.textHint,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      chipTheme: chipThemeBase(seedColor).copyWith(
        backgroundColor: colorScheme.surfaceContainer,
        selectedColor: seedColor.withValues(alpha: 0.16),
        disabledColor: colorScheme.surfaceContainerLow,
        labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontFamily: AppFonts.primary),
        side: BorderSide.none,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: seedColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: _onPrimaryFor(seedColor),
          disabledBackgroundColor: seedColor.withValues(alpha: 0.35),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: _onPrimaryFor(seedColor),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: seedColor,
          side: BorderSide(color: seedColor.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: seedColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: seedColor,
        foregroundColor: _onPrimaryFor(seedColor),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color(0xFFF7F8FC),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2A2F3A),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: AppFonts.primary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: AppFonts.primary,
        ),
        subtitleTextStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: AppFonts.primary),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),

      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: seedColor, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 1.8),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  /// 暗色主题
  static ThemeData darkTheme(Color seedColor) {
    final base = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    final colorScheme = base.copyWith(
      primary: seedColor,
      onPrimary: _onPrimaryFor(seedColor),
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      onSurface: const Color(0xFFE6EAF2),
      onSurfaceVariant: const Color(0xFFA0AABB),
      surfaceContainerLowest: AppColors.darkBackground,
      surfaceContainerLow: const Color(0xFF151920),
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      outline: const Color(0xFF39414F),
      outlineVariant: const Color(0xFF2A3140),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppFonts.primary,

      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,

      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: const Color(0xFFE6EAF2),
        titleTextStyle: const TextStyle(
          color: Color(0xFFE6EAF2),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: seedColor,
        unselectedItemColor: const Color(0xFF6B7385),
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      chipTheme: chipThemeBase(seedColor).copyWith(
        backgroundColor: AppColors.darkSurfaceContainer,
        selectedColor: seedColor.withValues(alpha: 0.22),
        disabledColor: AppColors.darkSurface,
        labelStyle: const TextStyle(
          color: Color(0xFFE6EAF2),
          fontSize: 13,
          fontFamily: AppFonts.primary,
        ),
        side: BorderSide.none,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: seedColor, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: _onPrimaryFor(seedColor),
          disabledBackgroundColor: seedColor.withValues(alpha: 0.35),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: _onPrimaryFor(seedColor),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: seedColor,
          side: BorderSide(color: seedColor.withValues(alpha: 0.45)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: seedColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: seedColor,
        foregroundColor: _onPrimaryFor(seedColor),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A3140),
        thickness: 1,
        space: 1,
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.darkSurfaceContainer,
        elevation: 10,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(color: Color(0xFFE6EAF2), fontSize: 14),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceContainerHighest,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: AppFonts.primary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: const Color(0xFFA0AABB),
        textColor: const Color(0xFFE6EAF2),
        titleTextStyle: const TextStyle(
          color: Color(0xFFE6EAF2),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: AppFonts.primary,
        ),
        subtitleTextStyle: const TextStyle(color: Color(0xFFA0AABB), fontSize: 13, fontFamily: AppFonts.primary),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(color: seedColor),

      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(fontSize: 16, color: Color(0xFFE6EAF2)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceContainer,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: seedColor, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 1.8),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.darkSurfaceContainer),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  static ChipThemeData chipThemeBase(Color seedColor) {
    return ChipThemeData(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      selectedColor: seedColor.withValues(alpha: 0.16),
      labelStyle: const TextStyle(fontSize: 13, fontFamily: AppFonts.primary),
      secondaryLabelStyle: TextStyle(
        color: seedColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        fontFamily: AppFonts.primary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide.none,
      showCheckmark: false,
    );
  }
}
