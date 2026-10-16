// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frida_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fridaActionDatasource)
const fridaActionDatasourceProvider = FridaActionDatasourceProvider._();

final class FridaActionDatasourceProvider
    extends
        $FunctionalProvider<
          FridaActionDatasource,
          FridaActionDatasource,
          FridaActionDatasource
        >
    with $Provider<FridaActionDatasource> {
  const FridaActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fridaActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fridaActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<FridaActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FridaActionDatasource create(Ref ref) {
    return fridaActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FridaActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FridaActionDatasource>(value),
    );
  }
}

String _$fridaActionDatasourceHash() =>
    r'4eddbad9d761f375eaa11f301e6e1f8344cfbb36';

@ProviderFor(fridaActionRepository)
const fridaActionRepositoryProvider = FridaActionRepositoryProvider._();

final class FridaActionRepositoryProvider
    extends
        $FunctionalProvider<
          FridaActionRepository,
          FridaActionRepository,
          FridaActionRepository
        >
    with $Provider<FridaActionRepository> {
  const FridaActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fridaActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fridaActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<FridaActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FridaActionRepository create(Ref ref) {
    return fridaActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FridaActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FridaActionRepository>(value),
    );
  }
}

String _$fridaActionRepositoryHash() =>
    r'918de03b58706eda583970cc098469f7fc34e590';

@ProviderFor(createFridaScript)
const createFridaScriptProvider = CreateFridaScriptFamily._();

final class CreateFridaScriptProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const CreateFridaScriptProvider._({
    required CreateFridaScriptFamily super.from,
    required ({
      String packageName,
      String localPath,
      String content,
      bool append,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'createFridaScriptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createFridaScriptHash();

  @override
  String toString() {
    return r'createFridaScriptProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String packageName,
              String localPath,
              String content,
              bool append,
            });
    return createFridaScript(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
      content: argument.content,
      append: argument.append,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CreateFridaScriptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createFridaScriptHash() => r'bd52e71b4de6d3604e17abfdbbfe8191b06ab544';

final class CreateFridaScriptFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String localPath, String content, bool append})
        > {
  const CreateFridaScriptFamily._()
    : super(
        retry: null,
        name: r'createFridaScriptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateFridaScriptProvider call({
    required String packageName,
    required String localPath,
    required String content,
    bool append = false,
  }) => CreateFridaScriptProvider._(
    argument: (
      packageName: packageName,
      localPath: localPath,
      content: content,
      append: append,
    ),
    from: this,
  );

  @override
  String toString() => r'createFridaScriptProvider';
}

@ProviderFor(deleteFridaScript)
const deleteFridaScriptProvider = DeleteFridaScriptFamily._();

final class DeleteFridaScriptProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteFridaScriptProvider._({
    required DeleteFridaScriptFamily super.from,
    required ({String packageName, String localPath}) super.argument,
  }) : super(
         retry: null,
         name: r'deleteFridaScriptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteFridaScriptHash();

  @override
  String toString() {
    return r'deleteFridaScriptProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({String packageName, String localPath});
    return deleteFridaScript(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteFridaScriptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteFridaScriptHash() => r'cfcdc98aef121ebdab554ff1582366625361053e';

final class DeleteFridaScriptFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String localPath})
        > {
  const DeleteFridaScriptFamily._()
    : super(
        retry: null,
        name: r'deleteFridaScriptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteFridaScriptProvider call({
    required String packageName,
    required String localPath,
  }) => DeleteFridaScriptProvider._(
    argument: (packageName: packageName, localPath: localPath),
    from: this,
  );

  @override
  String toString() => r'deleteFridaScriptProvider';
}

@ProviderFor(importFridaScripts)
const importFridaScriptsProvider = ImportFridaScriptsFamily._();

final class ImportFridaScriptsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const ImportFridaScriptsProvider._({
    required ImportFridaScriptsFamily super.from,
    required ({String packageName, List<String> localPaths}) super.argument,
  }) : super(
         retry: null,
         name: r'importFridaScriptsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$importFridaScriptsHash();

  @override
  String toString() {
    return r'importFridaScriptsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument as ({String packageName, List<String> localPaths});
    return importFridaScripts(
      ref,
      packageName: argument.packageName,
      localPaths: argument.localPaths,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ImportFridaScriptsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importFridaScriptsHash() =>
    r'ff615dd4dd445361ab68c736986cf5ab130ed6b7';

final class ImportFridaScriptsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, List<String> localPaths})
        > {
  const ImportFridaScriptsFamily._()
    : super(
        retry: null,
        name: r'importFridaScriptsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ImportFridaScriptsProvider call({
    required String packageName,
    required List<String> localPaths,
  }) => ImportFridaScriptsProvider._(
    argument: (packageName: packageName, localPaths: localPaths),
    from: this,
  );

  @override
  String toString() => r'importFridaScriptsProvider';
}

@ProviderFor(setFridaScriptStatus)
const setFridaScriptStatusProvider = SetFridaScriptStatusFamily._();

final class SetFridaScriptStatusProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const SetFridaScriptStatusProvider._({
    required SetFridaScriptStatusFamily super.from,
    required ({String packageName, String localPath, bool enabled})
    super.argument,
  }) : super(
         retry: null,
         name: r'setFridaScriptStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setFridaScriptStatusHash();

  @override
  String toString() {
    return r'setFridaScriptStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument as ({String packageName, String localPath, bool enabled});
    return setFridaScriptStatus(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
      enabled: argument.enabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetFridaScriptStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setFridaScriptStatusHash() =>
    r'788155c921cfb945ba34afb99782790e5182b51f';

final class SetFridaScriptStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String localPath, bool enabled})
        > {
  const SetFridaScriptStatusFamily._()
    : super(
        retry: null,
        name: r'setFridaScriptStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SetFridaScriptStatusProvider call({
    required String packageName,
    required String localPath,
    required bool enabled,
  }) => SetFridaScriptStatusProvider._(
    argument: (
      packageName: packageName,
      localPath: localPath,
      enabled: enabled,
    ),
    from: this,
  );

  @override
  String toString() => r'setFridaScriptStatusProvider';
}

@ProviderFor(bundleFridaHookJs)
const bundleFridaHookJsProvider = BundleFridaHookJsFamily._();

final class BundleFridaHookJsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const BundleFridaHookJsProvider._({
    required BundleFridaHookJsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bundleFridaHookJsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bundleFridaHookJsHash();

  @override
  String toString() {
    return r'bundleFridaHookJsProvider'
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
    return bundleFridaHookJs(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BundleFridaHookJsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bundleFridaHookJsHash() => r'4e6b481b53fe2fb59a3564a4be33621b6e8456e0';

final class BundleFridaHookJsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  const BundleFridaHookJsFamily._()
    : super(
        retry: null,
        name: r'bundleFridaHookJsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BundleFridaHookJsProvider call({required String packageName}) =>
      BundleFridaHookJsProvider._(argument: packageName, from: this);

  @override
  String toString() => r'bundleFridaHookJsProvider';
}

@ProviderFor(getFridaTargetStatus)
const getFridaTargetStatusProvider = GetFridaTargetStatusFamily._();

final class GetFridaTargetStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const GetFridaTargetStatusProvider._({
    required GetFridaTargetStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getFridaTargetStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getFridaTargetStatusHash();

  @override
  String toString() {
    return r'getFridaTargetStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return getFridaTargetStatus(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFridaTargetStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getFridaTargetStatusHash() =>
    r'bdaa129138bd942dbc186473b097af8ea130f83d';

final class GetFridaTargetStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const GetFridaTargetStatusFamily._()
    : super(
        retry: null,
        name: r'getFridaTargetStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetFridaTargetStatusProvider call({required String packageName}) =>
      GetFridaTargetStatusProvider._(argument: packageName, from: this);

  @override
  String toString() => r'getFridaTargetStatusProvider';
}

@ProviderFor(setFridaTargetStatus)
const setFridaTargetStatusProvider = SetFridaTargetStatusFamily._();

final class SetFridaTargetStatusProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const SetFridaTargetStatusProvider._({
    required SetFridaTargetStatusFamily super.from,
    required ({String packageName, bool enabled}) super.argument,
  }) : super(
         retry: null,
         name: r'setFridaTargetStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setFridaTargetStatusHash();

  @override
  String toString() {
    return r'setFridaTargetStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({String packageName, bool enabled});
    return setFridaTargetStatus(
      ref,
      packageName: argument.packageName,
      enabled: argument.enabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetFridaTargetStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setFridaTargetStatusHash() =>
    r'4a07c46f6ba6f24f0048c088474efa5a41d7f877';

final class SetFridaTargetStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, bool enabled})
        > {
  const SetFridaTargetStatusFamily._()
    : super(
        retry: null,
        name: r'setFridaTargetStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SetFridaTargetStatusProvider call({
    required String packageName,
    required bool enabled,
  }) => SetFridaTargetStatusProvider._(
    argument: (packageName: packageName, enabled: enabled),
    from: this,
  );

  @override
  String toString() => r'setFridaTargetStatusProvider';
}
