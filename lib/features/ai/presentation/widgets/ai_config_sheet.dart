import 'dart:async';

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/app_bottom_sheet.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_model.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_action_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

final _sheetFeedbackProvider =
    Provider.autoDispose<ValueNotifier<_SheetFeedback?>>((ref) {
      final notifier = ValueNotifier<_SheetFeedback?>(null);
      ref.onDispose(notifier.dispose);
      return notifier;
    });

class _SheetFeedback {
  const _SheetFeedback({
    required this.scopeKey,
    required this.message,
    required this.isError,
  });

  final String? scopeKey;
  final String message;
  final bool isError;
}

/// AI 配置弹窗内容组件
class AIConfigSheet extends HookConsumerWidget {
  const AIConfigSheet({
    super.key,
    required this.formKey,
    required this.testActionNotifier,
  });

  final GlobalKey<FormBuilderState> formKey;
  final ValueNotifier<Future<void> Function()?> testActionNotifier;
  static bool _isShowing = false;

  static void _showSheetFeedback(
    WidgetRef ref,
    String scopeKey,
    String message, {
    bool isError = false,
  }) {
    ref.read(_sheetFeedbackProvider).value = _SheetFeedback(
      scopeKey: scopeKey,
      message: message,
      isError: isError,
    );
  }

  /// 显示 AI 配置弹窗
  static Future<void> show(BuildContext context) async {
    if (_isShowing) return;
    _isShowing = true;
    final formKey = GlobalKey<FormBuilderState>();
    final testActionNotifier = ValueNotifier<Future<void> Function()?>(null);
    try {
      await AppBottomSheet.show<void>(
        context: context,
        title: context.l10n.aiConfigTitle,
        action: [
          Row(
            children: [
              TextButton(
                onPressed: () => UrlHelper.openUrlInBrowser(
                  url:
                      "https://www.yuque.com/ababa-haoqq/hake3e/npt913l7r1goxsoi?singleDoc",
                ),
                child: Text(context.l10n.aiTutorial),
              ),
              TextButton(
                onPressed: () async {
                  final action = testActionNotifier.value;
                  if (action != null) await action();
                },
                child: Text(context.l10n.test),
              ),
            ],
          ),
        ],
        child: AIConfigSheet(
          formKey: formKey,
          testActionNotifier: testActionNotifier,
        ),
      );
    } finally {
      // The notifier has no external listeners; once the route and its
      // header action are gone it is reclaimed with the sheet. Avoid
      // disposing here because Hook cleanup may still clear its value while
      // Flutter is deactivating the route tree.
      _isShowing = false;
    }
  }

  /// 从表单值构建 AiConfig 对象
  static AiConfig _buildConfigFromFormValues(
    Map<String, dynamic> values,
    String id, {
    int defaultMaxToken = 0,
    double defaultTemperature = -1,
    double defaultMemoryRounds = 0,
  }) {
    return AiConfig(
      id: id,
      name: values["name"] ?? "",
      apiUrl: values["api"] ?? "",
      apiKey: values["api_key"] ?? "",
      moduleName: values["module_name"] ?? "",
      // Kept in the compatibility model; it is no longer user-editable.
      maxToken: defaultMaxToken > 0 ? defaultMaxToken : 0,
      // These fields only bridge old persisted configs. Negative temperature
      // means unspecified; context policy owns history selection.
      temperature: defaultTemperature,
      memoryRounds: defaultMemoryRounds,
      apiType: AiApiType.fromString(values["api_type"]?.toString() ?? "openai"),
    );
  }

  /// 凭据来源标识：同一来源（地址 + Key + API 类型）下模型列表才具有可比性。
  static String _modelSourceKeyOf(
    String apiUrl,
    String apiKey,
    AiApiType apiType,
  ) => '${apiUrl.trim()}|${apiKey.trim()}|${apiType.name}';

  static String _apiTypeLabel(BuildContext context, AiApiType type) {
    switch (type) {
      case AiApiType.openai:
        return context.l10n.aiApiTypeOpenAI;
      case AiApiType.openaiResponses:
        return context.l10n.aiApiTypeOpenAIResponses;
      case AiApiType.anthropic:
        return context.l10n.aiApiTypeAnthropic;
    }
  }

  static Widget _sectionHeader(
    BuildContext context, {
    required String zh,
    required String en,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            context.isZh ? zh : en,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: context.theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _feedbackBanner(BuildContext context, _SheetFeedback feedback) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: feedback.isError
            ? Colors.red.withValues(alpha: 0.10)
            : context.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: feedback.isError
              ? Colors.red.withValues(alpha: 0.30)
              : context.colorScheme.primary.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            feedback.isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            size: 18.sp,
            color: feedback.isError ? Colors.red : context.colorScheme.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              feedback.message,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.35,
                color: feedback.isError
                    ? Colors.red
                    : context.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _contextModeLabel(BuildContext context, AiContextMode mode) {
    if (context.isZh) {
      return switch (mode) {
        AiContextMode.tokenBudget => 'Token 预算',
        AiContextMode.recentMessages => '最近消息',
        AiContextMode.fullHistory => '完整历史',
      };
    }
    return switch (mode) {
      AiContextMode.tokenBudget => 'Token budget',
      AiContextMode.recentMessages => 'Recent messages',
      AiContextMode.fullHistory => 'Full history',
    };
  }

  static String _approvalModeLabel(
    BuildContext context,
    AiToolApprovalMode mode,
  ) {
    if (context.isZh) {
      return switch (mode) {
        AiToolApprovalMode.never => '从不允许',
        AiToolApprovalMode.riskyOnly => '仅危险操作确认',
        AiToolApprovalMode.always => '始终确认',
      };
    }
    return switch (mode) {
      AiToolApprovalMode.never => 'Never',
      AiToolApprovalMode.riskyOnly => 'Risky tools only',
      AiToolApprovalMode.always => 'Always',
    };
  }

  static AiConfig _emptyFormConfig() {
    return const AiConfig(
      id: '',
      name: '',
      apiUrl: '',
      apiKey: '',
      moduleName: '',
      maxToken: 0,
      temperature: -1,
      memoryRounds: 0,
      apiType: AiApiType.openai,
    );
  }

  static Map<String, dynamic> _formValuesFromConfig(
    AiConfig config, {
    AiAssistantProfile? assistant,
  }) {
    final contextPolicy = assistant?.contextPolicy;
    final toolPolicy = assistant?.toolPolicy;
    return {
      'name': config.name,
      'api': config.apiUrl,
      'api_key': config.apiKey,
      'module_name': config.moduleName,
      'api_type': config.apiType.name,
      'assistant_system_prompt': assistant?.systemPrompt ?? '',
      'assistant_context_mode':
          contextPolicy?.mode.name ?? AiContextMode.tokenBudget.name,
      'assistant_recent_limit':
          contextPolicy?.recentMessageLimit?.toString() ?? '',
      'assistant_tool_approval':
          toolPolicy?.approvalMode.name ?? AiToolApprovalMode.riskyOnly.name,
      'assistant_tool_rounds': (toolPolicy?.maxRounds ?? kDefaultMaxToolRounds)
          .toString(),
      'assistant_fallback_context': (contextPolicy?.fallbackContextTokens ??
              kDefaultFallbackContextTokens)
          .toString(),
    };
  }

  static BuiltinAiConfigSpec? _builtinSpecOf(AiConfig config) {
    return getBuiltinAiConfigSpecById(config.id);
  }

  static AiModel _modelFromDefinition(AiModelDefinition definition) {
    return AiModel(
      id: definition.id,
      object: 'model',
      created: 0,
      ownedBy: '',
      supportedEndpointTypes: const [],
      contextTokens: definition.limits.contextTokens,
      maxOutputTokens: definition.limits.maxOutputTokens,
    );
  }

  static Future<AiConfig> _resolveConfigWithAvailableModel(
    WidgetRef ref,
    AiConfig config, {
    bool syncFormModelName = false,
    GlobalKey<FormBuilderState>? formKey,
    ValueNotifier<List<AiModel>>? modelsSink,
  }) async {
    final models = await ref
        .read(aiConfigQueryRepositoryProvider)
        .getModels(config: config, forceRefresh: true);
    modelsSink?.value = models;
    if (models.isEmpty) {
      throw Exception('No available models returned by the API');
    }

    final currentModel = config.moduleName.trim();
    final resolvedModel = models.any((model) => model.id == currentModel)
        ? currentModel
        : models.first.id;

    if (syncFormModelName && resolvedModel != currentModel) {
      final formState = formKey?.currentState;
      if (formState != null && formState.fields.containsKey('module_name')) {
        formState.patchValue({'module_name': resolvedModel});
      }
    }

    return config.copyWith(moduleName: resolvedModel);
  }

  /// 处理测试连接逻辑
  static Future<void> _handleTest(
    BuildContext context,
    WidgetRef ref, {
    required String scopeKey,
    required GlobalKey<FormBuilderState> formKey,
    int defaultMaxToken = 0,
    double defaultTemperature = -1,
    double defaultMemoryRounds = 0,
  }) async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final values = formKey.currentState!.value;
      final config = _buildConfigFromFormValues(
        values,
        const Uuid().v4(),
        defaultMaxToken: defaultMaxToken,
        defaultTemperature: defaultTemperature,
        defaultMemoryRounds: defaultMemoryRounds,
      );

      _showSheetFeedback(ref, scopeKey, context.l10n.aiTestConnecting);
      try {
        final resolvedConfig = await _resolveConfigWithAvailableModel(
          ref,
          config,
          syncFormModelName: true,
          formKey: formKey,
        );
        final result = await ref
            .read(aiChatRuntimeProvider(packageName: 'temp').notifier)
            .testConnection(resolvedConfig);
        if (context.mounted) {
          _showSheetFeedback(ref, scopeKey, context.l10n.aiTestSuccess(result));
        }
      } catch (e) {
        if (context.mounted) {
          _showSheetFeedback(
            ref,
            scopeKey,
            context.l10n.aiTestFailed(e.toString()),
            isError: true,
          );
        }
      }
    }
  }

  static Future<void> _handleBuiltinTest({
    required BuildContext context,
    required WidgetRef ref,
    required String scopeKey,
    required BuiltinAiConfigSpec? builtinSpec,
    required AiConfig formConfig,
    required String apiKey,
  }) async {
    if (apiKey.isEmpty) {
      _showSheetFeedback(
        ref,
        scopeKey,
        context.l10n.cannotBeEmpty('API Key'),
        isError: true,
      );
      return;
    }

    final builtinConfig =
        builtinSpec?.toConfig(apiKey: apiKey) ??
        formConfig.copyWith(apiKey: apiKey);
    _showSheetFeedback(ref, scopeKey, context.l10n.aiTestConnecting);
    try {
      final resolvedConfig = await _resolveConfigWithAvailableModel(
        ref,
        builtinConfig,
      );
      final result = await ref
          .read(aiChatRuntimeProvider(packageName: 'temp').notifier)
          .testConnection(resolvedConfig);
      if (context.mounted) {
        _showSheetFeedback(ref, scopeKey, context.l10n.aiTestSuccess(result));
      }
    } catch (e) {
      if (context.mounted) {
        _showSheetFeedback(
          ref,
          scopeKey,
          context.l10n.aiTestFailed(e.toString()),
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiConfigAsync = ref.watch(aiConfigProvider);
    final configListAsync = ref.watch(aiConfigListProvider);
    final assistantsAsync = ref.watch(aiAssistantsV2Provider);

    // editingConfig: null = 新建模式, non-null = 编辑某个已有配置
    // 用 useState 管理，避免引入额外的全局 provider
    final editingConfig = useState<AiConfig?>(null);
    final isNewMode = useState<bool>(false);
    final builtinApiKeyController = useTextEditingController();
    final builtinApiKeyValue = useValueListenable(builtinApiKeyController);
    final lastLoadedBuiltinApiKey = useRef<String?>(null);
    final currentConfig = aiConfigAsync.value;
    final sheetFeedback = useValueListenable(ref.watch(_sheetFeedbackProvider));
    final availableModels = useState<List<AiModel>>([]);
    final modelsLoading = useState(false);
    // 记录当前 availableModels 的实际来源（apiUrl|apiKey|apiType）。用于区分配置
    // 列表是来自「已保存配置」还是来自用户在表单里临时填写的新凭据。
    final availableModelsSourceKey = useRef<String?>(null);
    final modelsSourceKey = useRef<String?>(null);
    final selectedContextMode = useState(AiContextMode.tokenBudget);
    final contextSourceKey = useRef<String?>(null);
    final formSourceKey = useRef<String?>(null);

    // 统一同步内置配置输入框，避免在多个位置重复写 controller
    useEffect(() {
      final selectedConfig = isNewMode.value
          ? null
          : (editingConfig.value ?? currentConfig);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (selectedConfig != null && isBuiltinAiConfig(selectedConfig)) {
          if (lastLoadedBuiltinApiKey.value != selectedConfig.apiKey) {
            builtinApiKeyController.text = selectedConfig.apiKey;
            lastLoadedBuiltinApiKey.value = selectedConfig.apiKey;
          }
          return;
        }

        if (lastLoadedBuiltinApiKey.value != null ||
            builtinApiKeyController.text.isNotEmpty) {
          builtinApiKeyController.clear();
          lastLoadedBuiltinApiKey.value = null;
        }
      });
      return null;
    }, [isNewMode.value, editingConfig.value, currentConfig]);

    ref.listen(aiConfigActionProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) => _showSheetFeedback(
          ref,
          'provider_error',
          error.toString(),
          isError: true,
        ),
      );
    });

    return aiConfigAsync.when(
      loading: () => SizedBox(height: 200.h, child: const Loading()),
      error: (error, stack) => SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: RefError(
            error: error,
            onRetry: () => ref.invalidate(aiConfigProvider),
          ),
        ),
      ),
      data: (currentConfig) {
        return configListAsync.when(
          loading: () => SizedBox(height: 200.h, child: const Loading()),
          error: (error, stack) => SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: RefError(
                error: error,
                onRetry: () => ref.invalidate(aiConfigListProvider),
              ),
            ),
          ),
          data: (configList) {
            // 确定表单展示的配置：新建模式用空白，编辑模式用选中的，默认用当前配置
            final formConfig = isNewMode.value
                ? _emptyFormConfig()
                : (editingConfig.value ?? currentConfig);

            Future<void> loadModels() async {
              final formState = formKey.currentState;
              if (formState == null) return;
              formState.save();
              final values = formState.value;
              final apiUrl = values['api']?.toString().trim() ?? '';
              final apiKey = values['api_key']?.toString().trim() ?? '';
              if (apiUrl.isEmpty || apiKey.isEmpty) {
                _showSheetFeedback(
                  ref,
                  'models',
                  context.isZh
                      ? '请先填写 API 地址和 API Key'
                      : 'Enter API URL and API key first',
                  isError: true,
                );
                return;
              }
              modelsLoading.value = true;
              try {
                final config = _buildConfigFromFormValues(
                  values,
                  formConfig.id.isEmpty ? const Uuid().v4() : formConfig.id,
                  defaultMaxToken: formConfig.maxToken,
                  defaultTemperature: formConfig.temperature,
                  defaultMemoryRounds: formConfig.memoryRounds,
                );
                final models = await ref
                    .read(aiConfigQueryRepositoryProvider)
                    .getModels(config: config, forceRefresh: true);
                if (!context.mounted) return;
                availableModels.value = models;
                // 标记列表来源为「表单当前填写的凭据」，便于判断它与已保存的
                // 配置是否属于同一来源。
                availableModelsSourceKey.value = _modelSourceKeyOf(
                  config.apiUrl,
                  config.apiKey,
                  config.apiType,
                );
                // 凭据已变更（例如换了新的 API Key）时，旧的模型名属于上一个
                // 来源，不能继续作为选中值，否则下拉会悬挂一个不属于当前列表
                // 的模型名。此时回落到新列表的首项，让用户重新选择。
                final savedSourceKey = _modelSourceKeyOf(
                  formConfig.apiUrl,
                  formConfig.apiKey,
                  formConfig.apiType,
                );
                if (availableModelsSourceKey.value != savedSourceKey) {
                  final currentModelId =
                      (formState.value['module_name'] ?? '')
                          .toString()
                          .trim();
                  if (currentModelId.isNotEmpty &&
                      !models.any((model) => model.id == currentModelId)) {
                    formState.patchValue({
                      'module_name': models.isNotEmpty ? models.first.id : '',
                    });
                  }
                }
                if (models.isEmpty) {
                  _showSheetFeedback(
                    ref,
                    'models',
                    context.isZh
                        ? '服务端没有返回可用模型'
                        : 'No models returned by the service',
                    isError: true,
                  );
                }
              } catch (error) {
                if (!context.mounted) return;
                _showSheetFeedback(
                  ref,
                  'models',
                  context.isZh
                      ? '获取模型列表失败：$error'
                      : 'Failed to load models: $error',
                  isError: true,
                );
              } finally {
                if (context.mounted) {
                  modelsLoading.value = false;
                }
              }
            }

            final modelItems = availableModels.value;
            final savedModelId = formConfig.moduleName.trim();
            // 仅当当前列表与「已保存的配置」来自同一凭据时，旧模型名才与列表
            // 具有可比性；若用户在表单里改了地址/Key 后刷新，列表已属于另一个
            // 来源，此时把旧模型名混进来并标注「已保存」会严重误导用户。
            final listFromSavedConfig =
                availableModelsSourceKey.value ==
                _modelSourceKeyOf(
                  formConfig.apiUrl,
                  formConfig.apiKey,
                  formConfig.apiType,
                );
            final savedModelMissing =
                savedModelId.isNotEmpty &&
                !modelItems.any((model) => model.id == savedModelId);
            final modelDropdownItems = <DropdownMenuItem<String>>[
              ...modelItems.map(
                (model) => DropdownMenuItem<String>(
                  value: model.id,
                  child: Text(model.id, overflow: TextOverflow.ellipsis),
                ),
              ),
            ];
            // Keep a persisted model selectable while a provider refresh is
            // pending or when the provider no longer advertises that model.
            if (listFromSavedConfig && savedModelMissing) {
              modelDropdownItems.insert(
                0,
                DropdownMenuItem<String>(
                  value: savedModelId,
                  child: Text(
                    '$savedModelId (${context.isZh ? '已保存' : 'saved'})',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }
            AiAssistantProfile? formAssistant;
            final assistants = assistantsAsync.when(
              data: (value) => value,
              loading: () => const <AiAssistantProfile>[],
              error: (_, _) => const <AiAssistantProfile>[],
            );
            for (final assistant in assistants) {
              if (assistant.id == 'legacy-assistant-${formConfig.id}') {
                formAssistant = assistant;
                break;
              }
            }
            final initialValue = _formValuesFromConfig(
              formConfig,
              assistant: formAssistant,
            );
            final nextFormSourceKey = [
              isNewMode.value ? 'new' : 'edit',
              formConfig.id,
              formAssistant?.updatedAt.toIso8601String() ?? '',
            ].join('|');
            useEffect(() {
              if (formSourceKey.value == nextFormSourceKey) return null;
              formSourceKey.value = nextFormSourceKey;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                formKey.currentState?.patchValue(initialValue);
              });
              return null;
            }, [nextFormSourceKey]);
            final isBuiltinEditing = isBuiltinAiConfig(formConfig);
            final builtinSpec = _builtinSpecOf(formConfig);
            final modelSourceKey = [
              formConfig.id,
              formConfig.apiUrl.trim(),
              formConfig.apiKey.trim(),
              formConfig.apiType.name,
            ].join('|');

            final contextKey = [
              formConfig.id,
              formAssistant?.updatedAt.toIso8601String() ?? '',
            ].join('|');
            useEffect(() {
              if (contextSourceKey.value == contextKey) return null;
              contextSourceKey.value = contextKey;
              final mode =
                  formAssistant?.contextPolicy.mode ??
                  AiContextMode.tokenBudget;
              selectedContextMode.value = mode;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                formKey.currentState?.patchValue({
                  'assistant_context_mode': mode.name,
                  'assistant_recent_limit':
                      formAssistant?.contextPolicy.recentMessageLimit
                          ?.toString() ??
                      '',
                });
              });
              return null;
            }, [contextKey]);

            useEffect(() {
              if (modelsSourceKey.value == modelSourceKey) {
                return null;
              }
              modelsSourceKey.value = modelSourceKey;
              availableModels.value = const <AiModel>[];
              if (isBuiltinEditing || formConfig.id.isEmpty) return null;

              // Restore the last discovered catalog immediately. This keeps
              // every saved model selectable while the provider is offline or
              // the models endpoint is temporarily unavailable.
              unawaited(() async {
                try {
                  final definitions = await ref.read(
                    aiModelsV2Provider(
                      'legacy-connection-${formConfig.id}',
                    ).future,
                  );
                  if (!context.mounted ||
                      modelsSourceKey.value != modelSourceKey) {
                    return;
                  }
                  availableModels.value = definitions
                      .map(_modelFromDefinition)
                      .toList(growable: false);
                  // 目录来自已保存配置的 connection，视为「同一来源」，这样
                  // provider 离线时旧模型仍作为「已保存」项保持可选中。
                  availableModelsSourceKey.value = _modelSourceKeyOf(
                    formConfig.apiUrl,
                    formConfig.apiKey,
                    formConfig.apiType,
                  );
                } catch (_) {
                  // A missing catalog is expected for a brand-new config.
                }
              }());

              if (formConfig.apiUrl.trim().isNotEmpty &&
                  formConfig.apiKey.trim().isNotEmpty) {
                unawaited(loadModels());
              }
              return null;
            }, [isBuiltinEditing, modelSourceKey]);

            final feedbackScopeKey = [
              isNewMode.value ? 'new' : 'edit',
              editingConfig.value?.id ?? currentConfig.id,
              formConfig.id,
              formConfig.name,
              formConfig.apiUrl,
              formConfig.moduleName,
              formConfig.apiType.name,
              if (isBuiltinEditing) builtinApiKeyValue.text,
            ].join('|');

            Future<void> handleSheetTest() async {
              if (isBuiltinEditing) {
                await _handleBuiltinTest(
                  context: context,
                  ref: ref,
                  scopeKey: feedbackScopeKey,
                  builtinSpec: builtinSpec,
                  formConfig: formConfig,
                  apiKey: builtinApiKeyController.text.trim(),
                );
                return;
              }
              await _handleTest(
                context,
                ref,
                scopeKey: feedbackScopeKey,
                formKey: formKey,
                defaultMaxToken: formConfig.maxToken,
                defaultTemperature: formConfig.temperature,
                defaultMemoryRounds: formConfig.memoryRounds,
              );
            }

            useEffect(
              () {
                testActionNotifier.value = handleSheetTest;
                return () {
                  testActionNotifier.value = null;
                };
              },
              [
                isBuiltinEditing,
                formConfig.id,
                formConfig.apiUrl,
                formConfig.moduleName,
                formConfig.apiType.name,
                builtinApiKeyValue.text,
              ],
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 配置列表头部
                  Row(
                    children: [
                      Text(
                        context.l10n.aiConfigList,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: context.theme.hintColor,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: Icon(Icons.add, size: 16.sp),
                        label: Text(
                          context.l10n.aiConfigNew,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        onPressed: () {
                          isNewMode.value = true;
                          editingConfig.value = null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // 配置列表
                  if (configList.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: context.isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: configList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final config = entry.value;
                          final isCurrent = currentConfig.id == config.id;
                          final isBuiltin = isBuiltinAiConfig(config);
                          final isEditing =
                              !isNewMode.value &&
                              (editingConfig.value?.id == config.id ||
                                  (editingConfig.value == null && isCurrent));

                          return _ConfigListItem(
                            config: config,
                            builtinSpec: _builtinSpecOf(config),
                            isBuiltin: isBuiltin,
                            isCurrent: isCurrent,
                            isEditing: isEditing,
                            isFirst: index == 0,
                            onTap: () async {
                              try {
                                var selectedConfig = config;
                                if (!isCurrent) {
                                  await ref
                                      .read(aiConfigActionProvider.notifier)
                                      .switchConfig(config.id);
                                  ref.invalidate(aiChatRuntimeStatusProvider);
                                  selectedConfig = await ref.read(
                                    aiConfigProvider.future,
                                  );
                                }

                                // 直接更新状态
                                editingConfig.value = selectedConfig;
                                isNewMode.value = false;
                              } catch (e) {
                                if (context.mounted) {
                                  ToastMessage.show(
                                    '${context.l10n.error}: ${e.toString()}',
                                  );
                                }
                              }
                            },
                            onDelete: isBuiltin
                                ? null
                                : () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(context.l10n.confirmDelete),
                                        content: Text(
                                          context.l10n.aiConfigDeleteConfirm(
                                            config.name,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              context,
                                            ).pop(false),
                                            child: Text(context.l10n.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text(
                                              context.l10n.delete,
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmed == true) {
                                      try {
                                        await ref
                                            .read(
                                              aiConfigActionProvider.notifier,
                                            )
                                            .deleteConfig(config.id);
                                        if (editingConfig.value?.id ==
                                            config.id) {
                                          editingConfig.value = null;
                                          isNewMode.value = false;
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ToastMessage.show(
                                            '${context.l10n.error}: ${e.toString()}',
                                          );
                                        }
                                      }
                                    }
                                  },
                          );
                        }).toList(),
                      ),
                    )
                  else
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Text(
                        context.l10n.aiConfigEmpty,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: context.theme.hintColor,
                        ),
                      ),
                    ),

                  SizedBox(height: 20.h),

                  // 分隔线 + 编辑/新建标题
                  Row(
                    children: [
                      Text(
                        isNewMode.value
                            ? context.l10n.aiConfigNewTitle
                            : context.l10n.aiConfigEditTitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: context.theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // 表单
                  if (isBuiltinEditing)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            builtinSpec?.name ??
                                context.l10n.aiBuiltinConfigName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            context.l10n.aiCurrentStatus(
                              formConfig.apiKey.trim().isNotEmpty
                                  ? context.l10n.aiApiKeyConfigured
                                  : context.l10n.aiApiKeyNotConfigured,
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: formConfig.apiKey.trim().isNotEmpty
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          CustomTextField(
                            controller: builtinApiKeyController,
                            labelText: 'API Key',
                            hintText: context.l10n.aiApiKeyHint,
                            keyboardType: TextInputType.visiblePassword,
                            contextMenuBuilder:
                                _buildPasteAwareTextInputContextMenu,
                            suffixIcon: IconButton(
                              tooltip: context.isZh ? '粘贴' : 'Paste',
                              icon: const Icon(Icons.content_paste_rounded),
                              onPressed: () async {
                                await _pasteClipboardTextIntoController(
                                  builtinApiKeyController,
                                );
                              },
                            ),
                          ),
                          if (builtinSpec?.purchaseUrl
                              case final purchaseUrl?) ...[
                            SizedBox(height: 8.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () => UrlHelper.openUrlInBrowser(
                                  url: purchaseUrl,
                                ),
                                icon: const Icon(Icons.shopping_cart_outlined),
                                label: Text(context.l10n.aiBuyCardSecret),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    FormBuilder(
                      key: formKey,
                      initialValue: initialValue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AIConfigSheet._sectionHeader(
                            context,
                            zh: '连接',
                            en: 'Connection',
                          ),
                          CustomTextField.formBuilder(
                            name: 'name',
                            labelText: context.l10n.aiConfigName,
                            hintText: context.l10n.aiConfigNameHint,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: context.l10n.cannotBeEmpty(
                                  context.l10n.aiConfigName,
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField.formBuilder(
                            name: 'api',
                            labelText: context.l10n.aiBaseUrl,
                            hintText: context.l10n.aiBaseUrlHint,
                            keyboardType: TextInputType.url,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: context.l10n.cannotBeEmpty(
                                  context.l10n.aiBaseUrl,
                                ),
                              ),
                              FormBuilderValidators.url(
                                errorText: context.l10n.loadFailedMessage,
                              ),
                            ]),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            context.l10n.aiApiType,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: context.theme.hintColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          FormBuilderDropdown<String>(
                            name: 'api_type',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                            ),
                            initialValue: formConfig.apiType.name,
                            items: AiApiType.values.map((type) {
                              return DropdownMenuItem(
                                value: type.name,
                                child: Text(_apiTypeLabel(context, type)),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField.formBuilder(
                            name: 'api_key',
                            labelText: 'API Key',
                            hintText: context.l10n.aiApiKeyHint,
                            keyboardType: TextInputType.visiblePassword,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: context.l10n.cannotBeEmpty(
                                  'API Key',
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(height: 12.h),
                          AIConfigSheet._sectionHeader(
                            context,
                            zh: '模型',
                            en: 'Model',
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderDropdown<String>(
                                  name: 'module_name',
                                  decoration: InputDecoration(
                                    labelText: context.l10n.aiModelName,
                                    hintText: context.l10n.aiModelNameHint,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  initialValue: savedModelId.isEmpty
                                      ? null
                                      : savedModelId,
                                  validator: FormBuilderValidators.required(
                                    errorText: context.l10n.cannotBeEmpty(
                                      context.l10n.aiModelName,
                                    ),
                                  ),
                                  items: modelDropdownItems,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              IconButton(
                                tooltip: context.isZh
                                    ? '获取模型列表'
                                    : 'Load models',
                                onPressed: modelsLoading.value
                                    ? null
                                    : loadModels,
                                icon: modelsLoading.value
                                    ? SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.refresh_rounded),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          AIConfigSheet._sectionHeader(
                            context,
                            zh: '助手',
                            en: 'Assistant',
                          ),
                          CustomTextField.formBuilder(
                            name: 'assistant_system_prompt',
                            labelText: context.isZh
                                ? '系统提示词（可选）'
                                : 'System prompt (optional)',
                            hintText: context.isZh
                                ? '定义助手的角色和回答边界'
                                : 'Define the assistant role and boundaries',
                            maxLines: 3,
                          ),
                          SizedBox(height: 12.h),
                          FormBuilderDropdown<String>(
                            name: 'assistant_context_mode',
                            decoration: InputDecoration(
                              labelText: context.isZh
                                  ? '上下文策略'
                                  : 'Context policy',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            initialValue: selectedContextMode.value.name,
                            onChanged: (value) {
                              selectedContextMode.value = AiContextMode.values
                                  .firstWhere(
                                    (mode) => mode.name == value,
                                    orElse: () => AiContextMode.tokenBudget,
                                  );
                              if (selectedContextMode.value !=
                                  AiContextMode.recentMessages) {
                                formKey
                                    .currentState
                                    ?.fields['assistant_recent_limit']
                                    ?.reset();
                              }
                            },
                            items: AiContextMode.values
                                .map(
                                  (mode) => DropdownMenuItem(
                                    value: mode.name,
                                    child: Text(
                                      _contextModeLabel(context, mode),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                          if (selectedContextMode.value ==
                              AiContextMode.recentMessages) ...[
                            SizedBox(height: 12.h),
                            CustomTextField.formBuilder(
                              name: 'assistant_recent_limit',
                              labelText: context.isZh
                                  ? '最近消息数'
                                  : 'Recent message limit',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: FormBuilderValidators.required(
                                errorText: context.l10n.cannotBeEmpty(
                                  context.isZh
                                      ? '最近消息数'
                                      : 'Recent message limit',
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderDropdown<String>(
                                  name: 'assistant_tool_approval',
                                  decoration: InputDecoration(
                                    labelText: context.isZh
                                        ? '工具审批'
                                        : 'Tool approval',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  initialValue:
                                      AiToolApprovalMode.riskyOnly.name,
                                  items: AiToolApprovalMode.values
                                      .map(
                                        (mode) => DropdownMenuItem(
                                          value: mode.name,
                                          child: Text(
                                            _approvalModeLabel(context, mode),
                                          ),
                                        ),
                                      )
                                      .toList(growable: false),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomTextField.formBuilder(
                                  name: 'assistant_tool_rounds',
                                  labelText: context.isZh
                                      ? '工具最大轮数'
                                      : 'Max tool rounds',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          CustomTextField.formBuilder(
                            name: 'assistant_fallback_context',
                            labelText: context.isZh
                                ? '兜底上下文长度（模型未上报时生效）'
                                : 'Fallback context length (used when the model does not report one)',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 24.h),
                  if (sheetFeedback != null &&
                      sheetFeedback.scopeKey != null &&
                      sheetFeedback.scopeKey == feedbackScopeKey)
                    _feedbackBanner(context, sheetFeedback),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: ref.watch(aiConfigActionProvider).isLoading
                          ? null
                          : () async {
                              if (isBuiltinEditing) {
                                final apiKey = builtinApiKeyController.text
                                    .trim();
                                if (apiKey.isEmpty) {
                                  _showSheetFeedback(
                                    ref,
                                    feedbackScopeKey,
                                    context.l10n.cannotBeEmpty('API Key'),
                                    isError: true,
                                  );
                                  return;
                                }
                                final builtinConfig =
                                    builtinSpec?.toConfig(apiKey: apiKey) ??
                                    formConfig.copyWith(apiKey: apiKey);
                                _showSheetFeedback(
                                  ref,
                                  feedbackScopeKey,
                                  context.l10n.aiBuiltinSwitching,
                                );
                                try {
                                  final resolvedConfig =
                                      await _resolveConfigWithAvailableModel(
                                        ref,
                                        builtinConfig,
                                      );
                                  await ref
                                      .read(
                                        aiChatRuntimeProvider(
                                          packageName: 'temp',
                                        ).notifier,
                                      )
                                      .testConnection(resolvedConfig);
                                  await ref
                                      .read(aiConfigActionProvider.notifier)
                                      .save(resolvedConfig);
                                  ref.invalidate(aiChatRuntimeStatusProvider);
                                  isNewMode.value = false;
                                  editingConfig.value = null;
                                  if (context.mounted &&
                                      Navigator.canPop(context)) {
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    _showSheetFeedback(
                                      ref,
                                      feedbackScopeKey,
                                      context.l10n.aiSaveFailed(e.toString()),
                                      isError: true,
                                    );
                                  }
                                }
                                return;
                              }
                              if (formKey.currentState?.saveAndValidate() ??
                                  false) {
                                final values = formKey.currentState!.value;
                                final savedId = isNewMode.value
                                    ? const Uuid().v4()
                                    : (editingConfig.value?.id.isNotEmpty ==
                                              true
                                          ? editingConfig.value!.id
                                          : currentConfig.id);
                                final config = _buildConfigFromFormValues(
                                  values,
                                  savedId,
                                  defaultMaxToken: formConfig.maxToken,
                                  defaultTemperature: formConfig.temperature,
                                  defaultMemoryRounds: formConfig.memoryRounds,
                                );

                                _showSheetFeedback(
                                  ref,
                                  feedbackScopeKey,
                                  context.l10n.aiSavingAndTesting,
                                );
                                try {
                                  final resolvedConfig =
                                      await _resolveConfigWithAvailableModel(
                                        ref,
                                        config,
                                        syncFormModelName: true,
                                        modelsSink: availableModels,
                                      );
                                  await ref
                                      .read(
                                        aiChatRuntimeProvider(
                                          packageName: 'temp',
                                        ).notifier,
                                      )
                                      .testConnection(resolvedConfig);

                                  final systemPrompt =
                                      values['assistant_system_prompt']
                                          ?.toString();
                                  final contextMode = AiContextMode.values
                                      .firstWhere(
                                        (mode) =>
                                            mode.name ==
                                            values['assistant_context_mode'],
                                        orElse: () => AiContextMode.tokenBudget,
                                      );
                                  final approvalMode = AiToolApprovalMode.values
                                      .firstWhere(
                                        (mode) =>
                                            mode.name ==
                                            values['assistant_tool_approval'],
                                        orElse: () =>
                                            AiToolApprovalMode.riskyOnly,
                                      );
                                  final recentMessageLimit =
                                      contextMode ==
                                          AiContextMode.recentMessages
                                      ? int.tryParse(
                                          values['assistant_recent_limit']
                                                  ?.toString() ??
                                              '',
                                        )
                                      : null;
                                  // 空值/非法输入回落业务默认值；显式输入的
                                  // 非法区间（如 0、超上限）在保存链路统一
                                  // 解析收敛，避免静默禁用工具调用。
                                  final maxToolRounds =
                                      int.tryParse(
                                        values['assistant_tool_rounds']
                                                ?.toString() ??
                                            '',
                                      ) ??
                                      kDefaultMaxToolRounds;
                                  // 空值回落默认值；非法区间（0、超上限）
                                  // 在保存链路统一收敛。
                                  final fallbackContextTokens =
                                      resolveFallbackContextTokens(
                                        int.tryParse(
                                              values['assistant_fallback_context']
                                                      ?.toString() ??
                                                  '',
                                            ) ??
                                            kDefaultFallbackContextTokens,
                                      );
                                  final existsInList = configList.any(
                                    (item) => item.id == resolvedConfig.id,
                                  );
                                  await ref
                                      .read(aiConfigActionProvider.notifier)
                                      .saveConfiguration(
                                        config: resolvedConfig,
                                        models: availableModels.value,
                                        systemPrompt: systemPrompt,
                                        approvalMode: approvalMode,
                                        maxToolRounds: maxToolRounds,
                                        addToList:
                                            isNewMode.value || !existsInList,
                                      );

                                  await ref.refresh(
                                    aiChatRuntimeStatusProvider.future,
                                  );
                                  isNewMode.value = false;
                                  editingConfig.value = null;
                                  if (context.mounted &&
                                      Navigator.canPop(context)) {
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    _showSheetFeedback(
                                      ref,
                                      feedbackScopeKey,
                                      context.l10n.aiSaveFailed(e.toString()),
                                      isError: true,
                                    );
                                  }
                                }
                              }
                            },
                      child: ref.watch(aiConfigActionProvider).isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              context.l10n.confirm,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Widget _buildPasteAwareTextInputContextMenu(
  BuildContext context,
  EditableTextState editableTextState,
) {
  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: _buildPasteAwareContextMenuItems(editableTextState),
  );
}

List<ContextMenuButtonItem> _buildPasteAwareContextMenuItems(
  EditableTextState editableTextState,
) {
  final buttonItems = editableTextState.contextMenuButtonItems
      .map(
        (item) => item.type == ContextMenuButtonType.paste
            ? item.copyWith(
                onPressed: () =>
                    _pasteClipboardTextIntoEditableText(editableTextState),
              )
            : item,
      )
      .toList(growable: true);

  final canPaste = !editableTextState.widget.readOnly;
  final hasPaste = buttonItems.any(
    (item) => item.type == ContextMenuButtonType.paste,
  );
  if (canPaste && !hasPaste) {
    buttonItems.insert(
      _resolvePasteInsertIndex(buttonItems),
      ContextMenuButtonItem(
        type: ContextMenuButtonType.paste,
        onPressed: () => _pasteClipboardTextIntoEditableText(editableTextState),
      ),
    );
  }

  return buttonItems;
}

int _resolvePasteInsertIndex(List<ContextMenuButtonItem> buttonItems) {
  final copyIndex = buttonItems.lastIndexWhere(
    (item) => item.type == ContextMenuButtonType.copy,
  );
  if (copyIndex >= 0) {
    return copyIndex + 1;
  }

  final cutIndex = buttonItems.lastIndexWhere(
    (item) => item.type == ContextMenuButtonType.cut,
  );
  if (cutIndex >= 0) {
    return cutIndex + 1;
  }

  return 0;
}

Future<void> _pasteClipboardTextIntoEditableText(
  EditableTextState editableTextState,
) async {
  if (editableTextState.widget.readOnly) {
    editableTextState.hideToolbar();
    return;
  }

  final clipboardText = await _readClipboardText();
  if (!editableTextState.mounted ||
      clipboardText == null ||
      clipboardText.isEmpty) {
    editableTextState.hideToolbar();
    return;
  }

  final value = editableTextState.textEditingValue;
  final selection = value.selection.isValid
      ? value.selection
      : TextSelection.collapsed(offset: value.text.length);
  final nextValue = _replaceSelectionWithText(
    value: value,
    selection: selection,
    text: clipboardText,
  );
  editableTextState.userUpdateTextEditingValue(
    nextValue,
    SelectionChangedCause.toolbar,
  );

  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!editableTextState.mounted) {
      return;
    }
    editableTextState.bringIntoView(
      editableTextState.textEditingValue.selection.extent,
    );
    editableTextState.hideToolbar();
  });
}

Future<void> _pasteClipboardTextIntoController(
  TextEditingController controller,
) async {
  final clipboardText = await _readClipboardText();
  if (clipboardText == null || clipboardText.isEmpty) {
    return;
  }

  final value = controller.value;
  final selection = value.selection.isValid
      ? value.selection
      : TextSelection.collapsed(offset: value.text.length);
  controller.value = _replaceSelectionWithText(
    value: value,
    selection: selection,
    text: clipboardText,
  );
}

Future<String?> _readClipboardText() async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  final text = data?.text;
  if (text == null || text.isEmpty) {
    return null;
  }
  return text;
}

TextEditingValue _replaceSelectionWithText({
  required TextEditingValue value,
  required TextSelection selection,
  required String text,
}) {
  final nextOffset = selection.start + text.length;
  return value
      .replaced(selection, text)
      .copyWith(
        selection: TextSelection.collapsed(offset: nextOffset),
        composing: TextRange.empty,
      );
}

/// 配置列表项组件
class _ConfigListItem extends ConsumerWidget {
  const _ConfigListItem({
    required this.config,
    required this.builtinSpec,
    required this.isBuiltin,
    required this.isCurrent,
    required this.isEditing,
    required this.isFirst,
    required this.onTap,
    this.onDelete,
  });

  final AiConfig config;
  final BuiltinAiConfigSpec? builtinSpec;
  final bool isBuiltin;
  final bool isCurrent;
  final bool isEditing;
  final bool isFirst;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  Color _resolveBadgeColor(String label) {
    switch (label.trim().toLowerCase()) {
      case 'evil':
        return const Color(0xFFD92D20);
      case 'claude':
        return const Color(0xFFB95C1E);
      case 'chatgpt':
        return const Color(0xFF0F9D76);
      case '国产':
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFF667085);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isEditing
            ? context.colorScheme.primary.withValues(alpha: 0.08)
            : null,
        border: !isFirst
            ? Border(
                top: BorderSide(
                  color: context.isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey[300]!,
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          // 左侧：单选按钮
          IconButton(
            icon: Icon(
              isCurrent
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 22.sp,
              color: context.colorScheme.primary,
            ),
            tooltip: isCurrent
                ? context.l10n.aiConfigCurrent
                : context.l10n.aiConfigSwitch,
            onPressed: onTap, // 这里的按钮点击也走总的 onTap，确保效果一致
          ),
          // 中间：配置信息（可点击编辑）
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          config.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isCurrent) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              context.l10n.aiConfigCurrent,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                        if (isBuiltin)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (
                                    var index = 0;
                                    index <
                                        (builtinSpec?.badgeLabels.length ?? 0);
                                    index++
                                  ) ...[
                                    SizedBox(width: 6.w),
                                    Builder(
                                      builder: (context) {
                                        final badgeLabel =
                                            builtinSpec!.badgeLabels[index];
                                        final badgeColor = _resolveBadgeColor(
                                          badgeLabel,
                                        );
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: badgeColor,
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                          child: Text(
                                            badgeLabel,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isBuiltin
                          ? [
                              if ((builtinSpec?.statusLabel ?? '').isNotEmpty)
                                builtinSpec!.statusLabel,
                              config.apiKey.trim().isNotEmpty
                                  ? context.l10n.aiApiKeyConfigured
                                  : context.l10n.aiApiKeyNotConfigured,
                            ].join(' · ')
                          : config.moduleName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: context.theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 右侧：删除按钮
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20.sp, color: Colors.red),
              tooltip: context.l10n.aiConfigDelete,
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
