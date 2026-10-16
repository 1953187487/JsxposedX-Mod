import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info.freezed.dart';

@freezed
abstract class AppInfo with _$AppInfo {
  const AppInfo._();

  const factory AppInfo({
    required String name,
    required String packageName,
    required String versionName,
    required int versionCode,
    required bool isSystemApp,
    required Uint8List icon,
  }) = _AppInfo;
}
