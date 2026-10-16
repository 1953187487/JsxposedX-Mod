// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apk_analysis_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apkAnalysisActionDatasource)
const apkAnalysisActionDatasourceProvider =
    ApkAnalysisActionDatasourceProvider._();

final class ApkAnalysisActionDatasourceProvider
    extends
        $FunctionalProvider<
          ApkAnalysisActionDatasource,
          ApkAnalysisActionDatasource,
          ApkAnalysisActionDatasource
        >
    with $Provider<ApkAnalysisActionDatasource> {
  const ApkAnalysisActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apkAnalysisActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apkAnalysisActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<ApkAnalysisActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApkAnalysisActionDatasource create(Ref ref) {
    return apkAnalysisActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApkAnalysisActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApkAnalysisActionDatasource>(value),
    );
  }
}

String _$apkAnalysisActionDatasourceHash() =>
    r'b3ab31fb2b32f709799175e1860b980be87ac8d2';

@ProviderFor(apkAnalysisActionRepository)
const apkAnalysisActionRepositoryProvider =
    ApkAnalysisActionRepositoryProvider._();

final class ApkAnalysisActionRepositoryProvider
    extends
        $FunctionalProvider<
          ApkAnalysisActionRepository,
          ApkAnalysisActionRepository,
          ApkAnalysisActionRepository
        >
    with $Provider<ApkAnalysisActionRepository> {
  const ApkAnalysisActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apkAnalysisActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apkAnalysisActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ApkAnalysisActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApkAnalysisActionRepository create(Ref ref) {
    return apkAnalysisActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApkAnalysisActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApkAnalysisActionRepository>(value),
    );
  }
}

String _$apkAnalysisActionRepositoryHash() =>
    r'c7cf6b5b0b337eaa17f91ecde5d70a248de3a66a';

@ProviderFor(openApkSession)
const openApkSessionProvider = OpenApkSessionFamily._();

final class OpenApkSessionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const OpenApkSessionProvider._({
    required OpenApkSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'openApkSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$openApkSessionHash();

  @override
  String toString() {
    return r'openApkSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return openApkSession(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenApkSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$openApkSessionHash() => r'8f05be6f85a32245070c46023fb934a40cfba607';

final class OpenApkSessionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  const OpenApkSessionFamily._()
    : super(
        retry: null,
        name: r'openApkSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OpenApkSessionProvider call({required String packageName}) =>
      OpenApkSessionProvider._(argument: packageName, from: this);

  @override
  String toString() => r'openApkSessionProvider';
}

@ProviderFor(closeApkSession)
const closeApkSessionProvider = CloseApkSessionFamily._();

final class CloseApkSessionProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const CloseApkSessionProvider._({
    required CloseApkSessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'closeApkSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$closeApkSessionHash();

  @override
  String toString() {
    return r'closeApkSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as String;
    return closeApkSession(ref, sessionId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CloseApkSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$closeApkSessionHash() => r'718cd7417fc43bb38b27861440572f432672eae2';

final class CloseApkSessionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  const CloseApkSessionFamily._()
    : super(
        retry: null,
        name: r'closeApkSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CloseApkSessionProvider call({required String sessionId}) =>
      CloseApkSessionProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'closeApkSessionProvider';
}
