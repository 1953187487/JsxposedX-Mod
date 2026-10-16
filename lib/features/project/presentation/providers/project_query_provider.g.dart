// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectQueryDatasource)
const projectQueryDatasourceProvider = ProjectQueryDatasourceProvider._();

final class ProjectQueryDatasourceProvider
    extends
        $FunctionalProvider<
          ProjectQueryDatasource,
          ProjectQueryDatasource,
          ProjectQueryDatasource
        >
    with $Provider<ProjectQueryDatasource> {
  const ProjectQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<ProjectQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectQueryDatasource create(Ref ref) {
    return projectQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectQueryDatasource>(value),
    );
  }
}

String _$projectQueryDatasourceHash() =>
    r'7b02ca3b157e3dcc0305c4d7805bb456bee5092b';

@ProviderFor(projectQueryRepository)
const projectQueryRepositoryProvider = ProjectQueryRepositoryProvider._();

final class ProjectQueryRepositoryProvider
    extends
        $FunctionalProvider<
          ProjectQueryRepository,
          ProjectQueryRepository,
          ProjectQueryRepository
        >
    with $Provider<ProjectQueryRepository> {
  const ProjectQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProjectQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectQueryRepository create(Ref ref) {
    return projectQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectQueryRepository>(value),
    );
  }
}

String _$projectQueryRepositoryHash() =>
    r'029a8c81773b252f2bf78c4b3867ceb419e7bf20';

@ProviderFor(projectExists)
const projectExistsProvider = ProjectExistsFamily._();

final class ProjectExistsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const ProjectExistsProvider._({
    required ProjectExistsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectExistsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectExistsHash();

  @override
  String toString() {
    return r'projectExistsProvider'
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
    return projectExists(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectExistsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectExistsHash() => r'950e76f7a26db05e1217d2470fc8465ceee2e356';

final class ProjectExistsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const ProjectExistsFamily._()
    : super(
        retry: null,
        name: r'projectExistsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectExistsProvider call({required String packageName}) =>
      ProjectExistsProvider._(argument: packageName, from: this);

  @override
  String toString() => r'projectExistsProvider';
}

@ProviderFor(projects)
const projectsProvider = ProjectsProvider._();

final class ProjectsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppInfo>>,
          List<AppInfo>,
          FutureOr<List<AppInfo>>
        >
    with $FutureModifier<List<AppInfo>>, $FutureProvider<List<AppInfo>> {
  const ProjectsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsHash();

  @$internal
  @override
  $FutureProviderElement<List<AppInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppInfo>> create(Ref ref) {
    return projects(ref);
  }
}

String _$projectsHash() => r'37e7a55c8a60ef4e524851e6ebd6104035b8e192';

@ProviderFor(auditLogs)
const auditLogsProvider = AuditLogsFamily._();

final class AuditLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AuditLog>>,
          List<AuditLog>,
          FutureOr<List<AuditLog>>
        >
    with $FutureModifier<List<AuditLog>>, $FutureProvider<List<AuditLog>> {
  const AuditLogsProvider._({
    required AuditLogsFamily super.from,
    required ({String packageName, int limit, int offset, String? keyword})
    super.argument,
  }) : super(
         retry: null,
         name: r'auditLogsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$auditLogsHash();

  @override
  String toString() {
    return r'auditLogsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AuditLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AuditLog>> create(Ref ref) {
    final argument =
        this.argument
            as ({String packageName, int limit, int offset, String? keyword});
    return auditLogs(
      ref,
      packageName: argument.packageName,
      limit: argument.limit,
      offset: argument.offset,
      keyword: argument.keyword,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$auditLogsHash() => r'f79a83fbcb88708ff2033410eaa19fa513529c9a';

final class AuditLogsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AuditLog>>,
          ({String packageName, int limit, int offset, String? keyword})
        > {
  const AuditLogsFamily._()
    : super(
        retry: null,
        name: r'auditLogsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AuditLogsProvider call({
    required String packageName,
    required int limit,
    required int offset,
    String? keyword,
  }) => AuditLogsProvider._(
    argument: (
      packageName: packageName,
      limit: limit,
      offset: offset,
      keyword: keyword,
    ),
    from: this,
  );

  @override
  String toString() => r'auditLogsProvider';
}

@ProviderFor(auditLogJsCode)
const auditLogJsCodeProvider = AuditLogJsCodeFamily._();

final class AuditLogJsCodeProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const AuditLogJsCodeProvider._({
    required AuditLogJsCodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'auditLogJsCodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$auditLogJsCodeHash();

  @override
  String toString() {
    return r'auditLogJsCodeProvider'
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
    return auditLogJsCode(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditLogJsCodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$auditLogJsCodeHash() => r'e66aa634d1f9ae53ff95df57b9a02774a76d889f';

final class AuditLogJsCodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  const AuditLogJsCodeFamily._()
    : super(
        retry: null,
        name: r'auditLogJsCodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AuditLogJsCodeProvider call({required String packageName}) =>
      AuditLogJsCodeProvider._(argument: packageName, from: this);

  @override
  String toString() => r'auditLogJsCodeProvider';
}
