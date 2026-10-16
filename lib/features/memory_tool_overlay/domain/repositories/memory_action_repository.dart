import 'package:JsxposedX/generated/memory_tool.g.dart';

abstract class MemoryActionRepository {
  Future<void> firstScan({required FirstScanRequest request});

  Future<void> nextScan({required NextScanRequest request});

  Future<void> cancelSearch();

  Future<void> resetSearchSession();

  Future<void> writeMemoryValue({required MemoryWriteRequest request});

  Future<MemoryInstructionPatchResult> patchMemoryInstruction({
    required MemoryInstructionPatchRequest request,
  });

  Future<void> setMemoryFreeze({required MemoryFreezeRequest request});

  Future<List<FrozenMemoryValue>> getFrozenMemoryValues();

  Future<bool> isProcessPaused({required int pid});

  Future<void> setProcessPaused({required int pid, required bool paused});

  Future<MemoryBreakpoint> addMemoryBreakpoint({
    required AddMemoryBreakpointRequest request,
  });

  Future<void> removeMemoryBreakpoint({required String breakpointId});

  Future<void> setMemoryBreakpointEnabled({
    required String breakpointId,
    required bool enabled,
  });

  Future<void> clearMemoryBreakpointHits({required int pid});

  Future<void> resumeAfterBreakpoint({required int pid});
}
