// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuditLog {

 String get algorithm; int get operation; String get key; String get keyBase64; String get keyPlaintext; String? get iv; String? get ivBase64; String? get ivPlaintext; String get input; String get inputBase64; String get output; String get outputBase64; String get inputHex; String get outputHex; List<String> get stackTrace; String get fingerprint; int get timestamp;
/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogCopyWith<AuditLog> get copyWith => _$AuditLogCopyWithImpl<AuditLog>(this as AuditLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLog&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.key, key) || other.key == key)&&(identical(other.keyBase64, keyBase64) || other.keyBase64 == keyBase64)&&(identical(other.keyPlaintext, keyPlaintext) || other.keyPlaintext == keyPlaintext)&&(identical(other.iv, iv) || other.iv == iv)&&(identical(other.ivBase64, ivBase64) || other.ivBase64 == ivBase64)&&(identical(other.ivPlaintext, ivPlaintext) || other.ivPlaintext == ivPlaintext)&&(identical(other.input, input) || other.input == input)&&(identical(other.inputBase64, inputBase64) || other.inputBase64 == inputBase64)&&(identical(other.output, output) || other.output == output)&&(identical(other.outputBase64, outputBase64) || other.outputBase64 == outputBase64)&&(identical(other.inputHex, inputHex) || other.inputHex == inputHex)&&(identical(other.outputHex, outputHex) || other.outputHex == outputHex)&&const DeepCollectionEquality().equals(other.stackTrace, stackTrace)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,algorithm,operation,key,keyBase64,keyPlaintext,iv,ivBase64,ivPlaintext,input,inputBase64,output,outputBase64,inputHex,outputHex,const DeepCollectionEquality().hash(stackTrace),fingerprint,timestamp);

@override
String toString() {
  return 'AuditLog(algorithm: $algorithm, operation: $operation, key: $key, keyBase64: $keyBase64, keyPlaintext: $keyPlaintext, iv: $iv, ivBase64: $ivBase64, ivPlaintext: $ivPlaintext, input: $input, inputBase64: $inputBase64, output: $output, outputBase64: $outputBase64, inputHex: $inputHex, outputHex: $outputHex, stackTrace: $stackTrace, fingerprint: $fingerprint, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $AuditLogCopyWith<$Res>  {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) _then) = _$AuditLogCopyWithImpl;
@useResult
$Res call({
 String algorithm, int operation, String key, String keyBase64, String keyPlaintext, String? iv, String? ivBase64, String? ivPlaintext, String input, String inputBase64, String output, String outputBase64, String inputHex, String outputHex, List<String> stackTrace, String fingerprint, int timestamp
});




}
/// @nodoc
class _$AuditLogCopyWithImpl<$Res>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._self, this._then);

  final AuditLog _self;
  final $Res Function(AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? algorithm = null,Object? operation = null,Object? key = null,Object? keyBase64 = null,Object? keyPlaintext = null,Object? iv = freezed,Object? ivBase64 = freezed,Object? ivPlaintext = freezed,Object? input = null,Object? inputBase64 = null,Object? output = null,Object? outputBase64 = null,Object? inputHex = null,Object? outputHex = null,Object? stackTrace = null,Object? fingerprint = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,keyBase64: null == keyBase64 ? _self.keyBase64 : keyBase64 // ignore: cast_nullable_to_non_nullable
as String,keyPlaintext: null == keyPlaintext ? _self.keyPlaintext : keyPlaintext // ignore: cast_nullable_to_non_nullable
as String,iv: freezed == iv ? _self.iv : iv // ignore: cast_nullable_to_non_nullable
as String?,ivBase64: freezed == ivBase64 ? _self.ivBase64 : ivBase64 // ignore: cast_nullable_to_non_nullable
as String?,ivPlaintext: freezed == ivPlaintext ? _self.ivPlaintext : ivPlaintext // ignore: cast_nullable_to_non_nullable
as String?,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,inputBase64: null == inputBase64 ? _self.inputBase64 : inputBase64 // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,outputBase64: null == outputBase64 ? _self.outputBase64 : outputBase64 // ignore: cast_nullable_to_non_nullable
as String,inputHex: null == inputHex ? _self.inputHex : inputHex // ignore: cast_nullable_to_non_nullable
as String,outputHex: null == outputHex ? _self.outputHex : outputHex // ignore: cast_nullable_to_non_nullable
as String,stackTrace: null == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as List<String>,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLog].
extension AuditLogPatterns on AuditLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLog value)  $default,){
final _that = this;
switch (_that) {
case _AuditLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLog value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String algorithm,  int operation,  String key,  String keyBase64,  String keyPlaintext,  String? iv,  String? ivBase64,  String? ivPlaintext,  String input,  String inputBase64,  String output,  String outputBase64,  String inputHex,  String outputHex,  List<String> stackTrace,  String fingerprint,  int timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.algorithm,_that.operation,_that.key,_that.keyBase64,_that.keyPlaintext,_that.iv,_that.ivBase64,_that.ivPlaintext,_that.input,_that.inputBase64,_that.output,_that.outputBase64,_that.inputHex,_that.outputHex,_that.stackTrace,_that.fingerprint,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String algorithm,  int operation,  String key,  String keyBase64,  String keyPlaintext,  String? iv,  String? ivBase64,  String? ivPlaintext,  String input,  String inputBase64,  String output,  String outputBase64,  String inputHex,  String outputHex,  List<String> stackTrace,  String fingerprint,  int timestamp)  $default,) {final _that = this;
switch (_that) {
case _AuditLog():
return $default(_that.algorithm,_that.operation,_that.key,_that.keyBase64,_that.keyPlaintext,_that.iv,_that.ivBase64,_that.ivPlaintext,_that.input,_that.inputBase64,_that.output,_that.outputBase64,_that.inputHex,_that.outputHex,_that.stackTrace,_that.fingerprint,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String algorithm,  int operation,  String key,  String keyBase64,  String keyPlaintext,  String? iv,  String? ivBase64,  String? ivPlaintext,  String input,  String inputBase64,  String output,  String outputBase64,  String inputHex,  String outputHex,  List<String> stackTrace,  String fingerprint,  int timestamp)?  $default,) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.algorithm,_that.operation,_that.key,_that.keyBase64,_that.keyPlaintext,_that.iv,_that.ivBase64,_that.ivPlaintext,_that.input,_that.inputBase64,_that.output,_that.outputBase64,_that.inputHex,_that.outputHex,_that.stackTrace,_that.fingerprint,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _AuditLog implements AuditLog {
  const _AuditLog({required this.algorithm, required this.operation, required this.key, required this.keyBase64, required this.keyPlaintext, required this.iv, required this.ivBase64, required this.ivPlaintext, required this.input, required this.inputBase64, required this.output, required this.outputBase64, required this.inputHex, required this.outputHex, required final  List<String> stackTrace, required this.fingerprint, required this.timestamp}): _stackTrace = stackTrace;
  

@override final  String algorithm;
@override final  int operation;
@override final  String key;
@override final  String keyBase64;
@override final  String keyPlaintext;
@override final  String? iv;
@override final  String? ivBase64;
@override final  String? ivPlaintext;
@override final  String input;
@override final  String inputBase64;
@override final  String output;
@override final  String outputBase64;
@override final  String inputHex;
@override final  String outputHex;
 final  List<String> _stackTrace;
@override List<String> get stackTrace {
  if (_stackTrace is EqualUnmodifiableListView) return _stackTrace;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stackTrace);
}

@override final  String fingerprint;
@override final  int timestamp;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogCopyWith<_AuditLog> get copyWith => __$AuditLogCopyWithImpl<_AuditLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLog&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.key, key) || other.key == key)&&(identical(other.keyBase64, keyBase64) || other.keyBase64 == keyBase64)&&(identical(other.keyPlaintext, keyPlaintext) || other.keyPlaintext == keyPlaintext)&&(identical(other.iv, iv) || other.iv == iv)&&(identical(other.ivBase64, ivBase64) || other.ivBase64 == ivBase64)&&(identical(other.ivPlaintext, ivPlaintext) || other.ivPlaintext == ivPlaintext)&&(identical(other.input, input) || other.input == input)&&(identical(other.inputBase64, inputBase64) || other.inputBase64 == inputBase64)&&(identical(other.output, output) || other.output == output)&&(identical(other.outputBase64, outputBase64) || other.outputBase64 == outputBase64)&&(identical(other.inputHex, inputHex) || other.inputHex == inputHex)&&(identical(other.outputHex, outputHex) || other.outputHex == outputHex)&&const DeepCollectionEquality().equals(other._stackTrace, _stackTrace)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,algorithm,operation,key,keyBase64,keyPlaintext,iv,ivBase64,ivPlaintext,input,inputBase64,output,outputBase64,inputHex,outputHex,const DeepCollectionEquality().hash(_stackTrace),fingerprint,timestamp);

@override
String toString() {
  return 'AuditLog(algorithm: $algorithm, operation: $operation, key: $key, keyBase64: $keyBase64, keyPlaintext: $keyPlaintext, iv: $iv, ivBase64: $ivBase64, ivPlaintext: $ivPlaintext, input: $input, inputBase64: $inputBase64, output: $output, outputBase64: $outputBase64, inputHex: $inputHex, outputHex: $outputHex, stackTrace: $stackTrace, fingerprint: $fingerprint, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$AuditLogCopyWith<$Res> implements $AuditLogCopyWith<$Res> {
  factory _$AuditLogCopyWith(_AuditLog value, $Res Function(_AuditLog) _then) = __$AuditLogCopyWithImpl;
@override @useResult
$Res call({
 String algorithm, int operation, String key, String keyBase64, String keyPlaintext, String? iv, String? ivBase64, String? ivPlaintext, String input, String inputBase64, String output, String outputBase64, String inputHex, String outputHex, List<String> stackTrace, String fingerprint, int timestamp
});




}
/// @nodoc
class __$AuditLogCopyWithImpl<$Res>
    implements _$AuditLogCopyWith<$Res> {
  __$AuditLogCopyWithImpl(this._self, this._then);

  final _AuditLog _self;
  final $Res Function(_AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? algorithm = null,Object? operation = null,Object? key = null,Object? keyBase64 = null,Object? keyPlaintext = null,Object? iv = freezed,Object? ivBase64 = freezed,Object? ivPlaintext = freezed,Object? input = null,Object? inputBase64 = null,Object? output = null,Object? outputBase64 = null,Object? inputHex = null,Object? outputHex = null,Object? stackTrace = null,Object? fingerprint = null,Object? timestamp = null,}) {
  return _then(_AuditLog(
algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,keyBase64: null == keyBase64 ? _self.keyBase64 : keyBase64 // ignore: cast_nullable_to_non_nullable
as String,keyPlaintext: null == keyPlaintext ? _self.keyPlaintext : keyPlaintext // ignore: cast_nullable_to_non_nullable
as String,iv: freezed == iv ? _self.iv : iv // ignore: cast_nullable_to_non_nullable
as String?,ivBase64: freezed == ivBase64 ? _self.ivBase64 : ivBase64 // ignore: cast_nullable_to_non_nullable
as String?,ivPlaintext: freezed == ivPlaintext ? _self.ivPlaintext : ivPlaintext // ignore: cast_nullable_to_non_nullable
as String?,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,inputBase64: null == inputBase64 ? _self.inputBase64 : inputBase64 // ignore: cast_nullable_to_non_nullable
as String,output: null == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String,outputBase64: null == outputBase64 ? _self.outputBase64 : outputBase64 // ignore: cast_nullable_to_non_nullable
as String,inputHex: null == inputHex ? _self.inputHex : inputHex // ignore: cast_nullable_to_non_nullable
as String,outputHex: null == outputHex ? _self.outputHex : outputHex // ignore: cast_nullable_to_non_nullable
as String,stackTrace: null == stackTrace ? _self._stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as List<String>,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
