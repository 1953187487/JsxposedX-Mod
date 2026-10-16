// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_conversation_export_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiConversationExportService)
const aiConversationExportServiceProvider =
    AiConversationExportServiceProvider._();

final class AiConversationExportServiceProvider
    extends
        $FunctionalProvider<
          AiConversationExportService,
          AiConversationExportService,
          AiConversationExportService
        >
    with $Provider<AiConversationExportService> {
  const AiConversationExportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiConversationExportServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiConversationExportServiceHash();

  @$internal
  @override
  $ProviderElement<AiConversationExportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiConversationExportService create(Ref ref) {
    return aiConversationExportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiConversationExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiConversationExportService>(value),
    );
  }
}

String _$aiConversationExportServiceHash() =>
    r'b2941117420d34c78cd228d5d08694fca11a9662';
