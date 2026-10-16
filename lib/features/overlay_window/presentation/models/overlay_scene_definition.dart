import 'package:flutter/widgets.dart';

typedef OverlaySceneTextBuilder = String Function(BuildContext context);
typedef OverlayScenePanelBuilder = Widget Function(BuildContext context);

class OverlaySceneDefinition {
  const OverlaySceneDefinition({
    required this.sceneId,
    required this.bubbleSize,
    required this.notificationTitle,
    required this.notificationContent,
    required this.panelBuilder,
  });

  final int sceneId;
  final double bubbleSize;
  final OverlaySceneTextBuilder notificationTitle;
  final OverlaySceneTextBuilder notificationContent;
  final OverlayScenePanelBuilder panelBuilder;
}
