import 'dart:convert';
import 'dart:io';

import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:JsxposedX/generated/shell.g.dart';

/// 通用文件查看器。
///
/// 支持查看文本与图片：优先用 `dart:io` 直接读取应用可访问的路径；
/// 若越权（如 `/data/data/...`）则回退到 root shell 读取（图片走 base64）。
class FileViewerPage extends HookWidget {
  const FileViewerPage({super.key, required this.path, this.title});

  final String path;
  final String? title;

  bool get _isImage {
    final lower = path.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
  }

  @override
  Widget build(BuildContext context) {
    final bytes = useState<Uint8List?>(null);
    final text = useState<String?>(null);
    final error = useState<String?>(null);
    final loading = useState(true);

    useEffect(() {
      var cancelled = false;
      Future<void> load() async {
        loading.value = true;
        error.value = null;
        try {
          final file = File(path);
          final exists = await file.exists();
          Uint8List? data;
          if (exists) {
            data = await file.readAsBytes();
          } else {
            // 回退到 root shell：图片用 base64，文本直接 cat
            final native = ShellNative();
            if (_isImage) {
              final result = await native.executeShell(
                'base64 "$path"',
                true,
                30,
              );
              if (result.exitCode != 0 || result.stdout.trim().isEmpty) {
                throw StateError(
                  result.stderr.trim().isNotEmpty
                      ? result.stderr.trim()
                      : 'file not found',
                );
              }
              data = base64Decode(result.stdout.replaceAll(RegExp(r'\s'), ''));
            } else {
              final result = await native.executeShell(
                'cat "$path"',
                true,
                30,
              );
              if (result.exitCode != 0) {
                throw StateError(
                  result.stderr.trim().isNotEmpty
                      ? result.stderr.trim()
                      : 'file not found',
                );
              }
              data = Uint8List.fromList(utf8.encode(result.stdout));
            }
          }
          if (cancelled) return;
          if (_isImage) {
            bytes.value = data;
          } else {
            text.value = utf8.decode(data, allowMalformed: true);
          }
        } catch (e) {
          if (!cancelled) error.value = e.toString();
        } finally {
          if (!cancelled) loading.value = false;
        }
      }

      load();
      return () => cancelled = true;
    }, [path]);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? path.split('/').last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              path,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontFamily: 'monospace',
                color: context.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: context.isZh ? '复制路径' : 'Copy path',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: path));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.isZh ? '路径已复制' : 'Path copied'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
      body: _buildBody(context, loading.value, error.value, bytes.value, text.value),
    );
  }

  Widget _buildBody(
    BuildContext context,
    bool loading,
    String? error,
    Uint8List? bytes,
    String? text,
  ) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 40.sp, color: Colors.redAccent),
              SizedBox(height: 12.h),
              Text(
                context.isZh ? '无法读取文件' : 'Cannot read file',
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 8.h),
              SelectableText(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontFamily: 'monospace',
                  color: context.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (bytes != null && bytes.isNotEmpty) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 6,
        child: Center(child: Image.memory(bytes, fit: BoxFit.contain)),
      );
    }
    if (text != null) {
      return _TextFileView(content: text);
    }
    return Center(
      child: Text(context.isZh ? '空文件' : 'Empty file'),
    );
  }
}

class _TextFileView extends StatelessWidget {
  const _TextFileView({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12.w),
      child: SelectableText(
        content,
        style: TextStyle(
          fontSize: 12.sp,
          height: 1.5,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
