// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_keyword_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DialogKeywordDto _$DialogKeywordDtoFromJson(Map<String, dynamic> json) =>
    _DialogKeywordDto(
      keyword: json['keyword'] as String? ?? "",
      isCheck: json['isCheck'] as bool? ?? false,
    );

Map<String, dynamic> _$DialogKeywordDtoToJson(_DialogKeywordDto instance) =>
    <String, dynamic>{'keyword': instance.keyword, 'isCheck': instance.isCheck};
