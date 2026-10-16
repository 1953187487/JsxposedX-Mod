// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostStats {

 int get viewCount; int get likeCount; int get commentCount; int get favoriteCount; int get shareCount; int get rewardCount;
/// Create a copy of PostStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostStatsCopyWith<PostStats> get copyWith => _$PostStatsCopyWithImpl<PostStats>(this as PostStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostStats&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.rewardCount, rewardCount) || other.rewardCount == rewardCount));
}


@override
int get hashCode => Object.hash(runtimeType,viewCount,likeCount,commentCount,favoriteCount,shareCount,rewardCount);

@override
String toString() {
  return 'PostStats(viewCount: $viewCount, likeCount: $likeCount, commentCount: $commentCount, favoriteCount: $favoriteCount, shareCount: $shareCount, rewardCount: $rewardCount)';
}


}

/// @nodoc
abstract mixin class $PostStatsCopyWith<$Res>  {
  factory $PostStatsCopyWith(PostStats value, $Res Function(PostStats) _then) = _$PostStatsCopyWithImpl;
@useResult
$Res call({
 int viewCount, int likeCount, int commentCount, int favoriteCount, int shareCount, int rewardCount
});




}
/// @nodoc
class _$PostStatsCopyWithImpl<$Res>
    implements $PostStatsCopyWith<$Res> {
  _$PostStatsCopyWithImpl(this._self, this._then);

  final PostStats _self;
  final $Res Function(PostStats) _then;

/// Create a copy of PostStats
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


/// Adds pattern-matching-related methods to [PostStats].
extension PostStatsPatterns on PostStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostStats value)  $default,){
final _that = this;
switch (_that) {
case _PostStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostStats value)?  $default,){
final _that = this;
switch (_that) {
case _PostStats() when $default != null:
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
case _PostStats() when $default != null:
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
case _PostStats():
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
case _PostStats() when $default != null:
return $default(_that.viewCount,_that.likeCount,_that.commentCount,_that.favoriteCount,_that.shareCount,_that.rewardCount);case _:
  return null;

}
}

}

/// @nodoc


class _PostStats extends PostStats {
  const _PostStats({required this.viewCount, required this.likeCount, required this.commentCount, required this.favoriteCount, required this.shareCount, required this.rewardCount}): super._();
  

@override final  int viewCount;
@override final  int likeCount;
@override final  int commentCount;
@override final  int favoriteCount;
@override final  int shareCount;
@override final  int rewardCount;

/// Create a copy of PostStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostStatsCopyWith<_PostStats> get copyWith => __$PostStatsCopyWithImpl<_PostStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostStats&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.rewardCount, rewardCount) || other.rewardCount == rewardCount));
}


@override
int get hashCode => Object.hash(runtimeType,viewCount,likeCount,commentCount,favoriteCount,shareCount,rewardCount);

@override
String toString() {
  return 'PostStats(viewCount: $viewCount, likeCount: $likeCount, commentCount: $commentCount, favoriteCount: $favoriteCount, shareCount: $shareCount, rewardCount: $rewardCount)';
}


}

/// @nodoc
abstract mixin class _$PostStatsCopyWith<$Res> implements $PostStatsCopyWith<$Res> {
  factory _$PostStatsCopyWith(_PostStats value, $Res Function(_PostStats) _then) = __$PostStatsCopyWithImpl;
@override @useResult
$Res call({
 int viewCount, int likeCount, int commentCount, int favoriteCount, int shareCount, int rewardCount
});




}
/// @nodoc
class __$PostStatsCopyWithImpl<$Res>
    implements _$PostStatsCopyWith<$Res> {
  __$PostStatsCopyWithImpl(this._self, this._then);

  final _PostStats _self;
  final $Res Function(_PostStats) _then;

/// Create a copy of PostStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? viewCount = null,Object? likeCount = null,Object? commentCount = null,Object? favoriteCount = null,Object? shareCount = null,Object? rewardCount = null,}) {
  return _then(_PostStats(
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
