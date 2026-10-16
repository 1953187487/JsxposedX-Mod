import 'dart:async';

import 'package:JsxposedX/common/widgets/cache_image.dart';
import 'package:JsxposedX/core/animations/fade_animation_hook.dart';
import 'package:JsxposedX/core/animations/slide_animation_hook.dart';
import 'package:JsxposedX/core/constants/assets_constants.dart';
import 'package:JsxposedX/core/extensions/context_extensions.dart';
import 'package:JsxposedX/core/providers/status_management_provider.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:JsxposedX/core/utils/procedure_utils.dart';
import 'package:JsxposedX/features/ai/presentation/providers/runtime/ai_chat_runtime_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_action_provider.dart';
import 'package:JsxposedX/features/project/presentation/providers/project_query_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 启动页
/// 负责：应用初始化、品牌展示、路由跳转
class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiStatusAsync = ref.watch(aiChatRuntimeStatusProvider);
    // 跳过按钮显示状态
    final showSkipButton = useState(false);

    // 倒计时秒数
    final countdown = useState(5);

    final versionName = useState<String>("");
    // 三个滑动动画
    final logoAnimation = useSlideAnimation(
      const SlideAnimationConfig(direction: SlideDirection.leftToRight),
    );
    final topTextAnimation = useSlideAnimation(
      const SlideAnimationConfig(direction: SlideDirection.topToBottom),
    );
    final bottomTextAnimation = useSlideAnimation(
      const SlideAnimationConfig(direction: SlideDirection.bottomToTop),
    );

    // 淡入动画（给logo和文字用）
    final fadeAnimation = useFadeAnimation(
      const FadeAnimationConfig(direction: FadeDirection.fadeIn),
    );

    // 启动页逻辑：初始化 + 跳转
    useEffect(() {
      bool isCancelled = false;
      Timer? hookRefreshTimer;

      // 1秒后显示跳过按钮
      Future.microtask(() async {
        versionName.value = await ProcedureUtils.getVersionName();
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!isCancelled && context.mounted) {
          showSkipButton.value = true;
        }
      });

      // 倒计时
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (isCancelled || !context.mounted) {
          return false;
        }
        if (countdown.value > 0) {
          countdown.value--;
          return true;
        }
        return false;
      }).then((_) {
        if (!isCancelled && context.mounted) {
          context.go(HomeRoute.home);
        }
      });

      // 启动预检：并行触发 AI、Root、Hook 和 Frida 的环境探测
      Future.microtask(() async {
        // 再并行检测其他状态
        Future.wait([
          ref.read(aiChatRuntimeStatusProvider.future),
          ref.read(isRootProvider.future),
          ref.read(isHookProvider.future),
          ref.read(isFridaProvider.future),
          ref.read(initProjectProvider.future),
          ref.read(projectsProvider.future),
        ]);
      });

      hookRefreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        final hookState = ref.read(isHookProvider);
        if (hookState.value == true) {
          hookRefreshTimer?.cancel();
          return;
        }
        if (!hookState.isLoading) {
          ref.invalidate(isHookProvider);
        }
      });

      return () {
        isCancelled = true;
        hookRefreshTimer?.cancel();
      };
    }, []);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部跳过按钮区域 - 固定高度
            SizedBox(
              height: 56.h,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: AnimatedOpacity(
                    opacity: showSkipButton.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: TextButton(
                      onPressed: () => context.go(HomeRoute.home),
                      style: TextButton.styleFrom(
                        foregroundColor: context.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '${context.isZh ? '跳过' : 'Skip'} ${countdown.value}s',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 上部空白 - 占比 5
            const Spacer(flex: 5),

            // 中心内容区域
            FadeTransition(
              opacity: fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  SlideTransition(
                    position: logoAnimation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CacheImage(
                        imageUrl: AssetsConstants.logo,
                        size: 110.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // 应用名称
                  SlideTransition(
                    position: topTextAnimation,
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: aiStatusAsync.value ?? false
                            ? [
                                const Color(0xFF70D7F9),
                                const Color(0xFFAD98FF),
                                const Color(0xFFFFB385),
                              ]
                            : [
                                context.colorScheme.primary,
                                context.colorScheme.secondary,
                              ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        context.l10n.appName,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),

            // 下部空白 - 占比 6
            const Spacer(flex: 6),

            // 底部版本信息
            Padding(
              padding: EdgeInsets.only(bottom: 32.h),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  "v${versionName.value}",
                  style: TextStyle(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.3),
                    fontSize: 11.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // 副标题
            SlideTransition(
              position: bottomTextAnimation,
              child: Text(
                context.l10n.appSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
