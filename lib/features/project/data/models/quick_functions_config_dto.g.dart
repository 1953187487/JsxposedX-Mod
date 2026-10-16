// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_functions_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuickFunctionsConfigDto _$QuickFunctionsConfigDtoFromJson(
  Map<String, dynamic> json,
) => _QuickFunctionsConfigDto(
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => QuickFunctionsConfigItemDto.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$QuickFunctionsConfigDtoToJson(
  _QuickFunctionsConfigDto instance,
) => <String, dynamic>{'items': instance.items};

_QuickFunctionsConfigItemDto _$QuickFunctionsConfigItemDtoFromJson(
  Map<String, dynamic> json,
) => _QuickFunctionsConfigItemDto(
  name: json['name'] as String,
  status: json['status'] as bool,
);

Map<String, dynamic> _$QuickFunctionsConfigItemDtoToJson(
  _QuickFunctionsConfigItemDto instance,
) => <String, dynamic>{'name': instance.name, 'status': instance.status};
