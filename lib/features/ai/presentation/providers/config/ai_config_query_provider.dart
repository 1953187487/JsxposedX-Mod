import 'package:JsxposedX/core/enums/ai_api_type.dart';
import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/core/networks/http_service.dart';
import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/features/ai/data/datasources/config/ai_config_action_datasource.dart';
import 'package:JsxposedX/features/ai/data/datasources/config/ai_config_query_datasource.dart';
import 'package:JsxposedX/features/ai/data/repositories/config/ai_config_query_repository_impl.dart'
    as impl;
import 'package:JsxposedX/features/ai/domain/constants/builtin_ai_config.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_model.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/repositories/config/ai_config_query_repository.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_config_query_provider.g.dart';

@riverpod
AiConfigQueryRepository aiConfigQueryRepository(Ref ref) {
  final storage = ref.watch(piniaStorageLocalProvider);
  final httpService = ref.watch(httpServiceProvider);
  final dataSource = AiConfigQueryDatasource(
    storage: storage,
    httpService: httpService,
  );
  return impl.AiConfigQueryRepositoryImpl(dataSource: dataSource);
}

/// 获取 AI 配置
@riverpod
Future<List<AiModel>> aiModels(Ref ref) async {
  final config = await ref.watch(aiConfigProvider.future);
  return await ref
      .watch(aiConfigQueryRepositoryProvider)
      .getModels(config: config);
}

final aiModelsRefreshActionProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final config = await ref.read(aiConfigProvider.future);
    await ref
        .read(aiConfigQueryRepositoryProvider)
        .getModels(config: config, forceRefresh: true);
    ref.invalidate(aiModelsProvider);
  };
});

/// 获取 AI 配置
@riverpod
Future<AiConfig> aiConfig(Ref ref) async {
  return await ref.watch(aiConfigQueryRepositoryProvider).getConfig();
}

/// 获取 AI 配置列表
@riverpod
Future<List<AiConfig>> aiConfigList(Ref ref) async {
  final storage = ref.watch(piniaStorageLocalProvider);
  final actionDataSource = AiConfigActionDatasource(storage: storage);
  final queryDataSource = AiConfigQueryDatasource(storage: storage);
  final builtinConfigs = await queryDataSource.getBuiltinConfigs();
  final standardConfigs = await _readStandardCustomConfigs(ref);
  if (standardConfigs.isNotEmpty) {
    return [...builtinConfigs.map((dto) => dto.toEntity()), ...standardConfigs];
  }

  // Existing installs can still have an empty catalog when migration has not
  // completed. Keep the old list as a read-only fallback for that case.
  final legacyConfigs = await actionDataSource.getConfigList();
  return [
    ...builtinConfigs.map((dto) => dto.toEntity()),
    ...legacyConfigs.map((dto) => dto.toEntity()),
  ];
}

Future<List<AiConfig>> _readStandardCustomConfigs(Ref ref) async {
  try {
    await ref.read(aiSystemMigrationProvider.future);
    final catalog = ref.read(aiCatalogRepositoryProvider);
    final connections = await catalog.getConnections();
    final configs = <AiConfig>[];
    for (final connection in connections) {
      const prefix = 'legacy-connection-';
      if (!connection.id.startsWith(prefix)) continue;
      final configId = connection.id.substring(prefix.length);
      if (configId.isEmpty || isBuiltinAiConfigId(configId)) continue;

      final models = await catalog.getModels(connection.id);
      if (models.isEmpty) continue;
      final assistant = await catalog.getAssistant(
        'legacy-assistant-$configId',
      );
      final model = models.firstWhere(
        (item) => item.id == assistant?.modelId,
        orElse: () => models.first,
      );
      final apiType = _apiTypeForProvider(connection.providerId);
      final endpoint =
          connection.endpointOverrides[_endpointForApiType(apiType)];
      final apiUrl = (endpoint ?? connection.baseUri).toString();
      final apiKey = connection.credentialRef == null
          ? ''
          : (await ref
                        .read(aiCredentialStoreProvider)
                        .read(connection.credentialRef!))
                    ?.value ??
                '';
      configs.add(
        AiConfig(
          id: configId,
          name: connection.displayName,
          apiKey: apiKey,
          apiUrl: apiUrl,
          moduleName: model.id,
          maxToken:
              assistant?.generation.maxOutputTokens ??
              model.limits.maxOutputTokens ??
              0,
          temperature: assistant?.generation.temperature ?? -1,
          memoryRounds:
              assistant?.contextPolicy.mode == AiContextMode.recentMessages
              ? (assistant?.contextPolicy.recentMessageLimit ?? 0).toDouble()
              : 0,
          apiType: apiType,
        ),
      );
    }
    return configs;
  } catch (_) {
    return const [];
  }
}

AiApiType _apiTypeForProvider(String providerId) => switch (providerId) {
  'openai-responses' => AiApiType.openaiResponses,
  'anthropic' => AiApiType.anthropic,
  _ => AiApiType.openai,
};

AiEndpointKind _endpointForApiType(AiApiType apiType) => switch (apiType) {
  AiApiType.openai => AiEndpointKind.chatCompletions,
  AiApiType.openaiResponses => AiEndpointKind.responses,
  AiApiType.anthropic => AiEndpointKind.messages,
};

class ActiveAiConfigMeta {
  const ActiveAiConfigMeta({
    required this.config,
    required this.isBuiltin,
    required this.displayLabel,
  });

  final AiConfig config;
  final bool isBuiltin;
  final String displayLabel;
}

final activeAiConfigMetaProvider = Provider<AsyncValue<ActiveAiConfigMeta>>((
  ref,
) {
  final configAsync = ref.watch(aiConfigProvider);
  return configAsync.whenData((config) {
    return ActiveAiConfigMeta(
      config: config,
      isBuiltin: isBuiltinAiConfig(config),
      displayLabel: config.name,
    );
  });
});
