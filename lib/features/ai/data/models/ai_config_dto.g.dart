// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiConfigDto _$AiConfigDtoFromJson(Map<String, dynamic> json) => _AiConfigDto(
  id: json['id'] as String? ?? "",
  name: json['name'] as String? ?? "",
  apiKey: json['apiKey'] as String? ?? "",
  apiUrl: json['apiUrl'] as String? ?? "",
  moduleName: json['moduleName'] as String? ?? "",
  maxToken: (json['maxToken'] as num?)?.toInt() ?? 300,
  temperature: (json['temperature'] as num?)?.toDouble() ?? 0.8,
  memoryRounds: (json['memoryRounds'] as num?)?.toDouble() ?? 10,
  apiType: json['apiType'] as String? ?? 'openai',
);

Map<String, dynamic> _$AiConfigDtoToJson(_AiConfigDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'apiKey': instance.apiKey,
      'apiUrl': instance.apiUrl,
      'moduleName': instance.moduleName,
      'maxToken': instance.maxToken,
      'temperature': instance.temperature,
      'memoryRounds': instance.memoryRounds,
      'apiType': instance.apiType,
    };
