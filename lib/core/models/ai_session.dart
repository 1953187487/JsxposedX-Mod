import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_session.freezed.dart';

@freezed
abstract class AiSession with _$AiSession {
  const factory AiSession({
    required String id,
    required String name,
    required String packageName,
    required DateTime lastUpdateTime,
    required String lastMessage,
  }) = _AiSession;
}
