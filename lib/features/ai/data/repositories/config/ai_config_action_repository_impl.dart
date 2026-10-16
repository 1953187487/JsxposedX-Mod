import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/features/ai/data/datasources/config/ai_config_action_datasource.dart';
import 'package:JsxposedX/features/ai/data/models/ai_config_dto.dart';
import 'package:JsxposedX/features/ai/domain/repositories/config/ai_config_action_repository.dart';

/// AI 配置操作仓储实现
class AiConfigActionRepositoryImpl implements AiConfigActionRepository {
  final AiConfigActionDatasource dataSource;

  AiConfigActionRepositoryImpl({required this.dataSource});

  @override
  Future<void> saveConfig(AiConfig config) async {
    final dto = AiConfigDto(
      id: config.id,
      name: config.name,
      apiKey: config.apiKey,
      apiUrl: config.apiUrl,
      moduleName: config.moduleName,
      maxToken: config.maxToken,
      temperature: config.temperature,
      memoryRounds: config.memoryRounds,
      apiType: config.apiType.name,
    );
    await dataSource.saveConfig(dto);
  }

  @override
  Future<List<AiConfig>> getConfigList() async {
    final dtos = await dataSource.getConfigList();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> addConfig(AiConfig config) async {
    final dto = AiConfigDto(
      id: config.id,
      name: config.name,
      apiKey: config.apiKey,
      apiUrl: config.apiUrl,
      moduleName: config.moduleName,
      maxToken: config.maxToken,
      temperature: config.temperature,
      memoryRounds: config.memoryRounds,
      apiType: config.apiType.name,
    );
    await dataSource.addConfig(dto);
  }

  @override
  Future<void> updateConfig(AiConfig config) async {
    final dto = AiConfigDto(
      id: config.id,
      name: config.name,
      apiKey: config.apiKey,
      apiUrl: config.apiUrl,
      moduleName: config.moduleName,
      maxToken: config.maxToken,
      temperature: config.temperature,
      memoryRounds: config.memoryRounds,
      apiType: config.apiType.name,
    );
    await dataSource.updateConfig(dto);
  }

  @override
  Future<void> deleteConfig(String id) async {
    await dataSource.deleteConfig(id);
  }

  @override
  Future<void> switchConfig(String id) async {
    await dataSource.switchConfig(id);
  }
}
