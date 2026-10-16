// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiSession {

 String get id; String get name; String get packageName; DateTime get lastUpdateTime; String get lastMessage;
/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSessionCopyWith<AiSession> get copyWith => _$AiSessionCopyWithImpl<AiSession>(this as AiSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSession&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.lastUpdateTime, lastUpdateTime) || other.lastUpdateTime == lastUpdateTime)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,packageName,lastUpdateTime,lastMessage);

@override
String toString() {
  return 'AiSession(id: $id, name: $name, packageName: $packageName, lastUpdateTime: $lastUpdateTime, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class $AiSessionCopyWith<$Res>  {
  factory $AiSessionCopyWith(AiSession value, $Res Function(AiSession) _then) = _$AiSessionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String packageName, DateTime lastUpdateTime, String lastMessage
});




}
/// @nodoc
class _$AiSessionCopyWithImpl<$Res>
    implements $AiSessionCopyWith<$Res> {
  _$AiSessionCopyWithImpl(this._self, this._then);

  final AiSession _self;
  final $Res Function(AiSession) _then;

/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? packageName = null,Object? lastUpdateTime = null,Object? lastMessage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,lastUpdateTime: null == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiSession].
extension AiSessionPatterns on AiSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSession value)  $default,){
final _that = this;
switch (_that) {
case _AiSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSession value)?  $default,){
final _that = this;
switch (_that) {
case _AiSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String packageName,  DateTime lastUpdateTime,  String lastMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiSession() when $default != null:
return $default(_that.id,_that.name,_that.packageName,_that.lastUpdateTime,_that.lastMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String packageName,  DateTime lastUpdateTime,  String lastMessage)  $default,) {final _that = this;
switch (_that) {
case _AiSession():
return $default(_that.id,_that.name,_that.packageName,_that.lastUpdateTime,_that.lastMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String packageName,  DateTime lastUpdateTime,  String lastMessage)?  $default,) {final _that = this;
switch (_that) {
case _AiSession() when $default != null:
return $default(_that.id,_that.name,_that.packageName,_that.lastUpdateTime,_that.lastMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AiSession implements AiSession {
  const _AiSession({required this.id, required this.name, required this.packageName, required this.lastUpdateTime, required this.lastMessage});
  

@override final  String id;
@override final  String name;
@override final  String packageName;
@override final  DateTime lastUpdateTime;
@override final  String lastMessage;

/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSessionCopyWith<_AiSession> get copyWith => __$AiSessionCopyWithImpl<_AiSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSession&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.lastUpdateTime, lastUpdateTime) || other.lastUpdateTime == lastUpdateTime)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,packageName,lastUpdateTime,lastMessage);

@override
String toString() {
  return 'AiSession(id: $id, name: $name, packageName: $packageName, lastUpdateTime: $lastUpdateTime, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class _$AiSessionCopyWith<$Res> implements $AiSessionCopyWith<$Res> {
  factory _$AiSessionCopyWith(_AiSession value, $Res Function(_AiSession) _then) = __$AiSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String packageName, DateTime lastUpdateTime, String lastMessage
});




}
/// @nodoc
class __$AiSessionCopyWithImpl<$Res>
    implements _$AiSessionCopyWith<$Res> {
  __$AiSessionCopyWithImpl(this._self, this._then);

  final _AiSession _self;
  final $Res Function(_AiSession) _then;

/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? packageName = null,Object? lastUpdateTime = null,Object? lastMessage = null,}) {
  return _then(_AiSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,lastUpdateTime: null == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as DateTime,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
