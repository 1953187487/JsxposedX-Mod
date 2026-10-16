import 'package:JsxposedX/features/memory_tool_overlay/data/datasources/memory_pointer_auto_chase_query_datasource.dart';
import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_pointer_auto_chase_query_repository.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryPointerAutoChaseQueryRepositoryImpl
    implements MemoryPointerAutoChaseQueryRepository {
  MemoryPointerAutoChaseQueryRepositoryImpl({required this.dataSource});

  final MemoryPointerAutoChaseQueryDatasource dataSource;

  @override
  Future<PointerAutoChaseState> getPointerAutoChaseState() async {
    return await dataSource.getPointerAutoChaseState();
  }

  @override
  Future<List<PointerScanResult>> getPointerAutoChaseLayerResults({
    required int layerIndex,
    required int offset,
    required int limit,
  }) async {
    return await dataSource.getPointerAutoChaseLayerResults(
      layerIndex: layerIndex,
      offset: offset,
      limit: limit,
    );
  }
}
