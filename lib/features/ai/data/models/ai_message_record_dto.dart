import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

part 'ai_message_record_dto.freezed.dart';
part 'ai_message_record_dto.g.dart';

@freezed
abstract class AiContentPartDto with _$AiContentPartDto {
  const AiContentPartDto._();

  const factory AiContentPartDto({
    required String type,
    String? text,
    String? attachmentId,
    String? toolCallId,
    String? toolName,
    Map<String, Object?>? arguments,
    bool? success,
  }) = _AiContentPartDto;

  factory AiContentPartDto.fromJson(Map<String, Object?> json) =>
      _$AiContentPartDtoFromJson(json);

  factory AiContentPartDto.fromEntity(AiContentPart entity) => switch (entity) {
    AiTextPart(:final text) => AiContentPartDto(type: 'text', text: text),
    AiReasoningPart(:final text) => AiContentPartDto(
      type: 'reasoning',
      text: text,
    ),
    AiImagePart(:final attachmentId) => AiContentPartDto(
      type: 'image',
      attachmentId: attachmentId,
    ),
    AiToolCallPart(:final toolCall) => AiContentPartDto(
      type: 'toolCall',
      toolCallId: toolCall.id,
      toolName: toolCall.name,
      arguments: toolCall.arguments,
    ),
    AiToolResultPart(:final toolResult) => AiContentPartDto(
      type: 'toolResult',
      text: toolResult.content,
      toolCallId: toolResult.toolCallId,
      toolName: toolResult.name,
      success: toolResult.success,
    ),
  };

  AiContentPart toEntity() => switch (type) {
    'text' => AiContentPart.text(text ?? ''),
    'reasoning' => AiContentPart.reasoning(text ?? ''),
    'image' when attachmentId != null => AiContentPart.image(
      attachmentId: attachmentId!,
    ),
    'toolCall' when toolCallId != null && toolName != null =>
      AiContentPart.toolCall(
        toolCall: AiToolCall(
          id: toolCallId!,
          name: toolName!,
          arguments: arguments ?? const {},
        ),
      ),
    'toolResult' when toolCallId != null && toolName != null =>
      AiContentPart.toolResult(
        toolResult: AiToolResult(
          toolCallId: toolCallId!,
          name: toolName!,
          success: success ?? false,
          content: text ?? '',
        ),
      ),
    _ => throw FormatException('Unknown or incomplete content part: $type'),
  };
}

@freezed
abstract class AiUsageDto with _$AiUsageDto {
  const AiUsageDto._();

  const factory AiUsageDto({
    @Default(0) int inputTokens,
    @Default(0) int outputTokens,
    @Default(0) int totalTokens,
  }) = _AiUsageDto;

  factory AiUsageDto.fromJson(Map<String, Object?> json) =>
      _$AiUsageDtoFromJson(json);

  factory AiUsageDto.fromEntity(AiUsage entity) => AiUsageDto(
    inputTokens: entity.inputTokens,
    outputTokens: entity.outputTokens,
    totalTokens: entity.totalTokens,
  );

  AiUsage toEntity() => AiUsage(
    inputTokens: inputTokens,
    outputTokens: outputTokens,
    totalTokens: totalTokens,
  );
}

@freezed
abstract class AiFailureDto with _$AiFailureDto {
  const AiFailureDto._();

  const factory AiFailureDto({
    required String code,
    required String messageKey,
    @Default(false) bool retryable,
    int? httpStatus,
    String? providerRequestId,
  }) = _AiFailureDto;

  factory AiFailureDto.fromJson(Map<String, Object?> json) =>
      _$AiFailureDtoFromJson(json);

  factory AiFailureDto.fromEntity(AiFailure entity) => AiFailureDto(
    code: entity.code.name,
    messageKey: entity.messageKey,
    retryable: entity.retryable,
    httpStatus: entity.httpStatus,
    providerRequestId: entity.providerRequestId,
  );

  AiFailure toEntity() => AiFailure(
    code: _failureCode(code),
    messageKey: messageKey,
    retryable: retryable,
    httpStatus: httpStatus,
    providerRequestId: providerRequestId,
  );

  static AiFailureCode _failureCode(String value) {
    for (final code in AiFailureCode.values) {
      if (code.name == value) return code;
    }
    return AiFailureCode.unknown;
  }
}

@freezed
abstract class AiMessageRecordDto with _$AiMessageRecordDto {
  const AiMessageRecordDto._();

  @JsonSerializable(explicitToJson: true)
  const factory AiMessageRecordDto({
    required String id,
    required String conversationId,
    required String role,
    required List<AiContentPartDto> parts,
    @Default('completed') String status,
    String? parentId,
    AiUsageDto? usage,
    AiFailureDto? failure,
    required String createdAt,
    String? completedAt,
  }) = _AiMessageRecordDto;

  factory AiMessageRecordDto.fromJson(Map<String, Object?> json) =>
      _$AiMessageRecordDtoFromJson(json);

  factory AiMessageRecordDto.fromEntity(AiMessage entity) => AiMessageRecordDto(
    id: entity.id,
    conversationId: entity.conversationId,
    role: entity.role.name,
    parts: entity.parts
        .map(AiContentPartDto.fromEntity)
        .toList(growable: false),
    status: entity.status.name,
    parentId: entity.parentId,
    usage: entity.usage == null ? null : AiUsageDto.fromEntity(entity.usage!),
    failure: entity.failure == null
        ? null
        : AiFailureDto.fromEntity(entity.failure!),
    createdAt: entity.createdAt.toUtc().toIso8601String(),
    completedAt: entity.completedAt?.toUtc().toIso8601String(),
  );

  AiMessage toEntity() => AiMessage(
    id: id,
    conversationId: conversationId,
    role: _enumByName(AiMessageRole.values, role, AiMessageRole.user),
    parts: parts.map((part) => part.toEntity()).toList(growable: false),
    status: _enumByName(
      AiMessageStatus.values,
      status,
      AiMessageStatus.completed,
    ),
    parentId: parentId,
    usage: usage?.toEntity(),
    failure: failure?.toEntity(),
    createdAt: _parseDateTime(createdAt, 'createdAt'),
    completedAt: completedAt == null
        ? null
        : _parseDateTime(completedAt!, 'completedAt'),
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
