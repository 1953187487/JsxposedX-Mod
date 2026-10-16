// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xposed_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(xposedQueryDatasource)
const xposedQueryDatasourceProvider = XposedQueryDatasourceProvider._();

final class XposedQueryDatasourceProvider
    extends
        $FunctionalProvider<
          XposedQueryDatasource,
          XposedQueryDatasource,
          XposedQueryDatasource
        >
    with $Provider<XposedQueryDatasource> {
  const XposedQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xposedQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xposedQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<XposedQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  XposedQueryDatasource create(Ref ref) {
    return xposedQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(XposedQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<XposedQueryDatasource>(value),
    );
  }
}

String _$xposedQueryDatasourceHash() =>
    r'b8ec256827e2317fde04b54e986db28fba2317a5';

@ProviderFor(xposedQueryRepository)
const xposedQueryRepositoryProvider = XposedQueryRepositoryProvider._();

final class XposedQueryRepositoryProvider
    extends
        $FunctionalProvider<
          XposedQueryRepository,
          XposedQueryRepository,
          XposedQueryRepository
        >
    with $Provider<XposedQueryRepository> {
  const XposedQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xposedQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xposedQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<XposedQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  XposedQueryRepository create(Ref ref) {
    return xposedQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(XposedQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<XposedQueryRepository>(value),
    );
  }
}

String _$xposedQueryRepositoryHash() =>
    r'd210f2e45aed7a67d1c122f35d1f04e526960e6d';

@ProviderFor(jsScripts)
const jsScriptsProvider = JsScriptsFamily._();

final class JsScriptsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const JsScriptsProvider._({
    required JsScriptsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'jsScriptsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jsScriptsHash();

  @override
  String toString() {
    return r'jsScriptsProvider'
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
    return jsScripts(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JsScriptsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jsScriptsHash() => r'75179ebe611f69eb7d097f923d864032370a9a64';

final class JsScriptsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  const JsScriptsFamily._()
    : super(
        retry: null,
        name: r'jsScriptsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  JsScriptsProvider call({required String packageName}) =>
      JsScriptsProvider._(argument: packageName, from: this);

  @override
  String toString() => r'jsScriptsProvider';
}

@ProviderFor(readJsScript)
const readJsScriptProvider = ReadJsScriptFamily._();

final class ReadJsScriptProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const ReadJsScriptProvider._({
    required ReadJsScriptFamily super.from,
    required ({String packageName, String localPath}) super.argument,
  }) : super(
         retry: null,
         name: r'readJsScriptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$readJsScriptHash();

  @override
  String toString() {
    return r'readJsScriptProvider'
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
    return readJsScript(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReadJsScriptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$readJsScriptHash() => r'c78bffd7451b343488e47464060e7ce72ed99d98';

final class ReadJsScriptFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String>,
          ({String packageName, String localPath})
        > {
  const ReadJsScriptFamily._()
    : super(
        retry: null,
        name: r'readJsScriptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReadJsScriptProvider call({
    required String packageName,
    required String localPath,
  }) => ReadJsScriptProvider._(
    argument: (packageName: packageName, localPath: localPath),
    from: this,
  );

  @override
  String toString() => r'readJsScriptProvider';
}

@ProviderFor(getJsScriptStatus)
const getJsScriptStatusProvider = GetJsScriptStatusFamily._();

final class GetJsScriptStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const GetJsScriptStatusProvider._({
    required GetJsScriptStatusFamily super.from,
    required ({String packageName, String localPath}) super.argument,
  }) : super(
         retry: null,
         name: r'getJsScriptStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getJsScriptStatusHash();

  @override
  String toString() {
    return r'getJsScriptStatusProvider'
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
    return getJsScriptStatus(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetJsScriptStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getJsScriptStatusHash() => r'4544f4d73f15e6d7b97600740e155701c33380d3';

final class GetJsScriptStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({String packageName, String localPath})
        > {
  const GetJsScriptStatusFamily._()
    : super(
        retry: null,
        name: r'getJsScriptStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetJsScriptStatusProvider call({
    required String packageName,
    required String localPath,
  }) => GetJsScriptStatusProvider._(
    argument: (packageName: packageName, localPath: localPath),
    from: this,
  );

  @override
  String toString() => r'getJsScriptStatusProvider';
}
