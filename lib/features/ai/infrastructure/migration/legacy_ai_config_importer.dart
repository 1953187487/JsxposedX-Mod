import 'package:JsxposedX/features/ai/data/datasources/config/ai_config_action_datasource.dart';
import 'package:JsxposedX/features/ai/data/datasources/config/ai_config_query_datasource.dart';
import 'package:JsxposedX/features/ai/data/models/ai_config_dto.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_catalog_repository.dart';

class LegacyAiConfigImporter {
  const LegacyAiConfigImporter({
    required AiConfigActionDatasource actionDataSource,
    required AiConfigQueryDatasource queryDataSource,
    required AiCatalogRepository catalogRepository,
    required AiCredentialStore credentialStore,
    DateTime Function()? now,
  }) : _actionDataSource = actionDataSource,
       _queryDataSource = queryDataSource,
       _catalogRepository = catalogRepository,
       _credentialStore = credentialStore,
       _now = now ?? DateTime.now;

  LegacyAiConfigImporter.forImport({
    required AiCatalogRepository catalogRepository,
    required AiCredentialStore credentialStore,
    DateTime Function()? now,
  }) : _actionDataSource = null,
       _queryDataSource = null,
       _catalogRepository = catalogRepository,
       _credentialStore = credentialStore,
       _now = now ?? DateTime.now;

  final AiConfigActionDatasource? _actionDataSource;
  final AiConfigQueryDatasource? _queryDataSource;
  final AiCatalogRepository _catalogRepository;
  final AiCredentialStore _credentialStore;
  final DateTime Function() _now;

  Future<LegacyAiImportReport> importAll() async {
    final actionDataSource = _actionDataSource;
    final queryDataSource = _queryDataSource;
    if (actionDataSource == null || queryDataSource == null) {
      throw StateError('Legacy data sources are not configured');
    }
    final byId = <String, AiConfigDto>{};
    for (final config in await queryDataSource.getBuiltinConfigs()) {
      if (config.id.isNotEmpty) byId[config.id] = config;
    }
    for (final config in await actionDataSource.getConfigList()) {
      if (config.id.isNotEmpty) byId[config.id] = config;
    }
    final active = await queryDataSource.getConfig();
    if (active.id.isNotEmpty) byId[active.id] = active;

    return importConfigs(byId.values);
  }

  Future<LegacyAiImportReport> importConfigs(
    Iterable<AiConfigDto> configs,
  ) async {
    final imported = <String>[];
    final failures = <LegacyAiImportFailure>[];
    for (final config in configs) {
      try {
        await _importOne(config);
        imported.add(config.id);
      } catch (error) {
        failures.add(
          LegacyAiImportFailure(configId: config.id, reason: '$error'),
        );
      }
    }
    return LegacyAiImportReport(
      importedConfigIds: List.unmodifiable(imported),
      failures: List.unmodifiable(failures),
    );
  }

  Future<void> importConfig(
    AiConfigDto config, {
    List<AiModelDefinition> discoveredModels = const [],
    String? systemPrompt,
    AiToolApprovalMode? approvalMode,
    int? maxToolRounds,
  }) {
    return _importOne(
      config,
      discoveredModels: discoveredModels,
      systemPrompt: systemPrompt,
      approvalMode: approvalMode,
      maxToolRounds: maxToolRounds,
    );
  }

  Future<void> _importOne(
    AiConfigDto legacy, {
    List<AiModelDefinition> discoveredModels = const [],
    String? systemPrompt,
    AiToolApprovalMode? approvalMode,
    int? maxToolRounds,
  }) async {
    final endpoint = _parseEndpoint(legacy.apiUrl, legacy.apiType);
    final connectionId = 'legacy-connection-${legacy.id}';
    final modelId = legacy.moduleName.trim();
    if (modelId.isEmpty) {
      throw const FormatException('Legacy model ID is empty');
    }
    String? credentialRef;
    AiSecret? previousSecret;
    if (legacy.apiKey.isNotEmpty) {
      const legacyCredentialPrefix = 'legacy-';
      final expectedReference = '$legacyCredentialPrefix${legacy.id}';
      previousSecret = await _credentialStore.read(expectedReference);
      credentialRef = await _credentialStore.put(
        AiSecret(legacy.apiKey),
        credentialRef: expectedReference,
      );
    }
    final existingConnection = await _catalogRepository.getConnection(
      connectionId,
    );
    final connection =
        (existingConnection ??
                AiProviderConnection(
                  id: connectionId,
                  providerId: endpoint.providerId,
                  displayName: legacy.name.isEmpty ? modelId : legacy.name,
                  baseUri: endpoint.baseUri,
                ))
            .copyWith(
              providerId: endpoint.providerId,
              displayName: legacy.name.isEmpty ? modelId : legacy.name,
              baseUri: endpoint.baseUri,
              credentialRef: credentialRef ?? existingConnection?.credentialRef,
              endpointOverrides: endpoint.overrides,
            );
    final selectedModel = AiModelDefinition(
      id: modelId,
      connectionId: connectionId,
      displayName: modelId,
      capabilities: const AiModelCapabilities(
        streaming: true,
        toolCalling: true,
      ),
      limits: AiModelLimits(
        maxOutputTokens: legacy.maxToken > 0 ? legacy.maxToken : null,
      ),
      source: 'legacyImport',
    );
    final modelById = <String, AiModelDefinition>{
      for (final model in await _catalogRepository.getModels(connectionId))
        model.id: model,
      for (final model in discoveredModels)
        if (model.connectionId == connectionId) model.id: model,
    };
    modelById[modelId] = (modelById[modelId] ?? selectedModel).copyWith(
      displayName: modelById[modelId]?.displayName ?? selectedModel.displayName,
      limits: (modelById[modelId]?.limits ?? selectedModel.limits).copyWith(
        maxOutputTokens:
            modelById[modelId]?.limits.maxOutputTokens ??
            selectedModel.limits.maxOutputTokens,
      ),
    );
    final now = _now().toUtc();
    final assistantId = 'legacy-assistant-${legacy.id}';
    final existingAssistant = await _catalogRepository.getAssistant(
      assistantId,
    );
    final assistant =
        (existingAssistant ??
                AiAssistantProfile(
                  id: assistantId,
                  name: legacy.name.isEmpty ? modelId : legacy.name,
                  connectionId: connectionId,
                  modelId: modelId,
                  generation: AiGenerationOptions(
                    maxOutputTokens: legacy.maxToken > 0
                        ? legacy.maxToken
                        : null,
                    temperature: legacy.temperature >= 0
                        ? legacy.temperature
                        : null,
                  ),
                  contextPolicy: kDefaultContextPolicy,
                  createdAt: now,
                  updatedAt: now,
                ))
            .copyWith(
              name: legacy.name.isEmpty ? modelId : legacy.name,
              connectionId: connectionId,
              modelId: modelId,
              systemPrompt: systemPrompt?.trim().isEmpty == true
                  ? null
                  : systemPrompt?.trim() ?? existingAssistant?.systemPrompt,
              // 上下文策略为全局固化行为，导入时统一收敛到系统默认值。
              contextPolicy: kDefaultContextPolicy,
              toolPolicy:
                  (existingAssistant?.toolPolicy ?? const AiToolPolicy())
                      .copyWith(
                        approvalMode:
                            approvalMode ??
                            existingAssistant?.toolPolicy.approvalMode ??
                            AiToolApprovalMode.riskyOnly,
                        // 统一走解析收敛：非正值（含 0）回落默认值，
                        // 历史默认 8 视为未调整迁移为 24，显式合法值保留。
                        maxRounds: resolveMaxToolRounds(
                          maxToolRounds ??
                              existingAssistant?.toolPolicy.maxRounds ??
                              kDefaultMaxToolRounds,
                        ),
                      ),
              updatedAt: now,
            );

    try {
      await _catalogRepository.saveConnectionBundle(
        connection: connection,
        models: modelById.values.toList(growable: false),
        assistants: [assistant],
      );
    } catch (_) {
      if (credentialRef != null) {
        if (previousSecret == null) {
          await _credentialStore.delete(credentialRef);
        } else {
          await _credentialStore.put(
            previousSecret,
            credentialRef: credentialRef,
          );
        }
      }
      rethrow;
    }
  }

  static _LegacyEndpoint _parseEndpoint(String rawUrl, String rawApiType) {
    final parsed = Uri.tryParse(rawUrl.trim());
    if (parsed == null || !parsed.hasScheme || parsed.host.isEmpty) {
      throw const FormatException('Legacy API URL is invalid');
    }
    final type = rawApiType.toLowerCase();
    final kind = switch (type) {
      'openairesponses' ||
      'openai_responses' ||
      'openai-responses' => AiEndpointKind.responses,
      'anthropic' => AiEndpointKind.messages,
      _ => AiEndpointKind.chatCompletions,
    };
    final providerId = switch (kind) {
      AiEndpointKind.responses => 'openai-responses',
      AiEndpointKind.messages => 'anthropic',
      _ => 'openai',
    };
    final suffix = switch (kind) {
      AiEndpointKind.chatCompletions => '/chat/completions',
      AiEndpointKind.responses => '/responses',
      AiEndpointKind.messages => '/messages',
      AiEndpointKind.models => '/models',
    };
    final normalizedPath = parsed.path.endsWith('/') && parsed.path.length > 1
        ? parsed.path.substring(0, parsed.path.length - 1)
        : parsed.path;
    if (normalizedPath.endsWith(suffix)) {
      final basePath = normalizedPath.substring(
        0,
        normalizedPath.length - suffix.length,
      );
      return _LegacyEndpoint(
        providerId: providerId,
        baseUri: _withoutQuery(parsed, '$basePath/'),
        overrides: {kind: parsed.replace(path: normalizedPath)},
      );
    }
    final basePath = normalizedPath.endsWith('/v1')
        ? '$normalizedPath/'
        : '${normalizedPath == '/' ? '' : normalizedPath}/v1/';
    return _LegacyEndpoint(
      providerId: providerId,
      baseUri: _withoutQuery(parsed, basePath),
      overrides: const {},
    );
  }

  static Uri _withoutQuery(Uri uri, String path) {
    return Uri(
      scheme: uri.scheme,
      userInfo: uri.userInfo,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: path,
    );
  }
}

class LegacyAiImportReport {
  const LegacyAiImportReport({
    required this.importedConfigIds,
    required this.failures,
  });

  final List<String> importedConfigIds;
  final List<LegacyAiImportFailure> failures;

  bool get isSuccessful => failures.isEmpty;
}

class LegacyAiImportFailure {
  const LegacyAiImportFailure({required this.configId, required this.reason});

  final String configId;
  final String reason;
}

class _LegacyEndpoint {
  const _LegacyEndpoint({
    required this.providerId,
    required this.baseUri,
    required this.overrides,
  });

  final String providerId;
  final Uri baseUri;
  final Map<AiEndpointKind, Uri> overrides;
}
