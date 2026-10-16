// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiStatus)
const aiStatusProvider = AiStatusProvider._();

final class AiStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const AiStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiStatusHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return aiStatus(ref);
  }
}

String _$aiStatusHash() => r'3202fb17366bc6964f4dc7c4b96364438bad331e';

@ProviderFor(aiConnectionTestService)
const aiConnectionTestServiceProvider = AiConnectionTestServiceProvider._();

final class AiConnectionTestServiceProvider
    extends
        $FunctionalProvider<
          AiConnectionTestService,
          AiConnectionTestService,
          AiConnectionTestService
        >
    with $Provider<AiConnectionTestService> {
  const AiConnectionTestServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConnectionTestServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConnectionTestServiceHash();

  @$internal
  @override
  $ProviderElement<AiConnectionTestService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiConnectionTestService create(Ref ref) {
    return aiConnectionTestService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConnectionTestService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConnectionTestService>(value),
    );
  }
}

String _$aiConnectionTestServiceHash() =>
    r'a225edc79d7089f0385ca50015bc2dadd83fa748';

@ProviderFor(AiChatAction)
const aiChatActionProvider = AiChatActionFamily._();

final class AiChatActionProvider
    extends $NotifierProvider<AiChatAction, AiChatRuntimeState> {
  const AiChatActionProvider._({
    required AiChatActionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'aiChatActionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiChatActionHash();

  @override
  String toString() {
    return r'aiChatActionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AiChatAction create() => AiChatAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatRuntimeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatRuntimeState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AiChatActionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiChatActionHash() => r'81a9cf4cc652358f12a6e8019938adeedcc3c405';

final class AiChatActionFamily extends $Family
    with
        $ClassFamilyOverride<
          AiChatAction,
          AiChatRuntimeState,
          AiChatRuntimeState,
          AiChatRuntimeState,
          String
        > {
  const AiChatActionFamily._()
    : super(
        retry: null,
        name: r'aiChatActionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AiChatActionProvider call({required String packageName}) =>
      AiChatActionProvider._(argument: packageName, from: this);

  @override
  String toString() => r'aiChatActionProvider';
}

abstract class _$AiChatAction extends $Notifier<AiChatRuntimeState> {
  late final _$args = ref.$arg as String;
  String get packageName => _$args;

  AiChatRuntimeState build({required String packageName});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(packageName: _$args);
    final ref = this.ref as $Ref<AiChatRuntimeState, AiChatRuntimeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiChatRuntimeState, AiChatRuntimeState>,
              AiChatRuntimeState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
