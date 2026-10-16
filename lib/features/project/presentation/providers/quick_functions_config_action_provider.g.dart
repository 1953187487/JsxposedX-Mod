// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_functions_config_action_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quickFunctionsConfigActionDatasource)
const quickFunctionsConfigActionDatasourceProvider =
    QuickFunctionsConfigActionDatasourceProvider._();

final class QuickFunctionsConfigActionDatasourceProvider
    extends
        $FunctionalProvider<
          QuickFunctionsConfigActionDataSource,
          QuickFunctionsConfigActionDataSource,
          QuickFunctionsConfigActionDataSource
        >
    with $Provider<QuickFunctionsConfigActionDataSource> {
  const QuickFunctionsConfigActionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickFunctionsConfigActionDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$quickFunctionsConfigActionDatasourceHash();

  @$internal
  @override
  $ProviderElement<QuickFunctionsConfigActionDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuickFunctionsConfigActionDataSource create(Ref ref) {
    return quickFunctionsConfigActionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickFunctionsConfigActionDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<QuickFunctionsConfigActionDataSource>(value),
    );
  }
}

String _$quickFunctionsConfigActionDatasourceHash() =>
    r'395c870872e47ff25f89a758e25772039ebdc980';

@ProviderFor(quickFunctionsConfigActionRepository)
const quickFunctionsConfigActionRepositoryProvider =
    QuickFunctionsConfigActionRepositoryProvider._();

final class QuickFunctionsConfigActionRepositoryProvider
    extends
        $FunctionalProvider<
          QuickFunctionsConfigActionRepository,
          QuickFunctionsConfigActionRepository,
          QuickFunctionsConfigActionRepository
        >
    with $Provider<QuickFunctionsConfigActionRepository> {
  const QuickFunctionsConfigActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickFunctionsConfigActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$quickFunctionsConfigActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuickFunctionsConfigActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuickFunctionsConfigActionRepository create(Ref ref) {
    return quickFunctionsConfigActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickFunctionsConfigActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<QuickFunctionsConfigActionRepository>(value),
    );
  }
}

String _$quickFunctionsConfigActionRepositoryHash() =>
    r'83d611544e2dadc6d1b5539ed19a61623f3d7c8a';

/// 设置快捷功能开关状态

@ProviderFor(setQuickFunctionStatus)
const setQuickFunctionStatusProvider = SetQuickFunctionStatusFamily._();

/// 设置快捷功能开关状态

final class SetQuickFunctionStatusProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 设置快捷功能开关状态
  const SetQuickFunctionStatusProvider._({
    required SetQuickFunctionStatusFamily super.from,
    required ({String packageName, String name, bool status}) super.argument,
  }) : super(
         retry: null,
         name: r'setQuickFunctionStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setQuickFunctionStatusHash();

  @override
  String toString() {
    return r'setQuickFunctionStatusProvider'
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
        this.argument as ({String packageName, String name, bool status});
    return setQuickFunctionStatus(
      ref,
      packageName: argument.packageName,
      name: argument.name,
      status: argument.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetQuickFunctionStatusProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setQuickFunctionStatusHash() =>
    r'6c19793b350e9272aa0185aab5fa29a11065e4a1';

/// 设置快捷功能开关状态

final class SetQuickFunctionStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String name, bool status})
        > {
  const SetQuickFunctionStatusFamily._()
    : super(
        retry: null,
        name: r'setQuickFunctionStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 设置快捷功能开关状态

  SetQuickFunctionStatusProvider call({
    required String packageName,
    required String name,
    required bool status,
  }) => SetQuickFunctionStatusProvider._(
    argument: (packageName: packageName, name: name, status: status),
    from: this,
  );

  @override
  String toString() => r'setQuickFunctionStatusProvider';
}

/// 设置弹窗关键词列表

@ProviderFor(setDialogKeywords)
const setDialogKeywordsProvider = SetDialogKeywordsFamily._();

/// 设置弹窗关键词列表

final class SetDialogKeywordsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 设置弹窗关键词列表
  const SetDialogKeywordsProvider._({
    required SetDialogKeywordsFamily super.from,
    required ({String packageName, String name, List<DialogKeyword> keywords})
    super.argument,
  }) : super(
         retry: null,
         name: r'setDialogKeywordsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setDialogKeywordsHash();

  @override
  String toString() {
    return r'setDialogKeywordsProvider'
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
              String name,
              List<DialogKeyword> keywords,
            });
    return setDialogKeywords(
      ref,
      packageName: argument.packageName,
      name: argument.name,
      keywords: argument.keywords,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetDialogKeywordsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setDialogKeywordsHash() => r'429d15a075a069721bab73b4910c73682dc0bdec';

/// 设置弹窗关键词列表

final class SetDialogKeywordsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String name, List<DialogKeyword> keywords})
        > {
  const SetDialogKeywordsFamily._()
    : super(
        retry: null,
        name: r'setDialogKeywordsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 设置弹窗关键词列表

  SetDialogKeywordsProvider call({
    required String packageName,
    required String name,
    required List<DialogKeyword> keywords,
  }) => SetDialogKeywordsProvider._(
    argument: (packageName: packageName, name: name, keywords: keywords),
    from: this,
  );

  @override
  String toString() => r'setDialogKeywordsProvider';
}

/// 添加一个弹窗关键词

@ProviderFor(addDialogKeyword)
const addDialogKeywordProvider = AddDialogKeywordFamily._();

/// 添加一个弹窗关键词

final class AddDialogKeywordProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 添加一个弹窗关键词
  const AddDialogKeywordProvider._({
    required AddDialogKeywordFamily super.from,
    required ({String packageName, String name, DialogKeyword keyword})
    super.argument,
  }) : super(
         retry: null,
         name: r'addDialogKeywordProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addDialogKeywordHash();

  @override
  String toString() {
    return r'addDialogKeywordProvider'
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
            as ({String packageName, String name, DialogKeyword keyword});
    return addDialogKeyword(
      ref,
      packageName: argument.packageName,
      name: argument.name,
      keyword: argument.keyword,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddDialogKeywordProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addDialogKeywordHash() => r'878c4e1f94b162fb442fc5b505bde862188c2b08';

/// 添加一个弹窗关键词

final class AddDialogKeywordFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String name, DialogKeyword keyword})
        > {
  const AddDialogKeywordFamily._()
    : super(
        retry: null,
        name: r'addDialogKeywordProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 添加一个弹窗关键词

  AddDialogKeywordProvider call({
    required String packageName,
    required String name,
    required DialogKeyword keyword,
  }) => AddDialogKeywordProvider._(
    argument: (packageName: packageName, name: name, keyword: keyword),
    from: this,
  );

  @override
  String toString() => r'addDialogKeywordProvider';
}

/// 删除一个弹窗关键词

@ProviderFor(removeDialogKeyword)
const removeDialogKeywordProvider = RemoveDialogKeywordFamily._();

/// 删除一个弹窗关键词

final class RemoveDialogKeywordProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 删除一个弹窗关键词
  const RemoveDialogKeywordProvider._({
    required RemoveDialogKeywordFamily super.from,
    required ({String packageName, String name, String keyword}) super.argument,
  }) : super(
         retry: null,
         name: r'removeDialogKeywordProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$removeDialogKeywordHash();

  @override
  String toString() {
    return r'removeDialogKeywordProvider'
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
        this.argument as ({String packageName, String name, String keyword});
    return removeDialogKeyword(
      ref,
      packageName: argument.packageName,
      name: argument.name,
      keyword: argument.keyword,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RemoveDialogKeywordProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$removeDialogKeywordHash() =>
    r'c0e2f5fd243423ced390b4e571798b1ed7fe5a07';

/// 删除一个弹窗关键词

final class RemoveDialogKeywordFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String name, String keyword})
        > {
  const RemoveDialogKeywordFamily._()
    : super(
        retry: null,
        name: r'removeDialogKeywordProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 删除一个弹窗关键词

  RemoveDialogKeywordProvider call({
    required String packageName,
    required String name,
    required String keyword,
  }) => RemoveDialogKeywordProvider._(
    argument: (packageName: packageName, name: name, keyword: keyword),
    from: this,
  );

  @override
  String toString() => r'removeDialogKeywordProvider';
}

/// 更新关键词选中状态

@ProviderFor(updateDialogKeywordCheck)
const updateDialogKeywordCheckProvider = UpdateDialogKeywordCheckFamily._();

/// 更新关键词选中状态

final class UpdateDialogKeywordCheckProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 更新关键词选中状态
  const UpdateDialogKeywordCheckProvider._({
    required UpdateDialogKeywordCheckFamily super.from,
    required ({String packageName, String name, String keyword, bool isCheck})
    super.argument,
  }) : super(
         retry: null,
         name: r'updateDialogKeywordCheckProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateDialogKeywordCheckHash();

  @override
  String toString() {
    return r'updateDialogKeywordCheckProvider'
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
              String name,
              String keyword,
              bool isCheck,
            });
    return updateDialogKeywordCheck(
      ref,
      packageName: argument.packageName,
      name: argument.name,
      keyword: argument.keyword,
      isCheck: argument.isCheck,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateDialogKeywordCheckProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateDialogKeywordCheckHash() =>
    r'd421da5a760cf09c4f97eff6b72733716f3ffcfd';

/// 更新关键词选中状态

final class UpdateDialogKeywordCheckFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String name, String keyword, bool isCheck})
        > {
  const UpdateDialogKeywordCheckFamily._()
    : super(
        retry: null,
        name: r'updateDialogKeywordCheckProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 更新关键词选中状态

  UpdateDialogKeywordCheckProvider call({
    required String packageName,
    required String name,
    required String keyword,
    required bool isCheck,
  }) => UpdateDialogKeywordCheckProvider._(
    argument: (
      packageName: packageName,
      name: name,
      keyword: keyword,
      isCheck: isCheck,
    ),
    from: this,
  );

  @override
  String toString() => r'updateDialogKeywordCheckProvider';
}

/// 清空关键词列表

@ProviderFor(clearDialogKeywords)
const clearDialogKeywordsProvider = ClearDialogKeywordsFamily._();

/// 清空关键词列表

final class ClearDialogKeywordsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 清空关键词列表
  const ClearDialogKeywordsProvider._({
    required ClearDialogKeywordsFamily super.from,
    required ({String packageName, String name}) super.argument,
  }) : super(
         retry: null,
         name: r'clearDialogKeywordsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$clearDialogKeywordsHash();

  @override
  String toString() {
    return r'clearDialogKeywordsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({String packageName, String name});
    return clearDialogKeywords(
      ref,
      packageName: argument.packageName,
      name: argument.name,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClearDialogKeywordsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clearDialogKeywordsHash() =>
    r'6b2bbbc633c1ca1ac86afdce11465ee31f433ac6';

/// 清空关键词列表

final class ClearDialogKeywordsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String packageName, String name})
        > {
  const ClearDialogKeywordsFamily._()
    : super(
        retry: null,
        name: r'clearDialogKeywordsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 清空关键词列表

  ClearDialogKeywordsProvider call({
    required String packageName,
    required String name,
  }) => ClearDialogKeywordsProvider._(
    argument: (packageName: packageName, name: name),
    from: this,
  );

  @override
  String toString() => r'clearDialogKeywordsProvider';
}
