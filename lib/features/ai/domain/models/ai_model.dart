import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_model.freezed.dart';

@freezed
abstract class AiModel with _$AiModel {
  const AiModel._(); // 私有构造函数，用于添加自定义方法

  const factory AiModel({
    required String id,
    required String object,
    required int created,
    required String ownedBy,
    required List<String> supportedEndpointTypes,
    int? contextTokens,
    int? maxOutputTokens,
  }) = _AiModel;
}
