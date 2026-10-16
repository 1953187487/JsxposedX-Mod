// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiSessionDto _$AiSessionDtoFromJson(Map<String, dynamic> json) =>
    _AiSessionDto(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      packageName: json['packageName'] as String? ?? "",
      lastUpdateTime: json['lastUpdateTime'] as String? ?? "",
      lastMessage: json['lastMessage'] as String? ?? "",
    );

Map<String, dynamic> _$AiSessionDtoToJson(_AiSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'packageName': instance.packageName,
      'lastUpdateTime': instance.lastUpdateTime,
      'lastMessage': instance.lastMessage,
    };
