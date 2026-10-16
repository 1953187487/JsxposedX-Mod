import 'package:JsxposedX/generated/memory_tool.g.dart';

abstract class MemoryPointerAutoChaseActionRepository {
  Future<void> startPointerAutoChase({required PointerAutoChaseRequest request});

  Future<void> cancelPointerAutoChase();

  Future<void> resetPointerAutoChase();
}
