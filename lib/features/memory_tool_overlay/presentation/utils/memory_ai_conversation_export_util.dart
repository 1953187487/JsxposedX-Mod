import 'dart:io';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/features/ai/presentation/providers/ai_conversation_export_provider.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_host_runtime_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;

/// 悬浮窗内的 AI 会话导出。
///
/// 宿主用的是 `saveExportWithPicker`（FilePicker + 分享），在悬浮窗独立引擎里
/// 不可用，因此这里自己写一份：复用 [AiConversationExportService] 的纯文本生成
/// 逻辑，再直接写入公共 Download 目录，配合悬浮窗自有的 toast 反馈。
Future<File?> exportOverlayAiConversation({
  required BuildContext context,
  required WidgetRef ref,
  required String conversationId,
  required String conversationTitle,
  required bool isMarkdown,
}) async {
  try {
    final service = ref.read(aiConversationExportServiceProvider);
    final content = isMarkdown
        ? await service.exportToMarkdown(conversationId: conversationId)
        : await service.exportToJson(conversationId: conversationId);

    final safeTitle = _sanitizeFileName(conversationTitle);
    final extension = isMarkdown ? 'md' : 'json';
    final fileName =
        'chat_${safeTitle}_${DateTime.now().millisecondsSinceEpoch}.$extension';

    final candidateDirectories = <Directory>[
      if (Platform.isAndroid)
        Directory('/storage/emulated/0/Download/JsxposedX/exports/ai_chat'),
      Directory(
        p.join(
          Directory.systemTemp.path,
          'JsxposedX',
          'exports',
          'ai_chat',
        ),
      ),
    ];

    File? exportFile;
    Object? lastError;
    for (final directory in candidateDirectories) {
      try {
        await directory.create(recursive: true);
        final candidateFile = File(p.join(directory.path, fileName));
        await candidateFile.writeAsString(content, flush: true);
        exportFile = candidateFile;
        break;
      } catch (error) {
        lastError = error;
      }
    }

    if (exportFile == null) {
      throw lastError ??
          (context.isZh ? '没有可用的导出目录' : 'No writable export directory');
    }

    ref.read(overlayWindowHostRuntimeProvider.notifier).showToast(
      context.isZh
          ? '已导出到: ${_formatDisplayPath(context, exportFile.path)}'
          : 'Exported to: ${_formatDisplayPath(context, exportFile.path)}',
      durationMs: 2600,
    );
    return exportFile;
  } catch (_) {
    ref.read(overlayWindowHostRuntimeProvider.notifier).showToast(
      context.isZh ? '导出失败' : 'Export failed',
      durationMs: 1800,
    );
    return null;
  }
}

String _sanitizeFileName(String name) {
  final normalized = name
      .trim()
      .replaceAll(RegExp(r'[\\/:*?"<>|\s]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  if (normalized.isEmpty) {
    return 'conversation';
  }
  return normalized.length > 40 ? normalized.substring(0, 40) : normalized;
}

String _formatDisplayPath(BuildContext context, String path) {
  if (path.startsWith('/storage/emulated/0')) {
    return path.replaceFirst(
      '/storage/emulated/0',
      context.isZh ? '手机存储' : 'Internal storage',
    );
  }
  return path;
}
