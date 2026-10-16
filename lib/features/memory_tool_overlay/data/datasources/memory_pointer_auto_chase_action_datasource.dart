import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryPointerAutoChaseActionDatasource {
  final _native = MemoryToolNative();

  Future<void> startPointerAutoChase({
    required PointerAutoChaseRequest request,
  }) async {
    await _native.startPointerAutoChase(request);
  }

  Future<void> cancelPointerAutoChase() async {
    await _native.cancelPointerAutoChase();
  }

  Future<void> resetPointerAutoChase() async {
    await _native.resetPointerAutoChase();
  }
}
