// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_host_layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverlayHostLayout {

 int get width; int get height; Offset get position; bool get enableDrag; OverlayWindowDisplayMode get displayMode;
/// Create a copy of OverlayHostLayout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayHostLayoutCopyWith<OverlayHostLayout> get copyWith => _$OverlayHostLayoutCopyWithImpl<OverlayHostLayout>(this as OverlayHostLayout, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayHostLayout&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.position, position) || other.position == position)&&(identical(other.enableDrag, enableDrag) || other.enableDrag == enableDrag)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode));
}


@override
int get hashCode => Object.hash(runtimeType,width,height,position,enableDrag,displayMode);

@override
String toString() {
  return 'OverlayHostLayout(width: $width, height: $height, position: $position, enableDrag: $enableDrag, displayMode: $displayMode)';
}


}

/// @nodoc
abstract mixin class $OverlayHostLayoutCopyWith<$Res>  {
  factory $OverlayHostLayoutCopyWith(OverlayHostLayout value, $Res Function(OverlayHostLayout) _then) = _$OverlayHostLayoutCopyWithImpl;
@useResult
$Res call({
 int width, int height, Offset position, bool enableDrag, OverlayWindowDisplayMode displayMode
});




}
/// @nodoc
class _$OverlayHostLayoutCopyWithImpl<$Res>
    implements $OverlayHostLayoutCopyWith<$Res> {
  _$OverlayHostLayoutCopyWithImpl(this._self, this._then);

  final OverlayHostLayout _self;
  final $Res Function(OverlayHostLayout) _then;

/// Create a copy of OverlayHostLayout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? position = null,Object? enableDrag = null,Object? displayMode = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,enableDrag: null == enableDrag ? _self.enableDrag : enableDrag // ignore: cast_nullable_to_non_nullable
as bool,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as OverlayWindowDisplayMode,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayHostLayout].
extension OverlayHostLayoutPatterns on OverlayHostLayout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayHostLayout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayHostLayout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayHostLayout value)  $default,){
final _that = this;
switch (_that) {
case _OverlayHostLayout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayHostLayout value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayHostLayout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int width,  int height,  Offset position,  bool enableDrag,  OverlayWindowDisplayMode displayMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayHostLayout() when $default != null:
return $default(_that.width,_that.height,_that.position,_that.enableDrag,_that.displayMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int width,  int height,  Offset position,  bool enableDrag,  OverlayWindowDisplayMode displayMode)  $default,) {final _that = this;
switch (_that) {
case _OverlayHostLayout():
return $default(_that.width,_that.height,_that.position,_that.enableDrag,_that.displayMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int width,  int height,  Offset position,  bool enableDrag,  OverlayWindowDisplayMode displayMode)?  $default,) {final _that = this;
switch (_that) {
case _OverlayHostLayout() when $default != null:
return $default(_that.width,_that.height,_that.position,_that.enableDrag,_that.displayMode);case _:
  return null;

}
}

}

/// @nodoc


class _OverlayHostLayout extends OverlayHostLayout {
  const _OverlayHostLayout({required this.width, required this.height, required this.position, required this.enableDrag, required this.displayMode}): super._();
  

@override final  int width;
@override final  int height;
@override final  Offset position;
@override final  bool enableDrag;
@override final  OverlayWindowDisplayMode displayMode;

/// Create a copy of OverlayHostLayout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayHostLayoutCopyWith<_OverlayHostLayout> get copyWith => __$OverlayHostLayoutCopyWithImpl<_OverlayHostLayout>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayHostLayout&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.position, position) || other.position == position)&&(identical(other.enableDrag, enableDrag) || other.enableDrag == enableDrag)&&(identical(other.displayMode, displayMode) || other.displayMode == displayMode));
}


@override
int get hashCode => Object.hash(runtimeType,width,height,position,enableDrag,displayMode);

@override
String toString() {
  return 'OverlayHostLayout(width: $width, height: $height, position: $position, enableDrag: $enableDrag, displayMode: $displayMode)';
}


}

/// @nodoc
abstract mixin class _$OverlayHostLayoutCopyWith<$Res> implements $OverlayHostLayoutCopyWith<$Res> {
  factory _$OverlayHostLayoutCopyWith(_OverlayHostLayout value, $Res Function(_OverlayHostLayout) _then) = __$OverlayHostLayoutCopyWithImpl;
@override @useResult
$Res call({
 int width, int height, Offset position, bool enableDrag, OverlayWindowDisplayMode displayMode
});




}
/// @nodoc
class __$OverlayHostLayoutCopyWithImpl<$Res>
    implements _$OverlayHostLayoutCopyWith<$Res> {
  __$OverlayHostLayoutCopyWithImpl(this._self, this._then);

  final _OverlayHostLayout _self;
  final $Res Function(_OverlayHostLayout) _then;

/// Create a copy of OverlayHostLayout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? position = null,Object? enableDrag = null,Object? displayMode = null,}) {
  return _then(_OverlayHostLayout(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,enableDrag: null == enableDrag ? _self.enableDrag : enableDrag // ignore: cast_nullable_to_non_nullable
as bool,displayMode: null == displayMode ? _self.displayMode : displayMode // ignore: cast_nullable_to_non_nullable
as OverlayWindowDisplayMode,
  ));
}


}

// dart format on
