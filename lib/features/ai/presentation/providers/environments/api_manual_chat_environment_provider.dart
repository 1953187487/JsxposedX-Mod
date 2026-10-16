import 'package:JsxposedX/features/ai/domain/environments/api_manual_chat_environment_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_manual_chat_environment_provider.g.dart';

class ApiManualChatEnvironmentArgs {
  const ApiManualChatEnvironmentArgs({
    required this.scopeId,
    required this.systemPrompt,
  });

  final String scopeId;
  final String systemPrompt;

  @override
  bool operator ==(Object other) {
    return other is ApiManualChatEnvironmentArgs &&
        other.scopeId == scopeId &&
        other.systemPrompt == systemPrompt;
  }

  @override
  int get hashCode => Object.hash(scopeId, systemPrompt);
}

@riverpod
ApiManualChatEnvironmentAdapter apiManualChatEnvironment(
  Ref ref,
  ApiManualChatEnvironmentArgs args,
) {
  return ApiManualChatEnvironmentAdapter(
    scopeId: args.scopeId,
    systemPrompt: args.systemPrompt,
  );
}
