// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_ai_overlay_environment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(memoryAiOverlayEnvironment)
const memoryAiOverlayEnvironmentProvider = MemoryAiOverlayEnvironmentFamily._();

final class MemoryAiOverlayEnvironmentProvider
    extends
        $FunctionalProvider<
          MemoryAiOverlayEnvironmentAdapter,
          MemoryAiOverlayEnvironmentAdapter,
          MemoryAiOverlayEnvironmentAdapter
        >
    with $Provider<MemoryAiOverlayEnvironmentAdapter> {
  const MemoryAiOverlayEnvironmentProvider._({
    required MemoryAiOverlayEnvironmentFamily super.from,
    required MemoryAiOverlayEnvironmentArgs super.argument,
  }) : super(
         retry: null,
         name: r'memoryAiOverlayEnvironmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$memoryAiOverlayEnvironmentHash();

  @override
  String toString() {
    return r'memoryAiOverlayEnvironmentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MemoryAiOverlayEnvironmentAdapter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MemoryAiOverlayEnvironmentAdapter create(Ref ref) {
    final argument = this.argument as MemoryAiOverlayEnvironmentArgs;
    return memoryAiOverlayEnvironment(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryAiOverlayEnvironmentAdapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoryAiOverlayEnvironmentAdapter>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MemoryAiOverlayEnvironmentProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$memoryAiOverlayEnvironmentHash() =>
    r'2360a0b11ac0082d3fe788cbf00a44397096cfcf';

final class MemoryAiOverlayEnvironmentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          MemoryAiOverlayEnvironmentAdapter,
          MemoryAiOverlayEnvironmentArgs
        > {
  const MemoryAiOverlayEnvironmentFamily._()
    : super(
        retry: null,
        name: r'memoryAiOverlayEnvironmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MemoryAiOverlayEnvironmentProvider call(
    MemoryAiOverlayEnvironmentArgs args,
  ) => MemoryAiOverlayEnvironmentProvider._(argument: args, from: this);

  @override
  String toString() => r'memoryAiOverlayEnvironmentProvider';
}
