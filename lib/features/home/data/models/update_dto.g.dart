// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateDto _$UpdateDtoFromJson(Map<String, dynamic> json) => _UpdateDto(
  code: (json['code'] as num?)?.toInt() ?? 500,
  msg: json['msg'] == null
      ? const UpdateMsgDto()
      : UpdateMsgDto.fromJson(json['msg'] as Map<String, dynamic>),
  check: json['check'] as String? ?? '',
);

Map<String, dynamic> _$UpdateDtoToJson(_UpdateDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'check': instance.check,
    };

_UpdateMsgDto _$UpdateMsgDtoFromJson(Map<String, dynamic> json) =>
    _UpdateMsgDto(
      version: json['version'] as String? ?? '-1',
      url: json['app_update_url'] as String? ?? '',
      content: json['app_update_show'] as String? ?? '',
      mustUpdate: json['app_update_must'] as String? ?? '',
    );

Map<String, dynamic> _$UpdateMsgDtoToJson(_UpdateMsgDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'app_update_url': instance.url,
      'app_update_show': instance.content,
      'app_update_must': instance.mustUpdate,
    };
