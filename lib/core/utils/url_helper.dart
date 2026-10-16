import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  const UrlHelper._();

  static const MethodChannel _nativeChannel = MethodChannel(
    'com.jsxposed.xmod/url_helper',
  );

  static Future<void> openUrlInBrowser({required String url}) async {
    final Uri uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        return;
      }
    } catch (e) {
      debugPrint('url_launcher 打开 URL 失败，尝试原生兜底: $e');
    }

    try {
      final opened =
          await _nativeChannel.invokeMethod<bool>('openExternalUrl', {
            'url': url,
          }) ??
          false;
      if (!opened) {
        debugPrint('原生兜底仍无法打开 URL: $url');
      }
    } catch (e) {
      debugPrint('原生兜底打开 URL 失败: $e');
    }
  }
}
