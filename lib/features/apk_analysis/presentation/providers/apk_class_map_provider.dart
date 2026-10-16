import 'dart:convert';

import 'package:JsxposedX/core/models/ai_message.dart';
import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/apk_analysis/presentation/providers/apk_analysis_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'apk_class_map_provider.g.dart';

const _kMapSpace = 'dex_map';

String _cacheKey(String packageName, String className) =>
    'dex_map_${packageName}_$className';

class FlowNode {
  final String id;
  final String label;
  final String type;

  const FlowNode({
    required this.id,
    required this.label,
    this.type = 'default',
  });

  factory FlowNode.fromJson(Map<String, dynamic> j) => FlowNode(
    id: j['id']?.toString() ?? '',
    label: j['label']?.toString() ?? '',
    type: j['type']?.toString() ?? 'default',
  );

  Map<String, dynamic> toJson() => {'id': id, 'label': label, 'type': type};
}

class FlowEdge {
  final String from;
  final String to;
  final String label;

  const FlowEdge({required this.from, required this.to, this.label = ''});

  factory FlowEdge.fromJson(Map<String, dynamic> j) => FlowEdge(
    from: j['from']?.toString() ?? '',
    to: j['to']?.toString() ?? '',
    label: j['label']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {'from': from, 'to': to, 'label': label};
}

class ClassFlowData {
  final String className;
  final List<FlowNode> nodes;
  final List<FlowEdge> edges;
  final String? rawError;

  const ClassFlowData({
    required this.className,
    this.nodes = const [],
    this.edges = const [],
    this.rawError,
  });

  factory ClassFlowData.fromJson(
    Map<String, dynamic> json,
    String fallbackName,
  ) => ClassFlowData(
    className: json['className']?.toString() ?? fallbackName,
    nodes:
        (json['nodes'] as List?)
            ?.map((e) => FlowNode.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    edges:
        (json['edges'] as List?)
            ?.map((e) => FlowEdge.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  factory ClassFlowData.error(String className, String error) =>
      ClassFlowData(className: className, rawError: error);

  Map<String, dynamic> toJson() => {
    'className': className,
    'nodes': nodes.map((e) => e.toJson()).toList(),
    'edges': edges.map((e) => e.toJson()).toList(),
  };
}

@riverpod
Future<ClassFlowData> apkClassMap(
  Ref ref, {
  required String sessionId,
  required List<String> dexPaths,
  required String className,
  required String packageName,
}) async {
  final storage = ref.read(piniaStorageLocalProvider);
  final key = _cacheKey(packageName, className);

  final cached = await storage.getString(key, space: _kMapSpace);
  if (cached.isNotEmpty) {
    try {
      final decoded = jsonDecode(cached) as Map<String, dynamic>;
      return ClassFlowData.fromJson(decoded, className);
    } catch (_) {}
  }

  final config = await ref.watch(aiConfigProvider.future);
  if (config.apiUrl.isEmpty) {
    return ClassFlowData.error(className, 'AI not configured');
  }

  String code;
  try {
    code = await ref.watch(
      decompileClassProvider(
        sessionId: sessionId,
        dexPaths: dexPaths,
        className: className,
      ).future,
    );
  } catch (_) {
    try {
      code = await ref.watch(
        getClassSmaliProvider(
          sessionId: sessionId,
          dexPaths: dexPaths,
          className: className,
        ).future,
      );
    } catch (e) {
      return ClassFlowData.error(className, e.toString());
    }
  }

  const systemPrompt =
      'You are a code flow analyzer. Reply ONLY with valid JSON, no markdown fences.';
  const userPromptPrefix =
      'Analyze this Android class and produce a flowchart JSON with nodes and edges.\n'
      'Focus on: class hierarchy (extends/implements), key method call flow, important conditions.\n'
      'Schema:\n'
      '{\n'
      '  "className": "...",\n'
      '  "nodes": [{"id": "n1", "label": "ClassName", "type": "class|method|condition|start|end"}],\n'
      '  "edges": [{"from": "n1", "to": "n2", "label": "calls|extends|implements|"}]\n'
      '}\n'
      'Keep nodes <= 20, be concise. Code:\n';

  final truncatedCode = code.length > 5000
      ? '${code.substring(0, 5000)}...'
      : code;

  final messages = [
    AiMessage(id: const Uuid().v4(), role: 'system', content: systemPrompt),
    AiMessage(
      id: const Uuid().v4(),
      role: 'user',
      content: '$userPromptPrefix$truncatedCode',
    ),
  ];

  final stream = ref
      .read(aiChatRuntimeQueryProvider)
      .stream(config: config, messages: messages);

  final buffer = StringBuffer();
  await for (final chunk in stream) {
    buffer.write(chunk.content);
  }

  final raw = buffer.toString().trim();
  try {
    final start = raw.indexOf('{');
    final end = raw.lastIndexOf('}');
    final jsonStr = (start != -1 && end > start)
        ? raw.substring(start, end + 1)
        : raw;
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    final result = ClassFlowData.fromJson(decoded, className);
    await storage.setString(
      key,
      jsonEncode(result.toJson()),
      space: _kMapSpace,
    );
    return result;
  } catch (e) {
    return ClassFlowData.error(className, 'Parse error: $e\n\nRaw: $raw');
  }
}
