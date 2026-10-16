// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xposed_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(xposedActionDatasource)
const xposedActionDatasourceProvider = XposedActionDatasourceProvider._();

final class XposedActionDatasourceProvider
    extends
        $FunctionalProvider<
          XposedActionDatasource,
          XposedActionDatasource,
          XposedActionDatasource
        >
    with $Provider<XposedActionDatasource> {
  const XposedActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xposedActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xposedActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<XposedActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  XposedActionDatasource create(Ref ref) {
    return xposedActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(XposedActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<XposedActionDatasource>(value),
    );
  }
}

String _$xposedActionDatasourceHash() =>
    r'a36ac5d8c26a8bcb4c8c3e3b481d739cfbdb1544';

@ProviderFor(xposedActionRepository)
const xposedActionRepositoryProvider = XposedActionRepositoryProvider._();

final class XposedActionRepositoryProvider
    extends
        $FunctionalProvider<
          XposedActionRepository,
          XposedActionRepository,
          XposedActionRepository
        >
    with $Provider<XposedActionRepository> {
  const XposedActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xposedActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xposedActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<XposedActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  XposedActionRepository create(Ref ref) {
    return xposedActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(XposedActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<XposedActionRepository>(value),
    );
  }
}

String _$xposedActionRepositoryHash() =>
    r'5faf877e4c35a8a0a04cf663d04d5963e5658c95';

@ProviderFor(createJsScript)
const createJsScriptProvider = CreateJsScriptFamily._();

final class CreateJsScriptProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const CreateJsScriptProvider._({
    required CreateJsScriptFamily super.from,
    required ({
      String packageName,
      String localPath,
      String content,
      bool append,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'createJsScriptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createJsScriptHash();

  @override
  String toString() {
    return r'createJsScriptProvider'
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
    return createJsScript(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
      content: argument.content,
      append: argument.append,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CreateJsScriptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createJsScriptHash() => r'd6fb2405907e1a608cf21d803f16fec3674b3454';

final class CreateJsScriptFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String localPath, String content, bool append})
        > {
  const CreateJsScriptFamily._()
    : super(
        retry: null,
        name: r'createJsScriptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateJsScriptProvider call({
    required String packageName,
    required String localPath,
    required String content,
    bool append = false,
  }) => CreateJsScriptProvider._(
    argument: (
      packageName: packageName,
      localPath: localPath,
      content: content,
      append: append,
    ),
    from: this,
  );

  @override
  String toString() => r'createJsScriptProvider';
}

@ProviderFor(deleteJsScript)
const deleteJsScriptProvider = DeleteJsScriptFamily._();

final class DeleteJsScriptProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteJsScriptProvider._({
    required DeleteJsScriptFamily super.from,
    required ({String packageName, String localPath}) super.argument,
  }) : super(
         retry: null,
         name: r'deleteJsScriptProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteJsScriptHash();

  @override
  String toString() {
    return r'deleteJsScriptProvider'
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
    return deleteJsScript(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteJsScriptProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteJsScriptHash() => r'20efc3ea8dd81efb5f2f5002e3f6f86c9d28f563';

final class DeleteJsScriptFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String localPath})
        > {
  const DeleteJsScriptFamily._()
    : super(
        retry: null,
        name: r'deleteJsScriptProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteJsScriptProvider call({
    required String packageName,
    required String localPath,
  }) => DeleteJsScriptProvider._(
    argument: (packageName: packageName, localPath: localPath),
    from: this,
  );

  @override
  String toString() => r'deleteJsScriptProvider';
}

@ProviderFor(importJsScripts)
const importJsScriptsProvider = ImportJsScriptsFamily._();

final class ImportJsScriptsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const ImportJsScriptsProvider._({
    required ImportJsScriptsFamily super.from,
    required ({String packageName, List<String> localPaths}) super.argument,
  }) : super(
         retry: null,
         name: r'importJsScriptsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$importJsScriptsHash();

  @override
  String toString() {
    return r'importJsScriptsProvider'
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
    return importJsScripts(
      ref,
      packageName: argument.packageName,
      localPaths: argument.localPaths,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ImportJsScriptsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importJsScriptsHash() => r'043c11ea042abd46329b932e0c63efe7a3c72cd8';

final class ImportJsScriptsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, List<String> localPaths})
        > {
  const ImportJsScriptsFamily._()
    : super(
        retry: null,
        name: r'importJsScriptsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ImportJsScriptsProvider call({
    required String packageName,
    required List<String> localPaths,
  }) => ImportJsScriptsProvider._(
    argument: (packageName: packageName, localPaths: localPaths),
    from: this,
  );

  @override
  String toString() => r'importJsScriptsProvider';
}

@ProviderFor(setJsScriptStatus)
const setJsScriptStatusProvider = SetJsScriptStatusFamily._();

final class SetJsScriptStatusProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const SetJsScriptStatusProvider._({
    required SetJsScriptStatusFamily super.from,
    required ({String packageName, String localPath, bool status})
    super.argument,
  }) : super(
         retry: null,
         name: r'setJsScriptStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setJsScriptStatusHash();

  @override
  String toString() {
    return r'setJsScriptStatusProvider'
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
        this.argument as ({String packageName, String localPath, bool status});
    return setJsScriptStatus(
      ref,
      packageName: argument.packageName,
      localPath: argument.localPath,
      status: argument.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetJsScriptStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setJsScriptStatusHash() => r'483e6d10f3739b67f0467c2ae2324b8b856b1c4f';

final class SetJsScriptStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String localPath, bool status})
        > {
  const SetJsScriptStatusFamily._()
    : super(
        retry: null,
        name: r'setJsScriptStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SetJsScriptStatusProvider call({
    required String packageName,
    required String localPath,
    required bool status,
  }) => SetJsScriptStatusProvider._(
    argument: (packageName: packageName, localPath: localPath, status: status),
    from: this,
  );

  @override
  String toString() => r'setJsScriptStatusProvider';
}
