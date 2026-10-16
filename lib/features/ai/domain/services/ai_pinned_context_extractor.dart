import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';
import 'package:uuid/uuid.dart';

class AiPinnedContextExtractor {
  static const int maxPinnedItems = 8;
  static const int maxPinnedChars = 160;

  List<AiPinnedContextItem> extract({
    required List<AiMessage> protocolMessages,
    List<AiPinnedContextItem> previousItems = const [],
  }) {
    final nextItems = <AiPinnedContextItem>[
      ...previousItems.where(
        (item) => item.source != AiPinnedContextSource.userRule,
      ),
    ];

    for (final message in protocolMessages) {
      if (message.role != 'user') {
        continue;
      }
      final normalized = _normalizeUserContent(message.content);
      if (normalized.isEmpty || !_looksLikePinnedConstraint(normalized)) {
        continue;
      }
      nextItems.add(
        AiPinnedContextItem(
          id: message.id.isNotEmpty ? message.id : const Uuid().v4(),
          content: _truncate(normalized, maxPinnedChars),
          source: AiPinnedContextSource.userRule,
          priority: 80,
          createdAtIso: DateTime.now().toIso8601String(),
        ),
      );
    }

    final deduped = <AiPinnedContextItem>[];
    for (final item in nextItems) {
      final index = deduped.indexWhere(
        (existing) => _isDuplicateConstraint(existing.content, item.content),
      );
      if (index == -1) {
        deduped.add(item);
        continue;
      }

      final existing = deduped[index];
      if (_shouldReplaceExisting(existing: existing, incoming: item)) {
        deduped[index] = item;
      }
    }

    deduped.sort((left, right) {
      final priorityDiff = right.priority.compareTo(left.priority);
      if (priorityDiff != 0) {
        return priorityDiff;
      }
      final createdDiff = right.createdAtIso.compareTo(left.createdAtIso);
      if (createdDiff != 0) {
        return createdDiff;
      }
      return right.content.length.compareTo(left.content.length);
    });

    if (deduped.length <= maxPinnedItems) {
      return List<AiPinnedContextItem>.unmodifiable(deduped);
    }
    return List<AiPinnedContextItem>.unmodifiable(
      deduped.take(maxPinnedItems),
    );
  }

  String _normalizeUserContent(String content) {
    return AiMultimodalMessageCodec.toSemanticText(
      content,
      isZh: true,
    ).replaceAll('\r', ' ').replaceAll('\n', ' ').trim();
  }

  bool _looksLikePinnedConstraint(String text) {
    final normalized = text.toLowerCase();
    return text.contains('不要') ||
        text.contains('别') ||
        text.contains('禁止') ||
        text.contains('必须') ||
        text.contains('务必') ||
        text.contains('一定') ||
        text.contains('只能') ||
        text.contains('只允许') ||
        text.contains('记住') ||
        normalized.contains('must') ||
        normalized.contains('do not') ||
        normalized.contains("don't") ||
        normalized.contains('never');
  }

  bool _isDuplicateConstraint(String left, String right) {
    final normalizedLeft = left.trim();
    final normalizedRight = right.trim();
    if (normalizedLeft == normalizedRight) {
      return true;
    }
    return normalizedLeft.startsWith(normalizedRight) ||
        normalizedRight.startsWith(normalizedLeft);
  }

  bool _shouldReplaceExisting({
    required AiPinnedContextItem existing,
    required AiPinnedContextItem incoming,
  }) {
    if (incoming.priority != existing.priority) {
      return incoming.priority > existing.priority;
    }
    if (incoming.content.trim() == existing.content.trim()) {
      return true;
    }
    if (incoming.content.startsWith(existing.content) &&
        incoming.content.length > existing.content.length) {
      return true;
    }
    if (incoming.createdAtIso != existing.createdAtIso) {
      return incoming.createdAtIso.compareTo(existing.createdAtIso) >= 0;
    }
    return incoming.content.length >= existing.content.length;
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
