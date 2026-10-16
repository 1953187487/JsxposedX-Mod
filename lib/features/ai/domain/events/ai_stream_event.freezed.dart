// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_stream_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiStreamEvent {

 String get requestId; int get sequence;
/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiStreamEventCopyWith<AiStreamEvent> get copyWith => _$AiStreamEventCopyWithImpl<AiStreamEvent>(this as AiStreamEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiStreamEvent&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence);

@override
String toString() {
  return 'AiStreamEvent(requestId: $requestId, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class $AiStreamEventCopyWith<$Res>  {
  factory $AiStreamEventCopyWith(AiStreamEvent value, $Res Function(AiStreamEvent) _then) = _$AiStreamEventCopyWithImpl;
@useResult
$Res call({
 String requestId, int sequence
});




}
/// @nodoc
class _$AiStreamEventCopyWithImpl<$Res>
    implements $AiStreamEventCopyWith<$Res> {
  _$AiStreamEventCopyWithImpl(this._self, this._then);

  final AiStreamEvent _self;
  final $Res Function(AiStreamEvent) _then;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? sequence = null,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiStreamEvent].
extension AiStreamEventPatterns on AiStreamEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AiResponseStarted value)?  started,TResult Function( AiTextDelta value)?  textDelta,TResult Function( AiReasoningDelta value)?  reasoningDelta,TResult Function( AiToolCallDelta value)?  toolCallDelta,TResult Function( AiUsageUpdated value)?  usage,TResult Function( AiResponseCompleted value)?  completed,TResult Function( AiResponseFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AiResponseStarted() when started != null:
return started(_that);case AiTextDelta() when textDelta != null:
return textDelta(_that);case AiReasoningDelta() when reasoningDelta != null:
return reasoningDelta(_that);case AiToolCallDelta() when toolCallDelta != null:
return toolCallDelta(_that);case AiUsageUpdated() when usage != null:
return usage(_that);case AiResponseCompleted() when completed != null:
return completed(_that);case AiResponseFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AiResponseStarted value)  started,required TResult Function( AiTextDelta value)  textDelta,required TResult Function( AiReasoningDelta value)  reasoningDelta,required TResult Function( AiToolCallDelta value)  toolCallDelta,required TResult Function( AiUsageUpdated value)  usage,required TResult Function( AiResponseCompleted value)  completed,required TResult Function( AiResponseFailed value)  failed,}){
final _that = this;
switch (_that) {
case AiResponseStarted():
return started(_that);case AiTextDelta():
return textDelta(_that);case AiReasoningDelta():
return reasoningDelta(_that);case AiToolCallDelta():
return toolCallDelta(_that);case AiUsageUpdated():
return usage(_that);case AiResponseCompleted():
return completed(_that);case AiResponseFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AiResponseStarted value)?  started,TResult? Function( AiTextDelta value)?  textDelta,TResult? Function( AiReasoningDelta value)?  reasoningDelta,TResult? Function( AiToolCallDelta value)?  toolCallDelta,TResult? Function( AiUsageUpdated value)?  usage,TResult? Function( AiResponseCompleted value)?  completed,TResult? Function( AiResponseFailed value)?  failed,}){
final _that = this;
switch (_that) {
case AiResponseStarted() when started != null:
return started(_that);case AiTextDelta() when textDelta != null:
return textDelta(_that);case AiReasoningDelta() when reasoningDelta != null:
return reasoningDelta(_that);case AiToolCallDelta() when toolCallDelta != null:
return toolCallDelta(_that);case AiUsageUpdated() when usage != null:
return usage(_that);case AiResponseCompleted() when completed != null:
return completed(_that);case AiResponseFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String requestId,  int sequence)?  started,TResult Function( String requestId,  int sequence,  String itemId,  String delta)?  textDelta,TResult Function( String requestId,  int sequence,  String itemId,  String delta)?  reasoningDelta,TResult Function( String requestId,  int sequence,  int index,  String? toolCallId,  String? name,  String? argumentsDelta)?  toolCallDelta,TResult Function( String requestId,  int sequence,  AiUsage value)?  usage,TResult Function( String requestId,  int sequence,  AiFinishReason reason)?  completed,TResult Function( String requestId,  int sequence,  AiFailure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AiResponseStarted() when started != null:
return started(_that.requestId,_that.sequence);case AiTextDelta() when textDelta != null:
return textDelta(_that.requestId,_that.sequence,_that.itemId,_that.delta);case AiReasoningDelta() when reasoningDelta != null:
return reasoningDelta(_that.requestId,_that.sequence,_that.itemId,_that.delta);case AiToolCallDelta() when toolCallDelta != null:
return toolCallDelta(_that.requestId,_that.sequence,_that.index,_that.toolCallId,_that.name,_that.argumentsDelta);case AiUsageUpdated() when usage != null:
return usage(_that.requestId,_that.sequence,_that.value);case AiResponseCompleted() when completed != null:
return completed(_that.requestId,_that.sequence,_that.reason);case AiResponseFailed() when failed != null:
return failed(_that.requestId,_that.sequence,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String requestId,  int sequence)  started,required TResult Function( String requestId,  int sequence,  String itemId,  String delta)  textDelta,required TResult Function( String requestId,  int sequence,  String itemId,  String delta)  reasoningDelta,required TResult Function( String requestId,  int sequence,  int index,  String? toolCallId,  String? name,  String? argumentsDelta)  toolCallDelta,required TResult Function( String requestId,  int sequence,  AiUsage value)  usage,required TResult Function( String requestId,  int sequence,  AiFinishReason reason)  completed,required TResult Function( String requestId,  int sequence,  AiFailure failure)  failed,}) {final _that = this;
switch (_that) {
case AiResponseStarted():
return started(_that.requestId,_that.sequence);case AiTextDelta():
return textDelta(_that.requestId,_that.sequence,_that.itemId,_that.delta);case AiReasoningDelta():
return reasoningDelta(_that.requestId,_that.sequence,_that.itemId,_that.delta);case AiToolCallDelta():
return toolCallDelta(_that.requestId,_that.sequence,_that.index,_that.toolCallId,_that.name,_that.argumentsDelta);case AiUsageUpdated():
return usage(_that.requestId,_that.sequence,_that.value);case AiResponseCompleted():
return completed(_that.requestId,_that.sequence,_that.reason);case AiResponseFailed():
return failed(_that.requestId,_that.sequence,_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String requestId,  int sequence)?  started,TResult? Function( String requestId,  int sequence,  String itemId,  String delta)?  textDelta,TResult? Function( String requestId,  int sequence,  String itemId,  String delta)?  reasoningDelta,TResult? Function( String requestId,  int sequence,  int index,  String? toolCallId,  String? name,  String? argumentsDelta)?  toolCallDelta,TResult? Function( String requestId,  int sequence,  AiUsage value)?  usage,TResult? Function( String requestId,  int sequence,  AiFinishReason reason)?  completed,TResult? Function( String requestId,  int sequence,  AiFailure failure)?  failed,}) {final _that = this;
switch (_that) {
case AiResponseStarted() when started != null:
return started(_that.requestId,_that.sequence);case AiTextDelta() when textDelta != null:
return textDelta(_that.requestId,_that.sequence,_that.itemId,_that.delta);case AiReasoningDelta() when reasoningDelta != null:
return reasoningDelta(_that.requestId,_that.sequence,_that.itemId,_that.delta);case AiToolCallDelta() when toolCallDelta != null:
return toolCallDelta(_that.requestId,_that.sequence,_that.index,_that.toolCallId,_that.name,_that.argumentsDelta);case AiUsageUpdated() when usage != null:
return usage(_that.requestId,_that.sequence,_that.value);case AiResponseCompleted() when completed != null:
return completed(_that.requestId,_that.sequence,_that.reason);case AiResponseFailed() when failed != null:
return failed(_that.requestId,_that.sequence,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class AiResponseStarted extends AiStreamEvent {
  const AiResponseStarted({required this.requestId, required this.sequence}): super._();
  

@override final  String requestId;
@override final  int sequence;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiResponseStartedCopyWith<AiResponseStarted> get copyWith => _$AiResponseStartedCopyWithImpl<AiResponseStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiResponseStarted&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence);

@override
String toString() {
  return 'AiStreamEvent.started(requestId: $requestId, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class $AiResponseStartedCopyWith<$Res> implements $AiStreamEventCopyWith<$Res> {
  factory $AiResponseStartedCopyWith(AiResponseStarted value, $Res Function(AiResponseStarted) _then) = _$AiResponseStartedCopyWithImpl;
@override @useResult
$Res call({
 String requestId, int sequence
});




}
/// @nodoc
class _$AiResponseStartedCopyWithImpl<$Res>
    implements $AiResponseStartedCopyWith<$Res> {
  _$AiResponseStartedCopyWithImpl(this._self, this._then);

  final AiResponseStarted _self;
  final $Res Function(AiResponseStarted) _then;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? sequence = null,}) {
  return _then(AiResponseStarted(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class AiTextDelta extends AiStreamEvent {
  const AiTextDelta({required this.requestId, required this.sequence, required this.itemId, required this.delta}): super._();
  

@override final  String requestId;
@override final  int sequence;
 final  String itemId;
 final  String delta;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiTextDeltaCopyWith<AiTextDelta> get copyWith => _$AiTextDeltaCopyWithImpl<AiTextDelta>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiTextDelta&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.delta, delta) || other.delta == delta));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence,itemId,delta);

@override
String toString() {
  return 'AiStreamEvent.textDelta(requestId: $requestId, sequence: $sequence, itemId: $itemId, delta: $delta)';
}


}

/// @nodoc
abstract mixin class $AiTextDeltaCopyWith<$Res> implements $AiStreamEventCopyWith<$Res> {
  factory $AiTextDeltaCopyWith(AiTextDelta value, $Res Function(AiTextDelta) _then) = _$AiTextDeltaCopyWithImpl;
@override @useResult
$Res call({
 String requestId, int sequence, String itemId, String delta
});




}
/// @nodoc
class _$AiTextDeltaCopyWithImpl<$Res>
    implements $AiTextDeltaCopyWith<$Res> {
  _$AiTextDeltaCopyWithImpl(this._self, this._then);

  final AiTextDelta _self;
  final $Res Function(AiTextDelta) _then;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? sequence = null,Object? itemId = null,Object? delta = null,}) {
  return _then(AiTextDelta(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AiReasoningDelta extends AiStreamEvent {
  const AiReasoningDelta({required this.requestId, required this.sequence, required this.itemId, required this.delta}): super._();
  

@override final  String requestId;
@override final  int sequence;
 final  String itemId;
 final  String delta;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiReasoningDeltaCopyWith<AiReasoningDelta> get copyWith => _$AiReasoningDeltaCopyWithImpl<AiReasoningDelta>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiReasoningDelta&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.delta, delta) || other.delta == delta));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence,itemId,delta);

@override
String toString() {
  return 'AiStreamEvent.reasoningDelta(requestId: $requestId, sequence: $sequence, itemId: $itemId, delta: $delta)';
}


}

/// @nodoc
abstract mixin class $AiReasoningDeltaCopyWith<$Res> implements $AiStreamEventCopyWith<$Res> {
  factory $AiReasoningDeltaCopyWith(AiReasoningDelta value, $Res Function(AiReasoningDelta) _then) = _$AiReasoningDeltaCopyWithImpl;
@override @useResult
$Res call({
 String requestId, int sequence, String itemId, String delta
});




}
/// @nodoc
class _$AiReasoningDeltaCopyWithImpl<$Res>
    implements $AiReasoningDeltaCopyWith<$Res> {
  _$AiReasoningDeltaCopyWithImpl(this._self, this._then);

  final AiReasoningDelta _self;
  final $Res Function(AiReasoningDelta) _then;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? sequence = null,Object? itemId = null,Object? delta = null,}) {
  return _then(AiReasoningDelta(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AiToolCallDelta extends AiStreamEvent {
  const AiToolCallDelta({required this.requestId, required this.sequence, required this.index, this.toolCallId, this.name, this.argumentsDelta}): super._();
  

@override final  String requestId;
@override final  int sequence;
 final  int index;
 final  String? toolCallId;
 final  String? name;
 final  String? argumentsDelta;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolCallDeltaCopyWith<AiToolCallDelta> get copyWith => _$AiToolCallDeltaCopyWithImpl<AiToolCallDelta>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolCallDelta&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.index, index) || other.index == index)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.name, name) || other.name == name)&&(identical(other.argumentsDelta, argumentsDelta) || other.argumentsDelta == argumentsDelta));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence,index,toolCallId,name,argumentsDelta);

@override
String toString() {
  return 'AiStreamEvent.toolCallDelta(requestId: $requestId, sequence: $sequence, index: $index, toolCallId: $toolCallId, name: $name, argumentsDelta: $argumentsDelta)';
}


}

/// @nodoc
abstract mixin class $AiToolCallDeltaCopyWith<$Res> implements $AiStreamEventCopyWith<$Res> {
  factory $AiToolCallDeltaCopyWith(AiToolCallDelta value, $Res Function(AiToolCallDelta) _then) = _$AiToolCallDeltaCopyWithImpl;
@override @useResult
$Res call({
 String requestId, int sequence, int index, String? toolCallId, String? name, String? argumentsDelta
});




}
/// @nodoc
class _$AiToolCallDeltaCopyWithImpl<$Res>
    implements $AiToolCallDeltaCopyWith<$Res> {
  _$AiToolCallDeltaCopyWithImpl(this._self, this._then);

  final AiToolCallDelta _self;
  final $Res Function(AiToolCallDelta) _then;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? sequence = null,Object? index = null,Object? toolCallId = freezed,Object? name = freezed,Object? argumentsDelta = freezed,}) {
  return _then(AiToolCallDelta(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,argumentsDelta: freezed == argumentsDelta ? _self.argumentsDelta : argumentsDelta // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class AiUsageUpdated extends AiStreamEvent {
  const AiUsageUpdated({required this.requestId, required this.sequence, required this.value}): super._();
  

@override final  String requestId;
@override final  int sequence;
 final  AiUsage value;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiUsageUpdatedCopyWith<AiUsageUpdated> get copyWith => _$AiUsageUpdatedCopyWithImpl<AiUsageUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiUsageUpdated&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence,value);

@override
String toString() {
  return 'AiStreamEvent.usage(requestId: $requestId, sequence: $sequence, value: $value)';
}


}

/// @nodoc
abstract mixin class $AiUsageUpdatedCopyWith<$Res> implements $AiStreamEventCopyWith<$Res> {
  factory $AiUsageUpdatedCopyWith(AiUsageUpdated value, $Res Function(AiUsageUpdated) _then) = _$AiUsageUpdatedCopyWithImpl;
@override @useResult
$Res call({
 String requestId, int sequence, AiUsage value
});


$AiUsageCopyWith<$Res> get value;

}
/// @nodoc
class _$AiUsageUpdatedCopyWithImpl<$Res>
    implements $AiUsageUpdatedCopyWith<$Res> {
  _$AiUsageUpdatedCopyWithImpl(this._self, this._then);

  final AiUsageUpdated _self;
  final $Res Function(AiUsageUpdated) _then;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? sequence = null,Object? value = null,}) {
  return _then(AiUsageUpdated(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as AiUsage,
  ));
}

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiUsageCopyWith<$Res> get value {
  
  return $AiUsageCopyWith<$Res>(_self.value, (value) {
    return _then(_self.copyWith(value: value));
  });
}
}

/// @nodoc


class AiResponseCompleted extends AiStreamEvent {
  const AiResponseCompleted({required this.requestId, required this.sequence, required this.reason}): super._();
  

@override final  String requestId;
@override final  int sequence;
 final  AiFinishReason reason;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiResponseCompletedCopyWith<AiResponseCompleted> get copyWith => _$AiResponseCompletedCopyWithImpl<AiResponseCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiResponseCompleted&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence,reason);

@override
String toString() {
  return 'AiStreamEvent.completed(requestId: $requestId, sequence: $sequence, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AiResponseCompletedCopyWith<$Res> implements $AiStreamEventCopyWith<$Res> {
  factory $AiResponseCompletedCopyWith(AiResponseCompleted value, $Res Function(AiResponseCompleted) _then) = _$AiResponseCompletedCopyWithImpl;
@override @useResult
$Res call({
 String requestId, int sequence, AiFinishReason reason
});




}
/// @nodoc
class _$AiResponseCompletedCopyWithImpl<$Res>
    implements $AiResponseCompletedCopyWith<$Res> {
  _$AiResponseCompletedCopyWithImpl(this._self, this._then);

  final AiResponseCompleted _self;
  final $Res Function(AiResponseCompleted) _then;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? sequence = null,Object? reason = null,}) {
  return _then(AiResponseCompleted(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as AiFinishReason,
  ));
}


}

/// @nodoc


class AiResponseFailed extends AiStreamEvent {
  const AiResponseFailed({required this.requestId, required this.sequence, required this.failure}): super._();
  

@override final  String requestId;
@override final  int sequence;
 final  AiFailure failure;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiResponseFailedCopyWith<AiResponseFailed> get copyWith => _$AiResponseFailedCopyWithImpl<AiResponseFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiResponseFailed&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence,failure);

@override
String toString() {
  return 'AiStreamEvent.failed(requestId: $requestId, sequence: $sequence, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AiResponseFailedCopyWith<$Res> implements $AiStreamEventCopyWith<$Res> {
  factory $AiResponseFailedCopyWith(AiResponseFailed value, $Res Function(AiResponseFailed) _then) = _$AiResponseFailedCopyWithImpl;
@override @useResult
$Res call({
 String requestId, int sequence, AiFailure failure
});


$AiFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$AiResponseFailedCopyWithImpl<$Res>
    implements $AiResponseFailedCopyWith<$Res> {
  _$AiResponseFailedCopyWithImpl(this._self, this._then);

  final AiResponseFailed _self;
  final $Res Function(AiResponseFailed) _then;

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? sequence = null,Object? failure = null,}) {
  return _then(AiResponseFailed(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailure,
  ));
}

/// Create a copy of AiStreamEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiFailureCopyWith<$Res> get failure {
  
  return $AiFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
