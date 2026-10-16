import 'package:flutter/material.dart';

import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_container.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_content/bubble_content.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_states/bubble_state.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/bubble_toolbar/bubble_toolbar.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_tool_invocation_view.dart';

abstract class BaseAiChatBubble extends StatelessWidget {
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
  final VoidCallback? onQuote;
  final String? rawDetails;
  final List<AiToolInvocationView> toolInvocations;
  final VoidCallback? onToolApprove;
  final VoidCallback? onToolReject;
  final String? errorHint;
  final List<String> imageSources;
  final AiQuestion? pendingQuestion;
  final ValueChanged<List<String>>? onAnswer;

  const BaseAiChatBubble({
    super.key,
    required this.content,
    required this.role,
    this.isError = false,
    this.onRetry,
    this.packageName,
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
    this.errorHint,
    this.imageSources = const <String>[],
    this.pendingQuestion,
    this.onAnswer,
  });

  @protected
  BubbleState createBubbleState() {
    return BubbleState(
      content: content,
      role: role,
      isError: isError,
      onRetry: onRetry,
      packageName: packageName,
      retryLabel: retryLabel,
      loadingHint: loadingHint,
      streaming: streaming,
      onEdit: onEdit,
      onDelete: onDelete,
      onRegenerate: onRegenerate,
      onQuote: onQuote,
      rawDetails: rawDetails,
      toolInvocations: toolInvocations,
      onToolApprove: onToolApprove,
      onToolReject: onToolReject,
      errorHint: errorHint,
      imageSources: imageSources,
      pendingQuestion: pendingQuestion,
      onAnswer: onAnswer,
    );
  }

  @protected
  BaseBubbleContainerPart createContainerPart() {
    return const DefaultBubbleContainerPart();
  }

  @protected
  BaseBubbleContentPart createContentPart() {
    return const DefaultBubbleContentPart();
  }

  @protected
  BaseBubbleToolbarPart createToolbarPart() {
    return const DefaultBubbleToolbarPart();
  }

  @override
  Widget build(BuildContext context) {
    final bubbleState = createBubbleState();
    final containerPart = createContainerPart();
    final contentPart = createContentPart();
    final toolbarPart = createToolbarPart();
    return containerPart.build(
      context,
      bubbleState,
      contentPart: contentPart,
      toolbarPart: toolbarPart,
    );
  }
}

class AiChatBubble extends BaseAiChatBubble {
  const AiChatBubble({
    super.key,
    required super.content,
    required super.role,
    super.isError,
    super.onRetry,
    super.packageName,
    super.retryLabel,
    super.loadingHint,
    super.streaming,
    super.onEdit,
    super.onDelete,
    super.onRegenerate,
    super.onQuote,
    super.rawDetails,
    super.toolInvocations,
    super.onToolApprove,
    super.onToolReject,
    super.errorHint,
    super.imageSources,
    super.pendingQuestion,
    super.onAnswer,
  });
}
