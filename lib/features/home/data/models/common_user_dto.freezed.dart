// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommonUserDto {

 int get id; String get mxid; String get nickname; String get avatarUrl; String get description; int get gender; int get exp; bool get isVip; bool get isCert; bool get isOnline; List<int> get group;
/// Create a copy of CommonUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommonUserDtoCopyWith<CommonUserDto> get copyWith => _$CommonUserDtoCopyWithImpl<CommonUserDto>(this as CommonUserDto, _$identity);

  /// Serializes this CommonUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommonUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.mxid, mxid) || other.mxid == mxid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.isVip, isVip) || other.isVip == isVip)&&(identical(other.isCert, isCert) || other.isCert == isCert)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&const DeepCollectionEquality().equals(other.group, group));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mxid,nickname,avatarUrl,description,gender,exp,isVip,isCert,isOnline,const DeepCollectionEquality().hash(group));

@override
String toString() {
  return 'CommonUserDto(id: $id, mxid: $mxid, nickname: $nickname, avatarUrl: $avatarUrl, description: $description, gender: $gender, exp: $exp, isVip: $isVip, isCert: $isCert, isOnline: $isOnline, group: $group)';
}


}

/// @nodoc
abstract mixin class $CommonUserDtoCopyWith<$Res>  {
  factory $CommonUserDtoCopyWith(CommonUserDto value, $Res Function(CommonUserDto) _then) = _$CommonUserDtoCopyWithImpl;
@useResult
$Res call({
 int id, String mxid, String nickname, String avatarUrl, String description, int gender, int exp, bool isVip, bool isCert, bool isOnline, List<int> group
});




}
/// @nodoc
class _$CommonUserDtoCopyWithImpl<$Res>
    implements $CommonUserDtoCopyWith<$Res> {
  _$CommonUserDtoCopyWithImpl(this._self, this._then);

  final CommonUserDto _self;
  final $Res Function(CommonUserDto) _then;

/// Create a copy of CommonUserDto
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


/// Adds pattern-matching-related methods to [CommonUserDto].
extension CommonUserDtoPatterns on CommonUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommonUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommonUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommonUserDto value)  $default,){
final _that = this;
switch (_that) {
case _CommonUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommonUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _CommonUserDto() when $default != null:
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
case _CommonUserDto() when $default != null:
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
case _CommonUserDto():
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
case _CommonUserDto() when $default != null:
return $default(_that.id,_that.mxid,_that.nickname,_that.avatarUrl,_that.description,_that.gender,_that.exp,_that.isVip,_that.isCert,_that.isOnline,_that.group);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommonUserDto extends CommonUserDto {
  const _CommonUserDto({this.id = 0, this.mxid = "", this.nickname = "", this.avatarUrl = "", this.description = "", this.gender = 0, this.exp = 0, this.isVip = false, this.isCert = false, this.isOnline = false, final  List<int> group = const []}): _group = group,super._();
  factory _CommonUserDto.fromJson(Map<String, dynamic> json) => _$CommonUserDtoFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String mxid;
@override@JsonKey() final  String nickname;
@override@JsonKey() final  String avatarUrl;
@override@JsonKey() final  String description;
@override@JsonKey() final  int gender;
@override@JsonKey() final  int exp;
@override@JsonKey() final  bool isVip;
@override@JsonKey() final  bool isCert;
@override@JsonKey() final  bool isOnline;
 final  List<int> _group;
@override@JsonKey() List<int> get group {
  if (_group is EqualUnmodifiableListView) return _group;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_group);
}


/// Create a copy of CommonUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommonUserDtoCopyWith<_CommonUserDto> get copyWith => __$CommonUserDtoCopyWithImpl<_CommonUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommonUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommonUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.mxid, mxid) || other.mxid == mxid)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.isVip, isVip) || other.isVip == isVip)&&(identical(other.isCert, isCert) || other.isCert == isCert)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&const DeepCollectionEquality().equals(other._group, _group));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mxid,nickname,avatarUrl,description,gender,exp,isVip,isCert,isOnline,const DeepCollectionEquality().hash(_group));

@override
String toString() {
  return 'CommonUserDto(id: $id, mxid: $mxid, nickname: $nickname, avatarUrl: $avatarUrl, description: $description, gender: $gender, exp: $exp, isVip: $isVip, isCert: $isCert, isOnline: $isOnline, group: $group)';
}


}

/// @nodoc
abstract mixin class _$CommonUserDtoCopyWith<$Res> implements $CommonUserDtoCopyWith<$Res> {
  factory _$CommonUserDtoCopyWith(_CommonUserDto value, $Res Function(_CommonUserDto) _then) = __$CommonUserDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String mxid, String nickname, String avatarUrl, String description, int gender, int exp, bool isVip, bool isCert, bool isOnline, List<int> group
});




}
/// @nodoc
class __$CommonUserDtoCopyWithImpl<$Res>
    implements _$CommonUserDtoCopyWith<$Res> {
  __$CommonUserDtoCopyWithImpl(this._self, this._then);

  final _CommonUserDto _self;
  final $Res Function(_CommonUserDto) _then;

/// Create a copy of CommonUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mxid = null,Object? nickname = null,Object? avatarUrl = null,Object? description = null,Object? gender = null,Object? exp = null,Object? isVip = null,Object? isCert = null,Object? isOnline = null,Object? group = null,}) {
  return _then(_CommonUserDto(
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
