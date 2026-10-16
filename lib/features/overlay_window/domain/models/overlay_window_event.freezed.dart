// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_window_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverlayWindowEvent {

 OverlayWindowEventType get type; Offset? get hostPosition;
/// Create a copy of OverlayWindowEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayWindowEventCopyWith<OverlayWindowEvent> get copyWith => _$OverlayWindowEventCopyWithImpl<OverlayWindowEvent>(this as OverlayWindowEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayWindowEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.hostPosition, hostPosition) || other.hostPosition == hostPosition));
}


@override
int get hashCode => Object.hash(runtimeType,type,hostPosition);

@override
String toString() {
  return 'OverlayWindowEvent(type: $type, hostPosition: $hostPosition)';
}


}

/// @nodoc
abstract mixin class $OverlayWindowEventCopyWith<$Res>  {
  factory $OverlayWindowEventCopyWith(OverlayWindowEvent value, $Res Function(OverlayWindowEvent) _then) = _$OverlayWindowEventCopyWithImpl;
@useResult
$Res call({
 OverlayWindowEventType type, Offset? hostPosition
});




}
/// @nodoc
class _$OverlayWindowEventCopyWithImpl<$Res>
    implements $OverlayWindowEventCopyWith<$Res> {
  _$OverlayWindowEventCopyWithImpl(this._self, this._then);

  final OverlayWindowEvent _self;
  final $Res Function(OverlayWindowEvent) _then;

/// Create a copy of OverlayWindowEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? hostPosition = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OverlayWindowEventType,hostPosition: freezed == hostPosition ? _self.hostPosition : hostPosition // ignore: cast_nullable_to_non_nullable
as Offset?,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayWindowEvent].
extension OverlayWindowEventPatterns on OverlayWindowEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayWindowEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayWindowEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayWindowEvent value)  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayWindowEvent value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OverlayWindowEventType type,  Offset? hostPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayWindowEvent() when $default != null:
return $default(_that.type,_that.hostPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OverlayWindowEventType type,  Offset? hostPosition)  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowEvent():
return $default(_that.type,_that.hostPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OverlayWindowEventType type,  Offset? hostPosition)?  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowEvent() when $default != null:
return $default(_that.type,_that.hostPosition);case _:
  return null;

}
}

}

/// @nodoc


class _OverlayWindowEvent extends OverlayWindowEvent {
  const _OverlayWindowEvent({required this.type, this.hostPosition}): super._();
  

@override final  OverlayWindowEventType type;
@override final  Offset? hostPosition;

/// Create a copy of OverlayWindowEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayWindowEventCopyWith<_OverlayWindowEvent> get copyWith => __$OverlayWindowEventCopyWithImpl<_OverlayWindowEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayWindowEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.hostPosition, hostPosition) || other.hostPosition == hostPosition));
}


@override
int get hashCode => Object.hash(runtimeType,type,hostPosition);

@override
String toString() {
  return 'OverlayWindowEvent(type: $type, hostPosition: $hostPosition)';
}


}

/// @nodoc
abstract mixin class _$OverlayWindowEventCopyWith<$Res> implements $OverlayWindowEventCopyWith<$Res> {
  factory _$OverlayWindowEventCopyWith(_OverlayWindowEvent value, $Res Function(_OverlayWindowEvent) _then) = __$OverlayWindowEventCopyWithImpl;
@override @useResult
$Res call({
 OverlayWindowEventType type, Offset? hostPosition
});




}
/// @nodoc
class __$OverlayWindowEventCopyWithImpl<$Res>
    implements _$OverlayWindowEventCopyWith<$Res> {
  __$OverlayWindowEventCopyWithImpl(this._self, this._then);

  final _OverlayWindowEvent _self;
  final $Res Function(_OverlayWindowEvent) _then;

/// Create a copy of OverlayWindowEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? hostPosition = freezed,}) {
  return _then(_OverlayWindowEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OverlayWindowEventType,hostPosition: freezed == hostPosition ? _self.hostPosition : hostPosition // ignore: cast_nullable_to_non_nullable
as Offset?,
  ));
}


}

// dart format on
