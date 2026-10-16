// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_functions_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuickFunctionsConfigDto {

 List<QuickFunctionsConfigItemDto> get items;
/// Create a copy of QuickFunctionsConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickFunctionsConfigDtoCopyWith<QuickFunctionsConfigDto> get copyWith => _$QuickFunctionsConfigDtoCopyWithImpl<QuickFunctionsConfigDto>(this as QuickFunctionsConfigDto, _$identity);

  /// Serializes this QuickFunctionsConfigDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickFunctionsConfigDto&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'QuickFunctionsConfigDto(items: $items)';
}


}

/// @nodoc
abstract mixin class $QuickFunctionsConfigDtoCopyWith<$Res>  {
  factory $QuickFunctionsConfigDtoCopyWith(QuickFunctionsConfigDto value, $Res Function(QuickFunctionsConfigDto) _then) = _$QuickFunctionsConfigDtoCopyWithImpl;
@useResult
$Res call({
 List<QuickFunctionsConfigItemDto> items
});




}
/// @nodoc
class _$QuickFunctionsConfigDtoCopyWithImpl<$Res>
    implements $QuickFunctionsConfigDtoCopyWith<$Res> {
  _$QuickFunctionsConfigDtoCopyWithImpl(this._self, this._then);

  final QuickFunctionsConfigDto _self;
  final $Res Function(QuickFunctionsConfigDto) _then;

/// Create a copy of QuickFunctionsConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<QuickFunctionsConfigItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickFunctionsConfigDto].
extension QuickFunctionsConfigDtoPatterns on QuickFunctionsConfigDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickFunctionsConfigDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickFunctionsConfigDto value)  $default,){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickFunctionsConfigDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuickFunctionsConfigItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickFunctionsConfigDto() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuickFunctionsConfigItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _QuickFunctionsConfigDto():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuickFunctionsConfigItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _QuickFunctionsConfigDto() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuickFunctionsConfigDto extends QuickFunctionsConfigDto {
  const _QuickFunctionsConfigDto({required final  List<QuickFunctionsConfigItemDto> items}): _items = items,super._();
  factory _QuickFunctionsConfigDto.fromJson(Map<String, dynamic> json) => _$QuickFunctionsConfigDtoFromJson(json);

 final  List<QuickFunctionsConfigItemDto> _items;
@override List<QuickFunctionsConfigItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of QuickFunctionsConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickFunctionsConfigDtoCopyWith<_QuickFunctionsConfigDto> get copyWith => __$QuickFunctionsConfigDtoCopyWithImpl<_QuickFunctionsConfigDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickFunctionsConfigDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickFunctionsConfigDto&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'QuickFunctionsConfigDto(items: $items)';
}


}

/// @nodoc
abstract mixin class _$QuickFunctionsConfigDtoCopyWith<$Res> implements $QuickFunctionsConfigDtoCopyWith<$Res> {
  factory _$QuickFunctionsConfigDtoCopyWith(_QuickFunctionsConfigDto value, $Res Function(_QuickFunctionsConfigDto) _then) = __$QuickFunctionsConfigDtoCopyWithImpl;
@override @useResult
$Res call({
 List<QuickFunctionsConfigItemDto> items
});




}
/// @nodoc
class __$QuickFunctionsConfigDtoCopyWithImpl<$Res>
    implements _$QuickFunctionsConfigDtoCopyWith<$Res> {
  __$QuickFunctionsConfigDtoCopyWithImpl(this._self, this._then);

  final _QuickFunctionsConfigDto _self;
  final $Res Function(_QuickFunctionsConfigDto) _then;

/// Create a copy of QuickFunctionsConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_QuickFunctionsConfigDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<QuickFunctionsConfigItemDto>,
  ));
}


}


/// @nodoc
mixin _$QuickFunctionsConfigItemDto {

 String get name; bool get status;
/// Create a copy of QuickFunctionsConfigItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickFunctionsConfigItemDtoCopyWith<QuickFunctionsConfigItemDto> get copyWith => _$QuickFunctionsConfigItemDtoCopyWithImpl<QuickFunctionsConfigItemDto>(this as QuickFunctionsConfigItemDto, _$identity);

  /// Serializes this QuickFunctionsConfigItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickFunctionsConfigItemDto&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,status);

@override
String toString() {
  return 'QuickFunctionsConfigItemDto(name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class $QuickFunctionsConfigItemDtoCopyWith<$Res>  {
  factory $QuickFunctionsConfigItemDtoCopyWith(QuickFunctionsConfigItemDto value, $Res Function(QuickFunctionsConfigItemDto) _then) = _$QuickFunctionsConfigItemDtoCopyWithImpl;
@useResult
$Res call({
 String name, bool status
});




}
/// @nodoc
class _$QuickFunctionsConfigItemDtoCopyWithImpl<$Res>
    implements $QuickFunctionsConfigItemDtoCopyWith<$Res> {
  _$QuickFunctionsConfigItemDtoCopyWithImpl(this._self, this._then);

  final QuickFunctionsConfigItemDto _self;
  final $Res Function(QuickFunctionsConfigItemDto) _then;

/// Create a copy of QuickFunctionsConfigItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickFunctionsConfigItemDto].
extension QuickFunctionsConfigItemDtoPatterns on QuickFunctionsConfigItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickFunctionsConfigItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickFunctionsConfigItemDto value)  $default,){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickFunctionsConfigItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickFunctionsConfigItemDto() when $default != null:
return $default(_that.name,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool status)  $default,) {final _that = this;
switch (_that) {
case _QuickFunctionsConfigItemDto():
return $default(_that.name,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool status)?  $default,) {final _that = this;
switch (_that) {
case _QuickFunctionsConfigItemDto() when $default != null:
return $default(_that.name,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuickFunctionsConfigItemDto extends QuickFunctionsConfigItemDto {
  const _QuickFunctionsConfigItemDto({required this.name, required this.status}): super._();
  factory _QuickFunctionsConfigItemDto.fromJson(Map<String, dynamic> json) => _$QuickFunctionsConfigItemDtoFromJson(json);

@override final  String name;
@override final  bool status;

/// Create a copy of QuickFunctionsConfigItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickFunctionsConfigItemDtoCopyWith<_QuickFunctionsConfigItemDto> get copyWith => __$QuickFunctionsConfigItemDtoCopyWithImpl<_QuickFunctionsConfigItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickFunctionsConfigItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickFunctionsConfigItemDto&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,status);

@override
String toString() {
  return 'QuickFunctionsConfigItemDto(name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class _$QuickFunctionsConfigItemDtoCopyWith<$Res> implements $QuickFunctionsConfigItemDtoCopyWith<$Res> {
  factory _$QuickFunctionsConfigItemDtoCopyWith(_QuickFunctionsConfigItemDto value, $Res Function(_QuickFunctionsConfigItemDto) _then) = __$QuickFunctionsConfigItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, bool status
});




}
/// @nodoc
class __$QuickFunctionsConfigItemDtoCopyWithImpl<$Res>
    implements _$QuickFunctionsConfigItemDtoCopyWith<$Res> {
  __$QuickFunctionsConfigItemDtoCopyWithImpl(this._self, this._then);

  final _QuickFunctionsConfigItemDto _self;
  final $Res Function(_QuickFunctionsConfigItemDto) _then;

/// Create a copy of QuickFunctionsConfigItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,}) {
  return _then(_QuickFunctionsConfigItemDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
