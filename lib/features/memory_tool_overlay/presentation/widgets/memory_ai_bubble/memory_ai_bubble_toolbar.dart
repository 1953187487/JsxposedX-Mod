import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_panel_dialog.dart';
import 'package:JsxposedX/common/widgets/overlay_window/overlay_text_input_context_menu.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/bubble_toolbar.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/widgets/code_run_action.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/widgets/code_save_action.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class MemoryAiBubbleToolbarPart extends BaseBubbleToolbarPart {
  const MemoryAiBubbleToolbarPart();

  /// 悬浮窗为独立引擎，share_plus 依赖宿主 Activity，直接分享会失败。
  @override
  bool get supportsSystemShare => false;

  @override
  void handleCopyToClipboard(BuildContext context, String text) async {
    final copied = await FlutterOverlayWindow.setClipboardData(text);
    await ToastOverlayMessage.show(
      copied ? context.l10n.codeCopied : context.l10n.error,
    );
  }

  /// 复用宿主组件里的代码块动作，否则悬浮窗中的 JS 代码块会缺少
  /// 「运行」「保存」按钮（此前被阉割的表现之一）。
  @override
  List<Widget> buildCodeActions({
    required BubbleState state,
    required String language,
    required String code,
    String? scriptType,
    String? suggestedFileName,
  }) {
    return [
      CodeRunAction(
        code: code,
        packageName: state.packageName,
        scriptType: scriptType,
        suggestedFileName: suggestedFileName,
      ),
      CodeSaveAction(
        code: code,
        packageName: state.packageName,
        language: language,
        scriptType: scriptType,
        suggestedFileName: suggestedFileName,
      ),
      const SizedBox(width: 4),
    ];
  }

  /// 悬浮窗内没有可用的 `showModalBottomSheet` 宿主，统一改用
  /// [OverlayPanelDialog] 承载各类操作面板。
  @override
  Future<void> presentSheet({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return showOverlayPanelSheet(
      context: context,
      title: title,
      child: child,
    );
  }

  @override
  Future<void> showTextSelectionSheet(
    BuildContext context, {
    required String title,
    required String text,
  }) async {
    final scale = AiChatCompactScope.scaleOf(context);
    await presentSheet(
      context: context,
      title: title,
      child: SelectableText(
        text,
        contextMenuBuilder: buildOverlayTextInputContextMenu,
        style: TextStyle(
          fontSize: 14 * scale,
          height: 1.5,
        ),
      ),
    );
  }
}
