import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';
import 'package:JsxposedX/features/ai/domain/repositories/ai_conversation_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// AI 会话导出服务
class AiConversationExportService {
  final AiConversationRepository _conversationRepo;

  AiConversationExportService(this._conversationRepo);

  /// 导出会话为 Markdown
  Future<String> exportToMarkdown({
    required String conversationId,
    bool includeToolCalls = false,
  }) async {
    // 使用新的 Drift 数据库查询所有消息（不限制数量）
    final messages = await _conversationRepo.getMessages(conversationId, limit: 999999);
    final conversation = await _conversationRepo.getConversation(conversationId);

    final buffer = StringBuffer();
    buffer.writeln('# ${conversation?.title ?? '未命名会话'}');
    buffer.writeln();
    buffer.writeln('**会话 ID**: $conversationId');
    if (conversation != null) {
      buffer.writeln('**最后更新**: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(conversation.updatedAt)}');
    }
    buffer.writeln('**消息数量**: ${messages.length}');
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln();

    for (final message in messages) {
      _writeMessageToMarkdown(buffer, message, includeToolCalls);
    }

    return buffer.toString();
  }

  /// 导出会话为 JSON
  Future<String> exportToJson({
    required String conversationId,
    bool includeToolCalls = true,
  }) async {
    // 使用新的 Drift 数据库查询所有消息（不限制数量）
    final messages = await _conversationRepo.getMessages(conversationId, limit: 999999);
    final conversation = await _conversationRepo.getConversation(conversationId);

    final data = {
      'conversation': {
        'id': conversationId,
        'title': conversation?.title ?? '未命名会话',
        if (conversation != null) 'updatedAt': conversation.updatedAt.toIso8601String(),
      },
      'messages': messages.map((msg) => _messageToJson(msg, includeToolCalls)).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// 保存导出内容到用户选择的位置
  Future<File?> saveExportWithPicker({
    required String content,
    required String suggestedFileName,
  }) async {
    try {
      // 清理文件名，移除非法字符
      final cleanFileName = suggestedFileName
          .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
          .replaceAll(RegExp(r'\s+'), '_');

      // 将内容转为字节
      final Uint8List bytes = Uint8List.fromList(utf8.encode(content));

      // 使用系统文件选择器让用户选择保存位置
      String? result = await FilePicker.platform.saveFile(
        dialogTitle: '保存会话导出',
        fileName: cleanFileName,
        type: FileType.any,
        bytes: bytes, // Android/iOS 需要传入字节
      );

      if (result == null || result.isEmpty) {
        // 用户取消了
        return null;
      }

      // 返回保存的文件
      return File(result);
    } catch (e) {
      rethrow;
    }
  }

  /// 保存导出内容到文件（旧方法，保留用于工具调用）
  @Deprecated('请改用 saveExportWithPicker，让用户选择保存位置。')
  Future<File> saveExport({
    required String content,
    required String fileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/ai_exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final file = File('${exportDir.path}/$fileName');
    await file.writeAsString(content, flush: true);
    return file;
  }

  void _writeMessageToMarkdown(
    StringBuffer buffer,
    AiMessage message,
    bool includeToolCalls,
  ) {
    // 角色标题
    String roleTitle;
    switch (message.role) {
      case AiMessageRole.user:
        roleTitle = '👤 用户';
        break;
      case AiMessageRole.assistant:
        roleTitle = '🤖 助手';
        break;
      case AiMessageRole.system:
        roleTitle = '⚙️ 系统';
        break;
      case AiMessageRole.tool:
        roleTitle = '🔧 工具';
        break;
    }

    buffer.writeln('## $roleTitle');
    buffer.writeln();

    // 主要内容 - 遍历所有 parts
    for (final part in message.parts) {
      part.when(
        text: (text) {
          if (text.isNotEmpty) {
            buffer.writeln(text);
            buffer.writeln();
          }
        },
        reasoning: (text) {
          if (text.isNotEmpty) {
            buffer.writeln('**思考过程**:');
            buffer.writeln('```');
            buffer.writeln(text);
            buffer.writeln('```');
            buffer.writeln();
          }
        },
        image: (attachmentId) {
          buffer.writeln('**图片**: $attachmentId');
          buffer.writeln();
        },
        toolCall: (toolCall) {
          if (includeToolCalls) {
            buffer.writeln('**工具调用**: ${toolCall.name}');
            if (toolCall.arguments.isNotEmpty) {
              buffer.writeln('```json');
              buffer.writeln(const JsonEncoder.withIndent('  ').convert(toolCall.arguments));
              buffer.writeln('```');
            }
            buffer.writeln();
          }
        },
        toolResult: (toolResult) {
          buffer.writeln('**工具结果**: ${toolResult.toolCallId}');
          if (toolResult.content.isNotEmpty) {
            buffer.writeln('```');
            buffer.writeln(toolResult.content);
            buffer.writeln('```');
          }
          if (!toolResult.success) {
            buffer.writeln('> ⚠️ 此工具调用失败');
          }
          buffer.writeln();
        },
      );
    }

    buffer.writeln('---');
    buffer.writeln();
  }

  Map<String, dynamic> _messageToJson(AiMessage message, bool includeToolCalls) {
    final json = <String, dynamic>{
      'id': message.id,
      'conversationId': message.conversationId,
      'role': message.role.name,
      'createdAt': message.createdAt.toIso8601String(),
      'parts': message.parts.map((part) {
        return part.when(
          text: (text) => {'type': 'text', 'text': text},
          reasoning: (text) => {'type': 'reasoning', 'text': text},
          image: (attachmentId) => {'type': 'image', 'attachmentId': attachmentId},
          toolCall: (toolCall) => includeToolCalls
              ? {
                  'type': 'toolCall',
                  'id': toolCall.id,
                  'name': toolCall.name,
                  'arguments': toolCall.arguments,
                }
              : {},
          toolResult: (toolResult) => {
            'type': 'toolResult',
            'toolCallId': toolResult.toolCallId,
            'content': toolResult.content,
            'success': toolResult.success,
          },
        );
      }).toList(),
    };

    if (message.parentId != null) {
      json['parentId'] = message.parentId;
    }

    if (message.completedAt != null) {
      json['completedAt'] = message.completedAt!.toIso8601String();
    }

    return json;
  }
}
