import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/domain/events/ai_stream_event.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/anthropic_messages_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_chat_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_responses_adapter.dart';

void main() {
  test('serializes legacy UI image payload for every standard adapter', () {
    final encoded =
        '[ai_multimodal_v1]${jsonEncode({
          'text': 'inspect this',
          'attachments': [
            {'kind': 'image', 'file_name': 'sample.png', 'mime_type': 'image/png', 'size': 3, 'data_base64': 'YWJj'},
          ],
        })}';
    final request = _request(providerId: 'openai').copyWith(
      messages: [
        AiMessage(
          id: 'image-user',
          conversationId: 'conversation',
          role: AiMessageRole.user,
          parts: [AiContentPart.text(encoded)],
          createdAt: _epoch,
        ),
      ],
    );

    final chat = const OpenAiChatAdapter().prepare(
      request,
      context: _adapterContext('openai', 'openai.chat.v1'),
    );
    final chatContent =
        ((chat.body['messages'] as List).single as Map)['content'] as List;
    expect(chatContent.last['type'], 'image_url');

    final responses = const OpenAiResponsesAdapter().prepare(
      request.copyWith(
        connection: request.connection.copyWith(providerId: 'openai-responses'),
      ),
      context: _adapterContext('openai-responses', 'openai.responses.v1'),
    );
    final responsesContent =
        ((responses.body['input'] as List).single as Map)['content'] as List;
    expect(responsesContent.last['type'], 'input_image');

    final anthropic = const AnthropicMessagesAdapter().prepare(
      request.copyWith(
        connection: request.connection.copyWith(providerId: 'anthropic'),
      ),
      context: _adapterContext('anthropic', 'anthropic.messages.v1'),
    );
    final anthropicContent =
        ((anthropic.body['messages'] as List).single as Map)['content'] as List;
    expect(anthropicContent.last['type'], 'image');
  });

  test(
    'keeps provider detail from an embedded OpenAI error envelope',
    () async {
      final events = await const OpenAiChatAdapter()
          .decodeResponse(
            utf8.encode(
              jsonEncode({
                'error': {'message': '模型暂不支持该接口'},
              }),
            ),
            requestId: 'request-1',
          )
          .toList();

      final failure = events.whereType<AiResponseFailed>().single.failure;
      expect(failure.code, AiFailureCode.serverFailure);
      expect(failure.messageKey, '模型暂不支持该接口');
    },
  );

  test('keeps error detail from an OpenAI Responses failure event', () async {
    final payload = jsonEncode({
      'type': 'response.failed',
      'response': {
        'error': {'message': 'Responses 被网关拒绝'},
      },
    });
    final events = await const OpenAiResponsesAdapter()
        .decodeStream(
          Stream.value(
            utf8.encode('event: response.failed\ndata: $payload\n\n'),
          ),
          requestId: 'request-1',
        )
        .toList();

    final failure = events.whereType<AiResponseFailed>().single.failure;
    expect(failure.code, AiFailureCode.serverFailure);
    expect(failure.messageKey, 'Responses 被网关拒绝');
  });

  group('OpenAiResponsesAdapter', () {
    const adapter = OpenAiResponsesAdapter();

    test('decodes text, reasoning, usage and completion events', () async {
      final events = [
        {
          'type': 'response.reasoning_summary_text.delta',
          'item_id': 'r',
          'delta': 'think',
        },
        {
          'type': 'response.output_text.delta',
          'item_id': 'o',
          'delta': 'answer',
        },
        {
          'type': 'response.completed',
          'response': {
            'status': 'completed',
            'usage': {'input_tokens': 2, 'output_tokens': 4, 'total_tokens': 6},
          },
        },
      ];
      final stream = Stream<List<int>>.fromIterable(
        events.map((event) => utf8.encode('data: ${jsonEncode(event)}\n\n')),
      );

      final values = await adapter
          .decodeStream(stream, requestId: 'responses')
          .toList();

      expect(values.whereType<AiReasoningDelta>().single.delta, 'think');
      expect(values.whereType<AiTextDelta>().single.delta, 'answer');
      expect(values.whereType<AiUsageUpdated>().single.value.totalTokens, 6);
      expect(values.whereType<AiResponseCompleted>(), hasLength(1));
    });

    test('rejects a non-standard [DONE] marker', () async {
      final values = await adapter
          .decodeStream(
            Stream.value(utf8.encode('data: [DONE]\n\n')),
            requestId: 'responses',
          )
          .toList();

      expect(
        values.whereType<AiResponseFailed>().single.failure.code,
        AiFailureCode.protocolMalformed,
      );
    });

    test('keeps Responses call_id when argument deltas use item_id', () async {
      final stream = Stream<List<int>>.fromIterable([
        utf8.encode(
          'data: ${jsonEncode({
            'type': 'response.output_item.added',
            'output_index': 0,
            'item': {'id': 'fc_item_1', 'type': 'function_call', 'call_id': 'call_real_1', 'name': 'list_apk_files'},
          })}\n\n',
        ),
        utf8.encode(
          'data: ${jsonEncode({'type': 'response.function_call_arguments.delta', 'output_index': 0, 'item_id': 'fc_item_1', 'delta': '{"path":""}'})}\n\n',
        ),
        utf8.encode(
          'data: ${jsonEncode({
            'type': 'response.completed',
            'response': {'status': 'completed'},
          })}\n\n',
        ),
      ]);

      final values = await adapter
          .decodeStream(stream, requestId: 'responses')
          .toList();

      final call = values.whereType<AiToolCallDelta>().last;
      expect(call.toolCallId, 'call_real_1');
    });

    test(
      'resolves a delayed call_id without using the item_id as a fallback',
      () async {
        final stream = Stream<List<int>>.fromIterable([
          utf8.encode(
            'data: ${jsonEncode({
              'type': 'response.output_item.added',
              'output_index': 0,
              'item': {'id': 'fc_item_2', 'type': 'function_call', 'name': 'search'},
            })}\n\n',
          ),
          utf8.encode(
            'data: ${jsonEncode({'type': 'response.function_call_arguments.delta', 'output_index': 0, 'item_id': 'fc_item_2', 'delta': '{"q":"x"}'})}\n\n',
          ),
          utf8.encode(
            'data: ${jsonEncode({'type': 'response.function_call_arguments.done', 'output_index': 0, 'item_id': 'fc_item_2', 'call_id': 'call_real_2', 'arguments': '{"q":"x"}'})}\n\n',
          ),
          utf8.encode(
            'data: ${jsonEncode({
              'type': 'response.completed',
              'response': {'status': 'completed'},
            })}\n\n',
          ),
        ]);

        final values = await adapter
            .decodeStream(stream, requestId: 'responses')
            .toList();
        final calls = values.whereType<AiToolCallDelta>().toList();

        expect(calls.first.toolCallId, isNull);
        expect(calls.last.toolCallId, 'call_real_2');
        expect(
          calls.map((call) => call.toolCallId),
          isNot(contains('fc_item_2')),
        );
      },
    );

    test('uses Responses request shape', () {
      final prepared = adapter.prepare(
        _request(providerId: 'openai-responses'),
        context: const AiAdapterContext(
          provider: AiProviderDefinition(
            id: 'openai-responses',
            displayName: 'Responses',
            adapterId: 'openai.responses.v1',
          ),
          apiKey: 'secret',
        ),
      );

      expect(prepared.uri.path, '/v1/responses');
      expect(prepared.body, contains('input'));
      expect(prepared.body, isNot(contains('messages')));
    });

    test('uses output_text for assistant history items', () {
      final request = _request(providerId: 'openai-responses').copyWith(
        messages: [
          ..._request(providerId: 'openai-responses').messages,
          AiMessage(
            id: 'assistant',
            conversationId: 'conversation',
            role: AiMessageRole.assistant,
            parts: [AiContentPart.text('previous answer')],
            createdAt: _epoch,
          ),
        ],
      );
      final prepared = adapter.prepare(
        request,
        context: const AiAdapterContext(
          provider: AiProviderDefinition(
            id: 'openai-responses',
            displayName: 'Responses',
            adapterId: 'openai.responses.v1',
          ),
          apiKey: 'secret',
        ),
      );

      final input = (prepared.body['input'] as List).last as Map;
      expect(input['role'], 'assistant');
      expect((input['content'] as List).single['type'], 'output_text');
    });

    test(
      'serializes a Responses function call and output as a linked pair',
      () {
        final request = _request(providerId: 'openai-responses').copyWith(
          messages: [
            AiMessage(
              id: 'assistant-call',
              conversationId: 'conversation',
              role: AiMessageRole.assistant,
              parts: const [
                AiContentPart.toolCall(
                  toolCall: AiToolCall(
                    id: 'fc_1',
                    name: 'inspect',
                    arguments: {'path': ''},
                  ),
                ),
              ],
              createdAt: _epoch,
            ),
            AiMessage(
              id: 'tool-result',
              conversationId: 'conversation',
              role: AiMessageRole.tool,
              parts: const [
                AiContentPart.toolResult(
                  toolResult: AiToolResult(
                    toolCallId: 'fc_1',
                    name: 'inspect',
                    success: true,
                    content: 'ok',
                  ),
                ),
              ],
              createdAt: _epoch,
            ),
          ],
        );
        final prepared = adapter.prepare(
          request,
          context: _adapterContext('openai-responses', 'openai.responses.v1'),
        );
        final input = prepared.body['input'] as List;
        final call = input.whereType<Map>().singleWhere(
          (item) => item['type'] == 'function_call',
        );
        final output = input.whereType<Map>().singleWhere(
          (item) => item['type'] == 'function_call_output',
        );
        expect(call['call_id'], 'fc_1');
        expect(output['call_id'], call['call_id']);
      },
    );
  });

  group('AnthropicMessagesAdapter', () {
    const adapter = AnthropicMessagesAdapter();

    test('decodes content and partial tool JSON', () async {
      final records = [
        (
          'content_block_start',
          {
            'type': 'content_block_start',
            'index': 0,
            'content_block': {
              'type': 'tool_use',
              'id': 'call-1',
              'name': 'scan',
            },
          },
        ),
        (
          'content_block_delta',
          {
            'type': 'content_block_delta',
            'index': 0,
            'delta': {
              'type': 'input_json_delta',
              'partial_json': '{"path":"x"}',
            },
          },
        ),
        (
          'content_block_delta',
          {
            'type': 'content_block_delta',
            'index': 1,
            'delta': {'type': 'text_delta', 'text': 'done'},
          },
        ),
        (
          'message_delta',
          {
            'type': 'message_delta',
            'delta': {'stop_reason': 'tool_use'},
            'usage': {'output_tokens': 8},
          },
        ),
      ];
      final stream = Stream<List<int>>.fromIterable(
        records.map(
          (record) => utf8.encode(
            'event: ${record.$1}\ndata: ${jsonEncode(record.$2)}\n\n',
          ),
        ),
      );

      final values = await adapter
          .decodeStream(stream, requestId: 'anthropic')
          .toList();

      final toolDeltas = values.whereType<AiToolCallDelta>().toList();
      expect(toolDeltas.first.toolCallId, 'call-1');
      expect(toolDeltas.last.argumentsDelta, '{"path":"x"}');
      expect(values.whereType<AiTextDelta>().single.delta, 'done');
      expect(
        values.whereType<AiResponseCompleted>().single.reason,
        AiFinishReason.toolCall,
      );
    });

    test('extracts system message and uses Anthropic headers', () {
      final prepared = adapter.prepare(
        _request(providerId: 'anthropic', includeSystem: true),
        context: const AiAdapterContext(
          provider: AiProviderDefinition(
            id: 'anthropic',
            displayName: 'Anthropic',
            adapterId: 'anthropic.messages.v1',
            authScheme: AiAuthScheme.apiKeyHeader,
            authParameterName: 'x-api-key',
          ),
          apiKey: 'secret',
        ),
      );

      expect(prepared.uri.path, '/v1/messages');
      expect(prepared.headers['x-api-key'], 'secret');
      expect(prepared.headers['anthropic-version'], '2023-06-01');
      expect(prepared.body['system'], 'be precise');
      expect(prepared.body['messages'], hasLength(1));
    });
  });
}

AiAdapterContext _adapterContext(String providerId, String adapterId) {
  return AiAdapterContext(
    provider: AiProviderDefinition(
      id: providerId,
      displayName: providerId,
      adapterId: adapterId,
    ),
    apiKey: 'secret',
  );
}

AiRequest _request({required String providerId, bool includeSystem = false}) {
  return AiRequest(
    requestId: 'request',
    connection: AiProviderConnection(
      id: 'connection',
      providerId: providerId,
      displayName: providerId,
      baseUri: Uri.parse('https://example.test/v1/'),
    ),
    model: const AiModelDefinition(
      id: 'model',
      connectionId: 'connection',
      displayName: 'Model',
      capabilities: AiModelCapabilities(streaming: true, toolCalling: true),
      limits: AiModelLimits(maxOutputTokens: 1024),
    ),
    messages: [
      if (includeSystem)
        AiMessage(
          id: 'system',
          conversationId: 'conversation',
          role: AiMessageRole.system,
          parts: [AiContentPart.text('be precise')],
          createdAt: _epoch,
        ),
      AiMessage(
        id: 'user',
        conversationId: 'conversation',
        role: AiMessageRole.user,
        parts: [AiContentPart.text('hello')],
        createdAt: _epoch,
      ),
    ],
  );
}

final _epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
