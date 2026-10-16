import 'dart:typed_data';

import 'package:JsxposedX/core/models/app_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info_dto.freezed.dart';
part 'app_info_dto.g.dart';

@freezed
abstract class AppInfoDto with _$AppInfoDto {
  const AppInfoDto._();

  const factory AppInfoDto({
    @Default("") String name,
    @Default("") String packageName,
    @Default("") String versionName,
    @Default(0) int versionCode,
    @Default(false) bool isSystemApp,
    @JsonKey(includeFromJson: false, includeToJson: false) Uint8List? icon,
  }) = _AppInfoDto;

  factory AppInfoDto.fromJson(Map<String, dynamic> json) =>
      _$AppInfoDtoFromJson(json);

  AppInfo toEntity() {
    return AppInfo(
      name: name,
      packageName: packageName,
      versionName: versionName,
      versionCode: versionCode,
      isSystemApp: isSystemApp,
      icon: icon ?? Uint8List(0),
    );
  }
}
