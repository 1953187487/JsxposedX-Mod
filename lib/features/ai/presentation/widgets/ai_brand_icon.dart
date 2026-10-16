import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:JsxposedX/core/extensions/context_extensions.dart';

/// 已收录的品牌图标（simple-icons，CC0-1.0），颜色取各家官方品牌色。
enum AiBrand {
  openai('openai', Color(0xFF412991)),
  anthropic('anthropic', Color(0xFF191919)),
  claude('claude', Color(0xFFD97757)),
  deepseek('deepseek', Color(0xFF5786FE)),
  moonshot('moonshotai', Color(0xFF000000)),
  gemini('googlegemini', Color(0xFF8E75B2)),
  mistral('mistralai', Color(0xFFFA520F)),
  ollama('ollama', Color(0xFF000000)),
  qwen('qwen', Color(0xFF6950EF)),
  perplexity('perplexity', Color(0xFF1FB8CD)),
  glm('glm', Color(0xFF3B82F6)),
  groq('groq', Color(0xFFF55036)),
  xai('xai', Color(0xFF000000)),
  meta('meta', Color(0xFF0668E1)),
  minimax('minimax', Color(0xFF5B5CE2)),
  cohere('cohere', Color(0xFF39594D)),
  baichuan('baichuan', Color(0xFF3D7EFF)),
  yi('01ai', Color(0xFF111111)),
  internlm('internlm', Color(0xFF1677FF)),
  doubao('doubao', Color(0xFF3370FF)),
  llama('llama', Color(0xFF0668E1)),
  grok('grok', Color(0xFF000000)),
  stepfun('stepfun', Color(0xFF5B5CE2)),
  tencent('tencent', Color(0xFF0052D9)),
  amazon('amazon', Color(0xFFFF9900)),
  microsoft('microsoft', Color(0xFF5E5E5E)),
  ai21('ai21', Color(0xFF6C47FF));

  const AiBrand(this.assetName, this.brandColor);

  final String assetName;

  /// 官方品牌色。
  final Color brandColor;

  String get assetPath => 'assets/images/ai_icons/$assetName.svg';

  /// 在给定亮度下实际可用的着色。
  ///
  /// 多数品牌色（如 DeepSeek 蓝、Claude 橙）是中间明度，两种主题下都清晰；
  /// 但 Moonshot / Ollama 的纯黑、Anthropic 的近黑在深色背景上会隐形，
  /// 因此过暗的品牌色在深色模式下按原色相提亮，无色相的则转浅灰。
  Color resolveColor({required bool isDark}) {
    if (!isDark) return brandColor;

    final hsl = HSLColor.fromColor(brandColor);
    if (hsl.lightness >= 0.55) return brandColor;

    // 近乎无彩色的品牌（纯黑/近黑）没有可提亮的色相，改用中性浅色。
    if (hsl.saturation < 0.08) return const Color(0xFFE6E6E6);

    return hsl
        .withLightness(hsl.lightness < 0.35 ? 0.72 : 0.80)
        .withSaturation(hsl.saturation.clamp(0.55, 1.0))
        .toColor();
  }

  /// 依据接口地址/模型名/配置名推断服务商，识别不出返回 null。
  static AiBrand? resolve({String? apiUrl, String? modelName, String? name}) {
    final haystack = [
      apiUrl ?? '',
      modelName ?? '',
      name ?? '',
    ].join(' ').toLowerCase();

    if (haystack.trim().isEmpty) return null;

    // 关键词顺序敏感：产品品牌优先于公司品牌。
    const matchers = <(AiBrand, List<String>)>[
      (AiBrand.claude, ['claude']),
      (AiBrand.anthropic, ['anthropic']),
      (AiBrand.deepseek, ['deepseek']),
      (AiBrand.moonshot, ['moonshot', 'kimi', '月之暗面']),
      (AiBrand.gemini, ['gemini', 'generativelanguage', 'googleapis']),
      (AiBrand.mistral, ['mistral']),
      (AiBrand.ollama, ['ollama']),
      (AiBrand.qwen, ['qwen', 'dashscope', '通义']),
      (AiBrand.perplexity, ['perplexity']),
      (AiBrand.glm, ['glm', 'chatglm', 'zhipu', '智谱', '清言']),
      (AiBrand.groq, ['groq']),
      (AiBrand.xai, ['x.ai', 'grok', 'xai']),
      (AiBrand.meta, ['llama', 'meta']),
      (AiBrand.minimax, ['minimax', 'abab']),
      (AiBrand.cohere, ['cohere', 'command-r']),
      (AiBrand.baichuan, ['baichuan', '百川']),
      (AiBrand.yi, ['01.ai', '01ai', 'yi-']),
      (AiBrand.internlm, ['internlm', '书生']),
      (AiBrand.doubao, ['doubao', '豆包', 'volcengine']),
      (AiBrand.llama, ['llama', 'meta']),
      (AiBrand.grok, ['grok']),
      (AiBrand.stepfun, ['stepfun', 'step-']),
      (AiBrand.tencent, ['hunyuan', '混元', 'tencent']),
      (AiBrand.amazon, ['amazon', 'nova', 'bedrock']),
      (AiBrand.microsoft, ['azure', 'copilot', 'phi-']),
      (AiBrand.ai21, ['ai21', 'jamba']),
      (AiBrand.openai, ['openai', 'gpt-', 'gpt4', 'gpt5', 'o1-', 'o3-', 'o4-']),
    ];

    for (final (brand, keywords) in matchers) {
      if (keywords.any(haystack.contains)) return brand;
    }
    return null;
  }
}

/// 品牌图标，按各家官方品牌色着色；无匹配品牌时回退为通用图标。
///
/// 沐雪接口使用项目内已有的位图 logo。
class AiBrandIcon extends StatelessWidget {
  const AiBrandIcon({
    super.key,
    this.brand,
    this.size = 22,
    this.fallbackIcon = Icons.smart_toy_outlined,
    this.fallbackAsset,
  });

  final AiBrand? brand;
  final double size;
  final IconData fallbackIcon;

  /// 无品牌时使用的位图资源（如沐雪 logo）。
  final String? fallbackAsset;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Widget child;

    if (brand != null) {
      child = SvgPicture.asset(
        brand!.assetPath,
        width: size.sp,
        height: size.sp,
        colorFilter: ColorFilter.mode(
          brand!.resolveColor(isDark: isDark),
          BlendMode.srcIn,
        ),
        placeholderBuilder: (_) => _fallback(scheme),
      );
    } else if (fallbackAsset != null) {
      child = Image.asset(
        fallbackAsset!,
        width: size.sp,
        height: size.sp,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fallback(scheme),
      );
    } else {
      child = _fallback(scheme);
    }

    return child;
  }

  Widget _fallback(ColorScheme scheme) =>
      Icon(fallbackIcon, size: size.sp, color: scheme.primary);
}
