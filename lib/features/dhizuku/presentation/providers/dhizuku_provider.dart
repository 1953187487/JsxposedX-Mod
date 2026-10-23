import 'package:JsxposedX/generated/dhizuku.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dhizuku 原生桥接实例。
final dhizukuNativeProvider = Provider<DhizukuNative>((ref) {
  return DhizukuNative();
});

/// Dhizuku 安装、激活与授权状态。
final dhizukuStatusProvider = FutureProvider<DhizukuStatus>((ref) async {
  return ref.watch(dhizukuNativeProvider).getStatus();
});
