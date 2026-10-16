import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_overlay_ui_state_provider.g.dart';

const Object _aiOverlayUnset = Object();

class AiOverlayUiState {
  const AiOverlayUiState({
    this.isExpanded = false,
    this.offset,
    this.boundPid,
    this.panelSize,
  });

  final bool isExpanded;
  final Offset? offset;
  final int? boundPid;
  final Size? panelSize;

  AiOverlayUiState copyWith({
    bool? isExpanded,
    Object? offset = _aiOverlayUnset,
    Object? boundPid = _aiOverlayUnset,
    Object? panelSize = _aiOverlayUnset,
  }) {
    return AiOverlayUiState(
      isExpanded: isExpanded ?? this.isExpanded,
      offset: identical(offset, _aiOverlayUnset) ? this.offset : offset as Offset?,
      boundPid: identical(boundPid, _aiOverlayUnset) ? this.boundPid : boundPid as int?,
      panelSize: identical(panelSize, _aiOverlayUnset)
          ? this.panelSize
          : panelSize as Size?,
    );
  }
}

@Riverpod(keepAlive: true)
class AiOverlayUiStateController extends _$AiOverlayUiStateController {
  @override
  AiOverlayUiState build() {
    return const AiOverlayUiState();
  }

  void bindProcess({
    required int pid,
    required Offset initialOffset,
    required Size initialPanelSize,
  }) {
    if (state.boundPid == pid) {
      return;
    }
    state = AiOverlayUiState(
      isExpanded: false,
      offset: initialOffset,
      boundPid: pid,
      panelSize: initialPanelSize,
    );
  }

  void setExpanded(bool value) {
    if (state.isExpanded == value) {
      return;
    }
    state = state.copyWith(isExpanded: value);
  }

  void setOffset(Offset value) {
    if (state.offset == value) {
      return;
    }
    state = state.copyWith(offset: value);
  }

  void setPanelSize(Size value) {
    if (state.panelSize == value) {
      return;
    }
    state = state.copyWith(panelSize: value);
  }
}
