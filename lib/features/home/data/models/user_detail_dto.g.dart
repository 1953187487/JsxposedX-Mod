// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDetailDto _$UserDetailDtoFromJson(Map<String, dynamic> json) =>
    _UserDetailDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      mxid: json['mxid'] as String? ?? "",
      nickname: json['nickname'] as String? ?? "",
      avatarUrl: json['avatarUrl'] as String? ?? "",
      description: json['description'] as String? ?? "",
      cover: json['cover'] as String? ?? "",
      isVip: json['isVip'] as bool? ?? false,
      vipEndTime: (json['vipEndTime'] as num?)?.toInt() ?? 0,
      isCert: json['isCert'] as bool? ?? false,
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? "",
      isOnline: json['isOnline'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
      group:
          (json['group'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserDetailDtoToJson(_UserDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mxid': instance.mxid,
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
      'description': instance.description,
      'cover': instance.cover,
      'isVip': instance.isVip,
      'vipEndTime': instance.vipEndTime,
      'isCert': instance.isCert,
      'exp': instance.exp,
      'gender': instance.gender,
      'email': instance.email,
      'isOnline': instance.isOnline,
      'isFollowing': instance.isFollowing,
      'group': instance.group,
    };
