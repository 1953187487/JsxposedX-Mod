import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_presentation.freezed.dart';

const double overlayWindowDefaultBubbleSize = 58;

@freezed
abstract class OverlayWindowPresentation with _$OverlayWindowPresentation {
  const OverlayWindowPresentation._();

  const factory OverlayWindowPresentation({
    double? width,
    double? height,
    @Default(overlayWindowDefaultBubbleSize) double bubbleSize,
    @Default(true) bool enableDrag,
    String? notificationTitle,
    String? notificationContent,
  }) = _OverlayWindowPresentation;

  static const double defaultBubbleSize = overlayWindowDefaultBubbleSize;
}
