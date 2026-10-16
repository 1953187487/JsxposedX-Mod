import 'package:JsxposedX/core/models/quick_functions_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_functions_config_dto.freezed.dart';
part 'quick_functions_config_dto.g.dart';

@freezed
abstract class QuickFunctionsConfigDto with _$QuickFunctionsConfigDto {
  const QuickFunctionsConfigDto._();

  const factory QuickFunctionsConfigDto({
    required List<QuickFunctionsConfigItemDto> items,
  }) = _QuickFunctionsConfigDto;

  factory QuickFunctionsConfigDto.fromJson(Map<String, dynamic> json) =>
      _$QuickFunctionsConfigDtoFromJson(json);

  QuickFunctionsConfig toEntity() {
    return QuickFunctionsConfig(items: items.map((e) => e.toEntity()).toList());
  }
}

@freezed
abstract class QuickFunctionsConfigItemDto with _$QuickFunctionsConfigItemDto {
  const QuickFunctionsConfigItemDto._();

  const factory QuickFunctionsConfigItemDto({
    required String name,
    required bool status,
  }) = _QuickFunctionsConfigItemDto;

  factory QuickFunctionsConfigItemDto.fromJson(Map<String, dynamic> json) =>
      _$QuickFunctionsConfigItemDtoFromJson(json);

  QuickFunctionsConfigItem toEntity() {
    return QuickFunctionsConfigItem(name: name, status: status);
  }
}
