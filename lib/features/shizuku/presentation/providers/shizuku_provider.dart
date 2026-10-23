import 'package:JsxposedX/generated/shizuku.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shizuku 原生桥接实例。
final shizukuNativeProvider = Provider<ShizukuNative>((ref) {
  return ShizukuNative();
});

/// Shizuku 安装、运行与授权状态。
final shizukuStatusProvider = FutureProvider<ShizukuStatus>((ref) async {
  return ref.watch(shizukuNativeProvider).getStatus();
});
