import 'package:freezed_annotation/freezed_annotation.dart';

part 'apk_asset.freezed.dart';

@freezed
abstract class ApkAsset with _$ApkAsset {
  const factory ApkAsset({
    required String path,
    required String name,
    required int size,
    required int compressedSize,
    required bool isDirectory,
    required int lastModified,
  }) = _ApkAsset;
}
