import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_functions_config.freezed.dart';

@freezed
abstract class QuickFunctionsConfig with _$QuickFunctionsConfig {
  const QuickFunctionsConfig._();

  const factory QuickFunctionsConfig({
    required List<QuickFunctionsConfigItem> items,
  }) = _QuickFunctionsConfig;
}

@freezed
abstract class QuickFunctionsConfigItem with _$QuickFunctionsConfigItem {
  const QuickFunctionsConfigItem._();

  const factory QuickFunctionsConfigItem({
    required String name,
    required bool status,
  }) = _QuickFunctionsConfigItem;
}
