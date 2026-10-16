import 'package:JsxposedX/features/ai/domain/models/ai_plan_item.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_plan_parser.dart';
import 'package:JsxposedX/features/ai/presentation/states/ai_chat_view_message.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';

/// 计划模式的全局状态：开关 + AI 生成的执行计划列表。
@immutable
class AiPlanState {
  const AiPlanState({this.enabled = false, this.items = const []});

  /// 计划模式开关。开启后发送需求会注入「先拆解需求、生成执行计划」指令。
  final bool enabled;

  /// 当前执行计划。由 AI 回复中的任务清单增量同步而来。
  final List<AiPlanItem> items;

  bool get hasItems => items.isNotEmpty;

  int get completedCount =>
      items.where((item) => item.isCompleted).length;

  double get progress => items.isEmpty ? 0 : completedCount / items.length;

  AiPlanState copyWith({bool? enabled, List<AiPlanItem>? items}) {
    return AiPlanState(
      enabled: enabled ?? this.enabled,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AiPlanState &&
      other.enabled == enabled &&
      listEquals(other.items, items);

  @override
  int get hashCode => Object.hash(enabled, Object.hashAll(items));
}

/// 计划模式控制器。状态全局可监听：`ref.watch(aiPlanProvider(packageName))`。
class AiPlanController extends StateNotifier<AiPlanState> {
  AiPlanController() : super(const AiPlanState());

  /// 当前计划所属的会话 id，用于在切换对话时丢弃上一份计划。
  String? _sessionId;

  /// 切换计划模式开关。关闭时清空已生成的计划，避免残留旧计划干扰。
  void setEnabled(bool enabled) {
    if (state.enabled == enabled) return;
    _sessionId = null;
    state = AiPlanState(enabled: enabled);
  }

  /// 从 AI 会话消息中增量同步执行计划。
  ///
  /// AI 每完成一个步骤都会重新输出完整清单，因此这里按序合并：
  /// 已有位置沿用原项（文本变化即视为被改写），超出的部分增量追加；
  /// 解析结果比现状短时保留尾部，避免流式输出中途截断导致列表回缩。
  ///
  /// [sessionId] 用于识别计划归属的会话；一旦切换到别的会话（或新会话），
  /// 上一个会话的计划会被整体丢弃，避免缓存串到当前对话上。
  void syncFromMessages(
    List<AiChatViewMessage> messages, {
    bool isStreaming = false,
    String? sessionId,
  }) {
    if (!state.enabled) return;
    if (sessionId != _sessionId) {
      _sessionId = sessionId;
      state = state.copyWith(items: const []);
    }
    final contents = <String>[
      for (final message in messages)
        if (message.role == 'assistant') message.content,
    ];
    final parsed = AiPlanParser.parseLatestPlan(contents);
    if (parsed == null || parsed.isEmpty) return;
    // 流式输出时，未完成的步骤文本可能还在增长；此时只有解析出更完整的
    // 结果才覆盖，避免半截文本反复替换造成列表抖动。
    if (isStreaming && _isShorterButCovered(parsed)) return;
    final merged = _merge(parsed);
    if (merged.length == state.items.length &&
        _listEquals(merged, state.items)) {
      return;
    }
    state = state.copyWith(items: List.unmodifiable(merged));
  }

  /// 清空计划列表但保留开关状态（用于新会话）。
  void clearItems() {
    if (state.items.isEmpty) return;
    state = state.copyWith(items: const []);
  }

  List<AiPlanItem> _merge(List<AiPlanItem> parsed) {
    final merged = <AiPlanItem>[];
    for (var i = 0; i < parsed.length; i++) {
      if (i < state.items.length &&
          state.items[i].title == parsed[i].title) {
        merged.add(parsed[i]);
        continue;
      }
      merged.add(parsed[i]);
    }
    if (merged.length < state.items.length) {
      merged.addAll(state.items.skip(merged.length));
    }
    return merged;
  }

  /// 流式期间解析结果是否只是现有计划的“半截版本”。
  bool _isShorterButCovered(List<AiPlanItem> parsed) {
    if (parsed.length >= state.items.length) return false;
    for (var i = 0; i < parsed.length; i++) {
      if (parsed[i].title != state.items[i].title) return false;
    }
    return true;
  }

  bool _listEquals(List<AiPlanItem> left, List<AiPlanItem> right) {
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) return false;
    }
    return true;
  }
}

/// 计划模式状态（按逆向目标隔离），全局可监听。
final aiPlanProvider =
    StateNotifierProvider.family<AiPlanController, AiPlanState, String>(
      (ref, packageName) => AiPlanController(),
    );

/// 计划模式规则文本：要求 AI 先拆解需求再生成结构化执行计划，
/// 并在每次推进后重新输出完整清单（用 markdown 任务清单承载状态）。
///
/// 这段文本只作为系统规则交给模型，不会拼进用户消息，因此不会出现在对话气泡里。
class AiPlanPrompt {
  AiPlanPrompt._();

  /// 组合最终的系统规则：基础规则 + （计划模式开启时的）计划约束。
  static String systemRules({
    required String baseRules,
    required bool enabled,
    required bool isZh,
  }) {
    if (!enabled) return baseRules;
    final instruction = isZh ? _zh : _en;
    return baseRules.isEmpty ? instruction : '$baseRules\n\n$instruction';
  }

  static const String _zh = '''
[计划模式]
在开始动手之前，请先对用户的需求做前置分析：拆解目标、识别关键点与风险，然后给出结构化的执行计划，格式固定为：

### 执行计划
- [ ] 1. 第一个步骤
- [ ] 2. 第二个步骤

要求：
1. 每个步骤保持简短明确，只描述一个可独立完成的动作。
2. 每完成一个步骤后，请重新完整输出这份清单，把已完成步骤标记为 `- [x]`，当前进行中的步骤标记为 `- [>]`，未开始的保持 `- [ ]`。
3. 清单之外可以正常输出分析、结论与代码，不要省略清单。''';

  static const String _en = '''
[Plan mode]
Before doing anything, analyze the user's request first: break down the goal, call out key points and risks, then produce a structured execution plan in exactly this format:

### Execution Plan
- [ ] 1. First step
- [ ] 2. Second step

Rules:
1. Keep each step short and describe a single independently completable action.
2. After finishing a step, re-print the whole checklist, marking finished steps as `- [x]`, the current one as `- [>]`, and untouched ones as `- [ ]`.
3. You may still output analysis, conclusions and code outside the checklist — just never omit the checklist.''';
}
