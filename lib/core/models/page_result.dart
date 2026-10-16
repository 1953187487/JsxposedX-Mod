import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_result.freezed.dart';

@Freezed(genericArgumentFactories: true)
abstract class PageResult<T> with _$PageResult<T> {
  const factory PageResult({
    required int total,
    required List<T> rows,
    required int code,
    required String msg,
    required bool hasMore,
  }) = _PageResult<T>;
}
