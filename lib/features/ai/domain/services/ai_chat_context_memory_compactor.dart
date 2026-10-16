import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

/// 上下文记忆压缩器：对被裁剪出请求窗口的历史轮次生成机械摘要，
/// 以 `[context_memory]` 系统消息的形式注入请求，保证模型始终能
/// 看到"哪些目标已经分析过、结论是什么"，避免重复分析。
///
/// 只做可溯源的机械提取（工具调用名 + 参数 + 结果截断），不调用
/// LLM、不生成猜测内容：每条记录都能对应到一条真实历史消息。
class AiChatContextMemoryCompactor {
  const AiChatContextMemoryCompactor({
    // 记忆预算自适应设计（2026 业界实践）：
    // 
    // 【核心原则】
    // 记忆预算 = min(上下文总量 × 3%, 16384)
    // - 3% 对齐 LangChain/AFM 论文推荐值
    // - 16K 上限防止超大上下文时记忆膨胀（成本 + Lost in the Middle）
    // 
    // 【分层保障】
    // 128K 上下文：3840 tokens  → 满足 ~25 工具调用
    // 400K 上下文：12000 tokens → 满足 ~75 工具调用
    // 1M 上下文：  16384 tokens → 满足 100+ 工具调用（触顶）
    // 2M 上下文：  16384 tokens → 仍为 16K（防止记忆膨胀）
    // 
    // 【弃用固定 8K 的原因】
    // - 对 128K 上下文模型过大（8K > 3840），浪费成本
    // - 对 1M+ 上下文模型过小（8K < 30K），长会话降智
    // - 现代模型上下文跨度 128K-2M，固定值无法适配
    // 
    // 【实际计算】
    // 由 AiChatContextBuilder 根据 model.limits.contextTokens 动态计算
    // 并覆盖此处的 maxMemoryTokens 默认值
    this.maxToolCallEntries = kMaxMaxToolRounds,
    this.maxToolFindingEntries = 15,
    this.maxGoalEntries = 8,
    this.maxConclusionEntries = 12,
    this.maxEntryCharacters = 800,
    this.maxMemoryTokens = 4096, // 仅作回退值，实际由 Builder 计算
  });

  static const String memoryHeader = '[context_memory]';

  final int maxToolCallEntries;
  final int maxToolFindingEntries;
  final int maxGoalEntries;
  final int maxConclusionEntries;
  final int maxEntryCharacters;

  /// 记忆消息自身的 token 上限：记忆是补偿层，绝不允许反过来挤爆
  /// 请求预算。超限时按"结论 → 工具发现 → 用户目标 → 工具调用记录"
  /// 的顺序逐条降级，工具调用记录（含类名）最后丢——它是防止重复
  /// 分析的关键。
  final int maxMemoryTokens;

  /// [droppedMessages] 是被裁剪出窗口的历史（时间顺序）；
  /// [persistedMemory] 是持久化快照中的跨窗口记忆条目（例如会话
  /// 重启后分页加载窗口之外的历史摘要），与派生条目合并去重。
  AiChatContextCompaction compact({
    required List<AiMessage> droppedMessages,
    required String conversationId,
    required String Function() idFactory,
    required DateTime now,
    List<String> persistedMemory = const [],
  }) {
    final collector = _MemoryCollector();
    for (final message in droppedMessages) {
      _ingest(collector, message);
    }
    // 持久化条目兜底：dropped 覆盖不到的跨窗口历史（去重后追加）。
    for (final entry in persistedMemory) {
      _addUnique(collector.toolCalls, _truncate(entry));
    }

    final rendered = _render(collector);
    if (rendered == null) {
      return const AiChatContextCompaction();
    }
    return AiChatContextCompaction(
      message: AiMessage(
        id: idFactory(),
        conversationId: conversationId,
        role: AiMessageRole.system,
        parts: [AiContentPart.text(rendered.content)],
        createdAt: now,
      ),
      entries: rendered.entries,
    );
  }

  void _ingest(_MemoryCollector collector, AiMessage message) {
    switch (message.role) {
      case AiMessageRole.user:
        final text = _textOf(message);
        if (text.isNotEmpty) {
          _addUnique(collector.goals, _truncate(text));
        }
      case AiMessageRole.assistant:
        for (final part in message.parts.whereType<AiToolCallPart>()) {
          _addUnique(collector.toolCalls, _toolCallEntry(part.toolCall));
        }
        final text = _textOf(message);
        if (text.isNotEmpty) {
          _addUnique(collector.conclusions, _truncate(text));
        }
      case AiMessageRole.tool:
        for (final part in message.parts.whereType<AiToolResultPart>()) {
          _addUnique(
            collector.toolFindings,
            _truncate('${part.toolResult.name}: ${part.toolResult.content}'),
          );
        }
      case AiMessageRole.system:
        break;
    }
  }

  /// 工具调用记录是防重复分析的核心：保留调用名与全部标量参数
  /// （类名、方法名、关键字都在参数里），一并记录在调用条目中。
  String _toolCallEntry(AiToolCall toolCall) {
    final arguments = toolCall.arguments.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${_argumentValue(entry.value)}')
        .join(', ');
    return arguments.isEmpty
        ? '${toolCall.name}()'
        : '${toolCall.name}($arguments)';
  }

  String _argumentValue(Object? value) => value.toString();

  _RenderedMemory? _render(_MemoryCollector collector) {
    if (!collector.hasContent) return null;

    var goalCount = collector.goals.length.clamp(0, maxGoalEntries);
    var conclusionCount = collector.conclusions.length.clamp(
      0,
      maxConclusionEntries,
    );
    var findingCount = collector.toolFindings.length.clamp(
      0,
      maxToolFindingEntries,
    );
    var toolCallCount = collector.toolCalls.length.clamp(0, maxToolCallEntries);

    String render() {
      final buffer = StringBuffer(memoryHeader);
      buffer
        ..writeln()
        ..writeln(
          '以下为已从请求窗口裁剪的历史摘要。这些目标已经分析过，'
          '除非结果缺失或有明确新指令，请勿重复分析：',
        );
      _writeSection(
        buffer,
        '已完成的分析调用（勿重复）',
        collector.toolCalls.take(toolCallCount),
      );
      _writeSection(
        buffer,
        '历史分析发现',
        collector.toolFindings.take(findingCount),
      );
      _writeSection(
        buffer,
        '已确认结论',
        collector.conclusions.take(conclusionCount),
      );
      _writeSection(buffer, '用户目标', collector.goals.take(goalCount));
      return buffer.toString();
    }

    var content = render();
    while (_estimateTokens(content) > maxMemoryTokens) {
      var degraded = false;
      if (conclusionCount > 0) {
        conclusionCount--;
        degraded = true;
      } else if (findingCount > 0) {
        findingCount--;
        degraded = true;
      } else if (goalCount > 0) {
        goalCount--;
        degraded = true;
      } else if (toolCallCount > 0) {
        toolCallCount--;
        degraded = true;
      }
      if (!degraded) return null;
      content = render();
    }
    if (toolCallCount == 0 &&
        conclusionCount == 0 &&
        findingCount == 0 &&
        goalCount == 0) {
      return null;
    }
    // entries 只保留降级后最终存活的条目，与渲染内容严格一致，
    // 供持久化快照跨窗口去重合并。
    final entries = [
      ...collector.toolCalls.take(toolCallCount),
      ...collector.toolFindings.take(findingCount),
      ...collector.conclusions.take(conclusionCount),
      ...collector.goals.take(goalCount),
    ];
    return _RenderedMemory(content, entries);
  }

  /// 与 ConservativeAiTokenEstimator 的文本路径保持一致量级：
  /// 12 + 字符数 / 3。只用于记忆消息自身的软上限控制。
  static int _estimateTokens(String content) =>
      12 + (content.length / 3).ceil();

  void _writeSection(
    StringBuffer buffer,
    String title,
    Iterable<String> items,
  ) {
    final normalized = items
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    if (normalized.isEmpty) return;
    buffer
      ..writeln()
      ..writeln('$title：');
    for (final item in normalized) {
      buffer.writeln('- $item');
    }
  }

  static String _textOf(AiMessage message) {
    return message.parts
        .whereType<AiTextPart>()
        .map((part) => part.text)
        .join(' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _truncate(String text) {
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= maxEntryCharacters) return normalized;
    return '${normalized.substring(0, maxEntryCharacters)}…';
  }

  void _addUnique(List<String> items, String value) {
    if (value.isEmpty || items.contains(value)) return;
    items.add(value);
  }
}

/// 压缩结果：注入请求的记忆消息 + 可持久化的记忆条目。
///
/// [message] 为 null 时表示被裁剪的历史无可记忆内容；[entries] 是
/// 降级后最终存活的记忆条目（含防重复分析的工具调用记录），由
/// SessionController 持久化到会话上下文快照，实现跨重启合并。
class AiChatContextCompaction {
  const AiChatContextCompaction({this.message, this.entries = const []});

  /// 注入请求的 `[context_memory]` 系统消息；无可记忆内容时为 null。
  final AiMessage? message;

  /// 最终保留的记忆条目（去重后），供持久化快照跨窗口合并。
  final List<String> entries;

  bool get isEmpty => message == null && entries.isEmpty;
}

class _MemoryCollector {
  final List<String> goals = [];
  final List<String> toolCalls = [];
  final List<String> toolFindings = [];
  final List<String> conclusions = [];

  bool get hasContent =>
      goals.isNotEmpty ||
      toolCalls.isNotEmpty ||
      toolFindings.isNotEmpty ||
      conclusions.isNotEmpty;
}

class _RenderedMemory {
  const _RenderedMemory(this.content, this.entries);

  final String content;
  final List<String> entries;
}
