import 'package:flutter/foundation.dart';

/// 计划项状态。与 AI 输出的 markdown 任务清单中的复选框标记一一对应：
/// `- [ ]` 待办、`- [>]` 进行中、`- [x]` 已完成。
enum AiPlanItemStatus { pending, inProgress, completed }

/// 计划模式下的单个执行步骤。
@immutable
class AiPlanItem {
  const AiPlanItem({required this.title, required this.status});

  final String title;
  final AiPlanItemStatus status;

  bool get isCompleted => status == AiPlanItemStatus.completed;

  AiPlanItem copyWith({String? title, AiPlanItemStatus? status}) {
    return AiPlanItem(
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AiPlanItem && other.title == title && other.status == status;

  @override
  int get hashCode => Object.hash(title, status);

  @override
  String toString() => 'AiPlanItem($status, $title)';
}
