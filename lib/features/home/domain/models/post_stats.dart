import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_stats.freezed.dart';

@freezed
abstract class PostStats with _$PostStats {
  const PostStats._();

  const factory PostStats({
    required int viewCount,
    required int likeCount,
    required int commentCount,
    required int favoriteCount,
    required int shareCount,
    required int rewardCount,
  }) = _PostStats;
}
