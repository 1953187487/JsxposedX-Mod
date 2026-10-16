import 'dart:convert';

import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class QuillCustomCarousel extends quill.EmbedBuilder {
  @override
  String get key => 'custom_carousel';

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    final data = embedContext.node.value.data;
    final Map<String, dynamic> carouselData = jsonDecode(data);

    final List<String> imgs = List<String>.from(carouselData['imgs'] ?? []);
    final itemCount = imgs.length >= 3 ? 3 : imgs.length;
    final Axis scrollDirection = carouselData['scroll_direction'] == 'vertical'
        ? Axis.vertical
        : Axis.horizontal;
    final height =
        double.tryParse(carouselData["height"]?.toString() ?? '') ?? 300;
    final aspectRatio =
        (carouselData["aspect_radio"] as num?)?.toDouble() ?? 16 / 9;
    final itemHeight = height > 600 ? 600.0 : height;

    if (itemCount == 0) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('暂无图片')),
      );
    }

    if (scrollDirection == Axis.horizontal) {
      return SizedBox(
        height: itemHeight,
        child: PageView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CacheImage(imageUrl: imgs[index], fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CacheImage(imageUrl: imgs[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
