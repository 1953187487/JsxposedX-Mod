// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostDto {

 int get id; String get title; String get description; PostCategoryDto get postCategory; String get cover; int get publishTime; CommonUserDto get uploader; PostStatsDto get postStats; List<int> get badges;
/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDtoCopyWith<PostDto> get copyWith => _$PostDtoCopyWithImpl<PostDto>(this as PostDto, _$identity);

  /// Serializes this PostDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.postCategory, postCategory) || other.postCategory == postCategory)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.publishTime, publishTime) || other.publishTime == publishTime)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.postStats, postStats) || other.postStats == postStats)&&const DeepCollectionEquality().equals(other.badges, badges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,postCategory,cover,publishTime,uploader,postStats,const DeepCollectionEquality().hash(badges));

@override
String toString() {
  return 'PostDto(id: $id, title: $title, description: $description, postCategory: $postCategory, cover: $cover, publishTime: $publishTime, uploader: $uploader, postStats: $postStats, badges: $badges)';
}


}

/// @nodoc
abstract mixin class $PostDtoCopyWith<$Res>  {
  factory $PostDtoCopyWith(PostDto value, $Res Function(PostDto) _then) = _$PostDtoCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description, PostCategoryDto postCategory, String cover, int publishTime, CommonUserDto uploader, PostStatsDto postStats, List<int> badges
});


$PostCategoryDtoCopyWith<$Res> get postCategory;$CommonUserDtoCopyWith<$Res> get uploader;$PostStatsDtoCopyWith<$Res> get postStats;

}
/// @nodoc
class _$PostDtoCopyWithImpl<$Res>
    implements $PostDtoCopyWith<$Res> {
  _$PostDtoCopyWithImpl(this._self, this._then);

  final PostDto _self;
  final $Res Function(PostDto) _then;

/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? postCategory = null,Object? cover = null,Object? publishTime = null,Object? uploader = null,Object? postStats = null,Object? badges = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,postCategory: null == postCategory ? _self.postCategory : postCategory // ignore: cast_nullable_to_non_nullable
as PostCategoryDto,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,publishTime: null == publishTime ? _self.publishTime : publishTime // ignore: cast_nullable_to_non_nullable
as int,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as CommonUserDto,postStats: null == postStats ? _self.postStats : postStats // ignore: cast_nullable_to_non_nullable
as PostStatsDto,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCategoryDtoCopyWith<$Res> get postCategory {
  
  return $PostCategoryDtoCopyWith<$Res>(_self.postCategory, (value) {
    return _then(_self.copyWith(postCategory: value));
  });
}/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommonUserDtoCopyWith<$Res> get uploader {
  
  return $CommonUserDtoCopyWith<$Res>(_self.uploader, (value) {
    return _then(_self.copyWith(uploader: value));
  });
}/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatsDtoCopyWith<$Res> get postStats {
  
  return $PostStatsDtoCopyWith<$Res>(_self.postStats, (value) {
    return _then(_self.copyWith(postStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostDto].
extension PostDtoPatterns on PostDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostDto value)  $default,){
final _that = this;
switch (_that) {
case _PostDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostDto value)?  $default,){
final _that = this;
switch (_that) {
case _PostDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description,  PostCategoryDto postCategory,  String cover,  int publishTime,  CommonUserDto uploader,  PostStatsDto postStats,  List<int> badges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.badges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description,  PostCategoryDto postCategory,  String cover,  int publishTime,  CommonUserDto uploader,  PostStatsDto postStats,  List<int> badges)  $default,) {final _that = this;
switch (_that) {
case _PostDto():
return $default(_that.id,_that.title,_that.description,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.badges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description,  PostCategoryDto postCategory,  String cover,  int publishTime,  CommonUserDto uploader,  PostStatsDto postStats,  List<int> badges)?  $default,) {final _that = this;
switch (_that) {
case _PostDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.badges);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostDto extends PostDto {
  const _PostDto({this.id = 0, this.title = "", this.description = "", this.postCategory = const PostCategoryDto(), this.cover = "", this.publishTime = 0, this.uploader = const CommonUserDto(), this.postStats = const PostStatsDto(), final  List<int> badges = const []}): _badges = badges,super._();
  factory _PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  PostCategoryDto postCategory;
@override@JsonKey() final  String cover;
@override@JsonKey() final  int publishTime;
@override@JsonKey() final  CommonUserDto uploader;
@override@JsonKey() final  PostStatsDto postStats;
 final  List<int> _badges;
@override@JsonKey() List<int> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}


/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDtoCopyWith<_PostDto> get copyWith => __$PostDtoCopyWithImpl<_PostDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.postCategory, postCategory) || other.postCategory == postCategory)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.publishTime, publishTime) || other.publishTime == publishTime)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.postStats, postStats) || other.postStats == postStats)&&const DeepCollectionEquality().equals(other._badges, _badges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,postCategory,cover,publishTime,uploader,postStats,const DeepCollectionEquality().hash(_badges));

@override
String toString() {
  return 'PostDto(id: $id, title: $title, description: $description, postCategory: $postCategory, cover: $cover, publishTime: $publishTime, uploader: $uploader, postStats: $postStats, badges: $badges)';
}


}

/// @nodoc
abstract mixin class _$PostDtoCopyWith<$Res> implements $PostDtoCopyWith<$Res> {
  factory _$PostDtoCopyWith(_PostDto value, $Res Function(_PostDto) _then) = __$PostDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description, PostCategoryDto postCategory, String cover, int publishTime, CommonUserDto uploader, PostStatsDto postStats, List<int> badges
});


@override $PostCategoryDtoCopyWith<$Res> get postCategory;@override $CommonUserDtoCopyWith<$Res> get uploader;@override $PostStatsDtoCopyWith<$Res> get postStats;

}
/// @nodoc
class __$PostDtoCopyWithImpl<$Res>
    implements _$PostDtoCopyWith<$Res> {
  __$PostDtoCopyWithImpl(this._self, this._then);

  final _PostDto _self;
  final $Res Function(_PostDto) _then;

/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? postCategory = null,Object? cover = null,Object? publishTime = null,Object? uploader = null,Object? postStats = null,Object? badges = null,}) {
  return _then(_PostDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,postCategory: null == postCategory ? _self.postCategory : postCategory // ignore: cast_nullable_to_non_nullable
as PostCategoryDto,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,publishTime: null == publishTime ? _self.publishTime : publishTime // ignore: cast_nullable_to_non_nullable
as int,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as CommonUserDto,postStats: null == postStats ? _self.postStats : postStats // ignore: cast_nullable_to_non_nullable
as PostStatsDto,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCategoryDtoCopyWith<$Res> get postCategory {
  
  return $PostCategoryDtoCopyWith<$Res>(_self.postCategory, (value) {
    return _then(_self.copyWith(postCategory: value));
  });
}/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommonUserDtoCopyWith<$Res> get uploader {
  
  return $CommonUserDtoCopyWith<$Res>(_self.uploader, (value) {
    return _then(_self.copyWith(uploader: value));
  });
}/// Create a copy of PostDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatsDtoCopyWith<$Res> get postStats {
  
  return $PostStatsDtoCopyWith<$Res>(_self.postStats, (value) {
    return _then(_self.copyWith(postStats: value));
  });
}
}

// dart format on
