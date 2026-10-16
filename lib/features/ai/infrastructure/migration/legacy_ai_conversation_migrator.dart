import 'dart:convert';

import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/models/ai_message.dart' as legacy;
import 'package:JsxposedX/core/models/ai_session.dart' as legacy;
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_catalog_repository.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/domain/repositories/chat/ai_chat_query_repository.dart';

/// Imports legacy Pinia conversations into the normalized Drift store and
/// provides the lossless mapping needed by the existing reverse-engineering UI.
///
/// The importer is idempotent: conversation/message ids are retained and
/// writes use the standard repositories' conflict-update semantics.
class LegacyAiConversationMigrator {
  const LegacyAiConversationMigrator({
    required this.queryRepository,
    required this.catalogRepository,
    required this.conversationRepository,
  });

  final AiChatQueryRepository queryRepository;
  final AiCatalogRepository catalogRepository;
  final AiConversationRepository conversationRepository;

  Future<List<legacy.AiSession>> migratePackage({
    required String packageName,
    required AiConfig config,
  }) async {
    final assistantId = 'legacy-assistant-${config.id}';
    final assistant = await catalogRepository.getAssistant(assistantId);
    if (assistant == null) return const [];

    final sessions = await queryRepository.getSessions(packageName);
    for (final session in sessions) {
      final conversation = AiConversation(
        id: session.id,
        title: session.name,
        assistantId: assistant.id,
        environmentId: 'general',
        scopeId: packageName,
        createdAt: session.lastUpdateTime.toUtc(),
        updatedAt: session.lastUpdateTime.toUtc(),
      );
      final existing = await conversationRepository.getConversation(session.id);
      if (existing == null) {
        await conversationRepository.saveConversation(conversation);
      } else if (existing.assistantId != assistant.id ||
          existing.scopeId != packageName) {
        // Legacy chat treats the selected AI config as global. Rebind an
        // existing conversation when that config changes, without touching
        // its title, timestamps, archive state, or messages.
        await conversationRepository.saveConversation(
          existing.copyWith(assistantId: assistant.id, scopeId: packageName),
        );
      }

      final oldMessages = await queryRepository.getChatHistory(
        packageName,
        session.id,
      );
      if (oldMessages.isNotEmpty) {
        await conversationRepository.saveMessages(
          toStandardMessages(oldMessages, session.id, session.lastUpdateTime),
        );
      }
    }
    return sessions;
  }

  Future<void> saveLegacySession({
    required String packageName,
    required legacy.AiSession session,
    required List<legacy.AiMessage> messages,
    required AiConfig config,
  }) async {
    final assistantId = 'legacy-assistant-${config.id}';
    final assistant = await catalogRepository.getAssistant(assistantId);
    if (assistant == null) return;
    final conversation = AiConversation(
      id: session.id,
      title: session.name,
      assistantId: assistant.id,
      environmentId: 'general',
      scopeId: packageName,
      createdAt: session.lastUpdateTime.toUtc(),
      updatedAt: session.lastUpdateTime.toUtc(),
    );
    await conversationRepository.saveConversation(conversation);
    final nextMessages = toStandardMessages(
      messages,
      session.id,
      session.lastUpdateTime,
    );
    final existingMessages = <AiMessage>[];
    AiMessageCursor? cursor;
    while (true) {
      final page = await conversationRepository.getMessages(
        session.id,
        before: cursor,
        limit: 200,
      );
      existingMessages.addAll(page);
      if (page.length < 200) break;
      final oldest = page.first;
      cursor = AiMessageCursor(createdAt: oldest.createdAt, id: oldest.id);
    }
    await conversationRepository.saveMessages(nextMessages);
    final nextIds = nextMessages.map((message) => message.id).toSet();
    await conversationRepository.deleteMessagesById(
      session.id,
      existingMessages
          .where((message) => !nextIds.contains(message.id))
          .map((message) => message.id),
    );
  }

  Future<void> deleteSession(String sessionId) =>
      conversationRepository.deleteConversation(sessionId);

  Future<List<legacy.AiMessage>> readMessages(String sessionId) async {
    final messages = await conversationRepository.getMessages(sessionId);
    return messages.map(toLegacyMessage).toList(growable: false);
  }

  static List<AiMessage> toStandardMessages(
    List<legacy.AiMessage> messages,
    String conversationId,
    DateTime anchor,
  ) {
    var previous = anchor.toUtc().subtract(
      Duration(microseconds: messages.length),
    );
    return messages
        .map((message) {
          final createdAt = previous.add(const Duration(microseconds: 1));
          previous = createdAt;
          final parts = <AiContentPart>[];
          if (message.content.isNotEmpty && message.role != 'tool') {
            parts.add(AiContentPart.text(message.content));
          }
          if (message.reasoningContent?.isNotEmpty == true) {
            parts.add(AiContentPart.reasoning(message.reasoningContent!));
          }
          for (final raw
              in message.toolCalls ?? const <Map<String, dynamic>>[]) {
            final function = raw['function'];
            final functionMap = function is Map
                ? Map<String, dynamic>.from(function)
                : const <String, dynamic>{};
            final rawArguments = functionMap['arguments'];
            final arguments = rawArguments is String
                ? _decodeArguments(rawArguments)
                : (rawArguments is Map
                      ? Map<String, Object?>.from(rawArguments)
                      : const <String, Object?>{});
            parts.add(
              AiContentPart.toolCall(
                toolCall: AiToolCall(
                  id: raw['id']?.toString() ?? 'legacy-tool-call',
                  name: functionMap['name']?.toString() ?? '',
                  arguments: arguments,
                ),
              ),
            );
          }
          if (message.role == 'tool') {
            parts.add(
              AiContentPart.toolResult(
                toolResult: AiToolResult(
                  toolCallId: message.toolCallId ?? '',
                  name: 'tool',
                  success: !message.isError,
                  content: message.content,
                ),
              ),
            );
          }
          return AiMessage(
            id: message.id,
            conversationId: conversationId,
            role: _role(message.role),
            parts: parts,
            status: message.isError
                ? AiMessageStatus.failed
                : AiMessageStatus.completed,
            createdAt: createdAt,
            completedAt: createdAt,
          );
        })
        .toList(growable: false);
  }

  static legacy.AiMessage toLegacyMessage(AiMessage message) {
    String text = '';
    String? reasoning;
    List<Map<String, dynamic>>? toolCalls;
    String? toolCallId;
    var isError = message.status == AiMessageStatus.failed;
    for (final part in message.parts) {
      switch (part) {
        case AiTextPart(text: final value):
          text += value;
        case AiReasoningPart(text: final value):
          reasoning = '${reasoning ?? ''}$value';
        case AiToolCallPart(:final toolCall):
          toolCalls ??= <Map<String, dynamic>>[];
          toolCalls.add({
            'id': toolCall.id,
            'type': 'function',
            'function': {
              'name': toolCall.name,
              'arguments': jsonEncode(toolCall.arguments),
            },
          });
        case AiToolResultPart(:final toolResult):
          toolCallId = toolResult.toolCallId;
          text += toolResult.content;
          isError = !toolResult.success;
        case AiImagePart():
          break;
      }
    }
    if (isError && text.trim().isEmpty && message.failure != null) {
      text = describeAiFailure(message.failure!);
    }
    return legacy.AiMessage(
      id: message.id,
      role: message.role.name,
      content: text,
      reasoningContent: reasoning,
      toolCalls: toolCalls,
      toolCallId: toolCallId,
      isError: isError,
    );
  }

  static String describeAiFailure(AiFailure failure) {
    final status = failure.httpStatus == null
        ? ''
        : 'HTTP ${failure.httpStatus}：';
    final detail = switch (failure.code) {
      AiFailureCode.invalidConfiguration => 'AI 配置无效或模型能力不匹配',
      AiFailureCode.credentialMissing => 'API Key 未保存或无法读取',
      AiFailureCode.authenticationFailed => 'API Key 无效',
      AiFailureCode.permissionDenied => '当前 API Key 没有访问权限',
      AiFailureCode.modelNotFound => '模型不存在，或服务不支持当前 API 类型',
      AiFailureCode.unsupportedCapability => '当前模型不支持请求所需能力',
      AiFailureCode.contextLimitExceeded => '对话内容超过模型上下文限制',
      AiFailureCode.rateLimited => '请求过于频繁，请稍后重试',
      AiFailureCode.quotaExceeded => '账户额度不足',
      AiFailureCode.networkUnavailable => '网络不可用或 TLS 连接失败',
      AiFailureCode.connectTimeout => '连接 AI 服务超时',
      AiFailureCode.receiveTimeout => '等待 AI 响应超时',
      AiFailureCode.protocolMalformed => '服务返回了无法解析的数据，可能与所选 API 类型不兼容',
      AiFailureCode.protocolTruncated => '流式响应提前中断',
      AiFailureCode.serverFailure => 'AI 服务端异常',
      AiFailureCode.toolRejected => '工具调用被拒绝',
      AiFailureCode.toolFailed => '工具调用失败',
      AiFailureCode.cancelled => '请求已取消',
      AiFailureCode.unknown => '请求失败，请检查 API 地址、API 类型和模型',
    };
    final providerDetail = failure.messageKey.startsWith('ai.error.')
        ? null
        : failure.messageKey.trim();
    final requestId = failure.providerRequestId;
    return '$status$detail'
        '${providerDetail == null || providerDetail.isEmpty ? '' : '\n$providerDetail'}'
        '${requestId == null ? '' : '\n请求 ID：$requestId'}';
  }

  static AiMessageRole _role(String role) => switch (role) {
    'system' => AiMessageRole.system,
    'assistant' => AiMessageRole.assistant,
    'tool' => AiMessageRole.tool,
    _ => AiMessageRole.user,
  };

  static Map<String, Object?> _decodeArguments(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map
          ? Map<String, Object?>.from(decoded)
          : const <String, Object?>{};
    } catch (_) {
      return const <String, Object?>{};
    }
  }
}
