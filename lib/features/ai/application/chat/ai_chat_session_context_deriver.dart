import 'dart:convert';

import 'package:JsxposedX/core/models/ai_message.dart' as legacy;
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';

/// 从单个对话的真实消息中派生该对话的上下文状态变量（工具执行轨迹、
/// 最近诉求、最近失败原因、可机械提取的记忆条目）。
///
/// 只做可溯源的提取：每个条目都能对应到一条真实消息。无法从消息直接
/// 得到的语义字段（currentStep / confirmedFacts / openHypotheses 等）
/// 一律保持为空，绝不填充猜测内容。
class AiChatSessionContextDeriver {
  const AiChatSessionContextDeriver({
    this.maxMemoryEntries = 5,
    this.maxEntryCharacters = 240,
  });

  final int maxMemoryEntries;
  final int maxEntryCharacters;

  AiChatSessionContext derive({
    required List<AiMessage> history,
    required AiChatContextStats stats,
    required String sessionRules,
    List<String> memoryEntries = const [],
  }) {
    final completed = history
        .where((message) => message.status == AiMessageStatus.completed)
        .toList(growable: false);
    return AiChatSessionContext(
      sessionRules: sessionRules,
      sessionMemory: _deriveMemory(completed).copyWith(
        memoryEntries: memoryEntries,
      ),
      taskState: _deriveTaskState(completed),
      toolTrace: _deriveToolTrace(completed),
      stats: stats,
    );
  }

  /// 记忆条目只提取两类可靠信息：用户诉求文本与成功的工具结果摘要。
  AiChatSessionMemory _deriveMemory(List<AiMessage> messages) {
    final goals = <String>[];
    for (final message in messages.reversed) {
      if (goals.length >= maxMemoryEntries) break;
      if (message.role != AiMessageRole.user) continue;
      final text = _summarize(_textOf(message));
      if (text.isEmpty || goals.contains(text)) continue;
      goals.add(text);
    }
    final findings = <String>[];
    for (final message in messages.reversed) {
      if (findings.length >= maxMemoryEntries) break;
      for (final part in message.parts.whereType<AiToolResultPart>()) {
        if (!part.toolResult.success) continue;
        final summary = _summarize(part.toolResult.content);
        if (summary.isEmpty) continue;
        findings.add('${part.toolResult.name}: $summary');
        if (findings.length >= maxMemoryEntries) break;
      }
    }
    return AiChatSessionMemory(
      userGoals: goals.reversed.toList(growable: false),
      toolFindings: findings.reversed.toList(growable: false),
    );
  }

  AiChatTaskState _deriveTaskState(List<AiMessage> messages) {
    String? lastUserGoal;
    String? lastError;
    var errorDecided = false;
    for (final message in messages.reversed) {
      if (lastUserGoal == null && message.role == AiMessageRole.user) {
        final text = _summarize(_textOf(message));
        if (text.isNotEmpty) lastUserGoal = text;
      }
      if (!errorDecided) {
        final results = message.parts.whereType<AiToolResultPart>().toList();
        for (final part in results.reversed) {
          errorDecided = true;
          // 只看最近一次工具结果：成功则视为错误已恢复，不再显示历史失败，
          // 避免控制台长期挂着早已解决的错误。
          if (!part.toolResult.success) {
            lastError = _summarize(part.toolResult.content);
          }
          break;
        }
      }
      if (lastUserGoal != null && errorDecided) break;
    }
    return AiChatTaskState(lastUserGoal: lastUserGoal, lastError: lastError);
  }

  /// 以最近一次包含工具调用的 assistant 消息为锚点重建轨迹：
  /// 该锚点的工具调用与其后的工具结果构成一个可判定的执行单元。
  AiToolExecutionTrace _deriveToolTrace(List<AiMessage> messages) {
    var anchor = -1;
    for (var index = messages.length - 1; index >= 0; index--) {
      if (messages[index].parts.any((part) => part is AiToolCallPart)) {
        anchor = index;
        break;
      }
    }
    if (anchor < 0) return const AiToolExecutionTrace();

    final callIds = <String>[];
    final argumentSummaries = <String, String>{};
    for (final part in messages[anchor].parts.whereType<AiToolCallPart>()) {
      callIds.add(part.toolCall.id);
      argumentSummaries[part.toolCall.id] = _summarize(
        jsonEncode(part.toolCall.arguments),
      );
    }
    final resultSummaries = <String, String>{};
    for (final message in messages.skip(anchor)) {
      for (final part in message.parts.whereType<AiToolResultPart>()) {
        resultSummaries[part.toolResult.toolCallId] = _summarize(
          part.toolResult.content,
        );
      }
    }
    final isComplete = callIds.every(resultSummaries.containsKey);
    return AiToolExecutionTrace(
      assistantToolCallMessage: _toLegacy(messages[anchor]),
      toolCallIds: callIds,
      argumentSummaries: argumentSummaries,
      resultSummaries: resultSummaries,
      isComplete: isComplete,
      canReplay: isComplete && callIds.isNotEmpty,
    );
  }

  /// 工具轨迹与控制台沿用旧消息结构存储，这里做一次最小字段映射。
  static legacy.AiMessage _toLegacy(AiMessage message) {
    final text = message.parts
        .whereType<AiTextPart>()
        .map((part) => part.text)
        .join('\n')
        .trim();
    final reasoning = message.parts
        .whereType<AiReasoningPart>()
        .map((part) => part.text)
        .join('\n')
        .trim();
    final toolCalls = message.parts
        .whereType<AiToolCallPart>()
        .map(
          (part) => <String, dynamic>{
            'id': part.toolCall.id,
            'type': 'function',
            'function': {
              'name': part.toolCall.name,
              'arguments': jsonEncode(part.toolCall.arguments),
            },
          },
        )
        .toList(growable: false);
    return legacy.AiMessage(
      id: message.id,
      role: message.role.name,
      content: text,
      reasoningContent: reasoning.isEmpty ? null : reasoning,
      toolCalls: toolCalls.isEmpty ? null : toolCalls,
    );
  }

  static String _textOf(AiMessage message) {
    final raw = message.parts
        .whereType<AiTextPart>()
        .map((part) => part.text)
        .join('\n')
        .trim();
    if (raw.isEmpty) return '';
    // 多模态消息正文里可能内嵌 base64 图片数据，属于传输字节而非语义内容。
    return AiMultimodalMessageCodec.parse(raw)?.text.trim() ?? raw;
  }

  String _summarize(String value) {
    final normalized = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= maxEntryCharacters) return normalized;
    return '${normalized.substring(0, maxEntryCharacters)}…';
  }
}
