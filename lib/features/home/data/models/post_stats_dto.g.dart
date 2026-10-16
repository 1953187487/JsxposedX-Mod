// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostStatsDto _$PostStatsDtoFromJson(Map<String, dynamic> json) =>
    _PostStatsDto(
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
      rewardCount: (json['rewardCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PostStatsDtoToJson(_PostStatsDto instance) =>
    <String, dynamic>{
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'favoriteCount': instance.favoriteCount,
      'shareCount': instance.shareCount,
      'rewardCount': instance.rewardCount,
    };
