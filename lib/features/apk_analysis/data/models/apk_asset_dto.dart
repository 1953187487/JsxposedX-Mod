import 'package:JsxposedX/core/models/apk_asset.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'apk_asset_dto.freezed.dart';
part 'apk_asset_dto.g.dart';

@freezed
abstract class ApkAssetDto with _$ApkAssetDto {
  const ApkAssetDto._();

  const factory ApkAssetDto({
    @Default('') String path,
    @Default('') String name,
    @Default(0) int size,
    @Default(0) int compressedSize,
    @Default(false) bool isDirectory,
    @Default(0) int lastModified,
  }) = _ApkAssetDto;

  factory ApkAssetDto.fromJson(Map<String, dynamic> json) =>
      _$ApkAssetDtoFromJson(json);

  ApkAsset toEntity() {
    return ApkAsset(
      path: path,
      name: name,
      size: size,
      compressedSize: compressedSize,
      isDirectory: isDirectory,
      lastModified: lastModified,
    );
  }
}
