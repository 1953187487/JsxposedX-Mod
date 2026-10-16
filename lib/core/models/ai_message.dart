import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'ai_message.freezed.dart';

@freezed
abstract class AiMessage with _$AiMessage {
  const AiMessage._();

  const factory AiMessage({
    required String id,
    required String role, // system, user, assistant, tool
    required String content,
    @Default(null) String? reasoningContent,
    @Default(false) bool isError,
    @Default(false) bool isThinking,

    /// Function Calling: assistant 消息中携带的工具调用列表
    @Default(null) List<Map<String, dynamic>>? toolCalls,

    /// Function Calling: tool 消息对应的 tool_call_id
    @Default(null) String? toolCallId,

    /// 标记是否是工具结果气泡（UI展示用，不发送给API）
    @Default(false) bool isToolResultBubble,
  }) = _AiMessage;

  /// 创建 assistant 工具调用消息
  factory AiMessage.assistantToolCalls(
    List<Map<String, dynamic>> toolCalls, {
    String? reasoningContent,
  }) {
    return AiMessage(
      id: const Uuid().v4(),
      role: 'assistant',
      content: '',
      reasoningContent: reasoningContent,
      toolCalls: toolCalls,
    );
  }

  /// 创建工具结果消息
  factory AiMessage.toolResult({
    required String toolCallId,
    required String content,
    bool isError = false,
  }) {
    return AiMessage(
      id: const Uuid().v4(),
      role: 'tool',
      content: content,
      toolCallId: toolCallId,
      isError: isError,
    );
  }

  /// 是否包含工具调用
  bool get hasToolCalls => toolCalls != null && toolCalls!.isNotEmpty;

  /// 是否是工具结果消息
  bool get isToolResult => role == 'tool' && toolCallId != null;

  bool get isSessionSummary =>
      role == 'system' && content.startsWith('[session_summary]');

  Map<String, dynamic> toStorageJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      if (reasoningContent != null) 'reasoning_content': reasoningContent,
      'is_error': isError,
      'is_thinking': isThinking,
      if (toolCalls != null) 'tool_calls': toolCalls,
      if (toolCallId != null) 'tool_call_id': toolCallId,
      'is_tool_result_bubble': isToolResultBubble,
    };
  }

  factory AiMessage.fromStorageJson(Map<String, dynamic> json) {
    final rawToolCalls = json['tool_calls'] as List?;
    return AiMessage(
      id: json['id']?.toString() ?? const Uuid().v4(),
      role: json['role']?.toString() ?? 'user',
      content: json['content']?.toString() ?? '',
      reasoningContent: json['reasoning_content']?.toString(),
      isError: json['is_error'] == true,
      isThinking: json['is_thinking'] == true,
      toolCalls: rawToolCalls
          ?.map((item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false),
      toolCallId: json['tool_call_id']?.toString(),
      isToolResultBubble: json['is_tool_result_bubble'] == true,
    );
  }

  /// 是否应显示在聊天记录列表中
  bool get shouldDisplayInChatList {
    if (role == 'user') return true;
    if (role != 'assistant') return false;
    return !hasToolCalls;
  }
}
