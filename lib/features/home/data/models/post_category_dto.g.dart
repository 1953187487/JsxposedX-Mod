// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostCategoryDto _$PostCategoryDtoFromJson(Map<String, dynamic> json) =>
    _PostCategoryDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? "",
      icon: json['icon'] as String? ?? "",
      description: json['description'] as String? ?? "",
      ranking: (json['ranking'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PostCategoryDtoToJson(_PostCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'description': instance.description,
      'ranking': instance.ranking,
    };
