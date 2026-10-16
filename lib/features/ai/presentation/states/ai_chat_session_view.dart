import 'package:flutter/foundation.dart';

@immutable
class AiChatSessionView {
  const AiChatSessionView({
    required this.id,
    required this.name,
    required this.scopeId,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String scopeId;
  final DateTime updatedAt;
}
