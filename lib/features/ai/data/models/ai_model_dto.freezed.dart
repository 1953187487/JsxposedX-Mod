// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_model_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiModelDto {

 String get id; String get object; int get created;@JsonKey(name: "owned_by") String get ownedBy;@JsonKey(name: "supported_endpoint_types") List<String> get supportedEndpointTypes;@JsonKey(name: 'context_length') int? get contextTokens;@JsonKey(name: 'max_output_tokens') int? get maxOutputTokens;
/// Create a copy of AiModelDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelDtoCopyWith<AiModelDto> get copyWith => _$AiModelDtoCopyWithImpl<AiModelDto>(this as AiModelDto, _$identity);

  /// Serializes this AiModelDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModelDto&&(identical(other.id, id) || other.id == id)&&(identical(other.object, object) || other.object == object)&&(identical(other.created, created) || other.created == created)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&const DeepCollectionEquality().equals(other.supportedEndpointTypes, supportedEndpointTypes)&&(identical(other.contextTokens, contextTokens) || other.contextTokens == contextTokens)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,object,created,ownedBy,const DeepCollectionEquality().hash(supportedEndpointTypes),contextTokens,maxOutputTokens);

@override
String toString() {
  return 'AiModelDto(id: $id, object: $object, created: $created, ownedBy: $ownedBy, supportedEndpointTypes: $supportedEndpointTypes, contextTokens: $contextTokens, maxOutputTokens: $maxOutputTokens)';
}


}

/// @nodoc
abstract mixin class $AiModelDtoCopyWith<$Res>  {
  factory $AiModelDtoCopyWith(AiModelDto value, $Res Function(AiModelDto) _then) = _$AiModelDtoCopyWithImpl;
@useResult
$Res call({
 String id, String object, int created,@JsonKey(name: "owned_by") String ownedBy,@JsonKey(name: "supported_endpoint_types") List<String> supportedEndpointTypes,@JsonKey(name: 'context_length') int? contextTokens,@JsonKey(name: 'max_output_tokens') int? maxOutputTokens
});




}
/// @nodoc
class _$AiModelDtoCopyWithImpl<$Res>
    implements $AiModelDtoCopyWith<$Res> {
  _$AiModelDtoCopyWithImpl(this._self, this._then);

  final AiModelDto _self;
  final $Res Function(AiModelDto) _then;

/// Create a copy of AiModelDto
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


/// Adds pattern-matching-related methods to [AiModelDto].
extension AiModelDtoPatterns on AiModelDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModelDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModelDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModelDto value)  $default,){
final _that = this;
switch (_that) {
case _AiModelDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModelDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiModelDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String object,  int created, @JsonKey(name: "owned_by")  String ownedBy, @JsonKey(name: "supported_endpoint_types")  List<String> supportedEndpointTypes, @JsonKey(name: 'context_length')  int? contextTokens, @JsonKey(name: 'max_output_tokens')  int? maxOutputTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiModelDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String object,  int created, @JsonKey(name: "owned_by")  String ownedBy, @JsonKey(name: "supported_endpoint_types")  List<String> supportedEndpointTypes, @JsonKey(name: 'context_length')  int? contextTokens, @JsonKey(name: 'max_output_tokens')  int? maxOutputTokens)  $default,) {final _that = this;
switch (_that) {
case _AiModelDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String object,  int created, @JsonKey(name: "owned_by")  String ownedBy, @JsonKey(name: "supported_endpoint_types")  List<String> supportedEndpointTypes, @JsonKey(name: 'context_length')  int? contextTokens, @JsonKey(name: 'max_output_tokens')  int? maxOutputTokens)?  $default,) {final _that = this;
switch (_that) {
case _AiModelDto() when $default != null:
return $default(_that.id,_that.object,_that.created,_that.ownedBy,_that.supportedEndpointTypes,_that.contextTokens,_that.maxOutputTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiModelDto extends AiModelDto {
  const _AiModelDto({this.id = '', this.object = '', this.created = 0, @JsonKey(name: "owned_by") this.ownedBy = '', @JsonKey(name: "supported_endpoint_types") final  List<String> supportedEndpointTypes = const [], @JsonKey(name: 'context_length') this.contextTokens, @JsonKey(name: 'max_output_tokens') this.maxOutputTokens}): _supportedEndpointTypes = supportedEndpointTypes,super._();
  factory _AiModelDto.fromJson(Map<String, dynamic> json) => _$AiModelDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String object;
@override@JsonKey() final  int created;
@override@JsonKey(name: "owned_by") final  String ownedBy;
 final  List<String> _supportedEndpointTypes;
@override@JsonKey(name: "supported_endpoint_types") List<String> get supportedEndpointTypes {
  if (_supportedEndpointTypes is EqualUnmodifiableListView) return _supportedEndpointTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportedEndpointTypes);
}

@override@JsonKey(name: 'context_length') final  int? contextTokens;
@override@JsonKey(name: 'max_output_tokens') final  int? maxOutputTokens;

/// Create a copy of AiModelDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelDtoCopyWith<_AiModelDto> get copyWith => __$AiModelDtoCopyWithImpl<_AiModelDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiModelDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModelDto&&(identical(other.id, id) || other.id == id)&&(identical(other.object, object) || other.object == object)&&(identical(other.created, created) || other.created == created)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&const DeepCollectionEquality().equals(other._supportedEndpointTypes, _supportedEndpointTypes)&&(identical(other.contextTokens, contextTokens) || other.contextTokens == contextTokens)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,object,created,ownedBy,const DeepCollectionEquality().hash(_supportedEndpointTypes),contextTokens,maxOutputTokens);

@override
String toString() {
  return 'AiModelDto(id: $id, object: $object, created: $created, ownedBy: $ownedBy, supportedEndpointTypes: $supportedEndpointTypes, contextTokens: $contextTokens, maxOutputTokens: $maxOutputTokens)';
}


}

/// @nodoc
abstract mixin class _$AiModelDtoCopyWith<$Res> implements $AiModelDtoCopyWith<$Res> {
  factory _$AiModelDtoCopyWith(_AiModelDto value, $Res Function(_AiModelDto) _then) = __$AiModelDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String object, int created,@JsonKey(name: "owned_by") String ownedBy,@JsonKey(name: "supported_endpoint_types") List<String> supportedEndpointTypes,@JsonKey(name: 'context_length') int? contextTokens,@JsonKey(name: 'max_output_tokens') int? maxOutputTokens
});




}
/// @nodoc
class __$AiModelDtoCopyWithImpl<$Res>
    implements _$AiModelDtoCopyWith<$Res> {
  __$AiModelDtoCopyWithImpl(this._self, this._then);

  final _AiModelDto _self;
  final $Res Function(_AiModelDto) _then;

/// Create a copy of AiModelDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? object = null,Object? created = null,Object? ownedBy = null,Object? supportedEndpointTypes = null,Object? contextTokens = freezed,Object? maxOutputTokens = freezed,}) {
  return _then(_AiModelDto(
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
