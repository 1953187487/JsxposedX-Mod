import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:JsxposedX/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_definition.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_tool_registry.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_action_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/disabled_tools_store.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/user_risky_tools_store.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 聊天界面快捷设置菜单：模型选择 + 工具审批 + 工具管理
class AiQuickSettingsMenu extends HookConsumerWidget {
  const AiQuickSettingsMenu({
    super.key,
    this.packageName,
    this.embedded = false,
  });

  final String? packageName;

  /// 嵌入模式：用于悬浮窗的 [OverlayPanelDialog]，由外层提供背景、圆角与滚动，
  /// 自身不再绘制底部弹窗容器，也不再强制固定高度。
  final bool embedded;

  /// 显示快捷设置底部弹窗
  static Future<void> show(BuildContext context, {String? packageName}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AiQuickSettingsMenu(packageName: packageName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? Theme.of(context).colorScheme.surfaceContainerHigh
        : Theme.of(context).colorScheme.surface;

    // 保持 aiConfigActionProvider 在菜单打开期间存活，避免异步操作时被 auto-dispose
    ref.watch(aiConfigActionProvider);
    final configAsync = ref.watch(aiConfigProvider);
    final assistantsAsync = ref.watch(aiAssistantsV2Provider);

    // 读取工具定义列表
    final toolDefs = packageName != null
        ? ref
              .watch(aiChatRuntimeProvider(packageName: packageName!))
              .toolDefinitions
        : <AiToolDefinition>[];

    final content = configAsync.when(
      loading: () => _LoadingContent(),
      error: (error, _) => _ErrorContent(
        message: error.toString(),
        onRetry: () => ref.invalidate(aiConfigProvider),
      ),
      data: (config) {
        final isBuiltin = isBuiltinAiConfig(config);
        final assistantId = 'legacy-assistant-${config.id}';
        final assistant = assistantsAsync.when(
          data: (list) => list.where((a) => a.id == assistantId).firstOrNull,
          loading: () => null,
          error: (_, __) => null,
        );

        return _MenuContent(
          config: config,
          isBuiltin: isBuiltin,
          assistant: assistant,
          toolDefinitions: toolDefs,
          embedded: embedded,
        );
      },
    );

    if (embedded) {
      return content;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: content,
    );
  }
}

class _LoadingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: Colors.red),
            SizedBox(height: 12.h),
            Text(message, style: TextStyle(fontSize: 13.sp)),
            SizedBox(height: 12.h),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _MenuContent extends HookConsumerWidget {
  const _MenuContent({
    required this.config,
    required this.isBuiltin,
    required this.assistant,
    this.toolDefinitions = const [],
    this.embedded = false,
  });

  final AiConfig config;
  final bool isBuiltin;
  final AiAssistantProfile? assistant;
  final List<AiToolDefinition> toolDefinitions;
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isZh = context.isZh;
    final currentModelId = config.moduleName.trim();
    final currentApprovalMode =
        assistant?.toolPolicy.approvalMode ?? AiToolApprovalMode.riskyOnly;
    final isDark = ref.watch(isDarkModeProvider);

    // Load available models
    final modelsAsync = ref.watch(aiModelsProvider);
    final modelsLoading = useState(false);

    // Track the selected model ID locally (for optimistic UI)
    final selectedModelId = useState(currentModelId);
    final selectedApprovalMode = useState(currentApprovalMode);
    final isSaving = useState(false);

    // Sync when config changes externally
    useEffect(() {
      selectedModelId.value = currentModelId;
      return null;
    }, [currentModelId]);

    useEffect(() {
      selectedApprovalMode.value = currentApprovalMode;
      return null;
    }, [currentApprovalMode]);

    final list = ListView(
      shrinkWrap: embedded,
      physics: embedded ? const NeverScrollableScrollPhysics() : null,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      children: [
        // Handle bar（仅底部弹窗需要；嵌入面板时由外层容器承担边框）
        if (!embedded) ...[
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: context.theme.hintColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],

          // Title
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isZh ? '快捷设置' : 'Quick Settings',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isBuiltin
                      ? (isZh
                            ? '内置配置 - $currentModelId'
                            : 'Built-in - $currentModelId')
                      : config.name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.theme.hintColor,
                  ),
                ),
              ],
            ),
          ),

          // ── Section 1: Model ──
          _SettingsSection(
            title: isZh ? '模型选择' : 'Model',
            icon: Icons.smart_toy_outlined,
            initiallyExpanded: false,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isZh ? '当前模型' : 'Current Model',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.theme.hintColor,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: modelsLoading.value
                        ? null
                        : () {
                            modelsLoading.value = true;
                            ref.invalidate(aiModelsProvider);
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                if (context.mounted) {
                                  modelsLoading.value = false;
                                }
                              },
                            );
                          },
                    icon: modelsLoading.value
                        ? SizedBox(
                            width: 14.w,
                            height: 14.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colorScheme.primary,
                            ),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            size: 16.sp,
                            color: context.colorScheme.primary,
                          ),
                    label: Text(
                      isZh ? '刷新' : 'Refresh',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              modelsAsync.when(
                loading: () => Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        isZh ? '加载模型列表...' : 'Loading models...',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: context.theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                error: (error, _) => _infoRow(
                  context,
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.orange,
                  label: isZh ? '无法加载模型列表' : 'Cannot load models',
                  detail: error.toString(),
                  isDark: isDark,
                ),
                data: (models) {
                  if (models.isEmpty) {
                    return _infoRow(
                      context,
                      icon: Icons.info_outline,
                      iconColor: context.theme.hintColor,
                      label: isZh ? '暂无可用模型' : 'No models available',
                      isDark: isDark,
                    );
                  }

                  final orderedModels = [...models];
                  final selectedIndex = orderedModels.indexWhere(
                    (model) => model.id == selectedModelId.value,
                  );
                  if (selectedIndex > 0) {
                    final selectedModel = orderedModels.removeAt(selectedIndex);
                    orderedModels.insert(0, selectedModel);
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderedModels.length,
                    itemBuilder: (context, index) {
                      final model = orderedModels[index];
                      final isSelected = model.id == selectedModelId.value;
                      return _ModelListItem(
                        model: model,
                        isSelected: isSelected,
                        isSaving: isSaving.value && isSelected,
                        onTap: () {
                          if (isSelected || isSaving.value) return;
                          // 立即更新UI，提供即时反馈
                          selectedModelId.value = model.id;
                          isSaving.value = true;

                          // 异步执行保存操作，不阻塞主线程
                          Future.microtask(() async {
                            try {
                              final updatedConfig = config.copyWith(
                                moduleName: model.id,
                              );
                              await ref
                                  .read(aiConfigActionProvider.notifier)
                                  .updateConfig(updatedConfig);
                              if (!context.mounted) return;
                              ref.invalidate(aiChatRuntimeStatusProvider);
                              if (context.mounted) {
                                ToastMessage.show(
                                  isZh ? '模型已切换' : 'Model switched',
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              // 回滚UI状态
                              selectedModelId.value = currentModelId;
                              if (context.mounted) {
                                ToastMessage.show(
                                  isZh ? '切换失败: $e' : 'Switch failed: $e',
                                );
                              }
                            } finally {
                              if (context.mounted) {
                                isSaving.value = false;
                              }
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Section 2: Tool Approval ──
          _SettingsSection(
            title: isZh ? '工具审批' : 'Tool Approval',
            icon: Icons.security_outlined,
            initiallyExpanded: false,
            children: [
              Text(
                isZh
                    ? '控制 AI 执行工具前是否需要用户确认'
                    : 'Control whether AI tool calls require user approval',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: context.theme.hintColor,
                ),
              ),
              SizedBox(height: 12.h),

              // Approval mode selector
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: AiToolApprovalMode.values.map((mode) {
                    final isSelected = mode == selectedApprovalMode.value;
                    final label = _approvalModeShortLabel(context, mode);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (isSelected || isSaving.value) return;
                          // 立即更新UI，提供即时反馈
                          selectedApprovalMode.value = mode;
                          isSaving.value = true;

                          // 异步执行保存操作，不阻塞主线程
                          Future.microtask(() async {
                            try {
                              await ref
                                  .read(aiConfigActionProvider.notifier)
                                  .saveAssistantSettings(
                                    configId: config.id,
                                    systemPrompt: assistant?.systemPrompt,
                                    approvalMode: mode,
                                    maxToolRounds:
                                        assistant?.toolPolicy.maxRounds ??
                                        kDefaultMaxToolRounds,
                                  );
                              if (context.mounted) {
                                ref.invalidate(aiAssistantsV2Provider);
                                ToastMessage.show(
                                  isZh ? '审批模式已更新' : 'Approval mode updated',
                                );
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              // 回滚UI状态
                              selectedApprovalMode.value = currentApprovalMode;
                              if (context.mounted) {
                                ToastMessage.show(
                                  isZh ? '更新失败: $e' : 'Update failed: $e',
                                );
                              }
                            } finally {
                              if (context.mounted) {
                                isSaving.value = false;
                              }
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                      ? context.colorScheme.primary
                                      : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: isSelected && !isDark
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.06,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? (isDark
                                        ? Colors.white
                                        : context.colorScheme.primary)
                                  : context.theme.hintColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Approval mode description
              SizedBox(height: 10.h),
              _approvalModeDescription(context, selectedApprovalMode.value),

              SizedBox(height: 20.h),

              // ── Tool Management ──
              _sectionHeader(
                context,
                zh: '可用工具列表',
                en: 'Available Tools',
                icon: Icons.build_outlined,
              ),
              SizedBox(height: 8.h),
              Text(
                isZh
                    ? '启用或禁用 AI 可调用的工具，更改后下次会话生效'
                    : 'Enable or disable tools that AI can call. Changes apply on next session.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: context.theme.hintColor,
                ),
              ),
              SizedBox(height: 12.h),

              if (toolDefinitions.isEmpty)
                _infoRow(
                  context,
                  icon: Icons.info_outline,
                  iconColor: context.colorScheme.primary.withValues(alpha: 0.7),
                  label: isZh
                      ? '当前配置下无可用工具'
                      : 'No tools available for this configuration',
                  detail: isZh
                      ? '工具列表将在进入聊天后加载'
                      : 'Tool list will load after entering chat',
                  isDark: isDark,
                )
              else
                _ToolList(
                  configId: config.id,
                  toolDefinitions: toolDefinitions,
                  isSaving: isSaving,
                ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      );

    if (embedded) {
      return list;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: list,
    );
  }

  static String _approvalModeShortLabel(
    BuildContext context,
    AiToolApprovalMode mode,
  ) {
    if (context.isZh) {
      return switch (mode) {
        AiToolApprovalMode.never => '不审批',
        AiToolApprovalMode.riskyOnly => '仅危险',
        AiToolApprovalMode.always => '始终审批',
      };
    }
    return switch (mode) {
      AiToolApprovalMode.never => 'Never',
      AiToolApprovalMode.riskyOnly => 'Risky only',
      AiToolApprovalMode.always => 'Always',
    };
  }

  static Widget _approvalModeDescription(
    BuildContext context,
    AiToolApprovalMode mode,
  ) {
    final isZh = context.isZh;
    final (icon, text) = switch (mode) {
      AiToolApprovalMode.never => (
        Icons.speed_rounded,
        isZh
            ? 'AI 可直接执行所有工具，无需确认'
            : 'AI executes all tools directly without confirmation',
      ),
      AiToolApprovalMode.riskyOnly => (
        Icons.shield_outlined,
        isZh
            ? 'AI 调用工具时需你手动确认每个操作'
            : 'You must manually approve each tool call',
      ),
      AiToolApprovalMode.always => (
        Icons.verified_user_rounded,
        isZh
            ? '每次工具调用都需要你确认后再执行'
            : 'Every tool call requires your confirmation',
      ),
    };

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: context.colorScheme.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.4,
                color: context.textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _sectionHeader(
    BuildContext context, {
    required String zh,
    required String en,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: context.colorScheme.primary),
        SizedBox(width: 8.w),
        Text(
          context.isZh ? zh : en,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: context.textTheme.titleMedium?.color,
          ),
        ),
      ],
    );
  }

  static Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    String? detail,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey[300]!,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: iconColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (detail != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: context.theme.hintColor,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelListItem extends StatelessWidget {
  const _ModelListItem({
    required this.model,
    required this.isSelected,
    required this.isSaving,
    required this.onTap,
  });

  final dynamic model; // AiModel from config provider
  final bool isSelected;
  final bool isSaving;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final modelId = (model.id as String?) ?? '';
    final isDark = context.isDark;
    final brand = AiBrand.resolve(modelName: modelId);
    final brandColor =
        brand?.resolveColor(isDark: isDark) ?? context.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? brandColor.withValues(alpha: isDark ? 0.16 : 0.09)
            : (isDark ? context.colorScheme.surfaceContainerLow : Colors.white),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected
              ? brandColor.withValues(alpha: 0.55)
              : context.colorScheme.outlineVariant.withValues(alpha: 0.55),
          width: isSelected ? 1.2 : 0.8,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Center(
                    child: AiBrandIcon(
                      brand: brand,
                      size: 21,
                      fallbackIcon: Icons.memory_rounded,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modelId,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.25,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected ? brandColor : null,
                        ),
                      ),
                      if (model.contextTokens != null) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.data_object_rounded,
                              size: 12.sp,
                              color: context.theme.hintColor,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              '${model.contextTokens} tokens',
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                color: context.theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                if (isSaving)
                  SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: brandColor,
                    ),
                  )
                else
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? brandColor
                          : context.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSelected
                          ? Icons.check_rounded
                          : Icons.chevron_right_rounded,
                      size: isSelected ? 15.sp : 17.sp,
                      color: isSelected
                          ? Colors.white
                          : context.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolList extends HookConsumerWidget {
  const _ToolList({
    required this.configId,
    required this.toolDefinitions,
    required this.isSaving,
  });

  final String configId;
  final List<AiToolDefinition> toolDefinitions;
  final ValueNotifier<bool> isSaving;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isZh = context.isZh;
    final isDark = ref.watch(isDarkModeProvider);

    // 菜单打开时从持久化存储加载数据
    useEffect(() {
      Future.microtask(() async {
        await ref
            .read(disabledToolsStoreProvider.notifier)
            .loadDisabledTools(configId);
        await ref
            .read(userRiskyToolsStoreProvider.notifier)
            .loadRisky(configId);
      });
      return null;
    }, [configId]);

    final disabledTools =
        ref.watch(disabledToolsStoreProvider)[configId] ?? <String>{};
    final userRisky =
        ref.watch(userRiskyToolsStoreProvider)[configId] ?? <String, bool>{};

    // 使用 useMemoized 缓存分组计算，避免每次重建都重新计算
    final grouped = useMemoized(() {
      final result = <AiToolCategory, List<AiToolDefinition>>{};
      for (final tool in toolDefinitions) {
        final cat =
            AiToolRegistry.categoryOf(tool.name) ?? AiToolCategory.reverse;
        result.putIfAbsent(cat, () => []).add(tool);
      }
      return result;
    }, [toolDefinitions]);

    final categoryLabels = useMemoized(
      () => <AiToolCategory, String>{
        AiToolCategory.reverse: isZh ? 'APK 逆向分析' : 'APK Reverse',
        AiToolCategory.scriptLifecycle: isZh ? '脚本生命周期' : 'Script Lifecycle',
        AiToolCategory.contentProduction: isZh ? '内容生产' : 'Content Production',
        AiToolCategory.dataAnalysis: isZh ? '数据分析' : 'Data Analysis',
        AiToolCategory.systemControl: isZh ? '系统管控' : 'System Control',
        AiToolCategory.multimodal: isZh ? '多模态' : 'Multimodal',
      },
      [isZh],
    );

    final entries = useMemoized(() => grouped.entries.toList(), [grouped]);

    // 计算总项目数：每个分类标题 + 该分类下的所有工具
    final totalItemCount = useMemoized(() {
      int count = 0;
      for (final group in entries) {
        count += 1 + group.value.length; // 分类标题 + 工具项
      }
      return count;
    }, [entries]);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalItemCount,
        itemBuilder: (context, index) {
          // 找到当前索引对应的分类和工具
          int currentIndex = 0;
          for (var gi = 0; gi < entries.length; gi++) {
            final group = entries[gi];
            final cat = group.key;
            final toolsInCat = group.value;
            final isLastGroup = gi == entries.length - 1;

            // 检查是否是分类标题
            if (index == currentIndex) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 8.h,
                  bottom: 4.h,
                ),
                child: Text(
                  categoryLabels[cat] ?? cat.name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.grey[700],
                  ),
                ),
              );
            }
            currentIndex++;

            // 检查是否是工具项
            for (var ti = 0; ti < toolsInCat.length; ti++) {
              if (index == currentIndex) {
                final tool = toolsInCat[ti];
                final isLast = isLastGroup && ti == toolsInCat.length - 1;
                final isEnabled = !disabledTools.contains(tool.name);
                final isRisky = userRisky[tool.name] ?? (tool.isRisky == true);

                return _ToolListItem(
                  tool: tool,
                  isEnabled: isEnabled,
                  isRisky: isRisky,
                  isLast: isLast,
                  onToggleEnabled: () {
                    if (isSaving.value) return;
                    isSaving.value = true;

                    Future.microtask(() async {
                      try {
                        await ref
                            .read(disabledToolsStoreProvider.notifier)
                            .toggleTool(configId, tool.name);
                        if (context.mounted) {
                          ToastMessage.show(
                            isZh
                                ? '${tool.name} ${isEnabled ? "已禁用" : "已启用"}'
                                : '${tool.name} ${isEnabled ? "disabled" : "enabled"}',
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ToastMessage.show(isZh ? '操作失败: $e' : 'Failed: $e');
                        }
                      } finally {
                        if (context.mounted) {
                          isSaving.value = false;
                        }
                      }
                    });
                  },
                  onToggleRisky: () {
                    if (isSaving.value) return;
                    isSaving.value = true;

                    Future.microtask(() async {
                      try {
                        await ref
                            .read(userRiskyToolsStoreProvider.notifier)
                            .setRisky(configId, tool.name, !isRisky);
                        if (context.mounted) {
                          ToastMessage.show(
                            isZh
                                ? '${tool.name} ${isRisky ? "标记为安全" : "标记为危险"}'
                                : '${tool.name} ${isRisky ? "marked safe" : "marked risky"}',
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ToastMessage.show(isZh ? '操作失败: $e' : 'Failed: $e');
                        }
                      } finally {
                        if (context.mounted) {
                          isSaving.value = false;
                        }
                      }
                    });
                  },
                );
              }
              currentIndex++;
            }
          }

          // 不应该到达这里
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ToolListItem extends HookWidget {
  const _ToolListItem({
    required this.tool,
    required this.isEnabled,
    required this.isRisky,
    required this.isLast,
    required this.onToggleEnabled,
    required this.onToggleRisky,
  });

  final AiToolDefinition tool;
  final bool isEnabled;
  final bool isRisky;
  final bool isLast;
  final VoidCallback onToggleEnabled;
  final VoidCallback onToggleRisky;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.grey[300]!,
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        tool.name,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                          color: isEnabled ? null : context.theme.hintColor,
                        ),
                      ),
                    ),
                    if (isRisky) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(3.r),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text('⚠', style: TextStyle(fontSize: 10.sp)),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () => isExpanded.value = !isExpanded.value,
                  child: Text(
                    context.isZh || tool.descriptionEn.isEmpty
                        ? tool.description
                        : tool.descriptionEn,
                    maxLines: isExpanded.value ? null : 2,
                    overflow: isExpanded.value
                        ? TextOverflow.clip
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isEnabled
                          ? context.textTheme.bodySmall?.color
                          : context.theme.hintColor.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            children: [
              Text(
                context.isZh ? '启用' : 'On',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: context.theme.hintColor,
                ),
              ),
              SizedBox(
                height: 28.h,
                child: Switch(
                  value: isEnabled,
                  onChanged: (_) => onToggleEnabled(),
                  activeColor: context.colorScheme.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          SizedBox(width: 4.w),
          Column(
            children: [
              Text(
                context.isZh ? '危险' : 'Risky',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: context.theme.hintColor,
                ),
              ),
              SizedBox(
                height: 28.h,
                child: Switch(
                  value: isRisky,
                  onChanged: (_) => onToggleRisky(),
                  activeColor: Colors.orange,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 可折叠的设置分区，方便后续扩展更多功能
class _SettingsSection extends StatefulWidget {
  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
    this.initiallyExpanded = true,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  State<_SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<_SettingsSection> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? context.colorScheme.surfaceContainerLow
            : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.06)
              : context.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 18.sp,
                    color: context.colorScheme.primary,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: context.textTheme.titleMedium?.color,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20.sp,
                      color: context.theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children,
              ),
            ),
        ],
      ),
    );
  }
}
