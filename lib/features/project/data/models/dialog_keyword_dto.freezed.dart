// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialog_keyword_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DialogKeywordDto {

 String get keyword; bool get isCheck;
/// Create a copy of DialogKeywordDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogKeywordDtoCopyWith<DialogKeywordDto> get copyWith => _$DialogKeywordDtoCopyWithImpl<DialogKeywordDto>(this as DialogKeywordDto, _$identity);

  /// Serializes this DialogKeywordDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogKeywordDto&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.isCheck, isCheck) || other.isCheck == isCheck));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keyword,isCheck);

@override
String toString() {
  return 'DialogKeywordDto(keyword: $keyword, isCheck: $isCheck)';
}


}

/// @nodoc
abstract mixin class $DialogKeywordDtoCopyWith<$Res>  {
  factory $DialogKeywordDtoCopyWith(DialogKeywordDto value, $Res Function(DialogKeywordDto) _then) = _$DialogKeywordDtoCopyWithImpl;
@useResult
$Res call({
 String keyword, bool isCheck
});




}
/// @nodoc
class _$DialogKeywordDtoCopyWithImpl<$Res>
    implements $DialogKeywordDtoCopyWith<$Res> {
  _$DialogKeywordDtoCopyWithImpl(this._self, this._then);

  final DialogKeywordDto _self;
  final $Res Function(DialogKeywordDto) _then;

/// Create a copy of DialogKeywordDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyword = null,Object? isCheck = null,}) {
  return _then(_self.copyWith(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,isCheck: null == isCheck ? _self.isCheck : isCheck // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DialogKeywordDto].
extension DialogKeywordDtoPatterns on DialogKeywordDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogKeywordDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogKeywordDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogKeywordDto value)  $default,){
final _that = this;
switch (_that) {
case _DialogKeywordDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogKeywordDto value)?  $default,){
final _that = this;
switch (_that) {
case _DialogKeywordDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyword,  bool isCheck)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialogKeywordDto() when $default != null:
return $default(_that.keyword,_that.isCheck);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyword,  bool isCheck)  $default,) {final _that = this;
switch (_that) {
case _DialogKeywordDto():
return $default(_that.keyword,_that.isCheck);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyword,  bool isCheck)?  $default,) {final _that = this;
switch (_that) {
case _DialogKeywordDto() when $default != null:
return $default(_that.keyword,_that.isCheck);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DialogKeywordDto extends DialogKeywordDto {
  const _DialogKeywordDto({this.keyword = "", this.isCheck = false}): super._();
  factory _DialogKeywordDto.fromJson(Map<String, dynamic> json) => _$DialogKeywordDtoFromJson(json);

@override@JsonKey() final  String keyword;
@override@JsonKey() final  bool isCheck;

/// Create a copy of DialogKeywordDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogKeywordDtoCopyWith<_DialogKeywordDto> get copyWith => __$DialogKeywordDtoCopyWithImpl<_DialogKeywordDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DialogKeywordDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogKeywordDto&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.isCheck, isCheck) || other.isCheck == isCheck));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keyword,isCheck);

@override
String toString() {
  return 'DialogKeywordDto(keyword: $keyword, isCheck: $isCheck)';
}


}

/// @nodoc
abstract mixin class _$DialogKeywordDtoCopyWith<$Res> implements $DialogKeywordDtoCopyWith<$Res> {
  factory _$DialogKeywordDtoCopyWith(_DialogKeywordDto value, $Res Function(_DialogKeywordDto) _then) = __$DialogKeywordDtoCopyWithImpl;
@override @useResult
$Res call({
 String keyword, bool isCheck
});




}
/// @nodoc
class __$DialogKeywordDtoCopyWithImpl<$Res>
    implements _$DialogKeywordDtoCopyWith<$Res> {
  __$DialogKeywordDtoCopyWithImpl(this._self, this._then);

  final _DialogKeywordDto _self;
  final $Res Function(_DialogKeywordDto) _then;

/// Create a copy of DialogKeywordDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyword = null,Object? isCheck = null,}) {
  return _then(_DialogKeywordDto(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,isCheck: null == isCheck ? _self.isCheck : isCheck // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
