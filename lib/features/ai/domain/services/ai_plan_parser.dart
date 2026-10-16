import 'package:JsxposedX/features/ai/domain/models/ai_plan_item.dart';

/// 从 AI 回复（markdown）中解析「结构化执行计划」。
///
/// 计划模式约定 AI 按如下格式输出（标题后紧跟任务清单）：
///
/// ```markdown
/// ### 执行计划
/// - [x] 1. 定位登录校验入口
/// - [>] 2. 分析加密算法
/// - [ ] 3. 编写 Hook 脚本
/// ```
///
/// 解析器只做纯文本处理，不依赖 Flutter/Riverpod，便于单测。
class AiPlanParser {
  AiPlanParser._();

  /// 计划标题行：`#` ~ `######` 后跟计划相关的关键词。
  static final RegExp _titleLine = RegExp(
    r'^#{1,6}\s*(执行计划|执行步骤|任务计划|计划清单|计划|'
    r'execution plan|execution steps|plan)\s*[:：]?\s*$',
    caseSensitive: false,
  );

  /// 任务清单行：`- [x] 文本` 也兼容 `* [ ]`、`1. [x]` 等写法。
  static final RegExp _checklistLine = RegExp(
    r'^\s*(?:[-*+]|\d+[.)])\s*\[( |x|X|>)\]\s*(\S.*)$',
  );

  /// 标题里 AI 常自带序号（`1. 定位入口`），界面上会重新编号，
  /// 这里剥掉，避免出现「1. 1. 定位入口」。
  static final RegExp _leadingIndex = RegExp(r'^\d{1,2}[.、)）:：]\s+');

  /// 解析「最新的一份完整计划」。
  ///
  /// [assistantContents] 需按消息时间顺序（旧 → 新）传入。
  /// 优先返回最后一条带计划标题的回复中的清单；若所有回复都没有标题，
  /// 则退化为返回最后一条包含至少两条清单项的回复的清单（避免把正文中
  /// 偶然出现的一条勾选项误判为计划）。
  static List<AiPlanItem>? parseLatestPlan(List<String> assistantContents) {
    for (var i = assistantContents.length - 1; i >= 0; i--) {
      final titled = _parseAfterTitle(assistantContents[i]);
      if (titled.isNotEmpty) return titled;
    }
    for (var i = assistantContents.length - 1; i >= 0; i--) {
      final fallback = _parseChecklist(assistantContents[i]);
      if (fallback.length >= 2) return fallback;
    }
    return null;
  }

  /// 取最后一个计划标题之后的全部清单项。
  static List<AiPlanItem> _parseAfterTitle(String content) {
    final lines = content.split('\n');
    var titleIndex = -1;
    for (var i = 0; i < lines.length; i++) {
      if (_titleLine.hasMatch(lines[i].trim())) {
        titleIndex = i;
      }
    }
    if (titleIndex < 0) return const [];
    return _parseChecklist(lines.skip(titleIndex + 1).join('\n'));
  }

  static List<AiPlanItem> _parseChecklist(String content) {
    final items = <AiPlanItem>[];
    for (final line in content.split('\n')) {
      final match = _checklistLine.firstMatch(line);
      if (match == null) continue;
      final title = match.group(2)!.trim().replaceFirst(_leadingIndex, '');
      if (title.isEmpty) continue;
      items.add(AiPlanItem(title: title, status: _statusOf(match.group(1)!)));
    }
    return items;
  }

  /// 从 markdown 中摘掉「执行计划」小节，避免同一份清单既出现在
  /// 右侧计划菜单、又重复渲染在对话气泡里。
  ///
  /// 只移除最后一个计划标题（及其后的清单行与紧随的引用/说明行），
  /// 其余正文原样保留；若移除后正文为空则返回空串。
  static String stripPlanSection(String content) {
    final lines = content.split('\n');
    var titleIndex = -1;
    for (var i = 0; i < lines.length; i++) {
      if (_titleLine.hasMatch(lines[i].trim())) {
        titleIndex = i;
      }
    }
    if (titleIndex < 0) return content;

    final kept = <String>[];
    var dropping = true;
    for (var i = 0; i < lines.length; i++) {
      if (i == titleIndex) {
        dropping = true;
        continue;
      }
      if (dropping) {
        final line = lines[i];
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;
        // 清单行、清单后的补充说明（引用/缩进）都属于计划块，继续丢弃。
        if (_checklistLine.hasMatch(line) ||
            trimmed.startsWith('>') ||
            line.startsWith('  ') ||
            line.startsWith('\t')) {
          continue;
        }
        dropping = false;
      }
      kept.add(lines[i]);
    }
    return kept.join('\n').trim();
  }

  static AiPlanItemStatus _statusOf(String marker) {
    return switch (marker) {
      'x' || 'X' => AiPlanItemStatus.completed,
      '>' => AiPlanItemStatus.inProgress,
      _ => AiPlanItemStatus.pending,
    };
  }
}
