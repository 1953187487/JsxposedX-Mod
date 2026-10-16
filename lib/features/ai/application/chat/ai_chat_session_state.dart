import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/ai/application/chat/ai_stream_snapshot.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

part 'ai_chat_session_state.freezed.dart';

enum AiChatSessionPhase {
  loading,
  ready,
  requesting,
  streaming,
  cancelling,
  failed,
  awaitingToolApproval,
  awaitingUserAnswer,
}

@freezed
abstract class AiChatSessionState with _$AiChatSessionState {
  const AiChatSessionState._();

  const factory AiChatSessionState({
    required String conversationId,
    AiConversation? conversation,
    AiAssistantProfile? assistant,
    AiProviderConnection? connection,
    AiModelDefinition? model,
    @Default(<AiMessage>[]) List<AiMessage> messages,
    @Default(AiChatSessionPhase.loading) AiChatSessionPhase phase,
    @Default(false) bool hasOlderMessages,
    @Default(false) bool isLoadingOlderMessages,
    String? activeRequestId,
    String? activeAssistantMessageId,
    AiStreamSnapshot? runSnapshot,
    AiFailure? failure,
  }) = _AiChatSessionState;

  bool get hasActiveRun => activeRequestId != null;

  bool get canSend =>
      (phase == AiChatSessionPhase.ready ||
          phase == AiChatSessionPhase.failed) &&
      conversation != null &&
      assistant != null &&
      connection != null &&
      model != null;

  bool get isAwaitingToolApproval =>
      phase == AiChatSessionPhase.awaitingToolApproval;

  bool get isAwaitingUserAnswer =>
      phase == AiChatSessionPhase.awaitingUserAnswer;
}
