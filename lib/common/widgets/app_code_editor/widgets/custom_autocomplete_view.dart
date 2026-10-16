import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:re_editor/re_editor.dart';

class CustomAutocompleteView extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<CodeAutocompleteEditingValue> notifier;
  final ValueChanged<CodeAutocompleteResult> onSelected;

  const CustomAutocompleteView({
    super.key,
    required this.notifier,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CodeAutocompleteEditingValue>(
      valueListenable: notifier,
      builder: (context, value, _) {
        final prompts = value.prompts;
        if (prompts.isEmpty) {
          return const SizedBox.shrink();
        }

        return CodeEditorTapRegion(
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8.r),
            color: context.theme.cardColor,
            child: Container(
              constraints: BoxConstraints(maxHeight: 200.h, maxWidth: 280.w),
              decoration: BoxDecoration(
                border: Border.all(color: context.theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8.r),
              ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: prompts.length,
              itemBuilder: (context, index) {
                final prompt = prompts[index];
                final isSelected = index == value.index;
                
                return InkWell(
                  onTap: () {
                    onSelected(value.copyWith(index: index).autocomplete);
                  },
                  child: Container(
                    color: isSelected 
                      ? context.theme.colorScheme.primaryContainer 
                      : Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    child: _buildPromptItem(context, prompt, isSelected),
                  ),
                );
              },
            ),
          ),
          ),
        );
      },
    );
  }

  Widget _buildPromptItem(BuildContext context, CodePrompt prompt, bool isSelected) {
    final primaryColor = isSelected
        ? context.theme.colorScheme.onPrimaryContainer
        : context.theme.colorScheme.onSurface;
    final secondaryColor = isSelected
        ? context.theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6)
        : context.theme.colorScheme.onSurface.withValues(alpha: 0.5);

    // 函数提示：显示 name(params) → returnType
    if (prompt is CodeFunctionPrompt) {
      final params = prompt.parameters.keys.join(', ');
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.functions_rounded, size: 14.sp, color: Colors.purple.withValues(alpha: 0.8)),
          SizedBox(width: 6.w),
          Flexible(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: prompt.word,
                  style: TextStyle(fontSize: 13.sp, fontFamily: 'monospace', color: primaryColor),
                ),
                TextSpan(
                  text: '($params)',
                  style: TextStyle(fontSize: 11.sp, fontFamily: 'monospace', color: secondaryColor),
                ),
              ]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            prompt.type,
            style: TextStyle(fontSize: 10.sp, fontFamily: 'monospace', color: secondaryColor, fontStyle: FontStyle.italic),
          ),
        ],
      );
    }

    // 字段提示：显示 name : type
    if (prompt is CodeFieldPrompt) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 14.sp, color: Colors.blue.withValues(alpha: 0.8)),
          SizedBox(width: 6.w),
          Text(
            prompt.word,
            style: TextStyle(fontSize: 13.sp, fontFamily: 'monospace', color: primaryColor),
          ),
          SizedBox(width: 6.w),
          Text(
            prompt.type,
            style: TextStyle(fontSize: 10.sp, fontFamily: 'monospace', color: secondaryColor, fontStyle: FontStyle.italic),
          ),
        ],
      );
    }

    // 关键词提示（默认）
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.code_rounded, size: 14.sp, color: Colors.orange.withValues(alpha: 0.8)),
        SizedBox(width: 6.w),
        Text(
          prompt.word,
          style: TextStyle(fontSize: 13.sp, fontFamily: 'monospace', color: primaryColor),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(280, 200);
}
