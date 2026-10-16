import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryPointerAutoChaseQueryDatasource {
  final _native = MemoryToolNative();

  Future<PointerAutoChaseState> getPointerAutoChaseState() async {
    return await _native.getPointerAutoChaseState();
  }

  Future<List<PointerScanResult>> getPointerAutoChaseLayerResults({
    required int layerIndex,
    required int offset,
    required int limit,
  }) async {
    return await _native.getPointerAutoChaseLayerResults(
      layerIndex,
      offset,
      limit,
    );
  }
}
