import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

part 'ai_conversation_dto.freezed.dart';
part 'ai_conversation_dto.g.dart';

@freezed
abstract class AiConversationDto with _$AiConversationDto {
  const AiConversationDto._();

  const factory AiConversationDto({
    required String id,
    required String title,
    required String assistantId,
    @Default('general') String environmentId,
    String? scopeId,
    required String createdAt,
    required String updatedAt,
    String? archivedAt,
  }) = _AiConversationDto;

  factory AiConversationDto.fromJson(Map<String, Object?> json) =>
      _$AiConversationDtoFromJson(json);

  factory AiConversationDto.fromEntity(AiConversation entity) =>
      AiConversationDto(
        id: entity.id,
        title: entity.title,
        assistantId: entity.assistantId,
        environmentId: entity.environmentId,
        scopeId: entity.scopeId,
        createdAt: entity.createdAt.toUtc().toIso8601String(),
        updatedAt: entity.updatedAt.toUtc().toIso8601String(),
        archivedAt: entity.archivedAt?.toUtc().toIso8601String(),
      );

  AiConversation toEntity() => AiConversation(
    id: id,
    title: title,
    assistantId: assistantId,
    environmentId: environmentId,
    scopeId: scopeId,
    createdAt: _parseDateTime(createdAt, 'createdAt'),
    updatedAt: _parseDateTime(updatedAt, 'updatedAt'),
    archivedAt: archivedAt == null
        ? null
        : _parseDateTime(archivedAt!, 'archivedAt'),
  );
}

DateTime _parseDateTime(String value, String field) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('Invalid $field');
  return parsed.toUtc();
}
