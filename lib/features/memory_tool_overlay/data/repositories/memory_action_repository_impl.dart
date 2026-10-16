import 'package:JsxposedX/features/memory_tool_overlay/data/datasources/memory_action_datasource.dart';
import 'package:JsxposedX/features/memory_tool_overlay/domain/repositories/memory_action_repository.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryActionRepositoryImpl implements MemoryActionRepository {
  MemoryActionRepositoryImpl({required MemoryActionDatasource dataSource})
    : _dataSource = dataSource;

  final MemoryActionDatasource _dataSource;

  @override
  Future<void> firstScan({required FirstScanRequest request}) async {
    await _dataSource.firstScan(request: request);
  }

  @override
  Future<void> nextScan({required NextScanRequest request}) async {
    await _dataSource.nextScan(request: request);
  }

  @override
  Future<void> cancelSearch() async {
    await _dataSource.cancelSearch();
  }

  @override
  Future<void> resetSearchSession() async {
    await _dataSource.resetSearchSession();
  }

  @override
  Future<void> writeMemoryValue({required MemoryWriteRequest request}) async {
    await _dataSource.writeMemoryValue(request: request);
  }

  @override
  Future<MemoryInstructionPatchResult> patchMemoryInstruction({
    required MemoryInstructionPatchRequest request,
  }) async {
    return await _dataSource.patchMemoryInstruction(request: request);
  }

  @override
  Future<void> setMemoryFreeze({required MemoryFreezeRequest request}) async {
    await _dataSource.setMemoryFreeze(request: request);
  }

  @override
  Future<List<FrozenMemoryValue>> getFrozenMemoryValues() async {
    return await _dataSource.getFrozenMemoryValues();
  }

  @override
  Future<bool> isProcessPaused({required int pid}) async {
    return await _dataSource.isProcessPaused(pid: pid);
  }

  @override
  Future<void> setProcessPaused({
    required int pid,
    required bool paused,
  }) async {
    await _dataSource.setProcessPaused(pid: pid, paused: paused);
  }

  @override
  Future<MemoryBreakpoint> addMemoryBreakpoint({
    required AddMemoryBreakpointRequest request,
  }) async {
    return await _dataSource.addMemoryBreakpoint(request: request);
  }

  @override
  Future<void> removeMemoryBreakpoint({required String breakpointId}) async {
    await _dataSource.removeMemoryBreakpoint(breakpointId: breakpointId);
  }

  @override
  Future<void> setMemoryBreakpointEnabled({
    required String breakpointId,
    required bool enabled,
  }) async {
    await _dataSource.setMemoryBreakpointEnabled(
      breakpointId: breakpointId,
      enabled: enabled,
    );
  }

  @override
  Future<void> clearMemoryBreakpointHits({required int pid}) async {
    await _dataSource.clearMemoryBreakpointHits(pid: pid);
  }

  @override
  Future<void> resumeAfterBreakpoint({required int pid}) async {
    await _dataSource.resumeAfterBreakpoint(pid: pid);
  }
}
