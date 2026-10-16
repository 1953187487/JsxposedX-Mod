// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_viewport_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverlayViewportMetrics {

 double get width; double get height; EdgeInsets get safePadding;
/// Create a copy of OverlayViewportMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayViewportMetricsCopyWith<OverlayViewportMetrics> get copyWith => _$OverlayViewportMetricsCopyWithImpl<OverlayViewportMetrics>(this as OverlayViewportMetrics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayViewportMetrics&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.safePadding, safePadding) || other.safePadding == safePadding));
}


@override
int get hashCode => Object.hash(runtimeType,width,height,safePadding);

@override
String toString() {
  return 'OverlayViewportMetrics(width: $width, height: $height, safePadding: $safePadding)';
}


}

/// @nodoc
abstract mixin class $OverlayViewportMetricsCopyWith<$Res>  {
  factory $OverlayViewportMetricsCopyWith(OverlayViewportMetrics value, $Res Function(OverlayViewportMetrics) _then) = _$OverlayViewportMetricsCopyWithImpl;
@useResult
$Res call({
 double width, double height, EdgeInsets safePadding
});




}
/// @nodoc
class _$OverlayViewportMetricsCopyWithImpl<$Res>
    implements $OverlayViewportMetricsCopyWith<$Res> {
  _$OverlayViewportMetricsCopyWithImpl(this._self, this._then);

  final OverlayViewportMetrics _self;
  final $Res Function(OverlayViewportMetrics) _then;

/// Create a copy of OverlayViewportMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? safePadding = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,safePadding: null == safePadding ? _self.safePadding : safePadding // ignore: cast_nullable_to_non_nullable
as EdgeInsets,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayViewportMetrics].
extension OverlayViewportMetricsPatterns on OverlayViewportMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayViewportMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayViewportMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayViewportMetrics value)  $default,){
final _that = this;
switch (_that) {
case _OverlayViewportMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayViewportMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayViewportMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double width,  double height,  EdgeInsets safePadding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayViewportMetrics() when $default != null:
return $default(_that.width,_that.height,_that.safePadding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double width,  double height,  EdgeInsets safePadding)  $default,) {final _that = this;
switch (_that) {
case _OverlayViewportMetrics():
return $default(_that.width,_that.height,_that.safePadding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double width,  double height,  EdgeInsets safePadding)?  $default,) {final _that = this;
switch (_that) {
case _OverlayViewportMetrics() when $default != null:
return $default(_that.width,_that.height,_that.safePadding);case _:
  return null;

}
}

}

/// @nodoc


class _OverlayViewportMetrics extends OverlayViewportMetrics {
  const _OverlayViewportMetrics({required this.width, required this.height, required this.safePadding}): super._();
  

@override final  double width;
@override final  double height;
@override final  EdgeInsets safePadding;

/// Create a copy of OverlayViewportMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayViewportMetricsCopyWith<_OverlayViewportMetrics> get copyWith => __$OverlayViewportMetricsCopyWithImpl<_OverlayViewportMetrics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayViewportMetrics&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.safePadding, safePadding) || other.safePadding == safePadding));
}


@override
int get hashCode => Object.hash(runtimeType,width,height,safePadding);

@override
String toString() {
  return 'OverlayViewportMetrics(width: $width, height: $height, safePadding: $safePadding)';
}


}

/// @nodoc
abstract mixin class _$OverlayViewportMetricsCopyWith<$Res> implements $OverlayViewportMetricsCopyWith<$Res> {
  factory _$OverlayViewportMetricsCopyWith(_OverlayViewportMetrics value, $Res Function(_OverlayViewportMetrics) _then) = __$OverlayViewportMetricsCopyWithImpl;
@override @useResult
$Res call({
 double width, double height, EdgeInsets safePadding
});




}
/// @nodoc
class __$OverlayViewportMetricsCopyWithImpl<$Res>
    implements _$OverlayViewportMetricsCopyWith<$Res> {
  __$OverlayViewportMetricsCopyWithImpl(this._self, this._then);

  final _OverlayViewportMetrics _self;
  final $Res Function(_OverlayViewportMetrics) _then;

/// Create a copy of OverlayViewportMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? safePadding = null,}) {
  return _then(_OverlayViewportMetrics(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,safePadding: null == safePadding ? _self.safePadding : safePadding // ignore: cast_nullable_to_non_nullable
as EdgeInsets,
  ));
}


}

// dart format on
