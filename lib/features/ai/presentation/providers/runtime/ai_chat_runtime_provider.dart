import 'package:JsxposedX/features/ai/presentation/providers/chat/ai_chat_action_provider.dart';
import 'package:JsxposedX/features/ai/infrastructure/services/ai_analysis_query_service.dart';
import 'package:JsxposedX/features/ai/presentation/providers/system/ai_system_providers.dart';
import 'package:riverpod/riverpod.dart';

final aiChatRuntimeQueryProvider = Provider<AiAnalysisQueryService>(
  (ref) => AiAnalysisQueryService(ref.watch(aiDioProvider)),
);
final aiChatRuntimeStatusProvider = aiStatusProvider;
final aiChatRuntimeProvider = aiChatActionProvider;
