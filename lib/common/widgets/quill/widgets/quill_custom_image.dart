import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

/// 自定义图片嵌入 Builder（处理 custom_image 类型）
class QuillCustomImage extends quill.EmbedBuilder {
  @override
  String get key => 'custom_image';

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    try {
      final data = embedContext.node.value.data;
      final Map<String, dynamic> imageData = jsonDecode(data);
      final imageUrl = imageData['url'] as String?;

      if (imageUrl == null || imageUrl.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.broken_image, size: 48)),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('解析 custom_image 失败: $e');
      return const SizedBox.shrink();
    }
  }
}

List<quill.EmbedBuilder> quillCustomImages = FlutterQuillEmbeds.editorBuilders(
  imageEmbedConfig: QuillEditorImageEmbedConfig(
    imageProviderBuilder: (context, imageUrl) {
      debugPrint('🖼️ 加载图片: $imageUrl');
      return CachedNetworkImageProvider(imageUrl);
    },
    imageErrorWidgetBuilder: (imgContext, error, stackTrace) {
      debugPrint('❌ 图片加载失败: $error');
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.broken_image, size: 48),
              const SizedBox(height: 8),
              Text(
                '图片加载失败\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    },
    onImageClicked: (imageUrl) {
      debugPrint('👆 点击图片: $imageUrl');
    },
  ),
);
