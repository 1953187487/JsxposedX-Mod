// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageResultDto<T> {

 int get total; List<T> get rows; int get code; String get msg; bool get hasMore;
/// Create a copy of PageResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageResultDtoCopyWith<T, PageResultDto<T>> get copyWith => _$PageResultDtoCopyWithImpl<T, PageResultDto<T>>(this as PageResultDto<T>, _$identity);

  /// Serializes this PageResultDto to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageResultDto<T>&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.rows, rows)&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(rows),code,msg,hasMore);

@override
String toString() {
  return 'PageResultDto<$T>(total: $total, rows: $rows, code: $code, msg: $msg, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $PageResultDtoCopyWith<T,$Res>  {
  factory $PageResultDtoCopyWith(PageResultDto<T> value, $Res Function(PageResultDto<T>) _then) = _$PageResultDtoCopyWithImpl;
@useResult
$Res call({
 int total, List<T> rows, int code, String msg, bool hasMore
});




}
/// @nodoc
class _$PageResultDtoCopyWithImpl<T,$Res>
    implements $PageResultDtoCopyWith<T, $Res> {
  _$PageResultDtoCopyWithImpl(this._self, this._then);

  final PageResultDto<T> _self;
  final $Res Function(PageResultDto<T>) _then;

/// Create a copy of PageResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? rows = null,Object? code = null,Object? msg = null,Object? hasMore = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<T>,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PageResultDto].
extension PageResultDtoPatterns<T> on PageResultDto<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageResultDto<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageResultDto<T> value)  $default,){
final _that = this;
switch (_that) {
case _PageResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageResultDto<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PageResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  List<T> rows,  int code,  String msg,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageResultDto() when $default != null:
return $default(_that.total,_that.rows,_that.code,_that.msg,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  List<T> rows,  int code,  String msg,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _PageResultDto():
return $default(_that.total,_that.rows,_that.code,_that.msg,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  List<T> rows,  int code,  String msg,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _PageResultDto() when $default != null:
return $default(_that.total,_that.rows,_that.code,_that.msg,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PageResultDto<T> extends PageResultDto<T> {
  const _PageResultDto({this.total = 0, final  List<T> rows = const [], this.code = 400, this.msg = "", this.hasMore = false}): _rows = rows,super._();
  factory _PageResultDto.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PageResultDtoFromJson(json,fromJsonT);

@override@JsonKey() final  int total;
 final  List<T> _rows;
@override@JsonKey() List<T> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override@JsonKey() final  int code;
@override@JsonKey() final  String msg;
@override@JsonKey() final  bool hasMore;

/// Create a copy of PageResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageResultDtoCopyWith<T, _PageResultDto<T>> get copyWith => __$PageResultDtoCopyWithImpl<T, _PageResultDto<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PageResultDtoToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageResultDto<T>&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._rows, _rows)&&(identical(other.code, code) || other.code == code)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_rows),code,msg,hasMore);

@override
String toString() {
  return 'PageResultDto<$T>(total: $total, rows: $rows, code: $code, msg: $msg, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$PageResultDtoCopyWith<T,$Res> implements $PageResultDtoCopyWith<T, $Res> {
  factory _$PageResultDtoCopyWith(_PageResultDto<T> value, $Res Function(_PageResultDto<T>) _then) = __$PageResultDtoCopyWithImpl;
@override @useResult
$Res call({
 int total, List<T> rows, int code, String msg, bool hasMore
});




}
/// @nodoc
class __$PageResultDtoCopyWithImpl<T,$Res>
    implements _$PageResultDtoCopyWith<T, $Res> {
  __$PageResultDtoCopyWithImpl(this._self, this._then);

  final _PageResultDto<T> _self;
  final $Res Function(_PageResultDto<T>) _then;

/// Create a copy of PageResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? rows = null,Object? code = null,Object? msg = null,Object? hasMore = null,}) {
  return _then(_PageResultDto<T>(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<T>,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
