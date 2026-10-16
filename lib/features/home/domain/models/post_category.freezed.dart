// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostCategory {

 int get id; String get name; String get icon; String get description; int get ranking;
/// Create a copy of PostCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCategoryCopyWith<PostCategory> get copyWith => _$PostCategoryCopyWithImpl<PostCategory>(this as PostCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description)&&(identical(other.ranking, ranking) || other.ranking == ranking));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,icon,description,ranking);

@override
String toString() {
  return 'PostCategory(id: $id, name: $name, icon: $icon, description: $description, ranking: $ranking)';
}


}

/// @nodoc
abstract mixin class $PostCategoryCopyWith<$Res>  {
  factory $PostCategoryCopyWith(PostCategory value, $Res Function(PostCategory) _then) = _$PostCategoryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String icon, String description, int ranking
});




}
/// @nodoc
class _$PostCategoryCopyWithImpl<$Res>
    implements $PostCategoryCopyWith<$Res> {
  _$PostCategoryCopyWithImpl(this._self, this._then);

  final PostCategory _self;
  final $Res Function(PostCategory) _then;

/// Create a copy of PostCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? description = null,Object? ranking = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PostCategory].
extension PostCategoryPatterns on PostCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostCategory value)  $default,){
final _that = this;
switch (_that) {
case _PostCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostCategory value)?  $default,){
final _that = this;
switch (_that) {
case _PostCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String icon,  String description,  int ranking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostCategory() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.description,_that.ranking);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String icon,  String description,  int ranking)  $default,) {final _that = this;
switch (_that) {
case _PostCategory():
return $default(_that.id,_that.name,_that.icon,_that.description,_that.ranking);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String icon,  String description,  int ranking)?  $default,) {final _that = this;
switch (_that) {
case _PostCategory() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.description,_that.ranking);case _:
  return null;

}
}

}

/// @nodoc


class _PostCategory extends PostCategory {
  const _PostCategory({required this.id, required this.name, required this.icon, required this.description, required this.ranking}): super._();
  

@override final  int id;
@override final  String name;
@override final  String icon;
@override final  String description;
@override final  int ranking;

/// Create a copy of PostCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCategoryCopyWith<_PostCategory> get copyWith => __$PostCategoryCopyWithImpl<_PostCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description)&&(identical(other.ranking, ranking) || other.ranking == ranking));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,icon,description,ranking);

@override
String toString() {
  return 'PostCategory(id: $id, name: $name, icon: $icon, description: $description, ranking: $ranking)';
}


}

/// @nodoc
abstract mixin class _$PostCategoryCopyWith<$Res> implements $PostCategoryCopyWith<$Res> {
  factory _$PostCategoryCopyWith(_PostCategory value, $Res Function(_PostCategory) _then) = __$PostCategoryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String icon, String description, int ranking
});




}
/// @nodoc
class __$PostCategoryCopyWithImpl<$Res>
    implements _$PostCategoryCopyWith<$Res> {
  __$PostCategoryCopyWithImpl(this._self, this._then);

  final _PostCategory _self;
  final $Res Function(_PostCategory) _then;

/// Create a copy of PostCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? description = null,Object? ranking = null,}) {
  return _then(_PostCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
