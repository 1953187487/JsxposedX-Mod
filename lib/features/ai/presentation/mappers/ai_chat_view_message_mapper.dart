import 'dart:convert';

import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_state.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_snapshot.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_transport_trace.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_thinking_markup.dart';
import 'package:JsxposedX/features/ai/infrastructure/migration/legacy_ai_conversation_migrator.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_view_message.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_tool_invocation_view.dart';

class AiChatViewMessageMapper {
  const AiChatViewMessageMapper();

  /// 清理 DeepSeek 等模型输出的原始工具调用标签
  static String _cleanRawToolCallMarkers(String content) {
    // DeepSeek 模型的 DSML 工具调用标签
    var cleaned = content.replaceAll(RegExp(r'<｜DSML｜[^>]*>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'</｜DSML｜[^>]*>'), '');
    
    // 其他可能的工具调用标记格式
    cleaned = cleaned.replaceAll(RegExp(r'<\|function_calls\|>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'</\|function_calls\|>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'<\|invoke[^>]*\|>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'</\|invoke[^>]*\|>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'<\|parameter[^>]*\|>'), '');
    cleaned = cleaned.replaceAll(RegExp(r'</\|parameter[^>]*\|>'), '');
    
    return cleaned.trim();
  }

  List<AiChatViewMessage> mapHistory(
    List<AiMessage> messages, {
    AiChatSessionPhase phase = AiChatSessionPhase.ready,
  }) {
    final isAwaitingApproval = phase == AiChatSessionPhase.awaitingToolApproval;
    final display = <AiChatViewMessage>[];
    final pendingCalls = <String, _PendingToolCall>{};
    final pendingOrder = <String>[];

    void flushPending() {
      for (final id in pendingOrder) {
        final pending = pendingCalls[id];
        if (pending == null) continue;
        final status = isAwaitingApproval
            ? AiToolInvocationViewStatus.awaitingApproval
            : AiToolInvocationViewStatus.running;
        final invocation = AiToolInvocationView(
          callId: id,
          name: pending.call.name,
          argumentsJson: _encodeToolArguments(pending.call.arguments),
          status: status,
          requestedAt: pending.requestedAt,
        );
        display.add(
          AiChatViewMessage(
            id: 'tool-pending-$id',
            role: AiMessageRole.assistant.name,
            content: '`${pending.call.name}`',
            isToolResultBubble: true,
            toolInvocations: [invocation],
          ),
        );
      }
      pendingCalls.clear();
      pendingOrder.clear();
    }

    for (final message in messages) {
      if (message.role == AiMessageRole.system) {
        final text = message.parts
            .whereType<AiTextPart>()
            .map((part) => part.text)
            .join()
            .trim();
        if (text.isEmpty) continue;
        flushPending();
        display.add(
          AiChatViewMessage(
            id: message.id,
            sourceMessageId: message.id,
            role: message.role.name,
            content: text,
          ),
        );
        continue;
      }
      final calls = message.parts.whereType<AiToolCallPart>();
      if (message.role == AiMessageRole.assistant && calls.isNotEmpty) {
        flushPending();
        // 先渲染该 assistant 消息自身的文本/思考内容，
        // 保证多轮工具调用中每轮的自然语言回复不会丢失。
        final text = message.parts
            .whereType<AiTextPart>()
            .map((part) => part.text)
            .join();
        final reasoning = message.parts
            .whereType<AiReasoningPart>()
            .map((part) => part.text)
            .join();
        final assistantContent = _cleanRawToolCallMarkers(
          AiThinkingMarkup.compose(
            thinking: reasoning,
            answer: text,
            duration: null,
          ),
        );
        if (assistantContent.isNotEmpty) {
          display.add(
            AiChatViewMessage(
              id: message.id,
              sourceMessageId: message.id,
              role: message.role.name,
              content: assistantContent,
              // 工具调用轮次中断但已输出部分文本：保持正常气泡，仅附加提示。
              errorHint: message.status == AiMessageStatus.failed &&
                      message.failure != null
                  ? LegacyAiConversationMigrator.describeAiFailure(
                      message.failure!,
                    )
                  : null,
              rawDetails: _historyDetails(message),
              transportTrace: message.transportTrace,
            ),
          );
        }
        for (final part in calls) {
          final id = part.toolCall.id;
          if (id.isEmpty) continue;
          pendingCalls[id] = _PendingToolCall(
            call: part.toolCall,
            requestedAt: message.completedAt ?? message.createdAt,
          );
          pendingOrder.add(id);
        }
        continue;
      }

      final results = message.parts.whereType<AiToolResultPart>();
      if (message.role == AiMessageRole.tool && results.isNotEmpty) {
        for (final part in results) {
          final result = part.toolResult;
          final pending = pendingCalls.remove(result.toolCallId);
          pendingOrder.remove(result.toolCallId);
          final name = pending?.call.name.isNotEmpty == true
              ? pending!.call.name
              : result.name;
          final invocation = AiToolInvocationView(
            callId: result.toolCallId,
            name: name,
            argumentsJson: pending == null
                ? ''
                : _encodeToolArguments(pending.call.arguments),
            status: result.success
                ? AiToolInvocationViewStatus.succeeded
                : AiToolInvocationViewStatus.failed,
            resultContent: result.content,
            requestedAt: pending?.requestedAt,
            completedAt: message.completedAt ?? message.createdAt,
          );
          display.add(
            AiChatViewMessage(
              id: 'tool-result-${message.id}-${result.toolCallId}',
              sourceMessageId: message.id,
              role: AiMessageRole.assistant.name,
              content:
                  '${result.success ? '✅' : '❌'} `$name`:\n\n${result.content}',
              isError: !result.success,
              isToolResultBubble: true,
              toolInvocations: [invocation],
            ),
          );
        }
        continue;
      }

      flushPending();
      final text = message.parts
          .whereType<AiTextPart>()
          .map((part) => part.text)
          .join();
      final reasoning = message.parts
          .whereType<AiReasoningPart>()
          .map((part) => part.text)
          .join();
      final content = message.role == AiMessageRole.assistant
          ? _cleanRawToolCallMarkers(
              AiThinkingMarkup.compose(
                thinking: reasoning,
                answer: text,
                duration: null, // Note: persisted messages don't yet store duration directly
              ),
            )
          : text;
      final imageSources = _imageSourcesOf(message);
      if (content.isEmpty &&
          imageSources.isEmpty &&
          message.status != AiMessageStatus.failed) {
        continue;
      }
      // 与 mapStreaming 相同的分流：已输出部分内容后失败的持久化消息保持
      // 正常气泡样式，仅附加 errorHint 提示；空内容失败保留异常气泡。
      final failed = message.status == AiMessageStatus.failed;
      final hasContent = content.trim().isNotEmpty;
      display.add(
        AiChatViewMessage(
          id: message.id,
          sourceMessageId: message.id,
          role: message.role.name,
          content: content.isNotEmpty
              ? content
              : _failureDetail(message.failure),
          isError: failed && !hasContent,
          errorHint: failed && hasContent && message.failure != null
              ? LegacyAiConversationMigrator.describeAiFailure(
                  message.failure!,
                )
              : null,
          rawDetails: _historyDetails(message),
          transportTrace: message.transportTrace,
          imageSources: imageSources,
        ),
      );
    }
    flushPending();
    return List<AiChatViewMessage>.unmodifiable(display);
  }

  AiChatViewMessage mapStreaming({
    required String messageId,
    required AiStreamSnapshot snapshot,
  }) {
    // 区分「空对话失败」与「已输出部分内容后失败」：
    // 前者保留异常气泡（红边框 + 重试）；后者保持正常气泡样式与已有
    // 内容，失败信息以 errorHint 提示条附加展示，不篡改气泡本身。
    final failed = snapshot.status == AiStreamStatus.failed;
    final hasContent =
        snapshot.text.trim().isNotEmpty || snapshot.reasoning.trim().isNotEmpty;
    return AiChatViewMessage(
      id: messageId,
      sourceMessageId: messageId,
      role: AiMessageRole.assistant.name,
      content: _cleanRawToolCallMarkers(
        AiThinkingMarkup.compose(
          thinking: snapshot.reasoning,
          answer: snapshot.text,
          duration: snapshot.reasoningDuration,
        ),
      ),
      isError: failed && !hasContent,
      errorHint: failed && hasContent
          ? LegacyAiConversationMigrator.describeAiFailure(
              snapshot.failure ??
                  const AiFailure(
                    code: AiFailureCode.unknown,
                    messageKey: 'ai.error.unknown',
                  ),
            )
          : null,
      rawDetails: _snapshotDetails(snapshot),
      transportTrace: snapshot.transportTrace,
      toolInvocations: snapshot.toolCalls
          .map(
            (call) => AiToolInvocationView(
              callId: call.id ?? 'pending-${call.index}',
              name: call.name.isEmpty ? 'tool #${call.index + 1}' : call.name,
              argumentsJson: call.argumentsJson,
              status: call.argumentsJson.trim().isEmpty
                  ? AiToolInvocationViewStatus.preparing
                  : AiToolInvocationViewStatus.running,
            ),
          )
          .toList(growable: false),
    );
  }

  /// 提取消息中携带的图片源。
  /// 约定 [AiImagePart.attachmentId] 存储图片源字符串
  /// （http(s) 链接、data URI 或本地绝对路径）。
  static List<String> _imageSourcesOf(AiMessage message) {
    return message.parts
        .whereType<AiImagePart>()
        .map((part) => part.attachmentId.trim())
        .where((source) => source.isNotEmpty)
        .toList(growable: false);
  }

  static String _snapshotDetails(AiStreamSnapshot snapshot) {
    final buffer = StringBuffer()
      ..writeln('request_id: ${snapshot.requestId}')
      ..writeln('sequence: ${snapshot.sequence}')
      ..writeln('status: ${snapshot.status.name}');
    if (snapshot.finishReason != null) {
      buffer.writeln('finish_reason: ${snapshot.finishReason!.name}');
    }
    if (snapshot.usage != null) {
      buffer.writeln('usage: ${snapshot.usage}');
    }
    for (final call in snapshot.toolCalls) {
      buffer.writeln('tool: ${call.name} (${call.id ?? 'pending'})');
      if (call.argumentsJson.isNotEmpty) {
        buffer.writeln('arguments: ${call.argumentsJson}');
      }
    }
    if (snapshot.failure != null) {
      buffer.writeln('failure: ${snapshot.failure}');
    }
    if (snapshot.transportTrace case final trace?) {
      buffer
        ..writeln()
        ..writeln(_transportTraceDetails(trace));
    } else {
      buffer.writeln('transport: server did not provide metadata');
    }
    return buffer.toString().trim();
  }

  static String _historyDetails(AiMessage message) {
    final buffer = StringBuffer()
      ..writeln('message_id: ${message.id}')
      ..writeln('conversation_id: ${message.conversationId}')
      ..writeln('role: ${message.role.name}')
      ..writeln('status: ${message.status.name}')
      ..writeln('created_at: ${message.createdAt.toIso8601String()}');
    if (message.completedAt != null) {
      buffer.writeln('completed_at: ${message.completedAt!.toIso8601String()}');
    }
    if (message.usage != null) buffer.writeln('usage: ${message.usage}');
    if (message.failure != null) buffer.writeln('failure: ${message.failure}');
    buffer.writeln('transport: metadata unavailable for persisted message');
    return buffer.toString().trim();
  }

  static String _transportTraceDetails(AiTransportTrace trace) {
    final buffer = StringBuffer()
      ..writeln('transport:')
      ..writeln('  url: ${trace.requestUrl}')
      ..writeln(
        '  status: ${trace.statusCode?.toString() ?? 'server did not provide'}',
      )
      ..writeln(
        '  content_type: ${trace.contentType ?? 'server did not provide'}',
      )
      ..writeln(
        '  request_start: ${trace.requestStartTime?.toIso8601String() ?? 'server did not provide'}',
      )
      ..writeln(
        '  request_end: ${trace.requestEndTime?.toIso8601String() ?? 'server did not provide'}',
      )
      ..writeln(
        '  duration_ms: ${trace.responseDuration?.inMilliseconds.toString() ?? 'server did not provide'}',
      )
      ..writeln(
        '  provider_request_id: ${trace.providerRequestId ?? 'server did not provide'}',
      );
    if (trace.rawSseEvents.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('raw_sse:')
        ..writeln(trace.rawSseEvents.join('\n'));
    } else if (trace.rawResponseText != null &&
        trace.rawResponseText!.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('raw_response:')
        ..writeln(trace.rawResponseText!.trim());
    }
    if (trace.rawErrorJson != null && trace.rawErrorJson!.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('raw_error:')
        ..writeln(trace.rawErrorJson!.trim());
    }
    return buffer.toString().trimRight();
  }

  static String _failureDetail(AiFailure? failure) {
    if (failure == null) return '';
    final codeName = failure.code.name;
    final prefix = failure.messageKey.startsWith('ai.error.')
        ? codeName
        : failure.messageKey;
    if (failure.detail != null && failure.detail!.isNotEmpty) {
      return '$prefix\n\n${failure.detail}';
    }
    return prefix;
  }

  static String _encodeToolArguments(Map<String, Object?> arguments) {
    return const JsonEncoder.withIndent('  ').convert(arguments);
  }
}

class _PendingToolCall {
  const _PendingToolCall({required this.call, required this.requestedAt});

  final AiToolCall call;
  final DateTime? requestedAt;
}
