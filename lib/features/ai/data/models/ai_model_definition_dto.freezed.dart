// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_model_definition_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiModelCapabilitiesDto {

 bool get streaming; bool get visionInput; bool get fileInput; bool get reasoning; bool get toolCalling; bool get parallelToolCalling; bool get structuredOutput; bool get systemRole;
/// Create a copy of AiModelCapabilitiesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelCapabilitiesDtoCopyWith<AiModelCapabilitiesDto> get copyWith => _$AiModelCapabilitiesDtoCopyWithImpl<AiModelCapabilitiesDto>(this as AiModelCapabilitiesDto, _$identity);

  /// Serializes this AiModelCapabilitiesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModelCapabilitiesDto&&(identical(other.streaming, streaming) || other.streaming == streaming)&&(identical(other.visionInput, visionInput) || other.visionInput == visionInput)&&(identical(other.fileInput, fileInput) || other.fileInput == fileInput)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&(identical(other.toolCalling, toolCalling) || other.toolCalling == toolCalling)&&(identical(other.parallelToolCalling, parallelToolCalling) || other.parallelToolCalling == parallelToolCalling)&&(identical(other.structuredOutput, structuredOutput) || other.structuredOutput == structuredOutput)&&(identical(other.systemRole, systemRole) || other.systemRole == systemRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streaming,visionInput,fileInput,reasoning,toolCalling,parallelToolCalling,structuredOutput,systemRole);

@override
String toString() {
  return 'AiModelCapabilitiesDto(streaming: $streaming, visionInput: $visionInput, fileInput: $fileInput, reasoning: $reasoning, toolCalling: $toolCalling, parallelToolCalling: $parallelToolCalling, structuredOutput: $structuredOutput, systemRole: $systemRole)';
}


}

/// @nodoc
abstract mixin class $AiModelCapabilitiesDtoCopyWith<$Res>  {
  factory $AiModelCapabilitiesDtoCopyWith(AiModelCapabilitiesDto value, $Res Function(AiModelCapabilitiesDto) _then) = _$AiModelCapabilitiesDtoCopyWithImpl;
@useResult
$Res call({
 bool streaming, bool visionInput, bool fileInput, bool reasoning, bool toolCalling, bool parallelToolCalling, bool structuredOutput, bool systemRole
});




}
/// @nodoc
class _$AiModelCapabilitiesDtoCopyWithImpl<$Res>
    implements $AiModelCapabilitiesDtoCopyWith<$Res> {
  _$AiModelCapabilitiesDtoCopyWithImpl(this._self, this._then);

  final AiModelCapabilitiesDto _self;
  final $Res Function(AiModelCapabilitiesDto) _then;

/// Create a copy of AiModelCapabilitiesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streaming = null,Object? visionInput = null,Object? fileInput = null,Object? reasoning = null,Object? toolCalling = null,Object? parallelToolCalling = null,Object? structuredOutput = null,Object? systemRole = null,}) {
  return _then(_self.copyWith(
streaming: null == streaming ? _self.streaming : streaming // ignore: cast_nullable_to_non_nullable
as bool,visionInput: null == visionInput ? _self.visionInput : visionInput // ignore: cast_nullable_to_non_nullable
as bool,fileInput: null == fileInput ? _self.fileInput : fileInput // ignore: cast_nullable_to_non_nullable
as bool,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as bool,toolCalling: null == toolCalling ? _self.toolCalling : toolCalling // ignore: cast_nullable_to_non_nullable
as bool,parallelToolCalling: null == parallelToolCalling ? _self.parallelToolCalling : parallelToolCalling // ignore: cast_nullable_to_non_nullable
as bool,structuredOutput: null == structuredOutput ? _self.structuredOutput : structuredOutput // ignore: cast_nullable_to_non_nullable
as bool,systemRole: null == systemRole ? _self.systemRole : systemRole // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiModelCapabilitiesDto].
extension AiModelCapabilitiesDtoPatterns on AiModelCapabilitiesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModelCapabilitiesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModelCapabilitiesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModelCapabilitiesDto value)  $default,){
final _that = this;
switch (_that) {
case _AiModelCapabilitiesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModelCapabilitiesDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiModelCapabilitiesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool streaming,  bool visionInput,  bool fileInput,  bool reasoning,  bool toolCalling,  bool parallelToolCalling,  bool structuredOutput,  bool systemRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiModelCapabilitiesDto() when $default != null:
return $default(_that.streaming,_that.visionInput,_that.fileInput,_that.reasoning,_that.toolCalling,_that.parallelToolCalling,_that.structuredOutput,_that.systemRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool streaming,  bool visionInput,  bool fileInput,  bool reasoning,  bool toolCalling,  bool parallelToolCalling,  bool structuredOutput,  bool systemRole)  $default,) {final _that = this;
switch (_that) {
case _AiModelCapabilitiesDto():
return $default(_that.streaming,_that.visionInput,_that.fileInput,_that.reasoning,_that.toolCalling,_that.parallelToolCalling,_that.structuredOutput,_that.systemRole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool streaming,  bool visionInput,  bool fileInput,  bool reasoning,  bool toolCalling,  bool parallelToolCalling,  bool structuredOutput,  bool systemRole)?  $default,) {final _that = this;
switch (_that) {
case _AiModelCapabilitiesDto() when $default != null:
return $default(_that.streaming,_that.visionInput,_that.fileInput,_that.reasoning,_that.toolCalling,_that.parallelToolCalling,_that.structuredOutput,_that.systemRole);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiModelCapabilitiesDto extends AiModelCapabilitiesDto {
  const _AiModelCapabilitiesDto({this.streaming = false, this.visionInput = false, this.fileInput = false, this.reasoning = false, this.toolCalling = false, this.parallelToolCalling = false, this.structuredOutput = false, this.systemRole = true}): super._();
  factory _AiModelCapabilitiesDto.fromJson(Map<String, dynamic> json) => _$AiModelCapabilitiesDtoFromJson(json);

@override@JsonKey() final  bool streaming;
@override@JsonKey() final  bool visionInput;
@override@JsonKey() final  bool fileInput;
@override@JsonKey() final  bool reasoning;
@override@JsonKey() final  bool toolCalling;
@override@JsonKey() final  bool parallelToolCalling;
@override@JsonKey() final  bool structuredOutput;
@override@JsonKey() final  bool systemRole;

/// Create a copy of AiModelCapabilitiesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelCapabilitiesDtoCopyWith<_AiModelCapabilitiesDto> get copyWith => __$AiModelCapabilitiesDtoCopyWithImpl<_AiModelCapabilitiesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiModelCapabilitiesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModelCapabilitiesDto&&(identical(other.streaming, streaming) || other.streaming == streaming)&&(identical(other.visionInput, visionInput) || other.visionInput == visionInput)&&(identical(other.fileInput, fileInput) || other.fileInput == fileInput)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&(identical(other.toolCalling, toolCalling) || other.toolCalling == toolCalling)&&(identical(other.parallelToolCalling, parallelToolCalling) || other.parallelToolCalling == parallelToolCalling)&&(identical(other.structuredOutput, structuredOutput) || other.structuredOutput == structuredOutput)&&(identical(other.systemRole, systemRole) || other.systemRole == systemRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streaming,visionInput,fileInput,reasoning,toolCalling,parallelToolCalling,structuredOutput,systemRole);

@override
String toString() {
  return 'AiModelCapabilitiesDto(streaming: $streaming, visionInput: $visionInput, fileInput: $fileInput, reasoning: $reasoning, toolCalling: $toolCalling, parallelToolCalling: $parallelToolCalling, structuredOutput: $structuredOutput, systemRole: $systemRole)';
}


}

/// @nodoc
abstract mixin class _$AiModelCapabilitiesDtoCopyWith<$Res> implements $AiModelCapabilitiesDtoCopyWith<$Res> {
  factory _$AiModelCapabilitiesDtoCopyWith(_AiModelCapabilitiesDto value, $Res Function(_AiModelCapabilitiesDto) _then) = __$AiModelCapabilitiesDtoCopyWithImpl;
@override @useResult
$Res call({
 bool streaming, bool visionInput, bool fileInput, bool reasoning, bool toolCalling, bool parallelToolCalling, bool structuredOutput, bool systemRole
});




}
/// @nodoc
class __$AiModelCapabilitiesDtoCopyWithImpl<$Res>
    implements _$AiModelCapabilitiesDtoCopyWith<$Res> {
  __$AiModelCapabilitiesDtoCopyWithImpl(this._self, this._then);

  final _AiModelCapabilitiesDto _self;
  final $Res Function(_AiModelCapabilitiesDto) _then;

/// Create a copy of AiModelCapabilitiesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streaming = null,Object? visionInput = null,Object? fileInput = null,Object? reasoning = null,Object? toolCalling = null,Object? parallelToolCalling = null,Object? structuredOutput = null,Object? systemRole = null,}) {
  return _then(_AiModelCapabilitiesDto(
streaming: null == streaming ? _self.streaming : streaming // ignore: cast_nullable_to_non_nullable
as bool,visionInput: null == visionInput ? _self.visionInput : visionInput // ignore: cast_nullable_to_non_nullable
as bool,fileInput: null == fileInput ? _self.fileInput : fileInput // ignore: cast_nullable_to_non_nullable
as bool,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as bool,toolCalling: null == toolCalling ? _self.toolCalling : toolCalling // ignore: cast_nullable_to_non_nullable
as bool,parallelToolCalling: null == parallelToolCalling ? _self.parallelToolCalling : parallelToolCalling // ignore: cast_nullable_to_non_nullable
as bool,structuredOutput: null == structuredOutput ? _self.structuredOutput : structuredOutput // ignore: cast_nullable_to_non_nullable
as bool,systemRole: null == systemRole ? _self.systemRole : systemRole // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AiModelLimitsDto {

 int? get contextTokens; int? get maxOutputTokens; int? get maxImages; int? get maxTools; int? get maxToolResultBytes;
/// Create a copy of AiModelLimitsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelLimitsDtoCopyWith<AiModelLimitsDto> get copyWith => _$AiModelLimitsDtoCopyWithImpl<AiModelLimitsDto>(this as AiModelLimitsDto, _$identity);

  /// Serializes this AiModelLimitsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModelLimitsDto&&(identical(other.contextTokens, contextTokens) || other.contextTokens == contextTokens)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens)&&(identical(other.maxImages, maxImages) || other.maxImages == maxImages)&&(identical(other.maxTools, maxTools) || other.maxTools == maxTools)&&(identical(other.maxToolResultBytes, maxToolResultBytes) || other.maxToolResultBytes == maxToolResultBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contextTokens,maxOutputTokens,maxImages,maxTools,maxToolResultBytes);

@override
String toString() {
  return 'AiModelLimitsDto(contextTokens: $contextTokens, maxOutputTokens: $maxOutputTokens, maxImages: $maxImages, maxTools: $maxTools, maxToolResultBytes: $maxToolResultBytes)';
}


}

/// @nodoc
abstract mixin class $AiModelLimitsDtoCopyWith<$Res>  {
  factory $AiModelLimitsDtoCopyWith(AiModelLimitsDto value, $Res Function(AiModelLimitsDto) _then) = _$AiModelLimitsDtoCopyWithImpl;
@useResult
$Res call({
 int? contextTokens, int? maxOutputTokens, int? maxImages, int? maxTools, int? maxToolResultBytes
});




}
/// @nodoc
class _$AiModelLimitsDtoCopyWithImpl<$Res>
    implements $AiModelLimitsDtoCopyWith<$Res> {
  _$AiModelLimitsDtoCopyWithImpl(this._self, this._then);

  final AiModelLimitsDto _self;
  final $Res Function(AiModelLimitsDto) _then;

/// Create a copy of AiModelLimitsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contextTokens = freezed,Object? maxOutputTokens = freezed,Object? maxImages = freezed,Object? maxTools = freezed,Object? maxToolResultBytes = freezed,}) {
  return _then(_self.copyWith(
contextTokens: freezed == contextTokens ? _self.contextTokens : contextTokens // ignore: cast_nullable_to_non_nullable
as int?,maxOutputTokens: freezed == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int?,maxImages: freezed == maxImages ? _self.maxImages : maxImages // ignore: cast_nullable_to_non_nullable
as int?,maxTools: freezed == maxTools ? _self.maxTools : maxTools // ignore: cast_nullable_to_non_nullable
as int?,maxToolResultBytes: freezed == maxToolResultBytes ? _self.maxToolResultBytes : maxToolResultBytes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiModelLimitsDto].
extension AiModelLimitsDtoPatterns on AiModelLimitsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModelLimitsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModelLimitsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModelLimitsDto value)  $default,){
final _that = this;
switch (_that) {
case _AiModelLimitsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModelLimitsDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiModelLimitsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? contextTokens,  int? maxOutputTokens,  int? maxImages,  int? maxTools,  int? maxToolResultBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiModelLimitsDto() when $default != null:
return $default(_that.contextTokens,_that.maxOutputTokens,_that.maxImages,_that.maxTools,_that.maxToolResultBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? contextTokens,  int? maxOutputTokens,  int? maxImages,  int? maxTools,  int? maxToolResultBytes)  $default,) {final _that = this;
switch (_that) {
case _AiModelLimitsDto():
return $default(_that.contextTokens,_that.maxOutputTokens,_that.maxImages,_that.maxTools,_that.maxToolResultBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? contextTokens,  int? maxOutputTokens,  int? maxImages,  int? maxTools,  int? maxToolResultBytes)?  $default,) {final _that = this;
switch (_that) {
case _AiModelLimitsDto() when $default != null:
return $default(_that.contextTokens,_that.maxOutputTokens,_that.maxImages,_that.maxTools,_that.maxToolResultBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiModelLimitsDto extends AiModelLimitsDto {
  const _AiModelLimitsDto({this.contextTokens, this.maxOutputTokens, this.maxImages, this.maxTools, this.maxToolResultBytes}): super._();
  factory _AiModelLimitsDto.fromJson(Map<String, dynamic> json) => _$AiModelLimitsDtoFromJson(json);

@override final  int? contextTokens;
@override final  int? maxOutputTokens;
@override final  int? maxImages;
@override final  int? maxTools;
@override final  int? maxToolResultBytes;

/// Create a copy of AiModelLimitsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelLimitsDtoCopyWith<_AiModelLimitsDto> get copyWith => __$AiModelLimitsDtoCopyWithImpl<_AiModelLimitsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiModelLimitsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModelLimitsDto&&(identical(other.contextTokens, contextTokens) || other.contextTokens == contextTokens)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens)&&(identical(other.maxImages, maxImages) || other.maxImages == maxImages)&&(identical(other.maxTools, maxTools) || other.maxTools == maxTools)&&(identical(other.maxToolResultBytes, maxToolResultBytes) || other.maxToolResultBytes == maxToolResultBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contextTokens,maxOutputTokens,maxImages,maxTools,maxToolResultBytes);

@override
String toString() {
  return 'AiModelLimitsDto(contextTokens: $contextTokens, maxOutputTokens: $maxOutputTokens, maxImages: $maxImages, maxTools: $maxTools, maxToolResultBytes: $maxToolResultBytes)';
}


}

/// @nodoc
abstract mixin class _$AiModelLimitsDtoCopyWith<$Res> implements $AiModelLimitsDtoCopyWith<$Res> {
  factory _$AiModelLimitsDtoCopyWith(_AiModelLimitsDto value, $Res Function(_AiModelLimitsDto) _then) = __$AiModelLimitsDtoCopyWithImpl;
@override @useResult
$Res call({
 int? contextTokens, int? maxOutputTokens, int? maxImages, int? maxTools, int? maxToolResultBytes
});




}
/// @nodoc
class __$AiModelLimitsDtoCopyWithImpl<$Res>
    implements _$AiModelLimitsDtoCopyWith<$Res> {
  __$AiModelLimitsDtoCopyWithImpl(this._self, this._then);

  final _AiModelLimitsDto _self;
  final $Res Function(_AiModelLimitsDto) _then;

/// Create a copy of AiModelLimitsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contextTokens = freezed,Object? maxOutputTokens = freezed,Object? maxImages = freezed,Object? maxTools = freezed,Object? maxToolResultBytes = freezed,}) {
  return _then(_AiModelLimitsDto(
contextTokens: freezed == contextTokens ? _self.contextTokens : contextTokens // ignore: cast_nullable_to_non_nullable
as int?,maxOutputTokens: freezed == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int?,maxImages: freezed == maxImages ? _self.maxImages : maxImages // ignore: cast_nullable_to_non_nullable
as int?,maxTools: freezed == maxTools ? _self.maxTools : maxTools // ignore: cast_nullable_to_non_nullable
as int?,maxToolResultBytes: freezed == maxToolResultBytes ? _self.maxToolResultBytes : maxToolResultBytes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AiModelDefinitionDto {

 String get id; String get connectionId; String get displayName; AiModelCapabilitiesDto get capabilities; AiModelLimitsDto get limits; String get source;
/// Create a copy of AiModelDefinitionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelDefinitionDtoCopyWith<AiModelDefinitionDto> get copyWith => _$AiModelDefinitionDtoCopyWithImpl<AiModelDefinitionDto>(this as AiModelDefinitionDto, _$identity);

  /// Serializes this AiModelDefinitionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModelDefinitionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities)&&(identical(other.limits, limits) || other.limits == limits)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,connectionId,displayName,capabilities,limits,source);

@override
String toString() {
  return 'AiModelDefinitionDto(id: $id, connectionId: $connectionId, displayName: $displayName, capabilities: $capabilities, limits: $limits, source: $source)';
}


}

/// @nodoc
abstract mixin class $AiModelDefinitionDtoCopyWith<$Res>  {
  factory $AiModelDefinitionDtoCopyWith(AiModelDefinitionDto value, $Res Function(AiModelDefinitionDto) _then) = _$AiModelDefinitionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String connectionId, String displayName, AiModelCapabilitiesDto capabilities, AiModelLimitsDto limits, String source
});


$AiModelCapabilitiesDtoCopyWith<$Res> get capabilities;$AiModelLimitsDtoCopyWith<$Res> get limits;

}
/// @nodoc
class _$AiModelDefinitionDtoCopyWithImpl<$Res>
    implements $AiModelDefinitionDtoCopyWith<$Res> {
  _$AiModelDefinitionDtoCopyWithImpl(this._self, this._then);

  final AiModelDefinitionDto _self;
  final $Res Function(AiModelDefinitionDto) _then;

/// Create a copy of AiModelDefinitionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? connectionId = null,Object? displayName = null,Object? capabilities = null,Object? limits = null,Object? source = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as AiModelCapabilitiesDto,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as AiModelLimitsDto,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AiModelDefinitionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelCapabilitiesDtoCopyWith<$Res> get capabilities {
  
  return $AiModelCapabilitiesDtoCopyWith<$Res>(_self.capabilities, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}/// Create a copy of AiModelDefinitionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelLimitsDtoCopyWith<$Res> get limits {
  
  return $AiModelLimitsDtoCopyWith<$Res>(_self.limits, (value) {
    return _then(_self.copyWith(limits: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiModelDefinitionDto].
extension AiModelDefinitionDtoPatterns on AiModelDefinitionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModelDefinitionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModelDefinitionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModelDefinitionDto value)  $default,){
final _that = this;
switch (_that) {
case _AiModelDefinitionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModelDefinitionDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiModelDefinitionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String connectionId,  String displayName,  AiModelCapabilitiesDto capabilities,  AiModelLimitsDto limits,  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiModelDefinitionDto() when $default != null:
return $default(_that.id,_that.connectionId,_that.displayName,_that.capabilities,_that.limits,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String connectionId,  String displayName,  AiModelCapabilitiesDto capabilities,  AiModelLimitsDto limits,  String source)  $default,) {final _that = this;
switch (_that) {
case _AiModelDefinitionDto():
return $default(_that.id,_that.connectionId,_that.displayName,_that.capabilities,_that.limits,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String connectionId,  String displayName,  AiModelCapabilitiesDto capabilities,  AiModelLimitsDto limits,  String source)?  $default,) {final _that = this;
switch (_that) {
case _AiModelDefinitionDto() when $default != null:
return $default(_that.id,_that.connectionId,_that.displayName,_that.capabilities,_that.limits,_that.source);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiModelDefinitionDto extends AiModelDefinitionDto {
  const _AiModelDefinitionDto({required this.id, required this.connectionId, required this.displayName, this.capabilities = const AiModelCapabilitiesDto(), this.limits = const AiModelLimitsDto(), this.source = 'discovered'}): super._();
  factory _AiModelDefinitionDto.fromJson(Map<String, dynamic> json) => _$AiModelDefinitionDtoFromJson(json);

@override final  String id;
@override final  String connectionId;
@override final  String displayName;
@override@JsonKey() final  AiModelCapabilitiesDto capabilities;
@override@JsonKey() final  AiModelLimitsDto limits;
@override@JsonKey() final  String source;

/// Create a copy of AiModelDefinitionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelDefinitionDtoCopyWith<_AiModelDefinitionDto> get copyWith => __$AiModelDefinitionDtoCopyWithImpl<_AiModelDefinitionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiModelDefinitionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModelDefinitionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities)&&(identical(other.limits, limits) || other.limits == limits)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,connectionId,displayName,capabilities,limits,source);

@override
String toString() {
  return 'AiModelDefinitionDto(id: $id, connectionId: $connectionId, displayName: $displayName, capabilities: $capabilities, limits: $limits, source: $source)';
}


}

/// @nodoc
abstract mixin class _$AiModelDefinitionDtoCopyWith<$Res> implements $AiModelDefinitionDtoCopyWith<$Res> {
  factory _$AiModelDefinitionDtoCopyWith(_AiModelDefinitionDto value, $Res Function(_AiModelDefinitionDto) _then) = __$AiModelDefinitionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String connectionId, String displayName, AiModelCapabilitiesDto capabilities, AiModelLimitsDto limits, String source
});


@override $AiModelCapabilitiesDtoCopyWith<$Res> get capabilities;@override $AiModelLimitsDtoCopyWith<$Res> get limits;

}
/// @nodoc
class __$AiModelDefinitionDtoCopyWithImpl<$Res>
    implements _$AiModelDefinitionDtoCopyWith<$Res> {
  __$AiModelDefinitionDtoCopyWithImpl(this._self, this._then);

  final _AiModelDefinitionDto _self;
  final $Res Function(_AiModelDefinitionDto) _then;

/// Create a copy of AiModelDefinitionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? connectionId = null,Object? displayName = null,Object? capabilities = null,Object? limits = null,Object? source = null,}) {
  return _then(_AiModelDefinitionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as AiModelCapabilitiesDto,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as AiModelLimitsDto,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AiModelDefinitionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelCapabilitiesDtoCopyWith<$Res> get capabilities {
  
  return $AiModelCapabilitiesDtoCopyWith<$Res>(_self.capabilities, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}/// Create a copy of AiModelDefinitionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelLimitsDtoCopyWith<$Res> get limits {
  
  return $AiModelLimitsDtoCopyWith<$Res>(_self.limits, (value) {
    return _then(_self.copyWith(limits: value));
  });
}
}

// dart format on
