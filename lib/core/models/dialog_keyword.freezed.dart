// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialog_keyword.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DialogKeyword {

 String get keyword; bool get isCheck;
/// Create a copy of DialogKeyword
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogKeywordCopyWith<DialogKeyword> get copyWith => _$DialogKeywordCopyWithImpl<DialogKeyword>(this as DialogKeyword, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogKeyword&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.isCheck, isCheck) || other.isCheck == isCheck));
}


@override
int get hashCode => Object.hash(runtimeType,keyword,isCheck);

@override
String toString() {
  return 'DialogKeyword(keyword: $keyword, isCheck: $isCheck)';
}


}

/// @nodoc
abstract mixin class $DialogKeywordCopyWith<$Res>  {
  factory $DialogKeywordCopyWith(DialogKeyword value, $Res Function(DialogKeyword) _then) = _$DialogKeywordCopyWithImpl;
@useResult
$Res call({
 String keyword, bool isCheck
});




}
/// @nodoc
class _$DialogKeywordCopyWithImpl<$Res>
    implements $DialogKeywordCopyWith<$Res> {
  _$DialogKeywordCopyWithImpl(this._self, this._then);

  final DialogKeyword _self;
  final $Res Function(DialogKeyword) _then;

/// Create a copy of DialogKeyword
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyword = null,Object? isCheck = null,}) {
  return _then(_self.copyWith(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,isCheck: null == isCheck ? _self.isCheck : isCheck // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DialogKeyword].
extension DialogKeywordPatterns on DialogKeyword {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogKeyword value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogKeyword() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogKeyword value)  $default,){
final _that = this;
switch (_that) {
case _DialogKeyword():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogKeyword value)?  $default,){
final _that = this;
switch (_that) {
case _DialogKeyword() when $default != null:
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
case _DialogKeyword() when $default != null:
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
case _DialogKeyword():
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
case _DialogKeyword() when $default != null:
return $default(_that.keyword,_that.isCheck);case _:
  return null;

}
}

}

/// @nodoc


class _DialogKeyword extends DialogKeyword {
  const _DialogKeyword({required this.keyword, required this.isCheck}): super._();
  

@override final  String keyword;
@override final  bool isCheck;

/// Create a copy of DialogKeyword
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogKeywordCopyWith<_DialogKeyword> get copyWith => __$DialogKeywordCopyWithImpl<_DialogKeyword>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogKeyword&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.isCheck, isCheck) || other.isCheck == isCheck));
}


@override
int get hashCode => Object.hash(runtimeType,keyword,isCheck);

@override
String toString() {
  return 'DialogKeyword(keyword: $keyword, isCheck: $isCheck)';
}


}

/// @nodoc
abstract mixin class _$DialogKeywordCopyWith<$Res> implements $DialogKeywordCopyWith<$Res> {
  factory _$DialogKeywordCopyWith(_DialogKeyword value, $Res Function(_DialogKeyword) _then) = __$DialogKeywordCopyWithImpl;
@override @useResult
$Res call({
 String keyword, bool isCheck
});




}
/// @nodoc
class __$DialogKeywordCopyWithImpl<$Res>
    implements _$DialogKeywordCopyWith<$Res> {
  __$DialogKeywordCopyWithImpl(this._self, this._then);

  final _DialogKeyword _self;
  final $Res Function(_DialogKeyword) _then;

/// Create a copy of DialogKeyword
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyword = null,Object? isCheck = null,}) {
  return _then(_DialogKeyword(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,isCheck: null == isCheck ? _self.isCheck : isCheck // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
