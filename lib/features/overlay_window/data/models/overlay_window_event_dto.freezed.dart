// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_window_event_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OverlayWindowEventDto {

 OverlayWindowEventType get type; double? get hostX; double? get hostY;
/// Create a copy of OverlayWindowEventDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayWindowEventDtoCopyWith<OverlayWindowEventDto> get copyWith => _$OverlayWindowEventDtoCopyWithImpl<OverlayWindowEventDto>(this as OverlayWindowEventDto, _$identity);

  /// Serializes this OverlayWindowEventDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayWindowEventDto&&(identical(other.type, type) || other.type == type)&&(identical(other.hostX, hostX) || other.hostX == hostX)&&(identical(other.hostY, hostY) || other.hostY == hostY));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,hostX,hostY);

@override
String toString() {
  return 'OverlayWindowEventDto(type: $type, hostX: $hostX, hostY: $hostY)';
}


}

/// @nodoc
abstract mixin class $OverlayWindowEventDtoCopyWith<$Res>  {
  factory $OverlayWindowEventDtoCopyWith(OverlayWindowEventDto value, $Res Function(OverlayWindowEventDto) _then) = _$OverlayWindowEventDtoCopyWithImpl;
@useResult
$Res call({
 OverlayWindowEventType type, double? hostX, double? hostY
});




}
/// @nodoc
class _$OverlayWindowEventDtoCopyWithImpl<$Res>
    implements $OverlayWindowEventDtoCopyWith<$Res> {
  _$OverlayWindowEventDtoCopyWithImpl(this._self, this._then);

  final OverlayWindowEventDto _self;
  final $Res Function(OverlayWindowEventDto) _then;

/// Create a copy of OverlayWindowEventDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? hostX = freezed,Object? hostY = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OverlayWindowEventType,hostX: freezed == hostX ? _self.hostX : hostX // ignore: cast_nullable_to_non_nullable
as double?,hostY: freezed == hostY ? _self.hostY : hostY // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayWindowEventDto].
extension OverlayWindowEventDtoPatterns on OverlayWindowEventDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayWindowEventDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayWindowEventDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayWindowEventDto value)  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowEventDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayWindowEventDto value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowEventDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OverlayWindowEventType type,  double? hostX,  double? hostY)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayWindowEventDto() when $default != null:
return $default(_that.type,_that.hostX,_that.hostY);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OverlayWindowEventType type,  double? hostX,  double? hostY)  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowEventDto():
return $default(_that.type,_that.hostX,_that.hostY);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OverlayWindowEventType type,  double? hostX,  double? hostY)?  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowEventDto() when $default != null:
return $default(_that.type,_that.hostX,_that.hostY);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OverlayWindowEventDto extends OverlayWindowEventDto {
  const _OverlayWindowEventDto({required this.type, this.hostX, this.hostY}): super._();
  factory _OverlayWindowEventDto.fromJson(Map<String, dynamic> json) => _$OverlayWindowEventDtoFromJson(json);

@override final  OverlayWindowEventType type;
@override final  double? hostX;
@override final  double? hostY;

/// Create a copy of OverlayWindowEventDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayWindowEventDtoCopyWith<_OverlayWindowEventDto> get copyWith => __$OverlayWindowEventDtoCopyWithImpl<_OverlayWindowEventDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverlayWindowEventDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayWindowEventDto&&(identical(other.type, type) || other.type == type)&&(identical(other.hostX, hostX) || other.hostX == hostX)&&(identical(other.hostY, hostY) || other.hostY == hostY));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,hostX,hostY);

@override
String toString() {
  return 'OverlayWindowEventDto(type: $type, hostX: $hostX, hostY: $hostY)';
}


}

/// @nodoc
abstract mixin class _$OverlayWindowEventDtoCopyWith<$Res> implements $OverlayWindowEventDtoCopyWith<$Res> {
  factory _$OverlayWindowEventDtoCopyWith(_OverlayWindowEventDto value, $Res Function(_OverlayWindowEventDto) _then) = __$OverlayWindowEventDtoCopyWithImpl;
@override @useResult
$Res call({
 OverlayWindowEventType type, double? hostX, double? hostY
});




}
/// @nodoc
class __$OverlayWindowEventDtoCopyWithImpl<$Res>
    implements _$OverlayWindowEventDtoCopyWith<$Res> {
  __$OverlayWindowEventDtoCopyWithImpl(this._self, this._then);

  final _OverlayWindowEventDto _self;
  final $Res Function(_OverlayWindowEventDto) _then;

/// Create a copy of OverlayWindowEventDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? hostX = freezed,Object? hostY = freezed,}) {
  return _then(_OverlayWindowEventDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OverlayWindowEventType,hostX: freezed == hostX ? _self.hostX : hostX // ignore: cast_nullable_to_non_nullable
as double?,hostY: freezed == hostY ? _self.hostY : hostY // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
