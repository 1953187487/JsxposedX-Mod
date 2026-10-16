import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Loading extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? value;

  const Loading({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.value,
  });

  static void show() {
    SmartDialog.showLoading(
      builder: (context) => const Loading(),
    );
  }

  static void hide() {
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CacheImage(
            imageUrl: AssetsConstants.loading,
            width: width,
            height: height,
            fit: fit,
          ),
          if (value != null) ...[
            const SizedBox(height: 12),
            Text(
              "${(value! * 100).toStringAsFixed(0)}%",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
