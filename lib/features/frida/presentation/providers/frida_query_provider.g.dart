// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frida_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fridaQueryDatasource)
const fridaQueryDatasourceProvider = FridaQueryDatasourceProvider._();

final class FridaQueryDatasourceProvider
    extends
        $FunctionalProvider<
          FridaQueryDatasource,
          FridaQueryDatasource,
          FridaQueryDatasource
        >
    with $Provider<FridaQueryDatasource> {
  const FridaQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fridaQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fridaQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<FridaQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FridaQueryDatasource create(Ref ref) {
    return fridaQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FridaQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FridaQueryDatasource>(value),
    );
  }
}

String _$fridaQueryDatasourceHash() =>
    r'f5bfd3df03716f79f5de5428fc92bf8493824c0d';

@ProviderFor(fridaQueryRepository)
const fridaQueryRepositoryProvider = FridaQueryRepositoryProvider._();

final class FridaQueryRepositoryProvider
    extends
        $FunctionalProvider<
          FridaQueryRepository,
          FridaQueryRepository,
          FridaQueryRepository
        >
    with $Provider<FridaQueryRepository> {
  const FridaQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fridaQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fridaQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<FridaQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FridaQueryRepository create(Ref ref) {
    return fridaQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FridaQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FridaQueryRepository>(value),
    );
  }
}

String _$fridaQueryRepositoryHash() =>
    r'4b8e0f702856b8cb85b168b3dd9d8138d7b4d979';

@ProviderFor(fridaScripts)
const fridaScriptsProvider = FridaScriptsFamily._();

final class FridaScriptsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const FridaScriptsProvider._({
    required FridaScriptsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fridaScriptsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fridaScriptsHash();

  @override
  String toString() {
    return r'fridaScriptsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return fridaScripts(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FridaScriptsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fridaScriptsHash() => r'e53aaaa7c82d8c71ba106520c6ae2af3fc2b5664';

final class FridaScriptsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  const FridaScriptsFamily._()
    : super(
        retry: null,
        name: r'fridaScriptsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  FridaScriptsProvider call({required String packageName}) =>
      FridaScriptsProvider._(argument: packageName, from: this);

  @override
  String toString() => r'fridaScriptsProvider';
}

@ProviderFor(readFridaScript)
const readFridaScriptProvider = ReadFridaScriptFamily._();

final class ReadFridaScriptProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const ReadFridaScriptProvider._({
    required ReadFridaScriptFamily super.from,
    required ({String packageName, String localPath}) super.argument,
  }) : super(
         retry: null,
         name: r'readFridaScriptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$readFridaScriptHash();

  @override
  String toString() {
    return r'readFridaScriptProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as ({String packageName, String localPath});
    return readFridaScript(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReadFridaScriptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$readFridaScriptHash() => r'd950c6c1aae2f29ceaf9a0de64b6e9a5d406b9fb';

final class ReadFridaScriptFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String>,
          ({String packageName, String localPath})
        > {
  const ReadFridaScriptFamily._()
    : super(
        retry: null,
        name: r'readFridaScriptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReadFridaScriptProvider call({
    required String packageName,
    required String localPath,
  }) => ReadFridaScriptProvider._(
    argument: (packageName: packageName, localPath: localPath),
    from: this,
  );

  @override
  String toString() => r'readFridaScriptProvider';
}

@ProviderFor(getFridaScriptStatus)
const getFridaScriptStatusProvider = GetFridaScriptStatusFamily._();

final class GetFridaScriptStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const GetFridaScriptStatusProvider._({
    required GetFridaScriptStatusFamily super.from,
    required ({String packageName, String localPath}) super.argument,
  }) : super(
         retry: null,
         name: r'getFridaScriptStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getFridaScriptStatusHash();

  @override
  String toString() {
    return r'getFridaScriptStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({String packageName, String localPath});
    return getFridaScriptStatus(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetFridaScriptStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getFridaScriptStatusHash() =>
    r'a9db3bfd6020a98dbc2168401da1445d4a139990';

final class GetFridaScriptStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({String packageName, String localPath})
        > {
  const GetFridaScriptStatusFamily._()
    : super(
        retry: null,
        name: r'getFridaScriptStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetFridaScriptStatusProvider call({
    required String packageName,
    required String localPath,
  }) => GetFridaScriptStatusProvider._(
    argument: (packageName: packageName, localPath: localPath),
    from: this,
  );

  @override
  String toString() => r'getFridaScriptStatusProvider';
}

@ProviderFor(isZygiskModuleInstalled)
const isZygiskModuleInstalledProvider = IsZygiskModuleInstalledProvider._();

final class IsZygiskModuleInstalledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsZygiskModuleInstalledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isZygiskModuleInstalledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isZygiskModuleInstalledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isZygiskModuleInstalled(ref);
  }
}

String _$isZygiskModuleInstalledHash() =>
    r'1761f623d69d9f99e43b5bb9096e4b28d2013e49';
