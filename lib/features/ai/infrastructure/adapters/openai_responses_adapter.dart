import 'dart:convert';
import 'dart:developer' as developer;

import 'package:JsxposedX/features/ai/domain/events/ai_stream_event.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/protocol_adapter_support.dart';
import 'package:JsxposedX/features/ai/infrastructure/transport/sse_decoder.dart';
import 'package:flutter/foundation.dart';

class OpenAiResponsesAdapter implements AiProtocolAdapter {
  const OpenAiResponsesAdapter({this.maxSseEventBytes = 1024 * 1024});

  final int maxSseEventBytes;

  @override
  String get id => 'openai.responses.v1';

  @override
  PreparedAiRequest prepare(
    AiRequest request, {
    required AiAdapterContext context,
  }) {
    final headers = <String, String>{
      'Accept': 'text/event-stream',
      'Content-Type': 'application/json',
      ...request.connection.customHeaders,
    };
    var endpoint = resolveAiEndpoint(
      request.connection,
      AiEndpointKind.responses,
      'responses',
    );
    endpoint = applyAiAuthentication(
      endpoint: endpoint,
      headers: headers,
      context: context,
    );
    final input = request.messages
        .expand(
          (message) => _inputItems(
            message,
            allowImage: request.model.capabilities.visionInput,
          ),
        )
        .toList(growable: false);
    if (kDebugMode) {
      developer.log(
        '[AI][Responses] input=${input.map(_debugInputItem).join(' | ')}',
        name: 'AiTransport',
      );
    }
    final body = <String, Object?>{
      'model': request.model.id,
      'input': input,
      'stream': request.options.stream,
    };
    final options = request.options;
    if (options.maxOutputTokens != null) {
      body['max_output_tokens'] = options.maxOutputTokens;
    }
    if (options.temperature != null) body['temperature'] = options.temperature;
    if (options.topP != null) body['top_p'] = options.topP;
    if (options.reasoningEffort != null) {
      body['reasoning'] = {'effort': options.reasoningEffort};
    }
    if (request.tools.isNotEmpty) {
      body['tools'] = request.tools
          .map(
            (tool) => <String, Object?>{
              'type': 'function',
              'name': tool.name,
              'description': tool.description,
              'parameters': tool.inputSchema,
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
    final functionCallIdsByItemId = <String, String>{};
    final outputIndexesByItemId = <String, int>{};
    final functionCallIdsByOutputIndex = <int, String>{};
    final argumentsByOutputIndex = <int, StringBuffer>{};
    yield AiStreamEvent.started(requestId: requestId, sequence: sequence++);
    try {
      await for (final event in AiSseDecoder(
        maxEventBytes: maxSseEventBytes,
      ).decode(bytes)) {
        Object? raw;
        try {
          raw = jsonDecode(event.data);
        } on FormatException catch (error) {
          throw FormatException(
            'invalid Responses SSE event (${_preview(event.data)}): ${error.message}',
          );
        }
        if (raw is! Map) {
          throw const FormatException('Responses event is not an object');
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
          case 'response.output_text.delta':
            final delta = map['delta']?.toString() ?? '';
            if (delta.isNotEmpty) {
              yield AiStreamEvent.textDelta(
                requestId: requestId,
                sequence: sequence++,
                itemId: map['item_id']?.toString() ?? requestId,
                delta: delta,
              );
            }
          case 'response.reasoning_summary_text.delta' ||
              'response.reasoning_text.delta':
            final delta = map['delta']?.toString() ?? '';
            if (delta.isNotEmpty) {
              yield AiStreamEvent.reasoningDelta(
                requestId: requestId,
                sequence: sequence++,
                itemId: map['item_id']?.toString() ?? requestId,
                delta: delta,
              );
            }
          case 'response.output_item.added':
            final item = map['item'];
            if (item is Map && item['type'] == 'function_call') {
              final itemId = item['id']?.toString();
              final callId = _callId(item['call_id'], itemId: itemId);
              final outputIndex = aiIntValue(map['output_index']) ?? 0;
              if (itemId != null && itemId.isNotEmpty) {
                outputIndexesByItemId[itemId] = outputIndex;
              }
              _rememberFunctionCallId(
                itemId: itemId,
                outputIndex: outputIndex,
                callId: callId,
                byItemId: functionCallIdsByItemId,
                byOutputIndex: functionCallIdsByOutputIndex,
              );
              yield AiStreamEvent.toolCallDelta(
                requestId: requestId,
                sequence: sequence++,
                index: outputIndex,
                toolCallId: callId,
                name: item['name']?.toString(),
              );
            }
          case 'response.function_call_arguments.delta':
            final itemId = map['item_id']?.toString();
            final outputIndex = aiIntValue(map['output_index']) ?? 0;
            final callId =
                _callId(map['call_id'], itemId: itemId) ??
                (itemId == null ? null : functionCallIdsByItemId[itemId]) ??
                functionCallIdsByOutputIndex[outputIndex];
            final delta = map['delta']?.toString() ?? '';
            if (delta.isNotEmpty) {
              argumentsByOutputIndex
                  .putIfAbsent(outputIndex, StringBuffer.new)
                  .write(delta);
            }
            yield AiStreamEvent.toolCallDelta(
              requestId: requestId,
              sequence: sequence++,
              index: outputIndex,
              toolCallId: callId,
              argumentsDelta: delta,
            );
          case 'response.function_call_arguments.done':
            final itemId = map['item_id']?.toString();
            final outputIndex = aiIntValue(map['output_index']) ?? 0;
            final callId =
                _callId(map['call_id'], itemId: itemId) ??
                (itemId == null ? null : functionCallIdsByItemId[itemId]) ??
                functionCallIdsByOutputIndex[outputIndex];
            _rememberFunctionCallId(
              itemId: itemId,
              outputIndex: outputIndex,
              callId: callId,
              byItemId: functionCallIdsByItemId,
              byOutputIndex: functionCallIdsByOutputIndex,
            );
            final completeArguments = map['arguments']?.toString() ?? '';
            final seenArguments =
                argumentsByOutputIndex[outputIndex]?.toString() ?? '';
            final remainingArguments =
                completeArguments.startsWith(seenArguments)
                ? completeArguments.substring(seenArguments.length)
                : (seenArguments.isEmpty ? completeArguments : '');
            if (remainingArguments.isNotEmpty) {
              argumentsByOutputIndex
                  .putIfAbsent(outputIndex, StringBuffer.new)
                  .write(remainingArguments);
            }
            yield AiStreamEvent.toolCallDelta(
              requestId: requestId,
              sequence: sequence++,
              index: outputIndex,
              toolCallId: callId,
              argumentsDelta: remainingArguments,
            );
          case 'response.output_item.done':
            final item = map['item'];
            if (item is Map && item['type'] == 'function_call') {
              final itemId = item['id']?.toString();
              final outputIndex =
                  aiIntValue(map['output_index']) ??
                  (itemId == null ? null : outputIndexesByItemId[itemId]) ??
                  0;
              final callId = _callId(item['call_id'], itemId: itemId);
              _rememberFunctionCallId(
                itemId: itemId,
                outputIndex: outputIndex,
                callId: callId,
                byItemId: functionCallIdsByItemId,
                byOutputIndex: functionCallIdsByOutputIndex,
              );
              yield AiStreamEvent.toolCallDelta(
                requestId: requestId,
                sequence: sequence++,
                index: outputIndex,
                toolCallId: callId,
                name: _nonEmptyString(item['name']),
              );
            }
          case 'response.completed':
            final response = map['response'];
            final responseMap = response is Map
                ? Map<String, Object?>.from(response)
                : const <String, Object?>{};
            final usage = _usage(responseMap['usage']);
            if (usage != null) {
              yield AiStreamEvent.usage(
                requestId: requestId,
                sequence: sequence++,
                value: usage,
              );
            }
            terminal = true;
            yield AiStreamEvent.completed(
              requestId: requestId,
              sequence: sequence++,
              reason: _finishReason(responseMap),
            );
          case 'response.incomplete':
            terminal = true;
            yield AiStreamEvent.completed(
              requestId: requestId,
              sequence: sequence++,
              reason: AiFinishReason.length,
            );
          case 'response.failed' || 'error':
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
    } on FormatException catch (error) {
      yield AiStreamEvent.failed(
        requestId: requestId,
        sequence: sequence++,
        failure: AiFailure(
          code: AiFailureCode.protocolMalformed,
          messageKey: error.message.trim().isEmpty
              ? 'ai.error.protocolMalformed'
              : 'Responses stream parse error: ${error.message}',
        ),
      );
    }
  }

  static String? _nonEmptyString(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static String _debugInputItem(Map<String, Object?> item) {
    final type =
        item['type']?.toString() ?? item['role']?.toString() ?? 'unknown';
    final callId = item['call_id']?.toString();
    return callId == null ? type : '$type($callId)';
  }

  static String _preview(String value) {
    final normalized = value.replaceAll('\n', '\\n').replaceAll('\r', '\\r');
    return normalized.length <= 240
        ? normalized
        : '${normalized.substring(0, 240)}...';
  }

  static String? _callId(Object? value, {String? itemId}) {
    final callId = _nonEmptyString(value);
    return callId == null || callId == itemId ? null : callId;
  }

  static void _rememberFunctionCallId({
    required String? itemId,
    required int outputIndex,
    required String? callId,
    required Map<String, String> byItemId,
    required Map<int, String> byOutputIndex,
  }) {
    if (callId == null) return;
    if (itemId != null && itemId.isNotEmpty) byItemId[itemId] = callId;
    byOutputIndex[outputIndex] = callId;
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
      final output = map['output'];
      if (output is List) {
        for (var index = 0; index < output.length; index++) {
          final rawItem = output[index];
          if (rawItem is! Map) continue;
          final item = Map<String, Object?>.from(rawItem);
          if (item['type'] == 'function_call') {
            yield AiStreamEvent.toolCallDelta(
              requestId: requestId,
              sequence: sequence++,
              index: index,
              toolCallId: _callId(
                item['call_id'],
                itemId: item['id']?.toString(),
              ),
              name: item['name']?.toString(),
              argumentsDelta: item['arguments']?.toString(),
            );
            continue;
          }
          final content = item['content'];
          if (content is! List) continue;
          for (final rawPart in content) {
            if (rawPart is! Map) continue;
            final part = Map<String, Object?>.from(rawPart);
            final text = part['text']?.toString() ?? '';
            if (text.isEmpty) continue;
            if (part['type'] == 'reasoning_text' ||
                part['type'] == 'summary_text') {
              yield AiStreamEvent.reasoningDelta(
                requestId: requestId,
                sequence: sequence++,
                itemId: item['id']?.toString() ?? requestId,
                delta: text,
              );
            } else if (part['type'] == 'output_text') {
              yield AiStreamEvent.textDelta(
                requestId: requestId,
                sequence: sequence++,
                itemId: item['id']?.toString() ?? requestId,
                delta: text,
              );
            }
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
        reason: _finishReason(map),
      );
    } on FormatException catch (error) {
      yield AiStreamEvent.failed(
        requestId: requestId,
        sequence: sequence++,
        failure: AiFailure(
          code: AiFailureCode.protocolMalformed,
          messageKey: error.message.trim().isEmpty
              ? 'ai.error.protocolMalformed'
              : 'Responses parse error: ${error.message}',
        ),
      );
    }
  }

  static Iterable<Map<String, Object?>> _inputItems(
    AiMessage message, {
    required bool allowImage,
  }) sync* {
    final text = aiTextContent(message);
    if (text.isNotEmpty) {
      final role = switch (message.role) {
        AiMessageRole.system => 'developer',
        AiMessageRole.tool => 'user',
        AiMessageRole.user => 'user',
        AiMessageRole.assistant => 'assistant',
      };
      final contentType = role == 'assistant' ? 'output_text' : 'input_text';
      final content =
          message.role == AiMessageRole.user &&
              AiMultimodalMessageCodec.isEncoded(text)
          ? AiMultimodalMessageCodec.toOpenAiContent(
              text,
              isZh: true,
              allowImage: allowImage,
            )
                .map<Map<String, Object?>>((part) {
                  if (part['type'] == 'image_url') {
                    final image = part['image_url'];
                    return {
                      'type': 'input_image',
                      'image_url': image is Map
                          ? image['url']?.toString() ?? ''
                          : '',
                    };
                  }
                  return {
                    'type': 'input_text',
                    'text': part['text']?.toString() ?? '',
                  };
                })
                .toList(growable: false)
          : <Map<String, Object?>>[
              {'type': contentType, 'text': text},
            ];
      yield {'role': role, 'content': content};
    }
    for (final part in message.parts.whereType<AiToolCallPart>()) {
      yield {
        'type': 'function_call',
        'call_id': part.toolCall.id,
        'name': part.toolCall.name,
        'arguments': jsonEncode(part.toolCall.arguments),
      };
    }
    for (final part in message.parts.whereType<AiToolResultPart>()) {
      yield {
        'type': 'function_call_output',
        'call_id': part.toolResult.toolCallId,
        'output': part.toolResult.content,
      };
    }
  }

  static AiUsage? _usage(Object? raw) {
    if (raw is! Map) return null;
    final input = aiIntValue(raw['input_tokens']);
    final output = aiIntValue(raw['output_tokens']);
    final total = aiIntValue(raw['total_tokens']);
    if (input == null && output == null && total == null) return null;
    return AiUsage(
      inputTokens: input ?? 0,
      outputTokens: output ?? 0,
      totalTokens: total ?? ((input ?? 0) + (output ?? 0)),
    );
  }

  static AiFinishReason _finishReason(Map<String, Object?> response) {
    return response['status']?.toString() == 'incomplete'
        ? AiFinishReason.length
        : AiFinishReason.stop;
  }
}
