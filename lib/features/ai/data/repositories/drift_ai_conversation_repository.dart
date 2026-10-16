import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:JsxposedX/features/ai/data/models/ai_conversation_dto.dart';
import 'package:JsxposedX/features/ai/data/models/ai_message_record_dto.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart'
    hide AiConversation;

class DriftAiConversationRepository implements AiConversationRepository {
  const DriftAiConversationRepository(this._database);

  final AiDatabase _database;

  @override
  Future<List<AiConversation>> getConversations({
    AiConversationCursor? before,
    int limit = 30,
  }) async {
    final query = _database.select(_database.aiConversations)
      ..where((table) {
        final active = table.archivedAt.isNull();
        return before == null
            ? active
            : active &
                  (table.updatedAt.isSmallerThanValue(
                        before.updatedAt.toUtc(),
                      ) |
                      (table.updatedAt.equals(before.updatedAt.toUtc()) &
                          table.id.isSmallerThanValue(before.id)));
      })
      ..orderBy([
        (row) => OrderingTerm.desc(row.updatedAt),
        (row) => OrderingTerm.desc(row.id),
      ])
      ..limit(limit.clamp(1, 100));
    final rows = await query.get();
    return rows
        .map((row) => _conversationFromJson(row.payloadJson))
        .toList(growable: false);
  }

  @override
  Future<AiConversation?> getConversation(String id) async {
    final row = await (_database.select(
      _database.aiConversations,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _conversationFromJson(row.payloadJson);
  }

  @override
  Future<void> saveConversation(AiConversation conversation) async {
    final assistant =
        await (_database.select(_database.aiAssistantProfiles)
              ..where((table) => table.id.equals(conversation.assistantId)))
            .getSingleOrNull();
    if (assistant == null) {
      throw StateError(
        'Conversation references missing assistant ${conversation.assistantId}',
      );
    }
    await _database
        .into(_database.aiConversations)
        .insertOnConflictUpdate(
          AiConversationsCompanion.insert(
            id: conversation.id,
            assistantId: conversation.assistantId,
            title: conversation.title,
            createdAt: conversation.createdAt.toUtc(),
            updatedAt: conversation.updatedAt.toUtc(),
            archivedAt: Value(conversation.archivedAt?.toUtc()),
            payloadJson: jsonEncode(
              AiConversationDto.fromEntity(conversation).toJson(),
            ),
          ),
        );
  }

  @override
  Future<void> deleteConversation(String id) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.aiMessageRecords,
      )..where((table) => table.conversationId.equals(id))).go();
      await (_database.delete(
        _database.aiConversationContexts,
      )..where((table) => table.conversationId.equals(id))).go();
      await (_database.delete(
        _database.scriptLogs,
      )..where((table) => table.conversationId.equals(id))).go();
      await (_database.delete(
        _database.scriptRuns,
      )..where((table) => table.conversationId.equals(id))).go();
      await (_database.delete(
        _database.aiConversations,
      )..where((table) => table.id.equals(id))).go();
    });
  }

  @override
  Future<List<AiMessage>> getMessages(
    String conversationId, {
    AiMessageCursor? before,
    int limit = 50,
  }) async {
    final query = _database.select(_database.aiMessageRecords)
      ..where((table) {
        final conversation = table.conversationId.equals(conversationId);
        return before == null
            ? conversation
            : conversation &
                  (table.createdAt.isSmallerThanValue(
                        before.createdAt.toUtc(),
                      ) |
                      (table.createdAt.equals(before.createdAt.toUtc()) &
                          table.id.isSmallerThanValue(before.id)));
      })
      ..orderBy([
        (row) => OrderingTerm.desc(row.createdAt),
        (row) => OrderingTerm.desc(row.id),
      ])
      ..limit(limit.clamp(1, 200));
    final rows = await query.get();
    return rows.reversed
        .map((row) => _messageFromJson(row.payloadJson))
        .toList(growable: false);
  }

  @override
  Future<void> saveMessage(AiMessage message) => saveMessages([message]);

  @override
  Future<void> saveMessages(List<AiMessage> messages) async {
    if (messages.isEmpty) return;
    final conversationIds = messages
        .map((message) => message.conversationId)
        .toSet();
    if (conversationIds.length != 1) {
      throw ArgumentError('A message batch must belong to one conversation');
    }
    final conversationId = conversationIds.single;
    final conversation = await (_database.select(
      _database.aiConversations,
    )..where((table) => table.id.equals(conversationId))).getSingleOrNull();
    if (conversation == null) {
      throw StateError(
        'Cannot save messages for missing conversation $conversationId',
      );
    }
    await _database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _database.aiMessageRecords,
        messages
            .map(
              (message) => AiMessageRecordsCompanion.insert(
                id: message.id,
                conversationId: message.conversationId,
                createdAt: message.createdAt.toUtc(),
                status: message.status.name,
                payloadJson: jsonEncode(
                  AiMessageRecordDto.fromEntity(message).toJson(),
                ),
              ),
            )
            .toList(growable: false),
      );
    });
  }

  @override
  Future<void> deleteMessagesAfter(
    String conversationId,
    DateTime createdAt,
  ) async {
    await (_database.delete(_database.aiMessageRecords)..where(
          (table) =>
              table.conversationId.equals(conversationId) &
              table.createdAt.isBiggerThanValue(createdAt.toUtc()),
        ))
        .go();
  }

  @override
  Future<void> deleteMessagesById(
    String conversationId,
    Iterable<String> ids,
  ) async {
    final messageIds = ids.toSet();
    if (messageIds.isEmpty) return;
    await (_database.delete(_database.aiMessageRecords)..where(
          (table) =>
              table.conversationId.equals(conversationId) &
              table.id.isIn(messageIds),
        ))
        .go();
  }

  @override
  Future<AiChatSessionContext?> getConversationContext(
    String conversationId,
  ) async {
    final row =
        await (_database.select(_database.aiConversationContexts)
              ..where((table) => table.conversationId.equals(conversationId)))
            .getSingleOrNull();
    if (row == null) return null;
    try {
      return AiChatSessionContext.fromStorageJson(
        Map<String, dynamic>.from(jsonDecode(row.payloadJson) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveConversationContext(
    String conversationId,
    AiChatSessionContext context,
  ) async {
    final conversation =
        await (_database.select(_database.aiConversations)
              ..where((table) => table.id.equals(conversationId)))
            .getSingleOrNull();
    if (conversation == null) {
      throw StateError(
        'Cannot save context for missing conversation $conversationId',
      );
    }
    await _database
        .into(_database.aiConversationContexts)
        .insertOnConflictUpdate(
          AiConversationContextsCompanion.insert(
            conversationId: conversationId,
            contextVersion: context.version,
            payloadJson: jsonEncode(context.toStorageJson()),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }

  static AiConversation _conversationFromJson(String source) =>
      AiConversationDto.fromJson(
        Map<String, Object?>.from(jsonDecode(source) as Map),
      ).toEntity();

  static AiMessage _messageFromJson(String source) =>
      AiMessageRecordDto.fromJson(
        Map<String, Object?>.from(jsonDecode(source) as Map),
      ).toEntity();
}
