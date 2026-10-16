import 'package:JsxposedX/features/ai/domain/models/ai_chat_session_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_chat_context_memory_compactor.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_multimodal_message_codec.dart';

abstract interface class AiTokenEstimator {
  int estimate(AiMessage message);
}

class ConservativeAiTokenEstimator implements AiTokenEstimator {
  const ConservativeAiTokenEstimator();

  @override
  int estimate(AiMessage message) {
    var characters = 0;
    for (final part in message.parts) {
      characters += switch (part) {
        AiTextPart(:final text) => _textCost(text),
        AiReasoningPart(:final text) => text.length,
        AiImagePart() => 1024,
        AiToolCallPart(:final toolCall) =>
          toolCall.name.length + toolCall.arguments.toString().length,
        AiToolResultPart(:final toolResult) =>
          toolResult.name.length + toolResult.content.length,
      };
    }
    return 12 + (characters / 3).ceil();
  }

  static int _textCost(String text) {
    final parsed = AiMultimodalMessageCodec.parse(text);
    if (parsed == null) return text.length;
    // Base64 image data is transport bytes, not proportional text tokens.
    // Count a bounded image placeholder plus the editable caption instead.
    final imageCost = parsed.attachments
        .where((attachment) => attachment.isImage)
        .fold<int>(0, (total, _) => total + 1024);
    return parsed.text.length + imageCost;
  }
}

/// 上下文组装结果：既包含最终下发给模型的消息，也包含本次组装的真实
/// 统计信息（token 预算、裁剪情况、保留轮次、参与层），供控制台可视化。
class AiChatContextBuildResult {
  const AiChatContextBuildResult({
    required this.messages,
    required this.stats,
    required this.systemPrompt,
    this.memoryEntries = const [],
  });

  final List<AiMessage> messages;
  final AiChatContextStats stats;

  /// 本次实际拼接下发的系统提示（环境约束 + 助手人设），
  /// 供对话级上下文快照记录会话规则。
  final String systemPrompt;

  /// 本次注入 [context_memory] 后最终存活的记忆条目（含被裁历史的
  /// 工具调用记录），供调用方持久化，实现跨重启的记忆合并。
  final List<String> memoryEntries;
}

class AiChatContextBuilder {
  // Input tokens also include serialized tool schemas, protocol wrappers and
  // provider metadata. Keep this headroom outside the message estimator.
  static const int _protocolOverheadTokens = 2048;

  /// 高水位线：历史全量 token 占模型上下文的比例达到该值即触发
  /// 预防性软压缩（提前裁剪 + 记忆补偿），避免贴线溢出被 provider 拒绝。
  static const double _highWatermarkRatio = 0.95;

  /// 记忆消息的预算余量：协议开销 2048 是保守估计，[context_memory]
  /// 记忆消息作为请求构造的一部分从该余量中支出（上限 512），只有
  /// 超出余量的部分才挤占历史消息预算。记忆补偿绝不能反而把最近
  /// 轮次挤出窗口——那是本次修复要消灭的行为。
  static const int _memoryAllowanceTokens = 512;

  const AiChatContextBuilder({
    AiTokenEstimator tokenEstimator = const ConservativeAiTokenEstimator(),
    AiChatContextMemoryCompactor memoryCompactor =
        const AiChatContextMemoryCompactor(),
  }) : _tokenEstimator = tokenEstimator,
       _memoryCompactor = memoryCompactor;

  final AiTokenEstimator _tokenEstimator;
  final AiChatContextMemoryCompactor _memoryCompactor;

  List<AiMessage> build({
    required AiAssistantProfile assistant,
    required AiModelDefinition model,
    required List<AiMessage> messages,
    required String Function() idFactory,
    required DateTime now,
    String? environmentSystemPrompt,
  }) {
    return buildWithStats(
      assistant: assistant,
      model: model,
      messages: messages,
      idFactory: idFactory,
      now: now,
      environmentSystemPrompt: environmentSystemPrompt,
    ).messages;
  }

  AiChatContextBuildResult buildWithStats({
    required AiAssistantProfile assistant,
    required AiModelDefinition model,
    required List<AiMessage> messages,
    required String Function() idFactory,
    required DateTime now,
    String? environmentSystemPrompt,
    List<String> persistedMemory = const [],
  }) {
    final completedMessages = messages
        .where((message) => message.status == AiMessageStatus.completed)
        .toList(growable: false);
    // Tool results are part of the Responses protocol state. They cannot be
    // treated as optional context: removing them leaves function calls without
    // outputs and the provider rejects the next request.
    final eligible = completedMessages
        .where((message) => message.parts.isNotEmpty)
        .toList(growable: false);

    final profilePrompt = assistant.systemPrompt?.trim();
    final environmentPrompt = environmentSystemPrompt?.trim();
    final systemPrompt = [
      if (environmentPrompt != null && environmentPrompt.isNotEmpty)
        environmentPrompt,
      if (profilePrompt != null && profilePrompt.isNotEmpty) profilePrompt,
    ].join('\n\n');
    final conversationId = messages.firstOrNull?.conversationId ?? '';
    final systemPromptTokens = systemPrompt.isEmpty
        ? 0
        : _tokenEstimator.estimate(
            AiMessage(
              id: 'system-budget',
              conversationId: conversationId,
              role: AiMessageRole.system,
              parts: [AiContentPart.text(systemPrompt)],
              createdAt: now,
            ),
          );
    // 上下文预算优先使用模型元数据。如果服务器未返回，回退到用户配置的
    // fallbackContextTokens（默认 128K），确保会话能够正常初始化。
    var contextTokens = model.limits.contextTokens;
    if (contextTokens == null || contextTokens <= 0) {
      contextTokens = resolveFallbackContextTokens(
        assistant.contextPolicy.fallbackContextTokens,
      );
    }

    // 高水位监控：历史全量（含系统提示）占模型上下文的比例触达阈值
    // 时，把消息预算收紧到水位线以内，提前触发"裁剪 + 记忆压缩"，
    // 而不是等到硬预算贴线才被动动作。
    var eligibleTotalTokens = systemPromptTokens;
    for (final message in eligible) {
      eligibleTotalTokens += _tokenEstimator.estimate(message);
    }
    final highWatermark =
        contextTokens > 0 &&
        eligibleTotalTokens / contextTokens >= _highWatermarkRatio;
    final budgetScale = highWatermark ? _highWatermarkRatio : 1.0;

    final selected = switch (assistant.contextPolicy.mode) {
      AiContextMode.fullHistory => eligible,
      AiContextMode.recentMessages => _recentMessages(
        eligible,
        assistant.contextPolicy.recentMessageLimit,
      ),
      AiContextMode.tokenBudget => _withinTokenBudget(
        eligible,
        assistant.contextPolicy,
        contextTokens,
        systemPromptTokens: systemPromptTokens,
        budgetScale: budgetScale,
      ),
    };

    final boundedSelected =
        assistant.contextPolicy.mode == AiContextMode.tokenBudget
        ? selected
        : _withinTokenBudget(
            selected,
            assistant.contextPolicy,
            contextTokens,
            systemPromptTokens: systemPromptTokens,
            budgetScale: budgetScale,
          );
    // 修复工具调用配对可能重新带回被预算截断的历史消息；修复后必须
    // 再次执行预算裁剪，避免“配对合法但请求超出上下文上限”。
    final pairedSelected = _repairToolCallPairs(boundedSelected, eligible);
    var protocolSafeSelected = _withinTokenBudget(
      pairedSelected,
      assistant.contextPolicy,
      contextTokens,
      systemPromptTokens: systemPromptTokens,
      budgetScale: budgetScale,
    );

    // 记忆补偿：所有被裁出请求窗口的历史（无论预算、条数还是配对
    // 修复导致）都不再静默丢弃，而是压缩为 [context_memory] 机械
    // 摘要注入请求，保证模型始终知道"哪些目标已分析过、结论是什么"。
    var compaction = _compactMemory(
      eligible: eligible,
      selected: protocolSafeSelected,
      conversationId: conversationId,
      idFactory: idFactory,
      now: now,
      persistedMemory: persistedMemory,
    );
    // 记忆消息先从协议开销余量中支出（上限 512）；仅当超出余量、
    // 注入后绝对超出模型上下文时，才为溢出部分重新裁剪窗口。记忆
    // 有 maxMemoryTokens 硬上限，两轮内收敛，不发散。
    if (compaction.message != null) {
      for (var attempt = 0; attempt < 2; attempt++) {
        final memoryTokens = _tokenEstimator.estimate(compaction.message!);
        var selectedTokens = 0;
        for (final message in protocolSafeSelected) {
          selectedTokens += _tokenEstimator.estimate(message);
        }
        final memoryExcess = (memoryTokens - _memoryAllowanceTokens).clamp(
          0,
          memoryTokens,
        );
        final totalTokens =
            systemPromptTokens +
            selectedTokens +
            memoryExcess +
            assistant.contextPolicy.reservedOutputTokens +
            _protocolOverheadTokens;
        if (totalTokens <= contextTokens) break;
        final reSelected = _withinTokenBudget(
          protocolSafeSelected,
          assistant.contextPolicy,
          contextTokens,
          systemPromptTokens: systemPromptTokens,
          budgetScale: budgetScale,
          memoryTokens: memoryTokens,
        );
        if (_sameShape(reSelected, protocolSafeSelected)) break;
        protocolSafeSelected = reSelected;
        compaction = _compactMemory(
          eligible: eligible,
          selected: protocolSafeSelected,
          conversationId: conversationId,
          idFactory: idFactory,
          now: now,
          persistedMemory: persistedMemory,
        );
        if (compaction.message == null) break;
      }
    }

    final memoryMessage = compaction.message;
    final messageRole = model.capabilities.systemRole
        ? AiMessageRole.system
        : AiMessageRole.user;
    final headMessages = [
      if (systemPrompt.isNotEmpty)
        AiMessage(
          id: idFactory(),
          conversationId: conversationId,
          role: messageRole,
          parts: [AiContentPart.text(systemPrompt)],
          createdAt: now,
        ),
      if (memoryMessage != null) memoryMessage,
    ];
    return AiChatContextBuildResult(
      messages: [...headMessages, ...protocolSafeSelected],
      systemPrompt: systemPrompt,
      memoryEntries: compaction.entries,
      stats: _buildStats(
        mode: assistant.contextPolicy.mode,
        eligible: eligible,
        selected: protocolSafeSelected,
        systemPrompt: systemPrompt,
        systemPromptTokens: systemPromptTokens,
        memoryMessage: memoryMessage,
        memoryEntryCount: compaction.entries.length,
        contextTokens: contextTokens,
        highWatermark: highWatermark,
        repairedToolContext: !_sameShape(boundedSelected, pairedSelected),
      ),
    );
  }

  AiChatContextCompaction _compactMemory({
    required List<AiMessage> eligible,
    required List<AiMessage> selected,
    required String conversationId,
    required String Function() idFactory,
    required DateTime now,
    required List<String> persistedMemory,
  }) {
    final selectedIds = selected.map((message) => message.id).toSet();
    final dropped = eligible
        .where((message) => !selectedIds.contains(message.id))
        .toList(growable: false);
    return _memoryCompactor.compact(
      droppedMessages: dropped,
      conversationId: conversationId,
      idFactory: idFactory,
      now: now,
      persistedMemory: persistedMemory,
    );
  }

  AiChatContextStats _buildStats({
    required AiContextMode mode,
    required List<AiMessage> eligible,
    required List<AiMessage> selected,
    required String systemPrompt,
    required int systemPromptTokens,
    required AiMessage? memoryMessage,
    required int memoryEntryCount,
    required int contextTokens,
    required bool highWatermark,
    required bool repairedToolContext,
  }) {
    var estimatedTokens = systemPromptTokens;
    for (final message in selected) {
      estimatedTokens += _tokenEstimator.estimate(message);
    }
    // 记忆消息同样计入请求 token：监控口径必须覆盖全部请求内容。
    final memoryTokens = memoryMessage == null
        ? 0
        : _tokenEstimator.estimate(memoryMessage);
    estimatedTokens += memoryTokens;
    final didCompact = selected.length < eligible.length;
    final usageRatio = contextTokens > 0
        ? (estimatedTokens / contextTokens).clamp(0.0, 1.0)
        : 0.0;
    return AiChatContextStats(
      tokenBudget: contextTokens,
      estimatedTokens: estimatedTokens,
      remainingTokens: (contextTokens - estimatedTokens).clamp(
        0,
        contextTokens,
      ),
      usageRatio: usageRatio,
      highWatermarkReached: highWatermark,
      didCompact: didCompact,
      compactReason: didCompact
          ? mode == AiContextMode.tokenBudget
                ? 'budget'
                : highWatermark
                ? 'watermark'
                : null
          : null,
      repairedToolContext: repairedToolContext,
      recentRoundsKept: selected
          .where((message) => message.role == AiMessageRole.user)
          .length,
      memoryEntryCount: memoryEntryCount,
      includedLayers: [
        if (systemPrompt.isNotEmpty) 'system_prompt',
        if (memoryMessage != null) 'context_memory',
        switch (mode) {
          AiContextMode.fullHistory => 'full_history',
          AiContextMode.recentMessages => 'recent_messages',
          AiContextMode.tokenBudget => 'token_budget',
        },
        if (selected.any(
          (message) => message.parts.any(
            (part) => part is AiToolCallPart || part is AiToolResultPart,
          ),
        ))
          'tool_context',
      ],
    );
  }

  static bool _sameShape(List<AiMessage> left, List<AiMessage> right) {
    if (left.length != right.length) return false;
    for (var index = 0; index < left.length; index++) {
      if (left[index].id != right[index].id ||
          left[index].parts.length != right[index].parts.length) {
        return false;
      }
    }
    return true;
  }

  /// Responses requires every function_call_output to have its preceding
  /// function_call in the same input history. Context trimming is allowed to
  /// remove old turns, but never one half of a tool exchange.
  static List<AiMessage> _repairToolCallPairs(
    List<AiMessage> selected,
    List<AiMessage> source,
  ) {
    final callIds = {
      for (final message in source)
        for (final part in message.parts.whereType<AiToolCallPart>())
          part.toolCall.id,
    };
    final resultIds = {
      for (final message in source)
        for (final part in message.parts.whereType<AiToolResultPart>())
          part.toolResult.toolCallId,
    };
    final pairedIds = callIds.intersection(resultIds);
    final normalized = <String, AiMessage>{
      for (final message in source)
        message.id: message.copyWith(
          parts: message.parts
              .where(
                (part) =>
                    part is! AiToolCallPart && part is! AiToolResultPart ||
                    part is AiToolCallPart &&
                        pairedIds.contains(part.toolCall.id) ||
                    part is AiToolResultPart &&
                        pairedIds.contains(part.toolResult.toolCallId),
              )
              .toList(growable: false),
        ),
    };
    final selectedIds = selected.map((message) => message.id).toSet();
    var changed = true;
    while (changed) {
      changed = false;
      final selectedCalls = {
        for (final id in selectedIds)
          for (final part in normalized[id]!.parts.whereType<AiToolCallPart>())
            part.toolCall.id,
        for (final id in selectedIds)
          for (final part
              in normalized[id]!.parts.whereType<AiToolResultPart>())
            part.toolResult.toolCallId,
      };
      for (final message in normalized.values) {
        final related = message.parts.any(
          (part) =>
              part is AiToolCallPart &&
                  selectedCalls.contains(part.toolCall.id) ||
              part is AiToolResultPart &&
                  selectedCalls.contains(part.toolResult.toolCallId),
        );
        if (related && selectedIds.add(message.id)) changed = true;
      }
    }
    return source
        .where((message) => selectedIds.contains(message.id))
        .map((message) => normalized[message.id]!)
        .where((message) => message.parts.isNotEmpty)
        .toList(growable: false);
  }

  static List<AiMessage> _recentMessages(
    List<AiMessage> messages,
    int? configuredLimit,
  ) {
    if (messages.isEmpty) return messages;
    if (configuredLimit == null || configuredLimit <= 0) return messages;
    final limit = configuredLimit.clamp(1, messages.length);
    return messages.sublist(messages.length - limit);
  }

  List<AiMessage> _withinTokenBudget(
    List<AiMessage> messages,
    AiContextPolicy policy,
    int contextTokens, {
    int systemPromptTokens = 0,
    double budgetScale = 1.0,
    int memoryTokens = 0,
  }) {
    if (contextTokens <= 0) return messages;
    // 记忆超出余量的部分才挤占消息预算（余量内由协议开销保守估计承担）。
    final memoryExcess = (memoryTokens - _memoryAllowanceTokens).clamp(
      0,
      memoryTokens,
    );
    final rawBudget =
        (contextTokens -
                policy.reservedOutputTokens -
                systemPromptTokens -
                _protocolOverheadTokens -
                memoryExcess)
            .clamp(1, contextTokens);
    // 高水位时收紧可用预算：把保留窗口压到水位线以内，为输出和
    // 记忆消息留出余量，避免下一轮请求贴线溢出。
    final budget = (rawBudget * budgetScale).round().clamp(1, rawBudget);
    final minimum = policy.recentMessageMinimum <= 0
        ? 1
        : policy.recentMessageMinimum;
    final selected = <AiMessage>[];
    var used = 0;
    var largestKept = 0;
    var budgetCollapsed = false;
    for (final message in messages.reversed) {
      final estimated = _tokenEstimator.estimate(message);
      if (used > 0 && used + estimated > budget) {
        // 上下文硬预算优先于“至少保留 N 条消息”：已保留条数达到
        // minimum 即停止，避免超大工具结果让请求必然超过模型限制。
        if (selected.length >= minimum) break;
        // 仅当预算已经失效（连已保留的最新一条都装不下，例如上下文
        // 配置过小或协议开销吞满预算）时，才允许溢出保留到 minimum
        // 条——此时保留 1 条与 N 条同样超限，保住 minimum 条至少
        // 避免模型只剩一条消息彻底失忆。
        if (!budgetCollapsed) {
          if (budget >= largestKept) break;
          budgetCollapsed = true;
        }
        // 预算失效兜底也不吸收比已保留消息更大的巨无霸消息。
        if (estimated > largestKept) break;
      }
      selected.add(message);
      used += estimated;
      if (estimated > largestKept) largestKept = estimated;
    }
    return selected.reversed.toList(growable: false);
  }
}
