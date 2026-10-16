// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateDto {

 int get code; UpdateMsgDto get msg; String get check;
/// Create a copy of UpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateDtoCopyWith<UpdateDto> get copyWith => _$UpdateDtoCopyWithImpl<UpdateDto>(this as UpdateDto, _$identity);

  /// Serializes this UpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateDto&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.check, check) || other.check == check));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,check);

@override
String toString() {
  return 'UpdateDto(code: $code, msg: $msg, check: $check)';
}


}

/// @nodoc
abstract mixin class $UpdateDtoCopyWith<$Res>  {
  factory $UpdateDtoCopyWith(UpdateDto value, $Res Function(UpdateDto) _then) = _$UpdateDtoCopyWithImpl;
@useResult
$Res call({
 int code, UpdateMsgDto msg, String check
});


$UpdateMsgDtoCopyWith<$Res> get msg;

}
/// @nodoc
class _$UpdateDtoCopyWithImpl<$Res>
    implements $UpdateDtoCopyWith<$Res> {
  _$UpdateDtoCopyWithImpl(this._self, this._then);

  final UpdateDto _self;
  final $Res Function(UpdateDto) _then;

/// Create a copy of UpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? msg = null,Object? check = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as UpdateMsgDto,check: null == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of UpdateDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateMsgDtoCopyWith<$Res> get msg {
  
  return $UpdateMsgDtoCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateDto].
extension UpdateDtoPatterns on UpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  UpdateMsgDto msg,  String check)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  UpdateMsgDto msg,  String check)  $default,) {final _that = this;
switch (_that) {
case _UpdateDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  UpdateMsgDto msg,  String check)?  $default,) {final _that = this;
switch (_that) {
case _UpdateDto() when $default != null:
return $default(_that.code,_that.msg,_that.check);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateDto extends UpdateDto {
  const _UpdateDto({this.code = 500, this.msg = const UpdateMsgDto(), this.check = ''}): super._();
  factory _UpdateDto.fromJson(Map<String, dynamic> json) => _$UpdateDtoFromJson(json);

@override@JsonKey() final  int code;
@override@JsonKey() final  UpdateMsgDto msg;
@override@JsonKey() final  String check;

/// Create a copy of UpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateDtoCopyWith<_UpdateDto> get copyWith => __$UpdateDtoCopyWithImpl<_UpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateDto&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.check, check) || other.check == check));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,msg,check);

@override
String toString() {
  return 'UpdateDto(code: $code, msg: $msg, check: $check)';
}


}

/// @nodoc
abstract mixin class _$UpdateDtoCopyWith<$Res> implements $UpdateDtoCopyWith<$Res> {
  factory _$UpdateDtoCopyWith(_UpdateDto value, $Res Function(_UpdateDto) _then) = __$UpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 int code, UpdateMsgDto msg, String check
});


@override $UpdateMsgDtoCopyWith<$Res> get msg;

}
/// @nodoc
class __$UpdateDtoCopyWithImpl<$Res>
    implements _$UpdateDtoCopyWith<$Res> {
  __$UpdateDtoCopyWithImpl(this._self, this._then);

  final _UpdateDto _self;
  final $Res Function(_UpdateDto) _then;

/// Create a copy of UpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? msg = null,Object? check = null,}) {
  return _then(_UpdateDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as UpdateMsgDto,check: null == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of UpdateDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateMsgDtoCopyWith<$Res> get msg {
  
  return $UpdateMsgDtoCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// @nodoc
mixin _$UpdateMsgDto {

 String get version;@JsonKey(name: "app_update_url") String get url;@JsonKey(name: "app_update_show") String get content;@JsonKey(name: "app_update_must") String get mustUpdate;
/// Create a copy of UpdateMsgDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateMsgDtoCopyWith<UpdateMsgDto> get copyWith => _$UpdateMsgDtoCopyWithImpl<UpdateMsgDto>(this as UpdateMsgDto, _$identity);

  /// Serializes this UpdateMsgDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateMsgDto&&(identical(other.version, version) || other.version == version)&&(identical(other.url, url) || other.url == url)&&(identical(other.content, content) || other.content == content)&&(identical(other.mustUpdate, mustUpdate) || other.mustUpdate == mustUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,url,content,mustUpdate);

@override
String toString() {
  return 'UpdateMsgDto(version: $version, url: $url, content: $content, mustUpdate: $mustUpdate)';
}


}

/// @nodoc
abstract mixin class $UpdateMsgDtoCopyWith<$Res>  {
  factory $UpdateMsgDtoCopyWith(UpdateMsgDto value, $Res Function(UpdateMsgDto) _then) = _$UpdateMsgDtoCopyWithImpl;
@useResult
$Res call({
 String version,@JsonKey(name: "app_update_url") String url,@JsonKey(name: "app_update_show") String content,@JsonKey(name: "app_update_must") String mustUpdate
});




}
/// @nodoc
class _$UpdateMsgDtoCopyWithImpl<$Res>
    implements $UpdateMsgDtoCopyWith<$Res> {
  _$UpdateMsgDtoCopyWithImpl(this._self, this._then);

  final UpdateMsgDto _self;
  final $Res Function(UpdateMsgDto) _then;

/// Create a copy of UpdateMsgDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? url = null,Object? content = null,Object? mustUpdate = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mustUpdate: null == mustUpdate ? _self.mustUpdate : mustUpdate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateMsgDto].
extension UpdateMsgDtoPatterns on UpdateMsgDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateMsgDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateMsgDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateMsgDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateMsgDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateMsgDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateMsgDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version, @JsonKey(name: "app_update_url")  String url, @JsonKey(name: "app_update_show")  String content, @JsonKey(name: "app_update_must")  String mustUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateMsgDto() when $default != null:
return $default(_that.version,_that.url,_that.content,_that.mustUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version, @JsonKey(name: "app_update_url")  String url, @JsonKey(name: "app_update_show")  String content, @JsonKey(name: "app_update_must")  String mustUpdate)  $default,) {final _that = this;
switch (_that) {
case _UpdateMsgDto():
return $default(_that.version,_that.url,_that.content,_that.mustUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version, @JsonKey(name: "app_update_url")  String url, @JsonKey(name: "app_update_show")  String content, @JsonKey(name: "app_update_must")  String mustUpdate)?  $default,) {final _that = this;
switch (_that) {
case _UpdateMsgDto() when $default != null:
return $default(_that.version,_that.url,_that.content,_that.mustUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateMsgDto extends UpdateMsgDto {
  const _UpdateMsgDto({this.version = '-1', @JsonKey(name: "app_update_url") this.url = '', @JsonKey(name: "app_update_show") this.content = '', @JsonKey(name: "app_update_must") this.mustUpdate = ''}): super._();
  factory _UpdateMsgDto.fromJson(Map<String, dynamic> json) => _$UpdateMsgDtoFromJson(json);

@override@JsonKey() final  String version;
@override@JsonKey(name: "app_update_url") final  String url;
@override@JsonKey(name: "app_update_show") final  String content;
@override@JsonKey(name: "app_update_must") final  String mustUpdate;

/// Create a copy of UpdateMsgDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateMsgDtoCopyWith<_UpdateMsgDto> get copyWith => __$UpdateMsgDtoCopyWithImpl<_UpdateMsgDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateMsgDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateMsgDto&&(identical(other.version, version) || other.version == version)&&(identical(other.url, url) || other.url == url)&&(identical(other.content, content) || other.content == content)&&(identical(other.mustUpdate, mustUpdate) || other.mustUpdate == mustUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,url,content,mustUpdate);

@override
String toString() {
  return 'UpdateMsgDto(version: $version, url: $url, content: $content, mustUpdate: $mustUpdate)';
}


}

/// @nodoc
abstract mixin class _$UpdateMsgDtoCopyWith<$Res> implements $UpdateMsgDtoCopyWith<$Res> {
  factory _$UpdateMsgDtoCopyWith(_UpdateMsgDto value, $Res Function(_UpdateMsgDto) _then) = __$UpdateMsgDtoCopyWithImpl;
@override @useResult
$Res call({
 String version,@JsonKey(name: "app_update_url") String url,@JsonKey(name: "app_update_show") String content,@JsonKey(name: "app_update_must") String mustUpdate
});




}
/// @nodoc
class __$UpdateMsgDtoCopyWithImpl<$Res>
    implements _$UpdateMsgDtoCopyWith<$Res> {
  __$UpdateMsgDtoCopyWithImpl(this._self, this._then);

  final _UpdateMsgDto _self;
  final $Res Function(_UpdateMsgDto) _then;

/// Create a copy of UpdateMsgDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? url = null,Object? content = null,Object? mustUpdate = null,}) {
  return _then(_UpdateMsgDto(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mustUpdate: null == mustUpdate ? _self.mustUpdate : mustUpdate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
