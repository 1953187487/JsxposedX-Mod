// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageResultDto<T> _$PageResultDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PageResultDto<T>(
  total: (json['total'] as num?)?.toInt() ?? 0,
  rows: (json['rows'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
  code: (json['code'] as num?)?.toInt() ?? 400,
  msg: json['msg'] as String? ?? "",
  hasMore: json['hasMore'] as bool? ?? false,
);

Map<String, dynamic> _$PageResultDtoToJson<T>(
  _PageResultDto<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'total': instance.total,
  'rows': instance.rows.map(toJsonT).toList(),
  'code': instance.code,
  'msg': instance.msg,
  'hasMore': instance.hasMore,
};
