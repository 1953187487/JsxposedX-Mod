import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_host_runtime_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void showMemoryToolSelectionLimitToast(Ref ref, int limit) {
  if (limit < 1) {
    return;
  }
  final localeLanguageCode = ref
      .read(overlayWindowHostRuntimeProvider)
      .payload
      .localeLanguageCode
      .toLowerCase();
  final message = localeLanguageCode.startsWith('zh')
      ? '超出您设置的最大范围:$limit'
      : 'Exceeded your configured maximum range: $limit';
  ref.read(overlayWindowHostRuntimeProvider.notifier).showToast(message);
}
