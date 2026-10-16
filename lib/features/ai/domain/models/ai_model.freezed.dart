// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiModel {

 String get id; String get object; int get created; String get ownedBy; List<String> get supportedEndpointTypes; int? get contextTokens; int? get maxOutputTokens;
/// Create a copy of AiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelCopyWith<AiModel> get copyWith => _$AiModelCopyWithImpl<AiModel>(this as AiModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.object, object) || other.object == object)&&(identical(other.created, created) || other.created == created)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&const DeepCollectionEquality().equals(other.supportedEndpointTypes, supportedEndpointTypes)&&(identical(other.contextTokens, contextTokens) || other.contextTokens == contextTokens)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens));
}


@override
int get hashCode => Object.hash(runtimeType,id,object,created,ownedBy,const DeepCollectionEquality().hash(supportedEndpointTypes),contextTokens,maxOutputTokens);

@override
String toString() {
  return 'AiModel(id: $id, object: $object, created: $created, ownedBy: $ownedBy, supportedEndpointTypes: $supportedEndpointTypes, contextTokens: $contextTokens, maxOutputTokens: $maxOutputTokens)';
}


}

/// @nodoc
abstract mixin class $AiModelCopyWith<$Res>  {
  factory $AiModelCopyWith(AiModel value, $Res Function(AiModel) _then) = _$AiModelCopyWithImpl;
@useResult
$Res call({
 String id, String object, int created, String ownedBy, List<String> supportedEndpointTypes, int? contextTokens, int? maxOutputTokens
});




}
/// @nodoc
class _$AiModelCopyWithImpl<$Res>
    implements $AiModelCopyWith<$Res> {
  _$AiModelCopyWithImpl(this._self, this._then);

  final AiModel _self;
  final $Res Function(AiModel) _then;

/// Create a copy of AiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? object = null,Object? created = null,Object? ownedBy = null,Object? supportedEndpointTypes = null,Object? contextTokens = freezed,Object? maxOutputTokens = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,object: null == object ? _self.object : object // ignore: cast_nullable_to_non_nullable
as String,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int,ownedBy: null == ownedBy ? _self.ownedBy : ownedBy // ignore: cast_nullable_to_non_nullable
as String,supportedEndpointTypes: null == supportedEndpointTypes ? _self.supportedEndpointTypes : supportedEndpointTypes // ignore: cast_nullable_to_non_nullable
as List<String>,contextTokens: freezed == contextTokens ? _self.contextTokens : contextTokens // ignore: cast_nullable_to_non_nullable
as int?,maxOutputTokens: freezed == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiModel].
extension AiModelPatterns on AiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModel value)  $default,){
final _that = this;
switch (_that) {
case _AiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModel value)?  $default,){
final _that = this;
switch (_that) {
case _AiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String object,  int created,  String ownedBy,  List<String> supportedEndpointTypes,  int? contextTokens,  int? maxOutputTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiModel() when $default != null:
return $default(_that.id,_that.object,_that.created,_that.ownedBy,_that.supportedEndpointTypes,_that.contextTokens,_that.maxOutputTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String object,  int created,  String ownedBy,  List<String> supportedEndpointTypes,  int? contextTokens,  int? maxOutputTokens)  $default,) {final _that = this;
switch (_that) {
case _AiModel():
return $default(_that.id,_that.object,_that.created,_that.ownedBy,_that.supportedEndpointTypes,_that.contextTokens,_that.maxOutputTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String object,  int created,  String ownedBy,  List<String> supportedEndpointTypes,  int? contextTokens,  int? maxOutputTokens)?  $default,) {final _that = this;
switch (_that) {
case _AiModel() when $default != null:
return $default(_that.id,_that.object,_that.created,_that.ownedBy,_that.supportedEndpointTypes,_that.contextTokens,_that.maxOutputTokens);case _:
  return null;

}
}

}

/// @nodoc


class _AiModel extends AiModel {
  const _AiModel({required this.id, required this.object, required this.created, required this.ownedBy, required final  List<String> supportedEndpointTypes, this.contextTokens, this.maxOutputTokens}): _supportedEndpointTypes = supportedEndpointTypes,super._();
  

@override final  String id;
@override final  String object;
@override final  int created;
@override final  String ownedBy;
 final  List<String> _supportedEndpointTypes;
@override List<String> get supportedEndpointTypes {
  if (_supportedEndpointTypes is EqualUnmodifiableListView) return _supportedEndpointTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportedEndpointTypes);
}

@override final  int? contextTokens;
@override final  int? maxOutputTokens;

/// Create a copy of AiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelCopyWith<_AiModel> get copyWith => __$AiModelCopyWithImpl<_AiModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.object, object) || other.object == object)&&(identical(other.created, created) || other.created == created)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&const DeepCollectionEquality().equals(other._supportedEndpointTypes, _supportedEndpointTypes)&&(identical(other.contextTokens, contextTokens) || other.contextTokens == contextTokens)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens));
}


@override
int get hashCode => Object.hash(runtimeType,id,object,created,ownedBy,const DeepCollectionEquality().hash(_supportedEndpointTypes),contextTokens,maxOutputTokens);

@override
String toString() {
  return 'AiModel(id: $id, object: $object, created: $created, ownedBy: $ownedBy, supportedEndpointTypes: $supportedEndpointTypes, contextTokens: $contextTokens, maxOutputTokens: $maxOutputTokens)';
}


}

/// @nodoc
abstract mixin class _$AiModelCopyWith<$Res> implements $AiModelCopyWith<$Res> {
  factory _$AiModelCopyWith(_AiModel value, $Res Function(_AiModel) _then) = __$AiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String object, int created, String ownedBy, List<String> supportedEndpointTypes, int? contextTokens, int? maxOutputTokens
});




}
/// @nodoc
class __$AiModelCopyWithImpl<$Res>
    implements _$AiModelCopyWith<$Res> {
  __$AiModelCopyWithImpl(this._self, this._then);

  final _AiModel _self;
  final $Res Function(_AiModel) _then;

/// Create a copy of AiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? object = null,Object? created = null,Object? ownedBy = null,Object? supportedEndpointTypes = null,Object? contextTokens = freezed,Object? maxOutputTokens = freezed,}) {
  return _then(_AiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,object: null == object ? _self.object : object // ignore: cast_nullable_to_non_nullable
as String,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int,ownedBy: null == ownedBy ? _self.ownedBy : ownedBy // ignore: cast_nullable_to_non_nullable
as String,supportedEndpointTypes: null == supportedEndpointTypes ? _self._supportedEndpointTypes : supportedEndpointTypes // ignore: cast_nullable_to_non_nullable
as List<String>,contextTokens: freezed == contextTokens ? _self.contextTokens : contextTokens // ignore: cast_nullable_to_non_nullable
as int?,maxOutputTokens: freezed == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
