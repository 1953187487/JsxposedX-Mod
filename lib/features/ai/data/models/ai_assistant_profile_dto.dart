import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

part 'ai_assistant_profile_dto.freezed.dart';
part 'ai_assistant_profile_dto.g.dart';

@freezed
abstract class AiGenerationOptionsDto with _$AiGenerationOptionsDto {
  const AiGenerationOptionsDto._();

  const factory AiGenerationOptionsDto({
    int? maxOutputTokens,
    double? temperature,
    double? topP,
    double? presencePenalty,
    double? frequencyPenalty,
    String? reasoningEffort,
    @Default(true) bool stream,
  }) = _AiGenerationOptionsDto;

  factory AiGenerationOptionsDto.fromJson(Map<String, Object?> json) =>
      _$AiGenerationOptionsDtoFromJson(json);

  factory AiGenerationOptionsDto.fromEntity(AiGenerationOptions entity) =>
      AiGenerationOptionsDto(
        maxOutputTokens: entity.maxOutputTokens,
        temperature: entity.temperature,
        topP: entity.topP,
        presencePenalty: entity.presencePenalty,
        frequencyPenalty: entity.frequencyPenalty,
        reasoningEffort: entity.reasoningEffort,
        stream: entity.stream,
      );

  AiGenerationOptions toEntity() => AiGenerationOptions(
    maxOutputTokens: maxOutputTokens,
    temperature: temperature,
    topP: topP,
    presencePenalty: presencePenalty,
    frequencyPenalty: frequencyPenalty,
    reasoningEffort: reasoningEffort,
    stream: stream,
  );
}

@freezed
abstract class AiContextPolicyDto with _$AiContextPolicyDto {
  const AiContextPolicyDto._();

  const factory AiContextPolicyDto({
    @Default('tokenBudget') String mode,
    @Default(1024) int reservedOutputTokens,
    @Default(4) int recentMessageMinimum,
    int? recentMessageLimit,
    @Default(true) bool includeToolResults,
    @Default(false) bool enableSummarization,
    @Default(kDefaultFallbackContextTokens) int fallbackContextTokens,
  }) = _AiContextPolicyDto;

  factory AiContextPolicyDto.fromJson(Map<String, Object?> json) =>
      _$AiContextPolicyDtoFromJson(json);

  factory AiContextPolicyDto.fromEntity(AiContextPolicy entity) =>
      AiContextPolicyDto(
        mode: entity.mode.name,
        reservedOutputTokens: entity.reservedOutputTokens,
        recentMessageMinimum: entity.recentMessageMinimum,
        recentMessageLimit: entity.recentMessageLimit,
        includeToolResults: entity.includeToolResults,
        enableSummarization: entity.enableSummarization,
        fallbackContextTokens: entity.fallbackContextTokens,
      );

  AiContextPolicy toEntity() => AiContextPolicy(
    mode: _enumByName(AiContextMode.values, mode, AiContextMode.tokenBudget),
    reservedOutputTokens: reservedOutputTokens,
    recentMessageMinimum: recentMessageMinimum,
    recentMessageLimit: recentMessageLimit,
    includeToolResults: includeToolResults,
    enableSummarization: enableSummarization,
    // 旧数据缺失该字段时回落到默认值，非法值统一收敛。
    fallbackContextTokens: resolveFallbackContextTokens(fallbackContextTokens),
  );
}

@freezed
abstract class AiToolPolicyDto with _$AiToolPolicyDto {
  const AiToolPolicyDto._();

  const factory AiToolPolicyDto({
    @Default('riskyOnly') String approvalMode,
    @Default(kDefaultMaxToolRounds) int maxRounds,
    @Default(1024 * 1024) int maxResultBytes,
  }) = _AiToolPolicyDto;

  factory AiToolPolicyDto.fromJson(Map<String, Object?> json) =>
      _$AiToolPolicyDtoFromJson(json);

  factory AiToolPolicyDto.fromEntity(AiToolPolicy entity) => AiToolPolicyDto(
    approvalMode: entity.approvalMode.name,
    maxRounds: entity.maxRounds,
    maxResultBytes: entity.maxResultBytes,
  );

  AiToolPolicy toEntity() => AiToolPolicy(
    approvalMode: _enumByName(
      AiToolApprovalMode.values,
      approvalMode,
      AiToolApprovalMode.riskyOnly,
    ),
    // 读取时统一解析轮数，确保用户自定义值和合法边界保持有效。
    maxRounds: resolveMaxToolRounds(maxRounds),
    maxResultBytes: maxResultBytes,
  );
}

@freezed
abstract class AiAssistantProfileDto with _$AiAssistantProfileDto {
  const AiAssistantProfileDto._();

  @JsonSerializable(explicitToJson: true)
  const factory AiAssistantProfileDto({
    required String id,
    required String name,
    required String connectionId,
    required String modelId,
    String? systemPrompt,
    @Default(AiGenerationOptionsDto()) AiGenerationOptionsDto generation,
    @Default(AiContextPolicyDto()) AiContextPolicyDto contextPolicy,
    @Default(AiToolPolicyDto()) AiToolPolicyDto toolPolicy,
    required String createdAt,
    required String updatedAt,
  }) = _AiAssistantProfileDto;

  factory AiAssistantProfileDto.fromJson(Map<String, Object?> json) =>
      _$AiAssistantProfileDtoFromJson(json);

  factory AiAssistantProfileDto.fromEntity(AiAssistantProfile entity) =>
      AiAssistantProfileDto(
        id: entity.id,
        name: entity.name,
        connectionId: entity.connectionId,
        modelId: entity.modelId,
        systemPrompt: entity.systemPrompt,
        generation: AiGenerationOptionsDto.fromEntity(entity.generation),
        contextPolicy: AiContextPolicyDto.fromEntity(entity.contextPolicy),
        toolPolicy: AiToolPolicyDto.fromEntity(entity.toolPolicy),
        createdAt: entity.createdAt.toUtc().toIso8601String(),
        updatedAt: entity.updatedAt.toUtc().toIso8601String(),
      );

  AiAssistantProfile toEntity() => AiAssistantProfile(
    id: id,
    name: name,
    connectionId: connectionId,
    modelId: modelId,
    systemPrompt: systemPrompt,
    generation: generation.toEntity(),
    contextPolicy: contextPolicy.toEntity(),
    toolPolicy: toolPolicy.toEntity(),
    createdAt: _parseDateTime(createdAt, 'createdAt'),
    updatedAt: _parseDateTime(updatedAt, 'updatedAt'),
  );
}

T _enumByName<T extends Enum>(List<T> values, String name, T fallback) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

DateTime _parseDateTime(String value, String field) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) throw FormatException('Invalid $field');
  return parsed.toUtc();
}
