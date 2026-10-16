// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiModelDto _$AiModelDtoFromJson(Map<String, dynamic> json) => _AiModelDto(
  id: json['id'] as String? ?? '',
  object: json['object'] as String? ?? '',
  created: (json['created'] as num?)?.toInt() ?? 0,
  ownedBy: json['owned_by'] as String? ?? '',
  supportedEndpointTypes:
      (json['supported_endpoint_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  contextTokens: (json['context_length'] as num?)?.toInt(),
  maxOutputTokens: (json['max_output_tokens'] as num?)?.toInt(),
);

Map<String, dynamic> _$AiModelDtoToJson(_AiModelDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'owned_by': instance.ownedBy,
      'supported_endpoint_types': instance.supportedEndpointTypes,
      'context_length': instance.contextTokens,
      'max_output_tokens': instance.maxOutputTokens,
    };
