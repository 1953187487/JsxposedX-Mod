// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_assistant_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiGenerationOptionsDto _$AiGenerationOptionsDtoFromJson(
  Map<String, dynamic> json,
) => _AiGenerationOptionsDto(
  maxOutputTokens: (json['maxOutputTokens'] as num?)?.toInt(),
  temperature: (json['temperature'] as num?)?.toDouble(),
  topP: (json['topP'] as num?)?.toDouble(),
  presencePenalty: (json['presencePenalty'] as num?)?.toDouble(),
  frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble(),
  reasoningEffort: json['reasoningEffort'] as String?,
  stream: json['stream'] as bool? ?? true,
);

Map<String, dynamic> _$AiGenerationOptionsDtoToJson(
  _AiGenerationOptionsDto instance,
) => <String, dynamic>{
  'maxOutputTokens': instance.maxOutputTokens,
  'temperature': instance.temperature,
  'topP': instance.topP,
  'presencePenalty': instance.presencePenalty,
  'frequencyPenalty': instance.frequencyPenalty,
  'reasoningEffort': instance.reasoningEffort,
  'stream': instance.stream,
};

_AiContextPolicyDto _$AiContextPolicyDtoFromJson(
  Map<String, dynamic> json,
) => _AiContextPolicyDto(
  mode: json['mode'] as String? ?? 'tokenBudget',
  reservedOutputTokens: (json['reservedOutputTokens'] as num?)?.toInt() ?? 1024,
  recentMessageMinimum: (json['recentMessageMinimum'] as num?)?.toInt() ?? 4,
  recentMessageLimit: (json['recentMessageLimit'] as num?)?.toInt(),
  includeToolResults: json['includeToolResults'] as bool? ?? true,
  enableSummarization: json['enableSummarization'] as bool? ?? false,
  fallbackContextTokens:
      (json['fallbackContextTokens'] as num?)?.toInt() ??
      kDefaultFallbackContextTokens,
);

Map<String, dynamic> _$AiContextPolicyDtoToJson(_AiContextPolicyDto instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'reservedOutputTokens': instance.reservedOutputTokens,
      'recentMessageMinimum': instance.recentMessageMinimum,
      'recentMessageLimit': instance.recentMessageLimit,
      'includeToolResults': instance.includeToolResults,
      'enableSummarization': instance.enableSummarization,
      'fallbackContextTokens': instance.fallbackContextTokens,
    };

_AiToolPolicyDto _$AiToolPolicyDtoFromJson(Map<String, dynamic> json) =>
    _AiToolPolicyDto(
      approvalMode: json['approvalMode'] as String? ?? 'riskyOnly',
      maxRounds: (json['maxRounds'] as num?)?.toInt() ?? kDefaultMaxToolRounds,
      maxResultBytes: (json['maxResultBytes'] as num?)?.toInt() ?? 1024 * 1024,
    );

Map<String, dynamic> _$AiToolPolicyDtoToJson(_AiToolPolicyDto instance) =>
    <String, dynamic>{
      'approvalMode': instance.approvalMode,
      'maxRounds': instance.maxRounds,
      'maxResultBytes': instance.maxResultBytes,
    };

_AiAssistantProfileDto _$AiAssistantProfileDtoFromJson(
  Map<String, dynamic> json,
) => _AiAssistantProfileDto(
  id: json['id'] as String,
  name: json['name'] as String,
  connectionId: json['connectionId'] as String,
  modelId: json['modelId'] as String,
  systemPrompt: json['systemPrompt'] as String?,
  generation: json['generation'] == null
      ? const AiGenerationOptionsDto()
      : AiGenerationOptionsDto.fromJson(
          json['generation'] as Map<String, dynamic>,
        ),
  contextPolicy: json['contextPolicy'] == null
      ? const AiContextPolicyDto()
      : AiContextPolicyDto.fromJson(
          json['contextPolicy'] as Map<String, dynamic>,
        ),
  toolPolicy: json['toolPolicy'] == null
      ? const AiToolPolicyDto()
      : AiToolPolicyDto.fromJson(json['toolPolicy'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$AiAssistantProfileDtoToJson(
  _AiAssistantProfileDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'connectionId': instance.connectionId,
  'modelId': instance.modelId,
  'systemPrompt': instance.systemPrompt,
  'generation': instance.generation.toJson(),
  'contextPolicy': instance.contextPolicy.toJson(),
  'toolPolicy': instance.toolPolicy.toJson(),
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
