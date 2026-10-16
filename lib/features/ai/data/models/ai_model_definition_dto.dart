import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

part 'ai_model_definition_dto.freezed.dart';
part 'ai_model_definition_dto.g.dart';

@freezed
abstract class AiModelCapabilitiesDto with _$AiModelCapabilitiesDto {
  const AiModelCapabilitiesDto._();

  const factory AiModelCapabilitiesDto({
    @Default(false) bool streaming,
    @Default(false) bool visionInput,
    @Default(false) bool fileInput,
    @Default(false) bool reasoning,
    @Default(false) bool toolCalling,
    @Default(false) bool parallelToolCalling,
    @Default(false) bool structuredOutput,
    @Default(true) bool systemRole,
  }) = _AiModelCapabilitiesDto;

  factory AiModelCapabilitiesDto.fromJson(Map<String, Object?> json) =>
      _$AiModelCapabilitiesDtoFromJson(json);

  factory AiModelCapabilitiesDto.fromEntity(AiModelCapabilities entity) =>
      AiModelCapabilitiesDto(
        streaming: entity.streaming,
        visionInput: entity.visionInput,
        fileInput: entity.fileInput,
        reasoning: entity.reasoning,
        toolCalling: entity.toolCalling,
        parallelToolCalling: entity.parallelToolCalling,
        structuredOutput: entity.structuredOutput,
        systemRole: entity.systemRole,
      );

  AiModelCapabilities toEntity() => AiModelCapabilities(
    streaming: streaming,
    visionInput: visionInput,
    fileInput: fileInput,
    reasoning: reasoning,
    toolCalling: toolCalling,
    parallelToolCalling: parallelToolCalling,
    structuredOutput: structuredOutput,
    systemRole: systemRole,
  );
}

@freezed
abstract class AiModelLimitsDto with _$AiModelLimitsDto {
  const AiModelLimitsDto._();

  const factory AiModelLimitsDto({
    int? contextTokens,
    int? maxOutputTokens,
    int? maxImages,
    int? maxTools,
    int? maxToolResultBytes,
  }) = _AiModelLimitsDto;

  factory AiModelLimitsDto.fromJson(Map<String, Object?> json) =>
      _$AiModelLimitsDtoFromJson(json);

  factory AiModelLimitsDto.fromEntity(AiModelLimits entity) => AiModelLimitsDto(
    contextTokens: entity.contextTokens,
    maxOutputTokens: entity.maxOutputTokens,
    maxImages: entity.maxImages,
    maxTools: entity.maxTools,
    maxToolResultBytes: entity.maxToolResultBytes,
  );

  AiModelLimits toEntity() => AiModelLimits(
    contextTokens: contextTokens,
    maxOutputTokens: maxOutputTokens,
    maxImages: maxImages,
    maxTools: maxTools,
    maxToolResultBytes: maxToolResultBytes,
  );
}

@freezed
abstract class AiModelDefinitionDto with _$AiModelDefinitionDto {
  const AiModelDefinitionDto._();

  @JsonSerializable(explicitToJson: true)
  const factory AiModelDefinitionDto({
    required String id,
    required String connectionId,
    required String displayName,
    @Default(AiModelCapabilitiesDto()) AiModelCapabilitiesDto capabilities,
    @Default(AiModelLimitsDto()) AiModelLimitsDto limits,
    @Default('discovered') String source,
  }) = _AiModelDefinitionDto;

  factory AiModelDefinitionDto.fromJson(Map<String, Object?> json) =>
      _$AiModelDefinitionDtoFromJson(json);

  factory AiModelDefinitionDto.fromEntity(AiModelDefinition entity) =>
      AiModelDefinitionDto(
        id: entity.id,
        connectionId: entity.connectionId,
        displayName: entity.displayName,
        capabilities: AiModelCapabilitiesDto.fromEntity(entity.capabilities),
        limits: AiModelLimitsDto.fromEntity(entity.limits),
        source: entity.source,
      );

  AiModelDefinition toEntity() => AiModelDefinition(
    id: id,
    connectionId: connectionId,
    displayName: displayName,
    capabilities: capabilities.toEntity(),
    limits: limits.toEntity(),
    source: source,
  );
}
