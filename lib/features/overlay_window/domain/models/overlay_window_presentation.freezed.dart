// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_window_presentation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OverlayWindowPresentation {

 double? get width; double? get height; double get bubbleSize; bool get enableDrag; String? get notificationTitle; String? get notificationContent;
/// Create a copy of OverlayWindowPresentation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayWindowPresentationCopyWith<OverlayWindowPresentation> get copyWith => _$OverlayWindowPresentationCopyWithImpl<OverlayWindowPresentation>(this as OverlayWindowPresentation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayWindowPresentation&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.bubbleSize, bubbleSize) || other.bubbleSize == bubbleSize)&&(identical(other.enableDrag, enableDrag) || other.enableDrag == enableDrag)&&(identical(other.notificationTitle, notificationTitle) || other.notificationTitle == notificationTitle)&&(identical(other.notificationContent, notificationContent) || other.notificationContent == notificationContent));
}


@override
int get hashCode => Object.hash(runtimeType,width,height,bubbleSize,enableDrag,notificationTitle,notificationContent);

@override
String toString() {
  return 'OverlayWindowPresentation(width: $width, height: $height, bubbleSize: $bubbleSize, enableDrag: $enableDrag, notificationTitle: $notificationTitle, notificationContent: $notificationContent)';
}


}

/// @nodoc
abstract mixin class $OverlayWindowPresentationCopyWith<$Res>  {
  factory $OverlayWindowPresentationCopyWith(OverlayWindowPresentation value, $Res Function(OverlayWindowPresentation) _then) = _$OverlayWindowPresentationCopyWithImpl;
@useResult
$Res call({
 double? width, double? height, double bubbleSize, bool enableDrag, String? notificationTitle, String? notificationContent
});




}
/// @nodoc
class _$OverlayWindowPresentationCopyWithImpl<$Res>
    implements $OverlayWindowPresentationCopyWith<$Res> {
  _$OverlayWindowPresentationCopyWithImpl(this._self, this._then);

  final OverlayWindowPresentation _self;
  final $Res Function(OverlayWindowPresentation) _then;

/// Create a copy of OverlayWindowPresentation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = freezed,Object? height = freezed,Object? bubbleSize = null,Object? enableDrag = null,Object? notificationTitle = freezed,Object? notificationContent = freezed,}) {
  return _then(_self.copyWith(
width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,bubbleSize: null == bubbleSize ? _self.bubbleSize : bubbleSize // ignore: cast_nullable_to_non_nullable
as double,enableDrag: null == enableDrag ? _self.enableDrag : enableDrag // ignore: cast_nullable_to_non_nullable
as bool,notificationTitle: freezed == notificationTitle ? _self.notificationTitle : notificationTitle // ignore: cast_nullable_to_non_nullable
as String?,notificationContent: freezed == notificationContent ? _self.notificationContent : notificationContent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OverlayWindowPresentation].
extension OverlayWindowPresentationPatterns on OverlayWindowPresentation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverlayWindowPresentation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverlayWindowPresentation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverlayWindowPresentation value)  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowPresentation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverlayWindowPresentation value)?  $default,){
final _that = this;
switch (_that) {
case _OverlayWindowPresentation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? width,  double? height,  double bubbleSize,  bool enableDrag,  String? notificationTitle,  String? notificationContent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverlayWindowPresentation() when $default != null:
return $default(_that.width,_that.height,_that.bubbleSize,_that.enableDrag,_that.notificationTitle,_that.notificationContent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? width,  double? height,  double bubbleSize,  bool enableDrag,  String? notificationTitle,  String? notificationContent)  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowPresentation():
return $default(_that.width,_that.height,_that.bubbleSize,_that.enableDrag,_that.notificationTitle,_that.notificationContent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? width,  double? height,  double bubbleSize,  bool enableDrag,  String? notificationTitle,  String? notificationContent)?  $default,) {final _that = this;
switch (_that) {
case _OverlayWindowPresentation() when $default != null:
return $default(_that.width,_that.height,_that.bubbleSize,_that.enableDrag,_that.notificationTitle,_that.notificationContent);case _:
  return null;

}
}

}

/// @nodoc


class _OverlayWindowPresentation extends OverlayWindowPresentation {
  const _OverlayWindowPresentation({this.width, this.height, this.bubbleSize = overlayWindowDefaultBubbleSize, this.enableDrag = true, this.notificationTitle, this.notificationContent}): super._();
  

@override final  double? width;
@override final  double? height;
@override@JsonKey() final  double bubbleSize;
@override@JsonKey() final  bool enableDrag;
@override final  String? notificationTitle;
@override final  String? notificationContent;

/// Create a copy of OverlayWindowPresentation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverlayWindowPresentationCopyWith<_OverlayWindowPresentation> get copyWith => __$OverlayWindowPresentationCopyWithImpl<_OverlayWindowPresentation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverlayWindowPresentation&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.bubbleSize, bubbleSize) || other.bubbleSize == bubbleSize)&&(identical(other.enableDrag, enableDrag) || other.enableDrag == enableDrag)&&(identical(other.notificationTitle, notificationTitle) || other.notificationTitle == notificationTitle)&&(identical(other.notificationContent, notificationContent) || other.notificationContent == notificationContent));
}


@override
int get hashCode => Object.hash(runtimeType,width,height,bubbleSize,enableDrag,notificationTitle,notificationContent);

@override
String toString() {
  return 'OverlayWindowPresentation(width: $width, height: $height, bubbleSize: $bubbleSize, enableDrag: $enableDrag, notificationTitle: $notificationTitle, notificationContent: $notificationContent)';
}


}

/// @nodoc
abstract mixin class _$OverlayWindowPresentationCopyWith<$Res> implements $OverlayWindowPresentationCopyWith<$Res> {
  factory _$OverlayWindowPresentationCopyWith(_OverlayWindowPresentation value, $Res Function(_OverlayWindowPresentation) _then) = __$OverlayWindowPresentationCopyWithImpl;
@override @useResult
$Res call({
 double? width, double? height, double bubbleSize, bool enableDrag, String? notificationTitle, String? notificationContent
});




}
/// @nodoc
class __$OverlayWindowPresentationCopyWithImpl<$Res>
    implements _$OverlayWindowPresentationCopyWith<$Res> {
  __$OverlayWindowPresentationCopyWithImpl(this._self, this._then);

  final _OverlayWindowPresentation _self;
  final $Res Function(_OverlayWindowPresentation) _then;

/// Create a copy of OverlayWindowPresentation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = freezed,Object? height = freezed,Object? bubbleSize = null,Object? enableDrag = null,Object? notificationTitle = freezed,Object? notificationContent = freezed,}) {
  return _then(_OverlayWindowPresentation(
width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,bubbleSize: null == bubbleSize ? _self.bubbleSize : bubbleSize // ignore: cast_nullable_to_non_nullable
as double,enableDrag: null == enableDrag ? _self.enableDrag : enableDrag // ignore: cast_nullable_to_non_nullable
as bool,notificationTitle: freezed == notificationTitle ? _self.notificationTitle : notificationTitle // ignore: cast_nullable_to_non_nullable
as String?,notificationContent: freezed == notificationContent ? _self.notificationContent : notificationContent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
