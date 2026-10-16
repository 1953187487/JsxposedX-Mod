// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserDetail {

 int get id; String get mxid; String get nickname; String get avatarUrl; String get description; String get cover; bool get isVip; int get vipEndTime; bool get isCert; int get exp; int get gender; String get email; bool get isOnline; bool get isFollowing; List<int> get group;
/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDetailCopyWith<UserDetail> get copyWith => _$UserDetailCopyWithImpl<UserDetail>(this as UserDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.mxid, mxid) || other.mxid == mxid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.isVip, isVip) || other.isVip == isVip)&&(identical(other.vipEndTime, vipEndTime) || other.vipEndTime == vipEndTime)&&(identical(other.isCert, isCert) || other.isCert == isCert)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.email, email) || other.email == email)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&const DeepCollectionEquality().equals(other.group, group));
}


@override
int get hashCode => Object.hash(runtimeType,id,mxid,nickname,avatarUrl,description,cover,isVip,vipEndTime,isCert,exp,gender,email,isOnline,isFollowing,const DeepCollectionEquality().hash(group));

@override
String toString() {
  return 'UserDetail(id: $id, mxid: $mxid, nickname: $nickname, avatarUrl: $avatarUrl, description: $description, cover: $cover, isVip: $isVip, vipEndTime: $vipEndTime, isCert: $isCert, exp: $exp, gender: $gender, email: $email, isOnline: $isOnline, isFollowing: $isFollowing, group: $group)';
}


}

/// @nodoc
abstract mixin class $UserDetailCopyWith<$Res>  {
  factory $UserDetailCopyWith(UserDetail value, $Res Function(UserDetail) _then) = _$UserDetailCopyWithImpl;
@useResult
$Res call({
 int id, String mxid, String nickname, String avatarUrl, String description, String cover, bool isVip, int vipEndTime, bool isCert, int exp, int gender, String email, bool isOnline, bool isFollowing, List<int> group
});




}
/// @nodoc
class _$UserDetailCopyWithImpl<$Res>
    implements $UserDetailCopyWith<$Res> {
  _$UserDetailCopyWithImpl(this._self, this._then);

  final UserDetail _self;
  final $Res Function(UserDetail) _then;

/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mxid = null,Object? nickname = null,Object? avatarUrl = null,Object? description = null,Object? cover = null,Object? isVip = null,Object? vipEndTime = null,Object? isCert = null,Object? exp = null,Object? gender = null,Object? email = null,Object? isOnline = null,Object? isFollowing = null,Object? group = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mxid: null == mxid ? _self.mxid : mxid // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,isVip: null == isVip ? _self.isVip : isVip // ignore: cast_nullable_to_non_nullable
as bool,vipEndTime: null == vipEndTime ? _self.vipEndTime : vipEndTime // ignore: cast_nullable_to_non_nullable
as int,isCert: null == isCert ? _self.isCert : isCert // ignore: cast_nullable_to_non_nullable
as bool,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDetail].
extension UserDetailPatterns on UserDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDetail value)  $default,){
final _that = this;
switch (_that) {
case _UserDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDetail value)?  $default,){
final _that = this;
switch (_that) {
case _UserDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String mxid,  String nickname,  String avatarUrl,  String description,  String cover,  bool isVip,  int vipEndTime,  bool isCert,  int exp,  int gender,  String email,  bool isOnline,  bool isFollowing,  List<int> group)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDetail() when $default != null:
return $default(_that.id,_that.mxid,_that.nickname,_that.avatarUrl,_that.description,_that.cover,_that.isVip,_that.vipEndTime,_that.isCert,_that.exp,_that.gender,_that.email,_that.isOnline,_that.isFollowing,_that.group);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String mxid,  String nickname,  String avatarUrl,  String description,  String cover,  bool isVip,  int vipEndTime,  bool isCert,  int exp,  int gender,  String email,  bool isOnline,  bool isFollowing,  List<int> group)  $default,) {final _that = this;
switch (_that) {
case _UserDetail():
return $default(_that.id,_that.mxid,_that.nickname,_that.avatarUrl,_that.description,_that.cover,_that.isVip,_that.vipEndTime,_that.isCert,_that.exp,_that.gender,_that.email,_that.isOnline,_that.isFollowing,_that.group);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String mxid,  String nickname,  String avatarUrl,  String description,  String cover,  bool isVip,  int vipEndTime,  bool isCert,  int exp,  int gender,  String email,  bool isOnline,  bool isFollowing,  List<int> group)?  $default,) {final _that = this;
switch (_that) {
case _UserDetail() when $default != null:
return $default(_that.id,_that.mxid,_that.nickname,_that.avatarUrl,_that.description,_that.cover,_that.isVip,_that.vipEndTime,_that.isCert,_that.exp,_that.gender,_that.email,_that.isOnline,_that.isFollowing,_that.group);case _:
  return null;

}
}

}

/// @nodoc


class _UserDetail extends UserDetail {
  const _UserDetail({required this.id, required this.mxid, required this.nickname, required this.avatarUrl, required this.description, required this.cover, required this.isVip, required this.vipEndTime, required this.isCert, required this.exp, required this.gender, required this.email, required this.isOnline, required this.isFollowing, required final  List<int> group}): _group = group,super._();
  

@override final  int id;
@override final  String mxid;
@override final  String nickname;
@override final  String avatarUrl;
@override final  String description;
@override final  String cover;
@override final  bool isVip;
@override final  int vipEndTime;
@override final  bool isCert;
@override final  int exp;
@override final  int gender;
@override final  String email;
@override final  bool isOnline;
@override final  bool isFollowing;
 final  List<int> _group;
@override List<int> get group {
  if (_group is EqualUnmodifiableListView) return _group;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_group);
}


/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDetailCopyWith<_UserDetail> get copyWith => __$UserDetailCopyWithImpl<_UserDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.mxid, mxid) || other.mxid == mxid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.isVip, isVip) || other.isVip == isVip)&&(identical(other.vipEndTime, vipEndTime) || other.vipEndTime == vipEndTime)&&(identical(other.isCert, isCert) || other.isCert == isCert)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.email, email) || other.email == email)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&const DeepCollectionEquality().equals(other._group, _group));
}


@override
int get hashCode => Object.hash(runtimeType,id,mxid,nickname,avatarUrl,description,cover,isVip,vipEndTime,isCert,exp,gender,email,isOnline,isFollowing,const DeepCollectionEquality().hash(_group));

@override
String toString() {
  return 'UserDetail(id: $id, mxid: $mxid, nickname: $nickname, avatarUrl: $avatarUrl, description: $description, cover: $cover, isVip: $isVip, vipEndTime: $vipEndTime, isCert: $isCert, exp: $exp, gender: $gender, email: $email, isOnline: $isOnline, isFollowing: $isFollowing, group: $group)';
}


}

/// @nodoc
abstract mixin class _$UserDetailCopyWith<$Res> implements $UserDetailCopyWith<$Res> {
  factory _$UserDetailCopyWith(_UserDetail value, $Res Function(_UserDetail) _then) = __$UserDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String mxid, String nickname, String avatarUrl, String description, String cover, bool isVip, int vipEndTime, bool isCert, int exp, int gender, String email, bool isOnline, bool isFollowing, List<int> group
});




}
/// @nodoc
class __$UserDetailCopyWithImpl<$Res>
    implements _$UserDetailCopyWith<$Res> {
  __$UserDetailCopyWithImpl(this._self, this._then);

  final _UserDetail _self;
  final $Res Function(_UserDetail) _then;

/// Create a copy of UserDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mxid = null,Object? nickname = null,Object? avatarUrl = null,Object? description = null,Object? cover = null,Object? isVip = null,Object? vipEndTime = null,Object? isCert = null,Object? exp = null,Object? gender = null,Object? email = null,Object? isOnline = null,Object? isFollowing = null,Object? group = null,}) {
  return _then(_UserDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mxid: null == mxid ? _self.mxid : mxid // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String,isVip: null == isVip ? _self.isVip : isVip // ignore: cast_nullable_to_non_nullable
as bool,vipEndTime: null == vipEndTime ? _self.vipEndTime : vipEndTime // ignore: cast_nullable_to_non_nullable
as int,isCert: null == isCert ? _self.isCert : isCert // ignore: cast_nullable_to_non_nullable
as bool,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,group: null == group ? _self._group : group // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
