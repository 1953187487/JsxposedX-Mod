// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommonUserDto _$CommonUserDtoFromJson(Map<String, dynamic> json) =>
    _CommonUserDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      mxid: json['mxid'] as String? ?? "",
      nickname: json['nickname'] as String? ?? "",
      avatarUrl: json['avatarUrl'] as String? ?? "",
      description: json['description'] as String? ?? "",
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      isVip: json['isVip'] as bool? ?? false,
      isCert: json['isCert'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? false,
      group:
          (json['group'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CommonUserDtoToJson(_CommonUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mxid': instance.mxid,
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
      'description': instance.description,
      'gender': instance.gender,
      'exp': instance.exp,
      'isVip': instance.isVip,
      'isCert': instance.isCert,
      'isOnline': instance.isOnline,
      'group': instance.group,
    };
