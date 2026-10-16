import 'package:JsxposedX/generated/memory_tool.g.dart';

abstract class MemoryPointerAutoChaseQueryRepository {
  Future<PointerAutoChaseState> getPointerAutoChaseState();

  Future<List<PointerScanResult>> getPointerAutoChaseLayerResults({
    required int layerIndex,
    required int offset,
    required int limit,
  });
}
