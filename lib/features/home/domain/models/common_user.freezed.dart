// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommonUser {

 int get id; String get mxid; String get nickname; String get avatarUrl; String get description; int get gender; int get exp; bool get isVip; bool get isCert; bool get isOnline; List<int> get group;
/// Create a copy of CommonUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommonUserCopyWith<CommonUser> get copyWith => _$CommonUserCopyWithImpl<CommonUser>(this as CommonUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommonUser&&(identical(other.id, id) || other.id == id)&&(identical(other.mxid, mxid) || other.mxid == mxid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.isVip, isVip) || other.isVip == isVip)&&(identical(other.isCert, isCert) || other.isCert == isCert)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&const DeepCollectionEquality().equals(other.group, group));
}


@override
int get hashCode => Object.hash(runtimeType,id,mxid,nickname,avatarUrl,description,gender,exp,isVip,isCert,isOnline,const DeepCollectionEquality().hash(group));

@override
String toString() {
  return 'CommonUser(id: $id, mxid: $mxid, nickname: $nickname, avatarUrl: $avatarUrl, description: $description, gender: $gender, exp: $exp, isVip: $isVip, isCert: $isCert, isOnline: $isOnline, group: $group)';
}


}

/// @nodoc
abstract mixin class $CommonUserCopyWith<$Res>  {
  factory $CommonUserCopyWith(CommonUser value, $Res Function(CommonUser) _then) = _$CommonUserCopyWithImpl;
@useResult
$Res call({
 int id, String mxid, String nickname, String avatarUrl, String description, int gender, int exp, bool isVip, bool isCert, bool isOnline, List<int> group
});




}
/// @nodoc
class _$CommonUserCopyWithImpl<$Res>
    implements $CommonUserCopyWith<$Res> {
  _$CommonUserCopyWithImpl(this._self, this._then);

  final CommonUser _self;
  final $Res Function(CommonUser) _then;

/// Create a copy of CommonUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mxid = null,Object? nickname = null,Object? avatarUrl = null,Object? description = null,Object? gender = null,Object? exp = null,Object? isVip = null,Object? isCert = null,Object? isOnline = null,Object? group = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mxid: null == mxid ? _self.mxid : mxid // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as int,isVip: null == isVip ? _self.isVip : isVip // ignore: cast_nullable_to_non_nullable
as bool,isCert: null == isCert ? _self.isCert : isCert // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [CommonUser].
extension CommonUserPatterns on CommonUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommonUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommonUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommonUser value)  $default,){
final _that = this;
switch (_that) {
case _CommonUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommonUser value)?  $default,){
final _that = this;
switch (_that) {
case _CommonUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String mxid,  String nickname,  String avatarUrl,  String description,  int gender,  int exp,  bool isVip,  bool isCert,  bool isOnline,  List<int> group)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommonUser() when $default != null:
return $default(_that.id,_that.mxid,_that.nickname,_that.avatarUrl,_that.description,_that.gender,_that.exp,_that.isVip,_that.isCert,_that.isOnline,_that.group);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String mxid,  String nickname,  String avatarUrl,  String description,  int gender,  int exp,  bool isVip,  bool isCert,  bool isOnline,  List<int> group)  $default,) {final _that = this;
switch (_that) {
case _CommonUser():
return $default(_that.id,_that.mxid,_that.nickname,_that.avatarUrl,_that.description,_that.gender,_that.exp,_that.isVip,_that.isCert,_that.isOnline,_that.group);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String mxid,  String nickname,  String avatarUrl,  String description,  int gender,  int exp,  bool isVip,  bool isCert,  bool isOnline,  List<int> group)?  $default,) {final _that = this;
switch (_that) {
case _CommonUser() when $default != null:
return $default(_that.id,_that.mxid,_that.nickname,_that.avatarUrl,_that.description,_that.gender,_that.exp,_that.isVip,_that.isCert,_that.isOnline,_that.group);case _:
  return null;

}
}

}

/// @nodoc


class _CommonUser extends CommonUser {
  const _CommonUser({required this.id, required this.mxid, required this.nickname, required this.avatarUrl, required this.description, required this.gender, required this.exp, required this.isVip, required this.isCert, required this.isOnline, required final  List<int> group}): _group = group,super._();
  

@override final  int id;
@override final  String mxid;
@override final  String nickname;
@override final  String avatarUrl;
@override final  String description;
@override final  int gender;
@override final  int exp;
@override final  bool isVip;
@override final  bool isCert;
@override final  bool isOnline;
 final  List<int> _group;
@override List<int> get group {
  if (_group is EqualUnmodifiableListView) return _group;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_group);
}


/// Create a copy of CommonUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommonUserCopyWith<_CommonUser> get copyWith => __$CommonUserCopyWithImpl<_CommonUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommonUser&&(identical(other.id, id) || other.id == id)&&(identical(other.mxid, mxid) || other.mxid == mxid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.isVip, isVip) || other.isVip == isVip)&&(identical(other.isCert, isCert) || other.isCert == isCert)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&const DeepCollectionEquality().equals(other._group, _group));
}


@override
int get hashCode => Object.hash(runtimeType,id,mxid,nickname,avatarUrl,description,gender,exp,isVip,isCert,isOnline,const DeepCollectionEquality().hash(_group));

@override
String toString() {
  return 'CommonUser(id: $id, mxid: $mxid, nickname: $nickname, avatarUrl: $avatarUrl, description: $description, gender: $gender, exp: $exp, isVip: $isVip, isCert: $isCert, isOnline: $isOnline, group: $group)';
}


}

/// @nodoc
abstract mixin class _$CommonUserCopyWith<$Res> implements $CommonUserCopyWith<$Res> {
  factory _$CommonUserCopyWith(_CommonUser value, $Res Function(_CommonUser) _then) = __$CommonUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String mxid, String nickname, String avatarUrl, String description, int gender, int exp, bool isVip, bool isCert, bool isOnline, List<int> group
});




}
/// @nodoc
class __$CommonUserCopyWithImpl<$Res>
    implements _$CommonUserCopyWith<$Res> {
  __$CommonUserCopyWithImpl(this._self, this._then);

  final _CommonUser _self;
  final $Res Function(_CommonUser) _then;

/// Create a copy of CommonUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mxid = null,Object? nickname = null,Object? avatarUrl = null,Object? description = null,Object? gender = null,Object? exp = null,Object? isVip = null,Object? isCert = null,Object? isOnline = null,Object? group = null,}) {
  return _then(_CommonUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,mxid: null == mxid ? _self.mxid : mxid // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as int,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as int,isVip: null == isVip ? _self.isVip : isVip // ignore: cast_nullable_to_non_nullable
as bool,isCert: null == isCert ? _self.isCert : isCert // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,group: null == group ? _self._group : group // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
