// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_overlay_ui_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiOverlayUiStateController)
const aiOverlayUiStateControllerProvider =
    AiOverlayUiStateControllerProvider._();

final class AiOverlayUiStateControllerProvider
    extends $NotifierProvider<AiOverlayUiStateController, AiOverlayUiState> {
  const AiOverlayUiStateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiOverlayUiStateControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiOverlayUiStateControllerHash();

  @$internal
  @override
  AiOverlayUiStateController create() => AiOverlayUiStateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiOverlayUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiOverlayUiState>(value),
    );
  }
}

String _$aiOverlayUiStateControllerHash() =>
    r'82bc801bbf01d26712d664b17f6e940acd2e449c';

abstract class _$AiOverlayUiStateController
    extends $Notifier<AiOverlayUiState> {
  AiOverlayUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AiOverlayUiState, AiOverlayUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiOverlayUiState, AiOverlayUiState>,
              AiOverlayUiState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
