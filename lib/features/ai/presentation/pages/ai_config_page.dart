import 'dart:async';

import 'package:JsxposedX/common/pages/toast.dart';
import 'package:JsxposedX/common/widgets/custom_text_field.dart';
import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/common/widgets/ref_error.dart';
import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/utils/url_helper.dart';
import 'package:JsxposedX/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_model.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/presentation/providers/chat/ai_chat_action_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_action_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/config/ai_config_query_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/ai/presentation/widgets/ai_brand_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

const String _tutorialUrl =
    'https://www.yuque.com/ababa-haoqq/hake3e/npt913l7r1goxsoi?singleDoc';

/// 服务商预设：选中后自动填充服务地址与接口类型，避免手填出错。
class _ProviderPreset {
  const _ProviderPreset({
    required this.label,
    required this.apiUrl,
    required this.apiType,
  });

  final String label;
  final String apiUrl;
  final AiApiType apiType;
}

const List<_ProviderPreset> _providerPresets = [
  _ProviderPreset(
    label: 'OpenAI',
    apiUrl: 'https://api.openai.com/v1',
    apiType: AiApiType.openai,
  ),
  _ProviderPreset(
    label: 'DeepSeek',
    apiUrl: 'https://api.deepseek.com/v1',
    apiType: AiApiType.openai,
  ),
  _ProviderPreset(
    label: 'Moonshot',
    apiUrl: 'https://api.moonshot.cn/v1',
    apiType: AiApiType.openai,
  ),
  _ProviderPreset(
    label: 'Anthropic',
    apiUrl: 'https://api.anthropic.com/v1',
    apiType: AiApiType.anthropic,
  ),
];

/// 连通状态：编辑页底部常驻展示，取代与保存割裂的独立测试按钮。
enum _ConnState { idle, testing, ok, failed }

class _ConnStatus {
  const _ConnStatus(this.state, [this.message]);

  final _ConnState state;
  final String? message;
}

String _apiTypeLabel(BuildContext context, AiApiType type) {
  switch (type) {
    case AiApiType.openai:
      return 'OpenAI Chat Completions';
    case AiApiType.openaiResponses:
      return context.l10n.aiApiTypeOpenAIResponses;
    case AiApiType.anthropic:
      return 'Anthropic Message';
  }
}

String _approvalModeLabel(BuildContext context, AiToolApprovalMode mode) {
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

AiModel _modelFromDefinition(AiModelDefinition definition) => AiModel(
  id: definition.id,
  object: 'model',
  created: 0,
  ownedBy: '',
  supportedEndpointTypes: const [],
  contextTokens: definition.limits.contextTokens,
  maxOutputTokens: definition.limits.maxOutputTokens,
);

String _assistantIdOf(String configId) => 'legacy-assistant-$configId';

/// AI 配置入口：全屏配置列表页。
class AiConfigPage extends HookConsumerWidget {
  const AiConfigPage({super.key});

  static bool _isShowing = false;

  static Future<void> show(BuildContext context) async {
    if (_isShowing) return;
    _isShowing = true;
    try {
      await Navigator.of(
        context,
      ).push<void>(MaterialPageRoute(builder: (_) => const AiConfigPage()));
    } finally {
      _isShowing = false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiConfigAsync = ref.watch(aiConfigProvider);
    final configListAsync = ref.watch(aiConfigListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.aiConfigTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.aiTutorial,
            onPressed: () => UrlHelper.openUrlInBrowser(url: _tutorialUrl),
            icon: const Icon(Icons.help_outline_rounded),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: aiConfigAsync.when(
        loading: () => const Center(child: Loading()),
        error: (error, stack) => Center(
          child: RefError(
            error: error,
            onRetry: () => ref.invalidate(aiConfigProvider),
          ),
        ),
        data: (currentConfig) => configListAsync.when(
          loading: () => const Center(child: Loading()),
          error: (error, stack) => Center(
            child: RefError(
              error: error,
              onRetry: () => ref.invalidate(aiConfigListProvider),
            ),
          ),
          data: (configList) => _ConfigListView(
            currentConfig: currentConfig,
            configList: configList,
          ),
        ),
      ),
    );
  }
}

/// 配置列表：切换（显式操作）与编辑（点击卡片）分离。
class _ConfigListView extends ConsumerWidget {
  const _ConfigListView({
    required this.currentConfig,
    required this.configList,
  });

  final AiConfig currentConfig;
  final List<AiConfig> configList;

  Future<void> _activate(
    BuildContext context,
    WidgetRef ref,
    AiConfig config,
  ) async {
    try {
      await ref.read(aiConfigActionProvider.notifier).switchConfig(config.id);
      ref.invalidate(aiChatRuntimeStatusProvider);
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show('${context.l10n.error}: $e');
      }
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    AiConfig config,
  ) async {
    final confirmed = await confirmDeleteConfig(context, config.name);
    if (confirmed != true) return;
    try {
      await ref.read(aiConfigActionProvider.notifier).deleteConfig(config.id);
    } catch (e) {
      if (context.mounted) {
        ToastMessage.show('${context.l10n.error}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = context.colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AiConfigEditPage.show(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.aiConfigNew),
      ),
      body: configList.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.smart_toy_outlined,
                      size: 40.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      context.l10n.aiConfigEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
              itemCount: configList.length + 1,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 2.h),
                    child: Text(
                      context.l10n.aiConfigList,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }
                final config = configList[index - 1];
                final isCurrent = currentConfig.id == config.id;
                final isBuiltin = isBuiltinAiConfig(config);
                return _ConfigCard(
                  config: config,
                  builtinSpec: getBuiltinAiConfigSpecById(config.id),
                  isBuiltin: isBuiltin,
                  isCurrent: isCurrent,
                  onEdit: () =>
                      AiConfigEditPage.show(context, configId: config.id),
                  onActivate: isCurrent
                      ? null
                      : () => _activate(context, ref, config),
                  onDelete: isBuiltin
                      ? null
                      : () => _delete(context, ref, config),
                );
              },
            ),
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({
    required this.config,
    required this.builtinSpec,
    required this.isBuiltin,
    required this.isCurrent,
    required this.onEdit,
    required this.onActivate,
    required this.onDelete,
  });

  final AiConfig config;
  final BuiltinAiConfigSpec? builtinSpec;
  final bool isBuiltin;
  final bool isCurrent;
  final VoidCallback onEdit;
  final VoidCallback? onActivate;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final badgeLabels = builtinSpec?.badgeLabels ?? const <String>[];

    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? scheme.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isCurrent
              ? scheme.primary.withValues(alpha: 0.45)
              : (context.isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : scheme.outlineVariant),
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 4.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? scheme.primary.withValues(alpha: 0.16)
                            : scheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: AiBrandIcon(
                        brand: isBuiltin
                            ? null
                            : AiBrand.resolve(
                                apiUrl: config.apiUrl,
                                modelName: config.moduleName,
                                name: config.name,
                              ),
                        fallbackAsset: isBuiltin
                            ? 'assets/images/muxue.png'
                            : null,
                        fallbackIcon: Icons.smart_toy_outlined,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              config.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: context.textTheme.titleMedium?.color,
                              ),
                            ),
                          ),
                          if (isCurrent) ...[
                            SizedBox(width: 8.w),
                            _StatusPill(
                              label: context.l10n.aiConfigCurrent,
                              color: scheme.primary,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (onDelete != null)
                      PopupMenuButton<String>(
                        tooltip: '',
                        icon: Icon(
                          Icons.more_vert_rounded,
                          size: 20.sp,
                          color: scheme.onSurfaceVariant,
                        ),
                        onSelected: (value) {
                          if (value == 'delete') onDelete!.call();
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18.sp,
                                  color: scheme.error,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.l10n.aiConfigDelete,
                                  style: TextStyle(color: scheme.error),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(width: 8.w),
                  ],
                ),
                SizedBox(height: 8.h),
                // 内置配置的勋章保持单行，避免标签换行撑高供应商卡片。
                if (isBuiltin) ...[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: badgeLabels
                          .map(
                            (label) => Padding(
                              padding: EdgeInsets.only(right: 6.w),
                              child: _AiBadgePill(label: label),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          config.moduleName.trim().isEmpty
                              ? config.apiUrl
                              : config.moduleName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 删除确认弹窗，列表页与编辑页共用。
Future<bool?> confirmDeleteConfig(BuildContext context, String name) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.l10n.confirmDelete),
      content: Text(context.l10n.aiConfigDeleteConfirm(name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            context.l10n.delete,
            style: TextStyle(color: context.colorScheme.error),
          ),
        ),
      ],
    ),
  );
}

/// 配置编辑页。
class AiConfigEditPage extends HookConsumerWidget {
  const AiConfigEditPage({super.key, required this.configId});

  final String? configId;

  static Future<void> show(BuildContext context, {String? configId}) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => AiConfigEditPage(configId: configId)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiConfigAsync = ref.watch(aiConfigProvider);
    final configListAsync = ref.watch(aiConfigListProvider);
    final assistantsAsync = ref.watch(aiAssistantsV2Provider);

    final isNew = configId == null;
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final builtinKeyController = useTextEditingController();

    final availableModels = useState<List<AiModel>>(const []);
    final modelsLoading = useState(false);
    final conn = useState<_ConnStatus>(const _ConnStatus(_ConnState.idle));
    final advancedOpen = useState(false);
    final saving = useState(false);
    final loadedCatalogIds = useRef<Set<String>>(<String>{});
    final modelsSourceKey = useRef<String?>(null);

    final currentConfig = aiConfigAsync.value;
    final configList = configListAsync.value ?? const <AiConfig>[];
    final editConfig = isNew
        ? null
        : configList.where((item) => item.id == configId).firstOrNull;

    // 配置已被删除时直接退出，避免停在空表单上。
    useEffect(() {
      if (isNew || currentConfig == null || editConfig != null) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });
      return null;
    }, [isNew, editConfig?.id, currentConfig?.id]);

    // 新建配置绝不复用当前配置的字段，避免把别的配置的 API Key 带进来。
    final baseConfig = isNew
        ? const AiConfig(
            id: '',
            name: '',
            apiKey: '',
            apiUrl: '',
            moduleName: '',
            maxToken: 0,
            temperature: -1,
            memoryRounds: 0,
            apiType: AiApiType.openai,
          )
        : editConfig!;

    final isBuiltinEditing = !isNew && isBuiltinAiConfig(baseConfig);
    final builtinSpec = getBuiltinAiConfigSpecById(baseConfig.id);

    AiAssistantProfile? formAssistant;
    for (final assistant
        in assistantsAsync.value ?? const <AiAssistantProfile>[]) {
      if (assistant.id == _assistantIdOf(baseConfig.id)) {
        formAssistant = assistant;
        break;
      }
    }

    final initialValue = <String, dynamic>{
      'name': baseConfig.name,
      'api': baseConfig.apiUrl,
      'api_key': baseConfig.apiKey,
      'module_name': baseConfig.moduleName,
      'api_type': baseConfig.apiType.name,
      'max_token': baseConfig.maxToken > 0
          ? baseConfig.maxToken.toString()
          : '',
      'temperature': baseConfig.temperature >= 0
          ? baseConfig.temperature.toString()
          : '',
      'assistant_system_prompt': formAssistant?.systemPrompt ?? '',
      'assistant_tool_approval':
          formAssistant?.toolPolicy.approvalMode.name ??
          AiToolApprovalMode.riskyOnly.name,
      'assistant_tool_rounds':
          (formAssistant?.toolPolicy.maxRounds ?? kDefaultMaxToolRounds)
              .toString(),
    };

    // 编辑对象变化时重置表单与状态。
    final formSourceKey = '${isNew ? 'new' : 'edit'}|${baseConfig.id}';
    useEffect(() {
      conn.value = const _ConnStatus(_ConnState.idle);
      availableModels.value = const [];
      modelsSourceKey.value = [
        baseConfig.apiUrl.trim(),
        baseConfig.apiKey.trim(),
        baseConfig.apiType.name,
      ].join('|');
      if (isBuiltinEditing) {
        builtinKeyController.text = baseConfig.apiKey;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          formKey.currentState?.patchValue(initialValue);
        }
      });
      return null;
    }, [formSourceKey, isBuiltinEditing]);

    // 恢复上次发现的模型目录，保证离线时已保存的模型仍能选中。
    final catalogKey = baseConfig.id;
    useEffect(() {
      if (isBuiltinEditing || catalogKey.isEmpty) return null;
      if (loadedCatalogIds.value.contains(catalogKey)) return null;
      loadedCatalogIds.value.add(catalogKey);
      final catalogSourceKey = [
        baseConfig.apiUrl.trim(),
        baseConfig.apiKey.trim(),
        baseConfig.apiType.name,
      ].join('|');
      unawaited(() async {
        try {
          final definitions = await ref.read(
            aiModelsV2Provider('legacy-connection-$catalogKey').future,
          );
          if (!context.mounted ||
              (modelsSourceKey.value != null &&
                  modelsSourceKey.value != catalogSourceKey)) {
            return;
          }
          modelsSourceKey.value = catalogSourceKey;
          availableModels.value = definitions
              .map(_modelFromDefinition)
              .toList(growable: false);
        } catch (_) {
          // 全新配置没有缓存目录属于正常情况。
        }
      }());
      return null;
    }, [catalogKey, isBuiltinEditing]);

    AiConfig buildFromForm(Map<String, dynamic> values, String id) {
      final maxToken = int.tryParse(values['max_token']?.toString() ?? '') ?? 0;
      final temperature =
          double.tryParse(values['temperature']?.toString() ?? '') ?? -1;
      return AiConfig(
        id: id,
        name: values['name']?.toString() ?? '',
        apiUrl: values['api']?.toString() ?? '',
        apiKey: values['api_key']?.toString() ?? '',
        moduleName: values['module_name']?.toString() ?? '',
        maxToken: maxToken > 0 ? maxToken : baseConfig.maxToken,
        temperature: temperature >= 0 ? temperature : baseConfig.temperature,
        memoryRounds: baseConfig.memoryRounds,
        apiType: AiApiType.fromString(
          values['api_type']?.toString() ?? AiApiType.openai.name,
        ),
      );
    }

    Future<List<AiModel>> fetchModels(AiConfig config) async {
      final models = await ref
          .read(aiConfigQueryRepositoryProvider)
          .getModels(config: config, forceRefresh: true);
      availableModels.value = models;
      return models;
    }

    Future<void> loadModels() async {
      final formState = formKey.currentState;
      if (formState == null) return;
      formState.save();
      final values = formState.value;
      final apiUrl = values['api']?.toString().trim() ?? '';
      final apiKey = values['api_key']?.toString().trim() ?? '';
      if (apiUrl.isEmpty || apiKey.isEmpty) {
        ToastMessage.show(
          context.isZh
              ? '请先填写 API 地址和 API Key'
              : 'Enter the API URL and API key first',
        );
        return;
      }
      modelsLoading.value = true;
      try {
        final config = buildFromForm(
          values,
          baseConfig.id.isEmpty ? const Uuid().v4() : baseConfig.id,
        );
        final sourceKey = [
          config.apiUrl.trim(),
          config.apiKey.trim(),
          config.apiType.name,
        ].join('|');
        final sourceChanged = modelsSourceKey.value != sourceKey;
        if (sourceChanged) {
          formState.fields['module_name']?.didChange(null);
        }
        final models = await fetchModels(config);
        if (!context.mounted) return;
        modelsSourceKey.value = sourceKey;
        final modelField = formState.fields['module_name'];
        final currentModelId = modelField?.value?.toString().trim() ?? '';
        if (sourceChanged ||
            !models.any((model) => model.id == currentModelId)) {
          modelField?.didChange(models.isEmpty ? null : models.first.id);
        }
        if (models.isEmpty) {
          ToastMessage.show(
            context.isZh
                ? '服务端没有返回可用模型'
                : 'The service returned no usable model',
          );
        }
      } catch (error) {
        if (!context.mounted) return;
        ToastMessage.show(context.l10n.aiTestFailed(error.toString()));
      } finally {
        if (context.mounted) {
          modelsLoading.value = false;
        }
      }
    }

    /// 拉取模型并测试连通性；成功返回可用配置，失败返回 null。
    Future<AiConfig?> verify(AiConfig config) async {
      final emptyModelHint = context.isZh
          ? '服务端没有返回可用模型'
          : 'The service returned no usable model';
      conn.value = const _ConnStatus(_ConnState.testing);
      try {
        final models = await fetchModels(config);
        if (models.isEmpty) {
          throw Exception(emptyModelHint);
        }
        var resolved = config;
        if (!models.any((model) => model.id == resolved.moduleName)) {
          resolved = resolved.copyWith(moduleName: models.first.id);
          formKey.currentState?.patchValue({
            'module_name': resolved.moduleName,
          });
        }
        final result = await ref
            .read(aiConnectionTestServiceProvider)
            .test(resolved);
        conn.value = _ConnStatus(_ConnState.ok, result);
        return resolved;
      } catch (e) {
        conn.value = _ConnStatus(_ConnState.failed, e.toString());
        return null;
      }
    }

    Future<void> handleSave() async {
      final formState = formKey.currentState;
      if (formState == null || !formState.saveAndValidate()) return;
      final values = formState.value;

      if (isBuiltinEditing) {
        final apiKey = builtinKeyController.text.trim();
        if (apiKey.isEmpty) {
          ToastMessage.show(context.l10n.cannotBeEmpty('API Key'));
          return;
        }
        saving.value = true;
        try {
          final builtinConfig = builtinSpec == null
              ? baseConfig.copyWith(apiKey: apiKey)
              : builtinSpec.toConfig(apiKey: apiKey);
          final verified = await verify(builtinConfig);
          if (verified == null) {
            if (context.mounted) {
              ToastMessage.show(
                context.l10n.aiSaveFailed(
                  conn.value.message ?? context.l10n.error,
                ),
              );
            }
            return;
          }
          await ref.read(aiConfigActionProvider.notifier).save(verified);
          ref.invalidate(aiChatRuntimeStatusProvider);
          if (context.mounted && Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        } finally {
          if (context.mounted) saving.value = false;
        }
        return;
      }

      final savedId = baseConfig.id.isNotEmpty
          ? baseConfig.id
          : const Uuid().v4();
      saving.value = true;
      try {
        final draft = buildFromForm(values, savedId);
        final verified = await verify(draft);
        if (verified == null) {
          if (context.mounted) {
            ToastMessage.show(
              context.l10n.aiSaveFailed(
                conn.value.message ?? context.l10n.error,
              ),
            );
          }
          return;
        }

        final approvalMode = AiToolApprovalMode.values.firstWhere(
          (mode) => mode.name == values['assistant_tool_approval'],
          orElse: () => AiToolApprovalMode.riskyOnly,
        );
        final maxToolRounds = int.tryParse(
          values['assistant_tool_rounds']?.toString() ?? '',
        );
        final existsInList = configList.any((item) => item.id == verified.id);
        await ref
            .read(aiConfigActionProvider.notifier)
            .saveConfiguration(
              config: verified,
              models: availableModels.value,
              systemPrompt: values['assistant_system_prompt']?.toString(),
              approvalMode: approvalMode,
              maxToolRounds: resolveMaxToolRounds(maxToolRounds ?? 0),
              addToList: !existsInList,
            );
        ref.invalidate(aiChatRuntimeStatusProvider);
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          ToastMessage.show(context.l10n.aiSaveFailed(e.toString()));
        }
      } finally {
        if (context.mounted) saving.value = false;
      }
    }

    Future<void> handleDelete() async {
      final confirmed = await confirmDeleteConfig(context, baseConfig.name);
      if (confirmed != true) return;
      try {
        await ref
            .read(aiConfigActionProvider.notifier)
            .deleteConfig(baseConfig.id);
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          ToastMessage.show('${context.l10n.error}: $e');
        }
      }
    }

    if (aiConfigAsync.isLoading ||
        (!isNew && (configListAsync.isLoading || editConfig == null))) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Loading()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNew ? context.l10n.aiConfigNewTitle : baseConfig.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (!isNew && !isBuiltinEditing)
            IconButton(
              tooltip: context.l10n.aiConfigDelete,
              onPressed: handleDelete,
              icon: Icon(
                Icons.delete_outline_rounded,
                color: context.colorScheme.error,
              ),
            ),
          SizedBox(width: 4.w),
        ],
      ),
      body: FormBuilder(
        key: formKey,
        initialValue: initialValue,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            if (isBuiltinEditing)
              _builtinCard(context, builtinSpec, builtinKeyController)
            else ...[
              if (isNew) ...[
                _presetSection(context, formKey, conn),
                SizedBox(height: 16.h),
              ],
              _connectionSection(context, isNew),
              SizedBox(height: 16.h),
              _modelSection(
                context,
                baseConfig,
                availableModels,
                modelsLoading,
                loadModels,
              ),
              SizedBox(height: 16.h),
              _advancedSection(context, advancedOpen),
              SizedBox(height: 16.h),
              _assistantSection(context),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(context, conn, saving.value, handleSave),
    );
  }

  Widget _builtinCard(
    BuildContext context,
    BuiltinAiConfigSpec? spec,
    TextEditingController apiKeyController,
  ) {
    final scheme = context.colorScheme;
    final configured = apiKeyController.text.trim().isNotEmpty;
    final purchaseUrl = spec?.purchaseUrl;
    return _sectionCard(
      context,
      title: spec?.name ?? context.l10n.aiBuiltinConfigName,
      icon: Icons.local_florist_outlined,
      children: [
        Text(
          context.l10n.aiCurrentStatus(
            configured
                ? context.l10n.aiApiKeyConfigured
                : context.l10n.aiApiKeyNotConfigured,
          ),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: configured ? scheme.primary : scheme.error,
          ),
        ),
        SizedBox(height: 14.h),
        CustomTextField(
          controller: apiKeyController,
          labelText: 'API Key',
          hintText: context.l10n.aiApiKeyHint,
          keyboardType: TextInputType.visiblePassword,
        ),
        if (purchaseUrl != null && purchaseUrl.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => UrlHelper.openUrlInBrowser(url: purchaseUrl),
              icon: const Icon(Icons.shopping_cart_outlined, size: 18),
              label: Text(context.l10n.aiBuyCardSecret),
            ),
          ),
        ],
      ],
    );
  }

  Widget _presetSection(
    BuildContext context,
    GlobalKey<FormBuilderState> formKey,
    ValueNotifier<_ConnStatus> conn,
  ) {
    final scheme = context.colorScheme;
    return _sectionCard(
      context,
      title: context.isZh ? '快速开始' : 'Quick start',
      icon: Icons.bolt_outlined,
      children: [
        Text(
          context.isZh
              ? '选择服务商可自动填写服务地址与接口类型'
              : 'Pick a provider to prefill the URL and API type',
          style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _providerPresets
              .map((preset) {
                return ActionChip(
                  avatar: AiBrandIcon(
                    brand: AiBrand.resolve(
                      apiUrl: preset.apiUrl,
                      name: preset.label,
                    ),
                    size: 18,
                  ),
                  label: Text(preset.label),
                  onPressed: () {
                    formKey.currentState?.patchValue({
                      'api': preset.apiUrl,
                      'api_type': preset.apiType.name,
                    });
                    conn.value = const _ConnStatus(_ConnState.idle);
                  },
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }

  Widget _connectionSection(BuildContext context, bool isNew) {
    return _sectionCard(
      context,
      title: context.isZh ? '连接服务' : 'Connection',
      icon: Icons.cloud_outlined,
      children: [
        CustomTextField.formBuilder(
          name: 'name',
          labelText: context.l10n.aiConfigName,
          hintText: context.l10n.aiConfigNameHint,
          validator: FormBuilderValidators.required(
            errorText: context.l10n.cannotBeEmpty(context.l10n.aiConfigName),
          ),
        ),
        SizedBox(height: 14.h),
        CustomTextField.formBuilder(
          name: 'api',
          labelText: context.l10n.aiBaseUrl,
          hintText: context.l10n.aiBaseUrlHint,
          keyboardType: TextInputType.url,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
              errorText: context.l10n.cannotBeEmpty(context.l10n.aiBaseUrl),
            ),
            FormBuilderValidators.url(
              errorText: context.l10n.loadFailedMessage,
            ),
          ]),
        ),
        SizedBox(height: 14.h),
        FormBuilderDropdown<String>(
          name: 'api_type',
          decoration: _fieldDecoration(
            context,
            labelText: context.l10n.aiApiType,
          ),
          items: AiApiType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type.name,
                  child: Row(
                    children: [
                      AiBrandIcon(
                        brand: type == AiApiType.anthropic
                            ? AiBrand.anthropic
                            : AiBrand.openai,
                        size: 18,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(child: Text(_apiTypeLabel(context, type))),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
        ),
        SizedBox(height: 14.h),
        CustomTextField.formBuilder(
          name: 'api_key',
          labelText: 'API Key',
          hintText: context.l10n.aiApiKeyHint,
          keyboardType: TextInputType.visiblePassword,
          validator: FormBuilderValidators.required(
            errorText: context.l10n.cannotBeEmpty('API Key'),
          ),
        ),
      ],
    );
  }

  Widget _modelSection(
    BuildContext context,
    AiConfig baseConfig,
    ValueNotifier<List<AiModel>> availableModels,
    ValueNotifier<bool> modelsLoading,
    Future<void> Function() loadModels,
  ) {
    return _sectionCard(
      context,
      title: context.l10n.aiModelName,
      icon: Icons.memory_rounded,
      trailing: TextButton.icon(
        onPressed: modelsLoading.value ? null : loadModels,
        icon: modelsLoading.value
            ? SizedBox(
                width: 14.w,
                height: 14.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh_rounded, size: 18),
        label: Text(context.isZh ? '获取模型' : 'Load'),
      ),
      children: [
        _ModelPickerField(
          models: availableModels,
          savedModelId: baseConfig.moduleName.trim(),
        ),
      ],
    );
  }

  Widget _advancedSection(
    BuildContext context,
    ValueNotifier<bool> advancedOpen,
  ) {
    final scheme = context.colorScheme;
    return _sectionCard(
      context,
      title: context.isZh ? '高级设置' : 'Advanced',
      icon: Icons.tune_rounded,
      onHeaderTap: () => advancedOpen.value = !advancedOpen.value,
      trailing: AnimatedRotation(
        turns: advancedOpen.value ? 0.5 : 0,
        duration: const Duration(milliseconds: 200),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 20.sp,
          color: context.theme.hintColor,
        ),
      ),
      children: [
        if (!advancedOpen.value)
          Text(
            context.isZh
                ? '最大输出 Token 与温度；留空沿用默认值'
                : 'Max output tokens and temperature; blank keeps defaults',
            style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant),
          )
        else ...[
          CustomTextField.formBuilder(
            name: 'max_token',
            labelText: context.l10n.aiMaxTokens,
            hintText: context.l10n.aiMaxTokensHint,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(height: 14.h),
          CustomTextField.formBuilder(
            name: 'temperature',
            labelText: context.l10n.aiTemperature,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ],
    );
  }

  Widget _assistantSection(BuildContext context) {
    return _sectionCard(
      context,
      title: context.isZh ? '助手行为' : 'Assistant',
      icon: Icons.psychology_outlined,
      children: [
        CustomTextField.formBuilder(
          name: 'assistant_system_prompt',
          labelText: context.isZh ? '系统提示词（可选）' : 'System prompt (optional)',
          hintText: context.isZh
              ? '定义助手的角色与回答边界'
              : 'Define the assistant role and boundaries',
          maxLines: 3,
        ),
        SizedBox(height: 14.h),
        FormBuilderDropdown<String>(
          name: 'assistant_tool_approval',
          decoration: _fieldDecoration(
            context,
            labelText: context.isZh ? '工具审批' : 'Tool approval',
          ),
          items: AiToolApprovalMode.values
              .map(
                (mode) => DropdownMenuItem(
                  value: mode.name,
                  child: Text(_approvalModeLabel(context, mode)),
                ),
              )
              .toList(growable: false),
        ),
        SizedBox(height: 14.h),
        CustomTextField.formBuilder(
          name: 'assistant_tool_rounds',
          labelText: context.isZh ? '工具最大轮数' : 'Max tool rounds',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _bottomBar(
    BuildContext context,
    ValueNotifier<_ConnStatus> conn,
    bool saving,
    Future<void> Function() handleSave,
  ) {
    final scheme = context.colorScheme;
    final status = conn.value;
    final (IconData icon, Color color, String text) = switch (status.state) {
      _ConnState.idle => (
        Icons.circle_outlined,
        scheme.onSurfaceVariant,
        context.isZh ? '保存前会自动验证连通性' : 'Connectivity is verified on save',
      ),
      _ConnState.testing => (
        Icons.autorenew_rounded,
        scheme.primary,
        context.l10n.aiTestConnecting,
      ),
      _ConnState.ok => (
        Icons.check_circle_rounded,
        scheme.primary,
        status.message ?? context.l10n.aiTestSuccess(''),
      ),
      _ConnState.failed => (
        Icons.error_outline_rounded,
        scheme.error,
        status.message ?? context.l10n.error,
      ),
    };

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(top: BorderSide(color: scheme.outlineVariant)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, size: 16.sp, color: color),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  disabledBackgroundColor: scheme.primary.withValues(
                    alpha: 0.5,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: saving ? null : handleSave,
                child: saving
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : Text(
                        context.l10n.confirm,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _sectionCard(
  BuildContext context, {
  required String title,
  required IconData icon,
  Widget? trailing,
  VoidCallback? onHeaderTap,
  required List<Widget> children,
}) {
  final scheme = context.colorScheme;
  final header = Row(
    children: [
      Icon(icon, size: 18.sp, color: scheme.primary),
      SizedBox(width: 10.w),
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: context.textTheme.titleMedium?.color,
          ),
        ),
      ),
      if (trailing != null) trailing,
    ],
  );
  return Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
    decoration: BoxDecoration(
      color: context.isDark ? scheme.surfaceContainerLow : Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(
        color: context.isDark
            ? Colors.white.withValues(alpha: 0.06)
            : scheme.outlineVariant,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onHeaderTap != null)
          InkWell(
            onTap: onHeaderTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: header,
            ),
          )
        else
          header,
        SizedBox(height: 10.h),
        ...children,
      ],
    ),
  );
}

/// 胶囊状态徽标，与「激活状态」胶囊保持同一视觉语言。
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 带品牌 SVG 与品牌色的 AI 能力徽章。
class _AiBadgePill extends StatelessWidget {
  const _AiBadgePill({required this.label});

  final String label;

  AiBrand get _brand => switch (label.toLowerCase()) {
    'claude' => AiBrand.claude,
    'chatgpt' => AiBrand.openai,
    '国产' => AiBrand.qwen,
    _ => AiBrand.anthropic,
  };

  @override
  Widget build(BuildContext context) {
    final brand = _brand;
    final color = brand.resolveColor(isDark: context.isDark);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AiBrandIcon(brand: brand, size: 12),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// 与 [CustomTextField] 保持一致的输入框装饰。
InputDecoration _fieldDecoration(
  BuildContext context, {
  String? labelText,
  String? hintText,
  IconData? prefixIcon,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon == null
        ? null
        : Icon(
            prefixIcon,
            size: 20.sp,
            color: context.colorScheme.onSurfaceVariant,
          ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(
        color: Colors.grey.withValues(alpha: 0.3),
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: context.colorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: context.colorScheme.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: context.colorScheme.error, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
  );
}

/// 可搜索的模型选择器：模型数量可能上百，普通下拉不可用。
class _ModelPickerField extends HookWidget {
  const _ModelPickerField({required this.models, required this.savedModelId});

  final ValueNotifier<List<AiModel>> models;
  final String savedModelId;

  @override
  Widget build(BuildContext context) {
    final selected = useState<String?>(
      savedModelId.isEmpty ? null : savedModelId,
    );

    useEffect(() {
      selected.value = savedModelId.isEmpty ? null : savedModelId;
      return null;
    }, [savedModelId]);

    return FormBuilderField<String>(
      name: 'module_name',
      initialValue: selected.value,
      validator: FormBuilderValidators.required(
        errorText: context.l10n.cannotBeEmpty(context.l10n.aiModelName),
      ),
      builder: (field) {
        final scheme = context.colorScheme;
        final current = field.value;
        final borderColor = field.hasError
            ? scheme.error
            : Colors.grey.withValues(alpha: 0.3);

        Future<void> openPicker() async {
          final ids = models.value.map((model) => model.id).toList();
          if (ids.isEmpty) {
            ToastMessage.show(
              context.isZh ? '请先获取模型列表' : 'Load the model list first',
            );
            return;
          }
          final picked = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                _ModelSearchSheet(modelIds: ids, selected: current),
          );
          if (picked == null) return;
          selected.value = picked;
          field.didChange(picked);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: openPicker,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    if (current?.isNotEmpty == true) ...[
                      AiBrandIcon(
                        brand: AiBrand.resolve(modelName: current),
                        size: 20,
                        fallbackIcon: Icons.memory_rounded,
                      ),
                      SizedBox(width: 12.w),
                    ],
                    Expanded(
                      child: Text(
                        current?.isNotEmpty == true
                            ? current!
                            : context.l10n.aiModelNameHint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: current?.isNotEmpty == true
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.unfold_more_rounded,
                      size: 20.sp,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (field.hasError) ...[
              SizedBox(height: 6.h),
              Text(
                field.errorText ?? '',
                style: TextStyle(fontSize: 12.sp, color: scheme.error),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// 带搜索框的模型列表弹层。
class _ModelSearchSheet extends StatefulWidget {
  const _ModelSearchSheet({required this.modelIds, required this.selected});

  final List<String> modelIds;
  final String? selected;

  @override
  State<_ModelSearchSheet> createState() => _ModelSearchSheetState();
}

class _ModelSearchSheetState extends State<_ModelSearchSheet> {
  final TextEditingController _controller = TextEditingController();
  late List<String> _filtered = widget.modelIds;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQuery(String query) {
    final keyword = query.trim().toLowerCase();
    setState(() {
      _filtered = keyword.isEmpty
          ? widget.modelIds
          : widget.modelIds
                .where((id) => id.toLowerCase().contains(keyword))
                .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: context.isDark ? scheme.surfaceContainerLow : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
            child: Row(
              children: [
                Icon(Icons.hub_outlined, size: 18.sp, color: scheme.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    context.isZh ? '选择模型' : 'Select model',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: context.textTheme.titleMedium?.color,
                    ),
                  ),
                ),
                Text(
                  '${_filtered.length}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onQuery,
              style: TextStyle(fontSize: 14.sp, color: scheme.onSurface),
              decoration: _fieldDecoration(
                context,
                labelText: context.isZh ? '搜索模型' : 'Search models',
                prefixIcon: Icons.search_rounded,
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: scheme.outlineVariant.withValues(alpha: 0.6),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 40.sp,
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          context.isZh ? '没有匹配的模型' : 'No matching model',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final id = _filtered[index];
                      final isSelected = id == widget.selected;
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(id),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            children: [
                              AiBrandIcon(
                                brand: AiBrand.resolve(modelName: id),
                                size: 20,
                                fallbackIcon: Icons.memory_rounded,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  id,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? scheme.primary
                                        : scheme.onSurface,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 18.sp,
                                  color: scheme.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
