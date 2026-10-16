// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_functions_config_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quickFunctionsConfigQueryDatasource)
const quickFunctionsConfigQueryDatasourceProvider =
    QuickFunctionsConfigQueryDatasourceProvider._();

final class QuickFunctionsConfigQueryDatasourceProvider
    extends
        $FunctionalProvider<
          QuickFunctionsConfigQueryDataSource,
          QuickFunctionsConfigQueryDataSource,
          QuickFunctionsConfigQueryDataSource
        >
    with $Provider<QuickFunctionsConfigQueryDataSource> {
  const QuickFunctionsConfigQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickFunctionsConfigQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$quickFunctionsConfigQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<QuickFunctionsConfigQueryDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuickFunctionsConfigQueryDataSource create(Ref ref) {
    return quickFunctionsConfigQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickFunctionsConfigQueryDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickFunctionsConfigQueryDataSource>(
        value,
      ),
    );
  }
}

String _$quickFunctionsConfigQueryDatasourceHash() =>
    r'bec7ffb11c6461a0fbe354c1d955e28bf8e04347';

@ProviderFor(quickFunctionsConfigQueryRepository)
const quickFunctionsConfigQueryRepositoryProvider =
    QuickFunctionsConfigQueryRepositoryProvider._();

final class QuickFunctionsConfigQueryRepositoryProvider
    extends
        $FunctionalProvider<
          QuickFunctionsConfigQueryRepository,
          QuickFunctionsConfigQueryRepository,
          QuickFunctionsConfigQueryRepository
        >
    with $Provider<QuickFunctionsConfigQueryRepository> {
  const QuickFunctionsConfigQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickFunctionsConfigQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$quickFunctionsConfigQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuickFunctionsConfigQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuickFunctionsConfigQueryRepository create(Ref ref) {
    return quickFunctionsConfigQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickFunctionsConfigQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickFunctionsConfigQueryRepository>(
        value,
      ),
    );
  }
}

String _$quickFunctionsConfigQueryRepositoryHash() =>
    r'a3bb721f2df68e86aa15ff66d4ad886a27c286c5';

/// 获取快捷功能开关状态

@ProviderFor(getQuickFunctionStatus)
const getQuickFunctionStatusProvider = GetQuickFunctionStatusFamily._();

/// 获取快捷功能开关状态

final class GetQuickFunctionStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 获取快捷功能开关状态
  const GetQuickFunctionStatusProvider._({
    required GetQuickFunctionStatusFamily super.from,
    required ({String packageName, String name}) super.argument,
  }) : super(
         retry: null,
         name: r'getQuickFunctionStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getQuickFunctionStatusHash();

  @override
  String toString() {
    return r'getQuickFunctionStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({String packageName, String name});
    return getQuickFunctionStatus(
      ref,
      packageName: argument.packageName,
      name: argument.name,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetQuickFunctionStatusProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getQuickFunctionStatusHash() =>
    r'023e1f94827f008bcd6f20308ec8d37fc1a343e5';

/// 获取快捷功能开关状态

final class GetQuickFunctionStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({String packageName, String name})
        > {
  const GetQuickFunctionStatusFamily._()
    : super(
        retry: null,
        name: r'getQuickFunctionStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 获取快捷功能开关状态

  GetQuickFunctionStatusProvider call({
    required String packageName,
    required String name,
  }) => GetQuickFunctionStatusProvider._(
    argument: (packageName: packageName, name: name),
    from: this,
  );

  @override
  String toString() => r'getQuickFunctionStatusProvider';
}

/// 获取弹窗关键词列表

@ProviderFor(getDialogKeywords)
const getDialogKeywordsProvider = GetDialogKeywordsFamily._();

/// 获取弹窗关键词列表

final class GetDialogKeywordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DialogKeyword>>,
          List<DialogKeyword>,
          FutureOr<List<DialogKeyword>>
        >
    with
        $FutureModifier<List<DialogKeyword>>,
        $FutureProvider<List<DialogKeyword>> {
  /// 获取弹窗关键词列表
  const GetDialogKeywordsProvider._({
    required GetDialogKeywordsFamily super.from,
    required ({String packageName, String name}) super.argument,
  }) : super(
         retry: null,
         name: r'getDialogKeywordsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getDialogKeywordsHash();

  @override
  String toString() {
    return r'getDialogKeywordsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<DialogKeyword>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DialogKeyword>> create(Ref ref) {
    final argument = this.argument as ({String packageName, String name});
    return getDialogKeywords(
      ref,
      packageName: argument.packageName,
      name: argument.name,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetDialogKeywordsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getDialogKeywordsHash() => r'ed6eae4d9b9f2cb38a1c68f2f944cafcabb380f5';

/// 获取弹窗关键词列表

final class GetDialogKeywordsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<DialogKeyword>>,
          ({String packageName, String name})
        > {
  const GetDialogKeywordsFamily._()
    : super(
        retry: null,
        name: r'getDialogKeywordsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 获取弹窗关键词列表

  GetDialogKeywordsProvider call({
    required String packageName,
    required String name,
  }) => GetDialogKeywordsProvider._(
    argument: (packageName: packageName, name: name),
    from: this,
  );

  @override
  String toString() => r'getDialogKeywordsProvider';
}
