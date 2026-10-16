import 'package:flutter/material.dart';

/// 在悬浮窗引擎内以 [OverlayPanelDialog] 的形式弹出承载 [child] 的面板。
///
/// 悬浮窗是独立引擎，`showModalBottomSheet` / `showDialog` / `SmartDialog`
/// 无法正确呈现；这里通过覆盖层路由 `Navigator.push` 直接渲染对话框，供
/// 悬浮窗内的长按菜单、引用上下文等面板统一复用。
Future<void> showOverlayPanelSheet({
  required BuildContext context,
  required String title,
  required Widget child,
  double maxWidthPortrait = 420.0,
  double maxWidthLandscape = 520.0,
  double maxHeightPortrait = 560.0,
  double maxHeightLandscape = 420.0,
  Size portraitBaseSize = const Size(360.0, 520.0),
  Size landscapeBaseSize = const Size(440.0, 400.0),
}) {
  return Navigator.of(context).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (routeContext, _, _) => OverlayPanelDialog.scaledCard(
        onClose: () => Navigator.of(routeContext).maybePop(),
        maxWidthPortrait: maxWidthPortrait,
        maxWidthLandscape: maxWidthLandscape,
        maxHeightPortrait: maxHeightPortrait,
        maxHeightLandscape: maxHeightLandscape,
        portraitBaseSize: portraitBaseSize,
        landscapeBaseSize: landscapeBaseSize,
        cardBorderRadius: 18.0,
        childBuilder: (cardContext, viewport, scaledLayout) {
          final scale = scaledLayout.scale;
          return Padding(
            padding: EdgeInsets.all(14.0 * scale),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(cardContext).textTheme.titleSmall
                            ?.copyWith(
                          fontSize: 15.0 * scale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(cardContext).maybePop(),
                      iconSize: 18.0 * scale,
                      visualDensity: VisualDensity.compact,
                      tooltip: MaterialLocalizations.of(
                        cardContext,
                      ).closeButtonTooltip,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(
                          cardContext,
                        ).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.0 * scale),
                Flexible(
                  child: SingleChildScrollView(child: child),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

class OverlayPanelViewport {
  const OverlayPanelViewport(this.constraints);

  final BoxConstraints constraints;

  bool get isLandscape =>
      constraints.maxWidth > constraints.maxHeight * 1.1;

  double get availableWidth =>
      (constraints.maxWidth - 20.0).clamp(0.0, double.infinity).toDouble();

  double get availableHeight =>
      constraints.maxHeight.clamp(0.0, double.infinity).toDouble();

  OverlayPanelLayout? resolveLayout({
    required double maxWidthPortrait,
    required double maxWidthLandscape,
    required double maxHeightPortrait,
    required double maxHeightLandscape,
    double landscapeHeightFactor = 0.9,
  }) {
    final dialogWidthCap = isLandscape ? maxWidthLandscape : maxWidthPortrait;
    final dialogHeightCap = isLandscape
        ? maxHeightLandscape
        : maxHeightPortrait;
    final width = availableWidth < dialogWidthCap
        ? availableWidth
        : dialogWidthCap;
    final maxHeight = isLandscape
        ? availableHeight * landscapeHeightFactor
        : (availableHeight < dialogHeightCap
              ? availableHeight
              : dialogHeightCap);

    if (width <= 0 || maxHeight <= 0) {
      return null;
    }

    return OverlayPanelLayout(
      width: width,
      maxHeight: maxHeight,
    );
  }

  OverlayPanelScaledLayout? resolveScaledLayout({
    required double maxWidthPortrait,
    required double maxWidthLandscape,
    required double maxHeightPortrait,
    required double maxHeightLandscape,
    required Size portraitBaseSize,
    required Size landscapeBaseSize,
    double landscapeHeightFactor = 0.9,
    double minScalePortrait = 0.5,
    double minScaleLandscape = 0.66,
    double maxScale = 1.0,
  }) {
    final layout = resolveLayout(
      maxWidthPortrait: maxWidthPortrait,
      maxWidthLandscape: maxWidthLandscape,
      maxHeightPortrait: maxHeightPortrait,
      maxHeightLandscape: maxHeightLandscape,
      landscapeHeightFactor: landscapeHeightFactor,
    );

    if (layout == null) {
      return null;
    }

    final baseSize = isLandscape ? landscapeBaseSize : portraitBaseSize;
    final scale = (layout.width / baseSize.width < layout.maxHeight / baseSize.height
            ? layout.width / baseSize.width
            : layout.maxHeight / baseSize.height)
        .clamp(isLandscape ? minScaleLandscape : minScalePortrait, maxScale)
        .toDouble();

    return OverlayPanelScaledLayout(
      layout: layout,
      scale: scale,
    );
  }
}

typedef OverlayPanelDialogBuilder = Widget Function(
  BuildContext context,
  OverlayPanelViewport viewport,
);

typedef OverlayPanelCardDialogBuilder = Widget Function(
  BuildContext context,
  OverlayPanelViewport viewport,
  OverlayPanelLayout layout,
);

typedef OverlayPanelScaledCardDialogBuilder = Widget Function(
  BuildContext context,
  OverlayPanelViewport viewport,
  OverlayPanelScaledLayout scaledLayout,
);

class OverlayPanelLayout {
  const OverlayPanelLayout({
    required this.width,
    required this.maxHeight,
  });

  final double width;
  final double maxHeight;
}

class OverlayPanelScaledLayout {
  const OverlayPanelScaledLayout({
    required this.layout,
    required this.scale,
  });

  final OverlayPanelLayout layout;
  final double scale;
}

class OverlayPanelCard extends StatelessWidget {
  const OverlayPanelCard({
    super.key,
    required this.layout,
    required this.child,
    this.color,
    this.borderRadius = 18.0,
    this.clipBehavior = Clip.antiAlias,
    this.height,
    this.minWidth,
    this.maxWidth,
  });

  final OverlayPanelLayout layout;
  final Widget child;
  final Color? color;
  final double borderRadius;
  final Clip clipBehavior;
  final double? height;
  final double? minWidth;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = maxWidth == null
        ? layout.width
        : layout.width < maxWidth!
        ? layout.width
        : maxWidth!;
    final resolvedMinWidth = minWidth == null
        ? 0.0
        : minWidth! < resolvedWidth
        ? minWidth!
        : resolvedWidth;

    return Material(
      color: color ?? Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: clipBehavior,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: resolvedMinWidth,
          maxWidth: resolvedWidth,
          maxHeight: layout.maxHeight,
        ),
        child: SizedBox(
          width: resolvedWidth,
          height: height,
          child: child,
        ),
      ),
    );
  }
}

class OverlayPanelDialog extends StatelessWidget {
  const OverlayPanelDialog({
    super.key,
    required this.childBuilder,
    this.onClose,
    this.barrierDismissible = true,
    this.barrierOpacity = 0.35,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.alignment = Alignment.center,
  }) : _cardBuilder = null,
       _scaledCardBuilder = null,
       maxWidthPortrait = null,
       maxWidthLandscape = null,
       maxHeightPortrait = null,
       maxHeightLandscape = null,
       portraitBaseSize = null,
       landscapeBaseSize = null,
       landscapeHeightFactor = 0.9,
       minScalePortrait = 0.5,
       minScaleLandscape = 0.66,
       maxScale = 1.0,
       cardColor = null,
       cardBorderRadius = 18.0,
       scaledCardBorderRadiusBuilder = null,
       cardMinWidth = null,
       cardMaxWidth = null,
       fillCardHeight = false;

  const OverlayPanelDialog.card({
    super.key,
    required OverlayPanelCardDialogBuilder childBuilder,
    required this.maxWidthPortrait,
    required this.maxWidthLandscape,
    required this.maxHeightPortrait,
    required this.maxHeightLandscape,
    this.onClose,
    this.barrierDismissible = true,
    this.barrierOpacity = 0.35,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.alignment = Alignment.center,
    this.landscapeHeightFactor = 0.9,
    this.cardColor,
    this.cardBorderRadius = 18.0,
    this.cardMinWidth,
    this.cardMaxWidth,
    this.fillCardHeight = false,
  }) : childBuilder = null,
       _cardBuilder = childBuilder,
       _scaledCardBuilder = null,
       portraitBaseSize = null,
       landscapeBaseSize = null,
       minScalePortrait = 0.5,
       minScaleLandscape = 0.66,
       maxScale = 1.0,
       scaledCardBorderRadiusBuilder = null;

  const OverlayPanelDialog.scaledCard({
    super.key,
    required OverlayPanelScaledCardDialogBuilder childBuilder,
    required this.maxWidthPortrait,
    required this.maxWidthLandscape,
    required this.maxHeightPortrait,
    required this.maxHeightLandscape,
    required this.portraitBaseSize,
    required this.landscapeBaseSize,
    this.onClose,
    this.barrierDismissible = true,
    this.barrierOpacity = 0.35,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0),
    this.alignment = Alignment.center,
    this.landscapeHeightFactor = 0.9,
    this.minScalePortrait = 0.5,
    this.minScaleLandscape = 0.66,
    this.maxScale = 1.0,
    this.cardColor,
    this.cardBorderRadius = 18.0,
    this.scaledCardBorderRadiusBuilder,
    this.cardMinWidth,
    this.cardMaxWidth,
    this.fillCardHeight = false,
  }) : childBuilder = null,
       _cardBuilder = null,
       _scaledCardBuilder = childBuilder;

  final OverlayPanelDialogBuilder? childBuilder;
  final OverlayPanelCardDialogBuilder? _cardBuilder;
  final OverlayPanelScaledCardDialogBuilder? _scaledCardBuilder;
  final VoidCallback? onClose;
  final bool barrierDismissible;
  final double barrierOpacity;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final double? maxWidthPortrait;
  final double? maxWidthLandscape;
  final double? maxHeightPortrait;
  final double? maxHeightLandscape;
  final Size? portraitBaseSize;
  final Size? landscapeBaseSize;
  final double landscapeHeightFactor;
  final double minScalePortrait;
  final double minScaleLandscape;
  final double maxScale;
  final Color? cardColor;
  final double cardBorderRadius;
  final double Function(OverlayPanelScaledLayout scaledLayout)?
  scaledCardBorderRadiusBuilder;
  final double? cardMinWidth;
  final double? cardMaxWidth;
  final bool fillCardHeight;

  Widget _buildOverlayChild(
    BuildContext context,
    OverlayPanelViewport viewport,
  ) {
    if (_scaledCardBuilder case final scaledCardBuilder?) {
      final scaledLayout = viewport.resolveScaledLayout(
        maxWidthPortrait: maxWidthPortrait!,
        maxWidthLandscape: maxWidthLandscape!,
        maxHeightPortrait: maxHeightPortrait!,
        maxHeightLandscape: maxHeightLandscape!,
        portraitBaseSize: portraitBaseSize!,
        landscapeBaseSize: landscapeBaseSize!,
        landscapeHeightFactor: landscapeHeightFactor,
        minScalePortrait: minScalePortrait,
        minScaleLandscape: minScaleLandscape,
        maxScale: maxScale,
      );

      if (scaledLayout == null) {
        return const SizedBox.shrink();
      }

      return OverlayPanelCard(
        layout: scaledLayout.layout,
        color: cardColor,
        borderRadius:
            scaledCardBorderRadiusBuilder?.call(scaledLayout) ??
            cardBorderRadius,
        minWidth: cardMinWidth,
        maxWidth: cardMaxWidth,
        height: fillCardHeight ? scaledLayout.layout.maxHeight : null,
        child: scaledCardBuilder(context, viewport, scaledLayout),
      );
    }

    if (_cardBuilder case final cardBuilder?) {
      final layout = viewport.resolveLayout(
        maxWidthPortrait: maxWidthPortrait!,
        maxWidthLandscape: maxWidthLandscape!,
        maxHeightPortrait: maxHeightPortrait!,
        maxHeightLandscape: maxHeightLandscape!,
        landscapeHeightFactor: landscapeHeightFactor,
      );

      if (layout == null) {
        return const SizedBox.shrink();
      }

      return OverlayPanelCard(
        layout: layout,
        color: cardColor,
        borderRadius: cardBorderRadius,
        minWidth: cardMinWidth,
        maxWidth: cardMaxWidth,
        height: fillCardHeight ? layout.maxHeight : null,
        child: cardBuilder(context, viewport, layout),
      );
    }

    return childBuilder!(context, viewport);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: barrierOpacity),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: barrierDismissible ? onClose : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewport = OverlayPanelViewport(constraints);

            return Align(
              alignment: alignment,
              child: Padding(
                padding: padding,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: _buildOverlayChild(context, viewport),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
