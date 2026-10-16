import 'package:JsxposedX/generated/memory_tool.g.dart'
    show PointerScanRequest, PointerScanResult;

class PointerChainLayerState {
  const PointerChainLayerState({
    required this.request,
    this.results = const <PointerScanResult>[],
    this.totalResultCount = 0,
    this.autoChaseLayerIndex,
    this.sourceResult,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorText,
    this.selectedPointerAddress,
    this.isAutoSelectedLayer = false,
    this.isTerminalLayer = false,
    this.autoStopReasonKey,
    this.staticOnlyMode = false,
  });

  final PointerScanRequest request;
  final List<PointerScanResult> results;
  final int totalResultCount;
  final int? autoChaseLayerIndex;
  final PointerScanResult? sourceResult;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorText;
  final int? selectedPointerAddress;
  final bool isAutoSelectedLayer;
  final bool isTerminalLayer;
  final String? autoStopReasonKey;
  final bool staticOnlyMode;

  PointerChainLayerState copyWith({
    PointerScanRequest? request,
    List<PointerScanResult>? results,
    int? totalResultCount,
    int? autoChaseLayerIndex,
    PointerScanResult? sourceResult,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorText,
    int? selectedPointerAddress,
    bool? isAutoSelectedLayer,
    bool? isTerminalLayer,
    String? autoStopReasonKey,
    bool? staticOnlyMode,
    bool clearErrorText = false,
    bool clearSelectedPointerAddress = false,
    bool clearAutoStopReasonKey = false,
    bool clearAutoChaseLayerIndex = false,
  }) {
    return PointerChainLayerState(
      request: request ?? this.request,
      results: results ?? this.results,
      totalResultCount: totalResultCount ?? this.totalResultCount,
      autoChaseLayerIndex: clearAutoChaseLayerIndex
          ? null
          : autoChaseLayerIndex ?? this.autoChaseLayerIndex,
      sourceResult: sourceResult ?? this.sourceResult,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorText: clearErrorText ? null : errorText ?? this.errorText,
      selectedPointerAddress: clearSelectedPointerAddress
          ? null
          : selectedPointerAddress ?? this.selectedPointerAddress,
      isAutoSelectedLayer: isAutoSelectedLayer ?? this.isAutoSelectedLayer,
      isTerminalLayer: isTerminalLayer ?? this.isTerminalLayer,
      autoStopReasonKey: clearAutoStopReasonKey
          ? null
          : autoStopReasonKey ?? this.autoStopReasonKey,
      staticOnlyMode: staticOnlyMode ?? this.staticOnlyMode,
    );
  }
}

class MemoryToolPointerState {
  const MemoryToolPointerState({
    this.layers = const <PointerChainLayerState>[],
    this.currentLayerIndex = -1,
    this.isAutoChasing = false,
    this.autoChaseMaxDepth = 0,
    this.autoChaseCurrentDepth = 0,
    this.autoChaseMessage,
  });

  final List<PointerChainLayerState> layers;
  final int currentLayerIndex;
  final bool isAutoChasing;
  final int autoChaseMaxDepth;
  final int autoChaseCurrentDepth;
  final String? autoChaseMessage;

  PointerChainLayerState? get currentLayer {
    if (currentLayerIndex < 0 || currentLayerIndex >= layers.length) {
      return null;
    }
    return layers[currentLayerIndex];
  }

  bool get hasLayers => currentLayer != null;

  MemoryToolPointerState copyWith({
    List<PointerChainLayerState>? layers,
    int? currentLayerIndex,
    bool? isAutoChasing,
    int? autoChaseMaxDepth,
    int? autoChaseCurrentDepth,
    String? autoChaseMessage,
    bool clearAutoChaseMessage = false,
  }) {
    return MemoryToolPointerState(
      layers: layers ?? this.layers,
      currentLayerIndex: currentLayerIndex ?? this.currentLayerIndex,
      isAutoChasing: isAutoChasing ?? this.isAutoChasing,
      autoChaseMaxDepth: autoChaseMaxDepth ?? this.autoChaseMaxDepth,
      autoChaseCurrentDepth:
          autoChaseCurrentDepth ?? this.autoChaseCurrentDepth,
      autoChaseMessage: clearAutoChaseMessage
          ? null
          : autoChaseMessage ?? this.autoChaseMessage,
    );
  }
}
