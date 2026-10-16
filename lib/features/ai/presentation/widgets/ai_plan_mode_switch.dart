import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/providers/plan/ai_plan_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_compact_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 「计划模式」开关（紧凑行内胶囊，与快捷操作磁贴同一套主题语言）。
///
/// 开启后 AI 会先拆解需求并产出结构化执行计划；关闭时保持原有常规交互逻辑。
class AiPlanModeSwitch extends HookConsumerWidget {
  const AiPlanModeSwitch({super.key, required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactScale = AiChatCompactScope.scaleOf(context);
    final enabled = ref.watch(
      aiPlanProvider(packageName).select((state) => state.enabled),
    );

    final accent = context.colorScheme.primary;
    final idleTint = context.colorScheme.onSurfaceVariant;
    final tint = enabled ? accent : idleTint;

    return Container(
      margin: EdgeInsets.only(right: 8.w * compactScale),
      child: InkWell(
        onTap: () => _toggle(ref, enabled),
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: enabled
                ? tint.withValues(alpha: context.isDark ? 0.18 : 0.12)
                : (context.isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: tint.withValues(alpha: enabled ? 0.35 : 0.1),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                enabled ? Icons.checklist_rounded : Icons.checklist_outlined,
                color: enabled ? accent : idleTint,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                context.isZh ? '计划模式' : 'Plan mode',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: enabled
                      ? accent
                      : context.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.8,
                        ),
                ),
              ),
              SizedBox(width: 6.w),
              SizedBox(
                width: 30.w,
                height: 18.h,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Switch(
                    value: enabled,
                    activeThumbColor: Colors.white,
                    activeTrackColor: accent,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) => _toggle(ref, enabled, next: value),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggle(WidgetRef ref, bool enabled, {bool? next}) {
    final target = next ?? !enabled;
    final notifier = ref.read(aiPlanProvider(packageName).notifier);
    if (target && ref.read(aiPlanProvider(packageName)).items.isNotEmpty) {
      // 重新开启时清掉上一轮残留的计划，避免与新计划混淆。
      notifier.clearItems();
    }
    notifier.setEnabled(target);
    ref
        .read(aiChatRuntimeProvider(packageName: packageName).notifier)
        .setPlanMode(target);
  }
}
