import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// 默认的粘贴感知上下文菜单构建器，确保长按时始终显示粘贴按钮
Widget _defaultContextMenuBuilder(
  BuildContext context,
  EditableTextState editableTextState,
) {
  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: _ensurePasteButton(editableTextState),
  );
}

List<ContextMenuButtonItem> _ensurePasteButton(
  EditableTextState editableTextState,
) {
  final buttonItems = editableTextState.contextMenuButtonItems
      .map((item) => item.type == ContextMenuButtonType.paste
          ? item.copyWith(
              onPressed: () => _pasteFromClipboard(editableTextState),
            )
          : item)
      .toList(growable: true);

  final canPaste = !editableTextState.widget.readOnly;
  final hasPaste =
      buttonItems.any((item) => item.type == ContextMenuButtonType.paste);
  if (canPaste && !hasPaste) {
    final insertIndex = _pasteInsertIndex(buttonItems);
    buttonItems.insert(
      insertIndex,
      ContextMenuButtonItem(
        type: ContextMenuButtonType.paste,
        onPressed: () => _pasteFromClipboard(editableTextState),
      ),
    );
  }

  return buttonItems;
}

int _pasteInsertIndex(List<ContextMenuButtonItem> buttonItems) {
  final copyIdx =
      buttonItems.lastIndexWhere((item) => item.type == ContextMenuButtonType.copy);
  if (copyIdx >= 0) return copyIdx + 1;
  final cutIdx =
      buttonItems.lastIndexWhere((item) => item.type == ContextMenuButtonType.cut);
  if (cutIdx >= 0) return cutIdx + 1;
  return 0;
}

Future<void> _pasteFromClipboard(EditableTextState editableTextState) async {
  if (editableTextState.widget.readOnly) {
    editableTextState.hideToolbar();
    return;
  }

  final data = await Clipboard.getData(Clipboard.kTextPlain);
  final text = data?.text;
  if (!editableTextState.mounted || text == null || text.isEmpty) {
    editableTextState.hideToolbar();
    return;
  }

  final value = editableTextState.textEditingValue;
  final selection = value.selection.isValid
      ? value.selection
      : TextSelection.collapsed(offset: value.text.length);
  final nextValue = value
      .replaced(selection, text)
      .copyWith(
        selection: TextSelection.collapsed(offset: selection.start + text.length),
        composing: TextRange.empty,
      );
  editableTextState.userUpdateTextEditingValue(
    nextValue,
    SelectionChangedCause.toolbar,
  );

  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!editableTextState.mounted) return;
    editableTextState.bringIntoView(
      editableTextState.textEditingValue.selection.extent,
    );
    editableTextState.hideToolbar();
  });
}

/// 精美输入框

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final bool enabled;
  final TextStyle? textStyle;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final String? name;
  final List<TextInputFormatter>? inputFormatters;
  final bool isFormBuilder;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.textStyle,
    this.fillColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.name,
    this.inputFormatters,
    this.isFormBuilder = false,
    this.contextMenuBuilder,
  });

  /// FormBuilder 版本（不需要 Controller）
  factory CustomTextField.formBuilder({
    Key? key,
    required String name,
    String? hintText,
    String? labelText,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
    int? maxLength,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String?)? onChanged,
    bool enabled = true,
    TextStyle? textStyle,
    Color? fillColor,
    Color? focusedBorderColor,
    Color? enabledBorderColor,
    List<TextInputFormatter>? inputFormatters,
    Widget Function(BuildContext, EditableTextState)? contextMenuBuilder,
    //// 只能输入数字
    // inputFormatters: [FilteringTextInputFormatter.digitsOnly]
    //
    // // 只能输入数字和小数点
    // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
    //
    // // 只能输入字母
    // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))]
    //
    // // 限制长度（例如最多10个字符）
    // inputFormatters: [LengthLimitingTextInputFormatter(10)]
  }) {
    return CustomTextField(
      key: key,
      name: name,
      hintText: hintText,
      labelText: labelText,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      textStyle: textStyle,
      fillColor: fillColor,
      focusedBorderColor: focusedBorderColor,
      enabledBorderColor: enabledBorderColor,
      inputFormatters: inputFormatters,
      isFormBuilder: true,
      contextMenuBuilder: contextMenuBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor,

      // 默认边框
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: enabledBorderColor ?? Colors.grey.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),

      // 获得焦点时的边框
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: focusedBorderColor ?? theme.colorScheme.primary,
          width: 2,
        ),
      ),

      // 错误边框
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),

      // 错误且获得焦点时的边框
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),

      // 禁用时的边框
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );

    // 如果是 FormBuilder 版本
    if (isFormBuilder && name != null) {
      return FormBuilderTextField(
        name: name!,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,
        enableInteractiveSelection: true,
        style: textStyle ?? const TextStyle(fontSize: 16),
        decoration: decoration,
        inputFormatters: inputFormatters,
        contextMenuBuilder:
            contextMenuBuilder ?? _defaultContextMenuBuilder,
      );
    }

    // 普通版本
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      enableInteractiveSelection: true,
      style: textStyle ?? const TextStyle(fontSize: 16),
      decoration: decoration,
      inputFormatters: inputFormatters,
      contextMenuBuilder:
          contextMenuBuilder ?? _defaultContextMenuBuilder,
    );
  }
}
