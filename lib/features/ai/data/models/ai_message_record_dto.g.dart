// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_message_record_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiContentPartDto _$AiContentPartDtoFromJson(Map<String, dynamic> json) =>
    _AiContentPartDto(
      type: json['type'] as String,
      text: json['text'] as String?,
      attachmentId: json['attachmentId'] as String?,
      toolCallId: json['toolCallId'] as String?,
      toolName: json['toolName'] as String?,
      arguments: json['arguments'] as Map<String, dynamic>?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$AiContentPartDtoToJson(_AiContentPartDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'text': instance.text,
      'attachmentId': instance.attachmentId,
      'toolCallId': instance.toolCallId,
      'toolName': instance.toolName,
      'arguments': instance.arguments,
      'success': instance.success,
    };

_AiUsageDto _$AiUsageDtoFromJson(Map<String, dynamic> json) => _AiUsageDto(
  inputTokens: (json['inputTokens'] as num?)?.toInt() ?? 0,
  outputTokens: (json['outputTokens'] as num?)?.toInt() ?? 0,
  totalTokens: (json['totalTokens'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AiUsageDtoToJson(_AiUsageDto instance) =>
    <String, dynamic>{
      'inputTokens': instance.inputTokens,
      'outputTokens': instance.outputTokens,
      'totalTokens': instance.totalTokens,
    };

_AiFailureDto _$AiFailureDtoFromJson(Map<String, dynamic> json) =>
    _AiFailureDto(
      code: json['code'] as String,
      messageKey: json['messageKey'] as String,
      retryable: json['retryable'] as bool? ?? false,
      httpStatus: (json['httpStatus'] as num?)?.toInt(),
      providerRequestId: json['providerRequestId'] as String?,
    );

Map<String, dynamic> _$AiFailureDtoToJson(_AiFailureDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'messageKey': instance.messageKey,
      'retryable': instance.retryable,
      'httpStatus': instance.httpStatus,
      'providerRequestId': instance.providerRequestId,
    };

_AiMessageRecordDto _$AiMessageRecordDtoFromJson(Map<String, dynamic> json) =>
    _AiMessageRecordDto(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      role: json['role'] as String,
      parts: (json['parts'] as List<dynamic>)
          .map((e) => AiContentPartDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String? ?? 'completed',
      parentId: json['parentId'] as String?,
      usage: json['usage'] == null
          ? null
          : AiUsageDto.fromJson(json['usage'] as Map<String, dynamic>),
      failure: json['failure'] == null
          ? null
          : AiFailureDto.fromJson(json['failure'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
      completedAt: json['completedAt'] as String?,
    );

Map<String, dynamic> _$AiMessageRecordDtoToJson(_AiMessageRecordDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'role': instance.role,
      'parts': instance.parts.map((e) => e.toJson()).toList(),
      'status': instance.status,
      'parentId': instance.parentId,
      'usage': instance.usage?.toJson(),
      'failure': instance.failure?.toJson(),
      'createdAt': instance.createdAt,
      'completedAt': instance.completedAt,
    };
