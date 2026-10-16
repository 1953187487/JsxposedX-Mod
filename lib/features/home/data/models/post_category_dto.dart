import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/home/domain/models/post_category.dart';

part 'post_category_dto.freezed.dart';
part 'post_category_dto.g.dart';

@freezed
abstract class PostCategoryDto with _$PostCategoryDto {
  const PostCategoryDto._();

  const factory PostCategoryDto({
    @Default(0) int id,
    @Default("") String name,
    @Default("") String icon,
    @Default("") String description,
    @Default(0) int ranking,
  }) = _PostCategoryDto;

  factory PostCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$PostCategoryDtoFromJson(json);

  PostCategory toEntity() {
    return PostCategory(
      id: id,
      name: name,
      icon: icon,
      description: description,
      ranking: ranking,
    );
  }
}
