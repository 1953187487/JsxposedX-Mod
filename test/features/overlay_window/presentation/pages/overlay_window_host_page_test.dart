import 'dart:async';
import 'dart:ui';

import 'package:JsxposedX/features/overlay_window/domain/models/overlay_host_layout.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_viewport_metrics.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_payload.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_runtime_message.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_status.dart';
import 'package:JsxposedX/features/overlay_window/domain/repositories/overlay_window_action_repository.dart';
import 'package:JsxposedX/features/overlay_window/domain/repositories/overlay_window_query_repository.dart';
import 'package:JsxposedX/features/overlay_window/presentation/models/overlay_scene_definition.dart';
import 'package:JsxposedX/features/overlay_window/presentation/pages/overlay_window_host_page.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_scene_registry_provider.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_action_provider.dart';
import 'package:JsxposedX/features/overlay_window/presentation/providers/overlay_window_query_provider.dart';
import 'package:JsxposedX/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('renders fallback panel for unknown scene', (tester) async {
    final queryRepository = _FakeOverlayWindowQueryRepository();
    final actionRepository = _FakeOverlayWindowActionRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          overlayWindowQueryRepositoryProvider.overrideWithValue(
            queryRepository,
          ),
          overlayWindowActionRepositoryProvider.overrideWithValue(
            actionRepository,
          ),
          overlaySceneRegistryProvider.overrideWith(
            (ref) => <int, OverlaySceneDefinition>{},
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, _) {
            return MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const OverlayWindowHostPage(),
            );
          },
        ),
      ),
    );

    queryRepository.controller.add(
      OverlayWindowRuntimeMessage.payload(
        OverlayWindowPayload(
          sceneId: 999,
          displayMode: OverlayWindowDisplayMode.panel,
          localeLanguageCode: 'en',
          localeCountryCode: 'US',
          isDarkTheme: true,
          primaryColorValue: 0xFF123456,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Overlay scene unavailable'), findsOneWidget);
    expect(
      find.text(
        'The requested overlay scene is not registered, so rendering was stopped.',
      ),
      findsOneWidget,
    );
  });
}

class _FakeOverlayWindowQueryRepository
    implements OverlayWindowQueryRepository {
  final StreamController<OverlayWindowRuntimeMessage> controller =
      StreamController<OverlayWindowRuntimeMessage>.broadcast();

  @override
  bool get isSupportedPlatform => true;

  @override
  Stream<OverlayWindowRuntimeMessage> get overlayEvents => controller.stream;

  @override
  Future<OverlayViewportMetrics> getOverlayViewportMetrics() async {
    return const OverlayViewportMetrics(
      width: 400,
      height: 800,
      safePadding: EdgeInsets.zero,
    );
  }

  @override
  Future<Offset> getOverlayPosition() async => const Offset(16, 100);

  @override
  Future<OverlayWindowStatus> getStatus() async {
    return const OverlayWindowStatus(
      isSupported: true,
      hasPermission: true,
      isActive: true,
    );
  }

  @override
  Future<bool> isActive() async => true;

  @override
  Future<bool> isPermissionGranted() async => true;
}

class _FakeOverlayWindowActionRepository
    implements OverlayWindowActionRepository {
  @override
  Future<bool> closeOverlay() async => true;

  @override
  Future<bool> moveOverlay(Offset position) async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> sharePayload(OverlayWindowPayload payload) async {}

  @override
  Future<void> showOverlayHost({
    required OverlayHostLayout layout,
    required String notificationTitle,
    required String notificationContent,
  }) async {}

  @override
  Future<bool> updateOverlayHost(OverlayHostLayout layout) async => true;
}
