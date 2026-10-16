import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/home/domain/models/post_stats.dart';

part 'post_stats_dto.freezed.dart';
part 'post_stats_dto.g.dart';

@freezed
abstract class PostStatsDto with _$PostStatsDto {
  const PostStatsDto._();

  const factory PostStatsDto({
    @Default(0) int viewCount,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(0) int favoriteCount,
    @Default(0) int shareCount,
    @Default(0) int rewardCount,
  }) = _PostStatsDto;

  factory PostStatsDto.fromJson(Map<String, dynamic> json) =>
      _$PostStatsDtoFromJson(json);

  PostStats toEntity() {
    return PostStats(
      viewCount: viewCount,
      likeCount: likeCount,
      commentCount: commentCount,
      favoriteCount: favoriteCount,
      shareCount: shareCount,
      rewardCount: rewardCount,
    );
  }
}
