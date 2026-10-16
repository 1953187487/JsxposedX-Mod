// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_stream_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiToolCallSnapshot {

 int get index; String? get id; String get name; String get argumentsJson;
/// Create a copy of AiToolCallSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolCallSnapshotCopyWith<AiToolCallSnapshot> get copyWith => _$AiToolCallSnapshotCopyWithImpl<AiToolCallSnapshot>(this as AiToolCallSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolCallSnapshot&&(identical(other.index, index) || other.index == index)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.argumentsJson, argumentsJson) || other.argumentsJson == argumentsJson));
}


@override
int get hashCode => Object.hash(runtimeType,index,id,name,argumentsJson);

@override
String toString() {
  return 'AiToolCallSnapshot(index: $index, id: $id, name: $name, argumentsJson: $argumentsJson)';
}


}

/// @nodoc
abstract mixin class $AiToolCallSnapshotCopyWith<$Res>  {
  factory $AiToolCallSnapshotCopyWith(AiToolCallSnapshot value, $Res Function(AiToolCallSnapshot) _then) = _$AiToolCallSnapshotCopyWithImpl;
@useResult
$Res call({
 int index, String? id, String name, String argumentsJson
});




}
/// @nodoc
class _$AiToolCallSnapshotCopyWithImpl<$Res>
    implements $AiToolCallSnapshotCopyWith<$Res> {
  _$AiToolCallSnapshotCopyWithImpl(this._self, this._then);

  final AiToolCallSnapshot _self;
  final $Res Function(AiToolCallSnapshot) _then;

/// Create a copy of AiToolCallSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? id = freezed,Object? name = null,Object? argumentsJson = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,argumentsJson: null == argumentsJson ? _self.argumentsJson : argumentsJson // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiToolCallSnapshot].
extension AiToolCallSnapshotPatterns on AiToolCallSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiToolCallSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiToolCallSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiToolCallSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _AiToolCallSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiToolCallSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _AiToolCallSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String? id,  String name,  String argumentsJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiToolCallSnapshot() when $default != null:
return $default(_that.index,_that.id,_that.name,_that.argumentsJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String? id,  String name,  String argumentsJson)  $default,) {final _that = this;
switch (_that) {
case _AiToolCallSnapshot():
return $default(_that.index,_that.id,_that.name,_that.argumentsJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String? id,  String name,  String argumentsJson)?  $default,) {final _that = this;
switch (_that) {
case _AiToolCallSnapshot() when $default != null:
return $default(_that.index,_that.id,_that.name,_that.argumentsJson);case _:
  return null;

}
}

}

/// @nodoc


class _AiToolCallSnapshot implements AiToolCallSnapshot {
  const _AiToolCallSnapshot({required this.index, this.id, this.name = '', this.argumentsJson = ''});
  

@override final  int index;
@override final  String? id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String argumentsJson;

/// Create a copy of AiToolCallSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiToolCallSnapshotCopyWith<_AiToolCallSnapshot> get copyWith => __$AiToolCallSnapshotCopyWithImpl<_AiToolCallSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiToolCallSnapshot&&(identical(other.index, index) || other.index == index)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.argumentsJson, argumentsJson) || other.argumentsJson == argumentsJson));
}


@override
int get hashCode => Object.hash(runtimeType,index,id,name,argumentsJson);

@override
String toString() {
  return 'AiToolCallSnapshot(index: $index, id: $id, name: $name, argumentsJson: $argumentsJson)';
}


}

/// @nodoc
abstract mixin class _$AiToolCallSnapshotCopyWith<$Res> implements $AiToolCallSnapshotCopyWith<$Res> {
  factory _$AiToolCallSnapshotCopyWith(_AiToolCallSnapshot value, $Res Function(_AiToolCallSnapshot) _then) = __$AiToolCallSnapshotCopyWithImpl;
@override @useResult
$Res call({
 int index, String? id, String name, String argumentsJson
});




}
/// @nodoc
class __$AiToolCallSnapshotCopyWithImpl<$Res>
    implements _$AiToolCallSnapshotCopyWith<$Res> {
  __$AiToolCallSnapshotCopyWithImpl(this._self, this._then);

  final _AiToolCallSnapshot _self;
  final $Res Function(_AiToolCallSnapshot) _then;

/// Create a copy of AiToolCallSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? id = freezed,Object? name = null,Object? argumentsJson = null,}) {
  return _then(_AiToolCallSnapshot(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,argumentsJson: null == argumentsJson ? _self.argumentsJson : argumentsJson // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AiStreamSnapshot {

 String get requestId; int get sequence; AiStreamStatus get status; String get text; String get reasoning; Duration? get reasoningDuration; List<AiToolCallSnapshot> get toolCalls; AiUsage? get usage; AiFinishReason? get finishReason; AiFailure? get failure; AiTransportTrace? get transportTrace;
/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiStreamSnapshotCopyWith<AiStreamSnapshot> get copyWith => _$AiStreamSnapshotCopyWithImpl<AiStreamSnapshot>(this as AiStreamSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiStreamSnapshot&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.status, status) || other.status == status)&&(identical(other.text, text) || other.text == text)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&(identical(other.reasoningDuration, reasoningDuration) || other.reasoningDuration == reasoningDuration)&&const DeepCollectionEquality().equals(other.toolCalls, toolCalls)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.finishReason, finishReason) || other.finishReason == finishReason)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transportTrace, transportTrace) || other.transportTrace == transportTrace));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence,status,text,reasoning,reasoningDuration,const DeepCollectionEquality().hash(toolCalls),usage,finishReason,failure,transportTrace);

@override
String toString() {
  return 'AiStreamSnapshot(requestId: $requestId, sequence: $sequence, status: $status, text: $text, reasoning: $reasoning, reasoningDuration: $reasoningDuration, toolCalls: $toolCalls, usage: $usage, finishReason: $finishReason, failure: $failure, transportTrace: $transportTrace)';
}


}

/// @nodoc
abstract mixin class $AiStreamSnapshotCopyWith<$Res>  {
  factory $AiStreamSnapshotCopyWith(AiStreamSnapshot value, $Res Function(AiStreamSnapshot) _then) = _$AiStreamSnapshotCopyWithImpl;
@useResult
$Res call({
 String requestId, int sequence, AiStreamStatus status, String text, String reasoning, Duration? reasoningDuration, List<AiToolCallSnapshot> toolCalls, AiUsage? usage, AiFinishReason? finishReason, AiFailure? failure, AiTransportTrace? transportTrace
});


$AiUsageCopyWith<$Res>? get usage;$AiFailureCopyWith<$Res>? get failure;$AiTransportTraceCopyWith<$Res>? get transportTrace;

}
/// @nodoc
class _$AiStreamSnapshotCopyWithImpl<$Res>
    implements $AiStreamSnapshotCopyWith<$Res> {
  _$AiStreamSnapshotCopyWithImpl(this._self, this._then);

  final AiStreamSnapshot _self;
  final $Res Function(AiStreamSnapshot) _then;

/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? sequence = null,Object? status = null,Object? text = null,Object? reasoning = null,Object? reasoningDuration = freezed,Object? toolCalls = null,Object? usage = freezed,Object? finishReason = freezed,Object? failure = freezed,Object? transportTrace = freezed,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiStreamStatus,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as String,reasoningDuration: freezed == reasoningDuration ? _self.reasoningDuration : reasoningDuration // ignore: cast_nullable_to_non_nullable
as Duration?,toolCalls: null == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<AiToolCallSnapshot>,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as AiUsage?,finishReason: freezed == finishReason ? _self.finishReason : finishReason // ignore: cast_nullable_to_non_nullable
as AiFinishReason?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailure?,transportTrace: freezed == transportTrace ? _self.transportTrace : transportTrace // ignore: cast_nullable_to_non_nullable
as AiTransportTrace?,
  ));
}
/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiUsageCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $AiUsageCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $AiFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiTransportTraceCopyWith<$Res>? get transportTrace {
    if (_self.transportTrace == null) {
    return null;
  }

  return $AiTransportTraceCopyWith<$Res>(_self.transportTrace!, (value) {
    return _then(_self.copyWith(transportTrace: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiStreamSnapshot].
extension AiStreamSnapshotPatterns on AiStreamSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiStreamSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiStreamSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiStreamSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _AiStreamSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiStreamSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _AiStreamSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  int sequence,  AiStreamStatus status,  String text,  String reasoning,  Duration? reasoningDuration,  List<AiToolCallSnapshot> toolCalls,  AiUsage? usage,  AiFinishReason? finishReason,  AiFailure? failure,  AiTransportTrace? transportTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiStreamSnapshot() when $default != null:
return $default(_that.requestId,_that.sequence,_that.status,_that.text,_that.reasoning,_that.reasoningDuration,_that.toolCalls,_that.usage,_that.finishReason,_that.failure,_that.transportTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  int sequence,  AiStreamStatus status,  String text,  String reasoning,  Duration? reasoningDuration,  List<AiToolCallSnapshot> toolCalls,  AiUsage? usage,  AiFinishReason? finishReason,  AiFailure? failure,  AiTransportTrace? transportTrace)  $default,) {final _that = this;
switch (_that) {
case _AiStreamSnapshot():
return $default(_that.requestId,_that.sequence,_that.status,_that.text,_that.reasoning,_that.reasoningDuration,_that.toolCalls,_that.usage,_that.finishReason,_that.failure,_that.transportTrace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  int sequence,  AiStreamStatus status,  String text,  String reasoning,  Duration? reasoningDuration,  List<AiToolCallSnapshot> toolCalls,  AiUsage? usage,  AiFinishReason? finishReason,  AiFailure? failure,  AiTransportTrace? transportTrace)?  $default,) {final _that = this;
switch (_that) {
case _AiStreamSnapshot() when $default != null:
return $default(_that.requestId,_that.sequence,_that.status,_that.text,_that.reasoning,_that.reasoningDuration,_that.toolCalls,_that.usage,_that.finishReason,_that.failure,_that.transportTrace);case _:
  return null;

}
}

}

/// @nodoc


class _AiStreamSnapshot implements AiStreamSnapshot {
  const _AiStreamSnapshot({required this.requestId, this.sequence = -1, this.status = AiStreamStatus.idle, this.text = '', this.reasoning = '', this.reasoningDuration, final  List<AiToolCallSnapshot> toolCalls = const <AiToolCallSnapshot>[], this.usage, this.finishReason, this.failure, this.transportTrace}): _toolCalls = toolCalls;
  

@override final  String requestId;
@override@JsonKey() final  int sequence;
@override@JsonKey() final  AiStreamStatus status;
@override@JsonKey() final  String text;
@override@JsonKey() final  String reasoning;
@override final  Duration? reasoningDuration;
 final  List<AiToolCallSnapshot> _toolCalls;
@override@JsonKey() List<AiToolCallSnapshot> get toolCalls {
  if (_toolCalls is EqualUnmodifiableListView) return _toolCalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_toolCalls);
}

@override final  AiUsage? usage;
@override final  AiFinishReason? finishReason;
@override final  AiFailure? failure;
@override final  AiTransportTrace? transportTrace;

/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiStreamSnapshotCopyWith<_AiStreamSnapshot> get copyWith => __$AiStreamSnapshotCopyWithImpl<_AiStreamSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiStreamSnapshot&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.status, status) || other.status == status)&&(identical(other.text, text) || other.text == text)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&(identical(other.reasoningDuration, reasoningDuration) || other.reasoningDuration == reasoningDuration)&&const DeepCollectionEquality().equals(other._toolCalls, _toolCalls)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.finishReason, finishReason) || other.finishReason == finishReason)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transportTrace, transportTrace) || other.transportTrace == transportTrace));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,sequence,status,text,reasoning,reasoningDuration,const DeepCollectionEquality().hash(_toolCalls),usage,finishReason,failure,transportTrace);

@override
String toString() {
  return 'AiStreamSnapshot(requestId: $requestId, sequence: $sequence, status: $status, text: $text, reasoning: $reasoning, reasoningDuration: $reasoningDuration, toolCalls: $toolCalls, usage: $usage, finishReason: $finishReason, failure: $failure, transportTrace: $transportTrace)';
}


}

/// @nodoc
abstract mixin class _$AiStreamSnapshotCopyWith<$Res> implements $AiStreamSnapshotCopyWith<$Res> {
  factory _$AiStreamSnapshotCopyWith(_AiStreamSnapshot value, $Res Function(_AiStreamSnapshot) _then) = __$AiStreamSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String requestId, int sequence, AiStreamStatus status, String text, String reasoning, Duration? reasoningDuration, List<AiToolCallSnapshot> toolCalls, AiUsage? usage, AiFinishReason? finishReason, AiFailure? failure, AiTransportTrace? transportTrace
});


@override $AiUsageCopyWith<$Res>? get usage;@override $AiFailureCopyWith<$Res>? get failure;@override $AiTransportTraceCopyWith<$Res>? get transportTrace;

}
/// @nodoc
class __$AiStreamSnapshotCopyWithImpl<$Res>
    implements _$AiStreamSnapshotCopyWith<$Res> {
  __$AiStreamSnapshotCopyWithImpl(this._self, this._then);

  final _AiStreamSnapshot _self;
  final $Res Function(_AiStreamSnapshot) _then;

/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? sequence = null,Object? status = null,Object? text = null,Object? reasoning = null,Object? reasoningDuration = freezed,Object? toolCalls = null,Object? usage = freezed,Object? finishReason = freezed,Object? failure = freezed,Object? transportTrace = freezed,}) {
  return _then(_AiStreamSnapshot(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiStreamStatus,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as String,reasoningDuration: freezed == reasoningDuration ? _self.reasoningDuration : reasoningDuration // ignore: cast_nullable_to_non_nullable
as Duration?,toolCalls: null == toolCalls ? _self._toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<AiToolCallSnapshot>,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as AiUsage?,finishReason: freezed == finishReason ? _self.finishReason : finishReason // ignore: cast_nullable_to_non_nullable
as AiFinishReason?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailure?,transportTrace: freezed == transportTrace ? _self.transportTrace : transportTrace // ignore: cast_nullable_to_non_nullable
as AiTransportTrace?,
  ));
}

/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiUsageCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $AiUsageCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $AiFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of AiStreamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiTransportTraceCopyWith<$Res>? get transportTrace {
    if (_self.transportTrace == null) {
    return null;
  }

  return $AiTransportTraceCopyWith<$Res>(_self.transportTrace!, (value) {
    return _then(_self.copyWith(transportTrace: value));
  });
}
}

// dart format on
