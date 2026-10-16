import 'package:flutter/foundation.dart';

import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_tool_invocation_view.dart';

@immutable
class BubbleState {
  final String content;
  final String role;
  final bool isError;
  final VoidCallback? onRetry;
  final String? packageName;
  final String? retryLabel;
  final String? loadingHint;
  final bool streaming;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRegenerate;

  /// 引用回复：把当前消息作为引用块带入输入框。
  final VoidCallback? onQuote;
  final String? rawDetails;
  final List<AiToolInvocationView> toolInvocations;
  final VoidCallback? onToolApprove;
  final VoidCallback? onToolReject;

  /// 问答模式：当前挂起等待作答的问题（用于判断选项卡片是否可交互）。
  final AiQuestion? pendingQuestion;

  /// 问答模式：用户选择选项后提交作答。
  final ValueChanged<List<String>>? onAnswer;

  /// 非侵入式错误提示：气泡内容正常展示时，流式中断/失败的补充说明。
  /// 非空时不影响 isError（红边框、重试按钮）等既有样式。
  final String? errorHint;

  /// AI 回复携带的图片源（http(s) 链接、data URI 或本地绝对路径），
  /// 与正文一起图文混排展示。
  final List<String> imageSources;

  const BubbleState({
    required this.content,
    required this.role,
    required this.isError,
    required this.onRetry,
    required this.packageName,
    this.retryLabel,
    this.loadingHint,
    this.streaming = false,
    this.onEdit,
    this.onDelete,
    this.onRegenerate,
    this.onQuote,
    this.rawDetails,
    this.toolInvocations = const <AiToolInvocationView>[],
    this.onToolApprove,
    this.onToolReject,
    this.pendingQuestion,
    this.onAnswer,
    this.errorHint,
    this.imageSources = const <String>[],
  });

  bool get isUser => role == 'user';

  bool get isSystem => role == 'system';

  bool get isLoading =>
      !isUser &&
      content.isEmpty &&
      imageSources.isEmpty &&
      !isError &&
      toolInvocations.isEmpty;

  bool get isToolResult {
    return !isUser &&
        (toolInvocations.isNotEmpty ||
            content.startsWith('✅') ||
            content.startsWith('❌'));
  }
}
