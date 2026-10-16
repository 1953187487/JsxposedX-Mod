import 'dart:typed_data';

import 'package:JsxposedX/common/widgets/loading.dart';
import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 智能图片组件
/// 自动判断图片来源，使用对应加载方式
class CacheImage extends StatelessWidget {
  static const int _maxCacheDimension = 4096;

  final String? imageUrl;
  final Uint8List? imageBytes;
  final double? size;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool isProfile;
  final bool isMemory;
  final BaseCacheManager? cacheManager;
  final bool canMagnified;

  const CacheImage({
    super.key,
    required String this.imageUrl,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheManager,
    this.canMagnified = false,
  }) : isProfile = false,
       isMemory = false,
       imageBytes = null;

  const CacheImage.profile({
    super.key,
    required String this.imageUrl,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheManager,
    this.canMagnified = false,
  }) : isProfile = true,
       isMemory = false,
       imageBytes = null;

  const CacheImage.memory({
    super.key,
    required Uint8List this.imageBytes,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.canMagnified = false,
  }) : isProfile = false,
       isMemory = true,
       imageUrl = null,
       cacheManager = null;

  /// 获取 ImageProvider
  /// 根据 URL 类型返回对应的 ImageProvider
  ImageProvider getImageProvider([String? url]) {
    // 内存图片
    if (isMemory && imageBytes != null && imageBytes!.isNotEmpty) {
      return MemoryImage(imageBytes!);
    }

    final targetUrl = url ?? imageUrl ?? '';
    if (_isValidNetworkUrl(targetUrl)) {
      return CachedNetworkImageProvider(
        targetUrl,
        errorListener: (error) {},
        cacheManager: cacheManager,
      );
    } else if (targetUrl.startsWith('assets/')) {
      return AssetImage(targetUrl);
    } else {
      return const AssetImage(AssetsConstants.logo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    int? cacheDimension(double? logicalDimension) {
      if (logicalDimension == null ||
          !logicalDimension.isFinite ||
          logicalDimension <= 0 ||
          !devicePixelRatio.isFinite ||
          devicePixelRatio <= 0) {
        return null;
      }
      final physicalDimension = logicalDimension * devicePixelRatio;
      if (!physicalDimension.isFinite || physicalDimension <= 0) {
        return null;
      }
      final roundedDimension = physicalDimension.round();
      if (roundedDimension > _maxCacheDimension) {
        return _maxCacheDimension;
      }
      return roundedDimension < 1 ? 1 : roundedDimension;
    }
    final cacheWidth = cacheDimension(size ?? width);
    final cacheHeight = cacheDimension(size ?? height);

    // 内存图片
    if (isMemory && imageBytes != null) {
      if (imageBytes!.isEmpty) {
        return _buildErrorWidget();
      }
      final imageWidget = Image.memory(
        imageBytes!,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
      return _wrapWithMagnifier(context, imageWidget);
    }

    final url = imageUrl ?? '';

    // 网络图片
    if (_isValidNetworkUrl(url)) {
      final imageWidget = CachedNetworkImage(
        imageUrl: url,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        maxWidthDiskCache: cacheWidth,
        maxHeightDiskCache: cacheHeight,
        cacheManager: cacheManager,
        placeholder: (context, url) =>
            Container(color: Colors.grey[200], child: const Loading()),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      );
      return _wrapWithMagnifier(context, imageWidget);
    }

    // 本地资源
    if (url.startsWith('assets/')) {
      final imageWidget = Image.asset(
        url,
        width: size ?? width,
        height: size ?? height,
        fit: fit,
      );
      return _wrapWithMagnifier(context, imageWidget);
    }

    return _buildErrorWidget();
  }

  Widget _wrapWithMagnifier(BuildContext context, Widget child) {
    if (!canMagnified) return child;

    return GestureDetector(
      onTap: () {
        if (imageUrl == null || imageUrl!.isEmpty) return;
        showDialog(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.9),
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: InteractiveViewer(
                  child: Image(image: getImageProvider(), fit: BoxFit.contain),
                ),
              ),
            );
          },
        );
      },
      child: child,
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: size ?? width,
      height: size ?? height,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  /// 验证网络 URL 是否有效
  static bool _isValidNetworkUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return false;
    }
    // 检查是否只是协议头（如 "https://" 或 "http://"）
    if (url == 'http://' || url == 'https://') {
      return false;
    }
    // 检查是否有域名部分
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
