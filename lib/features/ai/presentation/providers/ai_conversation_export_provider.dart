import 'package:JsxposedX/features/ai/domain/services/ai_conversation_export_service.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_conversation_export_provider.g.dart';

@riverpod
AiConversationExportService aiConversationExportService(
  Ref ref,
) {
  return AiConversationExportService(ref.watch(aiConversationRepositoryV2Provider));
}
