import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

Widget buildOverlayTextInputContextMenu(
  BuildContext context,
  EditableTextState editableTextState,
) {
  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: _buildButtonItems(editableTextState),
  );
}

List<ContextMenuButtonItem> _buildButtonItems(
  EditableTextState editableTextState,
) {
  final buttonItems = editableTextState.contextMenuButtonItems
      .map(
        (item) => switch (item.type) {
          ContextMenuButtonType.copy => item.copyWith(
            onPressed: () => _handleCopy(editableTextState),
          ),
          ContextMenuButtonType.cut => item.copyWith(
            onPressed: () => _handleCut(editableTextState),
          ),
          ContextMenuButtonType.paste => item.copyWith(
            onPressed: () => _handlePaste(editableTextState),
          ),
          _ => item,
        },
      )
      .toList(growable: true);

  final canPaste = !editableTextState.widget.readOnly;
  final hasPaste = buttonItems.any(
    (item) => item.type == ContextMenuButtonType.paste,
  );
  if (canPaste && !hasPaste) {
    buttonItems.insert(
      _resolvePasteInsertIndex(buttonItems),
      ContextMenuButtonItem(
        type: ContextMenuButtonType.paste,
        onPressed: () => _handlePaste(editableTextState),
      ),
    );
  }

  return buttonItems;
}

int _resolvePasteInsertIndex(List<ContextMenuButtonItem> buttonItems) {
  final copyIndex = buttonItems.lastIndexWhere(
    (item) => item.type == ContextMenuButtonType.copy,
  );
  if (copyIndex >= 0) {
    return copyIndex + 1;
  }

  final cutIndex = buttonItems.lastIndexWhere(
    (item) => item.type == ContextMenuButtonType.cut,
  );
  if (cutIndex >= 0) {
    return cutIndex + 1;
  }

  return 0;
}

Future<void> _handleCopy(EditableTextState editableTextState) async {
  final selection = editableTextState.textEditingValue.selection;
  if (selection.isCollapsed) {
    editableTextState.hideToolbar();
    return;
  }

  final selectedText = selection.textInside(editableTextState.textEditingValue.text);
  if (selectedText.isEmpty) {
    editableTextState.hideToolbar();
    return;
  }

  await FlutterOverlayWindow.setClipboardData(selectedText);
  if (editableTextState.mounted) {
    editableTextState.hideToolbar();
  }
}

Future<void> _handleCut(EditableTextState editableTextState) async {
  if (editableTextState.widget.readOnly) {
    editableTextState.hideToolbar();
    return;
  }

  final selection = editableTextState.textEditingValue.selection;
  if (selection.isCollapsed) {
    editableTextState.hideToolbar();
    return;
  }

  final selectedText = selection.textInside(editableTextState.textEditingValue.text);
  if (selectedText.isEmpty) {
    editableTextState.hideToolbar();
    return;
  }

  final copied = await FlutterOverlayWindow.setClipboardData(selectedText);
  if (!copied || !editableTextState.mounted) {
    return;
  }

  final nextValue = editableTextState.textEditingValue.replaced(selection, '').copyWith(
    selection: TextSelection.collapsed(offset: selection.start),
    composing: TextRange.empty,
  );
  editableTextState.userUpdateTextEditingValue(
    nextValue,
    SelectionChangedCause.toolbar,
  );
  editableTextState.hideToolbar();
}

Future<void> _handlePaste(EditableTextState editableTextState) async {
  if (editableTextState.widget.readOnly) {
    editableTextState.hideToolbar();
    return;
  }

  final clipboardText = await FlutterOverlayWindow.getClipboardData();
  if (!editableTextState.mounted || clipboardText == null || clipboardText.isEmpty) {
    editableTextState.hideToolbar();
    return;
  }

  final selection = editableTextState.textEditingValue.selection;
  final collapsedValue = editableTextState.textEditingValue.copyWith(
    selection: TextSelection.collapsed(offset: selection.start),
    composing: TextRange.empty,
  );
  editableTextState.userUpdateTextEditingValue(
    collapsedValue.replaced(selection, clipboardText),
    SelectionChangedCause.toolbar,
  );

  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!editableTextState.mounted) {
      return;
    }
    editableTextState.bringIntoView(
      editableTextState.textEditingValue.selection.extent,
    );
    editableTextState.hideToolbar();
  });
}
