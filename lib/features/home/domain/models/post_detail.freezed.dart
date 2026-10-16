// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostDetail {

 int get id; String get title; String get description; List<Tag> get tags; PostCategory get postCategory; String get cover; int get publishTime; CommonUser get uploader; PostStats get postStats; PostRights get postRights; PostStatus get postStatus; List<int> get badges; String get content;
/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDetailCopyWith<PostDetail> get copyWith => _$PostDetailCopyWithImpl<PostDetail>(this as PostDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.postCategory, postCategory) || other.postCategory == postCategory)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.publishTime, publishTime) || other.publishTime == publishTime)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.postStats, postStats) || other.postStats == postStats)&&(identical(other.postRights, postRights) || other.postRights == postRights)&&(identical(other.postStatus, postStatus) || other.postStatus == postStatus)&&const DeepCollectionEquality().equals(other.badges, badges)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(tags),postCategory,cover,publishTime,uploader,postStats,postRights,postStatus,const DeepCollectionEquality().hash(badges),content);

@override
String toString() {
  return 'PostDetail(id: $id, title: $title, description: $description, tags: $tags, postCategory: $postCategory, cover: $cover, publishTime: $publishTime, uploader: $uploader, postStats: $postStats, postRights: $postRights, postStatus: $postStatus, badges: $badges, content: $content)';
}


}

/// @nodoc
abstract mixin class $PostDetailCopyWith<$Res>  {
  factory $PostDetailCopyWith(PostDetail value, $Res Function(PostDetail) _then) = _$PostDetailCopyWithImpl;
@useResult
$Res call({
 int id, String title, String description, List<Tag> tags, PostCategory postCategory, String cover, int publishTime, CommonUser uploader, PostStats postStats, PostRights postRights, PostStatus postStatus, List<int> badges, String content
});


$PostCategoryCopyWith<$Res> get postCategory;$CommonUserCopyWith<$Res> get uploader;$PostStatsCopyWith<$Res> get postStats;$PostRightsCopyWith<$Res> get postRights;$PostStatusCopyWith<$Res> get postStatus;

}
/// @nodoc
class _$PostDetailCopyWithImpl<$Res>
    implements $PostDetailCopyWith<$Res> {
  _$PostDetailCopyWithImpl(this._self, this._then);

  final PostDetail _self;
  final $Res Function(PostDetail) _then;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? tags = null,Object? postCategory = null,Object? cover = null,Object? publishTime = null,Object? uploader = null,Object? postStats = null,Object? postRights = null,Object? postStatus = null,Object? badges = null,Object? content = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,postCategory: null == postCategory ? _self.postCategory : postCategory // ignore: cast_nullable_to_non_nullable
as PostCategory,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,publishTime: null == publishTime ? _self.publishTime : publishTime // ignore: cast_nullable_to_non_nullable
as int,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as CommonUser,postStats: null == postStats ? _self.postStats : postStats // ignore: cast_nullable_to_non_nullable
as PostStats,postRights: null == postRights ? _self.postRights : postRights // ignore: cast_nullable_to_non_nullable
as PostRights,postStatus: null == postStatus ? _self.postStatus : postStatus // ignore: cast_nullable_to_non_nullable
as PostStatus,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<int>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCategoryCopyWith<$Res> get postCategory {
  
  return $PostCategoryCopyWith<$Res>(_self.postCategory, (value) {
    return _then(_self.copyWith(postCategory: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommonUserCopyWith<$Res> get uploader {
  
  return $CommonUserCopyWith<$Res>(_self.uploader, (value) {
    return _then(_self.copyWith(uploader: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatsCopyWith<$Res> get postStats {
  
  return $PostStatsCopyWith<$Res>(_self.postStats, (value) {
    return _then(_self.copyWith(postStats: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRightsCopyWith<$Res> get postRights {
  
  return $PostRightsCopyWith<$Res>(_self.postRights, (value) {
    return _then(_self.copyWith(postRights: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatusCopyWith<$Res> get postStatus {
  
  return $PostStatusCopyWith<$Res>(_self.postStatus, (value) {
    return _then(_self.copyWith(postStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostDetail].
extension PostDetailPatterns on PostDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostDetail value)  $default,){
final _that = this;
switch (_that) {
case _PostDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String description,  List<Tag> tags,  PostCategory postCategory,  String cover,  int publishTime,  CommonUser uploader,  PostStats postStats,  PostRights postRights,  PostStatus postStatus,  List<int> badges,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String description,  List<Tag> tags,  PostCategory postCategory,  String cover,  int publishTime,  CommonUser uploader,  PostStats postStats,  PostRights postRights,  PostStatus postStatus,  List<int> badges,  String content)  $default,) {final _that = this;
switch (_that) {
case _PostDetail():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String description,  List<Tag> tags,  PostCategory postCategory,  String cover,  int publishTime,  CommonUser uploader,  PostStats postStats,  PostRights postRights,  PostStatus postStatus,  List<int> badges,  String content)?  $default,) {final _that = this;
switch (_that) {
case _PostDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.tags,_that.postCategory,_that.cover,_that.publishTime,_that.uploader,_that.postStats,_that.postRights,_that.postStatus,_that.badges,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _PostDetail extends PostDetail {
  const _PostDetail({required this.id, required this.title, required this.description, required final  List<Tag> tags, required this.postCategory, required this.cover, required this.publishTime, required this.uploader, required this.postStats, required this.postRights, required this.postStatus, required final  List<int> badges, required this.content}): _tags = tags,_badges = badges,super._();
  

@override final  int id;
@override final  String title;
@override final  String description;
 final  List<Tag> _tags;
@override List<Tag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  PostCategory postCategory;
@override final  String cover;
@override final  int publishTime;
@override final  CommonUser uploader;
@override final  PostStats postStats;
@override final  PostRights postRights;
@override final  PostStatus postStatus;
 final  List<int> _badges;
@override List<int> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

@override final  String content;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDetailCopyWith<_PostDetail> get copyWith => __$PostDetailCopyWithImpl<_PostDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.postCategory, postCategory) || other.postCategory == postCategory)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.publishTime, publishTime) || other.publishTime == publishTime)&&(identical(other.uploader, uploader) || other.uploader == uploader)&&(identical(other.postStats, postStats) || other.postStats == postStats)&&(identical(other.postRights, postRights) || other.postRights == postRights)&&(identical(other.postStatus, postStatus) || other.postStatus == postStatus)&&const DeepCollectionEquality().equals(other._badges, _badges)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_tags),postCategory,cover,publishTime,uploader,postStats,postRights,postStatus,const DeepCollectionEquality().hash(_badges),content);

@override
String toString() {
  return 'PostDetail(id: $id, title: $title, description: $description, tags: $tags, postCategory: $postCategory, cover: $cover, publishTime: $publishTime, uploader: $uploader, postStats: $postStats, postRights: $postRights, postStatus: $postStatus, badges: $badges, content: $content)';
}


}

/// @nodoc
abstract mixin class _$PostDetailCopyWith<$Res> implements $PostDetailCopyWith<$Res> {
  factory _$PostDetailCopyWith(_PostDetail value, $Res Function(_PostDetail) _then) = __$PostDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String description, List<Tag> tags, PostCategory postCategory, String cover, int publishTime, CommonUser uploader, PostStats postStats, PostRights postRights, PostStatus postStatus, List<int> badges, String content
});


@override $PostCategoryCopyWith<$Res> get postCategory;@override $CommonUserCopyWith<$Res> get uploader;@override $PostStatsCopyWith<$Res> get postStats;@override $PostRightsCopyWith<$Res> get postRights;@override $PostStatusCopyWith<$Res> get postStatus;

}
/// @nodoc
class __$PostDetailCopyWithImpl<$Res>
    implements _$PostDetailCopyWith<$Res> {
  __$PostDetailCopyWithImpl(this._self, this._then);

  final _PostDetail _self;
  final $Res Function(_PostDetail) _then;

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? tags = null,Object? postCategory = null,Object? cover = null,Object? publishTime = null,Object? uploader = null,Object? postStats = null,Object? postRights = null,Object? postStatus = null,Object? badges = null,Object? content = null,}) {
  return _then(_PostDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,postCategory: null == postCategory ? _self.postCategory : postCategory // ignore: cast_nullable_to_non_nullable
as PostCategory,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,publishTime: null == publishTime ? _self.publishTime : publishTime // ignore: cast_nullable_to_non_nullable
as int,uploader: null == uploader ? _self.uploader : uploader // ignore: cast_nullable_to_non_nullable
as CommonUser,postStats: null == postStats ? _self.postStats : postStats // ignore: cast_nullable_to_non_nullable
as PostStats,postRights: null == postRights ? _self.postRights : postRights // ignore: cast_nullable_to_non_nullable
as PostRights,postStatus: null == postStatus ? _self.postStatus : postStatus // ignore: cast_nullable_to_non_nullable
as PostStatus,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<int>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostCategoryCopyWith<$Res> get postCategory {
  
  return $PostCategoryCopyWith<$Res>(_self.postCategory, (value) {
    return _then(_self.copyWith(postCategory: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommonUserCopyWith<$Res> get uploader {
  
  return $CommonUserCopyWith<$Res>(_self.uploader, (value) {
    return _then(_self.copyWith(uploader: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatsCopyWith<$Res> get postStats {
  
  return $PostStatsCopyWith<$Res>(_self.postStats, (value) {
    return _then(_self.copyWith(postStats: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRightsCopyWith<$Res> get postRights {
  
  return $PostRightsCopyWith<$Res>(_self.postRights, (value) {
    return _then(_self.copyWith(postRights: value));
  });
}/// Create a copy of PostDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStatusCopyWith<$Res> get postStatus {
  
  return $PostStatusCopyWith<$Res>(_self.postStatus, (value) {
    return _then(_self.copyWith(postStatus: value));
  });
}
}

/// @nodoc
mixin _$Tag {

 int get id; String get tagName; int get hotValue;// 热度值
 int get clicks;
/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagCopyWith<Tag> get copyWith => _$TagCopyWithImpl<Tag>(this as Tag, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tag&&(identical(other.id, id) || other.id == id)&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.hotValue, hotValue) || other.hotValue == hotValue)&&(identical(other.clicks, clicks) || other.clicks == clicks));
}


@override
int get hashCode => Object.hash(runtimeType,id,tagName,hotValue,clicks);

@override
String toString() {
  return 'Tag(id: $id, tagName: $tagName, hotValue: $hotValue, clicks: $clicks)';
}


}

/// @nodoc
abstract mixin class $TagCopyWith<$Res>  {
  factory $TagCopyWith(Tag value, $Res Function(Tag) _then) = _$TagCopyWithImpl;
@useResult
$Res call({
 int id, String tagName, int hotValue, int clicks
});




}
/// @nodoc
class _$TagCopyWithImpl<$Res>
    implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._self, this._then);

  final Tag _self;
  final $Res Function(Tag) _then;

/// Create a copy of Tag
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


/// Adds pattern-matching-related methods to [Tag].
extension TagPatterns on Tag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tag value)  $default,){
final _that = this;
switch (_that) {
case _Tag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tag value)?  $default,){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String tagName,  int hotValue,  int clicks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String tagName,  int hotValue,  int clicks)  $default,) {final _that = this;
switch (_that) {
case _Tag():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String tagName,  int hotValue,  int clicks)?  $default,) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.tagName,_that.hotValue,_that.clicks);case _:
  return null;

}
}

}

/// @nodoc


class _Tag implements Tag {
  const _Tag({required this.id, required this.tagName, required this.hotValue, required this.clicks});
  

@override final  int id;
@override final  String tagName;
@override final  int hotValue;
// 热度值
@override final  int clicks;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagCopyWith<_Tag> get copyWith => __$TagCopyWithImpl<_Tag>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tag&&(identical(other.id, id) || other.id == id)&&(identical(other.tagName, tagName) || other.tagName == tagName)&&(identical(other.hotValue, hotValue) || other.hotValue == hotValue)&&(identical(other.clicks, clicks) || other.clicks == clicks));
}


@override
int get hashCode => Object.hash(runtimeType,id,tagName,hotValue,clicks);

@override
String toString() {
  return 'Tag(id: $id, tagName: $tagName, hotValue: $hotValue, clicks: $clicks)';
}


}

/// @nodoc
abstract mixin class _$TagCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$TagCopyWith(_Tag value, $Res Function(_Tag) _then) = __$TagCopyWithImpl;
@override @useResult
$Res call({
 int id, String tagName, int hotValue, int clicks
});




}
/// @nodoc
class __$TagCopyWithImpl<$Res>
    implements _$TagCopyWith<$Res> {
  __$TagCopyWithImpl(this._self, this._then);

  final _Tag _self;
  final $Res Function(_Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tagName = null,Object? hotValue = null,Object? clicks = null,}) {
  return _then(_Tag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tagName: null == tagName ? _self.tagName : tagName // ignore: cast_nullable_to_non_nullable
as String,hotValue: null == hotValue ? _self.hotValue : hotValue // ignore: cast_nullable_to_non_nullable
as int,clicks: null == clicks ? _self.clicks : clicks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PostRights {

 bool get canEdit; bool get canDelete; bool get canComment; bool get canLike; bool get canFavorite; bool get canShare; bool get canReward; bool get needLike; bool get needComment; bool get needReward;
/// Create a copy of PostRights
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostRightsCopyWith<PostRights> get copyWith => _$PostRightsCopyWithImpl<PostRights>(this as PostRights, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostRights&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canLike, canLike) || other.canLike == canLike)&&(identical(other.canFavorite, canFavorite) || other.canFavorite == canFavorite)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canReward, canReward) || other.canReward == canReward)&&(identical(other.needLike, needLike) || other.needLike == needLike)&&(identical(other.needComment, needComment) || other.needComment == needComment)&&(identical(other.needReward, needReward) || other.needReward == needReward));
}


@override
int get hashCode => Object.hash(runtimeType,canEdit,canDelete,canComment,canLike,canFavorite,canShare,canReward,needLike,needComment,needReward);

@override
String toString() {
  return 'PostRights(canEdit: $canEdit, canDelete: $canDelete, canComment: $canComment, canLike: $canLike, canFavorite: $canFavorite, canShare: $canShare, canReward: $canReward, needLike: $needLike, needComment: $needComment, needReward: $needReward)';
}


}

/// @nodoc
abstract mixin class $PostRightsCopyWith<$Res>  {
  factory $PostRightsCopyWith(PostRights value, $Res Function(PostRights) _then) = _$PostRightsCopyWithImpl;
@useResult
$Res call({
 bool canEdit, bool canDelete, bool canComment, bool canLike, bool canFavorite, bool canShare, bool canReward, bool needLike, bool needComment, bool needReward
});




}
/// @nodoc
class _$PostRightsCopyWithImpl<$Res>
    implements $PostRightsCopyWith<$Res> {
  _$PostRightsCopyWithImpl(this._self, this._then);

  final PostRights _self;
  final $Res Function(PostRights) _then;

/// Create a copy of PostRights
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


/// Adds pattern-matching-related methods to [PostRights].
extension PostRightsPatterns on PostRights {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostRights value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostRights() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostRights value)  $default,){
final _that = this;
switch (_that) {
case _PostRights():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostRights value)?  $default,){
final _that = this;
switch (_that) {
case _PostRights() when $default != null:
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
case _PostRights() when $default != null:
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
case _PostRights():
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
case _PostRights() when $default != null:
return $default(_that.canEdit,_that.canDelete,_that.canComment,_that.canLike,_that.canFavorite,_that.canShare,_that.canReward,_that.needLike,_that.needComment,_that.needReward);case _:
  return null;

}
}

}

/// @nodoc


class _PostRights implements PostRights {
  const _PostRights({required this.canEdit, required this.canDelete, required this.canComment, required this.canLike, required this.canFavorite, required this.canShare, required this.canReward, required this.needLike, required this.needComment, required this.needReward});
  

@override final  bool canEdit;
@override final  bool canDelete;
@override final  bool canComment;
@override final  bool canLike;
@override final  bool canFavorite;
@override final  bool canShare;
@override final  bool canReward;
@override final  bool needLike;
@override final  bool needComment;
@override final  bool needReward;

/// Create a copy of PostRights
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostRightsCopyWith<_PostRights> get copyWith => __$PostRightsCopyWithImpl<_PostRights>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostRights&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.canComment, canComment) || other.canComment == canComment)&&(identical(other.canLike, canLike) || other.canLike == canLike)&&(identical(other.canFavorite, canFavorite) || other.canFavorite == canFavorite)&&(identical(other.canShare, canShare) || other.canShare == canShare)&&(identical(other.canReward, canReward) || other.canReward == canReward)&&(identical(other.needLike, needLike) || other.needLike == needLike)&&(identical(other.needComment, needComment) || other.needComment == needComment)&&(identical(other.needReward, needReward) || other.needReward == needReward));
}


@override
int get hashCode => Object.hash(runtimeType,canEdit,canDelete,canComment,canLike,canFavorite,canShare,canReward,needLike,needComment,needReward);

@override
String toString() {
  return 'PostRights(canEdit: $canEdit, canDelete: $canDelete, canComment: $canComment, canLike: $canLike, canFavorite: $canFavorite, canShare: $canShare, canReward: $canReward, needLike: $needLike, needComment: $needComment, needReward: $needReward)';
}


}

/// @nodoc
abstract mixin class _$PostRightsCopyWith<$Res> implements $PostRightsCopyWith<$Res> {
  factory _$PostRightsCopyWith(_PostRights value, $Res Function(_PostRights) _then) = __$PostRightsCopyWithImpl;
@override @useResult
$Res call({
 bool canEdit, bool canDelete, bool canComment, bool canLike, bool canFavorite, bool canShare, bool canReward, bool needLike, bool needComment, bool needReward
});




}
/// @nodoc
class __$PostRightsCopyWithImpl<$Res>
    implements _$PostRightsCopyWith<$Res> {
  __$PostRightsCopyWithImpl(this._self, this._then);

  final _PostRights _self;
  final $Res Function(_PostRights) _then;

/// Create a copy of PostRights
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canEdit = null,Object? canDelete = null,Object? canComment = null,Object? canLike = null,Object? canFavorite = null,Object? canShare = null,Object? canReward = null,Object? needLike = null,Object? needComment = null,Object? needReward = null,}) {
  return _then(_PostRights(
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
mixin _$PostStatus {

/// 是否置顶标识
 bool get isTop;/// 是否锁定标识
 bool get isLocked;/// 是否点赞标识
 bool get isLike;/// 是否收藏标识
 bool get isFavorited;
/// Create a copy of PostStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostStatusCopyWith<PostStatus> get copyWith => _$PostStatusCopyWithImpl<PostStatus>(this as PostStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostStatus&&(identical(other.isTop, isTop) || other.isTop == isTop)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isLike, isLike) || other.isLike == isLike)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited));
}


@override
int get hashCode => Object.hash(runtimeType,isTop,isLocked,isLike,isFavorited);

@override
String toString() {
  return 'PostStatus(isTop: $isTop, isLocked: $isLocked, isLike: $isLike, isFavorited: $isFavorited)';
}


}

/// @nodoc
abstract mixin class $PostStatusCopyWith<$Res>  {
  factory $PostStatusCopyWith(PostStatus value, $Res Function(PostStatus) _then) = _$PostStatusCopyWithImpl;
@useResult
$Res call({
 bool isTop, bool isLocked, bool isLike, bool isFavorited
});




}
/// @nodoc
class _$PostStatusCopyWithImpl<$Res>
    implements $PostStatusCopyWith<$Res> {
  _$PostStatusCopyWithImpl(this._self, this._then);

  final PostStatus _self;
  final $Res Function(PostStatus) _then;

/// Create a copy of PostStatus
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


/// Adds pattern-matching-related methods to [PostStatus].
extension PostStatusPatterns on PostStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostStatus value)  $default,){
final _that = this;
switch (_that) {
case _PostStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PostStatus() when $default != null:
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
case _PostStatus() when $default != null:
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
case _PostStatus():
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
case _PostStatus() when $default != null:
return $default(_that.isTop,_that.isLocked,_that.isLike,_that.isFavorited);case _:
  return null;

}
}

}

/// @nodoc


class _PostStatus implements PostStatus {
  const _PostStatus({required this.isTop, required this.isLocked, required this.isLike, required this.isFavorited});
  

/// 是否置顶标识
@override final  bool isTop;
/// 是否锁定标识
@override final  bool isLocked;
/// 是否点赞标识
@override final  bool isLike;
/// 是否收藏标识
@override final  bool isFavorited;

/// Create a copy of PostStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostStatusCopyWith<_PostStatus> get copyWith => __$PostStatusCopyWithImpl<_PostStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostStatus&&(identical(other.isTop, isTop) || other.isTop == isTop)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isLike, isLike) || other.isLike == isLike)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited));
}


@override
int get hashCode => Object.hash(runtimeType,isTop,isLocked,isLike,isFavorited);

@override
String toString() {
  return 'PostStatus(isTop: $isTop, isLocked: $isLocked, isLike: $isLike, isFavorited: $isFavorited)';
}


}

/// @nodoc
abstract mixin class _$PostStatusCopyWith<$Res> implements $PostStatusCopyWith<$Res> {
  factory _$PostStatusCopyWith(_PostStatus value, $Res Function(_PostStatus) _then) = __$PostStatusCopyWithImpl;
@override @useResult
$Res call({
 bool isTop, bool isLocked, bool isLike, bool isFavorited
});




}
/// @nodoc
class __$PostStatusCopyWithImpl<$Res>
    implements _$PostStatusCopyWith<$Res> {
  __$PostStatusCopyWithImpl(this._self, this._then);

  final _PostStatus _self;
  final $Res Function(_PostStatus) _then;

/// Create a copy of PostStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isTop = null,Object? isLocked = null,Object? isLike = null,Object? isFavorited = null,}) {
  return _then(_PostStatus(
isTop: null == isTop ? _self.isTop : isTop // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,isLike: null == isLike ? _self.isLike : isLike // ignore: cast_nullable_to_non_nullable
as bool,isFavorited: null == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
