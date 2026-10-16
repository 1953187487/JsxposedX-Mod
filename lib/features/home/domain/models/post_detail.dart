import 'package:JsxposedX/features/home/domain/models/common_user.dart';
import 'package:JsxposedX/features/home/domain/models/post_category.dart';
import 'package:JsxposedX/features/home/domain/models/post_stats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_detail.freezed.dart';

@freezed
abstract class PostDetail with _$PostDetail {
  const PostDetail._();

  const factory PostDetail({
    required int id,
    required String title,
    required String description,
    required List<Tag> tags,
    required PostCategory postCategory,
    required String cover,
    required int publishTime,
    required CommonUser uploader,
    required PostStats postStats,
    required PostRights postRights,
    required PostStatus postStatus,
    required List<int> badges,
    required String content,
  }) = _PostDetail;
}

/// 标签业务实体
@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    required int id,
    required String tagName,
    required int hotValue, // 热度值
    required int clicks,
  }) = _Tag;
}

@freezed
abstract class PostRights with _$PostRights {
  const factory PostRights({
    required bool canEdit,
    required bool canDelete,
    required bool canComment,
    required bool canLike,
    required bool canFavorite,
    required bool canShare,
    required bool canReward,
    required bool needLike,
    required bool needComment,
    required bool needReward,
  }) = _PostRights;
}

@freezed
abstract class PostStatus with _$PostStatus {
  const factory PostStatus({
    /// 是否置顶标识
    required bool isTop,

    /// 是否锁定标识
    required bool isLocked,

    /// 是否点赞标识
    required bool isLike,

    /// 是否收藏标识
    required bool isFavorited,
  }) = _PostStatus;
}
