// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiChatSessionV2)
const aiChatSessionV2Provider = AiChatSessionV2Family._();

final class AiChatSessionV2Provider
    extends $AsyncNotifierProvider<AiChatSessionV2, AiChatSessionState> {
  const AiChatSessionV2Provider._({
    required AiChatSessionV2Family super.from,
    required (String, {String? packageName, bool isZh}) super.argument,
  }) : super(
         retry: null,
         name: r'aiChatSessionV2Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiChatSessionV2Hash();

  @override
  String toString() {
    return r'aiChatSessionV2Provider'
        ''
        '$argument';
  }

  @$internal
  @override
  AiChatSessionV2 create() => AiChatSessionV2();

  @override
  bool operator ==(Object other) {
    return other is AiChatSessionV2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiChatSessionV2Hash() => r'86e086aaae6e629656c272ae3ff8c2c7d6027906';

final class AiChatSessionV2Family extends $Family
    with
        $ClassFamilyOverride<
          AiChatSessionV2,
          AsyncValue<AiChatSessionState>,
          AiChatSessionState,
          FutureOr<AiChatSessionState>,
          (String, {String? packageName, bool isZh})
        > {
  const AiChatSessionV2Family._()
    : super(
        retry: null,
        name: r'aiChatSessionV2Provider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AiChatSessionV2Provider call(
    String conversationId, {
    String? packageName,
    bool isZh = true,
  }) => AiChatSessionV2Provider._(
    argument: (conversationId, packageName: packageName, isZh: isZh),
    from: this,
  );

  @override
  String toString() => r'aiChatSessionV2Provider';
}

abstract class _$AiChatSessionV2 extends $AsyncNotifier<AiChatSessionState> {
  late final _$args = ref.$arg as (String, {String? packageName, bool isZh});
  String get conversationId => _$args.$1;
  String? get packageName => _$args.packageName;
  bool get isZh => _$args.isZh;

  FutureOr<AiChatSessionState> build(
    String conversationId, {
    String? packageName,
    bool isZh = true,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      packageName: _$args.packageName,
      isZh: _$args.isZh,
    );
    final ref =
        this.ref as $Ref<AsyncValue<AiChatSessionState>, AiChatSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiChatSessionState>, AiChatSessionState>,
              AsyncValue<AiChatSessionState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
