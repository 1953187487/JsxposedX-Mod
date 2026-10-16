import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:re_editor/re_editor.dart';

import 'toolbar_icon.dart';
import 'toolbar_text_button.dart';

class AppCodeEditorToolbar extends HookWidget {
  final CodeLineEditingController controller;

  const AppCodeEditorToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    useValueListenable(controller);

    return CodeEditorTapRegion(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.theme.colorScheme.outlineVariant.withValues(
                alpha: 0.3,
              ),
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ToolbarIcon(
                icon: Icons.undo_rounded,
                tooltip: context.l10n.undo,
                onPressed: controller.canUndo ? controller.undo : null,
              ),
              ToolbarIcon(
                icon: Icons.redo_rounded,
                tooltip: context.l10n.redo,
                onPressed: controller.canRedo ? controller.redo : null,
              ),
              SizedBox(width: 8.w),
              ...[
                "Fun",
                "↹",
                "←",
                "→",
                "↑",
                "↓",
                "Jx",
                "(",
                ")",
                "[",
                "]",
                "{",
                "}",
                "~",
                "\$",
                ".",
                "\"",
                "\"\"",
                "=",
                ":",
                ",",
                ";",
                "'",
                "_",
                "+",
                "-",
                "*",
                "/",
                "\\",
                "%",
                "#",
                "^",
                "\$",
                "?",
                "&",
                "|",
                "<",
                ">",
                "`",
              ].map(
                (symbol) => ToolbarTextButton(
                  text: symbol,
                  onPressed: () {
                    if (symbol == 'Fun') {
                      controller.replaceSelection('function () {\n  \n}');
                    } else if (symbol == '↹') {
                      controller.replaceSelection('  ');
                    } else if (symbol == '←') {
                      controller.moveCursor(AxisDirection.left);
                    } else if (symbol == '→') {
                      controller.moveCursor(AxisDirection.right);
                    } else if (symbol == '↑') {
                      controller.moveCursor(AxisDirection.up);
                    } else if (symbol == '↓') {
                      controller.moveCursor(AxisDirection.down);
                    } else {
                      controller.replaceSelection(symbol);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
