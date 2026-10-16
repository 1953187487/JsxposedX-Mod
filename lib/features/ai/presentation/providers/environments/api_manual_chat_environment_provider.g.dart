// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_manual_chat_environment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiManualChatEnvironment)
const apiManualChatEnvironmentProvider = ApiManualChatEnvironmentFamily._();

final class ApiManualChatEnvironmentProvider
    extends
        $FunctionalProvider<
          ApiManualChatEnvironmentAdapter,
          ApiManualChatEnvironmentAdapter,
          ApiManualChatEnvironmentAdapter
        >
    with $Provider<ApiManualChatEnvironmentAdapter> {
  const ApiManualChatEnvironmentProvider._({
    required ApiManualChatEnvironmentFamily super.from,
    required ApiManualChatEnvironmentArgs super.argument,
  }) : super(
         retry: null,
         name: r'apiManualChatEnvironmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiManualChatEnvironmentHash();

  @override
  String toString() {
    return r'apiManualChatEnvironmentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ApiManualChatEnvironmentAdapter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApiManualChatEnvironmentAdapter create(Ref ref) {
    final argument = this.argument as ApiManualChatEnvironmentArgs;
    return apiManualChatEnvironment(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiManualChatEnvironmentAdapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiManualChatEnvironmentAdapter>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ApiManualChatEnvironmentProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiManualChatEnvironmentHash() =>
    r'43251f8eb5dfaae22a79797fa862481280e41e7c';

final class ApiManualChatEnvironmentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          ApiManualChatEnvironmentAdapter,
          ApiManualChatEnvironmentArgs
        > {
  const ApiManualChatEnvironmentFamily._()
    : super(
        retry: null,
        name: r'apiManualChatEnvironmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ApiManualChatEnvironmentProvider call(ApiManualChatEnvironmentArgs args) =>
      ApiManualChatEnvironmentProvider._(argument: args, from: this);

  @override
  String toString() => r'apiManualChatEnvironmentProvider';
}
