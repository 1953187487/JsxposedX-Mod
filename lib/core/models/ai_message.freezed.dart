// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiMessage {

 String get id; String get role;// system, user, assistant, tool
 String get content; String? get reasoningContent; bool get isError; bool get isThinking;/// Function Calling: assistant 消息中携带的工具调用列表
 List<Map<String, dynamic>>? get toolCalls;/// Function Calling: tool 消息对应的 tool_call_id
 String? get toolCallId;/// 标记是否是工具结果气泡（UI展示用，不发送给API）
 bool get isToolResultBubble;
/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiMessageCopyWith<AiMessage> get copyWith => _$AiMessageCopyWithImpl<AiMessage>(this as AiMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.reasoningContent, reasoningContent) || other.reasoningContent == reasoningContent)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isThinking, isThinking) || other.isThinking == isThinking)&&const DeepCollectionEquality().equals(other.toolCalls, toolCalls)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.isToolResultBubble, isToolResultBubble) || other.isToolResultBubble == isToolResultBubble));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,content,reasoningContent,isError,isThinking,const DeepCollectionEquality().hash(toolCalls),toolCallId,isToolResultBubble);

@override
String toString() {
  return 'AiMessage(id: $id, role: $role, content: $content, reasoningContent: $reasoningContent, isError: $isError, isThinking: $isThinking, toolCalls: $toolCalls, toolCallId: $toolCallId, isToolResultBubble: $isToolResultBubble)';
}


}

/// @nodoc
abstract mixin class $AiMessageCopyWith<$Res>  {
  factory $AiMessageCopyWith(AiMessage value, $Res Function(AiMessage) _then) = _$AiMessageCopyWithImpl;
@useResult
$Res call({
 String id, String role, String content, String? reasoningContent, bool isError, bool isThinking, List<Map<String, dynamic>>? toolCalls, String? toolCallId, bool isToolResultBubble
});




}
/// @nodoc
class _$AiMessageCopyWithImpl<$Res>
    implements $AiMessageCopyWith<$Res> {
  _$AiMessageCopyWithImpl(this._self, this._then);

  final AiMessage _self;
  final $Res Function(AiMessage) _then;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? content = null,Object? reasoningContent = freezed,Object? isError = null,Object? isThinking = null,Object? toolCalls = freezed,Object? toolCallId = freezed,Object? isToolResultBubble = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,reasoningContent: freezed == reasoningContent ? _self.reasoningContent : reasoningContent // ignore: cast_nullable_to_non_nullable
as String?,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isThinking: null == isThinking ? _self.isThinking : isThinking // ignore: cast_nullable_to_non_nullable
as bool,toolCalls: freezed == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,isToolResultBubble: null == isToolResultBubble ? _self.isToolResultBubble : isToolResultBubble // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiMessage].
extension AiMessagePatterns on AiMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiMessage value)  $default,){
final _that = this;
switch (_that) {
case _AiMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String role,  String content,  String? reasoningContent,  bool isError,  bool isThinking,  List<Map<String, dynamic>>? toolCalls,  String? toolCallId,  bool isToolResultBubble)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.isError,_that.isThinking,_that.toolCalls,_that.toolCallId,_that.isToolResultBubble);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String role,  String content,  String? reasoningContent,  bool isError,  bool isThinking,  List<Map<String, dynamic>>? toolCalls,  String? toolCallId,  bool isToolResultBubble)  $default,) {final _that = this;
switch (_that) {
case _AiMessage():
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.isError,_that.isThinking,_that.toolCalls,_that.toolCallId,_that.isToolResultBubble);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String role,  String content,  String? reasoningContent,  bool isError,  bool isThinking,  List<Map<String, dynamic>>? toolCalls,  String? toolCallId,  bool isToolResultBubble)?  $default,) {final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.isError,_that.isThinking,_that.toolCalls,_that.toolCallId,_that.isToolResultBubble);case _:
  return null;

}
}

}

/// @nodoc


class _AiMessage extends AiMessage {
  const _AiMessage({required this.id, required this.role, required this.content, this.reasoningContent = null, this.isError = false, this.isThinking = false, final  List<Map<String, dynamic>>? toolCalls = null, this.toolCallId = null, this.isToolResultBubble = false}): _toolCalls = toolCalls,super._();
  

@override final  String id;
@override final  String role;
// system, user, assistant, tool
@override final  String content;
@override@JsonKey() final  String? reasoningContent;
@override@JsonKey() final  bool isError;
@override@JsonKey() final  bool isThinking;
/// Function Calling: assistant 消息中携带的工具调用列表
 final  List<Map<String, dynamic>>? _toolCalls;
/// Function Calling: assistant 消息中携带的工具调用列表
@override@JsonKey() List<Map<String, dynamic>>? get toolCalls {
  final value = _toolCalls;
  if (value == null) return null;
  if (_toolCalls is EqualUnmodifiableListView) return _toolCalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Function Calling: tool 消息对应的 tool_call_id
@override@JsonKey() final  String? toolCallId;
/// 标记是否是工具结果气泡（UI展示用，不发送给API）
@override@JsonKey() final  bool isToolResultBubble;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiMessageCopyWith<_AiMessage> get copyWith => __$AiMessageCopyWithImpl<_AiMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.reasoningContent, reasoningContent) || other.reasoningContent == reasoningContent)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isThinking, isThinking) || other.isThinking == isThinking)&&const DeepCollectionEquality().equals(other._toolCalls, _toolCalls)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.isToolResultBubble, isToolResultBubble) || other.isToolResultBubble == isToolResultBubble));
}


@override
int get hashCode => Object.hash(runtimeType,id,role,content,reasoningContent,isError,isThinking,const DeepCollectionEquality().hash(_toolCalls),toolCallId,isToolResultBubble);

@override
String toString() {
  return 'AiMessage(id: $id, role: $role, content: $content, reasoningContent: $reasoningContent, isError: $isError, isThinking: $isThinking, toolCalls: $toolCalls, toolCallId: $toolCallId, isToolResultBubble: $isToolResultBubble)';
}


}

/// @nodoc
abstract mixin class _$AiMessageCopyWith<$Res> implements $AiMessageCopyWith<$Res> {
  factory _$AiMessageCopyWith(_AiMessage value, $Res Function(_AiMessage) _then) = __$AiMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String role, String content, String? reasoningContent, bool isError, bool isThinking, List<Map<String, dynamic>>? toolCalls, String? toolCallId, bool isToolResultBubble
});




}
/// @nodoc
class __$AiMessageCopyWithImpl<$Res>
    implements _$AiMessageCopyWith<$Res> {
  __$AiMessageCopyWithImpl(this._self, this._then);

  final _AiMessage _self;
  final $Res Function(_AiMessage) _then;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? content = null,Object? reasoningContent = freezed,Object? isError = null,Object? isThinking = null,Object? toolCalls = freezed,Object? toolCallId = freezed,Object? isToolResultBubble = null,}) {
  return _then(_AiMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,reasoningContent: freezed == reasoningContent ? _self.reasoningContent : reasoningContent // ignore: cast_nullable_to_non_nullable
as String?,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isThinking: null == isThinking ? _self.isThinking : isThinking // ignore: cast_nullable_to_non_nullable
as bool,toolCalls: freezed == toolCalls ? _self._toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,isToolResultBubble: null == isToolResultBubble ? _self.isToolResultBubble : isToolResultBubble // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
