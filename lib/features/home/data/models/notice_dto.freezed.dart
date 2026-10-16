// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoticeDto {

 int get code; MsgDto get msg; String get check;
/// Create a copy of NoticeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeDtoCopyWith<NoticeDto> get copyWith => _$NoticeDtoCopyWithImpl<NoticeDto>(this as NoticeDto, _$identity);

  /// Serializes this NoticeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeDto&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.check, check) || other.check == check));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,check);

@override
String toString() {
  return 'NoticeDto(code: $code, msg: $msg, check: $check)';
}


}

/// @nodoc
abstract mixin class $NoticeDtoCopyWith<$Res>  {
  factory $NoticeDtoCopyWith(NoticeDto value, $Res Function(NoticeDto) _then) = _$NoticeDtoCopyWithImpl;
@useResult
$Res call({
 int code, MsgDto msg, String check
});


$MsgDtoCopyWith<$Res> get msg;

}
/// @nodoc
class _$NoticeDtoCopyWithImpl<$Res>
    implements $NoticeDtoCopyWith<$Res> {
  _$NoticeDtoCopyWithImpl(this._self, this._then);

  final NoticeDto _self;
  final $Res Function(NoticeDto) _then;

/// Create a copy of NoticeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? msg = null,Object? check = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as MsgDto,check: null == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of NoticeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MsgDtoCopyWith<$Res> get msg {
  
  return $MsgDtoCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoticeDto].
extension NoticeDtoPatterns on NoticeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeDto value)  $default,){
final _that = this;
switch (_that) {
case _NoticeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeDto value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  MsgDto msg,  String check)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeDto() when $default != null:
return $default(_that.code,_that.msg,_that.check);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  MsgDto msg,  String check)  $default,) {final _that = this;
switch (_that) {
case _NoticeDto():
return $default(_that.code,_that.msg,_that.check);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  MsgDto msg,  String check)?  $default,) {final _that = this;
switch (_that) {
case _NoticeDto() when $default != null:
return $default(_that.code,_that.msg,_that.check);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeDto extends NoticeDto {
  const _NoticeDto({this.code = 500, this.msg = const MsgDto(), this.check = ''}): super._();
  factory _NoticeDto.fromJson(Map<String, dynamic> json) => _$NoticeDtoFromJson(json);

@override@JsonKey() final  int code;
@override@JsonKey() final  MsgDto msg;
@override@JsonKey() final  String check;

/// Create a copy of NoticeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeDtoCopyWith<_NoticeDto> get copyWith => __$NoticeDtoCopyWithImpl<_NoticeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeDto&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.check, check) || other.check == check));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,check);

@override
String toString() {
  return 'NoticeDto(code: $code, msg: $msg, check: $check)';
}


}

/// @nodoc
abstract mixin class _$NoticeDtoCopyWith<$Res> implements $NoticeDtoCopyWith<$Res> {
  factory _$NoticeDtoCopyWith(_NoticeDto value, $Res Function(_NoticeDto) _then) = __$NoticeDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, MsgDto msg, String check
});


@override $MsgDtoCopyWith<$Res> get msg;

}
/// @nodoc
class __$NoticeDtoCopyWithImpl<$Res>
    implements _$NoticeDtoCopyWith<$Res> {
  __$NoticeDtoCopyWithImpl(this._self, this._then);

  final _NoticeDto _self;
  final $Res Function(_NoticeDto) _then;

/// Create a copy of NoticeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? msg = null,Object? check = null,}) {
  return _then(_NoticeDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as MsgDto,check: null == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of NoticeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MsgDtoCopyWith<$Res> get msg {
  
  return $MsgDtoCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// @nodoc
mixin _$MsgDto {

@JsonKey(name: "app_gg") String get content;
/// Create a copy of MsgDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MsgDtoCopyWith<MsgDto> get copyWith => _$MsgDtoCopyWithImpl<MsgDto>(this as MsgDto, _$identity);

  /// Serializes this MsgDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MsgDto&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'MsgDto(content: $content)';
}


}

/// @nodoc
abstract mixin class $MsgDtoCopyWith<$Res>  {
  factory $MsgDtoCopyWith(MsgDto value, $Res Function(MsgDto) _then) = _$MsgDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "app_gg") String content
});




}
/// @nodoc
class _$MsgDtoCopyWithImpl<$Res>
    implements $MsgDtoCopyWith<$Res> {
  _$MsgDtoCopyWithImpl(this._self, this._then);

  final MsgDto _self;
  final $Res Function(MsgDto) _then;

/// Create a copy of MsgDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MsgDto].
extension MsgDtoPatterns on MsgDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MsgDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MsgDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MsgDto value)  $default,){
final _that = this;
switch (_that) {
case _MsgDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MsgDto value)?  $default,){
final _that = this;
switch (_that) {
case _MsgDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "app_gg")  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MsgDto() when $default != null:
return $default(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "app_gg")  String content)  $default,) {final _that = this;
switch (_that) {
case _MsgDto():
return $default(_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "app_gg")  String content)?  $default,) {final _that = this;
switch (_that) {
case _MsgDto() when $default != null:
return $default(_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MsgDto extends MsgDto {
  const _MsgDto({@JsonKey(name: "app_gg") this.content = ''}): super._();
  factory _MsgDto.fromJson(Map<String, dynamic> json) => _$MsgDtoFromJson(json);

@override@JsonKey(name: "app_gg") final  String content;

/// Create a copy of MsgDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MsgDtoCopyWith<_MsgDto> get copyWith => __$MsgDtoCopyWithImpl<_MsgDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MsgDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MsgDto&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content);

@override
String toString() {
  return 'MsgDto(content: $content)';
}


}

/// @nodoc
abstract mixin class _$MsgDtoCopyWith<$Res> implements $MsgDtoCopyWith<$Res> {
  factory _$MsgDtoCopyWith(_MsgDto value, $Res Function(_MsgDto) _then) = __$MsgDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "app_gg") String content
});




}
/// @nodoc
class __$MsgDtoCopyWithImpl<$Res>
    implements _$MsgDtoCopyWith<$Res> {
  __$MsgDtoCopyWithImpl(this._self, this._then);

  final _MsgDto _self;
  final $Res Function(_MsgDto) _then;

/// Create a copy of MsgDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,}) {
  return _then(_MsgDto(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
