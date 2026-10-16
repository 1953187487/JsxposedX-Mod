import 'dart:async';

import 'package:JsxposedX/features/memory_tool_overlay/presentation/enums/memory_search_range_preset_enum.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/enums/memory_search_range_section_enum.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/enums/memory_tool_pointer_alignment_option.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_pointer_action_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_pointer_auto_chase_action_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_pointer_auto_chase_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/providers/memory_pointer_query_provider.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/states/memory_tool_pointer_form_state.dart';
import 'package:JsxposedX/features/memory_tool_overlay/presentation/states/memory_tool_pointer_state.dart';
import 'package:JsxposedX/generated/memory_tool.g.dart'
    show
        PointerAutoChaseRequest,
        PointerAutoChaseState,
        PointerScanRequest,
        PointerScanResult,
        PointerScanSessionState,
        SearchTaskStatus;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memory_tool_pointer_provider.g.dart';

const int memoryToolPointerPageSize = 100;

@riverpod
bool hasRunningPointerTask(Ref ref) {
  final taskStateAsync = ref.watch(getPointerScanTaskStateProvider);
  return taskStateAsync.maybeWhen(
    data: (state) => state.status == SearchTaskStatus.running,
    orElse: () => false,
  );
}

@riverpod
List<PointerScanResult> currentPointerResults(Ref ref) {
  return ref.watch(
    memoryToolPointerControllerProvider.select(
      (state) => state.currentLayer?.results ?? const <PointerScanResult>[],
    ),
  );
}

@Riverpod(keepAlive: true)
class MemoryToolPointerSearchForm extends _$MemoryToolPointerSearchForm {
  @override
  MemoryToolPointerFormState build() {
    return const MemoryToolPointerFormState();
  }

  void updatePointerWidth(int pointerWidth) {
    state = state.copyWith(
      pointerWidth: pointerWidth,
      clearValidationError: true,
    );
  }

  void updateMaxOffsetInput(String value) {
    state = state.copyWith(
      maxOffsetInput: value,
      clearValidationError: true,
    );
  }

  void updateMaxDepthInput(String value) {
    state = state.copyWith(
      maxDepthInput: value,
      clearValidationError: true,
    );
  }

  void updateHexOffset(bool value) {
    state = state.copyWith(isHexOffset: value, clearValidationError: true);
  }

  void updateAlignment(MemoryToolPointerAlignmentOption option) {
    state = state.copyWith(
      selectedAlignment: option,
      clearValidationError: true,
    );
  }

  void updateRangePreset(MemorySearchRangePresetEnum preset) {
    final shouldSeedCustomSections =
        preset == MemorySearchRangePresetEnum.custom &&
        state.customRangeSections.isEmpty;
    state = state.copyWith(
      selectedRangePreset: preset,
      customRangeSections: shouldSeedCustomSections
          ? const <MemorySearchRangeSectionEnum>[
              MemorySearchRangeSectionEnum.anonymous,
              MemorySearchRangeSectionEnum.cAlloc,
              MemorySearchRangeSectionEnum.other,
            ]
          : state.customRangeSections,
      clearValidationError: true,
    );
  }

  void toggleCustomRangeSection(MemorySearchRangeSectionEnum section) {
    final nextSections = List<MemorySearchRangeSectionEnum>.from(
      state.customRangeSections,
    );
    if (nextSections.contains(section)) {
      nextSections.remove(section);
    } else {
      nextSections.add(section);
      nextSections.sort((left, right) => left.index.compareTo(right.index));
    }
    state = state.copyWith(
      customRangeSections: nextSections,
      clearValidationError: true,
    );
  }

  int? tryParseMaxOffset() {
    final rawValue = state.maxOffsetInput.trim();
    if (rawValue.isEmpty) {
      state = state.copyWith(
        validationError: MemoryToolPointerFormValidationError.invalidMaxOffset,
      );
      return null;
    }

    final normalized = state.isHexOffset
        ? rawValue.replaceFirst(RegExp(r'^0x', caseSensitive: false), '')
        : rawValue;
    final parsed = int.tryParse(
      normalized,
      radix: state.isHexOffset ? 16 : 10,
    );
    if (parsed == null || parsed < 0) {
      state = state.copyWith(
        validationError: MemoryToolPointerFormValidationError.invalidMaxOffset,
      );
      return null;
    }
    state = state.copyWith(clearValidationError: true);
    return parsed;
  }

  int? tryParseMaxDepth() {
    final rawValue = state.maxDepthInput.trim();
    final parsed = int.tryParse(rawValue);
    if (parsed == null || parsed < 1 || parsed > 12) {
      state = state.copyWith(
        validationError: MemoryToolPointerFormValidationError.invalidMaxDepth,
      );
      return null;
    }
    state = state.copyWith(clearValidationError: true);
    return parsed;
  }
}

@Riverpod(keepAlive: true)
class MemoryToolPointerController extends _$MemoryToolPointerController {
  static const Set<String> _staticRegionTypeKeys = <String>{'cData', 'cBss'};
  int _autoChaseRunToken = 0;
  PointerScanRequest? _autoChaseBaseRequest;

  @override
  MemoryToolPointerState build() {
    return const MemoryToolPointerState();
  }

  Future<void> startRootScan({required PointerScanRequest request}) async {
    await _interruptAutoChaseIfNeeded();
    _autoChaseBaseRequest = null;
    await _startFreshScan(request: request, isAutoChasing: false);
  }

  Future<void> startAutoChase({
    required PointerScanRequest request,
    required int maxDepth,
  }) async {
    _autoChaseRunToken += 1;
    final runToken = _autoChaseRunToken;
    _autoChaseBaseRequest = request;
    state = MemoryToolPointerState(
      layers: <PointerChainLayerState>[
        PointerChainLayerState(
          request: request,
          autoChaseLayerIndex: 0,
          isLoadingInitial: true,
          staticOnlyMode: true,
        ),
      ],
      currentLayerIndex: 0,
      isAutoChasing: true,
      autoChaseMaxDepth: maxDepth,
      autoChaseCurrentDepth: 0,
    );

    try {
      await ref
          .read(memoryPointerAutoChaseActionProvider.notifier)
          .startPointerAutoChase(
            request: PointerAutoChaseRequest(
              pid: request.pid,
              targetAddress: request.targetAddress,
              pointerWidth: request.pointerWidth,
              maxOffset: request.maxOffset,
              alignment: request.alignment,
              maxDepth: maxDepth,
              rangeSectionKeys: request.rangeSectionKeys,
              scanAllReadableRegions: request.scanAllReadableRegions,
            ),
          );
    } catch (error) {
      state = MemoryToolPointerState(
        layers: <PointerChainLayerState>[
          PointerChainLayerState(
            request: request,
            autoChaseLayerIndex: 0,
            isLoadingInitial: false,
            errorText: error.toString(),
            autoStopReasonKey: 'failed',
            staticOnlyMode: true,
          ),
        ],
        currentLayerIndex: 0,
      );
      return;
    }

    unawaited(_pollAutoChaseState(runToken));
  }

  Future<void> continueScan({
    required PointerScanResult result,
    required PointerScanRequest baseRequest,
  }) async {
    await _interruptAutoChaseIfNeeded();
    final request = _buildNextRequest(
      baseRequest: baseRequest,
      targetAddress: result.pointerAddress,
    );
    final nextLayers = <PointerChainLayerState>[
      ...state.layers,
      PointerChainLayerState(
        request: request,
        sourceResult: result,
        isLoadingInitial: true,
        staticOnlyMode: false,
      ),
    ];
    state = state.copyWith(
      layers: nextLayers,
      currentLayerIndex: nextLayers.length - 1,
      isAutoChasing: false,
      autoChaseMaxDepth: 0,
      autoChaseCurrentDepth: 0,
      clearAutoChaseMessage: true,
    );
    try {
      await ref.read(memoryPointerActionProvider.notifier).startPointerScan(
        request: request,
      );
    } catch (error) {
      _updateLayer(
        nextLayers.length - 1,
        nextLayers.last.copyWith(
          isLoadingInitial: false,
          errorText: error.toString(),
        ),
      );
    }
  }

  Future<void> handleTaskCompleted() async {
    try {
      final sessionState = await ref.read(getPointerScanSessionStateProvider.future);
      _ensureLayerForSession(sessionState, isLoadingInitial: false);
      await _refreshLayerForSession(sessionState);
    } catch (error) {
      final targetLayerIndex = _findActiveScanLayerIndex();
      if (targetLayerIndex >= 0 && targetLayerIndex < state.layers.length) {
        _updateLayer(
          targetLayerIndex,
          state.layers[targetLayerIndex].copyWith(
            isLoadingInitial: false,
            isLoadingMore: false,
            errorText: error.toString(),
          ),
        );
      }
    }
  }

  void handleTaskStopped({
    required SearchTaskStatus status,
    required String message,
  }) {
    final layerIndex = _findActiveScanLayerIndex();
    if (layerIndex < 0) {
      return;
    }

    final isCancelled = status == SearchTaskStatus.cancelled;
    _updateLayer(
      layerIndex,
      state.layers[layerIndex].copyWith(
        isLoadingInitial: false,
        isLoadingMore: false,
        errorText: isCancelled ? null : message,
        autoStopReasonKey: isCancelled ? 'cancelled' : null,
        clearErrorText: isCancelled,
      ),
    );
  }

  Future<void> cancelAutoChase() async {
    _autoChaseRunToken += 1;
    final layerIndex = state.currentLayerIndex;
    if (layerIndex >= 0 && layerIndex < state.layers.length) {
      _updateLayer(
        layerIndex,
        state.layers[layerIndex].copyWith(
          isLoadingInitial: false,
          isLoadingMore: false,
          autoStopReasonKey: 'cancelled',
          clearErrorText: true,
        ),
      );
    }
    state = state.copyWith(
      isAutoChasing: false,
      autoChaseCurrentDepth: 0,
      autoChaseMaxDepth: 0,
      autoChaseMessage: 'cancelled',
    );
    await ref
        .read(memoryPointerAutoChaseActionProvider.notifier)
        .cancelPointerAutoChase();
  }

  Future<void> loadMore() async {
    final layerIndex = state.currentLayerIndex;
    final currentLayer = state.currentLayer;
    if (currentLayer == null ||
        currentLayer.isLoadingInitial ||
        currentLayer.isLoadingMore ||
        !currentLayer.hasMore) {
      return;
    }

    _updateLayer(
      layerIndex,
      currentLayer.copyWith(isLoadingMore: true, clearErrorText: true),
    );

    try {
      final nextPage = currentLayer.autoChaseLayerIndex != null
          ? await ref
                .read(memoryPointerAutoChaseQueryRepositoryProvider)
                .getPointerAutoChaseLayerResults(
                  layerIndex: currentLayer.autoChaseLayerIndex!,
                  offset: currentLayer.results.length,
                  limit: memoryToolPointerPageSize,
                )
          : await _loadManualPointerPage(currentLayer);
      final mergedResults = <PointerScanResult>[
        ...currentLayer.results,
        ...nextPage,
      ];
      _updateLayer(
        layerIndex,
        currentLayer.copyWith(
          results: mergedResults,
          isLoadingMore: false,
          hasMore: mergedResults.length < currentLayer.totalResultCount,
          clearErrorText: true,
        ),
      );
    } catch (error) {
      _updateLayer(
        layerIndex,
        currentLayer.copyWith(
          isLoadingMore: false,
          errorText: error.toString(),
        ),
      );
    }
  }

  Future<void> selectLayer(int index) async {
    if (index < 0 || index >= state.layers.length || index == state.currentLayerIndex) {
      return;
    }
    state = state.copyWith(currentLayerIndex: index);
  }

  Future<void> clear() async {
    _autoChaseRunToken += 1;
    _autoChaseBaseRequest = null;
    state = const MemoryToolPointerState();
  }

  bool isStaticRegionType(String regionTypeKey) {
    return _staticRegionTypeKeys.contains(regionTypeKey);
  }

  Future<void> _interruptAutoChaseIfNeeded() async {
    if (!state.isAutoChasing) {
      return;
    }
    _autoChaseRunToken += 1;
    state = state.copyWith(
      isAutoChasing: false,
      autoChaseCurrentDepth: 0,
      autoChaseMaxDepth: 0,
    );
    await ref
        .read(memoryPointerAutoChaseActionProvider.notifier)
        .cancelPointerAutoChase();
  }

  Future<List<PointerScanResult>> _loadManualPointerPage(
    PointerChainLayerState currentLayer,
  ) async {
    final sessionState = await ref.read(getPointerScanSessionStateProvider.future);
    if (!_matchesSession(currentLayer.request, sessionState)) {
      throw StateError('Pointer scan session changed unexpectedly.');
    }
    return await ref.read(memoryPointerQueryRepositoryProvider).getPointerScanResults(
      offset: currentLayer.results.length,
      limit: memoryToolPointerPageSize,
    );
  }

  Future<void> _pollAutoChaseState(int runToken) async {
    try {
      while (_isAutoChaseRunActive(runToken)) {
        final autoChaseState = await ref
            .read(memoryPointerAutoChaseQueryRepositoryProvider)
            .getPointerAutoChaseState();
        if (!_isAutoChaseRunActive(runToken)) {
          return;
        }
        _applyAutoChaseState(autoChaseState);
        if (!autoChaseState.isRunning) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 120));
      }
    } catch (error) {
      if (!_isAutoChaseRunActive(runToken)) {
        return;
      }
      final lastLayerIndex = state.currentLayerIndex;
      if (lastLayerIndex >= 0 && lastLayerIndex < state.layers.length) {
        _updateLayer(
          lastLayerIndex,
          state.layers[lastLayerIndex].copyWith(
            isLoadingInitial: false,
            isLoadingMore: false,
            autoStopReasonKey: 'failed',
            errorText: error.toString(),
          ),
        );
      }
      state = state.copyWith(
        isAutoChasing: false,
        autoChaseCurrentDepth: 0,
        autoChaseMaxDepth: 0,
        autoChaseMessage: error.toString(),
      );
    }
  }

  void ensureSessionLayerVisible({
    required PointerScanSessionState sessionState,
    required bool isLoadingInitial,
  }) {
    _ensureLayerForSession(
      sessionState,
      isLoadingInitial: isLoadingInitial,
    );
  }

  void _applyAutoChaseState(PointerAutoChaseState autoChaseState) {
    final baseRequest = _autoChaseBaseRequest;
    if (baseRequest == null) {
      return;
    }

    final layers = autoChaseState.layers.isEmpty
        ? <PointerChainLayerState>[
            PointerChainLayerState(
              request: baseRequest,
              autoChaseLayerIndex: 0,
              isLoadingInitial: autoChaseState.isRunning,
              errorText: autoChaseState.isRunning || autoChaseState.message.isEmpty
                  ? null
                  : autoChaseState.message,
              autoStopReasonKey: autoChaseState.isRunning ? null : 'failed',
              staticOnlyMode: true,
            ),
          ]
        : List<PointerChainLayerState>.generate(autoChaseState.layers.length, (
            index,
          ) {
            final layer = autoChaseState.layers[index];
            return PointerChainLayerState(
              request: _buildNextRequest(
                baseRequest: baseRequest,
                targetAddress: layer.targetAddress,
              ),
              results: List<PointerScanResult>.from(layer.initialResults),
              totalResultCount: layer.resultCount,
              autoChaseLayerIndex: layer.layerIndex,
              sourceResult: index > 0
                  ? autoChaseState.layers[index - 1].selectedResult
                  : null,
              isLoadingInitial: false,
              isLoadingMore: false,
              hasMore: layer.hasMore,
              selectedPointerAddress: layer.selectedPointerAddress,
              isAutoSelectedLayer: layer.selectedResult != null,
              isTerminalLayer: layer.isTerminalLayer,
              autoStopReasonKey: layer.stopReasonKey.isEmpty
                  ? null
                  : layer.stopReasonKey,
              staticOnlyMode: true,
            );
          });

    state = state.copyWith(
      layers: layers,
      currentLayerIndex: layers.isEmpty ? -1 : layers.length - 1,
      isAutoChasing: autoChaseState.isRunning,
      autoChaseMaxDepth: autoChaseState.maxDepth,
      autoChaseCurrentDepth: autoChaseState.currentDepth,
      autoChaseMessage: autoChaseState.message,
    );
  }

  PointerScanRequest _buildNextRequest({
    required PointerScanRequest baseRequest,
    required int targetAddress,
  }) {
    return PointerScanRequest(
      pid: baseRequest.pid,
      targetAddress: targetAddress,
      pointerWidth: baseRequest.pointerWidth,
      maxOffset: baseRequest.maxOffset,
      alignment: baseRequest.alignment,
      rangeSectionKeys: baseRequest.rangeSectionKeys,
      scanAllReadableRegions: baseRequest.scanAllReadableRegions,
    );
  }

  Future<void> _startFreshScan({
    required PointerScanRequest request,
    required bool isAutoChasing,
  }) async {
    state = MemoryToolPointerState(
      layers: <PointerChainLayerState>[
        PointerChainLayerState(
          request: request,
          isLoadingInitial: true,
          staticOnlyMode: isAutoChasing,
        ),
      ],
      currentLayerIndex: 0,
      isAutoChasing: isAutoChasing,
    );
    try {
      await ref.read(memoryPointerActionProvider.notifier).startPointerScan(
        request: request,
      );
    } catch (error) {
      state = MemoryToolPointerState(
        layers: <PointerChainLayerState>[
          PointerChainLayerState(
            request: request,
            isLoadingInitial: false,
            errorText: error.toString(),
            autoStopReasonKey: isAutoChasing ? 'failed' : null,
            staticOnlyMode: isAutoChasing,
          ),
        ],
        currentLayerIndex: 0,
      );
    }
  }

  Future<void> _refreshLayerForSession(
    PointerScanSessionState sessionState,
  ) async {
    final layerIndex = _findLayerIndexBySession(sessionState);
    if (layerIndex < 0) {
      return;
    }

    final targetLayer = state.layers[layerIndex];
    final results = await ref
        .read(memoryPointerQueryRepositoryProvider)
        .getPointerScanResults(offset: 0, limit: memoryToolPointerPageSize);
    _updateLayer(
      layerIndex,
      targetLayer.copyWith(
        results: results,
        totalResultCount: sessionState.resultCount,
        isLoadingInitial: false,
        hasMore: results.length < sessionState.resultCount,
        clearErrorText: true,
      ),
    );
  }

  void _ensureLayerForSession(
    PointerScanSessionState sessionState, {
    required bool isLoadingInitial,
  }) {
    if (!sessionState.hasActiveSession) {
      return;
    }

    final existingLayerIndex = _findLayerIndexBySession(sessionState);
    if (existingLayerIndex >= 0) {
      final existingLayer = state.layers[existingLayerIndex];
      final nextHasMore = existingLayer.results.length < sessionState.resultCount;
      if (existingLayer.totalResultCount == sessionState.resultCount &&
          existingLayer.isLoadingInitial == isLoadingInitial &&
          existingLayer.hasMore == nextHasMore &&
          existingLayer.errorText == null) {
        return;
      }
      _updateLayer(
        existingLayerIndex,
        existingLayer.copyWith(
          totalResultCount: sessionState.resultCount,
          isLoadingInitial: isLoadingInitial,
          hasMore: nextHasMore,
          clearErrorText: true,
        ),
      );
      return;
    }

    state = MemoryToolPointerState(
      layers: <PointerChainLayerState>[
        PointerChainLayerState(
          request: _buildRequestFromSession(sessionState),
          totalResultCount: sessionState.resultCount,
          isLoadingInitial: isLoadingInitial,
          hasMore: sessionState.resultCount > 0,
        ),
      ],
      currentLayerIndex: 0,
    );
  }

  PointerScanRequest _buildRequestFromSession(PointerScanSessionState sessionState) {
    return PointerScanRequest(
      pid: sessionState.pid,
      targetAddress: sessionState.targetAddress,
      pointerWidth: sessionState.pointerWidth,
      maxOffset: sessionState.maxOffset,
      alignment: sessionState.alignment,
      rangeSectionKeys: const <String>[],
      scanAllReadableRegions: true,
    );
  }

  bool _isAutoChaseRunActive(int runToken) {
    return state.isAutoChasing && _autoChaseRunToken == runToken;
  }

  bool _matchesSession(
    PointerScanRequest request,
    PointerScanSessionState sessionState,
  ) {
    return sessionState.hasActiveSession &&
        request.pid == sessionState.pid &&
        request.targetAddress == sessionState.targetAddress &&
        request.pointerWidth == sessionState.pointerWidth &&
        request.maxOffset == sessionState.maxOffset &&
        request.alignment == sessionState.alignment;
  }

  int _findActiveScanLayerIndex() {
    for (var index = state.layers.length - 1; index >= 0; index -= 1) {
      final layer = state.layers[index];
      if (layer.autoChaseLayerIndex == null &&
          (layer.isLoadingInitial || layer.isLoadingMore)) {
        return index;
      }
    }
    return -1;
  }

  int _findLayerIndexBySession(PointerScanSessionState sessionState) {
    if (!sessionState.hasActiveSession) {
      return -1;
    }
    for (var index = state.layers.length - 1; index >= 0; index -= 1) {
      final layer = state.layers[index];
      if (layer.autoChaseLayerIndex == null &&
          _matchesSession(layer.request, sessionState)) {
        return index;
      }
    }
    return -1;
  }

  void _updateLayer(int index, PointerChainLayerState nextLayer) {
    final nextLayers = List<PointerChainLayerState>.from(state.layers);
    if (index < 0 || index >= nextLayers.length) {
      return;
    }
    nextLayers[index] = nextLayer;
    state = state.copyWith(layers: nextLayers);
  }
}
