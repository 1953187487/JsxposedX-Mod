import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 滑动动画方向
enum SlideDirection {
  leftToRight, // 从左到右
  rightToLeft, // 从右到左
  topToBottom, // 从上到下
  bottomToTop, // 从下到上
}

/// 滑动动画配置
class SlideAnimationConfig {
  final SlideDirection direction;
  final Duration duration;
  final Curve curve;

  const SlideAnimationConfig({
    required this.direction,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
  });
}

/// 自定义滑动动画Hook
///
/// 用法：
/// ```dart
/// final animation = useSlideAnimation(
///   SlideAnimationConfig(direction: SlideDirection.leftToRight),
/// );
///
/// return SlideTransition(
///   position: animation,
///   child: YourWidget(),
/// );
/// ```
Animation<Offset> useSlideAnimation(SlideAnimationConfig config) {
  // 创建动画控制器
  final controller = useAnimationController(duration: config.duration);

  // 根据方向确定起始位置
  final Offset beginOffset = switch (config.direction) {
    SlideDirection.leftToRight => const Offset(-1, 0),
    SlideDirection.rightToLeft => const Offset(1, 0),
    SlideDirection.topToBottom => const Offset(0, -1),
    SlideDirection.bottomToTop => const Offset(0, 1),
  };

  // 创建动画
  final animation = useMemoized(
    () => Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: config.curve)),
    [controller],
  );

  // 自动启动动画
  useEffect(() {
    controller.forward();
    return null;
  }, [controller]);

  return animation;
}
