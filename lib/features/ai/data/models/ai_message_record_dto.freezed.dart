// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_message_record_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiContentPartDto {

 String get type; String? get text; String? get attachmentId; String? get toolCallId; String? get toolName; Map<String, Object?>? get arguments; bool? get success;
/// Create a copy of AiContentPartDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiContentPartDtoCopyWith<AiContentPartDto> get copyWith => _$AiContentPartDtoCopyWithImpl<AiContentPartDto>(this as AiContentPartDto, _$identity);

  /// Serializes this AiContentPartDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiContentPartDto&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&const DeepCollectionEquality().equals(other.arguments, arguments)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text,attachmentId,toolCallId,toolName,const DeepCollectionEquality().hash(arguments),success);

@override
String toString() {
  return 'AiContentPartDto(type: $type, text: $text, attachmentId: $attachmentId, toolCallId: $toolCallId, toolName: $toolName, arguments: $arguments, success: $success)';
}


}

/// @nodoc
abstract mixin class $AiContentPartDtoCopyWith<$Res>  {
  factory $AiContentPartDtoCopyWith(AiContentPartDto value, $Res Function(AiContentPartDto) _then) = _$AiContentPartDtoCopyWithImpl;
@useResult
$Res call({
 String type, String? text, String? attachmentId, String? toolCallId, String? toolName, Map<String, Object?>? arguments, bool? success
});




}
/// @nodoc
class _$AiContentPartDtoCopyWithImpl<$Res>
    implements $AiContentPartDtoCopyWith<$Res> {
  _$AiContentPartDtoCopyWithImpl(this._self, this._then);

  final AiContentPartDto _self;
  final $Res Function(AiContentPartDto) _then;

/// Create a copy of AiContentPartDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? text = freezed,Object? attachmentId = freezed,Object? toolCallId = freezed,Object? toolName = freezed,Object? arguments = freezed,Object? success = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,attachmentId: freezed == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String?,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,arguments: freezed == arguments ? _self.arguments : arguments // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiContentPartDto].
extension AiContentPartDtoPatterns on AiContentPartDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiContentPartDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiContentPartDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiContentPartDto value)  $default,){
final _that = this;
switch (_that) {
case _AiContentPartDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiContentPartDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiContentPartDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? text,  String? attachmentId,  String? toolCallId,  String? toolName,  Map<String, Object?>? arguments,  bool? success)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiContentPartDto() when $default != null:
return $default(_that.type,_that.text,_that.attachmentId,_that.toolCallId,_that.toolName,_that.arguments,_that.success);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? text,  String? attachmentId,  String? toolCallId,  String? toolName,  Map<String, Object?>? arguments,  bool? success)  $default,) {final _that = this;
switch (_that) {
case _AiContentPartDto():
return $default(_that.type,_that.text,_that.attachmentId,_that.toolCallId,_that.toolName,_that.arguments,_that.success);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? text,  String? attachmentId,  String? toolCallId,  String? toolName,  Map<String, Object?>? arguments,  bool? success)?  $default,) {final _that = this;
switch (_that) {
case _AiContentPartDto() when $default != null:
return $default(_that.type,_that.text,_that.attachmentId,_that.toolCallId,_that.toolName,_that.arguments,_that.success);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiContentPartDto extends AiContentPartDto {
  const _AiContentPartDto({required this.type, this.text, this.attachmentId, this.toolCallId, this.toolName, final  Map<String, Object?>? arguments, this.success}): _arguments = arguments,super._();
  factory _AiContentPartDto.fromJson(Map<String, dynamic> json) => _$AiContentPartDtoFromJson(json);

@override final  String type;
@override final  String? text;
@override final  String? attachmentId;
@override final  String? toolCallId;
@override final  String? toolName;
 final  Map<String, Object?>? _arguments;
@override Map<String, Object?>? get arguments {
  final value = _arguments;
  if (value == null) return null;
  if (_arguments is EqualUnmodifiableMapView) return _arguments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  bool? success;

/// Create a copy of AiContentPartDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiContentPartDtoCopyWith<_AiContentPartDto> get copyWith => __$AiContentPartDtoCopyWithImpl<_AiContentPartDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiContentPartDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiContentPartDto&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.toolName, toolName) || other.toolName == toolName)&&const DeepCollectionEquality().equals(other._arguments, _arguments)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text,attachmentId,toolCallId,toolName,const DeepCollectionEquality().hash(_arguments),success);

@override
String toString() {
  return 'AiContentPartDto(type: $type, text: $text, attachmentId: $attachmentId, toolCallId: $toolCallId, toolName: $toolName, arguments: $arguments, success: $success)';
}


}

/// @nodoc
abstract mixin class _$AiContentPartDtoCopyWith<$Res> implements $AiContentPartDtoCopyWith<$Res> {
  factory _$AiContentPartDtoCopyWith(_AiContentPartDto value, $Res Function(_AiContentPartDto) _then) = __$AiContentPartDtoCopyWithImpl;
@override @useResult
$Res call({
 String type, String? text, String? attachmentId, String? toolCallId, String? toolName, Map<String, Object?>? arguments, bool? success
});




}
/// @nodoc
class __$AiContentPartDtoCopyWithImpl<$Res>
    implements _$AiContentPartDtoCopyWith<$Res> {
  __$AiContentPartDtoCopyWithImpl(this._self, this._then);

  final _AiContentPartDto _self;
  final $Res Function(_AiContentPartDto) _then;

/// Create a copy of AiContentPartDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? text = freezed,Object? attachmentId = freezed,Object? toolCallId = freezed,Object? toolName = freezed,Object? arguments = freezed,Object? success = freezed,}) {
  return _then(_AiContentPartDto(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,attachmentId: freezed == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String?,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,arguments: freezed == arguments ? _self._arguments : arguments // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,success: freezed == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$AiUsageDto {

 int get inputTokens; int get outputTokens; int get totalTokens;
/// Create a copy of AiUsageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiUsageDtoCopyWith<AiUsageDto> get copyWith => _$AiUsageDtoCopyWithImpl<AiUsageDto>(this as AiUsageDto, _$identity);

  /// Serializes this AiUsageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiUsageDto&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens)&&(identical(other.totalTokens, totalTokens) || other.totalTokens == totalTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inputTokens,outputTokens,totalTokens);

@override
String toString() {
  return 'AiUsageDto(inputTokens: $inputTokens, outputTokens: $outputTokens, totalTokens: $totalTokens)';
}


}

/// @nodoc
abstract mixin class $AiUsageDtoCopyWith<$Res>  {
  factory $AiUsageDtoCopyWith(AiUsageDto value, $Res Function(AiUsageDto) _then) = _$AiUsageDtoCopyWithImpl;
@useResult
$Res call({
 int inputTokens, int outputTokens, int totalTokens
});




}
/// @nodoc
class _$AiUsageDtoCopyWithImpl<$Res>
    implements $AiUsageDtoCopyWith<$Res> {
  _$AiUsageDtoCopyWithImpl(this._self, this._then);

  final AiUsageDto _self;
  final $Res Function(AiUsageDto) _then;

/// Create a copy of AiUsageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputTokens = null,Object? outputTokens = null,Object? totalTokens = null,}) {
  return _then(_self.copyWith(
inputTokens: null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,outputTokens: null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,totalTokens: null == totalTokens ? _self.totalTokens : totalTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiUsageDto].
extension AiUsageDtoPatterns on AiUsageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiUsageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiUsageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiUsageDto value)  $default,){
final _that = this;
switch (_that) {
case _AiUsageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiUsageDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiUsageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int inputTokens,  int outputTokens,  int totalTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiUsageDto() when $default != null:
return $default(_that.inputTokens,_that.outputTokens,_that.totalTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int inputTokens,  int outputTokens,  int totalTokens)  $default,) {final _that = this;
switch (_that) {
case _AiUsageDto():
return $default(_that.inputTokens,_that.outputTokens,_that.totalTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int inputTokens,  int outputTokens,  int totalTokens)?  $default,) {final _that = this;
switch (_that) {
case _AiUsageDto() when $default != null:
return $default(_that.inputTokens,_that.outputTokens,_that.totalTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiUsageDto extends AiUsageDto {
  const _AiUsageDto({this.inputTokens = 0, this.outputTokens = 0, this.totalTokens = 0}): super._();
  factory _AiUsageDto.fromJson(Map<String, dynamic> json) => _$AiUsageDtoFromJson(json);

@override@JsonKey() final  int inputTokens;
@override@JsonKey() final  int outputTokens;
@override@JsonKey() final  int totalTokens;

/// Create a copy of AiUsageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiUsageDtoCopyWith<_AiUsageDto> get copyWith => __$AiUsageDtoCopyWithImpl<_AiUsageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiUsageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiUsageDto&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens)&&(identical(other.totalTokens, totalTokens) || other.totalTokens == totalTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inputTokens,outputTokens,totalTokens);

@override
String toString() {
  return 'AiUsageDto(inputTokens: $inputTokens, outputTokens: $outputTokens, totalTokens: $totalTokens)';
}


}

/// @nodoc
abstract mixin class _$AiUsageDtoCopyWith<$Res> implements $AiUsageDtoCopyWith<$Res> {
  factory _$AiUsageDtoCopyWith(_AiUsageDto value, $Res Function(_AiUsageDto) _then) = __$AiUsageDtoCopyWithImpl;
@override @useResult
$Res call({
 int inputTokens, int outputTokens, int totalTokens
});




}
/// @nodoc
class __$AiUsageDtoCopyWithImpl<$Res>
    implements _$AiUsageDtoCopyWith<$Res> {
  __$AiUsageDtoCopyWithImpl(this._self, this._then);

  final _AiUsageDto _self;
  final $Res Function(_AiUsageDto) _then;

/// Create a copy of AiUsageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputTokens = null,Object? outputTokens = null,Object? totalTokens = null,}) {
  return _then(_AiUsageDto(
inputTokens: null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,outputTokens: null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,totalTokens: null == totalTokens ? _self.totalTokens : totalTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AiFailureDto {

 String get code; String get messageKey; bool get retryable; int? get httpStatus; String? get providerRequestId;
/// Create a copy of AiFailureDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiFailureDtoCopyWith<AiFailureDto> get copyWith => _$AiFailureDtoCopyWithImpl<AiFailureDto>(this as AiFailureDto, _$identity);

  /// Serializes this AiFailureDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiFailureDto&&(identical(other.code, code) || other.code == code)&&(identical(other.messageKey, messageKey) || other.messageKey == messageKey)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.httpStatus, httpStatus) || other.httpStatus == httpStatus)&&(identical(other.providerRequestId, providerRequestId) || other.providerRequestId == providerRequestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,messageKey,retryable,httpStatus,providerRequestId);

@override
String toString() {
  return 'AiFailureDto(code: $code, messageKey: $messageKey, retryable: $retryable, httpStatus: $httpStatus, providerRequestId: $providerRequestId)';
}


}

/// @nodoc
abstract mixin class $AiFailureDtoCopyWith<$Res>  {
  factory $AiFailureDtoCopyWith(AiFailureDto value, $Res Function(AiFailureDto) _then) = _$AiFailureDtoCopyWithImpl;
@useResult
$Res call({
 String code, String messageKey, bool retryable, int? httpStatus, String? providerRequestId
});




}
/// @nodoc
class _$AiFailureDtoCopyWithImpl<$Res>
    implements $AiFailureDtoCopyWith<$Res> {
  _$AiFailureDtoCopyWithImpl(this._self, this._then);

  final AiFailureDto _self;
  final $Res Function(AiFailureDto) _then;

/// Create a copy of AiFailureDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? messageKey = null,Object? retryable = null,Object? httpStatus = freezed,Object? providerRequestId = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,messageKey: null == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,httpStatus: freezed == httpStatus ? _self.httpStatus : httpStatus // ignore: cast_nullable_to_non_nullable
as int?,providerRequestId: freezed == providerRequestId ? _self.providerRequestId : providerRequestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiFailureDto].
extension AiFailureDtoPatterns on AiFailureDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiFailureDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiFailureDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiFailureDto value)  $default,){
final _that = this;
switch (_that) {
case _AiFailureDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiFailureDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiFailureDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String messageKey,  bool retryable,  int? httpStatus,  String? providerRequestId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiFailureDto() when $default != null:
return $default(_that.code,_that.messageKey,_that.retryable,_that.httpStatus,_that.providerRequestId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String messageKey,  bool retryable,  int? httpStatus,  String? providerRequestId)  $default,) {final _that = this;
switch (_that) {
case _AiFailureDto():
return $default(_that.code,_that.messageKey,_that.retryable,_that.httpStatus,_that.providerRequestId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String messageKey,  bool retryable,  int? httpStatus,  String? providerRequestId)?  $default,) {final _that = this;
switch (_that) {
case _AiFailureDto() when $default != null:
return $default(_that.code,_that.messageKey,_that.retryable,_that.httpStatus,_that.providerRequestId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiFailureDto extends AiFailureDto {
  const _AiFailureDto({required this.code, required this.messageKey, this.retryable = false, this.httpStatus, this.providerRequestId}): super._();
  factory _AiFailureDto.fromJson(Map<String, dynamic> json) => _$AiFailureDtoFromJson(json);

@override final  String code;
@override final  String messageKey;
@override@JsonKey() final  bool retryable;
@override final  int? httpStatus;
@override final  String? providerRequestId;

/// Create a copy of AiFailureDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiFailureDtoCopyWith<_AiFailureDto> get copyWith => __$AiFailureDtoCopyWithImpl<_AiFailureDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiFailureDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiFailureDto&&(identical(other.code, code) || other.code == code)&&(identical(other.messageKey, messageKey) || other.messageKey == messageKey)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.httpStatus, httpStatus) || other.httpStatus == httpStatus)&&(identical(other.providerRequestId, providerRequestId) || other.providerRequestId == providerRequestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,messageKey,retryable,httpStatus,providerRequestId);

@override
String toString() {
  return 'AiFailureDto(code: $code, messageKey: $messageKey, retryable: $retryable, httpStatus: $httpStatus, providerRequestId: $providerRequestId)';
}


}

/// @nodoc
abstract mixin class _$AiFailureDtoCopyWith<$Res> implements $AiFailureDtoCopyWith<$Res> {
  factory _$AiFailureDtoCopyWith(_AiFailureDto value, $Res Function(_AiFailureDto) _then) = __$AiFailureDtoCopyWithImpl;
@override @useResult
$Res call({
 String code, String messageKey, bool retryable, int? httpStatus, String? providerRequestId
});




}
/// @nodoc
class __$AiFailureDtoCopyWithImpl<$Res>
    implements _$AiFailureDtoCopyWith<$Res> {
  __$AiFailureDtoCopyWithImpl(this._self, this._then);

  final _AiFailureDto _self;
  final $Res Function(_AiFailureDto) _then;

/// Create a copy of AiFailureDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? messageKey = null,Object? retryable = null,Object? httpStatus = freezed,Object? providerRequestId = freezed,}) {
  return _then(_AiFailureDto(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,messageKey: null == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,httpStatus: freezed == httpStatus ? _self.httpStatus : httpStatus // ignore: cast_nullable_to_non_nullable
as int?,providerRequestId: freezed == providerRequestId ? _self.providerRequestId : providerRequestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AiMessageRecordDto {

 String get id; String get conversationId; String get role; List<AiContentPartDto> get parts; String get status; String? get parentId; AiUsageDto? get usage; AiFailureDto? get failure; String get createdAt; String? get completedAt;
/// Create a copy of AiMessageRecordDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiMessageRecordDtoCopyWith<AiMessageRecordDto> get copyWith => _$AiMessageRecordDtoCopyWithImpl<AiMessageRecordDto>(this as AiMessageRecordDto, _$identity);

  /// Serializes this AiMessageRecordDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiMessageRecordDto&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.parts, parts)&&(identical(other.status, status) || other.status == status)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,role,const DeepCollectionEquality().hash(parts),status,parentId,usage,failure,createdAt,completedAt);

@override
String toString() {
  return 'AiMessageRecordDto(id: $id, conversationId: $conversationId, role: $role, parts: $parts, status: $status, parentId: $parentId, usage: $usage, failure: $failure, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $AiMessageRecordDtoCopyWith<$Res>  {
  factory $AiMessageRecordDtoCopyWith(AiMessageRecordDto value, $Res Function(AiMessageRecordDto) _then) = _$AiMessageRecordDtoCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String role, List<AiContentPartDto> parts, String status, String? parentId, AiUsageDto? usage, AiFailureDto? failure, String createdAt, String? completedAt
});


$AiUsageDtoCopyWith<$Res>? get usage;$AiFailureDtoCopyWith<$Res>? get failure;

}
/// @nodoc
class _$AiMessageRecordDtoCopyWithImpl<$Res>
    implements $AiMessageRecordDtoCopyWith<$Res> {
  _$AiMessageRecordDtoCopyWithImpl(this._self, this._then);

  final AiMessageRecordDto _self;
  final $Res Function(AiMessageRecordDto) _then;

/// Create a copy of AiMessageRecordDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? role = null,Object? parts = null,Object? status = null,Object? parentId = freezed,Object? usage = freezed,Object? failure = freezed,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<AiContentPartDto>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as AiUsageDto?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailureDto?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AiMessageRecordDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiUsageDtoCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $AiUsageDtoCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}/// Create a copy of AiMessageRecordDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiFailureDtoCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $AiFailureDtoCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiMessageRecordDto].
extension AiMessageRecordDtoPatterns on AiMessageRecordDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiMessageRecordDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiMessageRecordDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiMessageRecordDto value)  $default,){
final _that = this;
switch (_that) {
case _AiMessageRecordDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiMessageRecordDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiMessageRecordDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String role,  List<AiContentPartDto> parts,  String status,  String? parentId,  AiUsageDto? usage,  AiFailureDto? failure,  String createdAt,  String? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiMessageRecordDto() when $default != null:
return $default(_that.id,_that.conversationId,_that.role,_that.parts,_that.status,_that.parentId,_that.usage,_that.failure,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String role,  List<AiContentPartDto> parts,  String status,  String? parentId,  AiUsageDto? usage,  AiFailureDto? failure,  String createdAt,  String? completedAt)  $default,) {final _that = this;
switch (_that) {
case _AiMessageRecordDto():
return $default(_that.id,_that.conversationId,_that.role,_that.parts,_that.status,_that.parentId,_that.usage,_that.failure,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String role,  List<AiContentPartDto> parts,  String status,  String? parentId,  AiUsageDto? usage,  AiFailureDto? failure,  String createdAt,  String? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiMessageRecordDto() when $default != null:
return $default(_that.id,_that.conversationId,_that.role,_that.parts,_that.status,_that.parentId,_that.usage,_that.failure,_that.createdAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiMessageRecordDto extends AiMessageRecordDto {
  const _AiMessageRecordDto({required this.id, required this.conversationId, required this.role, required final  List<AiContentPartDto> parts, this.status = 'completed', this.parentId, this.usage, this.failure, required this.createdAt, this.completedAt}): _parts = parts,super._();
  factory _AiMessageRecordDto.fromJson(Map<String, dynamic> json) => _$AiMessageRecordDtoFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String role;
 final  List<AiContentPartDto> _parts;
@override List<AiContentPartDto> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override@JsonKey() final  String status;
@override final  String? parentId;
@override final  AiUsageDto? usage;
@override final  AiFailureDto? failure;
@override final  String createdAt;
@override final  String? completedAt;

/// Create a copy of AiMessageRecordDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiMessageRecordDtoCopyWith<_AiMessageRecordDto> get copyWith => __$AiMessageRecordDtoCopyWithImpl<_AiMessageRecordDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiMessageRecordDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiMessageRecordDto&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._parts, _parts)&&(identical(other.status, status) || other.status == status)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,conversationId,role,const DeepCollectionEquality().hash(_parts),status,parentId,usage,failure,createdAt,completedAt);

@override
String toString() {
  return 'AiMessageRecordDto(id: $id, conversationId: $conversationId, role: $role, parts: $parts, status: $status, parentId: $parentId, usage: $usage, failure: $failure, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$AiMessageRecordDtoCopyWith<$Res> implements $AiMessageRecordDtoCopyWith<$Res> {
  factory _$AiMessageRecordDtoCopyWith(_AiMessageRecordDto value, $Res Function(_AiMessageRecordDto) _then) = __$AiMessageRecordDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String role, List<AiContentPartDto> parts, String status, String? parentId, AiUsageDto? usage, AiFailureDto? failure, String createdAt, String? completedAt
});


@override $AiUsageDtoCopyWith<$Res>? get usage;@override $AiFailureDtoCopyWith<$Res>? get failure;

}
/// @nodoc
class __$AiMessageRecordDtoCopyWithImpl<$Res>
    implements _$AiMessageRecordDtoCopyWith<$Res> {
  __$AiMessageRecordDtoCopyWithImpl(this._self, this._then);

  final _AiMessageRecordDto _self;
  final $Res Function(_AiMessageRecordDto) _then;

/// Create a copy of AiMessageRecordDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? role = null,Object? parts = null,Object? status = null,Object? parentId = freezed,Object? usage = freezed,Object? failure = freezed,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_AiMessageRecordDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<AiContentPartDto>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as AiUsageDto?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailureDto?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AiMessageRecordDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiUsageDtoCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $AiUsageDtoCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}/// Create a copy of AiMessageRecordDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiFailureDtoCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $AiFailureDtoCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
