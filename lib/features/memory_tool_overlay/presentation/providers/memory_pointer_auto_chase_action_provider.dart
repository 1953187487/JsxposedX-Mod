import 'package:JsxposedX/features/memory_tool_overlay/data/datasources/memory_pointer_auto_chase_action_datasource.dart';
import 'package:JsxposedX/features/memory_tool_overlay/data/repositories/memory_pointer_auto_chase_action_repository_impl.dart';
import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_pointer_auto_chase_action_repository.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_pointer_auto_chase_query_provider.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memory_pointer_auto_chase_action_provider.g.dart';

@riverpod
MemoryPointerAutoChaseActionDatasource memoryPointerAutoChaseActionDatasource(
  Ref ref,
) {
  return MemoryPointerAutoChaseActionDatasource();
}

@riverpod
MemoryPointerAutoChaseActionRepository
memoryPointerAutoChaseActionRepository(Ref ref) {
  final dataSource = ref.watch(memoryPointerAutoChaseActionDatasourceProvider);
  return MemoryPointerAutoChaseActionRepositoryImpl(dataSource: dataSource);
}

@Riverpod(keepAlive: true)
class MemoryPointerAutoChaseAction extends _$MemoryPointerAutoChaseAction {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> startPointerAutoChase({
    required PointerAutoChaseRequest request,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(memoryPointerAutoChaseActionRepositoryProvider)
          .startPointerAutoChase(request: request);
      _invalidateAutoChaseQueries();
    });
  }

  Future<void> cancelPointerAutoChase() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(memoryPointerAutoChaseActionRepositoryProvider)
          .cancelPointerAutoChase();
      _invalidateAutoChaseQueries();
    });
  }

  Future<void> resetPointerAutoChase() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(memoryPointerAutoChaseActionRepositoryProvider)
          .resetPointerAutoChase();
      _invalidateAutoChaseQueries();
    });
  }

  void _invalidateAutoChaseQueries() {
    ref.invalidate(getPointerAutoChaseStateProvider);
    ref.invalidate(getPointerAutoChaseLayerResultsProvider);
  }
}
