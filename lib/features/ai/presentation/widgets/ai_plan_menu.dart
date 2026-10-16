import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/themes/app_colors.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_plan_item.dart';
import 'package:JsxposedX/features/ai/presentation/providers/plan/ai_plan_provider.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 计划模式的专属 AI 菜单组件。
///
/// 独立可复用：仅依赖 [aiPlanProvider]，负责渲染 AI 生成的执行计划列表，
/// 随计划项状态变化做增量更新，并区分展示已完成 / 进行中 / 待办。
/// 视觉与输入框上方的上下文占用率指示器保持一致（淡描边 + 主色进度条）。
class AiPlanMenu extends HookConsumerWidget {
  const AiPlanMenu({super.key, required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scopeScale = AiChatCompactScope.scaleOf(context);
    final planState = ref.watch(aiPlanProvider(packageName));
    final expanded = useState(true);
    final listController = useScrollController();

    if (!planState.enabled || !planState.hasItems) {
      return const SizedBox.shrink();
    }

    final color = context.colorScheme.primary;
    final radius = BorderRadius.circular(8 * scopeScale);
    final surfaceDecoration = BoxDecoration(
      borderRadius: radius,
      border: Border.all(
        color: context.colorScheme.outlineVariant.withValues(alpha: 0.45),
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16 * scopeScale,
        6 * scopeScale,
        16 * scopeScale,
        0,
      ),
      child: Container(
        decoration: surfaceDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(
              context: context,
              scopeScale: scopeScale,
              planState: planState,
              color: color,
              radius: radius,
              expanded: expanded,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: expanded.value
                  ? ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 178 * scopeScale),
                      child: ListView.builder(
                        controller: listController,
                        shrinkWrap: true,
                        padding: EdgeInsets.fromLTRB(
                          10 * scopeScale,
                          0,
                          10 * scopeScale,
                          8 * scopeScale,
                        ),
                        itemCount: planState.items.length,
                        itemBuilder: (context, index) => _PlanItemTile(
                          key: ValueKey('plan-item-$index'),
                          index: index,
                          item: planState.items[index],
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header({
    required BuildContext context,
    required double scopeScale,
    required AiPlanState planState,
    required Color color,
    required BorderRadius radius,
    required ValueNotifier<bool> expanded,
  }) {
    final allDone = planState.completedCount == planState.items.length;
    return InkWell(
      borderRadius: BorderRadius.vertical(top: radius.topLeft),
      onTap: () => expanded.value = !expanded.value,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          10 * scopeScale,
          6 * scopeScale,
          8 * scopeScale,
          6 * scopeScale,
        ),
        child: Row(
          children: [
            Icon(
              allDone ? Icons.task_alt_rounded : Icons.checklist_rtl_rounded,
              size: 15 * scopeScale,
              color: allDone ? AppColors.success : color,
            ),
            SizedBox(width: 6 * scopeScale),
            Text(
              context.isZh ? '执行计划' : 'Execution plan',
              style: TextStyle(
                fontSize: 11 * scopeScale,
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 8 * scopeScale),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2 * scopeScale),
                child: LinearProgressIndicator(
                  value: planState.progress,
                  minHeight: 3 * scopeScale,
                  backgroundColor: color.withValues(alpha: 0.16),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    allDone ? AppColors.success : color,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8 * scopeScale),
            Text(
              '${planState.completedCount}/${planState.items.length}',
              style: TextStyle(
                fontSize: 11 * scopeScale,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            AnimatedRotation(
              turns: expanded.value ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more_rounded,
                size: 15 * scopeScale,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 单个计划项：复用占用率指示器的字号与配色，仅用图标 + 文字区分状态。
class _PlanItemTile extends StatelessWidget {
  const _PlanItemTile({super.key, required this.index, required this.item});

  final int index;
  final AiPlanItem item;

  @override
  Widget build(BuildContext context) {
    final scopeScale = AiChatCompactScope.scaleOf(context);
    final isCompleted = item.status == AiPlanItemStatus.completed;
    final isInProgress = item.status == AiPlanItemStatus.inProgress;
    final statusColor = switch (item.status) {
      AiPlanItemStatus.completed => AppColors.success,
      AiPlanItemStatus.inProgress => AppColors.warning,
      AiPlanItemStatus.pending => context.colorScheme.onSurfaceVariant,
    };
    final icon = switch (item.status) {
      AiPlanItemStatus.completed => Icons.check_circle_rounded,
      AiPlanItemStatus.inProgress => Icons.pending_rounded,
      AiPlanItemStatus.pending => Icons.radio_button_unchecked_rounded,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: 6 * scopeScale,
        vertical: 5 * scopeScale,
      ),
      decoration: BoxDecoration(
        color: isInProgress
            ? AppColors.warning.withValues(alpha: context.isDark ? 0.10 : 0.07)
            : null,
        borderRadius: BorderRadius.circular(6 * scopeScale),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1 * scopeScale),
            // 状态切换时让图标缩放淡入，给出「这一步刚完成」的反馈。
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                icon,
                key: ValueKey(item.status),
                size: 14 * scopeScale,
                color: statusColor,
              ),
            ),
          ),
          SizedBox(width: 8 * scopeScale),
          Expanded(
            child: Text(
              '${index + 1}. ${item.title}',
              style: TextStyle(
                fontSize: 11.5 * scopeScale,
                height: 1.4,
                color: isCompleted
                    ? context.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      )
                    : context.colorScheme.onSurface,
                fontWeight: isInProgress ? FontWeight.w600 : FontWeight.w400,
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
