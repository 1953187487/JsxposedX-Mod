// lib/core/utils/file_picker_util.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class FilePickerUtil {
  FilePickerUtil._();

  static const MethodChannel _overlayPickerChannel = MethodChannel(
    'com.jsxposed.xmod/file_picker_proxy',
  );

  /// 选择图片并返回字节数据
  static Future<PickedFileData?> pickImage({
    bool useOverlayProxy = false,
  }) async {
    if (useOverlayProxy && Platform.isAndroid) {
      return _pickWithOverlayProxy(method: 'pickImage');
    }
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    return _pickedFileFromResult(result);
  }

  /// 选择任意类型文件
  static Future<PickedFileData?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool useOverlayProxy = false,
  }) async {
    if (useOverlayProxy && Platform.isAndroid) {
      return _pickWithOverlayProxy(
        method: 'pickFile',
        arguments: {'allowedExtensions': allowedExtensions},
      );
    }
    final result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
      allowMultiple: false,
    );
    return _pickedFileFromResult(result);
  }

  /// 选择多个文件
  static Future<List<PickedFileData>> pickMultipleFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return [];

    final List<PickedFileData> pickedFiles = [];

    for (final file in result.files) {
      Uint8List? bytes;

      if (file.bytes != null) {
        bytes = file.bytes;
      } else if (file.path != null) {
        final fileData = File(file.path!);
        bytes = await fileData.readAsBytes();
      }

      if (bytes != null) {
        pickedFiles.add(
          PickedFileData(
            bytes: bytes,
            fileName: file.name,
            path: file.path,
            size: file.size,
            extension: file.extension,
          ),
        );
      }
    }

    return pickedFiles;
  }

  static Future<PickedFileData?> pickApk() async {
    return pickFile(type: FileType.custom, allowedExtensions: ['apk']);
  }

  /// 通过悬浮窗代理保存文件。悬浮窗是独立引擎，`FilePicker.platform.saveFile`
  /// 依赖宿主 Activity，故改走原生 SAF 代理。
  ///
  /// 返回保存后的展示路径（URI 或文件名），用户取消或失败时返回 null。
  static Future<String?> saveFileWithOverlayProxy({
    required String fileName,
    required Uint8List bytes,
  }) async {
    return _overlayPickerChannel.invokeMethod<String>('saveFile', {
      'name': fileName,
      'bytes': bytes,
    });
  }

  static Future<PickedFileData?> _pickWithOverlayProxy({
    required String method,
    Map<String, Object?>? arguments,
  }) async {
    final raw = await _overlayPickerChannel.invokeMapMethod<String, dynamic>(
      method,
      arguments,
    );
    if (raw == null) {
      return null;
    }

    final bytes = raw['bytes'];
    if (bytes is! Uint8List) {
      throw StateError('Overlay picker returned invalid bytes payload.');
    }

    final fileName = (raw['name'] as String?)?.trim();
    final path = raw['path'] as String?;
    return PickedFileData(
      bytes: bytes,
      fileName: (fileName == null || fileName.isEmpty) ? 'unknown' : fileName,
      path: path,
      size: (raw['size'] as num?)?.toInt() ?? bytes.length,
      extension:
          (raw['extension'] as String?) ??
          _extensionFromName(fileName ?? path),
    );
  }

  static Future<PickedFileData?> _pickedFileFromResult(
    FilePickerResult? result,
  ) async {
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.first;
    Uint8List? bytes;

    if (file.bytes != null) {
      bytes = file.bytes;
    } else if (file.path != null) {
      final fileData = File(file.path!);
      bytes = await fileData.readAsBytes();
    }

    if (bytes == null) {
      return null;
    }

    return PickedFileData(
      bytes: bytes,
      fileName: file.name,
      path: file.path,
      size: file.size,
      extension: file.extension ?? _extensionFromName(file.name),
    );
  }

  static String? _extensionFromName(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final index = value.lastIndexOf('.');
    if (index < 0 || index >= value.length - 1) {
      return null;
    }
    return value.substring(index + 1).toLowerCase();
  }
}

/// 选中的文件数据
class PickedFileData {
  final Uint8List bytes;
  final String fileName;
  final String? path;
  final int size;
  final String? extension;

  PickedFileData({
    required this.bytes,
    required this.fileName,
    this.path,
    required this.size,
    this.extension,
  });

  /// 文件大小（格式化）
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(2)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  String toString() {
    return 'PickedFileData{fileName: $fileName, size: $size, extension: $extension}';
  }
}
