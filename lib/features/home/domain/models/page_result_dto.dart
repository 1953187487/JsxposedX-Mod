import 'package:JsxposedX/core/models/page_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_result_dto.freezed.dart';

part 'page_result_dto.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PageResultDto<T> with _$PageResultDto<T> {
  const PageResultDto._();

  const factory PageResultDto({
    @Default(0) int total,
    @Default([]) List<T> rows,
    @Default(400) int code,
    @Default("") String msg,
    @Default(false) bool hasMore,
  }) = _PageResultDto<T>;

  factory PageResultDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PageResultDtoFromJson(json, fromJsonT);

  PageResult<E> toEntity<E>(E Function(T) converter) {
    return PageResult<E>(
      total: total,
      rows: rows.map(converter).toList(),
      code: code,
      msg: msg,
      hasMore: hasMore,
    );
  }
}
