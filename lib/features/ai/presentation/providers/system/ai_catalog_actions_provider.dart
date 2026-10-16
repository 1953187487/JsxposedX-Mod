import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_chat_session_provider.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';

part 'ai_catalog_actions_provider.g.dart';

@Riverpod(keepAlive: true)
class AiCatalogActionsV2 extends _$AiCatalogActionsV2 {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<AiProviderConnection> saveConnection(
    AiProviderConnection connection, {
    String? secret,
  }) async {
    state = const AsyncLoading();
    final credentialStore = ref.read(aiCredentialStoreProvider);
    final repository = ref.read(aiCatalogRepositoryProvider);
    final trimmedSecret = secret?.trim();
    final originalReference = connection.credentialRef;
    AiSecret? originalSecret;
    String? savedReference;
    try {
      var savedConnection = connection;
      if (trimmedSecret != null && trimmedSecret.isNotEmpty) {
        final reference = originalReference ?? connection.id;
        originalSecret = await credentialStore.read(reference);
        savedReference = await credentialStore.put(
          AiSecret(trimmedSecret),
          credentialRef: reference,
        );
        savedConnection = connection.copyWith(credentialRef: savedReference);
      }
      await repository.saveConnection(savedConnection);
      state = const AsyncData(null);
      ref.invalidate(aiConnectionsV2Provider);
      return savedConnection;
    } catch (error, stackTrace) {
      if (savedReference != null) {
        if (originalSecret == null) {
          await credentialStore.delete(savedReference);
        } else {
          await credentialStore.put(
            originalSecret,
            credentialRef: savedReference,
          );
        }
      }
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> clearCredential(AiProviderConnection connection) async {
    final reference = connection.credentialRef;
    if (reference == null) return;
    state = const AsyncLoading();
    try {
      await ref
          .read(aiCatalogRepositoryProvider)
          .saveConnection(connection.copyWith(credentialRef: null));
      await ref.read(aiCredentialStoreProvider).delete(reference);
      state = const AsyncData(null);
      ref.invalidate(aiConnectionsV2Provider);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteConnection(AiProviderConnection connection) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(aiCatalogRepositoryProvider)
          .deleteConnection(connection.id);
      final reference = connection.credentialRef;
      if (reference != null) {
        await ref.read(aiCredentialStoreProvider).delete(reference);
      }
      state = const AsyncData(null);
      ref.invalidate(aiConnectionsV2Provider);
      ref.invalidate(aiModelsV2Provider(connection.id));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> saveModel(AiModelDefinition model) async {
    state = const AsyncLoading();
    try {
      await ref.read(aiCatalogRepositoryProvider).saveModels(
        model.connectionId,
        [model],
      );
      state = const AsyncData(null);
      ref.invalidate(aiModelsV2Provider(model.connectionId));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteModel(AiModelDefinition model) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(aiCatalogRepositoryProvider)
          .deleteModel(model.connectionId, model.id);
      state = const AsyncData(null);
      ref.invalidate(aiModelsV2Provider(model.connectionId));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> saveAssistant(AiAssistantProfile assistant) async {
    state = const AsyncLoading();
    try {
      await ref.read(aiCatalogRepositoryProvider).saveAssistant(assistant);
      state = const AsyncData(null);
      ref.invalidate(aiAssistantsV2Provider);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteAssistant(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read(aiCatalogRepositoryProvider).deleteAssistant(id);
      state = const AsyncData(null);
      ref.invalidate(aiAssistantsV2Provider);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<AiConversation> createConversation({
    required String assistantId,
    String? title,
    String environmentId = 'general',
    String? scopeId,
  }) async {
    state = const AsyncLoading();
    try {
      final assistant = await ref
          .read(aiCatalogRepositoryProvider)
          .getAssistant(assistantId);
      if (assistant == null) {
        throw StateError(
          'Cannot create a conversation for a missing assistant',
        );
      }
      final now = DateTime.now().toUtc();
      final conversation = AiConversation(
        id: const Uuid().v4(),
        title: title?.trim().isNotEmpty == true
            ? title!.trim()
            : assistant.name,
        assistantId: assistantId,
        environmentId: environmentId,
        scopeId: scopeId,
        createdAt: now,
        updatedAt: now,
      );
      await ref
          .read(aiConversationRepositoryV2Provider)
          .saveConversation(conversation);
      state = const AsyncData(null);
      ref.invalidate(
        aiConversationsV2Provider(
          environmentId: environmentId,
          scopeId: scopeId,
        ),
      );
      return conversation;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteConversation(
    String id, {
    String? packageName,
    bool isZh = true,
  }) async {
    state = const AsyncLoading();
    try {
      if (ref
              .read(
                aiChatSessionV2Provider(
                  id,
                  packageName: packageName,
                  isZh: isZh,
                ),
              )
              .value
              ?.hasActiveRun ==
          true) {
        throw StateError('Stop the active response before deleting this chat');
      }
      await ref.read(aiConversationRepositoryV2Provider).deleteConversation(id);
      ref.invalidate(
        aiChatSessionV2Provider(id, packageName: packageName, isZh: isZh),
      );
      ref.invalidate(aiConversationsV2Provider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
