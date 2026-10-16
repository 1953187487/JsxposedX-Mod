// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appQueryDatasource)
const appQueryDatasourceProvider = AppQueryDatasourceProvider._();

final class AppQueryDatasourceProvider
    extends
        $FunctionalProvider<
          AppQueryDatasource,
          AppQueryDatasource,
          AppQueryDatasource
        >
    with $Provider<AppQueryDatasource> {
  const AppQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<AppQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppQueryDatasource create(Ref ref) {
    return appQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppQueryDatasource>(value),
    );
  }
}

String _$appQueryDatasourceHash() =>
    r'fc3c5cfeffd39ad83e22b1884314a222c0bdf135';

@ProviderFor(appQueryRepository)
const appQueryRepositoryProvider = AppQueryRepositoryProvider._();

final class AppQueryRepositoryProvider
    extends
        $FunctionalProvider<
          AppQueryRepository,
          AppQueryRepository,
          AppQueryRepository
        >
    with $Provider<AppQueryRepository> {
  const AppQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<AppQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppQueryRepository create(Ref ref) {
    return appQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppQueryRepository>(value),
    );
  }
}

String _$appQueryRepositoryHash() =>
    r'9846d7ba512689debcba4b5423e5ac9882c898bc';

/// 获取应用列表

@ProviderFor(installedApps)
const installedAppsProvider = InstalledAppsFamily._();

/// 获取应用列表

final class InstalledAppsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppInfo>>,
          List<AppInfo>,
          FutureOr<List<AppInfo>>
        >
    with $FutureModifier<List<AppInfo>>, $FutureProvider<List<AppInfo>> {
  /// 获取应用列表
  const InstalledAppsProvider._({
    required InstalledAppsFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'installedAppsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$installedAppsHash();

  @override
  String toString() {
    return r'installedAppsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AppInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppInfo>> create(Ref ref) {
    final argument = this.argument as bool;
    return installedApps(ref, includeSystemApps: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InstalledAppsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$installedAppsHash() => r'4f6e355a27e5cb74ccdec91877d4bc2005d18d83';

/// 获取应用列表

final class InstalledAppsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AppInfo>>, bool> {
  const InstalledAppsFamily._()
    : super(
        retry: null,
        name: r'installedAppsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 获取应用列表

  InstalledAppsProvider call({bool includeSystemApps = false}) =>
      InstalledAppsProvider._(argument: includeSystemApps, from: this);

  @override
  String toString() => r'installedAppsProvider';
}

@ProviderFor(getAppByPackageName)
const getAppByPackageNameProvider = GetAppByPackageNameFamily._();

final class GetAppByPackageNameProvider
    extends
        $FunctionalProvider<AsyncValue<AppInfo?>, AppInfo?, FutureOr<AppInfo?>>
    with $FutureModifier<AppInfo?>, $FutureProvider<AppInfo?> {
  const GetAppByPackageNameProvider._({
    required GetAppByPackageNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getAppByPackageNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getAppByPackageNameHash();

  @override
  String toString() {
    return r'getAppByPackageNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AppInfo?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AppInfo?> create(Ref ref) {
    final argument = this.argument as String;
    return getAppByPackageName(ref, packageName: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAppByPackageNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getAppByPackageNameHash() =>
    r'8b0296888be9fd86c4181eb7129e5544b3596c46';

final class GetAppByPackageNameFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AppInfo?>, String> {
  const GetAppByPackageNameFamily._()
    : super(
        retry: null,
        name: r'getAppByPackageNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetAppByPackageNameProvider call({required String packageName}) =>
      GetAppByPackageNameProvider._(argument: packageName, from: this);

  @override
  String toString() => r'getAppByPackageNameProvider';
}
