part of 'ai_api.dart';

/// 对话子模块路径定义
class ChatApi {
  ChatApi._();

  /// 对话补全路径
  String get completions => "${ApiConfig.prefixV1}/chat/completions";
}
