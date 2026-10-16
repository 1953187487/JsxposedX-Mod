// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apk_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApkAsset {

 String get path; String get name; int get size; int get compressedSize; bool get isDirectory; int get lastModified;
/// Create a copy of ApkAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApkAssetCopyWith<ApkAsset> get copyWith => _$ApkAssetCopyWithImpl<ApkAsset>(this as ApkAsset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApkAsset&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.compressedSize, compressedSize) || other.compressedSize == compressedSize)&&(identical(other.isDirectory, isDirectory) || other.isDirectory == isDirectory)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,size,compressedSize,isDirectory,lastModified);

@override
String toString() {
  return 'ApkAsset(path: $path, name: $name, size: $size, compressedSize: $compressedSize, isDirectory: $isDirectory, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class $ApkAssetCopyWith<$Res>  {
  factory $ApkAssetCopyWith(ApkAsset value, $Res Function(ApkAsset) _then) = _$ApkAssetCopyWithImpl;
@useResult
$Res call({
 String path, String name, int size, int compressedSize, bool isDirectory, int lastModified
});




}
/// @nodoc
class _$ApkAssetCopyWithImpl<$Res>
    implements $ApkAssetCopyWith<$Res> {
  _$ApkAssetCopyWithImpl(this._self, this._then);

  final ApkAsset _self;
  final $Res Function(ApkAsset) _then;

/// Create a copy of ApkAsset
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


/// Adds pattern-matching-related methods to [ApkAsset].
extension ApkAssetPatterns on ApkAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApkAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApkAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApkAsset value)  $default,){
final _that = this;
switch (_that) {
case _ApkAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApkAsset value)?  $default,){
final _that = this;
switch (_that) {
case _ApkAsset() when $default != null:
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
case _ApkAsset() when $default != null:
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
case _ApkAsset():
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
case _ApkAsset() when $default != null:
return $default(_that.path,_that.name,_that.size,_that.compressedSize,_that.isDirectory,_that.lastModified);case _:
  return null;

}
}

}

/// @nodoc


class _ApkAsset implements ApkAsset {
  const _ApkAsset({required this.path, required this.name, required this.size, required this.compressedSize, required this.isDirectory, required this.lastModified});
  

@override final  String path;
@override final  String name;
@override final  int size;
@override final  int compressedSize;
@override final  bool isDirectory;
@override final  int lastModified;

/// Create a copy of ApkAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApkAssetCopyWith<_ApkAsset> get copyWith => __$ApkAssetCopyWithImpl<_ApkAsset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApkAsset&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.compressedSize, compressedSize) || other.compressedSize == compressedSize)&&(identical(other.isDirectory, isDirectory) || other.isDirectory == isDirectory)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,size,compressedSize,isDirectory,lastModified);

@override
String toString() {
  return 'ApkAsset(path: $path, name: $name, size: $size, compressedSize: $compressedSize, isDirectory: $isDirectory, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class _$ApkAssetCopyWith<$Res> implements $ApkAssetCopyWith<$Res> {
  factory _$ApkAssetCopyWith(_ApkAsset value, $Res Function(_ApkAsset) _then) = __$ApkAssetCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, int size, int compressedSize, bool isDirectory, int lastModified
});




}
/// @nodoc
class __$ApkAssetCopyWithImpl<$Res>
    implements _$ApkAssetCopyWith<$Res> {
  __$ApkAssetCopyWithImpl(this._self, this._then);

  final _ApkAsset _self;
  final $Res Function(_ApkAsset) _then;

/// Create a copy of ApkAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? size = null,Object? compressedSize = null,Object? isDirectory = null,Object? lastModified = null,}) {
  return _then(_ApkAsset(
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
