import 'package:JsxposedX/core/models/dialog_keyword.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialog_keyword_dto.freezed.dart';
part 'dialog_keyword_dto.g.dart';
@freezed
abstract class DialogKeywordDto with _$DialogKeywordDto {
  const DialogKeywordDto._();

  const factory DialogKeywordDto({
    @Default("") String keyword,
    @Default(false) bool isCheck,
  }) = _DialogKeywordDto;

  factory DialogKeywordDto.fromJson(Map<String, dynamic> json) =>
      _$DialogKeywordDtoFromJson(json);

  DialogKeyword toEntity() =>
      DialogKeyword(
        keyword: keyword,
        isCheck: isCheck,
      );
}
