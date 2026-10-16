// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_query_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checkQueryDatasource)
const checkQueryDatasourceProvider = CheckQueryDatasourceProvider._();

final class CheckQueryDatasourceProvider
    extends
        $FunctionalProvider<
          CheckQueryDatasource,
          CheckQueryDatasource,
          CheckQueryDatasource
        >
    with $Provider<CheckQueryDatasource> {
  const CheckQueryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkQueryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkQueryDatasourceHash();

  @$internal
  @override
  $ProviderElement<CheckQueryDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckQueryDatasource create(Ref ref) {
    return checkQueryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckQueryDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckQueryDatasource>(value),
    );
  }
}

String _$checkQueryDatasourceHash() =>
    r'abe3811a41e4e2a476e778b76fde5b0316e3eff1';

@ProviderFor(checkQueryRepository)
const checkQueryRepositoryProvider = CheckQueryRepositoryProvider._();

final class CheckQueryRepositoryProvider
    extends
        $FunctionalProvider<
          CheckQueryRepository,
          CheckQueryRepository,
          CheckQueryRepository
        >
    with $Provider<CheckQueryRepository> {
  const CheckQueryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkQueryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkQueryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CheckQueryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckQueryRepository create(Ref ref) {
    return checkQueryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckQueryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckQueryRepository>(value),
    );
  }
}

String _$checkQueryRepositoryHash() =>
    r'8661610ee12ffb36f0611105af44cfb630f70096';

@ProviderFor(updateInfo)
const updateInfoProvider = UpdateInfoProvider._();

final class UpdateInfoProvider
    extends $FunctionalProvider<AsyncValue<Update>, Update, FutureOr<Update>>
    with $FutureModifier<Update>, $FutureProvider<Update> {
  const UpdateInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateInfoHash();

  @$internal
  @override
  $FutureProviderElement<Update> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Update> create(Ref ref) {
    return updateInfo(ref);
  }
}

String _$updateInfoHash() => r'32c553148d5cc45fb85d79f904998445e3e052d6';

@ProviderFor(noticeInfo)
const noticeInfoProvider = NoticeInfoProvider._();

final class NoticeInfoProvider
    extends $FunctionalProvider<AsyncValue<Notice>, Notice, FutureOr<Notice>>
    with $FutureModifier<Notice>, $FutureProvider<Notice> {
  const NoticeInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noticeInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noticeInfoHash();

  @$internal
  @override
  $FutureProviderElement<Notice> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Notice> create(Ref ref) {
    return noticeInfo(ref);
  }
}

String _$noticeInfoHash() => r'1bf91a1d9d473eb5a99132ea2af1d632166027b8';
