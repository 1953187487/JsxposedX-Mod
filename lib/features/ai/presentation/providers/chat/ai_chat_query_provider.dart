import 'package:JsxposedX/core/providers/pinia_provider.dart';
import 'package:JsxposedX/features/ai/data/datasources/chat/ai_chat_query_datasource.dart';
import 'package:JsxposedX/features/ai/data/repositories/chat/ai_chat_query_repository_impl.dart';
import 'package:JsxposedX/features/ai/domain/repositories/chat/ai_chat_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_chat_query_provider.g.dart';

@riverpod
AiChatQueryDatasource aiChatQueryDatasource(Ref ref) {
  final PiniaStorage storage = ref.watch(piniaStorageLocalProvider);
  return AiChatQueryDatasource(storage: storage);
}

@riverpod
AiChatQueryRepository aiChatQueryRepository(Ref ref) {
  final dataSource = ref.watch(aiChatQueryDatasourceProvider);
  return AiChatQueryRepositoryImpl(dataSource: dataSource);
}
