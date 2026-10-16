import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/home/domain/models/post.dart';
import 'package:JsxposedX/features/home/data/models/common_user_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_category_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_stats_dto.dart';

part 'post_dto.freezed.dart';

part 'post_dto.g.dart';

@freezed
abstract class PostDto with _$PostDto {
  const PostDto._();

  const factory PostDto({
    @Default(0) int id,
    @Default("") String title,
    @Default("") String description,
    @Default(PostCategoryDto()) PostCategoryDto postCategory,
    @Default("") String cover,
    @Default(0) int publishTime,
    @Default(CommonUserDto()) CommonUserDto uploader,
    @Default(PostStatsDto()) PostStatsDto postStats,
    @Default([]) List<int> badges,
  }) = _PostDto;

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  Post toEntity() {
    return Post(
      id: id,
      title: title,
      description: description,
      postCategory: postCategory.toEntity(),
      cover: cover,
      publishTime: publishTime,
      uploader: uploader.toEntity(),
      postStats: postStats.toEntity(),
      badges: badges,
    );
  }
}
