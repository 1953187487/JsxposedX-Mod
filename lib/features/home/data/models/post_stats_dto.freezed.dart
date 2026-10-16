// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_stats_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostStatsDto {

 int get viewCount; int get likeCount; int get commentCount; int get favoriteCount; int get shareCount; int get rewardCount;
/// Create a copy of PostStatsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostStatsDtoCopyWith<PostStatsDto> get copyWith => _$PostStatsDtoCopyWithImpl<PostStatsDto>(this as PostStatsDto, _$identity);

  /// Serializes this PostStatsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostStatsDto&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.rewardCount, rewardCount) || other.rewardCount == rewardCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,viewCount,likeCount,commentCount,favoriteCount,shareCount,rewardCount);

@override
String toString() {
  return 'PostStatsDto(viewCount: $viewCount, likeCount: $likeCount, commentCount: $commentCount, favoriteCount: $favoriteCount, shareCount: $shareCount, rewardCount: $rewardCount)';
}


}

/// @nodoc
abstract mixin class $PostStatsDtoCopyWith<$Res>  {
  factory $PostStatsDtoCopyWith(PostStatsDto value, $Res Function(PostStatsDto) _then) = _$PostStatsDtoCopyWithImpl;
@useResult
$Res call({
 int viewCount, int likeCount, int commentCount, int favoriteCount, int shareCount, int rewardCount
});




}
/// @nodoc
class _$PostStatsDtoCopyWithImpl<$Res>
    implements $PostStatsDtoCopyWith<$Res> {
  _$PostStatsDtoCopyWithImpl(this._self, this._then);

  final PostStatsDto _self;
  final $Res Function(PostStatsDto) _then;

/// Create a copy of PostStatsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? viewCount = null,Object? likeCount = null,Object? commentCount = null,Object? favoriteCount = null,Object? shareCount = null,Object? rewardCount = null,}) {
  return _then(_self.copyWith(
viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,rewardCount: null == rewardCount ? _self.rewardCount : rewardCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PostStatsDto].
extension PostStatsDtoPatterns on PostStatsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostStatsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostStatsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostStatsDto value)  $default,){
final _that = this;
switch (_that) {
case _PostStatsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostStatsDto value)?  $default,){
final _that = this;
switch (_that) {
case _PostStatsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int viewCount,  int likeCount,  int commentCount,  int favoriteCount,  int shareCount,  int rewardCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostStatsDto() when $default != null:
return $default(_that.viewCount,_that.likeCount,_that.commentCount,_that.favoriteCount,_that.shareCount,_that.rewardCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int viewCount,  int likeCount,  int commentCount,  int favoriteCount,  int shareCount,  int rewardCount)  $default,) {final _that = this;
switch (_that) {
case _PostStatsDto():
return $default(_that.viewCount,_that.likeCount,_that.commentCount,_that.favoriteCount,_that.shareCount,_that.rewardCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int viewCount,  int likeCount,  int commentCount,  int favoriteCount,  int shareCount,  int rewardCount)?  $default,) {final _that = this;
switch (_that) {
case _PostStatsDto() when $default != null:
return $default(_that.viewCount,_that.likeCount,_that.commentCount,_that.favoriteCount,_that.shareCount,_that.rewardCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostStatsDto extends PostStatsDto {
  const _PostStatsDto({this.viewCount = 0, this.likeCount = 0, this.commentCount = 0, this.favoriteCount = 0, this.shareCount = 0, this.rewardCount = 0}): super._();
  factory _PostStatsDto.fromJson(Map<String, dynamic> json) => _$PostStatsDtoFromJson(json);

@override@JsonKey() final  int viewCount;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  int commentCount;
@override@JsonKey() final  int favoriteCount;
@override@JsonKey() final  int shareCount;
@override@JsonKey() final  int rewardCount;

/// Create a copy of PostStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostStatsDtoCopyWith<_PostStatsDto> get copyWith => __$PostStatsDtoCopyWithImpl<_PostStatsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostStatsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostStatsDto&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.rewardCount, rewardCount) || other.rewardCount == rewardCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,viewCount,likeCount,commentCount,favoriteCount,shareCount,rewardCount);

@override
String toString() {
  return 'PostStatsDto(viewCount: $viewCount, likeCount: $likeCount, commentCount: $commentCount, favoriteCount: $favoriteCount, shareCount: $shareCount, rewardCount: $rewardCount)';
}


}

/// @nodoc
abstract mixin class _$PostStatsDtoCopyWith<$Res> implements $PostStatsDtoCopyWith<$Res> {
  factory _$PostStatsDtoCopyWith(_PostStatsDto value, $Res Function(_PostStatsDto) _then) = __$PostStatsDtoCopyWithImpl;
@override @useResult
$Res call({
 int viewCount, int likeCount, int commentCount, int favoriteCount, int shareCount, int rewardCount
});




}
/// @nodoc
class __$PostStatsDtoCopyWithImpl<$Res>
    implements _$PostStatsDtoCopyWith<$Res> {
  __$PostStatsDtoCopyWithImpl(this._self, this._then);

  final _PostStatsDto _self;
  final $Res Function(_PostStatsDto) _then;

/// Create a copy of PostStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? viewCount = null,Object? likeCount = null,Object? commentCount = null,Object? favoriteCount = null,Object? shareCount = null,Object? rewardCount = null,}) {
  return _then(_PostStatsDto(
viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,rewardCount: null == rewardCount ? _self.rewardCount : rewardCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
