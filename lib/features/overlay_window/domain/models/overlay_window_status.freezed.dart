// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_window_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverlayWindowStatus {

 bool get isSupported; bool get hasPermission; bool get isActive;
/// Create a copy of OverlayWindowStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayWindowStatusCopyWith<OverlayWindowStatus> get copyWith => _$OverlayWindowStatusCopyWithImpl<OverlayWindowStatus>(this as OverlayWindowStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayWindowStatus&&(identical(other.isSupported, isSupported) || other.isSupported == isSupported)&&(identical(other.hasPermission, hasPermission) || other.hasPermission == hasPermission)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,isSupported,hasPermission,isActive);

@override
String toString() {
  return 'OverlayWindowStatus(isSupported: $isSupported, hasPermission: $hasPermission, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $OverlayWindowStatusCopyWith<$Res>  {
  factory $OverlayWindowStatusCopyWith(OverlayWindowStatus value, $Res Function(OverlayWindowStatus) _then) = _$OverlayWindowStatusCopyWithImpl;
@useResult
$Res call({
 bool isSupported, bool hasPermission, bool isActive
});




}
/// @nodoc
class _$OverlayWindowStatusCopyWithImpl<$Res>
    implements $OverlayWindowStatusCopyWith<$Res> {
  _$OverlayWindowStatusCopyWithImpl(this._self, this._then);

  final OverlayWindowStatus _self;
  final $Res Function(OverlayWindowStatus) _then;

/// Create a copy of OverlayWindowStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSupported = null,Object? hasPermission = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
isSupported: null == isSupported ? _self.isSupported : isSupported // ignore: cast_nullable_to_non_nullable
as bool,hasPermission: null == hasPermission ? _self.hasPermission : hasPermission // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayWindowStatus].
extension OverlayWindowStatusPatterns on OverlayWindowStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayWindowStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayWindowStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayWindowStatus value)  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayWindowStatus value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSupported,  bool hasPermission,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayWindowStatus() when $default != null:
return $default(_that.isSupported,_that.hasPermission,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSupported,  bool hasPermission,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowStatus():
return $default(_that.isSupported,_that.hasPermission,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSupported,  bool hasPermission,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowStatus() when $default != null:
return $default(_that.isSupported,_that.hasPermission,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _OverlayWindowStatus extends OverlayWindowStatus {
  const _OverlayWindowStatus({required this.isSupported, required this.hasPermission, required this.isActive}): super._();
  

@override final  bool isSupported;
@override final  bool hasPermission;
@override final  bool isActive;

/// Create a copy of OverlayWindowStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayWindowStatusCopyWith<_OverlayWindowStatus> get copyWith => __$OverlayWindowStatusCopyWithImpl<_OverlayWindowStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayWindowStatus&&(identical(other.isSupported, isSupported) || other.isSupported == isSupported)&&(identical(other.hasPermission, hasPermission) || other.hasPermission == hasPermission)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,isSupported,hasPermission,isActive);

@override
String toString() {
  return 'OverlayWindowStatus(isSupported: $isSupported, hasPermission: $hasPermission, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$OverlayWindowStatusCopyWith<$Res> implements $OverlayWindowStatusCopyWith<$Res> {
  factory _$OverlayWindowStatusCopyWith(_OverlayWindowStatus value, $Res Function(_OverlayWindowStatus) _then) = __$OverlayWindowStatusCopyWithImpl;
@override @useResult
$Res call({
 bool isSupported, bool hasPermission, bool isActive
});




}
/// @nodoc
class __$OverlayWindowStatusCopyWithImpl<$Res>
    implements _$OverlayWindowStatusCopyWith<$Res> {
  __$OverlayWindowStatusCopyWithImpl(this._self, this._then);

  final _OverlayWindowStatus _self;
  final $Res Function(_OverlayWindowStatus) _then;

/// Create a copy of OverlayWindowStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSupported = null,Object? hasPermission = null,Object? isActive = null,}) {
  return _then(_OverlayWindowStatus(
isSupported: null == isSupported ? _self.isSupported : isSupported // ignore: cast_nullable_to_non_nullable
as bool,hasPermission: null == hasPermission ? _self.hasPermission : hasPermission // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
