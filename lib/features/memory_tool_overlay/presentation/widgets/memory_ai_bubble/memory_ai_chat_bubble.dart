import 'dart:async';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_tool_invocation_view.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_bubble/ai_chat_bubble.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_bubble/memory_ai_bubble_container.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_bubble/memory_ai_bubble_content.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_bubble/memory_ai_bubble_state.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/widgets/memory_ai_bubble/memory_ai_bubble_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MemoryAiChatBubble extends BaseAiChatBubble {
  const MemoryAiChatBubble({
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
    this.isToolResultBubble = false,
  });

  final bool isToolResultBubble;

  @override
  MemoryAiBubbleState createBubbleState() {
    return MemoryAiBubbleState(
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
      isToolResultBubble: isToolResultBubble,
    );
  }

  @override
  MemoryAiBubbleContainerPart createContainerPart() {
    return const MemoryAiBubbleContainerPart();
  }

  @override
  MemoryAiBubbleContentPart createContentPart() {
    return const MemoryAiBubbleContentPart();
  }

  @override
  MemoryAiBubbleToolbarPart createToolbarPart() {
    return const MemoryAiBubbleToolbarPart();
  }
}

class MemoryAiStreamingChatBubble extends HookWidget {
  const MemoryAiStreamingChatBubble({
    super.key,
    required this.initialContent,
    required this.role,
    required this.isError,
    required this.isToolResultBubble,
    required this.retryLabel,
    required this.streamingContentStream,
    required this.streamingThinkingStream,
    this.errorHint,
    this.onRetry,
    this.packageName,
    this.onQuote,
    this.toolInvocations = const <AiToolInvocationView>[],
    this.onToolApprove,
    this.onToolReject,
    this.pendingQuestion,
    this.onAnswer,
  });

  final String initialContent;
  final String role;
  final bool isError;
  final bool isToolResultBubble;
  final String? errorHint;
  final String retryLabel;
  final Stream<String> streamingContentStream;
  final Stream<bool> streamingThinkingStream;
  final VoidCallback? onRetry;
  final String? packageName;
  final VoidCallback? onQuote;
  final List<AiToolInvocationView> toolInvocations;
  final VoidCallback? onToolApprove;
  final VoidCallback? onToolReject;
  final AiQuestion? pendingQuestion;
  final ValueChanged<List<String>>? onAnswer;

  @override
  Widget build(BuildContext context) {
    final content = useState(initialContent);
    final pendingContent = useRef<String?>(null);
    final flushTimer = useRef<Timer?>(null);
    final isThinking = useState(false);

    useEffect(() {
      final subscription = streamingContentStream.listen((data) {
        if (!context.mounted) {
          return;
        }

        if (data == content.value) return;
        pendingContent.value = data;
        if (flushTimer.value == null) {
          flushTimer.value = Timer(const Duration(milliseconds: 24), () {
            flushTimer.value = null;
            final next = pendingContent.value;
            pendingContent.value = null;
            if (next != null && context.mounted) content.value = next;
          });
        }
      });
      return () {
        flushTimer.value?.cancel();
        flushTimer.value = null;
        unawaited(subscription.cancel());
      };
    }, [streamingContentStream]);

    useEffect(() {
      final subscription = streamingThinkingStream.listen((value) {
        if (!context.mounted) {
          return;
        }
        isThinking.value = value;
      });
      return subscription.cancel;
    }, [streamingThinkingStream]);

    return MemoryAiChatBubble(
      key: const ValueKey('memory-streaming-bubble'),
      content: content.value,
      role: role,
      isError: isError,
      isToolResultBubble: isToolResultBubble,
      errorHint: errorHint,
      retryLabel: retryLabel,
      onRetry: onRetry,
      packageName: packageName,
      onQuote: onQuote,
      toolInvocations: toolInvocations,
      onToolApprove: onToolApprove,
      onToolReject: onToolReject,
      pendingQuestion: pendingQuestion,
      onAnswer: onAnswer,
      loadingHint: isThinking.value ? _memoryLoadingHint(context) : null,
      streaming: true,
    );
  }
}

String _memoryLoadingHint(BuildContext context) {
  return context.isZh
      ? '正在整理当前内存上下文...'
      : 'Analyzing current memory context...';
}
