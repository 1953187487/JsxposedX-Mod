import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/home/domain/models/post_detail.dart';
import 'package:JsxposedX/features/home/data/models/common_user_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_category_dto.dart';
import 'package:JsxposedX/features/home/data/models/post_stats_dto.dart';

part 'post_detail_dto.freezed.dart';

part 'post_detail_dto.g.dart';

@freezed
abstract class PostDetailDto with _$PostDetailDto {
  const PostDetailDto._();

  const factory PostDetailDto({
    @Default(-1) int id,
    @Default('') String title,
    @Default('') String description,
    @Default([]) List<TagDto> tags,
    @Default(PostCategoryDto()) PostCategoryDto postCategory,
    @Default('') String cover,
    @Default(0) int publishTime,
    @Default(CommonUserDto()) @JsonKey(name: 'uploader') CommonUserDto uploader,
    @Default(PostStatsDto()) @JsonKey(name: 'postStats') PostStatsDto postStats,
    @Default(PostRightsDto())
    @JsonKey(name: 'postRights')
    PostRightsDto postRights,
    @Default(PostStatusDto())
    @JsonKey(name: 'postStatus')
    PostStatusDto postStatus,
    @Default([]) List<int> badges,
    @Default('') String content,
  }) = _PostDetailDto;

  factory PostDetailDto.fromJson(Map<String, dynamic> json) =>
      _$PostDetailDtoFromJson(json);

  PostDetail toEntity() {
    return PostDetail(
      id: id,
      title: title,
      description: description,
      tags: tags.map((t) => t.toEntity()).toList(),
      postCategory: postCategory.toEntity(),
      cover: cover,
      publishTime: publishTime,
      uploader: uploader.toEntity(),
      postStats: postStats.toEntity(),
      postRights: postRights.toEntity(),
      postStatus: postStatus.toEntity(),
      badges: badges,
      content: content,
    );
  }
}

/// 标签数据传输对象
@freezed
abstract class TagDto with _$TagDto {
  const TagDto._();

  const factory TagDto({
    @Default(-1) int id,
    @Default('') @JsonKey(name: 'tagName') String tagName,
    @Default(0) int hotValue,
    @Default(0) int clicks,
  }) = _TagDto;

  factory TagDto.fromJson(Map<String, dynamic> json) => _$TagDtoFromJson(json);

  Tag toEntity() {
    return Tag(id: id, tagName: tagName, hotValue: hotValue, clicks: clicks);
  }
}

@freezed
abstract class PostRightsDto with _$PostRightsDto {
  const PostRightsDto._();

  const factory PostRightsDto({
    @Default(false) bool canEdit,
    @Default(false) bool canDelete,
    @Default(true) bool canComment,
    @Default(true) bool canLike,
    @Default(true) bool canFavorite,
    @Default(true) bool canShare,
    @Default(false) bool canReward,
    @Default(false) bool needLike,
    @Default(false) bool needComment,
    @Default(false) bool needReward,
  }) = _PostRightsDto;

  factory PostRightsDto.fromJson(Map<String, dynamic> json) =>
      _$PostRightsDtoFromJson(json);

  PostRights toEntity() {
    return PostRights(
      canEdit: canEdit,
      canDelete: canDelete,
      canComment: canComment,
      canLike: canLike,
      canFavorite: canFavorite,
      canShare: canShare,
      canReward: canReward,
      needLike: needLike,
      needComment: needComment,
      needReward: needReward,
    );
  }
}

@freezed
abstract class PostStatusDto with _$PostStatusDto {
  const PostStatusDto._();

  const factory PostStatusDto({
    @Default(false) bool isTop,
    @Default(false) bool isLocked,
    @Default(false) bool isLike,
    @Default(false) bool isFavorited,
  }) = _PostStatusDto;

  factory PostStatusDto.fromJson(Map<String, dynamic> json) =>
      _$PostStatusDtoFromJson(json);

  PostStatus toEntity() {
    return PostStatus(
      isTop: isTop,
      isLocked: isLocked,
      isLike: isLike,
      isFavorited: isFavorited,
    );
  }
}
