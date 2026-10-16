// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Update {

 int get code; UpdateMsg get msg; String get check;
/// Create a copy of Update
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateCopyWith<Update> get copyWith => _$UpdateCopyWithImpl<Update>(this as Update, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Update&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.check, check) || other.check == check));
}


@override
int get hashCode => Object.hash(runtimeType,code,msg,check);

@override
String toString() {
  return 'Update(code: $code, msg: $msg, check: $check)';
}


}

/// @nodoc
abstract mixin class $UpdateCopyWith<$Res>  {
  factory $UpdateCopyWith(Update value, $Res Function(Update) _then) = _$UpdateCopyWithImpl;
@useResult
$Res call({
 int code, UpdateMsg msg, String check
});


$UpdateMsgCopyWith<$Res> get msg;

}
/// @nodoc
class _$UpdateCopyWithImpl<$Res>
    implements $UpdateCopyWith<$Res> {
  _$UpdateCopyWithImpl(this._self, this._then);

  final Update _self;
  final $Res Function(Update) _then;

/// Create a copy of Update
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? msg = null,Object? check = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as UpdateMsg,check: null == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Update
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateMsgCopyWith<$Res> get msg {
  
  return $UpdateMsgCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}


/// Adds pattern-matching-related methods to [Update].
extension UpdatePatterns on Update {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Update value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Update() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Update value)  $default,){
final _that = this;
switch (_that) {
case _Update():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Update value)?  $default,){
final _that = this;
switch (_that) {
case _Update() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int code,  UpdateMsg msg,  String check)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Update() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int code,  UpdateMsg msg,  String check)  $default,) {final _that = this;
switch (_that) {
case _Update():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int code,  UpdateMsg msg,  String check)?  $default,) {final _that = this;
switch (_that) {
case _Update() when $default != null:
return $default(_that.code,_that.msg,_that.check);case _:
  return null;

}
}

}

/// @nodoc


class _Update extends Update {
  const _Update({required this.code, required this.msg, required this.check}): super._();
  

@override final  int code;
@override final  UpdateMsg msg;
@override final  String check;

/// Create a copy of Update
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCopyWith<_Update> get copyWith => __$UpdateCopyWithImpl<_Update>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Update&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.check, check) || other.check == check));
}


@override
int get hashCode => Object.hash(runtimeType,code,msg,check);

@override
String toString() {
  return 'Update(code: $code, msg: $msg, check: $check)';
}


}

/// @nodoc
abstract mixin class _$UpdateCopyWith<$Res> implements $UpdateCopyWith<$Res> {
  factory _$UpdateCopyWith(_Update value, $Res Function(_Update) _then) = __$UpdateCopyWithImpl;
@override @useResult
$Res call({
 int code, UpdateMsg msg, String check
});


@override $UpdateMsgCopyWith<$Res> get msg;

}
/// @nodoc
class __$UpdateCopyWithImpl<$Res>
    implements _$UpdateCopyWith<$Res> {
  __$UpdateCopyWithImpl(this._self, this._then);

  final _Update _self;
  final $Res Function(_Update) _then;

/// Create a copy of Update
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? msg = null,Object? check = null,}) {
  return _then(_Update(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as UpdateMsg,check: null == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Update
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateMsgCopyWith<$Res> get msg {
  
  return $UpdateMsgCopyWith<$Res>(_self.msg, (value) {
    return _then(_self.copyWith(msg: value));
  });
}
}

/// @nodoc
mixin _$UpdateMsg {

 String get version; String get url; String get content; String get mustUpdate;
/// Create a copy of UpdateMsg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateMsgCopyWith<UpdateMsg> get copyWith => _$UpdateMsgCopyWithImpl<UpdateMsg>(this as UpdateMsg, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateMsg&&(identical(other.version, version) || other.version == version)&&(identical(other.url, url) || other.url == url)&&(identical(other.content, content) || other.content == content)&&(identical(other.mustUpdate, mustUpdate) || other.mustUpdate == mustUpdate));
}


@override
int get hashCode => Object.hash(runtimeType,version,url,content,mustUpdate);

@override
String toString() {
  return 'UpdateMsg(version: $version, url: $url, content: $content, mustUpdate: $mustUpdate)';
}


}

/// @nodoc
abstract mixin class $UpdateMsgCopyWith<$Res>  {
  factory $UpdateMsgCopyWith(UpdateMsg value, $Res Function(UpdateMsg) _then) = _$UpdateMsgCopyWithImpl;
@useResult
$Res call({
 String version, String url, String content, String mustUpdate
});




}
/// @nodoc
class _$UpdateMsgCopyWithImpl<$Res>
    implements $UpdateMsgCopyWith<$Res> {
  _$UpdateMsgCopyWithImpl(this._self, this._then);

  final UpdateMsg _self;
  final $Res Function(UpdateMsg) _then;

/// Create a copy of UpdateMsg
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


/// Adds pattern-matching-related methods to [UpdateMsg].
extension UpdateMsgPatterns on UpdateMsg {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateMsg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateMsg() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateMsg value)  $default,){
final _that = this;
switch (_that) {
case _UpdateMsg():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateMsg value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateMsg() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String url,  String content,  String mustUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateMsg() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String url,  String content,  String mustUpdate)  $default,) {final _that = this;
switch (_that) {
case _UpdateMsg():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String url,  String content,  String mustUpdate)?  $default,) {final _that = this;
switch (_that) {
case _UpdateMsg() when $default != null:
return $default(_that.version,_that.url,_that.content,_that.mustUpdate);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateMsg extends UpdateMsg {
  const _UpdateMsg({required this.version, required this.url, required this.content, required this.mustUpdate}): super._();
  

@override final  String version;
@override final  String url;
@override final  String content;
@override final  String mustUpdate;

/// Create a copy of UpdateMsg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateMsgCopyWith<_UpdateMsg> get copyWith => __$UpdateMsgCopyWithImpl<_UpdateMsg>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateMsg&&(identical(other.version, version) || other.version == version)&&(identical(other.url, url) || other.url == url)&&(identical(other.content, content) || other.content == content)&&(identical(other.mustUpdate, mustUpdate) || other.mustUpdate == mustUpdate));
}


@override
int get hashCode => Object.hash(runtimeType,version,url,content,mustUpdate);

@override
String toString() {
  return 'UpdateMsg(version: $version, url: $url, content: $content, mustUpdate: $mustUpdate)';
}


}

/// @nodoc
abstract mixin class _$UpdateMsgCopyWith<$Res> implements $UpdateMsgCopyWith<$Res> {
  factory _$UpdateMsgCopyWith(_UpdateMsg value, $Res Function(_UpdateMsg) _then) = __$UpdateMsgCopyWithImpl;
@override @useResult
$Res call({
 String version, String url, String content, String mustUpdate
});




}
/// @nodoc
class __$UpdateMsgCopyWithImpl<$Res>
    implements _$UpdateMsgCopyWith<$Res> {
  __$UpdateMsgCopyWithImpl(this._self, this._then);

  final _UpdateMsg _self;
  final $Res Function(_UpdateMsg) _then;

/// Create a copy of UpdateMsg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? url = null,Object? content = null,Object? mustUpdate = null,}) {
  return _then(_UpdateMsg(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mustUpdate: null == mustUpdate ? _self.mustUpdate : mustUpdate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
