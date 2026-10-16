import 'package:flutter/foundation.dart';

import 'package:JsxposedX/features/ai/application/chat/ai_transport_trace.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_tool_invocation_view.dart';

/// Presentation-only message model. The chat widgets do not depend on the
/// legacy storage/protocol message shape.
@immutable
class AiChatViewMessage {
  const AiChatViewMessage({
    required this.id,
    required this.role,
    required this.content,
    this.isError = false,
    this.isToolResultBubble = false,
    this.rawDetails,
    this.transportTrace,
    this.sourceMessageId,
    this.toolInvocations = const <AiToolInvocationView>[],
    this.errorHint,
    this.imageSources = const <String>[],
  });

  final String id;
  final String role;
  final String content;
  final bool isError;
  final bool isToolResultBubble;
  final String? rawDetails;
  final AiTransportTrace? transportTrace;
  final String? sourceMessageId;
  final List<AiToolInvocationView> toolInvocations;

  /// 非侵入式错误提示。仅当「已输出部分有效内容后流式中断/失败」时非空：
  /// 此时气泡保持正常样式与已有内容（isError 为 false），错误信息以附加
  /// 提示条的形式补充展示，而不是把整个气泡标记为异常。
  final String? errorHint;

  /// AI 回复中携带的图片源（http(s) 链接、data URI 或本地绝对路径）。
  /// 对应领域层的 [AiContentPart.image]，用于图文混排展示。
  final List<String> imageSources;
}
