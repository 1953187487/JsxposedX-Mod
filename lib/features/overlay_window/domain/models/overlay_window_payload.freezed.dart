// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_window_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverlayWindowPayload {

 int get sceneId; OverlayWindowDisplayMode get displayMode; String get localeLanguageCode; String get localeCountryCode; bool get isDarkTheme; int get primaryColorValue;
/// Create a copy of OverlayWindowPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayWindowPayloadCopyWith<OverlayWindowPayload> get copyWith => _$OverlayWindowPayloadCopyWithImpl<OverlayWindowPayload>(this as OverlayWindowPayload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayWindowPayload&&(identical(other.sceneId, sceneId) || other.sceneId == sceneId)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode)&&(identical(other.localeLanguageCode, localeLanguageCode) || other.localeLanguageCode == localeLanguageCode)&&(identical(other.localeCountryCode, localeCountryCode) || other.localeCountryCode == localeCountryCode)&&(identical(other.isDarkTheme, isDarkTheme) || other.isDarkTheme == isDarkTheme)&&(identical(other.primaryColorValue, primaryColorValue) || other.primaryColorValue == primaryColorValue));
}


@override
int get hashCode => Object.hash(runtimeType,sceneId,displayMode,localeLanguageCode,localeCountryCode,isDarkTheme,primaryColorValue);

@override
String toString() {
  return 'OverlayWindowPayload(sceneId: $sceneId, displayMode: $displayMode, localeLanguageCode: $localeLanguageCode, localeCountryCode: $localeCountryCode, isDarkTheme: $isDarkTheme, primaryColorValue: $primaryColorValue)';
}


}

/// @nodoc
abstract mixin class $OverlayWindowPayloadCopyWith<$Res>  {
  factory $OverlayWindowPayloadCopyWith(OverlayWindowPayload value, $Res Function(OverlayWindowPayload) _then) = _$OverlayWindowPayloadCopyWithImpl;
@useResult
$Res call({
 int sceneId, OverlayWindowDisplayMode displayMode, String localeLanguageCode, String localeCountryCode, bool isDarkTheme, int primaryColorValue
});




}
/// @nodoc
class _$OverlayWindowPayloadCopyWithImpl<$Res>
    implements $OverlayWindowPayloadCopyWith<$Res> {
  _$OverlayWindowPayloadCopyWithImpl(this._self, this._then);

  final OverlayWindowPayload _self;
  final $Res Function(OverlayWindowPayload) _then;

/// Create a copy of OverlayWindowPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sceneId = null,Object? displayMode = null,Object? localeLanguageCode = null,Object? localeCountryCode = null,Object? isDarkTheme = null,Object? primaryColorValue = null,}) {
  return _then(_self.copyWith(
sceneId: null == sceneId ? _self.sceneId : sceneId // ignore: cast_nullable_to_non_nullable
as int,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as OverlayWindowDisplayMode,localeLanguageCode: null == localeLanguageCode ? _self.localeLanguageCode : localeLanguageCode // ignore: cast_nullable_to_non_nullable
as String,localeCountryCode: null == localeCountryCode ? _self.localeCountryCode : localeCountryCode // ignore: cast_nullable_to_non_nullable
as String,isDarkTheme: null == isDarkTheme ? _self.isDarkTheme : isDarkTheme // ignore: cast_nullable_to_non_nullable
as bool,primaryColorValue: null == primaryColorValue ? _self.primaryColorValue : primaryColorValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayWindowPayload].
extension OverlayWindowPayloadPatterns on OverlayWindowPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayWindowPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayWindowPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayWindowPayload value)  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayWindowPayload value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sceneId,  OverlayWindowDisplayMode displayMode,  String localeLanguageCode,  String localeCountryCode,  bool isDarkTheme,  int primaryColorValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayWindowPayload() when $default != null:
return $default(_that.sceneId,_that.displayMode,_that.localeLanguageCode,_that.localeCountryCode,_that.isDarkTheme,_that.primaryColorValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sceneId,  OverlayWindowDisplayMode displayMode,  String localeLanguageCode,  String localeCountryCode,  bool isDarkTheme,  int primaryColorValue)  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowPayload():
return $default(_that.sceneId,_that.displayMode,_that.localeLanguageCode,_that.localeCountryCode,_that.isDarkTheme,_that.primaryColorValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sceneId,  OverlayWindowDisplayMode displayMode,  String localeLanguageCode,  String localeCountryCode,  bool isDarkTheme,  int primaryColorValue)?  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowPayload() when $default != null:
return $default(_that.sceneId,_that.displayMode,_that.localeLanguageCode,_that.localeCountryCode,_that.isDarkTheme,_that.primaryColorValue);case _:
  return null;

}
}

}

/// @nodoc


class _OverlayWindowPayload extends OverlayWindowPayload {
  const _OverlayWindowPayload({required this.sceneId, required this.displayMode, required this.localeLanguageCode, required this.localeCountryCode, required this.isDarkTheme, required this.primaryColorValue}): super._();
  

@override final  int sceneId;
@override final  OverlayWindowDisplayMode displayMode;
@override final  String localeLanguageCode;
@override final  String localeCountryCode;
@override final  bool isDarkTheme;
@override final  int primaryColorValue;

/// Create a copy of OverlayWindowPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayWindowPayloadCopyWith<_OverlayWindowPayload> get copyWith => __$OverlayWindowPayloadCopyWithImpl<_OverlayWindowPayload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayWindowPayload&&(identical(other.sceneId, sceneId) || other.sceneId == sceneId)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode)&&(identical(other.localeLanguageCode, localeLanguageCode) || other.localeLanguageCode == localeLanguageCode)&&(identical(other.localeCountryCode, localeCountryCode) || other.localeCountryCode == localeCountryCode)&&(identical(other.isDarkTheme, isDarkTheme) || other.isDarkTheme == isDarkTheme)&&(identical(other.primaryColorValue, primaryColorValue) || other.primaryColorValue == primaryColorValue));
}


@override
int get hashCode => Object.hash(runtimeType,sceneId,displayMode,localeLanguageCode,localeCountryCode,isDarkTheme,primaryColorValue);

@override
String toString() {
  return 'OverlayWindowPayload(sceneId: $sceneId, displayMode: $displayMode, localeLanguageCode: $localeLanguageCode, localeCountryCode: $localeCountryCode, isDarkTheme: $isDarkTheme, primaryColorValue: $primaryColorValue)';
}


}

/// @nodoc
abstract mixin class _$OverlayWindowPayloadCopyWith<$Res> implements $OverlayWindowPayloadCopyWith<$Res> {
  factory _$OverlayWindowPayloadCopyWith(_OverlayWindowPayload value, $Res Function(_OverlayWindowPayload) _then) = __$OverlayWindowPayloadCopyWithImpl;
@override @useResult
$Res call({
 int sceneId, OverlayWindowDisplayMode displayMode, String localeLanguageCode, String localeCountryCode, bool isDarkTheme, int primaryColorValue
});




}
/// @nodoc
class __$OverlayWindowPayloadCopyWithImpl<$Res>
    implements _$OverlayWindowPayloadCopyWith<$Res> {
  __$OverlayWindowPayloadCopyWithImpl(this._self, this._then);

  final _OverlayWindowPayload _self;
  final $Res Function(_OverlayWindowPayload) _then;

/// Create a copy of OverlayWindowPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sceneId = null,Object? displayMode = null,Object? localeLanguageCode = null,Object? localeCountryCode = null,Object? isDarkTheme = null,Object? primaryColorValue = null,}) {
  return _then(_OverlayWindowPayload(
sceneId: null == sceneId ? _self.sceneId : sceneId // ignore: cast_nullable_to_non_nullable
as int,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as OverlayWindowDisplayMode,localeLanguageCode: null == localeLanguageCode ? _self.localeLanguageCode : localeLanguageCode // ignore: cast_nullable_to_non_nullable
as String,localeCountryCode: null == localeCountryCode ? _self.localeCountryCode : localeCountryCode // ignore: cast_nullable_to_non_nullable
as String,isDarkTheme: null == isDarkTheme ? _self.isDarkTheme : isDarkTheme // ignore: cast_nullable_to_non_nullable
as bool,primaryColorValue: null == primaryColorValue ? _self.primaryColorValue : primaryColorValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
