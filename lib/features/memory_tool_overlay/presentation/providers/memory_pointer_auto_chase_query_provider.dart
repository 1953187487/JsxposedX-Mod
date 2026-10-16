import 'package:JsxposedX/features/memory_tool_overlay/data/datasources/memory_pointer_auto_chase_query_datasource.dart';
import 'package:JsxposedX/features/memory_tool_overlay/data/repositories/memory_pointer_auto_chase_query_repository_impl.dart';
import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_pointer_auto_chase_query_repository.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memory_pointer_auto_chase_query_provider.g.dart';

@riverpod
MemoryPointerAutoChaseQueryRepository memoryPointerAutoChaseQueryRepository(
  Ref ref,
) {
  final dataSource = MemoryPointerAutoChaseQueryDatasource();
  return MemoryPointerAutoChaseQueryRepositoryImpl(dataSource: dataSource);
}

@riverpod
Future<PointerAutoChaseState> getPointerAutoChaseState(Ref ref) async {
  return await ref
      .watch(memoryPointerAutoChaseQueryRepositoryProvider)
      .getPointerAutoChaseState();
}

@riverpod
Future<List<PointerScanResult>> getPointerAutoChaseLayerResults(
  Ref ref, {
  required int layerIndex,
  required int offset,
  required int limit,
}) async {
  return await ref
      .watch(memoryPointerAutoChaseQueryRepositoryProvider)
      .getPointerAutoChaseLayerResults(
        layerIndex: layerIndex,
        offset: offset,
        limit: limit,
      );
}
