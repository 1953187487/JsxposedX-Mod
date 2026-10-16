// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_provider_connection_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiProviderConnectionDto {

 String get id; String get providerId; String get displayName; String get baseUri; String? get credentialRef; Map<String, String> get endpointOverrides; Map<String, String> get customHeaders; Map<String, Object?> get adapterOptions; bool get enabled;
/// Create a copy of AiProviderConnectionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiProviderConnectionDtoCopyWith<AiProviderConnectionDto> get copyWith => _$AiProviderConnectionDtoCopyWithImpl<AiProviderConnectionDto>(this as AiProviderConnectionDto, _$identity);

  /// Serializes this AiProviderConnectionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiProviderConnectionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.baseUri, baseUri) || other.baseUri == baseUri)&&(identical(other.credentialRef, credentialRef) || other.credentialRef == credentialRef)&&const DeepCollectionEquality().equals(other.endpointOverrides, endpointOverrides)&&const DeepCollectionEquality().equals(other.customHeaders, customHeaders)&&const DeepCollectionEquality().equals(other.adapterOptions, adapterOptions)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,providerId,displayName,baseUri,credentialRef,const DeepCollectionEquality().hash(endpointOverrides),const DeepCollectionEquality().hash(customHeaders),const DeepCollectionEquality().hash(adapterOptions),enabled);

@override
String toString() {
  return 'AiProviderConnectionDto(id: $id, providerId: $providerId, displayName: $displayName, baseUri: $baseUri, credentialRef: $credentialRef, endpointOverrides: $endpointOverrides, customHeaders: $customHeaders, adapterOptions: $adapterOptions, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $AiProviderConnectionDtoCopyWith<$Res>  {
  factory $AiProviderConnectionDtoCopyWith(AiProviderConnectionDto value, $Res Function(AiProviderConnectionDto) _then) = _$AiProviderConnectionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String providerId, String displayName, String baseUri, String? credentialRef, Map<String, String> endpointOverrides, Map<String, String> customHeaders, Map<String, Object?> adapterOptions, bool enabled
});




}
/// @nodoc
class _$AiProviderConnectionDtoCopyWithImpl<$Res>
    implements $AiProviderConnectionDtoCopyWith<$Res> {
  _$AiProviderConnectionDtoCopyWithImpl(this._self, this._then);

  final AiProviderConnectionDto _self;
  final $Res Function(AiProviderConnectionDto) _then;

/// Create a copy of AiProviderConnectionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? providerId = null,Object? displayName = null,Object? baseUri = null,Object? credentialRef = freezed,Object? endpointOverrides = null,Object? customHeaders = null,Object? adapterOptions = null,Object? enabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,baseUri: null == baseUri ? _self.baseUri : baseUri // ignore: cast_nullable_to_non_nullable
as String,credentialRef: freezed == credentialRef ? _self.credentialRef : credentialRef // ignore: cast_nullable_to_non_nullable
as String?,endpointOverrides: null == endpointOverrides ? _self.endpointOverrides : endpointOverrides // ignore: cast_nullable_to_non_nullable
as Map<String, String>,customHeaders: null == customHeaders ? _self.customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,adapterOptions: null == adapterOptions ? _self.adapterOptions : adapterOptions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiProviderConnectionDto].
extension AiProviderConnectionDtoPatterns on AiProviderConnectionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiProviderConnectionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiProviderConnectionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiProviderConnectionDto value)  $default,){
final _that = this;
switch (_that) {
case _AiProviderConnectionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiProviderConnectionDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiProviderConnectionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String providerId,  String displayName,  String baseUri,  String? credentialRef,  Map<String, String> endpointOverrides,  Map<String, String> customHeaders,  Map<String, Object?> adapterOptions,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiProviderConnectionDto() when $default != null:
return $default(_that.id,_that.providerId,_that.displayName,_that.baseUri,_that.credentialRef,_that.endpointOverrides,_that.customHeaders,_that.adapterOptions,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String providerId,  String displayName,  String baseUri,  String? credentialRef,  Map<String, String> endpointOverrides,  Map<String, String> customHeaders,  Map<String, Object?> adapterOptions,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _AiProviderConnectionDto():
return $default(_that.id,_that.providerId,_that.displayName,_that.baseUri,_that.credentialRef,_that.endpointOverrides,_that.customHeaders,_that.adapterOptions,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String providerId,  String displayName,  String baseUri,  String? credentialRef,  Map<String, String> endpointOverrides,  Map<String, String> customHeaders,  Map<String, Object?> adapterOptions,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _AiProviderConnectionDto() when $default != null:
return $default(_that.id,_that.providerId,_that.displayName,_that.baseUri,_that.credentialRef,_that.endpointOverrides,_that.customHeaders,_that.adapterOptions,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiProviderConnectionDto extends AiProviderConnectionDto {
  const _AiProviderConnectionDto({required this.id, required this.providerId, required this.displayName, required this.baseUri, this.credentialRef, final  Map<String, String> endpointOverrides = const <String, String>{}, final  Map<String, String> customHeaders = const <String, String>{}, final  Map<String, Object?> adapterOptions = const <String, Object?>{}, this.enabled = true}): _endpointOverrides = endpointOverrides,_customHeaders = customHeaders,_adapterOptions = adapterOptions,super._();
  factory _AiProviderConnectionDto.fromJson(Map<String, dynamic> json) => _$AiProviderConnectionDtoFromJson(json);

@override final  String id;
@override final  String providerId;
@override final  String displayName;
@override final  String baseUri;
@override final  String? credentialRef;
 final  Map<String, String> _endpointOverrides;
@override@JsonKey() Map<String, String> get endpointOverrides {
  if (_endpointOverrides is EqualUnmodifiableMapView) return _endpointOverrides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_endpointOverrides);
}

 final  Map<String, String> _customHeaders;
@override@JsonKey() Map<String, String> get customHeaders {
  if (_customHeaders is EqualUnmodifiableMapView) return _customHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customHeaders);
}

 final  Map<String, Object?> _adapterOptions;
@override@JsonKey() Map<String, Object?> get adapterOptions {
  if (_adapterOptions is EqualUnmodifiableMapView) return _adapterOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_adapterOptions);
}

@override@JsonKey() final  bool enabled;

/// Create a copy of AiProviderConnectionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiProviderConnectionDtoCopyWith<_AiProviderConnectionDto> get copyWith => __$AiProviderConnectionDtoCopyWithImpl<_AiProviderConnectionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiProviderConnectionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiProviderConnectionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.baseUri, baseUri) || other.baseUri == baseUri)&&(identical(other.credentialRef, credentialRef) || other.credentialRef == credentialRef)&&const DeepCollectionEquality().equals(other._endpointOverrides, _endpointOverrides)&&const DeepCollectionEquality().equals(other._customHeaders, _customHeaders)&&const DeepCollectionEquality().equals(other._adapterOptions, _adapterOptions)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,providerId,displayName,baseUri,credentialRef,const DeepCollectionEquality().hash(_endpointOverrides),const DeepCollectionEquality().hash(_customHeaders),const DeepCollectionEquality().hash(_adapterOptions),enabled);

@override
String toString() {
  return 'AiProviderConnectionDto(id: $id, providerId: $providerId, displayName: $displayName, baseUri: $baseUri, credentialRef: $credentialRef, endpointOverrides: $endpointOverrides, customHeaders: $customHeaders, adapterOptions: $adapterOptions, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$AiProviderConnectionDtoCopyWith<$Res> implements $AiProviderConnectionDtoCopyWith<$Res> {
  factory _$AiProviderConnectionDtoCopyWith(_AiProviderConnectionDto value, $Res Function(_AiProviderConnectionDto) _then) = __$AiProviderConnectionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String providerId, String displayName, String baseUri, String? credentialRef, Map<String, String> endpointOverrides, Map<String, String> customHeaders, Map<String, Object?> adapterOptions, bool enabled
});




}
/// @nodoc
class __$AiProviderConnectionDtoCopyWithImpl<$Res>
    implements _$AiProviderConnectionDtoCopyWith<$Res> {
  __$AiProviderConnectionDtoCopyWithImpl(this._self, this._then);

  final _AiProviderConnectionDto _self;
  final $Res Function(_AiProviderConnectionDto) _then;

/// Create a copy of AiProviderConnectionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? providerId = null,Object? displayName = null,Object? baseUri = null,Object? credentialRef = freezed,Object? endpointOverrides = null,Object? customHeaders = null,Object? adapterOptions = null,Object? enabled = null,}) {
  return _then(_AiProviderConnectionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,baseUri: null == baseUri ? _self.baseUri : baseUri // ignore: cast_nullable_to_non_nullable
as String,credentialRef: freezed == credentialRef ? _self.credentialRef : credentialRef // ignore: cast_nullable_to_non_nullable
as String?,endpointOverrides: null == endpointOverrides ? _self._endpointOverrides : endpointOverrides // ignore: cast_nullable_to_non_nullable
as Map<String, String>,customHeaders: null == customHeaders ? _self._customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,adapterOptions: null == adapterOptions ? _self._adapterOptions : adapterOptions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
