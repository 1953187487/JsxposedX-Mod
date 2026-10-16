import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

abstract interface class AiConversationRepository {
  Future<List<AiConversation>> getConversations({
    AiConversationCursor? before,
    int limit = 30,
  });

  Future<AiConversation?> getConversation(String id);

  Future<void> saveConversation(AiConversation conversation);

  Future<void> deleteConversation(String id);

  Future<List<AiMessage>> getMessages(
    String conversationId, {
    AiMessageCursor? before,
    int limit = 50,
  });

  Future<void> saveMessage(AiMessage message);

  Future<void> saveMessages(List<AiMessage> messages);

  Future<void> deleteMessagesAfter(String conversationId, DateTime createdAt);

  Future<void> deleteMessagesById(String conversationId, Iterable<String> ids);

  /// 读取该对话上次持久化的上下文快照；不存在时返回 null。
  Future<AiChatSessionContext?> getConversationContext(String conversationId);

  /// 覆盖写入该对话的上下文快照，使上下文状态在重启后可恢复。
  Future<void> saveConversationContext(
    String conversationId,
    AiChatSessionContext context,
  );
}

class AiConversationCursor {
  const AiConversationCursor({required this.updatedAt, required this.id});

  final DateTime updatedAt;
  final String id;
}

class AiMessageCursor {
  const AiMessageCursor({required this.createdAt, required this.id});

  final DateTime createdAt;
  final String id;
}
