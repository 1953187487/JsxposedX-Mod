import 'package:JsxposedX/features/memory_tool_overlay/data/datasources/memory_pointer_auto_chase_action_datasource.dart';
import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_pointer_auto_chase_action_repository.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryPointerAutoChaseActionRepositoryImpl
    implements MemoryPointerAutoChaseActionRepository {
  MemoryPointerAutoChaseActionRepositoryImpl({required this.dataSource});

  final MemoryPointerAutoChaseActionDatasource dataSource;

  @override
  Future<void> startPointerAutoChase({
    required PointerAutoChaseRequest request,
  }) async {
    await dataSource.startPointerAutoChase(request: request);
  }

  @override
  Future<void> cancelPointerAutoChase() async {
    await dataSource.cancelPointerAutoChase();
  }

  @override
  Future<void> resetPointerAutoChase() async {
    await dataSource.resetPointerAutoChase();
  }
}
