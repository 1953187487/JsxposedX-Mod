import 'package:JsxposedX/core/models/ai_config.dart';
import 'package:JsxposedX/features/ai/data/models/ai_message_dto.dart';

/// AI API 服务抽象接口
abstract class AiApiService {
  /// 发送流式聊天请求
  Stream<AiMessageDto> sendChatStream({
    required AiConfig config,
    required List<AiMessageDto> messages,
    List<Map<String, dynamic>>? tools,
  });

  /// 测试连接
  Future<String> testConnection(AiConfig config);
}
