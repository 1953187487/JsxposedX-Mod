import 'package:JsxposedX/features/memory_tool_overlay/presentation/pages/memory_tool_overlay.dart';
import 'package:JsxposedX/features/overlay_window/presentation/models/overlay_scene_definition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_scene_registry_provider.g.dart';

@riverpod
Map<int, OverlaySceneDefinition> overlaySceneRegistry(Ref ref) {
  final memoryToolOverlay = MemoryToolOverlay();
  final overlayConfig = memoryToolOverlay.overlayConfig;
  return <int, OverlaySceneDefinition>{
    overlayConfig.sceneId: OverlaySceneDefinition(
      sceneId: overlayConfig.sceneId,
      bubbleSize: overlayConfig.bubbleSize,
      notificationTitle: overlayConfig.notificationTitle,
      notificationContent: overlayConfig.notificationContent,
      panelBuilder: (context) => const MemoryToolOverlay(),
    ),
  };
}
