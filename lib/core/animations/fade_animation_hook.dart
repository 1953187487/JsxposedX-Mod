import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 淡入淡出方向
enum FadeDirection {
  fadeIn, // 淡入（0 → 1）
  fadeOut, // 淡出（1 → 0）
}

/// 淡入淡出动画配置
class FadeAnimationConfig {
  final FadeDirection direction;
  final Duration duration;
  final Curve curve;
  final double beginOpacity; // 起始透明度
  final double endOpacity; // 结束透明度

  const FadeAnimationConfig({
    this.direction = FadeDirection.fadeIn,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeIn,
    double? beginOpacity,
    double? endOpacity,
  }) : beginOpacity =
           beginOpacity ?? (direction == FadeDirection.fadeIn ? 0.0 : 1.0),
       endOpacity =
           endOpacity ?? (direction == FadeDirection.fadeIn ? 1.0 : 0.0);
}

/// 自定义淡入淡出动画Hook
///
/// 用法：
/// ```dart
/// final animation = useFadeAnimation(
///   FadeAnimationConfig(direction: FadeDirection.fadeIn),
/// );
///
/// return FadeTransition(
///   opacity: animation,
///   child: YourWidget(),
/// );
/// ```
Animation<double> useFadeAnimation(FadeAnimationConfig config) {
  // 创建动画控制器
  final controller = useAnimationController(duration: config.duration);

  // 创建动画
  final animation = useMemoized(
    () => Tween<double>(
      begin: config.beginOpacity,
      end: config.endOpacity,
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
