import 'package:JsxposedX/common/widgets/app_code_editor/app_code_editor.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_question_parser.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_list_card.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_method_card.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_permission_card.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_question_card.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_steps_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:re_editor/re_editor.dart';

import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/bubble_toolbar.dart';
class AiCodeElementBuilder extends MarkdownElementBuilder {
  final BubbleState state;
  final BaseBubbleToolbarPart toolbarPart;
  final double? initialFontSize;
  final double uiScale;

  AiCodeElementBuilder({
    required this.state,
    required this.toolbarPart,
    this.initialFontSize,
    this.uiScale = 1.0,
  });

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final rawLanguage =
        element.attributes['class']?.replaceFirst('language-', '') ?? '';
    final codeContent = element.textContent.trim();

    // 解析增强 Markdown 语法：javascript:xposed:fileName 或 javascript:frida:fileName
    String language = rawLanguage;
    String? scriptType;
    String? suggestedFileName;
    
    if (rawLanguage.startsWith('javascript:')) {
      final parts = rawLanguage.split(':');
      if (parts.length >= 3) {
        language = parts[0]; // javascript
        scriptType = parts[1]; // xposed 或 frida
        suggestedFileName = parts.sublist(2).join(':'); // 文件名（可能包含冒号）
      } else if (parts.length == 2) {
        language = parts[0]; // javascript
        scriptType = parts[1]; // xposed 或 frida
      }
    }

    if (!element.textContent.contains('\n') && language.isEmpty) {
      return null;
    }

    if (language == 'list') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4 * uiScale),
        child: AiListCard(rawContent: codeContent),
      );
    }

    if (language == 'method') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4 * uiScale),
        child: AiMethodCard(rawContent: codeContent),
      );
    }

    if (language == 'steps') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4 * uiScale),
        child: AiStepsCard(rawContent: codeContent),
      );
    }

    if (language == 'permissions') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4 * uiScale),
        child: AiPermissionCard(rawContent: codeContent),
      );
    }

    if (language == 'question') {
      // Markdown 元素构建器拿到的只是代码块内部文本，不含 ``` 围栏。
      final question = AiQuestionParser.parseBlockBody(element.textContent);
      if (question == null) return null;
      // 仅当该问题正是当前挂起等待作答的问题时，卡片才可交互；
      // 历史消息里的提问块退化为只读展示。
      final onSubmit = state.pendingQuestion == question
          ? state.onAnswer
          : null;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4 * uiScale),
        child: AiQuestionCard(question: question, onSubmit: onSubmit),
      );
    }

    final controller = CodeLineEditingController.fromText(codeContent);
    final extraActions = toolbarPart.buildCodeActions(
      state: state,
      language: language,
      code: codeContent,
      scriptType: scriptType,
      suggestedFileName: suggestedFileName,
    );

    if (language == 'javascript' || language == 'js') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4 * uiScale),
        child: AppCodeEditor(
          controller: controller,
          language: language,
          readOnly: true,
          initialFontSize: (initialFontSize ?? 13) * uiScale,
          extraActions: extraActions,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4 * uiScale),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 400 * uiScale, minHeight: 0),
        child: AppCodeEditor(
          controller: controller,
          language: language,
          readOnly: true,
          initialFontSize: (initialFontSize ?? 13) * uiScale,
          extraActions: extraActions,
        ),
      ),
    );
  }
}
