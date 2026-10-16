import 'dart:convert';

import 'package:JsxposedX/features/ai/domain/events/ai_stream_event.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/protocol_adapter_support.dart';
import 'package:JsxposedX/features/ai/infrastructure/transport/sse_decoder.dart';

class AnthropicMessagesAdapter implements AiProtocolAdapter {
  const AnthropicMessagesAdapter({this.maxSseEventBytes = 1024 * 1024});

  final int maxSseEventBytes;

  @override
  String get id => 'anthropic.messages.v1';

  @override
  PreparedAiRequest prepare(
    AiRequest request, {
    required AiAdapterContext context,
  }) {
    final headers = <String, String>{
      'Accept': 'text/event-stream',
      'Content-Type': 'application/json',
      'anthropic-version': '2023-06-01',
      ...request.connection.customHeaders,
    };
    var endpoint = resolveAiEndpoint(
      request.connection,
      AiEndpointKind.messages,
      'messages',
    );
    endpoint = applyAiAuthentication(
      endpoint: endpoint,
      headers: headers,
      context: context,
    );
    final system = request.messages
        .where((message) => message.role == AiMessageRole.system)
        .map(aiTextContent)
        .where((text) => text.isNotEmpty)
        .join('\n\n');
    final body = <String, Object?>{
      'model': request.model.id,
      'messages': request.messages
          .where((message) => message.role != AiMessageRole.system)
          .map(
            (message) => _messageJson(
              message,
              allowImage: request.model.capabilities.visionInput,
            ),
          )
          .toList(growable: false),
      'max_tokens':
          request.options.maxOutputTokens ??
          request.model.limits.maxOutputTokens ??
          4096,
      'stream': request.options.stream,
      if (system.isNotEmpty) 'system': system,
    };
    if (request.options.temperature != null) {
      body['temperature'] = request.options.temperature;
    }
    if (request.options.topP != null) body['top_p'] = request.options.topP;
    if (request.tools.isNotEmpty) {
      body['tools'] = request.tools
          .map(
            (tool) => <String, Object?>{
              'name': tool.name,
              'description': tool.description,
              'input_schema': tool.inputSchema,
            },
          )
          .toList(growable: false);
    }
    return PreparedAiRequest(uri: endpoint, headers: headers, body: body);
  }

  @override
  Stream<AiStreamEvent> decodeStream(
    Stream<List<int>> bytes, {
    required String requestId,
  }) async* {
    var sequence = 0;
    var terminal = false;
    final blockIds = <int, String>{};
    yield AiStreamEvent.started(requestId: requestId, sequence: sequence++);
    try {
      await for (final event in AiSseDecoder(
        maxEventBytes: maxSseEventBytes,
      ).decode(bytes)) {
        final raw = jsonDecode(event.data);
        if (raw is! Map) {
          throw const FormatException('Anthropic event is not an object');
        }
        final map = Map<String, Object?>.from(raw);
        if (aiPayloadIsError(map)) {
          yield AiStreamEvent.failed(
            requestId: requestId,
            sequence: sequence++,
            failure: aiProviderPayloadFailure(map),
          );
          return;
        }
        final type = map['type']?.toString() ?? event.event;
        switch (type) {
          case 'message_start':
            final message = map['message'];
            if (message is Map) {
              final usage = _usage(message['usage']);
              if (usage != null) {
                yield AiStreamEvent.usage(
                  requestId: requestId,
                  sequence: sequence++,
                  value: usage,
                );
              }
            }
          case 'content_block_start':
            final index = aiIntValue(map['index']) ?? 0;
            final block = map['content_block'];
            if (block is Map && block['type'] == 'tool_use') {
              final id = block['id']?.toString();
              if (id != null) blockIds[index] = id;
              yield AiStreamEvent.toolCallDelta(
                requestId: requestId,
                sequence: sequence++,
                index: index,
                toolCallId: id,
                name: block['name']?.toString(),
              );
            }
          case 'content_block_delta':
            final index = aiIntValue(map['index']) ?? 0;
            final delta = map['delta'];
            if (delta is! Map) continue;
            switch (delta['type']?.toString()) {
              case 'text_delta':
                final text = delta['text']?.toString() ?? '';
                if (text.isNotEmpty) {
                  yield AiStreamEvent.textDelta(
                    requestId: requestId,
                    sequence: sequence++,
                    itemId: 'block-$index',
                    delta: text,
                  );
                }
              case 'thinking_delta':
                final thinking = delta['thinking']?.toString() ?? '';
                if (thinking.isNotEmpty) {
                  yield AiStreamEvent.reasoningDelta(
                    requestId: requestId,
                    sequence: sequence++,
                    itemId: 'block-$index',
                    delta: thinking,
                  );
                }
              case 'input_json_delta':
                yield AiStreamEvent.toolCallDelta(
                  requestId: requestId,
                  sequence: sequence++,
                  index: index,
                  toolCallId: blockIds[index],
                  argumentsDelta: delta['partial_json']?.toString(),
                );
            }
          case 'message_delta':
            final usage = _usage(map['usage']);
            if (usage != null) {
              yield AiStreamEvent.usage(
                requestId: requestId,
                sequence: sequence++,
                value: usage,
              );
            }
            final delta = map['delta'];
            if (delta is Map) {
              final reason = _finishReason(delta['stop_reason']);
              if (reason != null && !terminal) {
                terminal = true;
                yield AiStreamEvent.completed(
                  requestId: requestId,
                  sequence: sequence++,
                  reason: reason,
                );
              }
            }
          case 'message_stop':
            if (!terminal) {
              terminal = true;
              yield AiStreamEvent.completed(
                requestId: requestId,
                sequence: sequence++,
                reason: AiFinishReason.stop,
              );
            }
          case 'error':
            terminal = true;
            yield AiStreamEvent.failed(
              requestId: requestId,
              sequence: sequence++,
              failure: aiProviderPayloadFailure(map),
            );
        }
      }
      if (!terminal) {
        yield AiStreamEvent.failed(
          requestId: requestId,
          sequence: sequence++,
          failure: const AiFailure(
            code: AiFailureCode.protocolTruncated,
            messageKey: 'ai.error.protocolTruncated',
          ),
        );
      }
    } on FormatException {
      yield AiStreamEvent.failed(
        requestId: requestId,
        sequence: sequence++,
        failure: const AiFailure(
          code: AiFailureCode.protocolMalformed,
          messageKey: 'ai.error.protocolMalformed',
        ),
      );
    }
  }

  @override
  Stream<AiStreamEvent> decodeResponse(
    List<int> bytes, {
    required String requestId,
  }) async* {
    var sequence = 0;
    yield AiStreamEvent.started(requestId: requestId, sequence: sequence++);
    try {
      final raw = jsonDecode(utf8.decode(bytes));
      if (raw is! Map) throw const FormatException('Invalid response');
      final map = Map<String, Object?>.from(raw);
      if (aiPayloadIsError(map)) {
        yield AiStreamEvent.failed(
          requestId: requestId,
          sequence: sequence++,
          failure: aiProviderPayloadFailure(map),
        );
        return;
      }
      final content = map['content'];
      if (content is List) {
        for (var index = 0; index < content.length; index++) {
          final rawPart = content[index];
          if (rawPart is! Map) continue;
          final part = Map<String, Object?>.from(rawPart);
          switch (part['type']?.toString()) {
            case 'text':
              yield AiStreamEvent.textDelta(
                requestId: requestId,
                sequence: sequence++,
                itemId: 'block-$index',
                delta: part['text']?.toString() ?? '',
              );
            case 'thinking':
              yield AiStreamEvent.reasoningDelta(
                requestId: requestId,
                sequence: sequence++,
                itemId: 'block-$index',
                delta: part['thinking']?.toString() ?? '',
              );
            case 'tool_use':
              yield AiStreamEvent.toolCallDelta(
                requestId: requestId,
                sequence: sequence++,
                index: index,
                toolCallId: part['id']?.toString(),
                name: part['name']?.toString(),
                argumentsDelta: jsonEncode(part['input']),
              );
          }
        }
      }
      final usage = _usage(map['usage']);
      if (usage != null) {
        yield AiStreamEvent.usage(
          requestId: requestId,
          sequence: sequence++,
          value: usage,
        );
      }
      yield AiStreamEvent.completed(
        requestId: requestId,
        sequence: sequence++,
        reason: _finishReason(map['stop_reason']) ?? AiFinishReason.unknown,
      );
    } on FormatException {
      yield AiStreamEvent.failed(
        requestId: requestId,
        sequence: sequence++,
        failure: const AiFailure(
          code: AiFailureCode.protocolMalformed,
          messageKey: 'ai.error.protocolMalformed',
        ),
      );
    }
  }

  static Map<String, Object?> _messageJson(
    AiMessage message, {
    required bool allowImage,
  }) {
    final content = <Map<String, Object?>>[];
    final text = aiTextContent(message);
    if (message.role == AiMessageRole.user &&
        AiMultimodalMessageCodec.isEncoded(text)) {
      content.addAll(
        AiMultimodalMessageCodec.toAnthropicContent(
          text,
          isZh: true,
          allowImage: allowImage,
        ),
      );
    } else if (text.isNotEmpty) {
      content.add({'type': 'text', 'text': text});
    }
    for (final part in message.parts.whereType<AiToolCallPart>()) {
      content.add({
        'type': 'tool_use',
        'id': part.toolCall.id,
        'name': part.toolCall.name,
        'input': part.toolCall.arguments,
      });
    }
    for (final part in message.parts.whereType<AiToolResultPart>()) {
      content.add({
        'type': 'tool_result',
        'tool_use_id': part.toolResult.toolCallId,
        'content': part.toolResult.content,
        if (!part.toolResult.success) 'is_error': true,
      });
    }
    return {
      'role': message.role == AiMessageRole.assistant ? 'assistant' : 'user',
      'content': content,
    };
  }

  static AiUsage? _usage(Object? raw) {
    if (raw is! Map) return null;
    final input = aiIntValue(raw['input_tokens']);
    final output = aiIntValue(raw['output_tokens']);
    if (input == null && output == null) return null;
    return AiUsage(
      inputTokens: input ?? 0,
      outputTokens: output ?? 0,
      totalTokens: (input ?? 0) + (output ?? 0),
    );
  }

  static AiFinishReason? _finishReason(Object? raw) =>
      switch (raw?.toString()) {
        'end_turn' || 'stop_sequence' => AiFinishReason.stop,
        'max_tokens' => AiFinishReason.length,
        'tool_use' => AiFinishReason.toolCall,
        _ => null,
      };
}
