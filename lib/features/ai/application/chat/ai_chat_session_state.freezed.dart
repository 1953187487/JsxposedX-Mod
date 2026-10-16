// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_chat_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiChatSessionState {

 String get conversationId; AiConversation? get conversation; AiAssistantProfile? get assistant; AiProviderConnection? get connection; AiModelDefinition? get model; List<AiMessage> get messages; AiChatSessionPhase get phase; bool get hasOlderMessages; bool get isLoadingOlderMessages; String? get activeRequestId; String? get activeAssistantMessageId; AiStreamSnapshot? get runSnapshot; AiFailure? get failure;
/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiChatSessionStateCopyWith<AiChatSessionState> get copyWith => _$AiChatSessionStateCopyWithImpl<AiChatSessionState>(this as AiChatSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiChatSessionState&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.conversation, conversation) || other.conversation == conversation)&&(identical(other.assistant, assistant) || other.assistant == assistant)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.hasOlderMessages, hasOlderMessages) || other.hasOlderMessages == hasOlderMessages)&&(identical(other.isLoadingOlderMessages, isLoadingOlderMessages) || other.isLoadingOlderMessages == isLoadingOlderMessages)&&(identical(other.activeRequestId, activeRequestId) || other.activeRequestId == activeRequestId)&&(identical(other.activeAssistantMessageId, activeAssistantMessageId) || other.activeAssistantMessageId == activeAssistantMessageId)&&(identical(other.runSnapshot, runSnapshot) || other.runSnapshot == runSnapshot)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,conversationId,conversation,assistant,connection,model,const DeepCollectionEquality().hash(messages),phase,hasOlderMessages,isLoadingOlderMessages,activeRequestId,activeAssistantMessageId,runSnapshot,failure);

@override
String toString() {
  return 'AiChatSessionState(conversationId: $conversationId, conversation: $conversation, assistant: $assistant, connection: $connection, model: $model, messages: $messages, phase: $phase, hasOlderMessages: $hasOlderMessages, isLoadingOlderMessages: $isLoadingOlderMessages, activeRequestId: $activeRequestId, activeAssistantMessageId: $activeAssistantMessageId, runSnapshot: $runSnapshot, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AiChatSessionStateCopyWith<$Res>  {
  factory $AiChatSessionStateCopyWith(AiChatSessionState value, $Res Function(AiChatSessionState) _then) = _$AiChatSessionStateCopyWithImpl;
@useResult
$Res call({
 String conversationId, AiConversation? conversation, AiAssistantProfile? assistant, AiProviderConnection? connection, AiModelDefinition? model, List<AiMessage> messages, AiChatSessionPhase phase, bool hasOlderMessages, bool isLoadingOlderMessages, String? activeRequestId, String? activeAssistantMessageId, AiStreamSnapshot? runSnapshot, AiFailure? failure
});


$AiConversationCopyWith<$Res>? get conversation;$AiAssistantProfileCopyWith<$Res>? get assistant;$AiProviderConnectionCopyWith<$Res>? get connection;$AiModelDefinitionCopyWith<$Res>? get model;$AiStreamSnapshotCopyWith<$Res>? get runSnapshot;$AiFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$AiChatSessionStateCopyWithImpl<$Res>
    implements $AiChatSessionStateCopyWith<$Res> {
  _$AiChatSessionStateCopyWithImpl(this._self, this._then);

  final AiChatSessionState _self;
  final $Res Function(AiChatSessionState) _then;

/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? conversation = freezed,Object? assistant = freezed,Object? connection = freezed,Object? model = freezed,Object? messages = null,Object? phase = null,Object? hasOlderMessages = null,Object? isLoadingOlderMessages = null,Object? activeRequestId = freezed,Object? activeAssistantMessageId = freezed,Object? runSnapshot = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,conversation: freezed == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as AiConversation?,assistant: freezed == assistant ? _self.assistant : assistant // ignore: cast_nullable_to_non_nullable
as AiAssistantProfile?,connection: freezed == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AiProviderConnection?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as AiModelDefinition?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as AiChatSessionPhase,hasOlderMessages: null == hasOlderMessages ? _self.hasOlderMessages : hasOlderMessages // ignore: cast_nullable_to_non_nullable
as bool,isLoadingOlderMessages: null == isLoadingOlderMessages ? _self.isLoadingOlderMessages : isLoadingOlderMessages // ignore: cast_nullable_to_non_nullable
as bool,activeRequestId: freezed == activeRequestId ? _self.activeRequestId : activeRequestId // ignore: cast_nullable_to_non_nullable
as String?,activeAssistantMessageId: freezed == activeAssistantMessageId ? _self.activeAssistantMessageId : activeAssistantMessageId // ignore: cast_nullable_to_non_nullable
as String?,runSnapshot: freezed == runSnapshot ? _self.runSnapshot : runSnapshot // ignore: cast_nullable_to_non_nullable
as AiStreamSnapshot?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailure?,
  ));
}
/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiConversationCopyWith<$Res>? get conversation {
    if (_self.conversation == null) {
    return null;
  }

  return $AiConversationCopyWith<$Res>(_self.conversation!, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiAssistantProfileCopyWith<$Res>? get assistant {
    if (_self.assistant == null) {
    return null;
  }

  return $AiAssistantProfileCopyWith<$Res>(_self.assistant!, (value) {
    return _then(_self.copyWith(assistant: value));
  });
}/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiProviderConnectionCopyWith<$Res>? get connection {
    if (_self.connection == null) {
    return null;
  }

  return $AiProviderConnectionCopyWith<$Res>(_self.connection!, (value) {
    return _then(_self.copyWith(connection: value));
  });
}/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelDefinitionCopyWith<$Res>? get model {
    if (_self.model == null) {
    return null;
  }

  return $AiModelDefinitionCopyWith<$Res>(_self.model!, (value) {
    return _then(_self.copyWith(model: value));
  });
}/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiStreamSnapshotCopyWith<$Res>? get runSnapshot {
    if (_self.runSnapshot == null) {
    return null;
  }

  return $AiStreamSnapshotCopyWith<$Res>(_self.runSnapshot!, (value) {
    return _then(_self.copyWith(runSnapshot: value));
  });
}/// Create a copy of AiChatSessionState
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
}
}


/// Adds pattern-matching-related methods to [AiChatSessionState].
extension AiChatSessionStatePatterns on AiChatSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiChatSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiChatSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiChatSessionState value)  $default,){
final _that = this;
switch (_that) {
case _AiChatSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiChatSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _AiChatSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String conversationId,  AiConversation? conversation,  AiAssistantProfile? assistant,  AiProviderConnection? connection,  AiModelDefinition? model,  List<AiMessage> messages,  AiChatSessionPhase phase,  bool hasOlderMessages,  bool isLoadingOlderMessages,  String? activeRequestId,  String? activeAssistantMessageId,  AiStreamSnapshot? runSnapshot,  AiFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiChatSessionState() when $default != null:
return $default(_that.conversationId,_that.conversation,_that.assistant,_that.connection,_that.model,_that.messages,_that.phase,_that.hasOlderMessages,_that.isLoadingOlderMessages,_that.activeRequestId,_that.activeAssistantMessageId,_that.runSnapshot,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String conversationId,  AiConversation? conversation,  AiAssistantProfile? assistant,  AiProviderConnection? connection,  AiModelDefinition? model,  List<AiMessage> messages,  AiChatSessionPhase phase,  bool hasOlderMessages,  bool isLoadingOlderMessages,  String? activeRequestId,  String? activeAssistantMessageId,  AiStreamSnapshot? runSnapshot,  AiFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _AiChatSessionState():
return $default(_that.conversationId,_that.conversation,_that.assistant,_that.connection,_that.model,_that.messages,_that.phase,_that.hasOlderMessages,_that.isLoadingOlderMessages,_that.activeRequestId,_that.activeAssistantMessageId,_that.runSnapshot,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String conversationId,  AiConversation? conversation,  AiAssistantProfile? assistant,  AiProviderConnection? connection,  AiModelDefinition? model,  List<AiMessage> messages,  AiChatSessionPhase phase,  bool hasOlderMessages,  bool isLoadingOlderMessages,  String? activeRequestId,  String? activeAssistantMessageId,  AiStreamSnapshot? runSnapshot,  AiFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AiChatSessionState() when $default != null:
return $default(_that.conversationId,_that.conversation,_that.assistant,_that.connection,_that.model,_that.messages,_that.phase,_that.hasOlderMessages,_that.isLoadingOlderMessages,_that.activeRequestId,_that.activeAssistantMessageId,_that.runSnapshot,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AiChatSessionState extends AiChatSessionState {
  const _AiChatSessionState({required this.conversationId, this.conversation, this.assistant, this.connection, this.model, final  List<AiMessage> messages = const <AiMessage>[], this.phase = AiChatSessionPhase.loading, this.hasOlderMessages = false, this.isLoadingOlderMessages = false, this.activeRequestId, this.activeAssistantMessageId, this.runSnapshot, this.failure}): _messages = messages,super._();
  

@override final  String conversationId;
@override final  AiConversation? conversation;
@override final  AiAssistantProfile? assistant;
@override final  AiProviderConnection? connection;
@override final  AiModelDefinition? model;
 final  List<AiMessage> _messages;
@override@JsonKey() List<AiMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  AiChatSessionPhase phase;
@override@JsonKey() final  bool hasOlderMessages;
@override@JsonKey() final  bool isLoadingOlderMessages;
@override final  String? activeRequestId;
@override final  String? activeAssistantMessageId;
@override final  AiStreamSnapshot? runSnapshot;
@override final  AiFailure? failure;

/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiChatSessionStateCopyWith<_AiChatSessionState> get copyWith => __$AiChatSessionStateCopyWithImpl<_AiChatSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiChatSessionState&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.conversation, conversation) || other.conversation == conversation)&&(identical(other.assistant, assistant) || other.assistant == assistant)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.hasOlderMessages, hasOlderMessages) || other.hasOlderMessages == hasOlderMessages)&&(identical(other.isLoadingOlderMessages, isLoadingOlderMessages) || other.isLoadingOlderMessages == isLoadingOlderMessages)&&(identical(other.activeRequestId, activeRequestId) || other.activeRequestId == activeRequestId)&&(identical(other.activeAssistantMessageId, activeAssistantMessageId) || other.activeAssistantMessageId == activeAssistantMessageId)&&(identical(other.runSnapshot, runSnapshot) || other.runSnapshot == runSnapshot)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,conversationId,conversation,assistant,connection,model,const DeepCollectionEquality().hash(_messages),phase,hasOlderMessages,isLoadingOlderMessages,activeRequestId,activeAssistantMessageId,runSnapshot,failure);

@override
String toString() {
  return 'AiChatSessionState(conversationId: $conversationId, conversation: $conversation, assistant: $assistant, connection: $connection, model: $model, messages: $messages, phase: $phase, hasOlderMessages: $hasOlderMessages, isLoadingOlderMessages: $isLoadingOlderMessages, activeRequestId: $activeRequestId, activeAssistantMessageId: $activeAssistantMessageId, runSnapshot: $runSnapshot, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AiChatSessionStateCopyWith<$Res> implements $AiChatSessionStateCopyWith<$Res> {
  factory _$AiChatSessionStateCopyWith(_AiChatSessionState value, $Res Function(_AiChatSessionState) _then) = __$AiChatSessionStateCopyWithImpl;
@override @useResult
$Res call({
 String conversationId, AiConversation? conversation, AiAssistantProfile? assistant, AiProviderConnection? connection, AiModelDefinition? model, List<AiMessage> messages, AiChatSessionPhase phase, bool hasOlderMessages, bool isLoadingOlderMessages, String? activeRequestId, String? activeAssistantMessageId, AiStreamSnapshot? runSnapshot, AiFailure? failure
});


@override $AiConversationCopyWith<$Res>? get conversation;@override $AiAssistantProfileCopyWith<$Res>? get assistant;@override $AiProviderConnectionCopyWith<$Res>? get connection;@override $AiModelDefinitionCopyWith<$Res>? get model;@override $AiStreamSnapshotCopyWith<$Res>? get runSnapshot;@override $AiFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$AiChatSessionStateCopyWithImpl<$Res>
    implements _$AiChatSessionStateCopyWith<$Res> {
  __$AiChatSessionStateCopyWithImpl(this._self, this._then);

  final _AiChatSessionState _self;
  final $Res Function(_AiChatSessionState) _then;

/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? conversation = freezed,Object? assistant = freezed,Object? connection = freezed,Object? model = freezed,Object? messages = null,Object? phase = null,Object? hasOlderMessages = null,Object? isLoadingOlderMessages = null,Object? activeRequestId = freezed,Object? activeAssistantMessageId = freezed,Object? runSnapshot = freezed,Object? failure = freezed,}) {
  return _then(_AiChatSessionState(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,conversation: freezed == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as AiConversation?,assistant: freezed == assistant ? _self.assistant : assistant // ignore: cast_nullable_to_non_nullable
as AiAssistantProfile?,connection: freezed == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AiProviderConnection?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as AiModelDefinition?,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as AiChatSessionPhase,hasOlderMessages: null == hasOlderMessages ? _self.hasOlderMessages : hasOlderMessages // ignore: cast_nullable_to_non_nullable
as bool,isLoadingOlderMessages: null == isLoadingOlderMessages ? _self.isLoadingOlderMessages : isLoadingOlderMessages // ignore: cast_nullable_to_non_nullable
as bool,activeRequestId: freezed == activeRequestId ? _self.activeRequestId : activeRequestId // ignore: cast_nullable_to_non_nullable
as String?,activeAssistantMessageId: freezed == activeAssistantMessageId ? _self.activeAssistantMessageId : activeAssistantMessageId // ignore: cast_nullable_to_non_nullable
as String?,runSnapshot: freezed == runSnapshot ? _self.runSnapshot : runSnapshot // ignore: cast_nullable_to_non_nullable
as AiStreamSnapshot?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailure?,
  ));
}

/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiConversationCopyWith<$Res>? get conversation {
    if (_self.conversation == null) {
    return null;
  }

  return $AiConversationCopyWith<$Res>(_self.conversation!, (value) {
    return _then(_self.copyWith(conversation: value));
  });
}/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiAssistantProfileCopyWith<$Res>? get assistant {
    if (_self.assistant == null) {
    return null;
  }

  return $AiAssistantProfileCopyWith<$Res>(_self.assistant!, (value) {
    return _then(_self.copyWith(assistant: value));
  });
}/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiProviderConnectionCopyWith<$Res>? get connection {
    if (_self.connection == null) {
    return null;
  }

  return $AiProviderConnectionCopyWith<$Res>(_self.connection!, (value) {
    return _then(_self.copyWith(connection: value));
  });
}/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelDefinitionCopyWith<$Res>? get model {
    if (_self.model == null) {
    return null;
  }

  return $AiModelDefinitionCopyWith<$Res>(_self.model!, (value) {
    return _then(_self.copyWith(model: value));
  });
}/// Create a copy of AiChatSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiStreamSnapshotCopyWith<$Res>? get runSnapshot {
    if (_self.runSnapshot == null) {
    return null;
  }

  return $AiStreamSnapshotCopyWith<$Res>(_self.runSnapshot!, (value) {
    return _then(_self.copyWith(runSnapshot: value));
  });
}/// Create a copy of AiChatSessionState
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
}
}

// dart format on
