// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServerList)
const serverListProvider = ServerListProvider._();

final class ServerListProvider
    extends $AsyncNotifierProvider<ServerList, List<FakeServerConfig>> {
  const ServerListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverListHash();

  @$internal
  @override
  ServerList create() => ServerList();
}

String _$serverListHash() => r'dc0327e087d7d5587aa994c41551a7249027cc93';

abstract class _$ServerList extends $AsyncNotifier<List<FakeServerConfig>> {
  FutureOr<List<FakeServerConfig>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<FakeServerConfig>>, List<FakeServerConfig>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FakeServerConfig>>,
                List<FakeServerConfig>
              >,
              AsyncValue<List<FakeServerConfig>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ActiveServer)
const activeServerProvider = ActiveServerProvider._();

final class ActiveServerProvider
    extends $NotifierProvider<ActiveServer, FakeServerStatus?> {
  const ActiveServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeServerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeServerHash();

  @$internal
  @override
  ActiveServer create() => ActiveServer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FakeServerStatus? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FakeServerStatus?>(value),
    );
  }
}

String _$activeServerHash() => r'6b9648b2a256b591d394f618b7f6e2e9624edb3f';

abstract class _$ActiveServer extends $Notifier<FakeServerStatus?> {
  FakeServerStatus? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FakeServerStatus?, FakeServerStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FakeServerStatus?, FakeServerStatus?>,
              FakeServerStatus?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ServerRuntimeStatus)
const serverRuntimeStatusProvider = ServerRuntimeStatusFamily._();

final class ServerRuntimeStatusProvider
    extends $AsyncNotifierProvider<ServerRuntimeStatus, FakeServerStatus?> {
  const ServerRuntimeStatusProvider._({
    required ServerRuntimeStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serverRuntimeStatusProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serverRuntimeStatusHash();

  @override
  String toString() {
    return r'serverRuntimeStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ServerRuntimeStatus create() => ServerRuntimeStatus();

  @override
  bool operator ==(Object other) {
    return other is ServerRuntimeStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serverRuntimeStatusHash() =>
    r'09c7c7d451d387f3d8e4b2802a124422475d5df3';

final class ServerRuntimeStatusFamily extends $Family
    with
        $ClassFamilyOverride<
          ServerRuntimeStatus,
          AsyncValue<FakeServerStatus?>,
          FakeServerStatus?,
          FutureOr<FakeServerStatus?>,
          String
        > {
  const ServerRuntimeStatusFamily._()
    : super(
        retry: null,
        name: r'serverRuntimeStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ServerRuntimeStatusProvider call(String serverId) =>
      ServerRuntimeStatusProvider._(argument: serverId, from: this);

  @override
  String toString() => r'serverRuntimeStatusProvider';
}

abstract class _$ServerRuntimeStatus extends $AsyncNotifier<FakeServerStatus?> {
  late final _$args = ref.$arg as String;
  String get serverId => _$args;

  FutureOr<FakeServerStatus?> build(String serverId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<FakeServerStatus?>, FakeServerStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FakeServerStatus?>, FakeServerStatus?>,
              AsyncValue<FakeServerStatus?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ServerAction)
const serverActionProvider = ServerActionProvider._();

final class ServerActionProvider
    extends $AsyncNotifierProvider<ServerAction, void> {
  const ServerActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverActionHash();

  @$internal
  @override
  ServerAction create() => ServerAction();
}

String _$serverActionHash() => r'85af0c52c8887c58d035c4372fdc1617bf26f426';

abstract class _$ServerAction extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(serverEngine)
const serverEngineProvider = ServerEngineProvider._();

final class ServerEngineProvider
    extends $FunctionalProvider<ServerEngine, ServerEngine, ServerEngine>
    with $Provider<ServerEngine> {
  const ServerEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverEngineHash();

  @$internal
  @override
  $ProviderElement<ServerEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ServerEngine create(Ref ref) {
    return serverEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerEngine>(value),
    );
  }
}

String _$serverEngineHash() => r'6027b6ed0dd9200db69666476c3b14ecc8c28bf8';
