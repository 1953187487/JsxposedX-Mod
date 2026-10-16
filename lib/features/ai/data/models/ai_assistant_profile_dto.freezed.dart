// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_assistant_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiGenerationOptionsDto {

 int? get maxOutputTokens; double? get temperature; double? get topP; double? get presencePenalty; double? get frequencyPenalty; String? get reasoningEffort; bool get stream;
/// Create a copy of AiGenerationOptionsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiGenerationOptionsDtoCopyWith<AiGenerationOptionsDto> get copyWith => _$AiGenerationOptionsDtoCopyWithImpl<AiGenerationOptionsDto>(this as AiGenerationOptionsDto, _$identity);

  /// Serializes this AiGenerationOptionsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiGenerationOptionsDto&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.topP, topP) || other.topP == topP)&&(identical(other.presencePenalty, presencePenalty) || other.presencePenalty == presencePenalty)&&(identical(other.frequencyPenalty, frequencyPenalty) || other.frequencyPenalty == frequencyPenalty)&&(identical(other.reasoningEffort, reasoningEffort) || other.reasoningEffort == reasoningEffort)&&(identical(other.stream, stream) || other.stream == stream));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxOutputTokens,temperature,topP,presencePenalty,frequencyPenalty,reasoningEffort,stream);

@override
String toString() {
  return 'AiGenerationOptionsDto(maxOutputTokens: $maxOutputTokens, temperature: $temperature, topP: $topP, presencePenalty: $presencePenalty, frequencyPenalty: $frequencyPenalty, reasoningEffort: $reasoningEffort, stream: $stream)';
}


}

/// @nodoc
abstract mixin class $AiGenerationOptionsDtoCopyWith<$Res>  {
  factory $AiGenerationOptionsDtoCopyWith(AiGenerationOptionsDto value, $Res Function(AiGenerationOptionsDto) _then) = _$AiGenerationOptionsDtoCopyWithImpl;
@useResult
$Res call({
 int? maxOutputTokens, double? temperature, double? topP, double? presencePenalty, double? frequencyPenalty, String? reasoningEffort, bool stream
});




}
/// @nodoc
class _$AiGenerationOptionsDtoCopyWithImpl<$Res>
    implements $AiGenerationOptionsDtoCopyWith<$Res> {
  _$AiGenerationOptionsDtoCopyWithImpl(this._self, this._then);

  final AiGenerationOptionsDto _self;
  final $Res Function(AiGenerationOptionsDto) _then;

/// Create a copy of AiGenerationOptionsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxOutputTokens = freezed,Object? temperature = freezed,Object? topP = freezed,Object? presencePenalty = freezed,Object? frequencyPenalty = freezed,Object? reasoningEffort = freezed,Object? stream = null,}) {
  return _then(_self.copyWith(
maxOutputTokens: freezed == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,topP: freezed == topP ? _self.topP : topP // ignore: cast_nullable_to_non_nullable
as double?,presencePenalty: freezed == presencePenalty ? _self.presencePenalty : presencePenalty // ignore: cast_nullable_to_non_nullable
as double?,frequencyPenalty: freezed == frequencyPenalty ? _self.frequencyPenalty : frequencyPenalty // ignore: cast_nullable_to_non_nullable
as double?,reasoningEffort: freezed == reasoningEffort ? _self.reasoningEffort : reasoningEffort // ignore: cast_nullable_to_non_nullable
as String?,stream: null == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiGenerationOptionsDto].
extension AiGenerationOptionsDtoPatterns on AiGenerationOptionsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiGenerationOptionsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiGenerationOptionsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiGenerationOptionsDto value)  $default,){
final _that = this;
switch (_that) {
case _AiGenerationOptionsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiGenerationOptionsDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiGenerationOptionsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? maxOutputTokens,  double? temperature,  double? topP,  double? presencePenalty,  double? frequencyPenalty,  String? reasoningEffort,  bool stream)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiGenerationOptionsDto() when $default != null:
return $default(_that.maxOutputTokens,_that.temperature,_that.topP,_that.presencePenalty,_that.frequencyPenalty,_that.reasoningEffort,_that.stream);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? maxOutputTokens,  double? temperature,  double? topP,  double? presencePenalty,  double? frequencyPenalty,  String? reasoningEffort,  bool stream)  $default,) {final _that = this;
switch (_that) {
case _AiGenerationOptionsDto():
return $default(_that.maxOutputTokens,_that.temperature,_that.topP,_that.presencePenalty,_that.frequencyPenalty,_that.reasoningEffort,_that.stream);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? maxOutputTokens,  double? temperature,  double? topP,  double? presencePenalty,  double? frequencyPenalty,  String? reasoningEffort,  bool stream)?  $default,) {final _that = this;
switch (_that) {
case _AiGenerationOptionsDto() when $default != null:
return $default(_that.maxOutputTokens,_that.temperature,_that.topP,_that.presencePenalty,_that.frequencyPenalty,_that.reasoningEffort,_that.stream);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiGenerationOptionsDto extends AiGenerationOptionsDto {
  const _AiGenerationOptionsDto({this.maxOutputTokens, this.temperature, this.topP, this.presencePenalty, this.frequencyPenalty, this.reasoningEffort, this.stream = true}): super._();
  factory _AiGenerationOptionsDto.fromJson(Map<String, dynamic> json) => _$AiGenerationOptionsDtoFromJson(json);

@override final  int? maxOutputTokens;
@override final  double? temperature;
@override final  double? topP;
@override final  double? presencePenalty;
@override final  double? frequencyPenalty;
@override final  String? reasoningEffort;
@override@JsonKey() final  bool stream;

/// Create a copy of AiGenerationOptionsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiGenerationOptionsDtoCopyWith<_AiGenerationOptionsDto> get copyWith => __$AiGenerationOptionsDtoCopyWithImpl<_AiGenerationOptionsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiGenerationOptionsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiGenerationOptionsDto&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.topP, topP) || other.topP == topP)&&(identical(other.presencePenalty, presencePenalty) || other.presencePenalty == presencePenalty)&&(identical(other.frequencyPenalty, frequencyPenalty) || other.frequencyPenalty == frequencyPenalty)&&(identical(other.reasoningEffort, reasoningEffort) || other.reasoningEffort == reasoningEffort)&&(identical(other.stream, stream) || other.stream == stream));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxOutputTokens,temperature,topP,presencePenalty,frequencyPenalty,reasoningEffort,stream);

@override
String toString() {
  return 'AiGenerationOptionsDto(maxOutputTokens: $maxOutputTokens, temperature: $temperature, topP: $topP, presencePenalty: $presencePenalty, frequencyPenalty: $frequencyPenalty, reasoningEffort: $reasoningEffort, stream: $stream)';
}


}

/// @nodoc
abstract mixin class _$AiGenerationOptionsDtoCopyWith<$Res> implements $AiGenerationOptionsDtoCopyWith<$Res> {
  factory _$AiGenerationOptionsDtoCopyWith(_AiGenerationOptionsDto value, $Res Function(_AiGenerationOptionsDto) _then) = __$AiGenerationOptionsDtoCopyWithImpl;
@override @useResult
$Res call({
 int? maxOutputTokens, double? temperature, double? topP, double? presencePenalty, double? frequencyPenalty, String? reasoningEffort, bool stream
});




}
/// @nodoc
class __$AiGenerationOptionsDtoCopyWithImpl<$Res>
    implements _$AiGenerationOptionsDtoCopyWith<$Res> {
  __$AiGenerationOptionsDtoCopyWithImpl(this._self, this._then);

  final _AiGenerationOptionsDto _self;
  final $Res Function(_AiGenerationOptionsDto) _then;

/// Create a copy of AiGenerationOptionsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxOutputTokens = freezed,Object? temperature = freezed,Object? topP = freezed,Object? presencePenalty = freezed,Object? frequencyPenalty = freezed,Object? reasoningEffort = freezed,Object? stream = null,}) {
  return _then(_AiGenerationOptionsDto(
maxOutputTokens: freezed == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,topP: freezed == topP ? _self.topP : topP // ignore: cast_nullable_to_non_nullable
as double?,presencePenalty: freezed == presencePenalty ? _self.presencePenalty : presencePenalty // ignore: cast_nullable_to_non_nullable
as double?,frequencyPenalty: freezed == frequencyPenalty ? _self.frequencyPenalty : frequencyPenalty // ignore: cast_nullable_to_non_nullable
as double?,reasoningEffort: freezed == reasoningEffort ? _self.reasoningEffort : reasoningEffort // ignore: cast_nullable_to_non_nullable
as String?,stream: null == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AiContextPolicyDto {

 String get mode; int get reservedOutputTokens; int get recentMessageMinimum; int? get recentMessageLimit; bool get includeToolResults; bool get enableSummarization; int get fallbackContextTokens;
/// Create a copy of AiContextPolicyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiContextPolicyDtoCopyWith<AiContextPolicyDto> get copyWith => _$AiContextPolicyDtoCopyWithImpl<AiContextPolicyDto>(this as AiContextPolicyDto, _$identity);

  /// Serializes this AiContextPolicyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiContextPolicyDto&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reservedOutputTokens, reservedOutputTokens) || other.reservedOutputTokens == reservedOutputTokens)&&(identical(other.recentMessageMinimum, recentMessageMinimum) || other.recentMessageMinimum == recentMessageMinimum)&&(identical(other.recentMessageLimit, recentMessageLimit) || other.recentMessageLimit == recentMessageLimit)&&(identical(other.includeToolResults, includeToolResults) || other.includeToolResults == includeToolResults)&&(identical(other.enableSummarization, enableSummarization) || other.enableSummarization == enableSummarization)&&(identical(other.fallbackContextTokens, fallbackContextTokens) || other.fallbackContextTokens == fallbackContextTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,reservedOutputTokens,recentMessageMinimum,recentMessageLimit,includeToolResults,enableSummarization,fallbackContextTokens);

@override
String toString() {
  return 'AiContextPolicyDto(mode: $mode, reservedOutputTokens: $reservedOutputTokens, recentMessageMinimum: $recentMessageMinimum, recentMessageLimit: $recentMessageLimit, includeToolResults: $includeToolResults, enableSummarization: $enableSummarization, fallbackContextTokens: $fallbackContextTokens)';
}


}

/// @nodoc
abstract mixin class $AiContextPolicyDtoCopyWith<$Res>  {
  factory $AiContextPolicyDtoCopyWith(AiContextPolicyDto value, $Res Function(AiContextPolicyDto) _then) = _$AiContextPolicyDtoCopyWithImpl;
@useResult
$Res call({
 String mode, int reservedOutputTokens, int recentMessageMinimum, int? recentMessageLimit, bool includeToolResults, bool enableSummarization, int fallbackContextTokens
});




}
/// @nodoc
class _$AiContextPolicyDtoCopyWithImpl<$Res>
    implements $AiContextPolicyDtoCopyWith<$Res> {
  _$AiContextPolicyDtoCopyWithImpl(this._self, this._then);

  final AiContextPolicyDto _self;
  final $Res Function(AiContextPolicyDto) _then;

/// Create a copy of AiContextPolicyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? reservedOutputTokens = null,Object? recentMessageMinimum = null,Object? recentMessageLimit = freezed,Object? includeToolResults = null,Object? enableSummarization = null,Object? fallbackContextTokens = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,reservedOutputTokens: null == reservedOutputTokens ? _self.reservedOutputTokens : reservedOutputTokens // ignore: cast_nullable_to_non_nullable
as int,recentMessageMinimum: null == recentMessageMinimum ? _self.recentMessageMinimum : recentMessageMinimum // ignore: cast_nullable_to_non_nullable
as int,recentMessageLimit: freezed == recentMessageLimit ? _self.recentMessageLimit : recentMessageLimit // ignore: cast_nullable_to_non_nullable
as int?,includeToolResults: null == includeToolResults ? _self.includeToolResults : includeToolResults // ignore: cast_nullable_to_non_nullable
as bool,enableSummarization: null == enableSummarization ? _self.enableSummarization : enableSummarization // ignore: cast_nullable_to_non_nullable
as bool,fallbackContextTokens: null == fallbackContextTokens ? _self.fallbackContextTokens : fallbackContextTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiContextPolicyDto].
extension AiContextPolicyDtoPatterns on AiContextPolicyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiContextPolicyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiContextPolicyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiContextPolicyDto value)  $default,){
final _that = this;
switch (_that) {
case _AiContextPolicyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiContextPolicyDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiContextPolicyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mode,  int reservedOutputTokens,  int recentMessageMinimum,  int? recentMessageLimit,  bool includeToolResults,  bool enableSummarization,  int fallbackContextTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiContextPolicyDto() when $default != null:
return $default(_that.mode,_that.reservedOutputTokens,_that.recentMessageMinimum,_that.recentMessageLimit,_that.includeToolResults,_that.enableSummarization,_that.fallbackContextTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mode,  int reservedOutputTokens,  int recentMessageMinimum,  int? recentMessageLimit,  bool includeToolResults,  bool enableSummarization,  int fallbackContextTokens)  $default,) {final _that = this;
switch (_that) {
case _AiContextPolicyDto():
return $default(_that.mode,_that.reservedOutputTokens,_that.recentMessageMinimum,_that.recentMessageLimit,_that.includeToolResults,_that.enableSummarization,_that.fallbackContextTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mode,  int reservedOutputTokens,  int recentMessageMinimum,  int? recentMessageLimit,  bool includeToolResults,  bool enableSummarization,  int fallbackContextTokens)?  $default,) {final _that = this;
switch (_that) {
case _AiContextPolicyDto() when $default != null:
return $default(_that.mode,_that.reservedOutputTokens,_that.recentMessageMinimum,_that.recentMessageLimit,_that.includeToolResults,_that.enableSummarization,_that.fallbackContextTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiContextPolicyDto extends AiContextPolicyDto {
  const _AiContextPolicyDto({this.mode = 'tokenBudget', this.reservedOutputTokens = 1024, this.recentMessageMinimum = 4, this.recentMessageLimit, this.includeToolResults = true, this.enableSummarization = false, this.fallbackContextTokens = kDefaultFallbackContextTokens}): super._();
  factory _AiContextPolicyDto.fromJson(Map<String, dynamic> json) => _$AiContextPolicyDtoFromJson(json);

@override@JsonKey() final  String mode;
@override@JsonKey() final  int reservedOutputTokens;
@override@JsonKey() final  int recentMessageMinimum;
@override final  int? recentMessageLimit;
@override@JsonKey() final  bool includeToolResults;
@override@JsonKey() final  bool enableSummarization;
@override@JsonKey() final  int fallbackContextTokens;

/// Create a copy of AiContextPolicyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiContextPolicyDtoCopyWith<_AiContextPolicyDto> get copyWith => __$AiContextPolicyDtoCopyWithImpl<_AiContextPolicyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiContextPolicyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiContextPolicyDto&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reservedOutputTokens, reservedOutputTokens) || other.reservedOutputTokens == reservedOutputTokens)&&(identical(other.recentMessageMinimum, recentMessageMinimum) || other.recentMessageMinimum == recentMessageMinimum)&&(identical(other.recentMessageLimit, recentMessageLimit) || other.recentMessageLimit == recentMessageLimit)&&(identical(other.includeToolResults, includeToolResults) || other.includeToolResults == includeToolResults)&&(identical(other.enableSummarization, enableSummarization) || other.enableSummarization == enableSummarization)&&(identical(other.fallbackContextTokens, fallbackContextTokens) || other.fallbackContextTokens == fallbackContextTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,reservedOutputTokens,recentMessageMinimum,recentMessageLimit,includeToolResults,enableSummarization,fallbackContextTokens);

@override
String toString() {
  return 'AiContextPolicyDto(mode: $mode, reservedOutputTokens: $reservedOutputTokens, recentMessageMinimum: $recentMessageMinimum, recentMessageLimit: $recentMessageLimit, includeToolResults: $includeToolResults, enableSummarization: $enableSummarization, fallbackContextTokens: $fallbackContextTokens)';
}


}

/// @nodoc
abstract mixin class _$AiContextPolicyDtoCopyWith<$Res> implements $AiContextPolicyDtoCopyWith<$Res> {
  factory _$AiContextPolicyDtoCopyWith(_AiContextPolicyDto value, $Res Function(_AiContextPolicyDto) _then) = __$AiContextPolicyDtoCopyWithImpl;
@override @useResult
$Res call({
 String mode, int reservedOutputTokens, int recentMessageMinimum, int? recentMessageLimit, bool includeToolResults, bool enableSummarization, int fallbackContextTokens
});




}
/// @nodoc
class __$AiContextPolicyDtoCopyWithImpl<$Res>
    implements _$AiContextPolicyDtoCopyWith<$Res> {
  __$AiContextPolicyDtoCopyWithImpl(this._self, this._then);

  final _AiContextPolicyDto _self;
  final $Res Function(_AiContextPolicyDto) _then;

/// Create a copy of AiContextPolicyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? reservedOutputTokens = null,Object? recentMessageMinimum = null,Object? recentMessageLimit = freezed,Object? includeToolResults = null,Object? enableSummarization = null,Object? fallbackContextTokens = null,}) {
  return _then(_AiContextPolicyDto(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,reservedOutputTokens: null == reservedOutputTokens ? _self.reservedOutputTokens : reservedOutputTokens // ignore: cast_nullable_to_non_nullable
as int,recentMessageMinimum: null == recentMessageMinimum ? _self.recentMessageMinimum : recentMessageMinimum // ignore: cast_nullable_to_non_nullable
as int,recentMessageLimit: freezed == recentMessageLimit ? _self.recentMessageLimit : recentMessageLimit // ignore: cast_nullable_to_non_nullable
as int?,includeToolResults: null == includeToolResults ? _self.includeToolResults : includeToolResults // ignore: cast_nullable_to_non_nullable
as bool,enableSummarization: null == enableSummarization ? _self.enableSummarization : enableSummarization // ignore: cast_nullable_to_non_nullable
as bool,fallbackContextTokens: null == fallbackContextTokens ? _self.fallbackContextTokens : fallbackContextTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AiToolPolicyDto {

 String get approvalMode; int get maxRounds; int get maxResultBytes;
/// Create a copy of AiToolPolicyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolPolicyDtoCopyWith<AiToolPolicyDto> get copyWith => _$AiToolPolicyDtoCopyWithImpl<AiToolPolicyDto>(this as AiToolPolicyDto, _$identity);

  /// Serializes this AiToolPolicyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolPolicyDto&&(identical(other.approvalMode, approvalMode) || other.approvalMode == approvalMode)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.maxResultBytes, maxResultBytes) || other.maxResultBytes == maxResultBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,approvalMode,maxRounds,maxResultBytes);

@override
String toString() {
  return 'AiToolPolicyDto(approvalMode: $approvalMode, maxRounds: $maxRounds, maxResultBytes: $maxResultBytes)';
}


}

/// @nodoc
abstract mixin class $AiToolPolicyDtoCopyWith<$Res>  {
  factory $AiToolPolicyDtoCopyWith(AiToolPolicyDto value, $Res Function(AiToolPolicyDto) _then) = _$AiToolPolicyDtoCopyWithImpl;
@useResult
$Res call({
 String approvalMode, int maxRounds, int maxResultBytes
});




}
/// @nodoc
class _$AiToolPolicyDtoCopyWithImpl<$Res>
    implements $AiToolPolicyDtoCopyWith<$Res> {
  _$AiToolPolicyDtoCopyWithImpl(this._self, this._then);

  final AiToolPolicyDto _self;
  final $Res Function(AiToolPolicyDto) _then;

/// Create a copy of AiToolPolicyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? approvalMode = null,Object? maxRounds = null,Object? maxResultBytes = null,}) {
  return _then(_self.copyWith(
approvalMode: null == approvalMode ? _self.approvalMode : approvalMode // ignore: cast_nullable_to_non_nullable
as String,maxRounds: null == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int,maxResultBytes: null == maxResultBytes ? _self.maxResultBytes : maxResultBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiToolPolicyDto].
extension AiToolPolicyDtoPatterns on AiToolPolicyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiToolPolicyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiToolPolicyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiToolPolicyDto value)  $default,){
final _that = this;
switch (_that) {
case _AiToolPolicyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiToolPolicyDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiToolPolicyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String approvalMode,  int maxRounds,  int maxResultBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiToolPolicyDto() when $default != null:
return $default(_that.approvalMode,_that.maxRounds,_that.maxResultBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String approvalMode,  int maxRounds,  int maxResultBytes)  $default,) {final _that = this;
switch (_that) {
case _AiToolPolicyDto():
return $default(_that.approvalMode,_that.maxRounds,_that.maxResultBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String approvalMode,  int maxRounds,  int maxResultBytes)?  $default,) {final _that = this;
switch (_that) {
case _AiToolPolicyDto() when $default != null:
return $default(_that.approvalMode,_that.maxRounds,_that.maxResultBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiToolPolicyDto extends AiToolPolicyDto {
  const _AiToolPolicyDto({this.approvalMode = 'riskyOnly', this.maxRounds = kDefaultMaxToolRounds, this.maxResultBytes = 1024 * 1024}): super._();
  factory _AiToolPolicyDto.fromJson(Map<String, dynamic> json) => _$AiToolPolicyDtoFromJson(json);

@override@JsonKey() final  String approvalMode;
@override@JsonKey() final  int maxRounds;
@override@JsonKey() final  int maxResultBytes;

/// Create a copy of AiToolPolicyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiToolPolicyDtoCopyWith<_AiToolPolicyDto> get copyWith => __$AiToolPolicyDtoCopyWithImpl<_AiToolPolicyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiToolPolicyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiToolPolicyDto&&(identical(other.approvalMode, approvalMode) || other.approvalMode == approvalMode)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.maxResultBytes, maxResultBytes) || other.maxResultBytes == maxResultBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,approvalMode,maxRounds,maxResultBytes);

@override
String toString() {
  return 'AiToolPolicyDto(approvalMode: $approvalMode, maxRounds: $maxRounds, maxResultBytes: $maxResultBytes)';
}


}

/// @nodoc
abstract mixin class _$AiToolPolicyDtoCopyWith<$Res> implements $AiToolPolicyDtoCopyWith<$Res> {
  factory _$AiToolPolicyDtoCopyWith(_AiToolPolicyDto value, $Res Function(_AiToolPolicyDto) _then) = __$AiToolPolicyDtoCopyWithImpl;
@override @useResult
$Res call({
 String approvalMode, int maxRounds, int maxResultBytes
});




}
/// @nodoc
class __$AiToolPolicyDtoCopyWithImpl<$Res>
    implements _$AiToolPolicyDtoCopyWith<$Res> {
  __$AiToolPolicyDtoCopyWithImpl(this._self, this._then);

  final _AiToolPolicyDto _self;
  final $Res Function(_AiToolPolicyDto) _then;

/// Create a copy of AiToolPolicyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? approvalMode = null,Object? maxRounds = null,Object? maxResultBytes = null,}) {
  return _then(_AiToolPolicyDto(
approvalMode: null == approvalMode ? _self.approvalMode : approvalMode // ignore: cast_nullable_to_non_nullable
as String,maxRounds: null == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int,maxResultBytes: null == maxResultBytes ? _self.maxResultBytes : maxResultBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AiAssistantProfileDto {

 String get id; String get name; String get connectionId; String get modelId; String? get systemPrompt; AiGenerationOptionsDto get generation; AiContextPolicyDto get contextPolicy; AiToolPolicyDto get toolPolicy; String get createdAt; String get updatedAt;
/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiAssistantProfileDtoCopyWith<AiAssistantProfileDto> get copyWith => _$AiAssistantProfileDtoCopyWithImpl<AiAssistantProfileDto>(this as AiAssistantProfileDto, _$identity);

  /// Serializes this AiAssistantProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiAssistantProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.contextPolicy, contextPolicy) || other.contextPolicy == contextPolicy)&&(identical(other.toolPolicy, toolPolicy) || other.toolPolicy == toolPolicy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,connectionId,modelId,systemPrompt,generation,contextPolicy,toolPolicy,createdAt,updatedAt);

@override
String toString() {
  return 'AiAssistantProfileDto(id: $id, name: $name, connectionId: $connectionId, modelId: $modelId, systemPrompt: $systemPrompt, generation: $generation, contextPolicy: $contextPolicy, toolPolicy: $toolPolicy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AiAssistantProfileDtoCopyWith<$Res>  {
  factory $AiAssistantProfileDtoCopyWith(AiAssistantProfileDto value, $Res Function(AiAssistantProfileDto) _then) = _$AiAssistantProfileDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String connectionId, String modelId, String? systemPrompt, AiGenerationOptionsDto generation, AiContextPolicyDto contextPolicy, AiToolPolicyDto toolPolicy, String createdAt, String updatedAt
});


$AiGenerationOptionsDtoCopyWith<$Res> get generation;$AiContextPolicyDtoCopyWith<$Res> get contextPolicy;$AiToolPolicyDtoCopyWith<$Res> get toolPolicy;

}
/// @nodoc
class _$AiAssistantProfileDtoCopyWithImpl<$Res>
    implements $AiAssistantProfileDtoCopyWith<$Res> {
  _$AiAssistantProfileDtoCopyWithImpl(this._self, this._then);

  final AiAssistantProfileDto _self;
  final $Res Function(AiAssistantProfileDto) _then;

/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? connectionId = null,Object? modelId = null,Object? systemPrompt = freezed,Object? generation = null,Object? contextPolicy = null,Object? toolPolicy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: freezed == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as AiGenerationOptionsDto,contextPolicy: null == contextPolicy ? _self.contextPolicy : contextPolicy // ignore: cast_nullable_to_non_nullable
as AiContextPolicyDto,toolPolicy: null == toolPolicy ? _self.toolPolicy : toolPolicy // ignore: cast_nullable_to_non_nullable
as AiToolPolicyDto,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiGenerationOptionsDtoCopyWith<$Res> get generation {
  
  return $AiGenerationOptionsDtoCopyWith<$Res>(_self.generation, (value) {
    return _then(_self.copyWith(generation: value));
  });
}/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiContextPolicyDtoCopyWith<$Res> get contextPolicy {
  
  return $AiContextPolicyDtoCopyWith<$Res>(_self.contextPolicy, (value) {
    return _then(_self.copyWith(contextPolicy: value));
  });
}/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiToolPolicyDtoCopyWith<$Res> get toolPolicy {
  
  return $AiToolPolicyDtoCopyWith<$Res>(_self.toolPolicy, (value) {
    return _then(_self.copyWith(toolPolicy: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiAssistantProfileDto].
extension AiAssistantProfileDtoPatterns on AiAssistantProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiAssistantProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiAssistantProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiAssistantProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _AiAssistantProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiAssistantProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiAssistantProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String connectionId,  String modelId,  String? systemPrompt,  AiGenerationOptionsDto generation,  AiContextPolicyDto contextPolicy,  AiToolPolicyDto toolPolicy,  String createdAt,  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiAssistantProfileDto() when $default != null:
return $default(_that.id,_that.name,_that.connectionId,_that.modelId,_that.systemPrompt,_that.generation,_that.contextPolicy,_that.toolPolicy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String connectionId,  String modelId,  String? systemPrompt,  AiGenerationOptionsDto generation,  AiContextPolicyDto contextPolicy,  AiToolPolicyDto toolPolicy,  String createdAt,  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AiAssistantProfileDto():
return $default(_that.id,_that.name,_that.connectionId,_that.modelId,_that.systemPrompt,_that.generation,_that.contextPolicy,_that.toolPolicy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String connectionId,  String modelId,  String? systemPrompt,  AiGenerationOptionsDto generation,  AiContextPolicyDto contextPolicy,  AiToolPolicyDto toolPolicy,  String createdAt,  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiAssistantProfileDto() when $default != null:
return $default(_that.id,_that.name,_that.connectionId,_that.modelId,_that.systemPrompt,_that.generation,_that.contextPolicy,_that.toolPolicy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiAssistantProfileDto extends AiAssistantProfileDto {
  const _AiAssistantProfileDto({required this.id, required this.name, required this.connectionId, required this.modelId, this.systemPrompt, this.generation = const AiGenerationOptionsDto(), this.contextPolicy = const AiContextPolicyDto(), this.toolPolicy = const AiToolPolicyDto(), required this.createdAt, required this.updatedAt}): super._();
  factory _AiAssistantProfileDto.fromJson(Map<String, dynamic> json) => _$AiAssistantProfileDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String connectionId;
@override final  String modelId;
@override final  String? systemPrompt;
@override@JsonKey() final  AiGenerationOptionsDto generation;
@override@JsonKey() final  AiContextPolicyDto contextPolicy;
@override@JsonKey() final  AiToolPolicyDto toolPolicy;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiAssistantProfileDtoCopyWith<_AiAssistantProfileDto> get copyWith => __$AiAssistantProfileDtoCopyWithImpl<_AiAssistantProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiAssistantProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiAssistantProfileDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.contextPolicy, contextPolicy) || other.contextPolicy == contextPolicy)&&(identical(other.toolPolicy, toolPolicy) || other.toolPolicy == toolPolicy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,connectionId,modelId,systemPrompt,generation,contextPolicy,toolPolicy,createdAt,updatedAt);

@override
String toString() {
  return 'AiAssistantProfileDto(id: $id, name: $name, connectionId: $connectionId, modelId: $modelId, systemPrompt: $systemPrompt, generation: $generation, contextPolicy: $contextPolicy, toolPolicy: $toolPolicy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AiAssistantProfileDtoCopyWith<$Res> implements $AiAssistantProfileDtoCopyWith<$Res> {
  factory _$AiAssistantProfileDtoCopyWith(_AiAssistantProfileDto value, $Res Function(_AiAssistantProfileDto) _then) = __$AiAssistantProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String connectionId, String modelId, String? systemPrompt, AiGenerationOptionsDto generation, AiContextPolicyDto contextPolicy, AiToolPolicyDto toolPolicy, String createdAt, String updatedAt
});


@override $AiGenerationOptionsDtoCopyWith<$Res> get generation;@override $AiContextPolicyDtoCopyWith<$Res> get contextPolicy;@override $AiToolPolicyDtoCopyWith<$Res> get toolPolicy;

}
/// @nodoc
class __$AiAssistantProfileDtoCopyWithImpl<$Res>
    implements _$AiAssistantProfileDtoCopyWith<$Res> {
  __$AiAssistantProfileDtoCopyWithImpl(this._self, this._then);

  final _AiAssistantProfileDto _self;
  final $Res Function(_AiAssistantProfileDto) _then;

/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? connectionId = null,Object? modelId = null,Object? systemPrompt = freezed,Object? generation = null,Object? contextPolicy = null,Object? toolPolicy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AiAssistantProfileDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: freezed == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as AiGenerationOptionsDto,contextPolicy: null == contextPolicy ? _self.contextPolicy : contextPolicy // ignore: cast_nullable_to_non_nullable
as AiContextPolicyDto,toolPolicy: null == toolPolicy ? _self.toolPolicy : toolPolicy // ignore: cast_nullable_to_non_nullable
as AiToolPolicyDto,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiGenerationOptionsDtoCopyWith<$Res> get generation {
  
  return $AiGenerationOptionsDtoCopyWith<$Res>(_self.generation, (value) {
    return _then(_self.copyWith(generation: value));
  });
}/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiContextPolicyDtoCopyWith<$Res> get contextPolicy {
  
  return $AiContextPolicyDtoCopyWith<$Res>(_self.contextPolicy, (value) {
    return _then(_self.copyWith(contextPolicy: value));
  });
}/// Create a copy of AiAssistantProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiToolPolicyDtoCopyWith<$Res> get toolPolicy {
  
  return $AiToolPolicyDtoCopyWith<$Res>(_self.toolPolicy, (value) {
    return _then(_self.copyWith(toolPolicy: value));
  });
}
}

// dart format on
