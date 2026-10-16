// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_functions_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuickFunctionsConfig {

 List<QuickFunctionsConfigItem> get items;
/// Create a copy of QuickFunctionsConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickFunctionsConfigCopyWith<QuickFunctionsConfig> get copyWith => _$QuickFunctionsConfigCopyWithImpl<QuickFunctionsConfig>(this as QuickFunctionsConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickFunctionsConfig&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'QuickFunctionsConfig(items: $items)';
}


}

/// @nodoc
abstract mixin class $QuickFunctionsConfigCopyWith<$Res>  {
  factory $QuickFunctionsConfigCopyWith(QuickFunctionsConfig value, $Res Function(QuickFunctionsConfig) _then) = _$QuickFunctionsConfigCopyWithImpl;
@useResult
$Res call({
 List<QuickFunctionsConfigItem> items
});




}
/// @nodoc
class _$QuickFunctionsConfigCopyWithImpl<$Res>
    implements $QuickFunctionsConfigCopyWith<$Res> {
  _$QuickFunctionsConfigCopyWithImpl(this._self, this._then);

  final QuickFunctionsConfig _self;
  final $Res Function(QuickFunctionsConfig) _then;

/// Create a copy of QuickFunctionsConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<QuickFunctionsConfigItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickFunctionsConfig].
extension QuickFunctionsConfigPatterns on QuickFunctionsConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickFunctionsConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickFunctionsConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickFunctionsConfig value)  $default,){
final _that = this;
switch (_that) {
case _QuickFunctionsConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickFunctionsConfig value)?  $default,){
final _that = this;
switch (_that) {
case _QuickFunctionsConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuickFunctionsConfigItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickFunctionsConfig() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuickFunctionsConfigItem> items)  $default,) {final _that = this;
switch (_that) {
case _QuickFunctionsConfig():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuickFunctionsConfigItem> items)?  $default,) {final _that = this;
switch (_that) {
case _QuickFunctionsConfig() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _QuickFunctionsConfig extends QuickFunctionsConfig {
  const _QuickFunctionsConfig({required final  List<QuickFunctionsConfigItem> items}): _items = items,super._();
  

 final  List<QuickFunctionsConfigItem> _items;
@override List<QuickFunctionsConfigItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of QuickFunctionsConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickFunctionsConfigCopyWith<_QuickFunctionsConfig> get copyWith => __$QuickFunctionsConfigCopyWithImpl<_QuickFunctionsConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickFunctionsConfig&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'QuickFunctionsConfig(items: $items)';
}


}

/// @nodoc
abstract mixin class _$QuickFunctionsConfigCopyWith<$Res> implements $QuickFunctionsConfigCopyWith<$Res> {
  factory _$QuickFunctionsConfigCopyWith(_QuickFunctionsConfig value, $Res Function(_QuickFunctionsConfig) _then) = __$QuickFunctionsConfigCopyWithImpl;
@override @useResult
$Res call({
 List<QuickFunctionsConfigItem> items
});




}
/// @nodoc
class __$QuickFunctionsConfigCopyWithImpl<$Res>
    implements _$QuickFunctionsConfigCopyWith<$Res> {
  __$QuickFunctionsConfigCopyWithImpl(this._self, this._then);

  final _QuickFunctionsConfig _self;
  final $Res Function(_QuickFunctionsConfig) _then;

/// Create a copy of QuickFunctionsConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_QuickFunctionsConfig(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<QuickFunctionsConfigItem>,
  ));
}


}

/// @nodoc
mixin _$QuickFunctionsConfigItem {

 String get name; bool get status;
/// Create a copy of QuickFunctionsConfigItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickFunctionsConfigItemCopyWith<QuickFunctionsConfigItem> get copyWith => _$QuickFunctionsConfigItemCopyWithImpl<QuickFunctionsConfigItem>(this as QuickFunctionsConfigItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickFunctionsConfigItem&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,name,status);

@override
String toString() {
  return 'QuickFunctionsConfigItem(name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class $QuickFunctionsConfigItemCopyWith<$Res>  {
  factory $QuickFunctionsConfigItemCopyWith(QuickFunctionsConfigItem value, $Res Function(QuickFunctionsConfigItem) _then) = _$QuickFunctionsConfigItemCopyWithImpl;
@useResult
$Res call({
 String name, bool status
});




}
/// @nodoc
class _$QuickFunctionsConfigItemCopyWithImpl<$Res>
    implements $QuickFunctionsConfigItemCopyWith<$Res> {
  _$QuickFunctionsConfigItemCopyWithImpl(this._self, this._then);

  final QuickFunctionsConfigItem _self;
  final $Res Function(QuickFunctionsConfigItem) _then;

/// Create a copy of QuickFunctionsConfigItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? status = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickFunctionsConfigItem].
extension QuickFunctionsConfigItemPatterns on QuickFunctionsConfigItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickFunctionsConfigItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickFunctionsConfigItem value)  $default,){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickFunctionsConfigItem value)?  $default,){
final _that = this;
switch (_that) {
case _QuickFunctionsConfigItem() when $default != null:
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
case _QuickFunctionsConfigItem() when $default != null:
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
case _QuickFunctionsConfigItem():
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
case _QuickFunctionsConfigItem() when $default != null:
return $default(_that.name,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _QuickFunctionsConfigItem extends QuickFunctionsConfigItem {
  const _QuickFunctionsConfigItem({required this.name, required this.status}): super._();
  

@override final  String name;
@override final  bool status;

/// Create a copy of QuickFunctionsConfigItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickFunctionsConfigItemCopyWith<_QuickFunctionsConfigItem> get copyWith => __$QuickFunctionsConfigItemCopyWithImpl<_QuickFunctionsConfigItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickFunctionsConfigItem&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,name,status);

@override
String toString() {
  return 'QuickFunctionsConfigItem(name: $name, status: $status)';
}


}

/// @nodoc
abstract mixin class _$QuickFunctionsConfigItemCopyWith<$Res> implements $QuickFunctionsConfigItemCopyWith<$Res> {
  factory _$QuickFunctionsConfigItemCopyWith(_QuickFunctionsConfigItem value, $Res Function(_QuickFunctionsConfigItem) _then) = __$QuickFunctionsConfigItemCopyWithImpl;
@override @useResult
$Res call({
 String name, bool status
});




}
/// @nodoc
class __$QuickFunctionsConfigItemCopyWithImpl<$Res>
    implements _$QuickFunctionsConfigItemCopyWith<$Res> {
  __$QuickFunctionsConfigItemCopyWithImpl(this._self, this._then);

  final _QuickFunctionsConfigItem _self;
  final $Res Function(_QuickFunctionsConfigItem) _then;

/// Create a copy of QuickFunctionsConfigItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? status = null,}) {
  return _then(_QuickFunctionsConfigItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
