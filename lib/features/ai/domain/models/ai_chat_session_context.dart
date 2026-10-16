import 'package:JsxposedX/core/models/ai_message.dart';

enum AiChatRecoveryMode {
  none,
  retryLastTurn,
  continueGeneration,
  resumeToolPhase,
  retryInitialization;

  String get storageValue => switch (this) {
    AiChatRecoveryMode.none => 'none',
    AiChatRecoveryMode.retryLastTurn => 'retry_last_turn',
    AiChatRecoveryMode.continueGeneration => 'continue_generation',
    AiChatRecoveryMode.resumeToolPhase => 'resume_tool_phase',
    AiChatRecoveryMode.retryInitialization => 'retry_initialization',
  };

  static AiChatRecoveryMode fromStorage(String? value) {
    return switch (value) {
      'retry_last_turn' => AiChatRecoveryMode.retryLastTurn,
      'continue_generation' => AiChatRecoveryMode.continueGeneration,
      'resume_tool_phase' => AiChatRecoveryMode.resumeToolPhase,
      'retry_initialization' => AiChatRecoveryMode.retryInitialization,
      _ => AiChatRecoveryMode.none,
    };
  }
}

class AiChatSessionContext {
  static const int currentVersion = 3;

  const AiChatSessionContext({
    this.version = currentVersion,
    this.sessionRules = '',
    this.pinnedContext = const [],
    this.sessionMemory = const AiChatSessionMemory(),
    this.taskState = const AiChatTaskState(),
    this.recentMessages = const [],
    this.toolTrace = const AiToolExecutionTrace(),
    this.checkpoint,
    this.stats = const AiChatContextStats(),
    this.migratedFromLegacySummary = false,
  });

  final int version;
  final String sessionRules;
  final List<AiPinnedContextItem> pinnedContext;
  final AiChatSessionMemory sessionMemory;
  final AiChatTaskState taskState;
  final List<AiMessage> recentMessages;
  final AiToolExecutionTrace toolTrace;
  final AiChatCheckpoint? checkpoint;
  final AiChatContextStats stats;
  final bool migratedFromLegacySummary;

  bool get hasStructuredMemory =>
      pinnedContext.isNotEmpty || sessionMemory.hasContent || taskState.hasContent;

  bool get hasPendingToolPhase => toolTrace.hasPendingToolResults;

  AiChatSessionContext copyWith({
    int? version,
    String? sessionRules,
    List<AiPinnedContextItem>? pinnedContext,
    AiChatSessionMemory? sessionMemory,
    AiChatTaskState? taskState,
    List<AiMessage>? recentMessages,
    AiToolExecutionTrace? toolTrace,
    Object? checkpoint = _sentinel,
    AiChatContextStats? stats,
    bool? migratedFromLegacySummary,
  }) {
    return AiChatSessionContext(
      version: version ?? this.version,
      sessionRules: sessionRules ?? this.sessionRules,
      pinnedContext: pinnedContext ?? this.pinnedContext,
      sessionMemory: sessionMemory ?? this.sessionMemory,
      taskState: taskState ?? this.taskState,
      recentMessages: recentMessages ?? this.recentMessages,
      toolTrace: toolTrace ?? this.toolTrace,
      checkpoint: identical(checkpoint, _sentinel)
          ? this.checkpoint
          : checkpoint as AiChatCheckpoint?,
      stats: stats ?? this.stats,
      migratedFromLegacySummary:
          migratedFromLegacySummary ?? this.migratedFromLegacySummary,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'version': version,
      'session_rules': sessionRules,
      'pinned_context': pinnedContext
          .map((item) => item.toStorageJson())
          .toList(growable: false),
      'session_memory': sessionMemory.toStorageJson(),
      'task_state': taskState.toStorageJson(),
      'recent_messages': recentMessages
          .map((message) => message.toStorageJson())
          .toList(growable: false),
      'tool_trace': toolTrace.toStorageJson(),
      if (checkpoint != null) 'checkpoint': checkpoint!.toStorageJson(),
      'stats': stats.toStorageJson(),
      'migrated_from_legacy_summary': migratedFromLegacySummary,
    };
  }

  factory AiChatSessionContext.fromStorageJson(Map<String, dynamic> json) {
    final rawRecentMessages = json['recent_messages'] as List?;
    final rawPinnedContext = json['pinned_context'] as List?;
    return AiChatSessionContext(
      version: json['version'] as int? ?? currentVersion,
      sessionRules: json['session_rules']?.toString() ?? '',
      pinnedContext: rawPinnedContext
              ?.map(
                (item) => AiPinnedContextItem.fromStorageJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false) ??
          const [],
      sessionMemory: AiChatSessionMemory.fromStorageJson(
        Map<String, dynamic>.from(
          json['session_memory'] as Map? ?? const <String, dynamic>{},
        ),
      ),
      taskState: AiChatTaskState.fromStorageJson(
        Map<String, dynamic>.from(
          json['task_state'] as Map? ?? const <String, dynamic>{},
        ),
      ),
      recentMessages: rawRecentMessages
              ?.map(
                (item) => AiMessage.fromStorageJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false) ??
          const [],
      toolTrace: AiToolExecutionTrace.fromStorageJson(
        Map<String, dynamic>.from(
          json['tool_trace'] as Map? ?? const <String, dynamic>{},
        ),
      ),
      checkpoint: json['checkpoint'] is Map
          ? AiChatCheckpoint.fromStorageJson(
              Map<String, dynamic>.from(json['checkpoint'] as Map),
            )
          : null,
      stats: AiChatContextStats.fromStorageJson(
        Map<String, dynamic>.from(
          json['stats'] as Map? ?? const <String, dynamic>{},
        ),
      ),
      migratedFromLegacySummary:
          json['migrated_from_legacy_summary'] == true,
    );
  }
}

enum AiPinnedContextSource {
  userRule('user_rule'),
  workflowConstraint('workflow_constraint'),
  environmentConstraint('environment_constraint');

  const AiPinnedContextSource(this.storageValue);

  final String storageValue;

  static AiPinnedContextSource fromStorage(String? value) {
    return switch (value) {
      'workflow_constraint' => AiPinnedContextSource.workflowConstraint,
      'environment_constraint' => AiPinnedContextSource.environmentConstraint,
      _ => AiPinnedContextSource.userRule,
    };
  }
}

class AiPinnedContextItem {
  const AiPinnedContextItem({
    required this.id,
    required this.content,
    required this.source,
    required this.priority,
    required this.createdAtIso,
  });

  final String id;
  final String content;
  final AiPinnedContextSource source;
  final int priority;
  final String createdAtIso;

  AiPinnedContextItem copyWith({
    String? id,
    String? content,
    AiPinnedContextSource? source,
    int? priority,
    String? createdAtIso,
  }) {
    return AiPinnedContextItem(
      id: id ?? this.id,
      content: content ?? this.content,
      source: source ?? this.source,
      priority: priority ?? this.priority,
      createdAtIso: createdAtIso ?? this.createdAtIso,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'id': id,
      'content': content,
      'source': source.storageValue,
      'priority': priority,
      'created_at_iso': createdAtIso,
    };
  }

  factory AiPinnedContextItem.fromStorageJson(Map<String, dynamic> json) {
    return AiPinnedContextItem(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      source: AiPinnedContextSource.fromStorage(json['source']?.toString()),
      priority: json['priority'] as int? ?? 80,
      createdAtIso: json['created_at_iso']?.toString() ?? '',
    );
  }
}

class AiChatSessionMemory {
  const AiChatSessionMemory({
    this.userGoals = const [],
    this.confirmedFacts = const [],
    this.openHypotheses = const [],
    this.toolFindings = const [],
    this.blockers = const [],
    this.memoryEntries = const [],
  });

  final List<String> userGoals;
  final List<String> confirmedFacts;
  final List<String> openHypotheses;
  final List<String> toolFindings;
  final List<String> blockers;

  /// 上下文记忆压缩器输出的持久化记忆条目：被裁出请求窗口的历史
  /// 摘要（含已完成的类分析工具调用记录）。重启/分页后作为
  /// persistedMemory 回流到下一次组装，防止重复分析已处理过的类。
  final List<String> memoryEntries;

  bool get hasContent =>
      userGoals.isNotEmpty ||
      confirmedFacts.isNotEmpty ||
      openHypotheses.isNotEmpty ||
      toolFindings.isNotEmpty ||
      blockers.isNotEmpty ||
      memoryEntries.isNotEmpty;

  AiChatSessionMemory copyWith({
    List<String>? userGoals,
    List<String>? confirmedFacts,
    List<String>? openHypotheses,
    List<String>? toolFindings,
    List<String>? blockers,
    List<String>? memoryEntries,
  }) {
    return AiChatSessionMemory(
      userGoals: userGoals ?? this.userGoals,
      confirmedFacts: confirmedFacts ?? this.confirmedFacts,
      openHypotheses: openHypotheses ?? this.openHypotheses,
      toolFindings: toolFindings ?? this.toolFindings,
      blockers: blockers ?? this.blockers,
      memoryEntries: memoryEntries ?? this.memoryEntries,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'user_goals': userGoals,
      'confirmed_facts': confirmedFacts,
      'open_hypotheses': openHypotheses,
      'tool_findings': toolFindings,
      'blockers': blockers,
      if (memoryEntries.isNotEmpty) 'memory_entries': memoryEntries,
    };
  }

  factory AiChatSessionMemory.fromStorageJson(Map<String, dynamic> json) {
    return AiChatSessionMemory(
      userGoals: _readStringList(json['user_goals']),
      confirmedFacts: _readStringList(json['confirmed_facts']),
      openHypotheses: _readStringList(json['open_hypotheses']),
      toolFindings: _readStringList(json['tool_findings']),
      blockers: _readStringList(json['blockers']),
      memoryEntries: _readStringList(json['memory_entries']),
    );
  }
}

class AiChatTaskState {
  const AiChatTaskState({
    this.currentStep,
    this.nextStep,
    this.recentSuccessStep,
    this.lastError,
    this.lastUserGoal,
    this.lastRecoveryMode = AiChatRecoveryMode.none,
  });

  final String? currentStep;
  final String? nextStep;
  final String? recentSuccessStep;
  final String? lastError;
  final String? lastUserGoal;
  final AiChatRecoveryMode lastRecoveryMode;

  bool get hasContent =>
      (currentStep?.isNotEmpty ?? false) ||
      (nextStep?.isNotEmpty ?? false) ||
      (recentSuccessStep?.isNotEmpty ?? false) ||
      (lastError?.isNotEmpty ?? false) ||
      (lastUserGoal?.isNotEmpty ?? false);

  AiChatTaskState copyWith({
    Object? currentStep = _sentinel,
    Object? nextStep = _sentinel,
    Object? recentSuccessStep = _sentinel,
    Object? lastError = _sentinel,
    Object? lastUserGoal = _sentinel,
    AiChatRecoveryMode? lastRecoveryMode,
  }) {
    return AiChatTaskState(
      currentStep: identical(currentStep, _sentinel)
          ? this.currentStep
          : currentStep as String?,
      nextStep: identical(nextStep, _sentinel)
          ? this.nextStep
          : nextStep as String?,
      recentSuccessStep: identical(recentSuccessStep, _sentinel)
          ? this.recentSuccessStep
          : recentSuccessStep as String?,
      lastError: identical(lastError, _sentinel)
          ? this.lastError
          : lastError as String?,
      lastUserGoal: identical(lastUserGoal, _sentinel)
          ? this.lastUserGoal
          : lastUserGoal as String?,
      lastRecoveryMode: lastRecoveryMode ?? this.lastRecoveryMode,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      if (currentStep != null) 'current_step': currentStep,
      if (nextStep != null) 'next_step': nextStep,
      if (recentSuccessStep != null) 'recent_success_step': recentSuccessStep,
      if (lastError != null) 'last_error': lastError,
      if (lastUserGoal != null) 'last_user_goal': lastUserGoal,
      'last_recovery_mode': lastRecoveryMode.storageValue,
    };
  }

  factory AiChatTaskState.fromStorageJson(Map<String, dynamic> json) {
    return AiChatTaskState(
      currentStep: json['current_step']?.toString(),
      nextStep: json['next_step']?.toString(),
      recentSuccessStep: json['recent_success_step']?.toString(),
      lastError: json['last_error']?.toString(),
      lastUserGoal: json['last_user_goal']?.toString(),
      lastRecoveryMode: AiChatRecoveryMode.fromStorage(
        json['last_recovery_mode']?.toString(),
      ),
    );
  }
}

class AiToolExecutionTrace {
  const AiToolExecutionTrace({
    this.assistantToolCallMessage,
    this.toolCallIds = const [],
    this.argumentSummaries = const {},
    this.resultSummaries = const {},
    this.isComplete = true,
    this.canReplay = false,
  });

  final AiMessage? assistantToolCallMessage;
  final List<String> toolCallIds;
  final Map<String, String> argumentSummaries;
  final Map<String, String> resultSummaries;
  final bool isComplete;
  final bool canReplay;

  bool get hasPendingToolResults => assistantToolCallMessage != null && !isComplete;

  AiToolExecutionTrace copyWith({
    Object? assistantToolCallMessage = _sentinel,
    List<String>? toolCallIds,
    Map<String, String>? argumentSummaries,
    Map<String, String>? resultSummaries,
    bool? isComplete,
    bool? canReplay,
  }) {
    return AiToolExecutionTrace(
      assistantToolCallMessage: identical(assistantToolCallMessage, _sentinel)
          ? this.assistantToolCallMessage
          : assistantToolCallMessage as AiMessage?,
      toolCallIds: toolCallIds ?? this.toolCallIds,
      argumentSummaries: argumentSummaries ?? this.argumentSummaries,
      resultSummaries: resultSummaries ?? this.resultSummaries,
      isComplete: isComplete ?? this.isComplete,
      canReplay: canReplay ?? this.canReplay,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      if (assistantToolCallMessage != null)
        'assistant_tool_call_message':
            assistantToolCallMessage!.toStorageJson(),
      'tool_call_ids': toolCallIds,
      'argument_summaries': argumentSummaries,
      'result_summaries': resultSummaries,
      'is_complete': isComplete,
      'can_replay': canReplay,
    };
  }

  factory AiToolExecutionTrace.fromStorageJson(Map<String, dynamic> json) {
    return AiToolExecutionTrace(
      assistantToolCallMessage: json['assistant_tool_call_message'] is Map
          ? AiMessage.fromStorageJson(
              Map<String, dynamic>.from(
                json['assistant_tool_call_message'] as Map,
              ),
            )
          : null,
      toolCallIds: _readStringList(json['tool_call_ids']),
      argumentSummaries: _readStringMap(json['argument_summaries']),
      resultSummaries: _readStringMap(json['result_summaries']),
      isComplete: json['is_complete'] != false,
      canReplay: json['can_replay'] == true,
    );
  }
}

class AiChatCheckpoint {
  const AiChatCheckpoint({
    required this.createdAtIso,
    this.lastUserMessage,
    this.protocolMessages = const [],
    this.sessionMemorySnapshot = const AiChatSessionMemory(),
    this.taskStateSnapshot = const AiChatTaskState(),
    this.toolTraceSnapshot = const AiToolExecutionTrace(),
    this.recoveryMode = AiChatRecoveryMode.none,
  });

  final String createdAtIso;
  final AiMessage? lastUserMessage;
  final List<AiMessage> protocolMessages;
  final AiChatSessionMemory sessionMemorySnapshot;
  final AiChatTaskState taskStateSnapshot;
  final AiToolExecutionTrace toolTraceSnapshot;
  final AiChatRecoveryMode recoveryMode;

  AiChatCheckpoint copyWith({
    String? createdAtIso,
    Object? lastUserMessage = _sentinel,
    List<AiMessage>? protocolMessages,
    AiChatSessionMemory? sessionMemorySnapshot,
    AiChatTaskState? taskStateSnapshot,
    AiToolExecutionTrace? toolTraceSnapshot,
    AiChatRecoveryMode? recoveryMode,
  }) {
    return AiChatCheckpoint(
      createdAtIso: createdAtIso ?? this.createdAtIso,
      lastUserMessage: identical(lastUserMessage, _sentinel)
          ? this.lastUserMessage
          : lastUserMessage as AiMessage?,
      protocolMessages: protocolMessages ?? this.protocolMessages,
      sessionMemorySnapshot:
          sessionMemorySnapshot ?? this.sessionMemorySnapshot,
      taskStateSnapshot: taskStateSnapshot ?? this.taskStateSnapshot,
      toolTraceSnapshot: toolTraceSnapshot ?? this.toolTraceSnapshot,
      recoveryMode: recoveryMode ?? this.recoveryMode,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'created_at_iso': createdAtIso,
      if (lastUserMessage != null) 'last_user_message': lastUserMessage!.toStorageJson(),
      'protocol_messages': protocolMessages
          .map((message) => message.toStorageJson())
          .toList(growable: false),
      'session_memory_snapshot': sessionMemorySnapshot.toStorageJson(),
      'task_state_snapshot': taskStateSnapshot.toStorageJson(),
      'tool_trace_snapshot': toolTraceSnapshot.toStorageJson(),
      'recovery_mode': recoveryMode.storageValue,
    };
  }

  factory AiChatCheckpoint.fromStorageJson(Map<String, dynamic> json) {
    final rawProtocolMessages = json['protocol_messages'] as List?;
    return AiChatCheckpoint(
      createdAtIso: json['created_at_iso']?.toString() ?? '',
      lastUserMessage: json['last_user_message'] is Map
          ? AiMessage.fromStorageJson(
              Map<String, dynamic>.from(json['last_user_message'] as Map),
            )
          : null,
      protocolMessages: rawProtocolMessages
              ?.map(
                (item) => AiMessage.fromStorageJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(growable: false) ??
          const [],
      sessionMemorySnapshot: AiChatSessionMemory.fromStorageJson(
        Map<String, dynamic>.from(
          json['session_memory_snapshot'] as Map? ?? const <String, dynamic>{},
        ),
      ),
      taskStateSnapshot: AiChatTaskState.fromStorageJson(
        Map<String, dynamic>.from(
          json['task_state_snapshot'] as Map? ?? const <String, dynamic>{},
        ),
      ),
      toolTraceSnapshot: AiToolExecutionTrace.fromStorageJson(
        Map<String, dynamic>.from(
          json['tool_trace_snapshot'] as Map? ?? const <String, dynamic>{},
        ),
      ),
      recoveryMode: AiChatRecoveryMode.fromStorage(
        json['recovery_mode']?.toString(),
      ),
    );
  }
}

class AiChatContextStats {
  const AiChatContextStats({
    this.tokenBudget = 0,
    this.estimatedTokens = 0,
    this.remainingTokens = 0,
    this.usageRatio = 0,
    this.highWatermarkReached = false,
    this.didCompact = false,
    this.compactReason,
    this.repairedToolContext = false,
    this.migratedLegacySummary = false,
    this.recentRoundsKept = 0,
    this.memoryEntryCount = 0,
    this.pinnedCount = 0,
    this.retrievedSnippetCount = 0,
    this.retrievedBundlesCount = 0,
    this.includedLayers = const [],
  });

  final int tokenBudget;
  final int estimatedTokens;
  final int remainingTokens;

  /// 上下文占用率：estimatedTokens / tokenBudget，范围 [0, 1]。
  /// 供监控告警实时统计，超过阈值（默认 0.75）即触发摘要压缩。
  final double usageRatio;

  /// 本次组装是否触达高水位线（触发了预防性摘要压缩）。
  final bool highWatermarkReached;
  final bool didCompact;
  final String? compactReason;
  final bool repairedToolContext;
  final bool migratedLegacySummary;
  final int recentRoundsKept;

  /// 注入的 [context_memory] 记忆条目数（防重复分析的压缩记录）。
  final int memoryEntryCount;
  final int pinnedCount;
  final int retrievedSnippetCount;
  final int retrievedBundlesCount;
  final List<String> includedLayers;

  AiChatContextStats copyWith({
    int? tokenBudget,
    int? estimatedTokens,
    int? remainingTokens,
    double? usageRatio,
    bool? highWatermarkReached,
    bool? didCompact,
    Object? compactReason = _sentinel,
    bool? repairedToolContext,
    bool? migratedLegacySummary,
    int? recentRoundsKept,
    int? memoryEntryCount,
    int? pinnedCount,
    int? retrievedSnippetCount,
    int? retrievedBundlesCount,
    List<String>? includedLayers,
  }) {
    return AiChatContextStats(
      tokenBudget: tokenBudget ?? this.tokenBudget,
      estimatedTokens: estimatedTokens ?? this.estimatedTokens,
      remainingTokens: remainingTokens ?? this.remainingTokens,
      usageRatio: usageRatio ?? this.usageRatio,
      highWatermarkReached: highWatermarkReached ?? this.highWatermarkReached,
      didCompact: didCompact ?? this.didCompact,
      compactReason: identical(compactReason, _sentinel)
          ? this.compactReason
          : compactReason as String?,
      repairedToolContext: repairedToolContext ?? this.repairedToolContext,
      migratedLegacySummary:
          migratedLegacySummary ?? this.migratedLegacySummary,
      recentRoundsKept: recentRoundsKept ?? this.recentRoundsKept,
      memoryEntryCount: memoryEntryCount ?? this.memoryEntryCount,
      pinnedCount: pinnedCount ?? this.pinnedCount,
      retrievedSnippetCount:
          retrievedSnippetCount ?? this.retrievedSnippetCount,
      retrievedBundlesCount:
          retrievedBundlesCount ?? this.retrievedBundlesCount,
      includedLayers: includedLayers ?? this.includedLayers,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'token_budget': tokenBudget,
      'estimated_tokens': estimatedTokens,
      'remaining_tokens': remainingTokens,
      'usage_ratio': usageRatio,
      'high_watermark_reached': highWatermarkReached,
      'did_compact': didCompact,
      if (compactReason != null) 'compact_reason': compactReason,
      'repaired_tool_context': repairedToolContext,
      'migrated_legacy_summary': migratedLegacySummary,
      'recent_rounds_kept': recentRoundsKept,
      'memory_entry_count': memoryEntryCount,
      'pinned_count': pinnedCount,
      'retrieved_snippet_count': retrievedSnippetCount,
      'retrieved_bundles_count': retrievedBundlesCount,
      'included_layers': includedLayers,
    };
  }

  factory AiChatContextStats.fromStorageJson(Map<String, dynamic> json) {
    return AiChatContextStats(
      tokenBudget: json['token_budget'] as int? ?? 0,
      estimatedTokens: json['estimated_tokens'] as int? ?? 0,
      remainingTokens: json['remaining_tokens'] as int? ?? 0,
      usageRatio: (json['usage_ratio'] as num?)?.toDouble() ?? 0,
      highWatermarkReached: json['high_watermark_reached'] == true,
      didCompact: json['did_compact'] == true,
      compactReason: json['compact_reason']?.toString(),
      repairedToolContext: json['repaired_tool_context'] == true,
      migratedLegacySummary: json['migrated_legacy_summary'] == true,
      recentRoundsKept: json['recent_rounds_kept'] as int? ?? 0,
      memoryEntryCount: json['memory_entry_count'] as int? ?? 0,
      pinnedCount: json['pinned_count'] as int? ?? 0,
      retrievedSnippetCount: json['retrieved_snippet_count'] as int? ?? 0,
      retrievedBundlesCount: json['retrieved_bundles_count'] as int? ?? 0,
      includedLayers: _readStringList(json['included_layers']),
    );
  }
}

List<String> _readStringList(dynamic value) {
  if (value is! List) {
    return const [];
  }
  return value.map((item) => item.toString()).toList(growable: false);
}

Map<String, String> _readStringMap(dynamic value) {
  if (value is! Map) {
    return const {};
  }
  return value.map(
    (key, item) => MapEntry(key.toString(), item.toString()),
  );
}

const Object _sentinel = Object();
