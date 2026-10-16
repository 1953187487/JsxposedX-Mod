import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/domain/events/ai_stream_event.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_chat_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/transport/sse_decoder.dart';

void main() {
  group('AiSseDecoder', () {
    test(
      'joins fields and survives arbitrary UTF-8 chunk boundaries',
      () async {
        final source = 'event: message\ndata: 你好\ndata: world\n\n';
        final bytes = utf8.encode(source);
        final chunks = <List<int>>[];
        for (var index = 0; index < bytes.length; index += 2) {
          chunks.add(bytes.sublist(index, (index + 2).clamp(0, bytes.length)));
        }

        final events = await const AiSseDecoder()
            .decode(Stream.fromIterable(chunks))
            .toList();

        expect(events, hasLength(1));
        expect(events.single.event, 'message');
        expect(events.single.data, '你好\nworld');
      },
    );

    test('rejects an oversized event', () async {
      expect(
        () => const AiSseDecoder(
          maxEventBytes: 4,
        ).decode(Stream.value(utf8.encode('data: 12345\n\n'))).toList(),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('OpenAiChatAdapter', () {
    const adapter = OpenAiChatAdapter();

    test('emits deltas before the stream completes', () async {
      final first = jsonEncode({
        'choices': [
          {
            'delta': {'role': 'assistant', 'content': '你'},
            'finish_reason': null,
          },
        ],
      });
      final second = jsonEncode({
        'choices': [
          {
            'delta': {'content': '好'},
            'finish_reason': null,
          },
        ],
      });
      final events = adapter
          .decodeStream(
            Stream.fromIterable([
              utf8.encode('data: $first\n\n'),
              utf8.encode('data: $second\n\n'),
              utf8.encode('data: [DONE]\n\n'),
            ]),
            requestId: 'r1',
          )
          .toList();

      final values = await events;
      expect(values.whereType<AiTextDelta>().map((event) => event.delta), [
        '你',
        '好',
      ]);
      expect(values.whereType<AiResponseCompleted>(), hasLength(1));
      expect(
        values.map((event) => event.sequence).toList(),
        orderedEquals([0, 1, 2, 3]),
      );
    });

    test('surfaces a gateway business-error envelope mid-stream', () async {
      // 复现网关在 HTTP 200 流内下发 {"code":30001,"message":...} 的场景：
      // 修复前该信封不被识别，delta 后流以 protocolTruncated 收尾且错误
      // 详情丢失；修复后应立刻产生携带网关错误信息的 failed 事件。
      final delta = jsonEncode({
        'choices': [
          {
            'delta': {'content': '部分回答'},
            'finish_reason': null,
          },
        ],
      });
      final envelope = jsonEncode({
        'code': 30001,
        'message': 'Sorry, your account balance is insufficient',
        'data': null,
      });

      final values = await adapter
          .decodeStream(
            Stream.fromIterable([
              utf8.encode('data: $delta\n\n'),
              utf8.encode('data: $envelope\n\n'),
            ]),
            requestId: 'r-envelope',
          )
          .toList();

      expect(
        values.whereType<AiTextDelta>().map((event) => event.delta).toList(),
        ['部分回答'],
      );
      final failure = values.whereType<AiResponseFailed>().single;
      expect(failure.failure.code, AiFailureCode.serverFailure);
      expect(failure.failure.messageKey, contains('account balance'));
    });

    test(
      'fails immediately on a business-error envelope without output',
      () async {
        final envelope = jsonEncode({
          'code': 30001,
          'message': 'Sorry, your account balance is insufficient',
          'data': null,
        });

        final values = await adapter
            .decodeStream(
              Stream.value(utf8.encode('data: $envelope\n\n')),
              requestId: 'r-envelope-empty',
            )
            .toList();

        // 空对话应直接以网关错误失败，而不是误报 protocolTruncated。
        expect(values, hasLength(1));
        final failure = values.whereType<AiResponseFailed>().single;
        expect(failure.failure.messageKey, contains('account balance'));
      },
    );

    test('keeps usage and tool call deltas typed', () async {
      final chunk = jsonEncode({
        'choices': [
          {
            'delta': {
              'tool_calls': [
                {
                  'index': 0,
                  'id': 'call-1',
                  'function': {'name': 'search', 'arguments': '{"q":"x"}'},
                },
              ],
            },
            'finish_reason': 'tool_calls',
          },
        ],
        'usage': {
          'prompt_tokens': 2,
          'completion_tokens': 3,
          'total_tokens': 5,
        },
      });

      final values = await adapter
          .decodeStream(
            Stream.value(utf8.encode('data: $chunk\n\ndata: [DONE]\n\n')),
            requestId: 'r2',
          )
          .toList();

      final tool = values.whereType<AiToolCallDelta>().single;
      expect(tool.index, 0);
      expect(tool.toolCallId, 'call-1');
      expect(values.whereType<AiUsageUpdated>().single.value.totalTokens, 5);
      expect(
        values.whereType<AiResponseCompleted>().single.reason,
        AiFinishReason.toolCall,
      );
    });

    test(
      'groups parallel tool call fragments by id when index is missing',
      () async {
        // 复现网关省略 index 字段时的并行工具调用：若不按 id 归组，
        // 两个工具的 arguments 分片会拼进同一缓冲区导致 JSON 错乱。
        String chunk(Object? id, String name, String arguments) => jsonEncode({
          'choices': [
            {
              'delta': {
                'tool_calls': [
                  {
                    'id': id,
                    'function': {'name': name, 'arguments': arguments},
                  },
                ],
              },
              'finish_reason': null,
            },
          ],
        });

        final values = await adapter
            .decodeStream(
              Stream.fromIterable([
                utf8.encode(
                  'data: ${chunk('call-a', 'search_classes', '{"q"')}\n\n',
                ),
                utf8.encode(
                  'data: ${chunk('call-b', 'get_manifest', '{"k"')}\n\n',
                ),
                utf8.encode('data: ${chunk('call-a', '', ': 1}')}\n\n'),
                utf8.encode('data: ${chunk('call-b', '', ': 2}')}\n\n'),
                utf8.encode('data: ${chunk(null, '', '')}\n\n'),
                utf8.encode('data: [DONE]\n\n'),
              ]),
              requestId: 'r-parallel',
            )
            .toList();

        final deltas = values.whereType<AiToolCallDelta>().toList();
        // call-a 的所有分片归到同一 index，call-b 归到另一 index，
        // 两个工具的参数互不混拼。
        expect(deltas.map((event) => event.index).toList(), [0, 1, 0, 1, 0]);
        expect(deltas[0].toolCallId, 'call-a');
        expect(deltas[2].index, deltas[0].index);
        expect(deltas[3].index, deltas[1].index);
        expect(deltas[4].toolCallId, isNull);
      },
    );

    test(
      'prepares an OpenAI request using resolved secret and explicit endpoint',
      () {
        final connection = AiProviderConnection(
          id: 'c1',
          providerId: 'openai',
          displayName: 'Test',
          baseUri: Uri.parse('https://example.test/v1/'),
          endpointOverrides: {
            AiEndpointKind.chatCompletions: Uri.parse(
              'https://proxy.test/custom/chat',
            ),
          },
        );
        final request = AiRequest(
          requestId: 'r3',
          connection: connection,
          model: AiModelDefinition(
            id: 'model-1',
            connectionId: 'c1',
            displayName: 'Model',
            capabilities: const AiModelCapabilities(streaming: true),
            limits: const AiModelLimits(),
          ),
          messages: [
            AiMessage(
              id: 'm1',
              conversationId: 'conversation-1',
              role: AiMessageRole.user,
              parts: [AiContentPart.text('hello')],
              createdAt: _epoch,
            ),
          ],
        );

        final prepared = adapter.prepare(
          request,
          context: const AiAdapterContext(
            provider: AiProviderDefinition(
              id: 'openai',
              displayName: 'OpenAI',
              adapterId: 'openai.chat.v1',
            ),
            apiKey: 'secret',
          ),
        );
        expect(prepared.uri.toString(), 'https://proxy.test/custom/chat');
        expect(prepared.headers['Authorization'], 'Bearer secret');
        expect(prepared.body['model'], 'model-1');
        expect(prepared.body['messages'], isA<List<Object?>>());
      },
    );

    test('never sends reasoning_content back in request messages', () {
      // SiliconFlow 等网关托管 DeepSeek/Qwen 推理模型时，会拒绝请求
      // messages 中携带 reasoning_content 字段的请求（HTTP 400，错误码
      // 20015 "messages in request are illegal"）。历史思考内容只用于
      // 本地展示，序列化请求时必须丢弃。
      final request = AiRequest(
        requestId: 'r-reasoning',
        connection: AiProviderConnection(
          id: 'c1',
          providerId: 'openai',
          displayName: 'Test',
          baseUri: Uri.parse('https://example.test/v1/'),
        ),
        model: AiModelDefinition(
          id: 'model-1',
          connectionId: 'c1',
          displayName: 'Model',
          capabilities: const AiModelCapabilities(streaming: true),
          limits: const AiModelLimits(),
        ),
        messages: [
          AiMessage(
            id: 'm-reasoning',
            conversationId: 'conversation-1',
            role: AiMessageRole.assistant,
            parts: const [
              AiContentPart.reasoning('先思考一下'),
              AiContentPart.text('这是正文回答'),
            ],
            createdAt: _epoch,
          ),
          AiMessage(
            id: 'm-reasoning-only',
            conversationId: 'conversation-1',
            role: AiMessageRole.assistant,
            parts: const [AiContentPart.reasoning('纯思考没有正文')],
            createdAt: _epoch,
          ),
        ],
      );

      final prepared = adapter.prepare(
        request,
        context: const AiAdapterContext(
          provider: AiProviderDefinition(
            id: 'openai',
            displayName: 'OpenAI',
            adapterId: 'openai.chat.v1',
          ),
          apiKey: 'secret',
        ),
      );

      final messages = (prepared.body['messages'] as List<Object?>)
          .cast<Map<String, Object?>>();
      for (final message in messages) {
        expect(
          message.containsKey('reasoning_content'),
          isFalse,
          reason: '请求消息不得携带 reasoning_content 字段',
        );
      }
      expect(messages.first['content'], '这是正文回答');
      // 纯思考无正文的消息对上下文没有贡献，整条丢弃而非回传空壳。
      expect(messages, hasLength(1));
    });

    test('drops unpaired tool fragments that providers reject', () {
      // 旧会话可能残留结构异常消息：孤儿 tool_call（结果丢失）、id 为空的
      // tool_call（流中断残留）、孤立 tool 结果（前置调用丢失）。OpenAI 兼容
      // 网关会拒绝整个请求而非忽略异常条目，必须请求侧丢弃。
      final request = AiRequest(
        requestId: 'r-sanitize',
        connection: AiProviderConnection(
          id: 'c1',
          providerId: 'openai',
          displayName: 'Test',
          baseUri: Uri.parse('https://example.test/v1/'),
        ),
        model: AiModelDefinition(
          id: 'model-1',
          connectionId: 'c1',
          displayName: 'Model',
          capabilities: const AiModelCapabilities(streaming: true),
          limits: const AiModelLimits(),
        ),
        messages: [
          // 正常配对：assistant tool_call + tool 结果。
          AiMessage(
            id: 'm-call-1',
            conversationId: 'conversation-1',
            role: AiMessageRole.assistant,
            parts: const [
              AiContentPart.toolCall(
                toolCall: AiToolCall(
                  id: 'call-1',
                  name: 'shell_exec',
                  arguments: {'command': 'ls'},
                ),
              ),
            ],
            createdAt: _epoch,
          ),
          AiMessage(
            id: 'm-result-1',
            conversationId: 'conversation-1',
            role: AiMessageRole.tool,
            parts: const [
              AiContentPart.toolResult(
                toolResult: AiToolResult(
                  toolCallId: 'call-1',
                  name: 'shell_exec',
                  success: true,
                  content: 'file-a\nfile-b',
                ),
              ),
            ],
            createdAt: _epoch,
          ),
          // 孤儿 tool_call：没有任何对应结果。
          AiMessage(
            id: 'm-call-orphan',
            conversationId: 'conversation-1',
            role: AiMessageRole.assistant,
            parts: const [
              AiContentPart.toolCall(
                toolCall: AiToolCall(
                  id: 'call-orphan',
                  name: 'shell_exec',
                  arguments: {'command': 'pwd'},
                ),
              ),
            ],
            createdAt: _epoch,
          ),
          // 孤立 tool 结果：没有前置 tool_call，且 id 为空。
          AiMessage(
            id: 'm-result-orphan',
            conversationId: 'conversation-1',
            role: AiMessageRole.tool,
            parts: const [
              AiContentPart.toolResult(
                toolResult: AiToolResult(
                  toolCallId: '',
                  name: 'shell_exec',
                  success: true,
                  content: 'orphan',
                ),
              ),
            ],
            createdAt: _epoch,
          ),
          // 正常用户消息，验证净化后请求仍可用。
          AiMessage(
            id: 'm-user-1',
            conversationId: 'conversation-1',
            role: AiMessageRole.user,
            parts: const [AiContentPart.text('继续')],
            createdAt: _epoch,
          ),
        ],
      );

      final prepared = adapter.prepare(
        request,
        context: const AiAdapterContext(
          provider: AiProviderDefinition(
            id: 'openai',
            displayName: 'OpenAI',
            adapterId: 'openai.chat.v1',
          ),
          apiKey: 'secret',
        ),
      );

      final messages = (prepared.body['messages'] as List<Object?>)
          .cast<Map<String, Object?>>();
      expect(messages, hasLength(3));
      expect(messages[0]['role'], 'assistant');
      expect(messages[0]['tool_calls'], hasLength(1));
      expect(
        (messages[0]['tool_calls'] as List<Object?>)
            .cast<Map<String, Object?>>()
            .first['id'],
        'call-1',
      );
      expect(messages[1]['role'], 'tool');
      expect(messages[1]['tool_call_id'], 'call-1');
      expect(messages[2]['role'], 'user');
      expect(messages[2]['content'], '继续');
    });
  });
}

final _epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
