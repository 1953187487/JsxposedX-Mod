// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_config_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiConfigDto {

 String get id; String get name; String get apiKey; String get apiUrl; String get moduleName; int get maxToken; double get temperature; double get memoryRounds; String get apiType;
/// Create a copy of AiConfigDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiConfigDtoCopyWith<AiConfigDto> get copyWith => _$AiConfigDtoCopyWithImpl<AiConfigDto>(this as AiConfigDto, _$identity);

  /// Serializes this AiConfigDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiConfigDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.apiUrl, apiUrl) || other.apiUrl == apiUrl)&&(identical(other.moduleName, moduleName) || other.moduleName == moduleName)&&(identical(other.maxToken, maxToken) || other.maxToken == maxToken)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.memoryRounds, memoryRounds) || other.memoryRounds == memoryRounds)&&(identical(other.apiType, apiType) || other.apiType == apiType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,apiKey,apiUrl,moduleName,maxToken,temperature,memoryRounds,apiType);

@override
String toString() {
  return 'AiConfigDto(id: $id, name: $name, apiKey: $apiKey, apiUrl: $apiUrl, moduleName: $moduleName, maxToken: $maxToken, temperature: $temperature, memoryRounds: $memoryRounds, apiType: $apiType)';
}


}

/// @nodoc
abstract mixin class $AiConfigDtoCopyWith<$Res>  {
  factory $AiConfigDtoCopyWith(AiConfigDto value, $Res Function(AiConfigDto) _then) = _$AiConfigDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String apiKey, String apiUrl, String moduleName, int maxToken, double temperature, double memoryRounds, String apiType
});




}
/// @nodoc
class _$AiConfigDtoCopyWithImpl<$Res>
    implements $AiConfigDtoCopyWith<$Res> {
  _$AiConfigDtoCopyWithImpl(this._self, this._then);

  final AiConfigDto _self;
  final $Res Function(AiConfigDto) _then;

/// Create a copy of AiConfigDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? apiKey = null,Object? apiUrl = null,Object? moduleName = null,Object? maxToken = null,Object? temperature = null,Object? memoryRounds = null,Object? apiType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,apiUrl: null == apiUrl ? _self.apiUrl : apiUrl // ignore: cast_nullable_to_non_nullable
as String,moduleName: null == moduleName ? _self.moduleName : moduleName // ignore: cast_nullable_to_non_nullable
as String,maxToken: null == maxToken ? _self.maxToken : maxToken // ignore: cast_nullable_to_non_nullable
as int,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,memoryRounds: null == memoryRounds ? _self.memoryRounds : memoryRounds // ignore: cast_nullable_to_non_nullable
as double,apiType: null == apiType ? _self.apiType : apiType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiConfigDto].
extension AiConfigDtoPatterns on AiConfigDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiConfigDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiConfigDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiConfigDto value)  $default,){
final _that = this;
switch (_that) {
case _AiConfigDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiConfigDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiConfigDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String apiKey,  String apiUrl,  String moduleName,  int maxToken,  double temperature,  double memoryRounds,  String apiType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiConfigDto() when $default != null:
return $default(_that.id,_that.name,_that.apiKey,_that.apiUrl,_that.moduleName,_that.maxToken,_that.temperature,_that.memoryRounds,_that.apiType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String apiKey,  String apiUrl,  String moduleName,  int maxToken,  double temperature,  double memoryRounds,  String apiType)  $default,) {final _that = this;
switch (_that) {
case _AiConfigDto():
return $default(_that.id,_that.name,_that.apiKey,_that.apiUrl,_that.moduleName,_that.maxToken,_that.temperature,_that.memoryRounds,_that.apiType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String apiKey,  String apiUrl,  String moduleName,  int maxToken,  double temperature,  double memoryRounds,  String apiType)?  $default,) {final _that = this;
switch (_that) {
case _AiConfigDto() when $default != null:
return $default(_that.id,_that.name,_that.apiKey,_that.apiUrl,_that.moduleName,_that.maxToken,_that.temperature,_that.memoryRounds,_that.apiType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiConfigDto extends AiConfigDto {
  const _AiConfigDto({this.id = "", this.name = "", this.apiKey = "", this.apiUrl = "", this.moduleName = "", this.maxToken = 300, this.temperature = 0.8, this.memoryRounds = 10, this.apiType = 'openai'}): super._();
  factory _AiConfigDto.fromJson(Map<String, dynamic> json) => _$AiConfigDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String apiKey;
@override@JsonKey() final  String apiUrl;
@override@JsonKey() final  String moduleName;
@override@JsonKey() final  int maxToken;
@override@JsonKey() final  double temperature;
@override@JsonKey() final  double memoryRounds;
@override@JsonKey() final  String apiType;

/// Create a copy of AiConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiConfigDtoCopyWith<_AiConfigDto> get copyWith => __$AiConfigDtoCopyWithImpl<_AiConfigDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiConfigDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiConfigDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.apiUrl, apiUrl) || other.apiUrl == apiUrl)&&(identical(other.moduleName, moduleName) || other.moduleName == moduleName)&&(identical(other.maxToken, maxToken) || other.maxToken == maxToken)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.memoryRounds, memoryRounds) || other.memoryRounds == memoryRounds)&&(identical(other.apiType, apiType) || other.apiType == apiType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,apiKey,apiUrl,moduleName,maxToken,temperature,memoryRounds,apiType);

@override
String toString() {
  return 'AiConfigDto(id: $id, name: $name, apiKey: $apiKey, apiUrl: $apiUrl, moduleName: $moduleName, maxToken: $maxToken, temperature: $temperature, memoryRounds: $memoryRounds, apiType: $apiType)';
}


}

/// @nodoc
abstract mixin class _$AiConfigDtoCopyWith<$Res> implements $AiConfigDtoCopyWith<$Res> {
  factory _$AiConfigDtoCopyWith(_AiConfigDto value, $Res Function(_AiConfigDto) _then) = __$AiConfigDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String apiKey, String apiUrl, String moduleName, int maxToken, double temperature, double memoryRounds, String apiType
});




}
/// @nodoc
class __$AiConfigDtoCopyWithImpl<$Res>
    implements _$AiConfigDtoCopyWith<$Res> {
  __$AiConfigDtoCopyWithImpl(this._self, this._then);

  final _AiConfigDto _self;
  final $Res Function(_AiConfigDto) _then;

/// Create a copy of AiConfigDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? apiKey = null,Object? apiUrl = null,Object? moduleName = null,Object? maxToken = null,Object? temperature = null,Object? memoryRounds = null,Object? apiType = null,}) {
  return _then(_AiConfigDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,apiUrl: null == apiUrl ? _self.apiUrl : apiUrl // ignore: cast_nullable_to_non_nullable
as String,moduleName: null == moduleName ? _self.moduleName : moduleName // ignore: cast_nullable_to_non_nullable
as String,maxToken: null == maxToken ? _self.maxToken : maxToken // ignore: cast_nullable_to_non_nullable
as int,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,memoryRounds: null == memoryRounds ? _self.memoryRounds : memoryRounds // ignore: cast_nullable_to_non_nullable
as double,apiType: null == apiType ? _self.apiType : apiType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
