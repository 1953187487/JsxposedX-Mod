import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

abstract interface class AiCatalogRepository {
  Future<List<AiProviderConnection>> getConnections();

  Future<AiProviderConnection?> getConnection(String id);

  Future<void> saveConnection(AiProviderConnection connection);

  Future<void> saveConnectionBundle({
    required AiProviderConnection connection,
    required List<AiModelDefinition> models,
    required List<AiAssistantProfile> assistants,
  });

  Future<void> deleteConnection(String id);

  Future<List<AiModelDefinition>> getModels(String connectionId);

  Future<AiModelDefinition?> getModel(String connectionId, String modelId);

  Future<void> saveModels(String connectionId, List<AiModelDefinition> models);

  Future<void> deleteModel(String connectionId, String modelId);

  Future<List<AiAssistantProfile>> getAssistants();

  Future<AiAssistantProfile?> getAssistant(String id);

  Future<void> saveAssistant(AiAssistantProfile assistant);

  Future<void> deleteAssistant(String id);
}
