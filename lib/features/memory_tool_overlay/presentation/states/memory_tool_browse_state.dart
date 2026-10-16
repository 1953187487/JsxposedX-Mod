import 'package:JsxposedX/features/memory_tool_overlay/presentation/models/memory_tool_display_item.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/states/memory_tool_result_selection_state.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart';

class MemoryToolBrowseState {
  const MemoryToolBrowseState({
    this.anchorItem,
    this.regions = const <MemoryRegion>[],
    this.results = const <MemoryToolDisplayItem>[],
    this.selectionState = const MemoryToolResultSelectionState(),
    this.hiddenAddresses = const <int>{},
    this.focusRequestId = 0,
    this.topNextStep = 1,
    this.bottomNextStep = 1,
    this.isInitializing = false,
    this.isLoadingAbove = false,
    this.isLoadingBelow = false,
    this.reachedTopBoundary = false,
    this.reachedBottomBoundary = false,
    this.errorText,
  });

  final MemoryToolDisplayItem? anchorItem;
  final List<MemoryRegion> regions;
  final List<MemoryToolDisplayItem> results;
  final MemoryToolResultSelectionState selectionState;
  final Set<int> hiddenAddresses;
  final int focusRequestId;
  final int topNextStep;
  final int bottomNextStep;
  final bool isInitializing;
  final bool isLoadingAbove;
  final bool isLoadingBelow;
  final bool reachedTopBoundary;
  final bool reachedBottomBoundary;
  final String? errorText;

  bool get hasAnchor => anchorItem != null;

  int? get anchorAddress => anchorItem?.address;

  int get strideBytes {
    final rawBytes = anchorItem?.rawBytes;
    if (rawBytes == null || rawBytes.isEmpty) {
      return 1;
    }
    return rawBytes.length;
  }

  SearchValueType get browseType => anchorItem?.type ?? SearchValueType.i32;

  bool get isInstructionMode => anchorItem?.isInstruction ?? false;

  MemoryToolBrowseState copyWith({
    MemoryToolDisplayItem? anchorItem,
    bool clearAnchorItem = false,
    List<MemoryRegion>? regions,
    List<MemoryToolDisplayItem>? results,
    MemoryToolResultSelectionState? selectionState,
    Set<int>? hiddenAddresses,
    int? focusRequestId,
    int? topNextStep,
    int? bottomNextStep,
    bool? isInitializing,
    bool? isLoadingAbove,
    bool? isLoadingBelow,
    bool? reachedTopBoundary,
    bool? reachedBottomBoundary,
    String? errorText,
    bool clearErrorText = false,
  }) {
    return MemoryToolBrowseState(
      anchorItem: clearAnchorItem ? null : anchorItem ?? this.anchorItem,
      regions: regions ?? this.regions,
      results: results ?? this.results,
      selectionState: selectionState ?? this.selectionState,
      hiddenAddresses: hiddenAddresses ?? this.hiddenAddresses,
      focusRequestId: focusRequestId ?? this.focusRequestId,
      topNextStep: topNextStep ?? this.topNextStep,
      bottomNextStep: bottomNextStep ?? this.bottomNextStep,
      isInitializing: isInitializing ?? this.isInitializing,
      isLoadingAbove: isLoadingAbove ?? this.isLoadingAbove,
      isLoadingBelow: isLoadingBelow ?? this.isLoadingBelow,
      reachedTopBoundary: reachedTopBoundary ?? this.reachedTopBoundary,
      reachedBottomBoundary:
          reachedBottomBoundary ?? this.reachedBottomBoundary,
      errorText: clearErrorText ? null : errorText ?? this.errorText,
    );
  }
}
