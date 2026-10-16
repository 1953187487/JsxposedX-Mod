// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apk_analysis_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apkAnalysisQueryDatasource)
const apkAnalysisQueryDatasourceProvider =
    ApkAnalysisQueryDatasourceProvider._();

final class ApkAnalysisQueryDatasourceProvider
    extends
        $FunctionalProvider<
          ApkAnalysisQueryDatasource,
          ApkAnalysisQueryDatasource,
          ApkAnalysisQueryDatasource
        >
    with $Provider<ApkAnalysisQueryDatasource> {
  const ApkAnalysisQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apkAnalysisQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apkAnalysisQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<ApkAnalysisQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApkAnalysisQueryDatasource create(Ref ref) {
    return apkAnalysisQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApkAnalysisQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApkAnalysisQueryDatasource>(value),
    );
  }
}

String _$apkAnalysisQueryDatasourceHash() =>
    r'82a59010773fdc82f875302b8a6a271cd85d9367';

@ProviderFor(apkAnalysisQueryRepository)
const apkAnalysisQueryRepositoryProvider =
    ApkAnalysisQueryRepositoryProvider._();

final class ApkAnalysisQueryRepositoryProvider
    extends
        $FunctionalProvider<
          ApkAnalysisQueryRepository,
          ApkAnalysisQueryRepository,
          ApkAnalysisQueryRepository
        >
    with $Provider<ApkAnalysisQueryRepository> {
  const ApkAnalysisQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apkAnalysisQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apkAnalysisQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ApkAnalysisQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApkAnalysisQueryRepository create(Ref ref) {
    return apkAnalysisQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApkAnalysisQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApkAnalysisQueryRepository>(value),
    );
  }
}

String _$apkAnalysisQueryRepositoryHash() =>
    r'0642b325c9ccf80aac3693b5d1550c411adbed34';

@ProviderFor(getApkAssets)
const getApkAssetsProvider = GetApkAssetsFamily._();

final class GetApkAssetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApkAsset>>,
          List<ApkAsset>,
          FutureOr<List<ApkAsset>>
        >
    with $FutureModifier<List<ApkAsset>>, $FutureProvider<List<ApkAsset>> {
  const GetApkAssetsProvider._({
    required GetApkAssetsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getApkAssetsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getApkAssetsHash();

  @override
  String toString() {
    return r'getApkAssetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ApkAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ApkAsset>> create(Ref ref) {
    final argument = this.argument as String;
    return getApkAssets(ref, sessionId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetApkAssetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getApkAssetsHash() => r'178a2042d5946bb2e83ff519196af4031c4fb897';

final class GetApkAssetsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ApkAsset>>, String> {
  const GetApkAssetsFamily._()
    : super(
        retry: null,
        name: r'getApkAssetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetApkAssetsProvider call({required String sessionId}) =>
      GetApkAssetsProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'getApkAssetsProvider';
}

@ProviderFor(getApkAssetsAt)
const getApkAssetsAtProvider = GetApkAssetsAtFamily._();

final class GetApkAssetsAtProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApkAsset>>,
          List<ApkAsset>,
          FutureOr<List<ApkAsset>>
        >
    with $FutureModifier<List<ApkAsset>>, $FutureProvider<List<ApkAsset>> {
  const GetApkAssetsAtProvider._({
    required GetApkAssetsAtFamily super.from,
    required ({String sessionId, String path}) super.argument,
  }) : super(
         retry: null,
         name: r'getApkAssetsAtProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getApkAssetsAtHash();

  @override
  String toString() {
    return r'getApkAssetsAtProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ApkAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ApkAsset>> create(Ref ref) {
    final argument = this.argument as ({String sessionId, String path});
    return getApkAssetsAt(
      ref,
      sessionId: argument.sessionId,
      path: argument.path,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetApkAssetsAtProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getApkAssetsAtHash() => r'0eb9fdb59df6d8e59ef37fe2a79c5a951a0c3b1e';

final class GetApkAssetsAtFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ApkAsset>>,
          ({String sessionId, String path})
        > {
  const GetApkAssetsAtFamily._()
    : super(
        retry: null,
        name: r'getApkAssetsAtProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetApkAssetsAtProvider call({
    required String sessionId,
    required String path,
  }) => GetApkAssetsAtProvider._(
    argument: (sessionId: sessionId, path: path),
    from: this,
  );

  @override
  String toString() => r'getApkAssetsAtProvider';
}

@ProviderFor(parseManifest)
const parseManifestProvider = ParseManifestFamily._();

final class ParseManifestProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApkManifest>,
          ApkManifest,
          FutureOr<ApkManifest>
        >
    with $FutureModifier<ApkManifest>, $FutureProvider<ApkManifest> {
  const ParseManifestProvider._({
    required ParseManifestFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'parseManifestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseManifestHash();

  @override
  String toString() {
    return r'parseManifestProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ApkManifest> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApkManifest> create(Ref ref) {
    final argument = this.argument as String;
    return parseManifest(ref, sessionId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ParseManifestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseManifestHash() => r'c4b07488d823d0e42de9e69ffde036263d7292a9';

final class ParseManifestFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ApkManifest>, String> {
  const ParseManifestFamily._()
    : super(
        retry: null,
        name: r'parseManifestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseManifestProvider call({required String sessionId}) =>
      ParseManifestProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'parseManifestProvider';
}

@ProviderFor(getDexPackages)
const getDexPackagesProvider = GetDexPackagesFamily._();

final class GetDexPackagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const GetDexPackagesProvider._({
    required GetDexPackagesFamily super.from,
    required ({String sessionId, List<String> dexPaths, String packagePrefix})
    super.argument,
  }) : super(
         retry: null,
         name: r'getDexPackagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getDexPackagesHash();

  @override
  String toString() {
    return r'getDexPackagesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String sessionId,
              List<String> dexPaths,
              String packagePrefix,
            });
    return getDexPackages(
      ref,
      sessionId: argument.sessionId,
      dexPaths: argument.dexPaths,
      packagePrefix: argument.packagePrefix,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetDexPackagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getDexPackagesHash() => r'df13cf2686f66270cbeda24e1ff7822b36fda6a8';

final class GetDexPackagesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<String>>,
          ({String sessionId, List<String> dexPaths, String packagePrefix})
        > {
  const GetDexPackagesFamily._()
    : super(
        retry: null,
        name: r'getDexPackagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetDexPackagesProvider call({
    required String sessionId,
    required List<String> dexPaths,
    required String packagePrefix,
  }) => GetDexPackagesProvider._(
    argument: (
      sessionId: sessionId,
      dexPaths: dexPaths,
      packagePrefix: packagePrefix,
    ),
    from: this,
  );

  @override
  String toString() => r'getDexPackagesProvider';
}

@ProviderFor(getDexClasses)
const getDexClassesProvider = GetDexClassesFamily._();

final class GetDexClassesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DexClass>>,
          List<DexClass>,
          FutureOr<List<DexClass>>
        >
    with $FutureModifier<List<DexClass>>, $FutureProvider<List<DexClass>> {
  const GetDexClassesProvider._({
    required GetDexClassesFamily super.from,
    required ({String sessionId, List<String> dexPaths, String packageName})
    super.argument,
  }) : super(
         retry: null,
         name: r'getDexClassesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getDexClassesHash();

  @override
  String toString() {
    return r'getDexClassesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<DexClass>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DexClass>> create(Ref ref) {
    final argument =
        this.argument
            as ({String sessionId, List<String> dexPaths, String packageName});
    return getDexClasses(
      ref,
      sessionId: argument.sessionId,
      dexPaths: argument.dexPaths,
      packageName: argument.packageName,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetDexClassesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getDexClassesHash() => r'a1979ec5c834772f82007a223d5b5239c00d2971';

final class GetDexClassesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<DexClass>>,
          ({String sessionId, List<String> dexPaths, String packageName})
        > {
  const GetDexClassesFamily._()
    : super(
        retry: null,
        name: r'getDexClassesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetDexClassesProvider call({
    required String sessionId,
    required List<String> dexPaths,
    required String packageName,
  }) => GetDexClassesProvider._(
    argument: (
      sessionId: sessionId,
      dexPaths: dexPaths,
      packageName: packageName,
    ),
    from: this,
  );

  @override
  String toString() => r'getDexClassesProvider';
}

@ProviderFor(getClassSmali)
const getClassSmaliProvider = GetClassSmaliFamily._();

final class GetClassSmaliProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const GetClassSmaliProvider._({
    required GetClassSmaliFamily super.from,
    required ({String sessionId, List<String> dexPaths, String className})
    super.argument,
  }) : super(
         retry: null,
         name: r'getClassSmaliProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getClassSmaliHash();

  @override
  String toString() {
    return r'getClassSmaliProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument =
        this.argument
            as ({String sessionId, List<String> dexPaths, String className});
    return getClassSmali(
      ref,
      sessionId: argument.sessionId,
      dexPaths: argument.dexPaths,
      className: argument.className,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetClassSmaliProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getClassSmaliHash() => r'7f3bba96bf9b246c9407f77a4b6a4e99b556ec31';

final class GetClassSmaliFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String>,
          ({String sessionId, List<String> dexPaths, String className})
        > {
  const GetClassSmaliFamily._()
    : super(
        retry: null,
        name: r'getClassSmaliProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetClassSmaliProvider call({
    required String sessionId,
    required List<String> dexPaths,
    required String className,
  }) => GetClassSmaliProvider._(
    argument: (sessionId: sessionId, dexPaths: dexPaths, className: className),
    from: this,
  );

  @override
  String toString() => r'getClassSmaliProvider';
}

@ProviderFor(decompileClass)
const decompileClassProvider = DecompileClassFamily._();

final class DecompileClassProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const DecompileClassProvider._({
    required DecompileClassFamily super.from,
    required ({String sessionId, List<String> dexPaths, String className})
    super.argument,
  }) : super(
         retry: null,
         name: r'decompileClassProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$decompileClassHash();

  @override
  String toString() {
    return r'decompileClassProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument =
        this.argument
            as ({String sessionId, List<String> dexPaths, String className});
    return decompileClass(
      ref,
      sessionId: argument.sessionId,
      dexPaths: argument.dexPaths,
      className: argument.className,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DecompileClassProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$decompileClassHash() => r'77968a2a403e068f158a1e05986f50cc6d975106';

final class DecompileClassFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String>,
          ({String sessionId, List<String> dexPaths, String className})
        > {
  const DecompileClassFamily._()
    : super(
        retry: null,
        name: r'decompileClassProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DecompileClassProvider call({
    required String sessionId,
    required List<String> dexPaths,
    required String className,
  }) => DecompileClassProvider._(
    argument: (sessionId: sessionId, dexPaths: dexPaths, className: className),
    from: this,
  );

  @override
  String toString() => r'decompileClassProvider';
}

@ProviderFor(searchDexClasses)
const searchDexClassesProvider = SearchDexClassesFamily._();

final class SearchDexClassesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const SearchDexClassesProvider._({
    required SearchDexClassesFamily super.from,
    required ({String sessionId, List<String> dexPaths, String keyword})
    super.argument,
  }) : super(
         retry: null,
         name: r'searchDexClassesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchDexClassesHash();

  @override
  String toString() {
    return r'searchDexClassesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument =
        this.argument
            as ({String sessionId, List<String> dexPaths, String keyword});
    return searchDexClasses(
      ref,
      sessionId: argument.sessionId,
      dexPaths: argument.dexPaths,
      keyword: argument.keyword,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchDexClassesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchDexClassesHash() => r'91baae209d6a9875880977642300bbb25a7aa20e';

final class SearchDexClassesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<String>>,
          ({String sessionId, List<String> dexPaths, String keyword})
        > {
  const SearchDexClassesFamily._()
    : super(
        retry: null,
        name: r'searchDexClassesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchDexClassesProvider call({
    required String sessionId,
    required List<String> dexPaths,
    required String keyword,
  }) => SearchDexClassesProvider._(
    argument: (sessionId: sessionId, dexPaths: dexPaths, keyword: keyword),
    from: this,
  );

  @override
  String toString() => r'searchDexClassesProvider';
}
