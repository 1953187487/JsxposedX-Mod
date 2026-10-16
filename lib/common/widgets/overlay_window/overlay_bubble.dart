import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class OverlayBubble extends StatelessWidget {
  const OverlayBubble({super.key, required this.size});

  final double size;

  static const LinearGradient _bubbleGradient = LinearGradient(
    colors: <Color>[Color(0xFF70D7F9), Color(0xFFAD98FF), Color(0xFFFFB385)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _bubbleGradient,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF70D7F9).withValues(
                alpha: context.isDark ? 0.28 : 0.24,
              ),
              blurRadius: 10,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: const Color(0xFFAD98FF).withValues(
                alpha: context.isDark ? 0.24 : 0.22,
              ),
              blurRadius: 12,
              offset: const Offset(3, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(
                alpha: context.isDark ? 0.12 : 0.06,
              ),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),

          ],
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.isDark ? const Color(0xFF1E1E1E) : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: ClipOval(
                  child: CacheImage(
                    imageUrl: AssetsConstants.logo,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
