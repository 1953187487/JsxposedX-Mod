// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostDetailDto _$PostDetailDtoFromJson(Map<String, dynamic> json) =>
    _PostDetailDto(
      id: (json['id'] as num?)?.toInt() ?? -1,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => TagDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      postCategory: json['postCategory'] == null
          ? const PostCategoryDto()
          : PostCategoryDto.fromJson(
              json['postCategory'] as Map<String, dynamic>,
            ),
      cover: json['cover'] as String? ?? '',
      publishTime: (json['publishTime'] as num?)?.toInt() ?? 0,
      uploader: json['uploader'] == null
          ? const CommonUserDto()
          : CommonUserDto.fromJson(json['uploader'] as Map<String, dynamic>),
      postStats: json['postStats'] == null
          ? const PostStatsDto()
          : PostStatsDto.fromJson(json['postStats'] as Map<String, dynamic>),
      postRights: json['postRights'] == null
          ? const PostRightsDto()
          : PostRightsDto.fromJson(json['postRights'] as Map<String, dynamic>),
      postStatus: json['postStatus'] == null
          ? const PostStatusDto()
          : PostStatusDto.fromJson(json['postStatus'] as Map<String, dynamic>),
      badges:
          (json['badges'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      content: json['content'] as String? ?? '',
    );

Map<String, dynamic> _$PostDetailDtoToJson(_PostDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags,
      'postCategory': instance.postCategory,
      'cover': instance.cover,
      'publishTime': instance.publishTime,
      'uploader': instance.uploader,
      'postStats': instance.postStats,
      'postRights': instance.postRights,
      'postStatus': instance.postStatus,
      'badges': instance.badges,
      'content': instance.content,
    };

_TagDto _$TagDtoFromJson(Map<String, dynamic> json) => _TagDto(
  id: (json['id'] as num?)?.toInt() ?? -1,
  tagName: json['tagName'] as String? ?? '',
  hotValue: (json['hotValue'] as num?)?.toInt() ?? 0,
  clicks: (json['clicks'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TagDtoToJson(_TagDto instance) => <String, dynamic>{
  'id': instance.id,
  'tagName': instance.tagName,
  'hotValue': instance.hotValue,
  'clicks': instance.clicks,
};

_PostRightsDto _$PostRightsDtoFromJson(Map<String, dynamic> json) =>
    _PostRightsDto(
      canEdit: json['canEdit'] as bool? ?? false,
      canDelete: json['canDelete'] as bool? ?? false,
      canComment: json['canComment'] as bool? ?? true,
      canLike: json['canLike'] as bool? ?? true,
      canFavorite: json['canFavorite'] as bool? ?? true,
      canShare: json['canShare'] as bool? ?? true,
      canReward: json['canReward'] as bool? ?? false,
      needLike: json['needLike'] as bool? ?? false,
      needComment: json['needComment'] as bool? ?? false,
      needReward: json['needReward'] as bool? ?? false,
    );

Map<String, dynamic> _$PostRightsDtoToJson(_PostRightsDto instance) =>
    <String, dynamic>{
      'canEdit': instance.canEdit,
      'canDelete': instance.canDelete,
      'canComment': instance.canComment,
      'canLike': instance.canLike,
      'canFavorite': instance.canFavorite,
      'canShare': instance.canShare,
      'canReward': instance.canReward,
      'needLike': instance.needLike,
      'needComment': instance.needComment,
      'needReward': instance.needReward,
    };

_PostStatusDto _$PostStatusDtoFromJson(Map<String, dynamic> json) =>
    _PostStatusDto(
      isTop: json['isTop'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
      isLike: json['isLike'] as bool? ?? false,
      isFavorited: json['isFavorited'] as bool? ?? false,
    );

Map<String, dynamic> _$PostStatusDtoToJson(_PostStatusDto instance) =>
    <String, dynamic>{
      'isTop': instance.isTop,
      'isLocked': instance.isLocked,
      'isLike': instance.isLike,
      'isFavorited': instance.isFavorited,
    };
