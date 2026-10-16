// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_detail_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostDetailDto {

 int get id; String get title; String get description; List<TagDto> get tags; PostCategoryDto get postCategory; String get cover; int get publishTime;@JsonKey(name: 'uploader') CommonUserDto get uploader;@JsonKey(name: 'postStats') PostStatsDto get postStats;@JsonKey(name: 'postRights') PostRightsDto get postRights;@JsonKey(name: 'postStatus') PostStatusDto get postStatus; List<int> get badges; String get content;
/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDetailDtoCopyWith<PostDetailDto> get copyWith => _$PostDetailDtoCopyWithImpl<PostDetailDto>(this as PostDetailDto, _$identity);

  /// Serializes this PostDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.postCategory, postCategory) || other.postCategory == postCategory)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.publishTime, publishTime) || other.publishTime == publishTime)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.postStats, postStats) || other.postStats == postStats)&&(identical(other.postRights, postRights) || other.postRights == postRights)&&(identical(other.postStatus, postStatus) || other.postStatus == postStatus)&&const DeepCollectionEquality().equals(other.badges, badges)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(tags),postCategory,cover,publishTime,uploader,postStats,postRights,postStatus,const DeepCollectionEquality().hash(badges),content);

@override
String toString() {
  return 'PostDetailDto(id: $id, title: $title, description: $description, tags: $tags, postCategory: $postCategory, cover: $cover, publishTime: $publishTime, uploader: $uploader, postStats: $postStats, postRights: $postRights, postStatus: $postStatus, badges: $badges, content: $content)';
}


}

/// @nodoc
abstract mixin class $PostDetailDtoCopyWith<$Res>  {
  factory $PostDetailDtoCopyWith(PostDetailDto value, $Res Function(PostDetailDto) _then) = _$PostDetailDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description, List<TagDto> tags, PostCategoryDto postCategory, String cover, int publishTime,@JsonKey(name: 'uploader') CommonUserDto uploader,@JsonKey(name: 'postStats') PostStatsDto postStats,@JsonKey(name: 'postRights') PostRightsDto postRights,@JsonKey(name: 'postStatus') PostStatusDto postStatus, List<int> badges, String content
});


$PostCategoryDtoCopyWith<$Res> get postCategory;$CommonUserDtoCopyWith<$Res> get uploader;$PostStatsDtoCopyWith<$Res> get postStats;$PostRightsDtoCopyWith<$Res> get postRights;$PostStatusDtoCopyWith<$Res> get postStatus;

}
/// @nodoc
class _$PostDetailDtoCopyWithImpl<$Res>
    implements $PostDetailDtoCopyWith<$Res> {
  _$PostDetailDtoCopyWithImpl(this._self, this._then);

  final PostDetailDto _self;
  final $Res Function(PostDetailDto) _then;

/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? tags = null,Object? postCategory = null,Object? cover = null,Object? publishTime = null,Object? uploader = null,Object? postStats = null,Object? postRights = null,Object? postStatus = null,Object? badges = null,Object? content = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagDto>,postCategory: null == postCategory ? _self.postCategory : postCategory // ignore: cast_nullable_to_non_nullable
as PostCategoryDto,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,publishTime: null == publishTime ? _self.publishTime : publishTime // ignore: cast_nullable_to_non_nullable
as int,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as CommonUserDto,postStats: null == postStats ? _self.postStats : postStats // ignore: cast_nullable_to_non_nullable
as PostStatsDto,postRights: null == postRights ? _self.postRights : postRights // ignore: cast_nullable_to_non_nullable
as PostRightsDto,postStatus: null == postStatus ? _self.postStatus : postStatus // ignore: cast_nullable_to_non_nullable
as PostStatusDto,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<int>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCategoryDtoCopyWith<$Res> get postCategory {
  
  return $PostCategoryDtoCopyWith<$Res>(_self.postCategory, (value) {
    return _then(_self.copyWith(postCategory: value));
  });
}/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommonUserDtoCopyWith<$Res> get uploader {
  
  return $CommonUserDtoCopyWith<$Res>(_self.uploader, (value) {
    return _then(_self.copyWith(uploader: value));
  });
}/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatsDtoCopyWith<$Res> get postStats {
  
  return $PostStatsDtoCopyWith<$Res>(_self.postStats, (value) {
    return _then(_self.copyWith(postStats: value));
  });
}/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRightsDtoCopyWith<$Res> get postRights {
  
  return $PostRightsDtoCopyWith<$Res>(_self.postRights, (value) {
    return _then(_self.copyWith(postRights: value));
  });
}/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatusDtoCopyWith<$Res> get postStatus {
  
  return $PostStatusDtoCopyWith<$Res>(_self.postStatus, (value) {
    return _then(_self.copyWith(postStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostDetailDto].
extension PostDetailDtoPatterns on PostDetailDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostDetailDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _PostDetailDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _PostDetailDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description,  List<TagDto> tags,  PostCategoryDto postCategory,  String cover,  int publishTime, @JsonKey(name: 'uploader')  CommonUserDto uploader, @JsonKey(name: 'postStats')  PostStatsDto postStats, @JsonKey(name: 'postRights')  PostRightsDto postRights, @JsonKey(name: 'postStatus')  PostStatusDto postStatus,  List<int> badges,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostDetailDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.tags,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.postRights,_that.postStatus,_that.badges,_that.content);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description,  List<TagDto> tags,  PostCategoryDto postCategory,  String cover,  int publishTime, @JsonKey(name: 'uploader')  CommonUserDto uploader, @JsonKey(name: 'postStats')  PostStatsDto postStats, @JsonKey(name: 'postRights')  PostRightsDto postRights, @JsonKey(name: 'postStatus')  PostStatusDto postStatus,  List<int> badges,  String content)  $default,) {final _that = this;
switch (_that) {
case _PostDetailDto():
return $default(_that.id,_that.title,_that.description,_that.tags,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.postRights,_that.postStatus,_that.badges,_that.content);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description,  List<TagDto> tags,  PostCategoryDto postCategory,  String cover,  int publishTime, @JsonKey(name: 'uploader')  CommonUserDto uploader, @JsonKey(name: 'postStats')  PostStatsDto postStats, @JsonKey(name: 'postRights')  PostRightsDto postRights, @JsonKey(name: 'postStatus')  PostStatusDto postStatus,  List<int> badges,  String content)?  $default,) {final _that = this;
switch (_that) {
case _PostDetailDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.tags,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.postRights,_that.postStatus,_that.badges,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostDetailDto extends PostDetailDto {
  const _PostDetailDto({this.id = -1, this.title = '', this.description = '', final  List<TagDto> tags = const [], this.postCategory = const PostCategoryDto(), this.cover = '', this.publishTime = 0, @JsonKey(name: 'uploader') this.uploader = const CommonUserDto(), @JsonKey(name: 'postStats') this.postStats = const PostStatsDto(), @JsonKey(name: 'postRights') this.postRights = const PostRightsDto(), @JsonKey(name: 'postStatus') this.postStatus = const PostStatusDto(), final  List<int> badges = const [], this.content = ''}): _tags = tags,_badges = badges,super._();
  factory _PostDetailDto.fromJson(Map<String, dynamic> json) => _$PostDetailDtoFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
 final  List<TagDto> _tags;
@override@JsonKey() List<TagDto> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  PostCategoryDto postCategory;
@override@JsonKey() final  String cover;
@override@JsonKey() final  int publishTime;
@override@JsonKey(name: 'uploader') final  CommonUserDto uploader;
@override@JsonKey(name: 'postStats') final  PostStatsDto postStats;
@override@JsonKey(name: 'postRights') final  PostRightsDto postRights;
@override@JsonKey(name: 'postStatus') final  PostStatusDto postStatus;
 final  List<int> _badges;
@override@JsonKey() List<int> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

@override@JsonKey() final  String content;

/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDetailDtoCopyWith<_PostDetailDto> get copyWith => __$PostDetailDtoCopyWithImpl<_PostDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostDetailDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.postCategory, postCategory) || other.postCategory == postCategory)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.publishTime, publishTime) || other.publishTime == publishTime)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.postStats, postStats) || other.postStats == postStats)&&(identical(other.postRights, postRights) || other.postRights == postRights)&&(identical(other.postStatus, postStatus) || other.postStatus == postStatus)&&const DeepCollectionEquality().equals(other._badges, _badges)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_tags),postCategory,cover,publishTime,uploader,postStats,postRights,postStatus,const DeepCollectionEquality().hash(_badges),content);

@override
String toString() {
  return 'PostDetailDto(id: $id, title: $title, description: $description, tags: $tags, postCategory: $postCategory, cover: $cover, publishTime: $publishTime, uploader: $uploader, postStats: $postStats, postRights: $postRights, postStatus: $postStatus, badges: $badges, content: $content)';
}


}

/// @nodoc
abstract mixin class _$PostDetailDtoCopyWith<$Res> implements $PostDetailDtoCopyWith<$Res> {
  factory _$PostDetailDtoCopyWith(_PostDetailDto value, $Res Function(_PostDetailDto) _then) = __$PostDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description, List<TagDto> tags, PostCategoryDto postCategory, String cover, int publishTime,@JsonKey(name: 'uploader') CommonUserDto uploader,@JsonKey(name: 'postStats') PostStatsDto postStats,@JsonKey(name: 'postRights') PostRightsDto postRights,@JsonKey(name: 'postStatus') PostStatusDto postStatus, List<int> badges, String content
});


@override $PostCategoryDtoCopyWith<$Res> get postCategory;@override $CommonUserDtoCopyWith<$Res> get uploader;@override $PostStatsDtoCopyWith<$Res> get postStats;@override $PostRightsDtoCopyWith<$Res> get postRights;@override $PostStatusDtoCopyWith<$Res> get postStatus;

}
/// @nodoc
class __$PostDetailDtoCopyWithImpl<$Res>
    implements _$PostDetailDtoCopyWith<$Res> {
  __$PostDetailDtoCopyWithImpl(this._self, this._then);

  final _PostDetailDto _self;
  final $Res Function(_PostDetailDto) _then;

/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? tags = null,Object? postCategory = null,Object? cover = null,Object? publishTime = null,Object? uploader = null,Object? postStats = null,Object? postRights = null,Object? postStatus = null,Object? badges = null,Object? content = null,}) {
  return _then(_PostDetailDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TagDto>,postCategory: null == postCategory ? _self.postCategory : postCategory // ignore: cast_nullable_to_non_nullable
as PostCategoryDto,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,publishTime: null == publishTime ? _self.publishTime : publishTime // ignore: cast_nullable_to_non_nullable
as int,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as CommonUserDto,postStats: null == postStats ? _self.postStats : postStats // ignore: cast_nullable_to_non_nullable
as PostStatsDto,postRights: null == postRights ? _self.postRights : postRights // ignore: cast_nullable_to_non_nullable
as PostRightsDto,postStatus: null == postStatus ? _self.postStatus : postStatus // ignore: cast_nullable_to_non_nullable
as PostStatusDto,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<int>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCategoryDtoCopyWith<$Res> get postCategory {
  
  return $PostCategoryDtoCopyWith<$Res>(_self.postCategory, (value) {
    return _then(_self.copyWith(postCategory: value));
  });
}/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommonUserDtoCopyWith<$Res> get uploader {
  
  return $CommonUserDtoCopyWith<$Res>(_self.uploader, (value) {
    return _then(_self.copyWith(uploader: value));
  });
}/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatsDtoCopyWith<$Res> get postStats {
  
  return $PostStatsDtoCopyWith<$Res>(_self.postStats, (value) {
    return _then(_self.copyWith(postStats: value));
  });
}/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRightsDtoCopyWith<$Res> get postRights {
  
  return $PostRightsDtoCopyWith<$Res>(_self.postRights, (value) {
    return _then(_self.copyWith(postRights: value));
  });
}/// Create a copy of PostDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatusDtoCopyWith<$Res> get postStatus {
  
  return $PostStatusDtoCopyWith<$Res>(_self.postStatus, (value) {
    return _then(_self.copyWith(postStatus: value));
  });
}
}


/// @nodoc
mixin _$TagDto {

 int get id;@JsonKey(name: 'tagName') String get tagName; int get hotValue; int get clicks;
/// Create a copy of TagDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagDtoCopyWith<TagDto> get copyWith => _$TagDtoCopyWithImpl<TagDto>(this as TagDto, _$identity);

  /// Serializes this TagDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagDto&&(identical(other.id, id) || other.id == id)&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.hotValue, hotValue) || other.hotValue == hotValue)&&(identical(other.clicks, clicks) || other.clicks == clicks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tagName,hotValue,clicks);

@override
String toString() {
  return 'TagDto(id: $id, tagName: $tagName, hotValue: $hotValue, clicks: $clicks)';
}


}

/// @nodoc
abstract mixin class $TagDtoCopyWith<$Res>  {
  factory $TagDtoCopyWith(TagDto value, $Res Function(TagDto) _then) = _$TagDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'tagName') String tagName, int hotValue, int clicks
});




}
/// @nodoc
class _$TagDtoCopyWithImpl<$Res>
    implements $TagDtoCopyWith<$Res> {
  _$TagDtoCopyWithImpl(this._self, this._then);

  final TagDto _self;
  final $Res Function(TagDto) _then;

/// Create a copy of TagDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tagName = null,Object? hotValue = null,Object? clicks = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,hotValue: null == hotValue ? _self.hotValue : hotValue // ignore: cast_nullable_to_non_nullable
as int,clicks: null == clicks ? _self.clicks : clicks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TagDto].
extension TagDtoPatterns on TagDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagDto value)  $default,){
final _that = this;
switch (_that) {
case _TagDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagDto value)?  $default,){
final _that = this;
switch (_that) {
case _TagDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'tagName')  String tagName,  int hotValue,  int clicks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagDto() when $default != null:
return $default(_that.id,_that.tagName,_that.hotValue,_that.clicks);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'tagName')  String tagName,  int hotValue,  int clicks)  $default,) {final _that = this;
switch (_that) {
case _TagDto():
return $default(_that.id,_that.tagName,_that.hotValue,_that.clicks);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'tagName')  String tagName,  int hotValue,  int clicks)?  $default,) {final _that = this;
switch (_that) {
case _TagDto() when $default != null:
return $default(_that.id,_that.tagName,_that.hotValue,_that.clicks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TagDto extends TagDto {
  const _TagDto({this.id = -1, @JsonKey(name: 'tagName') this.tagName = '', this.hotValue = 0, this.clicks = 0}): super._();
  factory _TagDto.fromJson(Map<String, dynamic> json) => _$TagDtoFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey(name: 'tagName') final  String tagName;
@override@JsonKey() final  int hotValue;
@override@JsonKey() final  int clicks;

/// Create a copy of TagDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagDtoCopyWith<_TagDto> get copyWith => __$TagDtoCopyWithImpl<_TagDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagDto&&(identical(other.id, id) || other.id == id)&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.hotValue, hotValue) || other.hotValue == hotValue)&&(identical(other.clicks, clicks) || other.clicks == clicks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tagName,hotValue,clicks);

@override
String toString() {
  return 'TagDto(id: $id, tagName: $tagName, hotValue: $hotValue, clicks: $clicks)';
}


}

/// @nodoc
abstract mixin class _$TagDtoCopyWith<$Res> implements $TagDtoCopyWith<$Res> {
  factory _$TagDtoCopyWith(_TagDto value, $Res Function(_TagDto) _then) = __$TagDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'tagName') String tagName, int hotValue, int clicks
});




}
/// @nodoc
class __$TagDtoCopyWithImpl<$Res>
    implements _$TagDtoCopyWith<$Res> {
  __$TagDtoCopyWithImpl(this._self, this._then);

  final _TagDto _self;
  final $Res Function(_TagDto) _then;

/// Create a copy of TagDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tagName = null,Object? hotValue = null,Object? clicks = null,}) {
  return _then(_TagDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,hotValue: null == hotValue ? _self.hotValue : hotValue // ignore: cast_nullable_to_non_nullable
as int,clicks: null == clicks ? _self.clicks : clicks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PostRightsDto {

 bool get canEdit; bool get canDelete; bool get canComment; bool get canLike; bool get canFavorite; bool get canShare; bool get canReward; bool get needLike; bool get needComment; bool get needReward;
/// Create a copy of PostRightsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostRightsDtoCopyWith<PostRightsDto> get copyWith => _$PostRightsDtoCopyWithImpl<PostRightsDto>(this as PostRightsDto, _$identity);

  /// Serializes this PostRightsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostRightsDto&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canLike, canLike) || other.canLike == canLike)&&(identical(other.canFavorite, canFavorite) || other.canFavorite == canFavorite)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canReward, canReward) || other.canReward == canReward)&&(identical(other.needLike, needLike) || other.needLike == needLike)&&(identical(other.needComment, needComment) || other.needComment == needComment)&&(identical(other.needReward, needReward) || other.needReward == needReward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canEdit,canDelete,canComment,canLike,canFavorite,canShare,canReward,needLike,needComment,needReward);

@override
String toString() {
  return 'PostRightsDto(canEdit: $canEdit, canDelete: $canDelete, canComment: $canComment, canLike: $canLike, canFavorite: $canFavorite, canShare: $canShare, canReward: $canReward, needLike: $needLike, needComment: $needComment, needReward: $needReward)';
}


}

/// @nodoc
abstract mixin class $PostRightsDtoCopyWith<$Res>  {
  factory $PostRightsDtoCopyWith(PostRightsDto value, $Res Function(PostRightsDto) _then) = _$PostRightsDtoCopyWithImpl;
@useResult
$Res call({
 bool canEdit, bool canDelete, bool canComment, bool canLike, bool canFavorite, bool canShare, bool canReward, bool needLike, bool needComment, bool needReward
});




}
/// @nodoc
class _$PostRightsDtoCopyWithImpl<$Res>
    implements $PostRightsDtoCopyWith<$Res> {
  _$PostRightsDtoCopyWithImpl(this._self, this._then);

  final PostRightsDto _self;
  final $Res Function(PostRightsDto) _then;

/// Create a copy of PostRightsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canEdit = null,Object? canDelete = null,Object? canComment = null,Object? canLike = null,Object? canFavorite = null,Object? canShare = null,Object? canReward = null,Object? needLike = null,Object? needComment = null,Object? needReward = null,}) {
  return _then(_self.copyWith(
canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canLike: null == canLike ? _self.canLike : canLike // ignore: cast_nullable_to_non_nullable
as bool,canFavorite: null == canFavorite ? _self.canFavorite : canFavorite // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canReward: null == canReward ? _self.canReward : canReward // ignore: cast_nullable_to_non_nullable
as bool,needLike: null == needLike ? _self.needLike : needLike // ignore: cast_nullable_to_non_nullable
as bool,needComment: null == needComment ? _self.needComment : needComment // ignore: cast_nullable_to_non_nullable
as bool,needReward: null == needReward ? _self.needReward : needReward // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PostRightsDto].
extension PostRightsDtoPatterns on PostRightsDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostRightsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostRightsDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostRightsDto value)  $default,){
final _that = this;
switch (_that) {
case _PostRightsDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostRightsDto value)?  $default,){
final _that = this;
switch (_that) {
case _PostRightsDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool canEdit,  bool canDelete,  bool canComment,  bool canLike,  bool canFavorite,  bool canShare,  bool canReward,  bool needLike,  bool needComment,  bool needReward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostRightsDto() when $default != null:
return $default(_that.canEdit,_that.canDelete,_that.canComment,_that.canLike,_that.canFavorite,_that.canShare,_that.canReward,_that.needLike,_that.needComment,_that.needReward);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool canEdit,  bool canDelete,  bool canComment,  bool canLike,  bool canFavorite,  bool canShare,  bool canReward,  bool needLike,  bool needComment,  bool needReward)  $default,) {final _that = this;
switch (_that) {
case _PostRightsDto():
return $default(_that.canEdit,_that.canDelete,_that.canComment,_that.canLike,_that.canFavorite,_that.canShare,_that.canReward,_that.needLike,_that.needComment,_that.needReward);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool canEdit,  bool canDelete,  bool canComment,  bool canLike,  bool canFavorite,  bool canShare,  bool canReward,  bool needLike,  bool needComment,  bool needReward)?  $default,) {final _that = this;
switch (_that) {
case _PostRightsDto() when $default != null:
return $default(_that.canEdit,_that.canDelete,_that.canComment,_that.canLike,_that.canFavorite,_that.canShare,_that.canReward,_that.needLike,_that.needComment,_that.needReward);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostRightsDto extends PostRightsDto {
  const _PostRightsDto({this.canEdit = false, this.canDelete = false, this.canComment = true, this.canLike = true, this.canFavorite = true, this.canShare = true, this.canReward = false, this.needLike = false, this.needComment = false, this.needReward = false}): super._();
  factory _PostRightsDto.fromJson(Map<String, dynamic> json) => _$PostRightsDtoFromJson(json);

@override@JsonKey() final  bool canEdit;
@override@JsonKey() final  bool canDelete;
@override@JsonKey() final  bool canComment;
@override@JsonKey() final  bool canLike;
@override@JsonKey() final  bool canFavorite;
@override@JsonKey() final  bool canShare;
@override@JsonKey() final  bool canReward;
@override@JsonKey() final  bool needLike;
@override@JsonKey() final  bool needComment;
@override@JsonKey() final  bool needReward;

/// Create a copy of PostRightsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostRightsDtoCopyWith<_PostRightsDto> get copyWith => __$PostRightsDtoCopyWithImpl<_PostRightsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostRightsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostRightsDto&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canLike, canLike) || other.canLike == canLike)&&(identical(other.canFavorite, canFavorite) || other.canFavorite == canFavorite)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canReward, canReward) || other.canReward == canReward)&&(identical(other.needLike, needLike) || other.needLike == needLike)&&(identical(other.needComment, needComment) || other.needComment == needComment)&&(identical(other.needReward, needReward) || other.needReward == needReward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canEdit,canDelete,canComment,canLike,canFavorite,canShare,canReward,needLike,needComment,needReward);

@override
String toString() {
  return 'PostRightsDto(canEdit: $canEdit, canDelete: $canDelete, canComment: $canComment, canLike: $canLike, canFavorite: $canFavorite, canShare: $canShare, canReward: $canReward, needLike: $needLike, needComment: $needComment, needReward: $needReward)';
}


}

/// @nodoc
abstract mixin class _$PostRightsDtoCopyWith<$Res> implements $PostRightsDtoCopyWith<$Res> {
  factory _$PostRightsDtoCopyWith(_PostRightsDto value, $Res Function(_PostRightsDto) _then) = __$PostRightsDtoCopyWithImpl;
@override @useResult
$Res call({
 bool canEdit, bool canDelete, bool canComment, bool canLike, bool canFavorite, bool canShare, bool canReward, bool needLike, bool needComment, bool needReward
});




}
/// @nodoc
class __$PostRightsDtoCopyWithImpl<$Res>
    implements _$PostRightsDtoCopyWith<$Res> {
  __$PostRightsDtoCopyWithImpl(this._self, this._then);

  final _PostRightsDto _self;
  final $Res Function(_PostRightsDto) _then;

/// Create a copy of PostRightsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canEdit = null,Object? canDelete = null,Object? canComment = null,Object? canLike = null,Object? canFavorite = null,Object? canShare = null,Object? canReward = null,Object? needLike = null,Object? needComment = null,Object? needReward = null,}) {
  return _then(_PostRightsDto(
canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,canComment: null == canComment ? _self.canComment : canComment // ignore: cast_nullable_to_non_nullable
as bool,canLike: null == canLike ? _self.canLike : canLike // ignore: cast_nullable_to_non_nullable
as bool,canFavorite: null == canFavorite ? _self.canFavorite : canFavorite // ignore: cast_nullable_to_non_nullable
as bool,canShare: null == canShare ? _self.canShare : canShare // ignore: cast_nullable_to_non_nullable
as bool,canReward: null == canReward ? _self.canReward : canReward // ignore: cast_nullable_to_non_nullable
as bool,needLike: null == needLike ? _self.needLike : needLike // ignore: cast_nullable_to_non_nullable
as bool,needComment: null == needComment ? _self.needComment : needComment // ignore: cast_nullable_to_non_nullable
as bool,needReward: null == needReward ? _self.needReward : needReward // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PostStatusDto {

 bool get isTop; bool get isLocked; bool get isLike; bool get isFavorited;
/// Create a copy of PostStatusDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostStatusDtoCopyWith<PostStatusDto> get copyWith => _$PostStatusDtoCopyWithImpl<PostStatusDto>(this as PostStatusDto, _$identity);

  /// Serializes this PostStatusDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostStatusDto&&(identical(other.isTop, isTop) || other.isTop == isTop)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isLike, isLike) || other.isLike == isLike)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isTop,isLocked,isLike,isFavorited);

@override
String toString() {
  return 'PostStatusDto(isTop: $isTop, isLocked: $isLocked, isLike: $isLike, isFavorited: $isFavorited)';
}


}

/// @nodoc
abstract mixin class $PostStatusDtoCopyWith<$Res>  {
  factory $PostStatusDtoCopyWith(PostStatusDto value, $Res Function(PostStatusDto) _then) = _$PostStatusDtoCopyWithImpl;
@useResult
$Res call({
 bool isTop, bool isLocked, bool isLike, bool isFavorited
});




}
/// @nodoc
class _$PostStatusDtoCopyWithImpl<$Res>
    implements $PostStatusDtoCopyWith<$Res> {
  _$PostStatusDtoCopyWithImpl(this._self, this._then);

  final PostStatusDto _self;
  final $Res Function(PostStatusDto) _then;

/// Create a copy of PostStatusDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isTop = null,Object? isLocked = null,Object? isLike = null,Object? isFavorited = null,}) {
  return _then(_self.copyWith(
isTop: null == isTop ? _self.isTop : isTop // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,isLike: null == isLike ? _self.isLike : isLike // ignore: cast_nullable_to_non_nullable
as bool,isFavorited: null == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PostStatusDto].
extension PostStatusDtoPatterns on PostStatusDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostStatusDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostStatusDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostStatusDto value)  $default,){
final _that = this;
switch (_that) {
case _PostStatusDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostStatusDto value)?  $default,){
final _that = this;
switch (_that) {
case _PostStatusDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isTop,  bool isLocked,  bool isLike,  bool isFavorited)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostStatusDto() when $default != null:
return $default(_that.isTop,_that.isLocked,_that.isLike,_that.isFavorited);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isTop,  bool isLocked,  bool isLike,  bool isFavorited)  $default,) {final _that = this;
switch (_that) {
case _PostStatusDto():
return $default(_that.isTop,_that.isLocked,_that.isLike,_that.isFavorited);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isTop,  bool isLocked,  bool isLike,  bool isFavorited)?  $default,) {final _that = this;
switch (_that) {
case _PostStatusDto() when $default != null:
return $default(_that.isTop,_that.isLocked,_that.isLike,_that.isFavorited);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostStatusDto extends PostStatusDto {
  const _PostStatusDto({this.isTop = false, this.isLocked = false, this.isLike = false, this.isFavorited = false}): super._();
  factory _PostStatusDto.fromJson(Map<String, dynamic> json) => _$PostStatusDtoFromJson(json);

@override@JsonKey() final  bool isTop;
@override@JsonKey() final  bool isLocked;
@override@JsonKey() final  bool isLike;
@override@JsonKey() final  bool isFavorited;

/// Create a copy of PostStatusDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostStatusDtoCopyWith<_PostStatusDto> get copyWith => __$PostStatusDtoCopyWithImpl<_PostStatusDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostStatusDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostStatusDto&&(identical(other.isTop, isTop) || other.isTop == isTop)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isLike, isLike) || other.isLike == isLike)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isTop,isLocked,isLike,isFavorited);

@override
String toString() {
  return 'PostStatusDto(isTop: $isTop, isLocked: $isLocked, isLike: $isLike, isFavorited: $isFavorited)';
}


}

/// @nodoc
abstract mixin class _$PostStatusDtoCopyWith<$Res> implements $PostStatusDtoCopyWith<$Res> {
  factory _$PostStatusDtoCopyWith(_PostStatusDto value, $Res Function(_PostStatusDto) _then) = __$PostStatusDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isTop, bool isLocked, bool isLike, bool isFavorited
});




}
/// @nodoc
class __$PostStatusDtoCopyWithImpl<$Res>
    implements _$PostStatusDtoCopyWith<$Res> {
  __$PostStatusDtoCopyWithImpl(this._self, this._then);

  final _PostStatusDto _self;
  final $Res Function(_PostStatusDto) _then;

/// Create a copy of PostStatusDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isTop = null,Object? isLocked = null,Object? isLike = null,Object? isFavorited = null,}) {
  return _then(_PostStatusDto(
isTop: null == isTop ? _self.isTop : isTop // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,isLike: null == isLike ? _self.isLike : isLike // ignore: cast_nullable_to_non_nullable
as bool,isFavorited: null == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
