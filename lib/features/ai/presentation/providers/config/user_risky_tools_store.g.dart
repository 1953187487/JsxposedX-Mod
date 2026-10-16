// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_risky_tools_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 持久化用户对每个工具的明确危险判定（configId -> {toolName: isRisky}）。
/// 用户的选择完全覆盖 AiToolDefinition.isRisky 的系统默认值：
/// - 未配置（key 缺失）→ 使用系统默认；
/// - 配置为 true / false → 以用户为准。
/// 这样保证任何工具（包括系统默认危险的工具）的开关都能独立开/关。

@ProviderFor(UserRiskyToolsStore)
const userRiskyToolsStoreProvider = UserRiskyToolsStoreProvider._();

/// 持久化用户对每个工具的明确危险判定（configId -> {toolName: isRisky}）。
/// 用户的选择完全覆盖 AiToolDefinition.isRisky 的系统默认值：
/// - 未配置（key 缺失）→ 使用系统默认；
/// - 配置为 true / false → 以用户为准。
/// 这样保证任何工具（包括系统默认危险的工具）的开关都能独立开/关。
final class UserRiskyToolsStoreProvider
    extends
        $NotifierProvider<UserRiskyToolsStore, Map<String, Map<String, bool>>> {
  /// 持久化用户对每个工具的明确危险判定（configId -> {toolName: isRisky}）。
  /// 用户的选择完全覆盖 AiToolDefinition.isRisky 的系统默认值：
  /// - 未配置（key 缺失）→ 使用系统默认；
  /// - 配置为 true / false → 以用户为准。
  /// 这样保证任何工具（包括系统默认危险的工具）的开关都能独立开/关。
  const UserRiskyToolsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRiskyToolsStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRiskyToolsStoreHash();

  @$internal
  @override
  UserRiskyToolsStore create() => UserRiskyToolsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Map<String, bool>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Map<String, bool>>>(
        value,
      ),
    );
  }
}

String _$userRiskyToolsStoreHash() =>
    r'b232446b6a0f3098c8ebff0944cc421ca57d02b8';

/// 持久化用户对每个工具的明确危险判定（configId -> {toolName: isRisky}）。
/// 用户的选择完全覆盖 AiToolDefinition.isRisky 的系统默认值：
/// - 未配置（key 缺失）→ 使用系统默认；
/// - 配置为 true / false → 以用户为准。
/// 这样保证任何工具（包括系统默认危险的工具）的开关都能独立开/关。

abstract class _$UserRiskyToolsStore
    extends $Notifier<Map<String, Map<String, bool>>> {
  Map<String, Map<String, bool>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              Map<String, Map<String, bool>>,
              Map<String, Map<String, bool>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, Map<String, bool>>,
                Map<String, Map<String, bool>>
              >,
              Map<String, Map<String, bool>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
