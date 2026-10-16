import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// AI 工具产物的本地文件存储。
///
/// 统一把截图、UI dump、导出报告、笔记、APK 资源等产物落到
/// `<应用文档目录>/ai_tool_outputs/<类别>/...`，避免各 handler 各写一套路径逻辑。
/// 该目录位于应用私有空间，读写无需 root。
class AiToolFileStore {
  AiToolFileStore._();

  static const _rootName = 'ai_tool_outputs';

  /// 输出根目录（不存在则创建）。
  static Future<Directory> _root() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/$_rootName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// 清理文件名中的非法字符，保留可读性。
  static String sanitizeFileName(String name) {
    final cleaned = name
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
    return cleaned.isEmpty ? 'untitled' : cleaned;
  }

  static Future<File> _writeBytes({
    required String category,
    required String fileName,
    required List<int> bytes,
  }) async {
    final root = await _root();
    final dir = Directory('${root.path}/$category');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File('${dir.path}/${sanitizeFileName(fileName)}');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// 写入文本产物，返回文件。
  static Future<File> writeText({
    required String category,
    required String fileName,
    required String content,
  }) {
    return _writeBytes(
      category: category,
      fileName: fileName,
      bytes: utf8.encode(content),
    );
  }

  /// 写入二进制产物，返回文件。
  static Future<File> writeBytes({
    required String category,
    required String fileName,
    required Uint8List bytes,
  }) {
    return _writeBytes(category: category, fileName: fileName, bytes: bytes);
  }

  /// 生成带时间戳的文件名，如 `shot_20260926_153012.png`。
  static String timestamped(String prefix, String extension) {
    final now = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    final stamp =
        '${now.year}${two(now.month)}${two(now.day)}_'
        '${two(now.hour)}${two(now.minute)}${two(now.second)}';
    return '${prefix}_$stamp.$extension';
  }

  /// 预创建某类别目录并返回目标文件的绝对路径（供 root shell 直接写入）。
  static Future<String> preparePath({
    required String category,
    required String fileName,
  }) async {
    final root = await _root();
    final dir = Directory('${root.path}/$category');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return '${dir.path}/${sanitizeFileName(fileName)}';
  }

  /// 读取文件字节（不存在返回 null）。
  static Future<Uint8List?> readBytes(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }
}
