import 'package:freezed_annotation/freezed_annotation.dart';

part 'overlay_window_status.freezed.dart';

@freezed
abstract class OverlayWindowStatus with _$OverlayWindowStatus {
  const OverlayWindowStatus._();

  const factory OverlayWindowStatus({
    required bool isSupported,
    required bool hasPermission,
    required bool isActive,
  }) = _OverlayWindowStatus;

  bool get canShow => isSupported && hasPermission;
}
