import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:JsxposedX/features/ai/data/models/ai_assistant_profile_dto.dart';
import 'package:JsxposedX/features/ai/data/models/ai_model_definition_dto.dart';
import 'package:JsxposedX/features/ai/data/models/ai_provider_connection_dto.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_catalog_repository.dart';
import 'package:JsxposedX/features/ai/domain/services/ai_connection_validator.dart';
import 'package:JsxposedX/features/ai/infrastructure/persistence/ai_database.dart'
    hide AiAssistantProfile, AiModelDefinition, AiProviderConnection;

class DriftAiCatalogRepository implements AiCatalogRepository {
  const DriftAiCatalogRepository(this._database);

  final AiDatabase _database;

  @override
  Future<List<AiProviderConnection>> getConnections() async {
    final rows = await (_database.select(
      _database.aiProviderConnections,
    )..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])).get();
    return rows
        .map((row) => _connectionFromJson(row.payloadJson))
        .toList(growable: false);
  }

  @override
  Future<AiProviderConnection?> getConnection(String id) async {
    final row = await (_database.select(
      _database.aiProviderConnections,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _connectionFromJson(row.payloadJson);
  }

  @override
  Future<void> saveConnection(AiProviderConnection connection) async {
    await _saveConnection(connection);
  }

  @override
  Future<void> saveConnectionBundle({
    required AiProviderConnection connection,
    required List<AiModelDefinition> models,
    required List<AiAssistantProfile> assistants,
  }) async {
    _validateModels(connection.id, models);
    _validateAssistants(connection.id, models, assistants);
    await _database.transaction(() async {
      await _saveConnection(connection);
      await _saveModels(connection.id, models);
      for (final assistant in assistants) {
        await _saveAssistant(assistant);
      }
    });
  }

  Future<void> _saveConnection(AiProviderConnection connection) async {
    validateAiProviderConnection(connection);
    final payload = jsonEncode(
      AiProviderConnectionDto.fromEntity(connection).toJson(),
    );
    await _database
        .into(_database.aiProviderConnections)
        .insertOnConflictUpdate(
          AiProviderConnectionsCompanion.insert(
            id: connection.id,
            payloadJson: payload,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }

  @override
  Future<void> deleteConnection(String id) async {
    await _database.transaction(() async {
      final referencedAssistant =
          await (_database.select(_database.aiAssistantProfiles)
                ..where((table) => table.connectionId.equals(id))
                ..limit(1))
              .getSingleOrNull();
      if (referencedAssistant != null) {
        throw StateError(
          'Cannot delete connection $id while assistants reference it',
        );
      }
      await (_database.delete(
        _database.aiModelDefinitions,
      )..where((table) => table.connectionId.equals(id))).go();
      await (_database.delete(
        _database.aiProviderConnections,
      )..where((table) => table.id.equals(id))).go();
    });
  }

  @override
  Future<List<AiModelDefinition>> getModels(String connectionId) async {
    final rows = await (_database.select(
      _database.aiModelDefinitions,
    )..where((table) => table.connectionId.equals(connectionId))).get();
    return rows
        .map((row) => _modelFromJson(row.payloadJson))
        .toList(growable: false);
  }

  @override
  Future<AiModelDefinition?> getModel(
    String connectionId,
    String modelId,
  ) async {
    final row =
        await (_database.select(_database.aiModelDefinitions)..where(
              (table) =>
                  table.connectionId.equals(connectionId) &
                  table.modelId.equals(modelId),
            ))
            .getSingleOrNull();
    return row == null ? null : _modelFromJson(row.payloadJson);
  }

  @override
  Future<void> saveModels(
    String connectionId,
    List<AiModelDefinition> models,
  ) async {
    _validateModels(connectionId, models);
    if (await getConnection(connectionId) == null) {
      throw StateError(
        'Cannot save models for missing connection $connectionId',
      );
    }
    await _saveModels(connectionId, models);
  }

  Future<void> _saveModels(
    String connectionId,
    List<AiModelDefinition> models,
  ) async {
    await _database.batch((batch) {
      final now = DateTime.now().toUtc();
      batch.insertAllOnConflictUpdate(
        _database.aiModelDefinitions,
        models
            .map(
              (model) => AiModelDefinitionsCompanion.insert(
                connectionId: connectionId,
                modelId: model.id,
                payloadJson: jsonEncode(
                  AiModelDefinitionDto.fromEntity(model).toJson(),
                ),
                updatedAt: now,
              ),
            )
            .toList(growable: false),
      );
    });
  }

  @override
  Future<void> deleteModel(String connectionId, String modelId) async {
    final referencedAssistant =
        await (_database.select(_database.aiAssistantProfiles)
              ..where(
                (table) =>
                    table.connectionId.equals(connectionId) &
                    table.modelId.equals(modelId),
              )
              ..limit(1))
            .getSingleOrNull();
    if (referencedAssistant != null) {
      throw StateError(
        'Cannot delete model $modelId while assistants reference it',
      );
    }
    await (_database.delete(_database.aiModelDefinitions)..where(
          (table) =>
              table.connectionId.equals(connectionId) &
              table.modelId.equals(modelId),
        ))
        .go();
  }

  @override
  Future<List<AiAssistantProfile>> getAssistants() async {
    final rows = await (_database.select(
      _database.aiAssistantProfiles,
    )..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])).get();
    return rows
        .map((row) => _assistantFromJson(row.payloadJson))
        .toList(growable: false);
  }

  @override
  Future<AiAssistantProfile?> getAssistant(String id) async {
    final row = await (_database.select(
      _database.aiAssistantProfiles,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _assistantFromJson(row.payloadJson);
  }

  @override
  Future<void> saveAssistant(AiAssistantProfile assistant) async {
    final connection = await getConnection(assistant.connectionId);
    final model = await getModel(assistant.connectionId, assistant.modelId);
    if (connection == null || model == null) {
      throw StateError('Assistant references a missing connection or model');
    }
    await _saveAssistant(assistant);
  }

  Future<void> _saveAssistant(AiAssistantProfile assistant) async {
    await _database
        .into(_database.aiAssistantProfiles)
        .insertOnConflictUpdate(
          AiAssistantProfilesCompanion.insert(
            id: assistant.id,
            connectionId: assistant.connectionId,
            modelId: assistant.modelId,
            payloadJson: jsonEncode(
              AiAssistantProfileDto.fromEntity(assistant).toJson(),
            ),
            updatedAt: assistant.updatedAt.toUtc(),
          ),
        );
  }

  @override
  Future<void> deleteAssistant(String id) async {
    final referencedConversation =
        await (_database.select(_database.aiConversations)
              ..where((table) => table.assistantId.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (referencedConversation != null) {
      throw StateError(
        'Cannot delete assistant $id while conversations reference it',
      );
    }
    await (_database.delete(
      _database.aiAssistantProfiles,
    )..where((table) => table.id.equals(id))).go();
  }

  static void _validateModels(
    String connectionId,
    List<AiModelDefinition> models,
  ) {
    if (models.any((model) => model.connectionId != connectionId)) {
      throw ArgumentError('All models must belong to $connectionId');
    }
    final modelIds = models.map((model) => model.id).toSet();
    if (modelIds.length != models.length || modelIds.any((id) => id.isEmpty)) {
      throw ArgumentError('Model IDs must be non-empty and unique');
    }
  }

  static void _validateAssistants(
    String connectionId,
    List<AiModelDefinition> models,
    List<AiAssistantProfile> assistants,
  ) {
    final modelIds = models.map((model) => model.id).toSet();
    final assistantIds = <String>{};
    for (final assistant in assistants) {
      if (assistant.id.isEmpty || !assistantIds.add(assistant.id)) {
        throw ArgumentError('Assistant IDs must be non-empty and unique');
      }
      if (assistant.connectionId != connectionId ||
          !modelIds.contains(assistant.modelId)) {
        throw ArgumentError(
          'Assistants must reference a model in connection $connectionId',
        );
      }
    }
  }

  static AiProviderConnection _connectionFromJson(String source) =>
      AiProviderConnectionDto.fromJson(
        Map<String, Object?>.from(jsonDecode(source) as Map),
      ).toEntity();

  static AiModelDefinition _modelFromJson(String source) =>
      AiModelDefinitionDto.fromJson(
        Map<String, Object?>.from(jsonDecode(source) as Map),
      ).toEntity();

  static AiAssistantProfile _assistantFromJson(String source) =>
      AiAssistantProfileDto.fromJson(
        Map<String, Object?>.from(jsonDecode(source) as Map),
      ).toEntity();
}
