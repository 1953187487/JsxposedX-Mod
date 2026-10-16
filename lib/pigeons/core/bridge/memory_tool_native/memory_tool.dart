import 'package:pigeon/pigeon.dart';

enum SearchValueType { i8, i16, i32, i64, f32, f64, bytes }

enum SearchMatchMode { exact }

enum SearchTaskStatus { idle, running, completed, cancelled, failed }

enum MemoryBreakpointAccessType { read, write, readWrite }

class ProcessInfo {
  final int pid;
  final String name;
  final String packageName;
  final Uint8List? icon;

  const ProcessInfo({
    required this.pid,
    required this.packageName,
    required this.name,
    this.icon,
  });
}

class SearchValue {
  final SearchValueType type;
  final String? textValue;
  final Uint8List? bytesValue;
  final bool littleEndian;

  const SearchValue({
    required this.type,
    this.textValue,
    this.bytesValue,
    required this.littleEndian,
  });
}

class MemoryRegion {
  final int startAddress;
  final int endAddress;
  final String perms;
  final int size;
  final String? path;
  final bool isAnonymous;

  const MemoryRegion({
    required this.startAddress,
    required this.endAddress,
    required this.perms,
    required this.size,
    this.path,
    required this.isAnonymous,
  });
}

class MemoryRegionQuery {
  final int pid;
  final int offset;
  final int limit;
  final bool readableOnly;
  final bool includeAnonymous;
  final bool includeFileBacked;

  const MemoryRegionQuery({
    required this.pid,
    required this.offset,
    required this.limit,
    required this.readableOnly,
    required this.includeAnonymous,
    required this.includeFileBacked,
  });
}

class FirstScanRequest {
  final int pid;
  final SearchValue value;
  final SearchMatchMode matchMode;
  final List<String> rangeSectionKeys;
  final bool scanAllReadableRegions;

  const FirstScanRequest({
    required this.pid,
    required this.value,
    required this.matchMode,
    required this.rangeSectionKeys,
    required this.scanAllReadableRegions,
  });
}

class NextScanRequest {
  final SearchValue value;
  final SearchMatchMode matchMode;

  const NextScanRequest({required this.value, required this.matchMode});
}

class SearchResult {
  final int address;
  final int regionStart;
  final String regionTypeKey;
  final SearchValueType type;
  final Uint8List rawBytes;
  final String displayValue;

  const SearchResult({
    required this.address,
    required this.regionStart,
    required this.regionTypeKey,
    required this.type,
    required this.rawBytes,
    required this.displayValue,
  });
}

class PointerScanRequest {
  final int pid;
  final int targetAddress;
  final int pointerWidth;
  final int maxOffset;
  final int alignment;
  final List<String> rangeSectionKeys;
  final bool scanAllReadableRegions;

  const PointerScanRequest({
    required this.pid,
    required this.targetAddress,
    required this.pointerWidth,
    required this.maxOffset,
    required this.alignment,
    required this.rangeSectionKeys,
    required this.scanAllReadableRegions,
  });
}

class PointerScanResult {
  final int pointerAddress;
  final int baseAddress;
  final int targetAddress;
  final int offset;
  final int regionStart;
  final String regionTypeKey;

  const PointerScanResult({
    required this.pointerAddress,
    required this.baseAddress,
    required this.targetAddress,
    required this.offset,
    required this.regionStart,
    required this.regionTypeKey,
  });
}

class PointerScanChaseHint {
  final PointerScanResult? result;
  final bool isTerminalStaticCandidate;
  final String stopReasonKey;

  const PointerScanChaseHint({
    this.result,
    required this.isTerminalStaticCandidate,
    required this.stopReasonKey,
  });
}

class PointerAutoChaseRequest {
  final int pid;
  final int targetAddress;
  final int pointerWidth;
  final int maxOffset;
  final int alignment;
  final int maxDepth;
  final List<String> rangeSectionKeys;
  final bool scanAllReadableRegions;

  const PointerAutoChaseRequest({
    required this.pid,
    required this.targetAddress,
    required this.pointerWidth,
    required this.maxOffset,
    required this.alignment,
    required this.maxDepth,
    required this.rangeSectionKeys,
    required this.scanAllReadableRegions,
  });
}

class PointerAutoChaseLayerState {
  final int layerIndex;
  final int targetAddress;
  final int? selectedPointerAddress;
  final PointerScanResult? selectedResult;
  final int resultCount;
  final bool hasMore;
  final bool isTerminalLayer;
  final String stopReasonKey;
  final List<PointerScanResult> initialResults;

  const PointerAutoChaseLayerState({
    required this.layerIndex,
    required this.targetAddress,
    this.selectedPointerAddress,
    this.selectedResult,
    required this.resultCount,
    required this.hasMore,
    required this.isTerminalLayer,
    required this.stopReasonKey,
    required this.initialResults,
  });
}

class PointerAutoChaseState {
  final bool isRunning;
  final int pid;
  final int maxDepth;
  final int currentDepth;
  final List<PointerAutoChaseLayerState> layers;
  final String message;

  const PointerAutoChaseState({
    required this.isRunning,
    required this.pid,
    required this.maxDepth,
    required this.currentDepth,
    required this.layers,
    required this.message,
  });
}

class AddMemoryBreakpointRequest {
  final int pid;
  final int address;
  final SearchValueType type;
  final int length;
  final MemoryBreakpointAccessType accessType;
  final bool enabled;
  final bool pauseProcessOnHit;

  const AddMemoryBreakpointRequest({
    required this.pid,
    required this.address,
    required this.type,
    required this.length,
    required this.accessType,
    required this.enabled,
    required this.pauseProcessOnHit,
  });
}

class MemoryBreakpoint {
  final String id;
  final int pid;
  final int address;
  final SearchValueType type;
  final int length;
  final MemoryBreakpointAccessType accessType;
  final bool enabled;
  final bool pauseProcessOnHit;
  final int hitCount;
  final int createdAtMillis;
  final int? lastHitAtMillis;
  final String lastError;

  const MemoryBreakpoint({
    required this.id,
    required this.pid,
    required this.address,
    required this.type,
    required this.length,
    required this.accessType,
    required this.enabled,
    required this.pauseProcessOnHit,
    required this.hitCount,
    required this.createdAtMillis,
    this.lastHitAtMillis,
    required this.lastError,
  });
}

class MemoryBreakpointState {
  final bool isSupported;
  final bool isProcessPaused;
  final int activeBreakpointCount;
  final int pendingHitCount;
  final String architecture;
  final String lastError;

  const MemoryBreakpointState({
    required this.isSupported,
    required this.isProcessPaused,
    required this.activeBreakpointCount,
    required this.pendingHitCount,
    required this.architecture,
    required this.lastError,
  });
}

class MemoryBreakpointHit {
  final String breakpointId;
  final int pid;
  final int address;
  final MemoryBreakpointAccessType accessType;
  final int threadId;
  final int timestampMillis;
  final Uint8List oldValue;
  final Uint8List newValue;
  final int pc;
  final String moduleName;
  final int moduleBase;
  final int moduleOffset;
  final String instructionText;

  const MemoryBreakpointHit({
    required this.breakpointId,
    required this.pid,
    required this.address,
    required this.accessType,
    required this.threadId,
    required this.timestampMillis,
    required this.oldValue,
    required this.newValue,
    required this.pc,
    required this.moduleName,
    required this.moduleBase,
    required this.moduleOffset,
    required this.instructionText,
  });
}

class MemoryReadRequest {
  final int pid;
  final int address;
  final SearchValueType type;
  final int length;

  const MemoryReadRequest({
    required this.pid,
    required this.address,
    required this.type,
    required this.length,
  });
}

class MemoryValuePreview {
  final int address;
  final SearchValueType type;
  final Uint8List rawBytes;
  final String displayValue;

  const MemoryValuePreview({
    required this.address,
    required this.type,
    required this.rawBytes,
    required this.displayValue,
  });
}

class MemoryWriteRequest {
  final int address;
  final SearchValue value;

  const MemoryWriteRequest({required this.address, required this.value});
}

class MemoryFreezeRequest {
  final int address;
  final SearchValue value;
  final bool enabled;

  const MemoryFreezeRequest({
    required this.address,
    required this.value,
    required this.enabled,
  });
}

class FrozenMemoryValue {
  final int pid;
  final int address;
  final SearchValueType type;
  final Uint8List rawBytes;
  final String displayValue;

  const FrozenMemoryValue({
    required this.pid,
    required this.address,
    required this.type,
    required this.rawBytes,
    required this.displayValue,
  });
}

class SearchSessionState {
  final bool hasActiveSession;
  final int pid;
  final SearchValueType type;
  final int regionCount;
  final int resultCount;
  final bool exactMode;
  final bool littleEndian;

  const SearchSessionState({
    required this.hasActiveSession,
    required this.pid,
    required this.type,
    required this.regionCount,
    required this.resultCount,
    required this.exactMode,
    required this.littleEndian,
  });
}

class SearchTaskState {
  final SearchTaskStatus status;
  final bool isFirstScan;
  final int pid;
  final int processedRegions;
  final int totalRegions;
  final int processedEntries;
  final int totalEntries;
  final int processedBytes;
  final int totalBytes;
  final int resultCount;
  final int elapsedMilliseconds;
  final bool canCancel;
  final String message;

  const SearchTaskState({
    required this.status,
    required this.isFirstScan,
    required this.pid,
    required this.processedRegions,
    required this.totalRegions,
    required this.processedEntries,
    required this.totalEntries,
    required this.processedBytes,
    required this.totalBytes,
    required this.resultCount,
    required this.elapsedMilliseconds,
    required this.canCancel,
    required this.message,
  });
}

class PointerScanSessionState {
  final bool hasActiveSession;
  final int pid;
  final int targetAddress;
  final int pointerWidth;
  final int maxOffset;
  final int alignment;
  final int regionCount;
  final int resultCount;

  const PointerScanSessionState({
    required this.hasActiveSession,
    required this.pid,
    required this.targetAddress,
    required this.pointerWidth,
    required this.maxOffset,
    required this.alignment,
    required this.regionCount,
    required this.resultCount,
  });
}

class PointerScanTaskState {
  final SearchTaskStatus status;
  final int pid;
  final int processedRegions;
  final int totalRegions;
  final int processedEntries;
  final int totalEntries;
  final int processedBytes;
  final int totalBytes;
  final int resultCount;
  final int elapsedMilliseconds;
  final bool canCancel;
  final String message;

  const PointerScanTaskState({
    required this.status,
    required this.pid,
    required this.processedRegions,
    required this.totalRegions,
    required this.processedEntries,
    required this.totalEntries,
    required this.processedBytes,
    required this.totalBytes,
    required this.resultCount,
    required this.elapsedMilliseconds,
    required this.canCancel,
    required this.message,
  });
}

class MemoryInstructionPatchRequest {
  final int pid;
  final int address;
  final String instruction;

  const MemoryInstructionPatchRequest({
    required this.pid,
    required this.address,
    required this.instruction,
  });
}

class MemoryInstructionPatchResult {
  final int address;
  final String architecture;
  final int instructionSize;
  final Uint8List beforeBytes;
  final Uint8List afterBytes;
  final String instructionText;

  const MemoryInstructionPatchResult({
    required this.address,
    required this.architecture,
    required this.instructionSize,
    required this.beforeBytes,
    required this.afterBytes,
    required this.instructionText,
  });
}

class MemoryInstructionPreview {
  final int address;
  final String architecture;
  final int instructionSize;
  final Uint8List rawBytes;
  final String instructionText;

  const MemoryInstructionPreview({
    required this.address,
    required this.architecture,
    required this.instructionSize,
    required this.rawBytes,
    required this.instructionText,
  });
}

@HostApi()
abstract class MemoryToolNative {
  @async
  int getPid({required String packageName});

  @async
  List<ProcessInfo> getProcessInfo(int offset, int limit);

  @async
  List<MemoryRegion> getMemoryRegions(MemoryRegionQuery query);

  @async
  SearchSessionState getSearchSessionState();

  @async
  SearchTaskState getSearchTaskState();

  @async
  List<SearchResult> getSearchResults(int offset, int limit);

  @async
  PointerScanSessionState getPointerScanSessionState();

  @async
  PointerScanTaskState getPointerScanTaskState();

  @async
  List<PointerScanResult> getPointerScanResults(int offset, int limit);

  @async
  PointerScanChaseHint getPointerScanChaseHint();

  @async
  PointerAutoChaseState getPointerAutoChaseState();

  @async
  List<PointerScanResult> getPointerAutoChaseLayerResults(
    int layerIndex,
    int offset,
    int limit,
  );

  @async
  MemoryBreakpoint addMemoryBreakpoint(AddMemoryBreakpointRequest request);

  @async
  void removeMemoryBreakpoint(String breakpointId);

  @async
  void setMemoryBreakpointEnabled(String breakpointId, bool enabled);

  @async
  List<MemoryBreakpoint> listMemoryBreakpoints(int pid);

  @async
  MemoryBreakpointState getMemoryBreakpointState(int pid);

  @async
  List<MemoryBreakpointHit> getMemoryBreakpointHits(
    int pid,
    int offset,
    int limit,
  );

  @async
  void clearMemoryBreakpointHits(int pid);

  @async
  void resumeAfterBreakpoint(int pid);

  @async
  List<MemoryValuePreview> readMemoryValues(List<MemoryReadRequest> requests);

  @async
  void writeMemoryValue(MemoryWriteRequest request);

  @async
  MemoryInstructionPatchResult patchMemoryInstruction(
    MemoryInstructionPatchRequest request,
  );

  @async
  List<MemoryInstructionPreview> disassembleMemory(int pid, List<int> addresses);

  @async
  void setMemoryFreeze(MemoryFreezeRequest request);

  @async
  List<FrozenMemoryValue> getFrozenMemoryValues();

  @async
  bool isProcessPaused(int pid);

  @async
  void setProcessPaused(int pid, bool paused);

  @async
  void firstScan(FirstScanRequest request);

  @async
  void nextScan(NextScanRequest request);

  @async
  void cancelSearch();

  @async
  void resetSearchSession();

  @async
  void startPointerScan(PointerScanRequest request);

  @async
  void startPointerAutoChase(PointerAutoChaseRequest request);

  @async
  void cancelPointerScan();

  @async
  void cancelPointerAutoChase();

  @async
  void resetPointerScanSession();

  @async
  void resetPointerAutoChase();
}
