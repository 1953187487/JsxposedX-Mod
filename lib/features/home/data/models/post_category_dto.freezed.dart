// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_category_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostCategoryDto {

 int get id; String get name; String get icon; String get description; int get ranking;
/// Create a copy of PostCategoryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCategoryDtoCopyWith<PostCategoryDto> get copyWith => _$PostCategoryDtoCopyWithImpl<PostCategoryDto>(this as PostCategoryDto, _$identity);

  /// Serializes this PostCategoryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostCategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description)&&(identical(other.ranking, ranking) || other.ranking == ranking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,description,ranking);

@override
String toString() {
  return 'PostCategoryDto(id: $id, name: $name, icon: $icon, description: $description, ranking: $ranking)';
}


}

/// @nodoc
abstract mixin class $PostCategoryDtoCopyWith<$Res>  {
  factory $PostCategoryDtoCopyWith(PostCategoryDto value, $Res Function(PostCategoryDto) _then) = _$PostCategoryDtoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String icon, String description, int ranking
});




}
/// @nodoc
class _$PostCategoryDtoCopyWithImpl<$Res>
    implements $PostCategoryDtoCopyWith<$Res> {
  _$PostCategoryDtoCopyWithImpl(this._self, this._then);

  final PostCategoryDto _self;
  final $Res Function(PostCategoryDto) _then;

/// Create a copy of PostCategoryDto
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


/// Adds pattern-matching-related methods to [PostCategoryDto].
extension PostCategoryDtoPatterns on PostCategoryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostCategoryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostCategoryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostCategoryDto value)  $default,){
final _that = this;
switch (_that) {
case _PostCategoryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostCategoryDto value)?  $default,){
final _that = this;
switch (_that) {
case _PostCategoryDto() when $default != null:
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
case _PostCategoryDto() when $default != null:
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
case _PostCategoryDto():
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
case _PostCategoryDto() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.description,_that.ranking);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostCategoryDto extends PostCategoryDto {
  const _PostCategoryDto({this.id = 0, this.name = "", this.icon = "", this.description = "", this.ranking = 0}): super._();
  factory _PostCategoryDto.fromJson(Map<String, dynamic> json) => _$PostCategoryDtoFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String icon;
@override@JsonKey() final  String description;
@override@JsonKey() final  int ranking;

/// Create a copy of PostCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCategoryDtoCopyWith<_PostCategoryDto> get copyWith => __$PostCategoryDtoCopyWithImpl<_PostCategoryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostCategoryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostCategoryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.description, description) || other.description == description)&&(identical(other.ranking, ranking) || other.ranking == ranking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,description,ranking);

@override
String toString() {
  return 'PostCategoryDto(id: $id, name: $name, icon: $icon, description: $description, ranking: $ranking)';
}


}

/// @nodoc
abstract mixin class _$PostCategoryDtoCopyWith<$Res> implements $PostCategoryDtoCopyWith<$Res> {
  factory _$PostCategoryDtoCopyWith(_PostCategoryDto value, $Res Function(_PostCategoryDto) _then) = __$PostCategoryDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String icon, String description, int ranking
});




}
/// @nodoc
class __$PostCategoryDtoCopyWithImpl<$Res>
    implements _$PostCategoryDtoCopyWith<$Res> {
  __$PostCategoryDtoCopyWithImpl(this._self, this._then);

  final _PostCategoryDto _self;
  final $Res Function(_PostCategoryDto) _then;

/// Create a copy of PostCategoryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? description = null,Object? ranking = null,}) {
  return _then(_PostCategoryDto(
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
