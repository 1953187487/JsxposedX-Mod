// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_viewport_metrics_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OverlayViewportMetricsDto {

 double get width; double get height; double get safeLeft; double get safeTop; double get safeRight; double get safeBottom;
/// Create a copy of OverlayViewportMetricsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayViewportMetricsDtoCopyWith<OverlayViewportMetricsDto> get copyWith => _$OverlayViewportMetricsDtoCopyWithImpl<OverlayViewportMetricsDto>(this as OverlayViewportMetricsDto, _$identity);

  /// Serializes this OverlayViewportMetricsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayViewportMetricsDto&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.safeLeft, safeLeft) || other.safeLeft == safeLeft)&&(identical(other.safeTop, safeTop) || other.safeTop == safeTop)&&(identical(other.safeRight, safeRight) || other.safeRight == safeRight)&&(identical(other.safeBottom, safeBottom) || other.safeBottom == safeBottom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,safeLeft,safeTop,safeRight,safeBottom);

@override
String toString() {
  return 'OverlayViewportMetricsDto(width: $width, height: $height, safeLeft: $safeLeft, safeTop: $safeTop, safeRight: $safeRight, safeBottom: $safeBottom)';
}


}

/// @nodoc
abstract mixin class $OverlayViewportMetricsDtoCopyWith<$Res>  {
  factory $OverlayViewportMetricsDtoCopyWith(OverlayViewportMetricsDto value, $Res Function(OverlayViewportMetricsDto) _then) = _$OverlayViewportMetricsDtoCopyWithImpl;
@useResult
$Res call({
 double width, double height, double safeLeft, double safeTop, double safeRight, double safeBottom
});




}
/// @nodoc
class _$OverlayViewportMetricsDtoCopyWithImpl<$Res>
    implements $OverlayViewportMetricsDtoCopyWith<$Res> {
  _$OverlayViewportMetricsDtoCopyWithImpl(this._self, this._then);

  final OverlayViewportMetricsDto _self;
  final $Res Function(OverlayViewportMetricsDto) _then;

/// Create a copy of OverlayViewportMetricsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? safeLeft = null,Object? safeTop = null,Object? safeRight = null,Object? safeBottom = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,safeLeft: null == safeLeft ? _self.safeLeft : safeLeft // ignore: cast_nullable_to_non_nullable
as double,safeTop: null == safeTop ? _self.safeTop : safeTop // ignore: cast_nullable_to_non_nullable
as double,safeRight: null == safeRight ? _self.safeRight : safeRight // ignore: cast_nullable_to_non_nullable
as double,safeBottom: null == safeBottom ? _self.safeBottom : safeBottom // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayViewportMetricsDto].
extension OverlayViewportMetricsDtoPatterns on OverlayViewportMetricsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayViewportMetricsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayViewportMetricsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayViewportMetricsDto value)  $default,){
final _that = this;
switch (_that) {
case _OverlayViewportMetricsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayViewportMetricsDto value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayViewportMetricsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double width,  double height,  double safeLeft,  double safeTop,  double safeRight,  double safeBottom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayViewportMetricsDto() when $default != null:
return $default(_that.width,_that.height,_that.safeLeft,_that.safeTop,_that.safeRight,_that.safeBottom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double width,  double height,  double safeLeft,  double safeTop,  double safeRight,  double safeBottom)  $default,) {final _that = this;
switch (_that) {
case _OverlayViewportMetricsDto():
return $default(_that.width,_that.height,_that.safeLeft,_that.safeTop,_that.safeRight,_that.safeBottom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double width,  double height,  double safeLeft,  double safeTop,  double safeRight,  double safeBottom)?  $default,) {final _that = this;
switch (_that) {
case _OverlayViewportMetricsDto() when $default != null:
return $default(_that.width,_that.height,_that.safeLeft,_that.safeTop,_that.safeRight,_that.safeBottom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OverlayViewportMetricsDto extends OverlayViewportMetricsDto {
  const _OverlayViewportMetricsDto({this.width = 0, this.height = 0, this.safeLeft = 0, this.safeTop = 0, this.safeRight = 0, this.safeBottom = 0}): super._();
  factory _OverlayViewportMetricsDto.fromJson(Map<String, dynamic> json) => _$OverlayViewportMetricsDtoFromJson(json);

@override@JsonKey() final  double width;
@override@JsonKey() final  double height;
@override@JsonKey() final  double safeLeft;
@override@JsonKey() final  double safeTop;
@override@JsonKey() final  double safeRight;
@override@JsonKey() final  double safeBottom;

/// Create a copy of OverlayViewportMetricsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayViewportMetricsDtoCopyWith<_OverlayViewportMetricsDto> get copyWith => __$OverlayViewportMetricsDtoCopyWithImpl<_OverlayViewportMetricsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverlayViewportMetricsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayViewportMetricsDto&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.safeLeft, safeLeft) || other.safeLeft == safeLeft)&&(identical(other.safeTop, safeTop) || other.safeTop == safeTop)&&(identical(other.safeRight, safeRight) || other.safeRight == safeRight)&&(identical(other.safeBottom, safeBottom) || other.safeBottom == safeBottom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,safeLeft,safeTop,safeRight,safeBottom);

@override
String toString() {
  return 'OverlayViewportMetricsDto(width: $width, height: $height, safeLeft: $safeLeft, safeTop: $safeTop, safeRight: $safeRight, safeBottom: $safeBottom)';
}


}

/// @nodoc
abstract mixin class _$OverlayViewportMetricsDtoCopyWith<$Res> implements $OverlayViewportMetricsDtoCopyWith<$Res> {
  factory _$OverlayViewportMetricsDtoCopyWith(_OverlayViewportMetricsDto value, $Res Function(_OverlayViewportMetricsDto) _then) = __$OverlayViewportMetricsDtoCopyWithImpl;
@override @useResult
$Res call({
 double width, double height, double safeLeft, double safeTop, double safeRight, double safeBottom
});




}
/// @nodoc
class __$OverlayViewportMetricsDtoCopyWithImpl<$Res>
    implements _$OverlayViewportMetricsDtoCopyWith<$Res> {
  __$OverlayViewportMetricsDtoCopyWithImpl(this._self, this._then);

  final _OverlayViewportMetricsDto _self;
  final $Res Function(_OverlayViewportMetricsDto) _then;

/// Create a copy of OverlayViewportMetricsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? safeLeft = null,Object? safeTop = null,Object? safeRight = null,Object? safeBottom = null,}) {
  return _then(_OverlayViewportMetricsDto(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,safeLeft: null == safeLeft ? _self.safeLeft : safeLeft // ignore: cast_nullable_to_non_nullable
as double,safeTop: null == safeTop ? _self.safeTop : safeTop // ignore: cast_nullable_to_non_nullable
as double,safeRight: null == safeRight ? _self.safeRight : safeRight // ignore: cast_nullable_to_non_nullable
as double,safeBottom: null == safeBottom ? _self.safeBottom : safeBottom // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
