import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/core/services/app_storage.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_orchestrator.dart';
import 'package:JsxposedX/features/ai/data/datasources/config/ai_config_action_datasource.dart';
import 'package:JsxposedX/features/ai/data/datasources/config/ai_config_query_datasource.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_ai_catalog_repository.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/data/repositories/drift_script_log_repository.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';
import 'package:JsxposedX/features/ai/domain/registries/protocol_adapter_registry.dart';
import 'package:JsxposedX/features/ai/domain/registries/provider_definition_registry.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_catalog_repository.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_conversation_repository.dart';
import 'package:JsxposedX/features/ai/domain/repositories/script_log_repository.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/anthropic_messages_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_chat_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_responses_adapter.dart';
import 'package:JsxposedX/features/ai/infrastructure/migration/legacy_ai_config_importer.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart'
    hide
        AiAssistantProfile,
        AiConversation,
        AiModelDefinition,
        AiProviderConnection;
import 'package:JsxposedX/features/ai/infrastructure/security/platform_ai_credential_store.dart';
import 'package:JsxposedX/features/ai/infrastructure/transport/dio_ai_transport.dart';

part 'ai_system_providers.g.dart';

const _legacyMigrationMarker = 'ai_v2_legacy_import_completed_v2';

@Riverpod(keepAlive: true)
AiDatabase aiDatabase(Ref ref) {
  final database = AiDatabase();
  ref.onDispose(database.close);
  return database;
}

@Riverpod(keepAlive: true)
AiCatalogRepository aiCatalogRepository(Ref ref) {
  return DriftAiCatalogRepository(ref.watch(aiDatabaseProvider));
}

@Riverpod(keepAlive: true)
AiConversationRepository aiConversationRepositoryV2(Ref ref) {
  return DriftAiConversationRepository(ref.watch(aiDatabaseProvider));
}

@Riverpod(keepAlive: true)
ScriptLogRepository scriptLogRepository(Ref ref) {
  return DriftScriptLogRepository(ref.watch(aiDatabaseProvider));
}

@Riverpod(keepAlive: true)
ScriptConversationBinding scriptConversationBinding(Ref ref) {
  return ScriptConversationBinding(ref.watch(scriptLogRepositoryProvider));
}

@Riverpod(keepAlive: true)
AiCredentialStore aiCredentialStore(Ref ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return const PlatformAiCredentialStore(storage);
}

@Riverpod(keepAlive: true)
ProviderDefinitionRegistry aiProviderDefinitionRegistry(Ref ref) {
  return ProviderDefinitionRegistry(const [
    AiProviderDefinition(
      id: 'openai',
      displayName: 'OpenAI Compatible',
      adapterId: 'openai.chat.v1',
    ),
    AiProviderDefinition(
      id: 'openai-responses',
      displayName: 'OpenAI Responses',
      adapterId: 'openai.responses.v1',
    ),
    AiProviderDefinition(
      id: 'anthropic',
      displayName: 'Anthropic',
      adapterId: 'anthropic.messages.v1',
      authScheme: AiAuthScheme.apiKeyHeader,
      authParameterName: 'x-api-key',
    ),
  ]);
}

@Riverpod(keepAlive: true)
ProtocolAdapterRegistry aiProtocolAdapterRegistry(Ref ref) {
  return ProtocolAdapterRegistry(const [
    OpenAiChatAdapter(),
    OpenAiResponsesAdapter(),
    AnthropicMessagesAdapter(),
  ]);
}

@Riverpod(keepAlive: true)
Dio aiDio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 5),
      validateStatus: (_) => true,
    ),
  );
  ref.onDispose(() => dio.close(force: true));
  return dio;
}

@Riverpod(keepAlive: true)
AiTransport aiTransport(Ref ref) {
  return DioAiTransport(ref.watch(aiDioProvider));
}

@Riverpod(keepAlive: true)
AiChatOrchestrator aiChatOrchestrator(Ref ref) {
  return AiChatOrchestrator(
    providerRegistry: ref.watch(aiProviderDefinitionRegistryProvider),
    adapterRegistry: ref.watch(aiProtocolAdapterRegistryProvider),
    transport: ref.watch(aiTransportProvider),
    credentialStore: ref.watch(aiCredentialStoreProvider),
  );
}

@Riverpod(keepAlive: true)
Future<LegacyAiImportReport?> aiSystemMigration(Ref ref) async {
  final preferences = await ref.watch(sharedPreferencesProvider.future);
  if (preferences.getBool(_legacyMigrationMarker) == true) return null;
  final storage = ref.watch(piniaStorageLocalProvider);
  final importer = LegacyAiConfigImporter(
    actionDataSource: AiConfigActionDatasource(storage: storage),
    queryDataSource: AiConfigQueryDatasource(storage: storage),
    catalogRepository: ref.watch(aiCatalogRepositoryProvider),
    credentialStore: ref.watch(aiCredentialStoreProvider),
  );
  final report = await importer.importAll();
  if (report.isSuccessful) {
    await preferences.setBool(_legacyMigrationMarker, true);
  }
  return report;
}

@riverpod
Future<List<AiProviderConnection>> aiConnectionsV2(Ref ref) async {
  await ref.watch(aiSystemMigrationProvider.future);
  return ref.watch(aiCatalogRepositoryProvider).getConnections();
}

@riverpod
Future<List<AiAssistantProfile>> aiAssistantsV2(Ref ref) async {
  await ref.watch(aiSystemMigrationProvider.future);
  return ref.watch(aiCatalogRepositoryProvider).getAssistants();
}

@riverpod
Future<List<AiModelDefinition>> aiModelsV2(Ref ref, String connectionId) async {
  await ref.watch(aiSystemMigrationProvider.future);
  return ref.watch(aiCatalogRepositoryProvider).getModels(connectionId);
}

@riverpod
Future<List<AiConversation>> aiConversationsV2(
  Ref ref, {
  String environmentId = 'general',
  String? scopeId,
}) async {
  await ref.watch(aiSystemMigrationProvider.future);
  final repository = ref.watch(aiConversationRepositoryV2Provider);
  final conversations = <AiConversation>[];
  AiConversationCursor? cursor;
  while (true) {
    final page = await repository.getConversations(before: cursor, limit: 100);
    conversations.addAll(page);
    if (page.length < 100) break;
    final last = page.last;
    cursor = AiConversationCursor(updatedAt: last.updatedAt, id: last.id);
  }
  return conversations
      .where(
        (conversation) =>
            conversation.environmentId == environmentId &&
            conversation.scopeId == scopeId,
      )
      .toList(growable: false);
}
