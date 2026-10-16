import 'package:JsxposedX/features/ai/domain/contracts/ai_chat_tool_handler.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_file_store.dart';
import 'package:JsxposedX/features/ai/domain/environments/ai_tool_runtime_context.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_tool_call.dart';

// ═══ 基类 ═══

abstract class ContentProductionHandler implements AiChatToolHandler {
  const ContentProductionHandler(this.context);

  final ApkReverseToolRuntimeContext context;

  String get _pkg => context.packageName;

  bool get _isZh => context.isZh;
}

// ═══ B1. export_conversation（P1） ═══

class ExportConversationHandler extends ContentProductionHandler {
  const ExportConversationHandler(super.context);

  @override
  String get toolName => 'export_conversation';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final format = call.getString('format', 'markdown');
    final includeToolCalls = call.getBool('include_tool_calls', true);
    final customFileName = call.getString('fileName', '');

    final conversationId = context.conversationBinding.conversationId;
    if (conversationId == null || conversationId.isEmpty) {
      return _isZh ? '无法导出：未找到当前会话 ID' : 'Cannot export: No current session ID';
    }

    final packageName = context.packageName;
    if (packageName.isEmpty) {
      return _isZh ? '无法导出：未找到包名' : 'Cannot export: Package name not found';
    }

    try {
      final exportService = context.exportService;
      if (exportService == null) {
        return _isZh
            ? '导出服务未初始化，请使用聊天界面右上角的导出按钮'
            : 'Export service not initialized. Please use the export button in the chat UI';
      }

      late String content;
      late String fileName;

      if (format == 'json') {
        content = await exportService.exportToJson(
          conversationId: conversationId,
          includeToolCalls: includeToolCalls,
        );
        fileName = customFileName.isNotEmpty
            ? customFileName
            : 'conversation_${DateTime.now().millisecondsSinceEpoch}.json';
      } else {
        content = await exportService.exportToMarkdown(
          conversationId: conversationId,
          includeToolCalls: includeToolCalls,
        );
        fileName = customFileName.isNotEmpty
            ? customFileName
            : 'conversation_${DateTime.now().millisecondsSinceEpoch}.md';
      }

      final file = await exportService.saveExport(
        content: content,
        fileName: fileName,
      );

      return _isZh
          ? '会话已导出到: ${file.path}\n格式: ${format == "markdown" ? "Markdown" : "JSON"}\n文件大小: ${(content.length / 1024).toStringAsFixed(2)} KB'
          : 'Conversation exported to: ${file.path}\nFormat: ${format == "markdown" ? "Markdown" : "JSON"}\nFile size: ${(content.length / 1024).toStringAsFixed(2)} KB';
    } catch (e) {
      return _isZh ? '导出失败: $e' : 'Export failed: $e';
    }
  }
}

// ═══ B2. generate_analysis_report（P2） ═══

class GenerateAnalysisReportHandler extends ContentProductionHandler {
  const GenerateAnalysisReportHandler(super.context);

  @override
  String get toolName => 'generate_analysis_report';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final exportService = context.exportService;
    if (exportService == null) {
      return _isZh
          ? '报告生成失败：导出服务未初始化'
          : 'Report generation failed: export service not initialized';
    }

    final conversationId = context.conversationBinding.conversationId;
    if (conversationId == null || conversationId.isEmpty) {
      return _isZh ? '报告生成失败：未找到当前会话 ID' : 'Report generation failed: no session ID';
    }

    final format = call.getString('format', 'preview');
    final sections = call.getStringList('sections');
    if (sections.isNotEmpty) {
      onProgress?.call(
        _isZh
            ? '提示：sections 过滤暂未生效，将导出完整会话内容'
            : 'Note: sections filter not applied yet; exporting full conversation',
      );
    }

    try {
      final markdown = await exportService.exportToMarkdown(
        conversationId: conversationId,
        includeToolCalls: true,
      );
      final header = StringBuffer()
        ..writeln('# 逆向分析报告')
        ..writeln()
        ..writeln('- **目标应用**: ${_pkg.isEmpty ? "未知" : _pkg}')
        ..writeln('- **生成时间**: ${DateTime.now().toIso8601String()}')
        ..writeln()
        ..writeln('---')
        ..writeln();
      final content = '$header$markdown';

      if (format == 'save') {
        final fileName = AiToolFileStore.timestamped(
          'report_${_pkg.isEmpty ? "app" : _pkg}',
          'md',
        );
        final file = await AiToolFileStore.writeText(
          category: 'reports',
          fileName: fileName,
          content: content,
        );
        return _isZh
            ? '分析报告已保存到: ${file.path}\n文件大小: ${(content.length / 1024).toStringAsFixed(2)} KB'
            : 'Report saved to: ${file.path}\nFile size: ${(content.length / 1024).toStringAsFixed(2)} KB';
      }

      return _isZh
          ? '以下是会话汇总的分析报告内容（可用 format=save 落盘）：\n\n$content'
          : 'Analysis report content (use format=save to persist):\n\n$content';
    } catch (e) {
      return _isZh ? '报告生成失败: $e' : 'Report generation failed: $e';
    }
  }
}

// ═══ B3. save_note（P2） ═══

class SaveNoteHandler extends ContentProductionHandler {
  const SaveNoteHandler(super.context);

  @override
  String get toolName => 'save_note';

  @override
  Future<String> handle(
    AiToolCall call, {
    AiToolProgressCallback? onProgress,
  }) async {
    final title = call.getString('title').trim();
    final content = call.getString('content');

    if (title.isEmpty) throw ArgumentError('title 不能为空');
    if (content.isEmpty) throw ArgumentError('content 不能为空');

    // 标题非法字符校验（sanitize 会兜底，这里显式提示用户）
    if (RegExp(r'[/\\:*?"<>|]').hasMatch(title)) {
      throw ArgumentError(
        _isZh ? '标题含非法字符 / Title contains invalid characters' : 'Title contains invalid characters',
      );
    }

    final pkg = _pkg.isEmpty ? 'unknown' : _pkg;
    final fileName = AiToolFileStore.sanitizeFileName('${pkg}_$title.md');
    final body = StringBuffer()
      ..writeln('# $title')
      ..writeln()
      ..writeln('- **目标应用**: $pkg')
      ..writeln('- **记录时间**: ${DateTime.now().toIso8601String()}')
      ..writeln()
      ..writeln('---')
      ..writeln()
      ..writeln(content);

    final file = await AiToolFileStore.writeText(
      category: 'notes',
      fileName: fileName,
      content: body.toString(),
    );

    return _isZh
        ? '笔记已保存到: ${file.path}'
        : 'Note saved to: ${file.path}';
  }
}