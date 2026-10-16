import 'package:JsxposedX/core/themes/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

quill.DefaultStyles buildCustomStyles(
  TextTheme textTheme,
  ColorScheme colorScheme,
) {
  return quill.DefaultStyles(
    h1: quill.DefaultTextBlockStyle(
      textTheme.headlineLarge!.copyWith(
        color: colorScheme.onSurface,
        fontFamily: AppFonts.primary,
      ),
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      null,
    ),
    h2: quill.DefaultTextBlockStyle(
      textTheme.headlineMedium!.copyWith(
        color: colorScheme.onSurface,
        fontFamily: AppFonts.primary,
      ),
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      null,
    ),
    h3: quill.DefaultTextBlockStyle(
      textTheme.headlineSmall!.copyWith(
        color: colorScheme.onSurface,
        fontFamily: AppFonts.primary,
      ),
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      null,
    ),
    paragraph: quill.DefaultTextBlockStyle(
      textTheme.bodyLarge!.copyWith(
        color: colorScheme.onSurface,
        fontFamily: AppFonts.primary,
      ),
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      null,
    ),
    bold: TextStyle(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
      fontFamily: AppFonts.primary,
    ),
    italic: TextStyle(
      fontStyle: FontStyle.italic,
      color: colorScheme.onSurface,
      fontFamily: AppFonts.primary,
    ),
    underline: TextStyle(
      decoration: TextDecoration.underline,
      color: colorScheme.onSurface,
      fontFamily: AppFonts.primary,
    ),
    strikeThrough: TextStyle(
      decoration: TextDecoration.lineThrough,
      color: colorScheme.onSurface,
      fontFamily: AppFonts.primary,
    ),
    link: TextStyle(
      color: Colors.blue,
      // 文字颜色
      decoration: TextDecoration.underline,
      // 添加下划线
      decorationColor: Colors.blue,
      // ⭐ 下划线颜色
      fontFamily: AppFonts.primary,
      decorationThickness: 2.0,
    ),
    color: colorScheme.onSurface,
    placeHolder: quill.DefaultTextBlockStyle(
      textTheme.bodyLarge!.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.6),
        fontFamily: AppFonts.primary,
      ),
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      null,
    ),
    lists: quill.DefaultListBlockStyle(
      textTheme.bodyLarge!.copyWith(
        color: colorScheme.onSurface,
        fontFamily: AppFonts.primary,
      ),
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      null,
      null,
    ),
    quote: quill.DefaultTextBlockStyle(
      textTheme.bodyLarge!.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.8),
        fontStyle: FontStyle.italic,
        fontFamily: AppFonts.primary,
      ),
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      BoxDecoration(
        border: Border(left: BorderSide(color: colorScheme.primary, width: 4)),
      ),
    ),
    code: quill.DefaultTextBlockStyle(
      textTheme.bodyMedium!.copyWith(
        color: colorScheme.onSurface,
        fontFamily: AppFonts.code,
        backgroundColor: colorScheme.surfaceContainerHighest,
      ),
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    inlineCode: quill.InlineCodeStyle(
      backgroundColor: colorScheme.surfaceContainerHighest,
      radius: const Radius.circular(4),
      style: textTheme.bodyMedium!.copyWith(
        color: colorScheme.onSurface,
        fontFamily: AppFonts.code,
      ),
    ),
  );
}
