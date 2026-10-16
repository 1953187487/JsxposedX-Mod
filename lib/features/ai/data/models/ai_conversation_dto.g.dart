// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiConversationDto _$AiConversationDtoFromJson(Map<String, dynamic> json) =>
    _AiConversationDto(
      id: json['id'] as String,
      title: json['title'] as String,
      assistantId: json['assistantId'] as String,
      environmentId: json['environmentId'] as String? ?? 'general',
      scopeId: json['scopeId'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      archivedAt: json['archivedAt'] as String?,
    );

Map<String, dynamic> _$AiConversationDtoToJson(_AiConversationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'assistantId': instance.assistantId,
      'environmentId': instance.environmentId,
      'scopeId': instance.scopeId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'archivedAt': instance.archivedAt,
    };
