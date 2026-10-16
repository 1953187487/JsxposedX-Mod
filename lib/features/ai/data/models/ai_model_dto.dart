import 'package:JsxposedX/features/ai/domain/models/ai_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_model_dto.freezed.dart';
part 'ai_model_dto.g.dart';

@freezed
abstract class AiModelDto with _$AiModelDto {
  const AiModelDto._(); // 私有构造函数，用于添加自定义方法

  const factory AiModelDto({
    @Default('') String id,
    @Default('') String object,
    @Default(0) int created,
    @JsonKey(name: "owned_by") @Default('') String ownedBy,
    @JsonKey(name: "supported_endpoint_types")
    @Default([])
    List<String> supportedEndpointTypes,
    @JsonKey(name: 'context_length') int? contextTokens,
    @JsonKey(name: 'max_output_tokens') int? maxOutputTokens,
  }) = _AiModelDto;

  factory AiModelDto.fromJson(Map<String, dynamic> json) =>
      _$AiModelDtoFromJson(json);

  factory AiModelDto.fromModelListJson(Map<String, dynamic> json) {
    final dto = AiModelDto.fromJson(json);
    return dto.copyWith(
      contextTokens:
          dto.contextTokens ??
          _firstInt(json, const [
            'context_window',
            'max_context_length',
            'input_token_limit',
            'context_tokens',
          ]),
      maxOutputTokens:
          dto.maxOutputTokens ??
          _firstInt(json, const [
            'max_completion_tokens',
            'output_token_limit',
            'max_tokens',
          ]),
    );
  }

  AiModel toEntity() {
    return AiModel(
      id: id,
      object: object,
      created: created,
      ownedBy: ownedBy,
      supportedEndpointTypes: supportedEndpointTypes,
      contextTokens: contextTokens,
      maxOutputTokens: maxOutputTokens,
    );
  }
}

int? _firstInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    final parsed = switch (value) {
      int number => number,
      num number => number.toInt(),
      String text => int.tryParse(text),
      _ => null,
    };
    if (parsed != null && parsed > 0) return parsed;
  }
  return null;
}
