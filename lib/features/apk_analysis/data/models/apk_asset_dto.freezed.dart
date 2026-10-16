// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apk_asset_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApkAssetDto {

 String get path; String get name; int get size; int get compressedSize; bool get isDirectory; int get lastModified;
/// Create a copy of ApkAssetDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApkAssetDtoCopyWith<ApkAssetDto> get copyWith => _$ApkAssetDtoCopyWithImpl<ApkAssetDto>(this as ApkAssetDto, _$identity);

  /// Serializes this ApkAssetDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApkAssetDto&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.compressedSize, compressedSize) || other.compressedSize == compressedSize)&&(identical(other.isDirectory, isDirectory) || other.isDirectory == isDirectory)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,name,size,compressedSize,isDirectory,lastModified);

@override
String toString() {
  return 'ApkAssetDto(path: $path, name: $name, size: $size, compressedSize: $compressedSize, isDirectory: $isDirectory, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class $ApkAssetDtoCopyWith<$Res>  {
  factory $ApkAssetDtoCopyWith(ApkAssetDto value, $Res Function(ApkAssetDto) _then) = _$ApkAssetDtoCopyWithImpl;
@useResult
$Res call({
 String path, String name, int size, int compressedSize, bool isDirectory, int lastModified
});




}
/// @nodoc
class _$ApkAssetDtoCopyWithImpl<$Res>
    implements $ApkAssetDtoCopyWith<$Res> {
  _$ApkAssetDtoCopyWithImpl(this._self, this._then);

  final ApkAssetDto _self;
  final $Res Function(ApkAssetDto) _then;

/// Create a copy of ApkAssetDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? size = null,Object? compressedSize = null,Object? isDirectory = null,Object? lastModified = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,compressedSize: null == compressedSize ? _self.compressedSize : compressedSize // ignore: cast_nullable_to_non_nullable
as int,isDirectory: null == isDirectory ? _self.isDirectory : isDirectory // ignore: cast_nullable_to_non_nullable
as bool,lastModified: null == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ApkAssetDto].
extension ApkAssetDtoPatterns on ApkAssetDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApkAssetDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApkAssetDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApkAssetDto value)  $default,){
final _that = this;
switch (_that) {
case _ApkAssetDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApkAssetDto value)?  $default,){
final _that = this;
switch (_that) {
case _ApkAssetDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  int size,  int compressedSize,  bool isDirectory,  int lastModified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApkAssetDto() when $default != null:
return $default(_that.path,_that.name,_that.size,_that.compressedSize,_that.isDirectory,_that.lastModified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  int size,  int compressedSize,  bool isDirectory,  int lastModified)  $default,) {final _that = this;
switch (_that) {
case _ApkAssetDto():
return $default(_that.path,_that.name,_that.size,_that.compressedSize,_that.isDirectory,_that.lastModified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  int size,  int compressedSize,  bool isDirectory,  int lastModified)?  $default,) {final _that = this;
switch (_that) {
case _ApkAssetDto() when $default != null:
return $default(_that.path,_that.name,_that.size,_that.compressedSize,_that.isDirectory,_that.lastModified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApkAssetDto extends ApkAssetDto {
  const _ApkAssetDto({this.path = '', this.name = '', this.size = 0, this.compressedSize = 0, this.isDirectory = false, this.lastModified = 0}): super._();
  factory _ApkAssetDto.fromJson(Map<String, dynamic> json) => _$ApkAssetDtoFromJson(json);

@override@JsonKey() final  String path;
@override@JsonKey() final  String name;
@override@JsonKey() final  int size;
@override@JsonKey() final  int compressedSize;
@override@JsonKey() final  bool isDirectory;
@override@JsonKey() final  int lastModified;

/// Create a copy of ApkAssetDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApkAssetDtoCopyWith<_ApkAssetDto> get copyWith => __$ApkAssetDtoCopyWithImpl<_ApkAssetDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApkAssetDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApkAssetDto&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.compressedSize, compressedSize) || other.compressedSize == compressedSize)&&(identical(other.isDirectory, isDirectory) || other.isDirectory == isDirectory)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,name,size,compressedSize,isDirectory,lastModified);

@override
String toString() {
  return 'ApkAssetDto(path: $path, name: $name, size: $size, compressedSize: $compressedSize, isDirectory: $isDirectory, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class _$ApkAssetDtoCopyWith<$Res> implements $ApkAssetDtoCopyWith<$Res> {
  factory _$ApkAssetDtoCopyWith(_ApkAssetDto value, $Res Function(_ApkAssetDto) _then) = __$ApkAssetDtoCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, int size, int compressedSize, bool isDirectory, int lastModified
});




}
/// @nodoc
class __$ApkAssetDtoCopyWithImpl<$Res>
    implements _$ApkAssetDtoCopyWith<$Res> {
  __$ApkAssetDtoCopyWithImpl(this._self, this._then);

  final _ApkAssetDto _self;
  final $Res Function(_ApkAssetDto) _then;

/// Create a copy of ApkAssetDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? size = null,Object? compressedSize = null,Object? isDirectory = null,Object? lastModified = null,}) {
  return _then(_ApkAssetDto(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,compressedSize: null == compressedSize ? _self.compressedSize : compressedSize // ignore: cast_nullable_to_non_nullable
as int,isDirectory: null == isDirectory ? _self.isDirectory : isDirectory // ignore: cast_nullable_to_non_nullable
as bool,lastModified: null == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
