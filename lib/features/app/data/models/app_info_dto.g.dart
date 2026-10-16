// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppInfoDto _$AppInfoDtoFromJson(Map<String, dynamic> json) => _AppInfoDto(
  name: json['name'] as String? ?? "",
  packageName: json['packageName'] as String? ?? "",
  versionName: json['versionName'] as String? ?? "",
  versionCode: (json['versionCode'] as num?)?.toInt() ?? 0,
  isSystemApp: json['isSystemApp'] as bool? ?? false,
);

Map<String, dynamic> _$AppInfoDtoToJson(_AppInfoDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'packageName': instance.packageName,
      'versionName': instance.versionName,
      'versionCode': instance.versionCode,
      'isSystemApp': instance.isSystemApp,
    };
