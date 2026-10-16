import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_controller.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_chat_session_state.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/apk_reverse_ai_environment_provider.dart';

part 'ai_chat_session_provider.g.dart';

@riverpod
class AiChatSessionV2 extends _$AiChatSessionV2 {
  AiChatSessionController? _controller;
  StreamSubscription<AiChatSessionState>? _subscription;

  @override
  Future<AiChatSessionState> build(
    String conversationId, {
    String? packageName,
    bool isZh = true,
  }) async {
    await ref.watch(aiSystemMigrationProvider.future);
    final environment = packageName == null
        ? null
        : (await ref.watch(
            apkReverseAiEnvironmentV2Provider(
              ApkReverseAiEnvironmentKey(packageName: packageName, isZh: isZh),
            ).future,
          )).configuration;
    final controller = AiChatSessionController(
      conversationId: conversationId,
      catalogRepository: ref.read(aiCatalogRepositoryProvider),
      conversationRepository: ref.read(aiConversationRepositoryV2Provider),
      startRun: ref.read(aiChatOrchestratorProvider).start,
      idFactory: const Uuid().v4,
      environment: environment,
    );
    _controller = controller;
    await controller.initialize();
    _subscription = controller.states.listen((next) {
      if (next.conversationId == conversationId) {
        state = AsyncData(next);
      }
    });
    ref.onDispose(() {
      unawaited(_subscription?.cancel());
      unawaited(controller.close());
    });
    return controller.state;
  }

  Future<void> sendText(String text) => _requireController().sendText(text);

  void cancel() => _requireController().cancel();

  Future<void> loadOlderMessages() => _requireController().loadOlderMessages();

  Future<void> retryLastResponse() => _requireController().retryLastResponse();

  Future<void> retryByMessageId(String messageId) =>
      _requireController().retryByMessageId(messageId);

  Future<void> regenerateLastResponse() =>
      _requireController().regenerateLastResponse();

  Future<void> deleteMessage(String messageId) =>
      _requireController().deleteMessage(messageId);

  Future<void> clearAssistantResponse(String messageId) =>
      _requireController().clearAssistantResponse(messageId);

  Future<void> continueGeneration(String messageId) =>
      _requireController().continueGeneration(messageId);

  AiChatSessionController _requireController() {
    final controller = _controller;
    if (controller == null) {
      throw StateError('AI chat session is not initialized');
    }
    return controller;
  }
}
