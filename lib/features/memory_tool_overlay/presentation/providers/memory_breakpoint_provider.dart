import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_action_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_query_provider.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memory_breakpoint_provider.g.dart';

@riverpod
Future<List<MemoryBreakpoint>> getMemoryBreakpoints(
  Ref ref, {
  required int pid,
}) async {
  return await ref
      .watch(memoryQueryRepositoryProvider)
      .listMemoryBreakpoints(pid: pid);
}

@riverpod
Future<MemoryBreakpointState> getMemoryBreakpointState(
  Ref ref, {
  required int pid,
}) async {
  return await ref
      .watch(memoryQueryRepositoryProvider)
      .getMemoryBreakpointState(pid: pid);
}

@riverpod
Future<List<MemoryBreakpointHit>> getMemoryBreakpointHits(
  Ref ref, {
  required int pid,
  int offset = 0,
  int limit = 100,
}) async {
  return await ref
      .watch(memoryQueryRepositoryProvider)
      .getMemoryBreakpointHits(pid: pid, offset: offset, limit: limit);
}

@Riverpod(keepAlive: true)
class MemoryBreakpointSelectedId extends _$MemoryBreakpointSelectedId {
  @override
  String? build() {
    return null;
  }

  void set(String? breakpointId) {
    state = breakpointId;
  }

  void clear() {
    state = null;
  }
}

@Riverpod(keepAlive: true)
class MemoryBreakpointAction extends _$MemoryBreakpointAction {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<MemoryBreakpoint> addMemoryBreakpoint({
    required AddMemoryBreakpointRequest request,
  }) async {
    late MemoryBreakpoint createdBreakpoint;
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      createdBreakpoint = await ref
          .read(memoryActionRepositoryProvider)
          .addMemoryBreakpoint(request: request);
      ref
          .read(memoryBreakpointSelectedIdProvider.notifier)
          .set(createdBreakpoint.id);
      _invalidateQueries(request.pid);
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
    return createdBreakpoint;
  }

  Future<void> removeMemoryBreakpoint({
    required int pid,
    required String breakpointId,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      await ref
          .read(memoryActionRepositoryProvider)
          .removeMemoryBreakpoint(breakpointId: breakpointId);
      final selectedId = ref.read(memoryBreakpointSelectedIdProvider);
      if (selectedId == breakpointId) {
        ref.read(memoryBreakpointSelectedIdProvider.notifier).clear();
      }
      _invalidateQueries(pid);
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }

  Future<void> setMemoryBreakpointEnabled({
    required int pid,
    required String breakpointId,
    required bool enabled,
  }) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      await ref.read(memoryActionRepositoryProvider).setMemoryBreakpointEnabled(
        breakpointId: breakpointId,
        enabled: enabled,
      );
      _invalidateQueries(pid);
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }

  Future<void> clearMemoryBreakpointHits({required int pid}) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      await ref
          .read(memoryActionRepositoryProvider)
          .clearMemoryBreakpointHits(pid: pid);
      _invalidateQueries(pid);
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }

  Future<void> resumeAfterBreakpoint({required int pid}) async {
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(() async {
      await ref
          .read(memoryActionRepositoryProvider)
          .resumeAfterBreakpoint(pid: pid);
      _invalidateQueries(pid);
    });
    state = nextState;
    if (nextState.hasError) {
      Error.throwWithStackTrace(
        nextState.error!,
        nextState.asError!.stackTrace,
      );
    }
  }

  void _invalidateQueries(int pid) {
    ref.invalidate(getMemoryBreakpointsProvider(pid: pid));
    ref.invalidate(getMemoryBreakpointStateProvider(pid: pid));
    ref.invalidate(getMemoryBreakpointHitsProvider(pid: pid));
    ref.invalidate(processPausedProvider(pid: pid));
  }
}
