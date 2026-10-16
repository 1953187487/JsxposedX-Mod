// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apk_reverse_chat_environment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apkReverseChatEnvironment)
const apkReverseChatEnvironmentProvider = ApkReverseChatEnvironmentFamily._();

final class ApkReverseChatEnvironmentProvider
    extends
        $FunctionalProvider<
          ApkReverseChatEnvironmentAdapter,
          ApkReverseChatEnvironmentAdapter,
          ApkReverseChatEnvironmentAdapter
        >
    with $Provider<ApkReverseChatEnvironmentAdapter> {
  const ApkReverseChatEnvironmentProvider._({
    required ApkReverseChatEnvironmentFamily super.from,
    required ApkReverseChatEnvironmentArgs super.argument,
  }) : super(
         retry: null,
         name: r'apkReverseChatEnvironmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apkReverseChatEnvironmentHash();

  @override
  String toString() {
    return r'apkReverseChatEnvironmentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ApkReverseChatEnvironmentAdapter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApkReverseChatEnvironmentAdapter create(Ref ref) {
    final argument = this.argument as ApkReverseChatEnvironmentArgs;
    return apkReverseChatEnvironment(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApkReverseChatEnvironmentAdapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApkReverseChatEnvironmentAdapter>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ApkReverseChatEnvironmentProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apkReverseChatEnvironmentHash() =>
    r'08a445f12d7c240dd203d9668b7fac55301d26a9';

final class ApkReverseChatEnvironmentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          ApkReverseChatEnvironmentAdapter,
          ApkReverseChatEnvironmentArgs
        > {
  const ApkReverseChatEnvironmentFamily._()
    : super(
        retry: null,
        name: r'apkReverseChatEnvironmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ApkReverseChatEnvironmentProvider call(ApkReverseChatEnvironmentArgs args) =>
      ApkReverseChatEnvironmentProvider._(argument: args, from: this);

  @override
  String toString() => r'apkReverseChatEnvironmentProvider';
}
