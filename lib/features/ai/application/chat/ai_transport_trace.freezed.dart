// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_transport_trace.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiTransportTrace {

 String get requestUrl; int? get statusCode; String? get contentType; DateTime? get requestStartTime; DateTime? get requestEndTime; Duration? get responseDuration; String? get providerRequestId; List<String> get rawSseEvents; String? get rawResponseText; String? get rawErrorJson;
/// Create a copy of AiTransportTrace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiTransportTraceCopyWith<AiTransportTrace> get copyWith => _$AiTransportTraceCopyWithImpl<AiTransportTrace>(this as AiTransportTrace, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiTransportTrace&&(identical(other.requestUrl, requestUrl) || other.requestUrl == requestUrl)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.requestStartTime, requestStartTime) || other.requestStartTime == requestStartTime)&&(identical(other.requestEndTime, requestEndTime) || other.requestEndTime == requestEndTime)&&(identical(other.responseDuration, responseDuration) || other.responseDuration == responseDuration)&&(identical(other.providerRequestId, providerRequestId) || other.providerRequestId == providerRequestId)&&const DeepCollectionEquality().equals(other.rawSseEvents, rawSseEvents)&&(identical(other.rawResponseText, rawResponseText) || other.rawResponseText == rawResponseText)&&(identical(other.rawErrorJson, rawErrorJson) || other.rawErrorJson == rawErrorJson));
}


@override
int get hashCode => Object.hash(runtimeType,requestUrl,statusCode,contentType,requestStartTime,requestEndTime,responseDuration,providerRequestId,const DeepCollectionEquality().hash(rawSseEvents),rawResponseText,rawErrorJson);

@override
String toString() {
  return 'AiTransportTrace(requestUrl: $requestUrl, statusCode: $statusCode, contentType: $contentType, requestStartTime: $requestStartTime, requestEndTime: $requestEndTime, responseDuration: $responseDuration, providerRequestId: $providerRequestId, rawSseEvents: $rawSseEvents, rawResponseText: $rawResponseText, rawErrorJson: $rawErrorJson)';
}


}

/// @nodoc
abstract mixin class $AiTransportTraceCopyWith<$Res>  {
  factory $AiTransportTraceCopyWith(AiTransportTrace value, $Res Function(AiTransportTrace) _then) = _$AiTransportTraceCopyWithImpl;
@useResult
$Res call({
 String requestUrl, int? statusCode, String? contentType, DateTime? requestStartTime, DateTime? requestEndTime, Duration? responseDuration, String? providerRequestId, List<String> rawSseEvents, String? rawResponseText, String? rawErrorJson
});




}
/// @nodoc
class _$AiTransportTraceCopyWithImpl<$Res>
    implements $AiTransportTraceCopyWith<$Res> {
  _$AiTransportTraceCopyWithImpl(this._self, this._then);

  final AiTransportTrace _self;
  final $Res Function(AiTransportTrace) _then;

/// Create a copy of AiTransportTrace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestUrl = null,Object? statusCode = freezed,Object? contentType = freezed,Object? requestStartTime = freezed,Object? requestEndTime = freezed,Object? responseDuration = freezed,Object? providerRequestId = freezed,Object? rawSseEvents = null,Object? rawResponseText = freezed,Object? rawErrorJson = freezed,}) {
  return _then(_self.copyWith(
requestUrl: null == requestUrl ? _self.requestUrl : requestUrl // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,requestStartTime: freezed == requestStartTime ? _self.requestStartTime : requestStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,requestEndTime: freezed == requestEndTime ? _self.requestEndTime : requestEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,responseDuration: freezed == responseDuration ? _self.responseDuration : responseDuration // ignore: cast_nullable_to_non_nullable
as Duration?,providerRequestId: freezed == providerRequestId ? _self.providerRequestId : providerRequestId // ignore: cast_nullable_to_non_nullable
as String?,rawSseEvents: null == rawSseEvents ? _self.rawSseEvents : rawSseEvents // ignore: cast_nullable_to_non_nullable
as List<String>,rawResponseText: freezed == rawResponseText ? _self.rawResponseText : rawResponseText // ignore: cast_nullable_to_non_nullable
as String?,rawErrorJson: freezed == rawErrorJson ? _self.rawErrorJson : rawErrorJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiTransportTrace].
extension AiTransportTracePatterns on AiTransportTrace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiTransportTrace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiTransportTrace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiTransportTrace value)  $default,){
final _that = this;
switch (_that) {
case _AiTransportTrace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiTransportTrace value)?  $default,){
final _that = this;
switch (_that) {
case _AiTransportTrace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestUrl,  int? statusCode,  String? contentType,  DateTime? requestStartTime,  DateTime? requestEndTime,  Duration? responseDuration,  String? providerRequestId,  List<String> rawSseEvents,  String? rawResponseText,  String? rawErrorJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiTransportTrace() when $default != null:
return $default(_that.requestUrl,_that.statusCode,_that.contentType,_that.requestStartTime,_that.requestEndTime,_that.responseDuration,_that.providerRequestId,_that.rawSseEvents,_that.rawResponseText,_that.rawErrorJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestUrl,  int? statusCode,  String? contentType,  DateTime? requestStartTime,  DateTime? requestEndTime,  Duration? responseDuration,  String? providerRequestId,  List<String> rawSseEvents,  String? rawResponseText,  String? rawErrorJson)  $default,) {final _that = this;
switch (_that) {
case _AiTransportTrace():
return $default(_that.requestUrl,_that.statusCode,_that.contentType,_that.requestStartTime,_that.requestEndTime,_that.responseDuration,_that.providerRequestId,_that.rawSseEvents,_that.rawResponseText,_that.rawErrorJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestUrl,  int? statusCode,  String? contentType,  DateTime? requestStartTime,  DateTime? requestEndTime,  Duration? responseDuration,  String? providerRequestId,  List<String> rawSseEvents,  String? rawResponseText,  String? rawErrorJson)?  $default,) {final _that = this;
switch (_that) {
case _AiTransportTrace() when $default != null:
return $default(_that.requestUrl,_that.statusCode,_that.contentType,_that.requestStartTime,_that.requestEndTime,_that.responseDuration,_that.providerRequestId,_that.rawSseEvents,_that.rawResponseText,_that.rawErrorJson);case _:
  return null;

}
}

}

/// @nodoc


class _AiTransportTrace implements AiTransportTrace {
  const _AiTransportTrace({required this.requestUrl, this.statusCode, this.contentType, this.requestStartTime, this.requestEndTime, this.responseDuration, this.providerRequestId, final  List<String> rawSseEvents = const [], this.rawResponseText, this.rawErrorJson}): _rawSseEvents = rawSseEvents;
  

@override final  String requestUrl;
@override final  int? statusCode;
@override final  String? contentType;
@override final  DateTime? requestStartTime;
@override final  DateTime? requestEndTime;
@override final  Duration? responseDuration;
@override final  String? providerRequestId;
 final  List<String> _rawSseEvents;
@override@JsonKey() List<String> get rawSseEvents {
  if (_rawSseEvents is EqualUnmodifiableListView) return _rawSseEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rawSseEvents);
}

@override final  String? rawResponseText;
@override final  String? rawErrorJson;

/// Create a copy of AiTransportTrace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiTransportTraceCopyWith<_AiTransportTrace> get copyWith => __$AiTransportTraceCopyWithImpl<_AiTransportTrace>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiTransportTrace&&(identical(other.requestUrl, requestUrl) || other.requestUrl == requestUrl)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.requestStartTime, requestStartTime) || other.requestStartTime == requestStartTime)&&(identical(other.requestEndTime, requestEndTime) || other.requestEndTime == requestEndTime)&&(identical(other.responseDuration, responseDuration) || other.responseDuration == responseDuration)&&(identical(other.providerRequestId, providerRequestId) || other.providerRequestId == providerRequestId)&&const DeepCollectionEquality().equals(other._rawSseEvents, _rawSseEvents)&&(identical(other.rawResponseText, rawResponseText) || other.rawResponseText == rawResponseText)&&(identical(other.rawErrorJson, rawErrorJson) || other.rawErrorJson == rawErrorJson));
}


@override
int get hashCode => Object.hash(runtimeType,requestUrl,statusCode,contentType,requestStartTime,requestEndTime,responseDuration,providerRequestId,const DeepCollectionEquality().hash(_rawSseEvents),rawResponseText,rawErrorJson);

@override
String toString() {
  return 'AiTransportTrace(requestUrl: $requestUrl, statusCode: $statusCode, contentType: $contentType, requestStartTime: $requestStartTime, requestEndTime: $requestEndTime, responseDuration: $responseDuration, providerRequestId: $providerRequestId, rawSseEvents: $rawSseEvents, rawResponseText: $rawResponseText, rawErrorJson: $rawErrorJson)';
}


}

/// @nodoc
abstract mixin class _$AiTransportTraceCopyWith<$Res> implements $AiTransportTraceCopyWith<$Res> {
  factory _$AiTransportTraceCopyWith(_AiTransportTrace value, $Res Function(_AiTransportTrace) _then) = __$AiTransportTraceCopyWithImpl;
@override @useResult
$Res call({
 String requestUrl, int? statusCode, String? contentType, DateTime? requestStartTime, DateTime? requestEndTime, Duration? responseDuration, String? providerRequestId, List<String> rawSseEvents, String? rawResponseText, String? rawErrorJson
});




}
/// @nodoc
class __$AiTransportTraceCopyWithImpl<$Res>
    implements _$AiTransportTraceCopyWith<$Res> {
  __$AiTransportTraceCopyWithImpl(this._self, this._then);

  final _AiTransportTrace _self;
  final $Res Function(_AiTransportTrace) _then;

/// Create a copy of AiTransportTrace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestUrl = null,Object? statusCode = freezed,Object? contentType = freezed,Object? requestStartTime = freezed,Object? requestEndTime = freezed,Object? responseDuration = freezed,Object? providerRequestId = freezed,Object? rawSseEvents = null,Object? rawResponseText = freezed,Object? rawErrorJson = freezed,}) {
  return _then(_AiTransportTrace(
requestUrl: null == requestUrl ? _self.requestUrl : requestUrl // ignore: cast_nullable_to_non_nullable
as String,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,requestStartTime: freezed == requestStartTime ? _self.requestStartTime : requestStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,requestEndTime: freezed == requestEndTime ? _self.requestEndTime : requestEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,responseDuration: freezed == responseDuration ? _self.responseDuration : responseDuration // ignore: cast_nullable_to_non_nullable
as Duration?,providerRequestId: freezed == providerRequestId ? _self.providerRequestId : providerRequestId // ignore: cast_nullable_to_non_nullable
as String?,rawSseEvents: null == rawSseEvents ? _self._rawSseEvents : rawSseEvents // ignore: cast_nullable_to_non_nullable
as List<String>,rawResponseText: freezed == rawResponseText ? _self.rawResponseText : rawResponseText // ignore: cast_nullable_to_non_nullable
as String?,rawErrorJson: freezed == rawErrorJson ? _self.rawErrorJson : rawErrorJson // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
