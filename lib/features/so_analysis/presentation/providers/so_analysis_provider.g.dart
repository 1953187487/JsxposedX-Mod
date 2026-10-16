// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'so_analysis_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soAnalysisDatasource)
const soAnalysisDatasourceProvider = SoAnalysisDatasourceProvider._();

final class SoAnalysisDatasourceProvider
    extends
        $FunctionalProvider<
          SoAnalysisDatasource,
          SoAnalysisDatasource,
          SoAnalysisDatasource
        >
    with $Provider<SoAnalysisDatasource> {
  const SoAnalysisDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soAnalysisDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soAnalysisDatasourceHash();

  @$internal
  @override
  $ProviderElement<SoAnalysisDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SoAnalysisDatasource create(Ref ref) {
    return soAnalysisDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoAnalysisDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoAnalysisDatasource>(value),
    );
  }
}

String _$soAnalysisDatasourceHash() =>
    r'87e31044613763c3edd56ef5897b8ae54576fbe5';

@ProviderFor(parseSoHeader)
const parseSoHeaderProvider = ParseSoHeaderFamily._();

final class ParseSoHeaderProvider
    extends
        $FunctionalProvider<
          AsyncValue<SoElfHeader>,
          SoElfHeader,
          FutureOr<SoElfHeader>
        >
    with $FutureModifier<SoElfHeader>, $FutureProvider<SoElfHeader> {
  const ParseSoHeaderProvider._({
    required ParseSoHeaderFamily super.from,
    required ({String sessionId, String soPath}) super.argument,
  }) : super(
         retry: null,
         name: r'parseSoHeaderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseSoHeaderHash();

  @override
  String toString() {
    return r'parseSoHeaderProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<SoElfHeader> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SoElfHeader> create(Ref ref) {
    final argument = this.argument as ({String sessionId, String soPath});
    return parseSoHeader(
      ref,
      sessionId: argument.sessionId,
      soPath: argument.soPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ParseSoHeaderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseSoHeaderHash() => r'fcbcb93ed4fe598f8dd06eadb231ab0adc9872a3';

final class ParseSoHeaderFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<SoElfHeader>,
          ({String sessionId, String soPath})
        > {
  const ParseSoHeaderFamily._()
    : super(
        retry: null,
        name: r'parseSoHeaderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseSoHeaderProvider call({
    required String sessionId,
    required String soPath,
  }) => ParseSoHeaderProvider._(
    argument: (sessionId: sessionId, soPath: soPath),
    from: this,
  );

  @override
  String toString() => r'parseSoHeaderProvider';
}

@ProviderFor(getSoSections)
const getSoSectionsProvider = GetSoSectionsFamily._();

final class GetSoSectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SoSection>>,
          List<SoSection>,
          FutureOr<List<SoSection>>
        >
    with $FutureModifier<List<SoSection>>, $FutureProvider<List<SoSection>> {
  const GetSoSectionsProvider._({
    required GetSoSectionsFamily super.from,
    required ({String sessionId, String soPath}) super.argument,
  }) : super(
         retry: null,
         name: r'getSoSectionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getSoSectionsHash();

  @override
  String toString() {
    return r'getSoSectionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SoSection>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SoSection>> create(Ref ref) {
    final argument = this.argument as ({String sessionId, String soPath});
    return getSoSections(
      ref,
      sessionId: argument.sessionId,
      soPath: argument.soPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetSoSectionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getSoSectionsHash() => r'3ea88bb605b2217f635b4b0c7098f5388ec3d378';

final class GetSoSectionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SoSection>>,
          ({String sessionId, String soPath})
        > {
  const GetSoSectionsFamily._()
    : super(
        retry: null,
        name: r'getSoSectionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetSoSectionsProvider call({
    required String sessionId,
    required String soPath,
  }) => GetSoSectionsProvider._(
    argument: (sessionId: sessionId, soPath: soPath),
    from: this,
  );

  @override
  String toString() => r'getSoSectionsProvider';
}

@ProviderFor(getExportedSymbols)
const getExportedSymbolsProvider = GetExportedSymbolsFamily._();

final class GetExportedSymbolsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SoSymbol>>,
          List<SoSymbol>,
          FutureOr<List<SoSymbol>>
        >
    with $FutureModifier<List<SoSymbol>>, $FutureProvider<List<SoSymbol>> {
  const GetExportedSymbolsProvider._({
    required GetExportedSymbolsFamily super.from,
    required ({String sessionId, String soPath}) super.argument,
  }) : super(
         retry: null,
         name: r'getExportedSymbolsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getExportedSymbolsHash();

  @override
  String toString() {
    return r'getExportedSymbolsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SoSymbol>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SoSymbol>> create(Ref ref) {
    final argument = this.argument as ({String sessionId, String soPath});
    return getExportedSymbols(
      ref,
      sessionId: argument.sessionId,
      soPath: argument.soPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetExportedSymbolsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getExportedSymbolsHash() =>
    r'102a25423f91fa1620e36c9df546d5bd51b68add';

final class GetExportedSymbolsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SoSymbol>>,
          ({String sessionId, String soPath})
        > {
  const GetExportedSymbolsFamily._()
    : super(
        retry: null,
        name: r'getExportedSymbolsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetExportedSymbolsProvider call({
    required String sessionId,
    required String soPath,
  }) => GetExportedSymbolsProvider._(
    argument: (sessionId: sessionId, soPath: soPath),
    from: this,
  );

  @override
  String toString() => r'getExportedSymbolsProvider';
}

@ProviderFor(getImportedSymbols)
const getImportedSymbolsProvider = GetImportedSymbolsFamily._();

final class GetImportedSymbolsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SoSymbol>>,
          List<SoSymbol>,
          FutureOr<List<SoSymbol>>
        >
    with $FutureModifier<List<SoSymbol>>, $FutureProvider<List<SoSymbol>> {
  const GetImportedSymbolsProvider._({
    required GetImportedSymbolsFamily super.from,
    required ({String sessionId, String soPath}) super.argument,
  }) : super(
         retry: null,
         name: r'getImportedSymbolsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getImportedSymbolsHash();

  @override
  String toString() {
    return r'getImportedSymbolsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SoSymbol>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SoSymbol>> create(Ref ref) {
    final argument = this.argument as ({String sessionId, String soPath});
    return getImportedSymbols(
      ref,
      sessionId: argument.sessionId,
      soPath: argument.soPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetImportedSymbolsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getImportedSymbolsHash() =>
    r'0b3a8941d5a9bdae86ccb4139c4a1faa8564c8d7';

final class GetImportedSymbolsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SoSymbol>>,
          ({String sessionId, String soPath})
        > {
  const GetImportedSymbolsFamily._()
    : super(
        retry: null,
        name: r'getImportedSymbolsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetImportedSymbolsProvider call({
    required String sessionId,
    required String soPath,
  }) => GetImportedSymbolsProvider._(
    argument: (sessionId: sessionId, soPath: soPath),
    from: this,
  );

  @override
  String toString() => r'getImportedSymbolsProvider';
}

@ProviderFor(getDependencies)
const getDependenciesProvider = GetDependenciesFamily._();

final class GetDependenciesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SoDependency>>,
          List<SoDependency>,
          FutureOr<List<SoDependency>>
        >
    with
        $FutureModifier<List<SoDependency>>,
        $FutureProvider<List<SoDependency>> {
  const GetDependenciesProvider._({
    required GetDependenciesFamily super.from,
    required ({String sessionId, String soPath}) super.argument,
  }) : super(
         retry: null,
         name: r'getDependenciesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getDependenciesHash();

  @override
  String toString() {
    return r'getDependenciesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SoDependency>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SoDependency>> create(Ref ref) {
    final argument = this.argument as ({String sessionId, String soPath});
    return getDependencies(
      ref,
      sessionId: argument.sessionId,
      soPath: argument.soPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetDependenciesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getDependenciesHash() => r'41e677aa955c3a9f320fdb4da247d2c4cbb4fb99';

final class GetDependenciesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SoDependency>>,
          ({String sessionId, String soPath})
        > {
  const GetDependenciesFamily._()
    : super(
        retry: null,
        name: r'getDependenciesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetDependenciesProvider call({
    required String sessionId,
    required String soPath,
  }) => GetDependenciesProvider._(
    argument: (sessionId: sessionId, soPath: soPath),
    from: this,
  );

  @override
  String toString() => r'getDependenciesProvider';
}

@ProviderFor(getJniFunctions)
const getJniFunctionsProvider = GetJniFunctionsFamily._();

final class GetJniFunctionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SoJniFunction>>,
          List<SoJniFunction>,
          FutureOr<List<SoJniFunction>>
        >
    with
        $FutureModifier<List<SoJniFunction>>,
        $FutureProvider<List<SoJniFunction>> {
  const GetJniFunctionsProvider._({
    required GetJniFunctionsFamily super.from,
    required ({String sessionId, String soPath}) super.argument,
  }) : super(
         retry: null,
         name: r'getJniFunctionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getJniFunctionsHash();

  @override
  String toString() {
    return r'getJniFunctionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SoJniFunction>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SoJniFunction>> create(Ref ref) {
    final argument = this.argument as ({String sessionId, String soPath});
    return getJniFunctions(
      ref,
      sessionId: argument.sessionId,
      soPath: argument.soPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetJniFunctionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getJniFunctionsHash() => r'51376302b2e52e534e5817b8673add1b17d6f057';

final class GetJniFunctionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SoJniFunction>>,
          ({String sessionId, String soPath})
        > {
  const GetJniFunctionsFamily._()
    : super(
        retry: null,
        name: r'getJniFunctionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetJniFunctionsProvider call({
    required String sessionId,
    required String soPath,
  }) => GetJniFunctionsProvider._(
    argument: (sessionId: sessionId, soPath: soPath),
    from: this,
  );

  @override
  String toString() => r'getJniFunctionsProvider';
}

@ProviderFor(getSoStrings)
const getSoStringsProvider = GetSoStringsFamily._();

final class GetSoStringsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SoString>>,
          List<SoString>,
          FutureOr<List<SoString>>
        >
    with $FutureModifier<List<SoString>>, $FutureProvider<List<SoString>> {
  const GetSoStringsProvider._({
    required GetSoStringsFamily super.from,
    required ({String sessionId, String soPath}) super.argument,
  }) : super(
         retry: null,
         name: r'getSoStringsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getSoStringsHash();

  @override
  String toString() {
    return r'getSoStringsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SoString>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SoString>> create(Ref ref) {
    final argument = this.argument as ({String sessionId, String soPath});
    return getSoStrings(
      ref,
      sessionId: argument.sessionId,
      soPath: argument.soPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetSoStringsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getSoStringsHash() => r'acd24e5871f0c4ae4efd542689f9162e468332b1';

final class GetSoStringsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SoString>>,
          ({String sessionId, String soPath})
        > {
  const GetSoStringsFamily._()
    : super(
        retry: null,
        name: r'getSoStringsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetSoStringsProvider call({
    required String sessionId,
    required String soPath,
  }) => GetSoStringsProvider._(
    argument: (sessionId: sessionId, soPath: soPath),
    from: this,
  );

  @override
  String toString() => r'getSoStringsProvider';
}

@ProviderFor(generateFridaHook)
const generateFridaHookProvider = GenerateFridaHookFamily._();

final class GenerateFridaHookProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const GenerateFridaHookProvider._({
    required GenerateFridaHookFamily super.from,
    required ({String sessionId, String soPath, String symbolName, int address})
    super.argument,
  }) : super(
         retry: null,
         name: r'generateFridaHookProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$generateFridaHookHash();

  @override
  String toString() {
    return r'generateFridaHookProvider'
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
            as ({
              String sessionId,
              String soPath,
              String symbolName,
              int address,
            });
    return generateFridaHook(
      ref,
      sessionId: argument.sessionId,
      soPath: argument.soPath,
      symbolName: argument.symbolName,
      address: argument.address,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GenerateFridaHookProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$generateFridaHookHash() => r'd5fc4b62dbaf4de58517fff219d2738e4257d321';

final class GenerateFridaHookFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String>,
          ({String sessionId, String soPath, String symbolName, int address})
        > {
  const GenerateFridaHookFamily._()
    : super(
        retry: null,
        name: r'generateFridaHookProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GenerateFridaHookProvider call({
    required String sessionId,
    required String soPath,
    required String symbolName,
    required int address,
  }) => GenerateFridaHookProvider._(
    argument: (
      sessionId: sessionId,
      soPath: soPath,
      symbolName: symbolName,
      address: address,
    ),
    from: this,
  );

  @override
  String toString() => r'generateFridaHookProvider';
}
