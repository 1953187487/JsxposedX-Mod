import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// 缩放动画方向
enum ScaleDirection {
  scaleIn, // 弹入（从小到大）
  scaleOut, // 弹出（从大到小）
}

/// 缩放动画配置
class ScaleAnimationConfig {
  final ScaleDirection direction;
  final Duration duration;
  final Curve curve;
  final double beginScale; // 起始缩放
  final double endScale; // 结束缩放
  final Alignment alignment; // 缩放中心点

  const ScaleAnimationConfig({
    this.direction = ScaleDirection.scaleIn,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutBack, // 弹性效果
    double? beginScale,
    double? endScale,
    this.alignment = Alignment.center,
  }) : beginScale =
           beginScale ?? (direction == ScaleDirection.scaleIn ? 0.0 : 1.0),
       endScale = endScale ?? (direction == ScaleDirection.scaleIn ? 1.0 : 0.0);
}

/// 自定义缩放动画Hook
///
/// 用法：
/// ```dart
/// final animation = useScaleAnimation(
///   ScaleAnimationConfig(
///     direction: ScaleDirection.scaleIn,
///     curve: Curves.elasticOut,  // 弹跳效果更明显
///   ),
/// );
///
/// return ScaleTransition(
///   scale: animation,
///   child: YourWidget(),
/// );
/// ```
Animation<double> useScaleAnimation(ScaleAnimationConfig config) {
  // 创建动画控制器
  final controller = useAnimationController(duration: config.duration);

  // 创建动画
  final animation = useMemoized(
    () => Tween<double>(
      begin: config.beginScale,
      end: config.endScale,
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
