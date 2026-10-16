import 'package:JsxposedX/generated/memory_tool.g.dart';

abstract class MemoryQueryRepository {
  Future<int> getPid({required String packageName});

  Future<List<ProcessInfo>> getProcessInfo({
    required int offset,
    required int limit,
  });

  Future<List<MemoryRegion>> getMemoryRegions({
    required int pid,
    required int offset,
    required int limit,
    required bool readableOnly,
    required bool includeAnonymous,
    required bool includeFileBacked,
  });

  Future<SearchSessionState> getSearchSessionState();

  Future<SearchTaskState> getSearchTaskState();

  Future<List<SearchResult>> getSearchResults({
    required int offset,
    required int limit,
  });

  Future<List<MemoryValuePreview>> readMemoryValues({
    required List<MemoryReadRequest> requests,
  });

  Future<List<MemoryInstructionPreview>> disassembleMemory({
    required int pid,
    required List<int> addresses,
  });

  Future<List<MemoryBreakpoint>> listMemoryBreakpoints({required int pid});

  Future<MemoryBreakpointState> getMemoryBreakpointState({required int pid});

  Future<List<MemoryBreakpointHit>> getMemoryBreakpointHits({
    required int pid,
    required int offset,
    required int limit,
  });
}
