// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apk_asset_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApkAssetDto _$ApkAssetDtoFromJson(Map<String, dynamic> json) => _ApkAssetDto(
  path: json['path'] as String? ?? '',
  name: json['name'] as String? ?? '',
  size: (json['size'] as num?)?.toInt() ?? 0,
  compressedSize: (json['compressedSize'] as num?)?.toInt() ?? 0,
  isDirectory: json['isDirectory'] as bool? ?? false,
  lastModified: (json['lastModified'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ApkAssetDtoToJson(_ApkAssetDto instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
      'compressedSize': instance.compressedSize,
      'isDirectory': instance.isDirectory,
      'lastModified': instance.lastModified,
    };
