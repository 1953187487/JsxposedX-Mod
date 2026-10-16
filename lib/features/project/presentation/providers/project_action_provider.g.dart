// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectActionDatasource)
const projectActionDatasourceProvider = ProjectActionDatasourceProvider._();

final class ProjectActionDatasourceProvider
    extends
        $FunctionalProvider<
          ProjectActionDatasource,
          ProjectActionDatasource,
          ProjectActionDatasource
        >
    with $Provider<ProjectActionDatasource> {
  const ProjectActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<ProjectActionDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectActionDatasource create(Ref ref) {
    return projectActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectActionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectActionDatasource>(value),
    );
  }
}

String _$projectActionDatasourceHash() =>
    r'a8fbdda8df8e6fa019d24f446e6a8c5a03d233bb';

@ProviderFor(projectActionRepository)
const projectActionRepositoryProvider = ProjectActionRepositoryProvider._();

final class ProjectActionRepositoryProvider
    extends
        $FunctionalProvider<
          ProjectActionRepository,
          ProjectActionRepository,
          ProjectActionRepository
        >
    with $Provider<ProjectActionRepository> {
  const ProjectActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProjectActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectActionRepository create(Ref ref) {
    return projectActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectActionRepository>(value),
    );
  }
}

String _$projectActionRepositoryHash() =>
    r'3522f143e421de83908b7455bf30e7af9cac48a1';

@ProviderFor(initProject)
const initProjectProvider = InitProjectProvider._();

final class InitProjectProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const InitProjectProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initProjectProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initProjectHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return initProject(ref);
  }
}

String _$initProjectHash() => r'53a8ebb3cd150ebad0db23d690b48ba80615f9a2';

@ProviderFor(createProject)
const createProjectProvider = CreateProjectFamily._();

final class CreateProjectProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const CreateProjectProvider._({
    required CreateProjectFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'createProjectProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createProjectHash();

  @override
  String toString() {
    return r'createProjectProvider'
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
    return createProject(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateProjectProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createProjectHash() => r'4fbd3d10a60afc1b8440e1b94b52e397ecaa0759';

final class CreateProjectFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  const CreateProjectFamily._()
    : super(
        retry: null,
        name: r'createProjectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateProjectProvider call({required String packageName}) =>
      CreateProjectProvider._(argument: packageName, from: this);

  @override
  String toString() => r'createProjectProvider';
}

@ProviderFor(deleteProject)
const deleteProjectProvider = DeleteProjectFamily._();

final class DeleteProjectProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteProjectProvider._({
    required DeleteProjectFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'deleteProjectProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteProjectHash();

  @override
  String toString() {
    return r'deleteProjectProvider'
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
    return deleteProject(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteProjectProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteProjectHash() => r'ce70f21e4cbedf20c3b341ad204d62f7c083db4d';

final class DeleteProjectFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  const DeleteProjectFamily._()
    : super(
        retry: null,
        name: r'deleteProjectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteProjectProvider call({required String packageName}) =>
      DeleteProjectProvider._(argument: packageName, from: this);

  @override
  String toString() => r'deleteProjectProvider';
}

@ProviderFor(deleteAuditLog)
const deleteAuditLogProvider = DeleteAuditLogFamily._();

final class DeleteAuditLogProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const DeleteAuditLogProvider._({
    required DeleteAuditLogFamily super.from,
    required ({String packageName, int timestamp}) super.argument,
  }) : super(
         retry: null,
         name: r'deleteAuditLogProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$deleteAuditLogHash();

  @override
  String toString() {
    return r'deleteAuditLogProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({String packageName, int timestamp});
    return deleteAuditLog(
      ref,
      packageName: argument.packageName,
      timestamp: argument.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteAuditLogProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$deleteAuditLogHash() => r'901d6495d42d94c8ed25d676bf41ace9b0102eb3';

final class DeleteAuditLogFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, int timestamp})
        > {
  const DeleteAuditLogFamily._()
    : super(
        retry: null,
        name: r'deleteAuditLogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DeleteAuditLogProvider call({
    required String packageName,
    required int timestamp,
  }) => DeleteAuditLogProvider._(
    argument: (packageName: packageName, timestamp: timestamp),
    from: this,
  );

  @override
  String toString() => r'deleteAuditLogProvider';
}

@ProviderFor(updateAuditLog)
const updateAuditLogProvider = UpdateAuditLogFamily._();

final class UpdateAuditLogProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const UpdateAuditLogProvider._({
    required UpdateAuditLogFamily super.from,
    required ({String packageName, AuditLog log}) super.argument,
  }) : super(
         retry: null,
         name: r'updateAuditLogProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateAuditLogHash();

  @override
  String toString() {
    return r'updateAuditLogProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({String packageName, AuditLog log});
    return updateAuditLog(
      ref,
      packageName: argument.packageName,
      log: argument.log,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateAuditLogProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateAuditLogHash() => r'58b2d406c21d60de3da3c3b66dc940d17f2e4d5c';

final class UpdateAuditLogFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, AuditLog log})
        > {
  const UpdateAuditLogFamily._()
    : super(
        retry: null,
        name: r'updateAuditLogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateAuditLogProvider call({
    required String packageName,
    required AuditLog log,
  }) => UpdateAuditLogProvider._(
    argument: (packageName: packageName, log: log),
    from: this,
  );

  @override
  String toString() => r'updateAuditLogProvider';
}

@ProviderFor(clearAuditLogs)
const clearAuditLogsProvider = ClearAuditLogsFamily._();

final class ClearAuditLogsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const ClearAuditLogsProvider._({
    required ClearAuditLogsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'clearAuditLogsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clearAuditLogsHash();

  @override
  String toString() {
    return r'clearAuditLogsProvider'
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
    return clearAuditLogs(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ClearAuditLogsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clearAuditLogsHash() => r'e4ff5ed935cd9913bbd976ec8353a7da77df7dd7';

final class ClearAuditLogsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  const ClearAuditLogsFamily._()
    : super(
        retry: null,
        name: r'clearAuditLogsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ClearAuditLogsProvider call({required String packageName}) =>
      ClearAuditLogsProvider._(argument: packageName, from: this);

  @override
  String toString() => r'clearAuditLogsProvider';
}

@ProviderFor(saveAuditLogJsCode)
const saveAuditLogJsCodeProvider = SaveAuditLogJsCodeFamily._();

final class SaveAuditLogJsCodeProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const SaveAuditLogJsCodeProvider._({
    required SaveAuditLogJsCodeFamily super.from,
    required ({String packageName, String code}) super.argument,
  }) : super(
         retry: null,
         name: r'saveAuditLogJsCodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saveAuditLogJsCodeHash();

  @override
  String toString() {
    return r'saveAuditLogJsCodeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({String packageName, String code});
    return saveAuditLogJsCode(
      ref,
      packageName: argument.packageName,
      code: argument.code,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SaveAuditLogJsCodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saveAuditLogJsCodeHash() =>
    r'8c23ddc724d3d992bbf8ea07cec7d461b598fa98';

final class SaveAuditLogJsCodeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String code})
        > {
  const SaveAuditLogJsCodeFamily._()
    : super(
        retry: null,
        name: r'saveAuditLogJsCodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SaveAuditLogJsCodeProvider call({
    required String packageName,
    required String code,
  }) => SaveAuditLogJsCodeProvider._(
    argument: (packageName: packageName, code: code),
    from: this,
  );

  @override
  String toString() => r'saveAuditLogJsCodeProvider';
}
