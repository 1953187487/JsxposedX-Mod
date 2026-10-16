// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoticeDto _$NoticeDtoFromJson(Map<String, dynamic> json) => _NoticeDto(
  code: (json['code'] as num?)?.toInt() ?? 500,
  msg: json['msg'] == null
      ? const MsgDto()
      : MsgDto.fromJson(json['msg'] as Map<String, dynamic>),
  check: json['check'] as String? ?? '',
);

Map<String, dynamic> _$NoticeDtoToJson(_NoticeDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'check': instance.check,
    };

_MsgDto _$MsgDtoFromJson(Map<String, dynamic> json) =>
    _MsgDto(content: json['app_gg'] as String? ?? '');

Map<String, dynamic> _$MsgDtoToJson(_MsgDto instance) => <String, dynamic>{
  'app_gg': instance.content,
};
