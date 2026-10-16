import 'dart:async';

import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_payload.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_runtime_message.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_query_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final overlayWindowRuntimeSyncProvider =
    NotifierProvider<OverlayWindowRuntimeSyncNotifier, OverlayWindowPayload?>(
      OverlayWindowRuntimeSyncNotifier.new,
    );

class OverlayWindowRuntimeSyncNotifier extends Notifier<OverlayWindowPayload?> {
  StreamSubscription<OverlayWindowRuntimeMessage>? _subscription;

  @override
  OverlayWindowPayload? build() {
    _subscription ??= ref
        .read(overlayWindowQueryRepositoryProvider)
        .overlayEvents
        .listen(_handleRuntimeMessage);
    ref.onDispose(() async {
      await _subscription?.cancel();
      _subscription = null;
    });
    return null;
  }

  void rememberPayload(OverlayWindowPayload payload) {
    state = payload;
  }

  void clear() {
    state = null;
  }

  void _handleRuntimeMessage(OverlayWindowRuntimeMessage message) {
    message.mapOrNull(
      payload: (payloadMessage) {
        state = payloadMessage.payload;
        return null;
      },
    );
  }
}
