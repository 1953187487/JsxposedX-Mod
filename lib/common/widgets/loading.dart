import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 应用加载动画（beta.2 重写）：
/// 品牌 Logo 呼吸脉冲 + 流光进度条，替代旧版 loading.gif。
class Loading extends StatefulWidget {
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
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final value = widget.value;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.04).animate(
              CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
            ),
            child: Container(
              width: widget.width ?? 88,
              height: widget.height ?? 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.72),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.35),
                    blurRadius: 26,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  AssetsConstants.logo,
                  width: (widget.width ?? 88) * 0.58,
                  height: (widget.height ?? 88) * 0.58,
                  fit: widget.fit,
                ),
              ),
            ),
          ),
          SizedBox(height: value == null ? 22 : 14),
          if (value != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: value.clamp(0.0, 1.0),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                    color: colorScheme.primary,
                    backgroundColor:
                        colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${(value * 100).toStringAsFixed(0)}%",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else
            _ShimmerBar(
              controller: _shimmer,
              color: colorScheme.primary,
              trackColor: colorScheme.surfaceContainerHighest,
            ),
        ],
      ),
    );
  }
}

class _ShimmerBar extends StatelessWidget {
  const _ShimmerBar({
    required this.controller,
    required this.color,
    required this.trackColor,
  });

  final AnimationController controller;
  final Color color;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 6,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final t = controller.value;
                  final segWidth = constraints.maxWidth * 0.38;
                  final travel = constraints.maxWidth + segWidth;
                  final x = t * travel - segWidth;
                  return Positioned(
                    left: x,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        width: segWidth,
                        height: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.25),
                                color,
                                color.withValues(alpha: 0.25),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 内联品牌加载（用于页面内的初始化等待区，非全屏弹层）。
class BrandLoading extends StatefulWidget {
  final String? message;
  final double size;

  const BrandLoading({super.key, this.message, this.size = 64});

  @override
  State<BrandLoading> createState() => _BrandLoadingState();
}

class _BrandLoadingState extends State<BrandLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = widget.size;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.06).animate(
              CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.72),
                  ],
                ),
                borderRadius: BorderRadius.circular(size * 0.28),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: size * 0.4,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size * 0.28),
                child: Image.asset(
                  AssetsConstants.logo,
                  width: size * 0.58,
                  height: size * 0.58,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          if (widget.message != null && widget.message!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: null,
                minHeight: 4,
                color: colorScheme.primary,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
