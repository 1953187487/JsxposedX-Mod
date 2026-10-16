import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/data/models/ai_config_dto.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_ai_catalog_repository.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart'
    as standard;
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';
import 'package:JsxposedX/features/ai/infrastructure/migration/legacy_ai_config_importer.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart';

void main() {
  late AiDatabase database;
  late DriftAiCatalogRepository catalog;
  late _MemoryCredentialStore credentials;
  late LegacyAiConfigImporter importer;

  setUp(() {
    database = AiDatabase.forTesting(NativeDatabase.memory());
    catalog = DriftAiCatalogRepository(database);
    credentials = _MemoryCredentialStore();
    importer = LegacyAiConfigImporter.forImport(
      catalogRepository: catalog,
      credentialStore: credentials,
      now: () => DateTime.utc(2026, 9, 5),
    );
  });

  tearDown(() => database.close());

  test('imports legacy endpoint, key reference, model and assistant', () async {
    const legacy = AiConfigDto(
      id: 'old',
      name: 'Old config',
      apiKey: 'secret',
      apiUrl: 'https://example.test/v1/chat/completions?route=a',
      moduleName: 'model-1',
      maxToken: 2048,
      temperature: 0.5,
      memoryRounds: 7,
      apiType: 'openai',
    );

    final report = await importer.importConfigs([legacy]);

    expect(report.isSuccessful, isTrue);
    final connection = await catalog.getConnection('legacy-connection-old');
    expect(connection?.baseUri.toString(), 'https://example.test/v1/');
    expect(
      connection?.endpointOverrides.values.single.toString(),
      'https://example.test/v1/chat/completions?route=a',
    );
    expect(connection?.credentialRef, 'legacy-old');
    expect(credentials.values['legacy-old'], 'secret');
    expect(
      (await catalog.getModel(
        'legacy-connection-old',
        'model-1',
      ))?.capabilities.toolCalling,
      isTrue,
    );
    final assistant = await catalog.getAssistant('legacy-assistant-old');
    // 上下文策略为系统固化行为，历史 memoryRounds 不再迁移为用户可调项。
    expect(
      assistant?.contextPolicy.recentMessageLimit,
      standard.kDefaultContextPolicy.recentMessageLimit,
    );
  });

  test('is idempotent and reports invalid entries independently', () async {
    const valid = AiConfigDto(
      id: 'valid',
      apiUrl: 'https://example.test/v1',
      moduleName: 'model',
    );
    const invalid = AiConfigDto(
      id: 'invalid',
      apiUrl: 'not a uri',
      moduleName: 'model',
    );

    await importer.importConfigs([valid]);
    final report = await importer.importConfigs([valid, invalid]);

    expect(report.importedConfigIds, ['valid']);
    expect(report.failures.single.configId, 'invalid');
    expect(await catalog.getConnections(), hasLength(1));
  });

  test('atomically keeps discovered models and assistant settings', () async {
    const legacy = AiConfigDto(
      id: 'standard',
      name: 'Standard config',
      apiKey: 'secret',
      apiUrl: 'https://example.test/v1',
      moduleName: 'model-2',
    );

    await importer.importConfig(
      legacy,
      discoveredModels: const [
        standard.AiModelDefinition(
          id: 'model-1',
          connectionId: 'legacy-connection-standard',
          displayName: 'Model 1',
          capabilities: standard.AiModelCapabilities(streaming: true),
          limits: standard.AiModelLimits(contextTokens: 8192),
        ),
        standard.AiModelDefinition(
          id: 'model-2',
          connectionId: 'legacy-connection-standard',
          displayName: 'Model 2',
          capabilities: standard.AiModelCapabilities(
            streaming: true,
            toolCalling: true,
          ),
          limits: standard.AiModelLimits(contextTokens: 32768),
        ),
      ],
      systemPrompt: 'Analyze precisely.',
      approvalMode: standard.AiToolApprovalMode.always,
      maxToolRounds: 12,
    );

    final models = await catalog.getModels('legacy-connection-standard');
    expect(
      models.map((model) => model.id),
      containsAll(['model-1', 'model-2']),
    );
    final assistant = await catalog.getAssistant('legacy-assistant-standard');
    expect(assistant?.modelId, 'model-2');
    expect(assistant?.systemPrompt, 'Analyze precisely.');
    // 上下文策略为系统固化行为，导入后统一采用默认值。
    expect(assistant?.contextPolicy.mode, standard.kDefaultContextPolicy.mode);
    expect(
      assistant?.toolPolicy.approvalMode,
      standard.AiToolApprovalMode.always,
    );
    expect(assistant?.toolPolicy.maxRounds, 12);
  });

  test('rolls back catalog data and a new credential on failure', () async {
    await database.customStatement('''
      CREATE TRIGGER reject_legacy_assistant
      BEFORE INSERT ON ai_assistant_profiles
      BEGIN
        SELECT RAISE(ABORT, 'test failure');
      END;
    ''');
    const legacy = AiConfigDto(
      id: 'broken',
      apiKey: 'secret',
      apiUrl: 'https://example.test/v1',
      moduleName: 'model',
    );

    final report = await importer.importConfigs([legacy]);

    expect(report.failures, hasLength(1));
    expect(await catalog.getConnection('legacy-connection-broken'), isNull);
    expect(credentials.values, isEmpty);
  });
}

class _MemoryCredentialStore implements AiCredentialStore {
  final Map<String, String> values = {};

  @override
  Future<String> put(AiSecret secret, {String? credentialRef}) async {
    final reference = credentialRef ?? 'generated';
    values[reference] = secret.value;
    return reference;
  }

  @override
  Future<AiSecret?> read(String credentialRef) async {
    final value = values[credentialRef];
    return value == null ? null : AiSecret(value);
  }

  @override
  Future<void> delete(String credentialRef) async {
    values.remove(credentialRef);
  }
}
