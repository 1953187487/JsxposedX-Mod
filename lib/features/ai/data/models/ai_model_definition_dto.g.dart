// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_definition_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiModelCapabilitiesDto _$AiModelCapabilitiesDtoFromJson(
  Map<String, dynamic> json,
) => _AiModelCapabilitiesDto(
  streaming: json['streaming'] as bool? ?? false,
  visionInput: json['visionInput'] as bool? ?? false,
  fileInput: json['fileInput'] as bool? ?? false,
  reasoning: json['reasoning'] as bool? ?? false,
  toolCalling: json['toolCalling'] as bool? ?? false,
  parallelToolCalling: json['parallelToolCalling'] as bool? ?? false,
  structuredOutput: json['structuredOutput'] as bool? ?? false,
  systemRole: json['systemRole'] as bool? ?? true,
);

Map<String, dynamic> _$AiModelCapabilitiesDtoToJson(
  _AiModelCapabilitiesDto instance,
) => <String, dynamic>{
  'streaming': instance.streaming,
  'visionInput': instance.visionInput,
  'fileInput': instance.fileInput,
  'reasoning': instance.reasoning,
  'toolCalling': instance.toolCalling,
  'parallelToolCalling': instance.parallelToolCalling,
  'structuredOutput': instance.structuredOutput,
  'systemRole': instance.systemRole,
};

_AiModelLimitsDto _$AiModelLimitsDtoFromJson(Map<String, dynamic> json) =>
    _AiModelLimitsDto(
      contextTokens: (json['contextTokens'] as num?)?.toInt(),
      maxOutputTokens: (json['maxOutputTokens'] as num?)?.toInt(),
      maxImages: (json['maxImages'] as num?)?.toInt(),
      maxTools: (json['maxTools'] as num?)?.toInt(),
      maxToolResultBytes: (json['maxToolResultBytes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AiModelLimitsDtoToJson(_AiModelLimitsDto instance) =>
    <String, dynamic>{
      'contextTokens': instance.contextTokens,
      'maxOutputTokens': instance.maxOutputTokens,
      'maxImages': instance.maxImages,
      'maxTools': instance.maxTools,
      'maxToolResultBytes': instance.maxToolResultBytes,
    };

_AiModelDefinitionDto _$AiModelDefinitionDtoFromJson(
  Map<String, dynamic> json,
) => _AiModelDefinitionDto(
  id: json['id'] as String,
  connectionId: json['connectionId'] as String,
  displayName: json['displayName'] as String,
  capabilities: json['capabilities'] == null
      ? const AiModelCapabilitiesDto()
      : AiModelCapabilitiesDto.fromJson(
          json['capabilities'] as Map<String, dynamic>,
        ),
  limits: json['limits'] == null
      ? const AiModelLimitsDto()
      : AiModelLimitsDto.fromJson(json['limits'] as Map<String, dynamic>),
  source: json['source'] as String? ?? 'discovered',
);

Map<String, dynamic> _$AiModelDefinitionDtoToJson(
  _AiModelDefinitionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'connectionId': instance.connectionId,
  'displayName': instance.displayName,
  'capabilities': instance.capabilities.toJson(),
  'limits': instance.limits.toJson(),
  'source': instance.source,
};
