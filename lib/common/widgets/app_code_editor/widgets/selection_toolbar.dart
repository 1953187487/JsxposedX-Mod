import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_editor/re_editor.dart';

class SystemSelectionToolbarController implements SelectionToolbarController {
  OverlayEntry? _entry;
  final String? customActionLabel;
  final void Function(String selectedText)? onCustomAction;

  SystemSelectionToolbarController({
    this.customActionLabel,
    this.onCustomAction,
  });

  @override
  void hide(BuildContext context) {
    _entry?.remove();
    _entry = null;
  }

  @override
  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
    Rect? renderRect,
  }) {
    hide(context);
    final entry = OverlayEntry(
      builder: (context) => SelectionToolbar(
        anchors: anchors,
        onCopy: () {
          Clipboard.setData(ClipboardData(text: controller.selectedText));
          hide(context);
        },
        onCut: () {
          Clipboard.setData(ClipboardData(text: controller.selectedText));
          controller.replaceSelection('');
          hide(context);
        },
        onPaste: () async {
          final data = await Clipboard.getData(Clipboard.kTextPlain);
          if (data?.text != null) {
            controller.replaceSelection(data!.text!);
          }
          hide(context);
        },
        onSelectAll: () {
          final lastIndex = controller.codeLines.length - 1;
          controller.selection = CodeLineSelection(
            baseIndex: 0,
            baseOffset: 0,
            extentIndex: lastIndex,
            extentOffset: controller.codeLines[lastIndex].length,
          );
          hide(context);
        },
        onComment: () {
          final selection = controller.selection;
          final startLine = selection.baseIndex;
          final endLine = selection.extentIndex;
          final minLine = startLine < endLine ? startLine : endLine;
          final maxLine = startLine < endLine ? endLine : startLine;

          final List<String> newLines = [];
          for (int i = minLine; i <= maxLine; i++) {
            final lineText = controller.codeLines[i].text;
            if (lineText.trimLeft().startsWith('//')) {
              final index = lineText.indexOf('//');
              newLines.add(lineText.replaceFirst('//', '', index));
            } else {
              newLines.add('// $lineText');
            }
          }

          controller.selection = CodeLineSelection(
            baseIndex: minLine,
            baseOffset: 0,
            extentIndex: maxLine,
            extentOffset: controller.codeLines[maxLine].length,
          );
          controller.replaceSelection(newLines.join('\n'));
          hide(context);
        },
        customActionLabel: customActionLabel,
        onCustomAction: onCustomAction != null
            ? () {
                final text = controller.selectedText;
                hide(context);
                onCustomAction!(text);
              }
            : null,
      ),
    );
    _entry = entry;
    Overlay.of(context).insert(entry);
  }
}

class SelectionToolbar extends StatelessWidget {
  final TextSelectionToolbarAnchors anchors;
  final VoidCallback onCopy;
  final VoidCallback onCut;
  final VoidCallback onPaste;
  final VoidCallback onSelectAll;
  final VoidCallback onComment;
  final String? customActionLabel;
  final VoidCallback? onCustomAction;

  const SelectionToolbar({
    super.key,
    required this.anchors,
    required this.onCopy,
    required this.onCut,
    required this.onPaste,
    required this.onSelectAll,
    required this.onComment,
    this.customActionLabel,
    this.onCustomAction,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CodeEditorTapRegion(
      child: Material(
        type: MaterialType.transparency,
        child: AdaptiveTextSelectionToolbar.buttonItems(
          anchors: anchors,
      buttonItems: [
            ContextMenuButtonItem(label: l10n.selectAll, onPressed: onSelectAll),
            ContextMenuButtonItem(label: l10n.cut, onPressed: onCut),
            ContextMenuButtonItem(label: l10n.copy, onPressed: onCopy),
            ContextMenuButtonItem(label: l10n.paste, onPressed: onPaste),
            if (onCustomAction != null && customActionLabel != null)
              ContextMenuButtonItem(label: customActionLabel!, onPressed: onCustomAction)
            else
              ContextMenuButtonItem(label: l10n.comment, onPressed: onComment),
          ],
        ),
      ),
    );
  }
}
