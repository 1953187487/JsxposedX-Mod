// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_host_layout_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OverlayHostLayoutDto {

 int get width; int get height; double get x; double get y; bool get enableDrag; OverlayWindowDisplayMode get displayMode;
/// Create a copy of OverlayHostLayoutDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayHostLayoutDtoCopyWith<OverlayHostLayoutDto> get copyWith => _$OverlayHostLayoutDtoCopyWithImpl<OverlayHostLayoutDto>(this as OverlayHostLayoutDto, _$identity);

  /// Serializes this OverlayHostLayoutDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayHostLayoutDto&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.enableDrag, enableDrag) || other.enableDrag == enableDrag)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,x,y,enableDrag,displayMode);

@override
String toString() {
  return 'OverlayHostLayoutDto(width: $width, height: $height, x: $x, y: $y, enableDrag: $enableDrag, displayMode: $displayMode)';
}


}

/// @nodoc
abstract mixin class $OverlayHostLayoutDtoCopyWith<$Res>  {
  factory $OverlayHostLayoutDtoCopyWith(OverlayHostLayoutDto value, $Res Function(OverlayHostLayoutDto) _then) = _$OverlayHostLayoutDtoCopyWithImpl;
@useResult
$Res call({
 int width, int height, double x, double y, bool enableDrag, OverlayWindowDisplayMode displayMode
});




}
/// @nodoc
class _$OverlayHostLayoutDtoCopyWithImpl<$Res>
    implements $OverlayHostLayoutDtoCopyWith<$Res> {
  _$OverlayHostLayoutDtoCopyWithImpl(this._self, this._then);

  final OverlayHostLayoutDto _self;
  final $Res Function(OverlayHostLayoutDto) _then;

/// Create a copy of OverlayHostLayoutDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? x = null,Object? y = null,Object? enableDrag = null,Object? displayMode = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,enableDrag: null == enableDrag ? _self.enableDrag : enableDrag // ignore: cast_nullable_to_non_nullable
as bool,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as OverlayWindowDisplayMode,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayHostLayoutDto].
extension OverlayHostLayoutDtoPatterns on OverlayHostLayoutDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayHostLayoutDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayHostLayoutDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayHostLayoutDto value)  $default,){
final _that = this;
switch (_that) {
case _OverlayHostLayoutDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayHostLayoutDto value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayHostLayoutDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int width,  int height,  double x,  double y,  bool enableDrag,  OverlayWindowDisplayMode displayMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayHostLayoutDto() when $default != null:
return $default(_that.width,_that.height,_that.x,_that.y,_that.enableDrag,_that.displayMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int width,  int height,  double x,  double y,  bool enableDrag,  OverlayWindowDisplayMode displayMode)  $default,) {final _that = this;
switch (_that) {
case _OverlayHostLayoutDto():
return $default(_that.width,_that.height,_that.x,_that.y,_that.enableDrag,_that.displayMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int width,  int height,  double x,  double y,  bool enableDrag,  OverlayWindowDisplayMode displayMode)?  $default,) {final _that = this;
switch (_that) {
case _OverlayHostLayoutDto() when $default != null:
return $default(_that.width,_that.height,_that.x,_that.y,_that.enableDrag,_that.displayMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OverlayHostLayoutDto extends OverlayHostLayoutDto {
  const _OverlayHostLayoutDto({required this.width, required this.height, required this.x, required this.y, required this.enableDrag, required this.displayMode}): super._();
  factory _OverlayHostLayoutDto.fromJson(Map<String, dynamic> json) => _$OverlayHostLayoutDtoFromJson(json);

@override final  int width;
@override final  int height;
@override final  double x;
@override final  double y;
@override final  bool enableDrag;
@override final  OverlayWindowDisplayMode displayMode;

/// Create a copy of OverlayHostLayoutDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayHostLayoutDtoCopyWith<_OverlayHostLayoutDto> get copyWith => __$OverlayHostLayoutDtoCopyWithImpl<_OverlayHostLayoutDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverlayHostLayoutDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayHostLayoutDto&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.enableDrag, enableDrag) || other.enableDrag == enableDrag)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,x,y,enableDrag,displayMode);

@override
String toString() {
  return 'OverlayHostLayoutDto(width: $width, height: $height, x: $x, y: $y, enableDrag: $enableDrag, displayMode: $displayMode)';
}


}

/// @nodoc
abstract mixin class _$OverlayHostLayoutDtoCopyWith<$Res> implements $OverlayHostLayoutDtoCopyWith<$Res> {
  factory _$OverlayHostLayoutDtoCopyWith(_OverlayHostLayoutDto value, $Res Function(_OverlayHostLayoutDto) _then) = __$OverlayHostLayoutDtoCopyWithImpl;
@override @useResult
$Res call({
 int width, int height, double x, double y, bool enableDrag, OverlayWindowDisplayMode displayMode
});




}
/// @nodoc
class __$OverlayHostLayoutDtoCopyWithImpl<$Res>
    implements _$OverlayHostLayoutDtoCopyWith<$Res> {
  __$OverlayHostLayoutDtoCopyWithImpl(this._self, this._then);

  final _OverlayHostLayoutDto _self;
  final $Res Function(_OverlayHostLayoutDto) _then;

/// Create a copy of OverlayHostLayoutDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? x = null,Object? y = null,Object? enableDrag = null,Object? displayMode = null,}) {
  return _then(_OverlayHostLayoutDto(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,enableDrag: null == enableDrag ? _self.enableDrag : enableDrag // ignore: cast_nullable_to_non_nullable
as bool,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as OverlayWindowDisplayMode,
  ));
}


}

// dart format on
