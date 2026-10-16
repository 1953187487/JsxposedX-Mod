import 'package:JsxposedX/features/ai/domain/models/ai_question.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';

/// 问答模式状态（按逆向目标隔离），全局可监听。
@immutable
class AiAskState {
  const AiAskState({this.enabled = false, this.pendingQuestion});

  /// 开关状态。
  final bool enabled;

  /// 当前等待用户作答的问题；为空表示没有待回答问题。
  final AiQuestion? pendingQuestion;

  bool get hasPendingQuestion => pendingQuestion != null;

  AiAskState copyWith({
    bool? enabled,
    AiQuestion? pendingQuestion,
    bool clearPendingQuestion = false,
  }) {
    return AiAskState(
      enabled: enabled ?? this.enabled,
      pendingQuestion: clearPendingQuestion
          ? null
          : (pendingQuestion ?? this.pendingQuestion),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AiAskState &&
      other.enabled == enabled &&
      other.pendingQuestion == pendingQuestion;

  @override
  int get hashCode => Object.hash(enabled, pendingQuestion);
}

/// 问答模式控制器。
class AiAskController extends StateNotifier<AiAskState> {
  AiAskController() : super(const AiAskState());

  /// 当前问答所属会话，切换对话时据此丢弃上一个会话的待作答问题。
  String? _sessionId;

  void setEnabled(bool enabled) {
    if (state.enabled == enabled) return;
    _sessionId = null;
    state = AiAskState(enabled: enabled);
  }

  /// 记录会话抛出的待作答问题。
  void setPendingQuestion(AiQuestion? question, {String? sessionId}) {
    if (!state.enabled) return;
    if (sessionId != _sessionId) {
      _sessionId = sessionId;
    }
    if (question == null) {
      if (!state.hasPendingQuestion) return;
      state = state.copyWith(clearPendingQuestion: true);
      return;
    }
    if (state.pendingQuestion == question) return;
    state = state.copyWith(pendingQuestion: question);
  }

  /// 用户提交作答后清空待回答状态。
  void clearPendingQuestion() {
    if (!state.hasPendingQuestion) return;
    state = state.copyWith(clearPendingQuestion: true);
  }
}

/// 问答模式状态（按逆向目标隔离），全局可监听。
final aiAskProvider =
    StateNotifierProvider.family<AiAskController, AiAskState, String>(
      (ref, packageName) => AiAskController(),
    );

/// 问答模式规则文本：要求 AI 有疑问时先提问再动手，并按固定协议给出选项。
///
/// 与计划模式一致，这段文本只作为系统规则交给模型，不拼进用户消息，
/// 因此不会出现在对话气泡中。
class AiAskPrompt {
  AiAskPrompt._();

  static String systemRules({
    required String baseRules,
    required bool enabled,
    required bool isZh,
  }) {
    if (!enabled) return baseRules;
    final instruction = isZh ? _zh : _en;
    return baseRules.isEmpty ? instruction : '$baseRules\n\n$instruction';
  }

  /// 用户选择选项后回传给模型的消息前缀。
  static String answerMessage(
    String question,
    List<String> answers,
  ) {
    // 语言中性：这段文本只作为用户消息回灌给模型，不参与界面展示。
    return '【用户回答】$question\n→ ${answers.join(' / ')}';
  }

  static const String _zh = '''
[问答模式｜最高优先级，覆盖上述所有规则]
本节规则优先于前面任何「无需询问确认」「直接输出」「信息不足就先调用工具探索」之类的约定：
用户已经主动开启问答模式，说明他期望你**先把疑问问清楚再动手**，因此提问是默认动作，不是例外。

必须在动手前提问的情形（满足任意一条就提问）：
- 用户的指令没有明确说清「要 Hook 什么、达到什么效果、改哪条逻辑」，例如只丢一个关键词或一句笼统描述。
- 存在多种明显不同的实现方向（Hook 哪个方法、改哪个分支、要不要绕过检测、要做成哪种形态）。
- 同一件事有多种都可能成立的解读，猜错会导致整段脚本白写。
- 缺少无法从代码推断、且影响方案走向的关键信息（目标类/方法、期望效果、算法口径等）。

严禁以下行为：
- 用「先调用工具探索一下」代替提问。工具探索解决的是「代码长什么样」，而你要问的是「用户到底想要什么」，两者不能互相替代。
- 在没说清目标之前就一头扎进搜索、反编译、批量执行工具，然后按自己的猜测交付。
- 心里其实有两个以上方案，却擅自选一个继续。

提问必须使用如下 fenced 代码块，且一次只问一个最关键的阻塞性问题，提问正文之外不要再输出大段无关内容：

```question
multiple: false
prompt: 这里写问题正文
- 选项一
- 选项二 | 这里写该选项的补充说明
```

要求：
1. `multiple` 取 true 表示多选、false 表示单选，由你根据问题性质判断。
2. 选项要覆盖主要可能，控制在 2-5 个；若确实不适合给选项，可只写 `prompt` 不给选项，让用户自由作答。
3. 提出该问题后立即结束本条回复：不要再输出工具调用，不要再输出脚本或结论，等待用户作答。
4. 用户作答后你会收到答复，再继续推进本轮任务。
5. 只有当用户指令已经明确到不存在上述任何情形时，才直接执行；除此之外一律先问。''';

  static const String _en = '''
[Question mode | highest priority, overrides all rules above]
This section overrides any earlier wording such as "no need to ask for confirmation", "just output", or "when information is missing, explore the code with tools first":
the user explicitly turned on question mode, so asking is the default behavior, not an exception.

You MUST ask before acting when any of these holds:
- The request does not specify what to hook, what effect is wanted, or which logic to change (e.g. just a keyword or a vague sentence).
- The goal has several clearly different approaches (which method to hook, which branch to patch, whether to bypass a check, what form to deliver).
- The request can be read in multiple plausible ways and a wrong guess would waste the whole script.
- Key information that shapes the approach is missing and cannot be inferred from code (target class/method, desired effect, crypto scheme).

Never do this:
- Substituting "let me explore with tools first" for asking. Tools tell you what the code looks like; the question is what the user actually wants — one cannot replace the other.
- Diving into searching, decompiling, or batch tool execution before the goal is clear, then delivering your own guess.
- Having two or more viable plans in mind and silently picking one.

Ask with exactly this fenced code block, and only ask one blocking question at a time; do not output long unrelated content alongside it:

```question
multiple: false
prompt: Write the question here
- Option one
- Option two | Optional detail for this option
```

Rules:
1. `multiple: true` means multi-select, `false` means single-select; decide based on the question.
2. Provide 2-5 options covering the main possibilities; if options do not fit, output only `prompt` and let the user answer freely.
3. End your reply right after asking: no tool calls, no script, no conclusion in the same turn.
4. You will receive the answer and then continue the current task.
5. Proceed directly only when the request is already unambiguous enough that none of the above applies; otherwise always ask first.''';
}
