import 'package:JsxposedX/features/overlay_window/data/datasources/overlay_window_platform_gateway.dart';
import 'package:JsxposedX/features/overlay_window/data/datasources/overlay_window_query_datasource.dart';
import 'package:JsxposedX/features/overlay_window/data/repositories/overlay_window_query_repository_impl.dart';
import 'package:JsxposedX/features/overlay_window/domain/models/overlay_window_status.dart';
import 'package:JsxposedX/features/overlay_window/domain/repositories/overlay_window_query_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_window_query_provider.g.dart';

@riverpod
OverlayWindowPlatformGateway overlayWindowPlatformGateway(Ref ref) {
  return const FlutterOverlayWindowPlatformGateway();
}

@riverpod
OverlayWindowQueryDatasource overlayWindowQueryDatasource(Ref ref) {
  final gateway = ref.watch(overlayWindowPlatformGatewayProvider);
  return OverlayWindowQueryDatasource(gateway: gateway);
}

@riverpod
OverlayWindowQueryRepository overlayWindowQueryRepository(Ref ref) {
  final dataSource = ref.watch(overlayWindowQueryDatasourceProvider);
  return OverlayWindowQueryRepositoryImpl(dataSource: dataSource);
}

@Riverpod(keepAlive: true)
Future<OverlayWindowStatus> overlayWindowStatus(Ref ref) async {
  return ref.watch(overlayWindowQueryRepositoryProvider).getStatus();
}
