// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiMessageDto _$AiMessageDtoFromJson(Map<String, dynamic> json) =>
    _AiMessageDto(
      role: json['role'] as String? ?? "user",
      content: json['content'] as String? ?? "",
      reasoningContent: json['reasoning_content'] as String?,
      toolCalls: (json['tool_calls'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      toolCallId: json['tool_call_id'] as String?,
    );

Map<String, dynamic> _$AiMessageDtoToJson(_AiMessageDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
      'reasoning_content': ?instance.reasoningContent,
      'tool_calls': ?instance.toolCalls,
      'tool_call_id': ?instance.toolCallId,
    };
