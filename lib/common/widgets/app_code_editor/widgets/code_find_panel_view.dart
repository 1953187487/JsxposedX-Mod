import 'dart:ui';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:re_editor/re_editor.dart';

class CodeFindPanelView extends HookWidget implements PreferredSizeWidget {
  final CodeFindController controller;
  final bool readOnly;

  const CodeFindPanelView({
    super.key,
    required this.controller,
    required this.readOnly,
  });

  @override
  Size get preferredSize => Size(
        double.infinity,
        controller.value == null ? 0 : (controller.value!.replaceMode ? 120.0 : 64.0),
      );

  @override
  Widget build(BuildContext context) {
    useListenable(controller);
    final value = controller.value;
    if (value == null) return const SizedBox.shrink();

    final isDark = context.isDark;
    final bg = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.35 : 0.12);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.topRight,
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 24,
              spreadRadius: -2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: bg.withValues(alpha: isDark ? 0.75 : 0.88),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FindRow(controller: controller, value: value),
                  if (value.replaceMode) ...[
                    const SizedBox(height: 8),
                    _ReplaceRow(controller: controller, value: value),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FindRow extends StatelessWidget {
  final CodeFindController controller;
  final CodeFindValue value;

  const _FindRow({required this.controller, required this.value});

  @override
  Widget build(BuildContext context) {
    final resultText = value.result == null 
        ? '0 / 0' 
        : '${value.result!.index + 1} / ${value.result!.matches.length}';

    return Row(
      children: [
        _ActionIcon(
          onPressed: () => controller.value = value.copyWith(
            replaceMode: !value.replaceMode,
            result: value.result,
          ),
          icon: value.replaceMode ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
          tooltip: context.l10n.toggleReplace,
          size: 30,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _CustomTextField(
            controller: controller.findInputController,
            focusNode: controller.findInputFocusNode,
            hintText: context.l10n.searchCode,
            actions: [
              _TextOption(
                label: 'Aa',
                tooltip: context.l10n.matchCase,
                active: value.option.caseSensitive,
                onTap: () => controller.toggleCaseSensitive(),
              ),
              _TextOption(
                label: '.*',
                tooltip: context.l10n.regex,
                active: value.option.regex,
                onTap: () => controller.toggleRegex(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          resultText,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 6),
        _ActionIcon(
          onPressed: value.result == null ? null : () => controller.previousMatch(),
          icon: Icons.keyboard_arrow_up_rounded,
          size: 30,
        ),
        _ActionIcon(
          onPressed: value.result == null ? null : () => controller.nextMatch(),
          icon: Icons.keyboard_arrow_down_rounded,
          size: 30,
        ),
        const SizedBox(width: 4),
        _ActionIcon(
          onPressed: () {
            controller.findInputController.clear();
            controller.replaceInputController.clear();
            controller.close();
          },
          icon: Icons.close_rounded,
          tooltip: context.l10n.close,
          iconColor: Colors.redAccent.withValues(alpha: 0.9),
          hoverColor: Colors.red.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}

class _ReplaceRow extends StatelessWidget {
  final CodeFindController controller;
  final CodeFindValue value;

  const _ReplaceRow({required this.controller, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 28),
        Expanded(
          child: _CustomTextField(
            controller: controller.replaceInputController,
            focusNode: controller.replaceInputFocusNode,
            hintText: context.l10n.replaceWith,
          ),
        ),
        const SizedBox(width: 8),
        _ActionIcon(
          onPressed: value.result == null ? null : () => controller.replaceMatch(),
          icon: Icons.find_replace_rounded,
          tooltip: context.l10n.replace,
        ),
        _ActionIcon(
          onPressed: value.result == null ? null : () => controller.replaceAllMatches(),
          icon: Icons.done_all_rounded,
          tooltip: context.l10n.replaceAll,
        ),
        const SizedBox(width: 32), 
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final List<Widget>? actions;

  const _CustomTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(6),
      ),
      // 注意：这里绝对不能再让 TextField 渲染任何自己的边框或胶囊阴影
      child: Theme(
        data: Theme.of(context).copyWith(
          // 强制覆盖可能有干扰的主题，确保没有任何背景和边框
          inputDecorationTheme: const InputDecorationTheme(
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: context.textTheme.bodyMedium?.copyWith(
                    height: 1.0,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      fontSize: 13,
                    ),
                    isCollapsed: true, // 极其重要：确保文字垂直居中且不产生额外高度
                  ),
                ),
              ),
            ),
            if (actions != null) ...[
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TextOption extends HookWidget {
  final String label;
  final String tooltip;
  final bool active;
  final VoidCallback onTap;

  const _TextOption({
    required this.label,
    required this.tooltip,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final primary = context.colorScheme.primary;
    
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: active ? primary.withValues(alpha: 0.15) : (isHovered.value ? Colors.black12 : Colors.transparent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                color: active ? primary : context.colorScheme.onSurfaceVariant,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends HookWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? hoverColor;
  final Color? iconColor;
  final double size;

  const _ActionIcon({
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.hoverColor,
    this.iconColor,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    
    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: InkResponse(
        onTap: onPressed,
        radius: 18,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isHovered.value && onPressed != null 
                ? (hoverColor ?? context.colorScheme.primary.withValues(alpha: 0.1)) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 18,
            color: onPressed == null 
                ? context.colorScheme.onSurfaceVariant.withValues(alpha: 0.2)
                : (iconColor ?? (isHovered.value ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.75))),
          ),
        ),
      ),
    );
  }
}
