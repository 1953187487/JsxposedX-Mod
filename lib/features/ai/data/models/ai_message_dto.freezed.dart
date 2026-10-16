// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiMessageDto {

@JsonKey(includeFromJson: false, includeToJson: false) String? get id; String get role; String get content;@JsonKey(name: 'reasoning_content', includeIfNull: false) String? get reasoningContent;@JsonKey(includeFromJson: false, includeToJson: false) bool get isThinking;@JsonKey(name: 'tool_calls', includeIfNull: false) List<Map<String, dynamic>>? get toolCalls;@JsonKey(name: 'tool_call_id', includeIfNull: false) String? get toolCallId;@JsonKey(includeFromJson: false, includeToJson: false) bool get isError;@JsonKey(includeFromJson: false, includeToJson: false) bool get isToolResultBubble;
/// Create a copy of AiMessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiMessageDtoCopyWith<AiMessageDto> get copyWith => _$AiMessageDtoCopyWithImpl<AiMessageDto>(this as AiMessageDto, _$identity);

  /// Serializes this AiMessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiMessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.reasoningContent, reasoningContent) || other.reasoningContent == reasoningContent)&&(identical(other.isThinking, isThinking) || other.isThinking == isThinking)&&const DeepCollectionEquality().equals(other.toolCalls, toolCalls)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isToolResultBubble, isToolResultBubble) || other.isToolResultBubble == isToolResultBubble));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,content,reasoningContent,isThinking,const DeepCollectionEquality().hash(toolCalls),toolCallId,isError,isToolResultBubble);

@override
String toString() {
  return 'AiMessageDto(id: $id, role: $role, content: $content, reasoningContent: $reasoningContent, isThinking: $isThinking, toolCalls: $toolCalls, toolCallId: $toolCallId, isError: $isError, isToolResultBubble: $isToolResultBubble)';
}


}

/// @nodoc
abstract mixin class $AiMessageDtoCopyWith<$Res>  {
  factory $AiMessageDtoCopyWith(AiMessageDto value, $Res Function(AiMessageDto) _then) = _$AiMessageDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String? id, String role, String content,@JsonKey(name: 'reasoning_content', includeIfNull: false) String? reasoningContent,@JsonKey(includeFromJson: false, includeToJson: false) bool isThinking,@JsonKey(name: 'tool_calls', includeIfNull: false) List<Map<String, dynamic>>? toolCalls,@JsonKey(name: 'tool_call_id', includeIfNull: false) String? toolCallId,@JsonKey(includeFromJson: false, includeToJson: false) bool isError,@JsonKey(includeFromJson: false, includeToJson: false) bool isToolResultBubble
});




}
/// @nodoc
class _$AiMessageDtoCopyWithImpl<$Res>
    implements $AiMessageDtoCopyWith<$Res> {
  _$AiMessageDtoCopyWithImpl(this._self, this._then);

  final AiMessageDto _self;
  final $Res Function(AiMessageDto) _then;

/// Create a copy of AiMessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? role = null,Object? content = null,Object? reasoningContent = freezed,Object? isThinking = null,Object? toolCalls = freezed,Object? toolCallId = freezed,Object? isError = null,Object? isToolResultBubble = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,reasoningContent: freezed == reasoningContent ? _self.reasoningContent : reasoningContent // ignore: cast_nullable_to_non_nullable
as String?,isThinking: null == isThinking ? _self.isThinking : isThinking // ignore: cast_nullable_to_non_nullable
as bool,toolCalls: freezed == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isToolResultBubble: null == isToolResultBubble ? _self.isToolResultBubble : isToolResultBubble // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiMessageDto].
extension AiMessageDtoPatterns on AiMessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiMessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiMessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiMessageDto value)  $default,){
final _that = this;
switch (_that) {
case _AiMessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiMessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiMessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String role,  String content, @JsonKey(name: 'reasoning_content', includeIfNull: false)  String? reasoningContent, @JsonKey(includeFromJson: false, includeToJson: false)  bool isThinking, @JsonKey(name: 'tool_calls', includeIfNull: false)  List<Map<String, dynamic>>? toolCalls, @JsonKey(name: 'tool_call_id', includeIfNull: false)  String? toolCallId, @JsonKey(includeFromJson: false, includeToJson: false)  bool isError, @JsonKey(includeFromJson: false, includeToJson: false)  bool isToolResultBubble)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiMessageDto() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.isThinking,_that.toolCalls,_that.toolCallId,_that.isError,_that.isToolResultBubble);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String role,  String content, @JsonKey(name: 'reasoning_content', includeIfNull: false)  String? reasoningContent, @JsonKey(includeFromJson: false, includeToJson: false)  bool isThinking, @JsonKey(name: 'tool_calls', includeIfNull: false)  List<Map<String, dynamic>>? toolCalls, @JsonKey(name: 'tool_call_id', includeIfNull: false)  String? toolCallId, @JsonKey(includeFromJson: false, includeToJson: false)  bool isError, @JsonKey(includeFromJson: false, includeToJson: false)  bool isToolResultBubble)  $default,) {final _that = this;
switch (_that) {
case _AiMessageDto():
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.isThinking,_that.toolCalls,_that.toolCallId,_that.isError,_that.isToolResultBubble);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeFromJson: false, includeToJson: false)  String? id,  String role,  String content, @JsonKey(name: 'reasoning_content', includeIfNull: false)  String? reasoningContent, @JsonKey(includeFromJson: false, includeToJson: false)  bool isThinking, @JsonKey(name: 'tool_calls', includeIfNull: false)  List<Map<String, dynamic>>? toolCalls, @JsonKey(name: 'tool_call_id', includeIfNull: false)  String? toolCallId, @JsonKey(includeFromJson: false, includeToJson: false)  bool isError, @JsonKey(includeFromJson: false, includeToJson: false)  bool isToolResultBubble)?  $default,) {final _that = this;
switch (_that) {
case _AiMessageDto() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.isThinking,_that.toolCalls,_that.toolCallId,_that.isError,_that.isToolResultBubble);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiMessageDto extends AiMessageDto {
  const _AiMessageDto({@JsonKey(includeFromJson: false, includeToJson: false) this.id, this.role = "user", this.content = "", @JsonKey(name: 'reasoning_content', includeIfNull: false) this.reasoningContent, @JsonKey(includeFromJson: false, includeToJson: false) this.isThinking = false, @JsonKey(name: 'tool_calls', includeIfNull: false) final  List<Map<String, dynamic>>? toolCalls, @JsonKey(name: 'tool_call_id', includeIfNull: false) this.toolCallId, @JsonKey(includeFromJson: false, includeToJson: false) this.isError = false, @JsonKey(includeFromJson: false, includeToJson: false) this.isToolResultBubble = false}): _toolCalls = toolCalls,super._();
  factory _AiMessageDto.fromJson(Map<String, dynamic> json) => _$AiMessageDtoFromJson(json);

@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? id;
@override@JsonKey() final  String role;
@override@JsonKey() final  String content;
@override@JsonKey(name: 'reasoning_content', includeIfNull: false) final  String? reasoningContent;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isThinking;
 final  List<Map<String, dynamic>>? _toolCalls;
@override@JsonKey(name: 'tool_calls', includeIfNull: false) List<Map<String, dynamic>>? get toolCalls {
  final value = _toolCalls;
  if (value == null) return null;
  if (_toolCalls is EqualUnmodifiableListView) return _toolCalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'tool_call_id', includeIfNull: false) final  String? toolCallId;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isError;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isToolResultBubble;

/// Create a copy of AiMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiMessageDtoCopyWith<_AiMessageDto> get copyWith => __$AiMessageDtoCopyWithImpl<_AiMessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiMessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiMessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.reasoningContent, reasoningContent) || other.reasoningContent == reasoningContent)&&(identical(other.isThinking, isThinking) || other.isThinking == isThinking)&&const DeepCollectionEquality().equals(other._toolCalls, _toolCalls)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isToolResultBubble, isToolResultBubble) || other.isToolResultBubble == isToolResultBubble));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,content,reasoningContent,isThinking,const DeepCollectionEquality().hash(_toolCalls),toolCallId,isError,isToolResultBubble);

@override
String toString() {
  return 'AiMessageDto(id: $id, role: $role, content: $content, reasoningContent: $reasoningContent, isThinking: $isThinking, toolCalls: $toolCalls, toolCallId: $toolCallId, isError: $isError, isToolResultBubble: $isToolResultBubble)';
}


}

/// @nodoc
abstract mixin class _$AiMessageDtoCopyWith<$Res> implements $AiMessageDtoCopyWith<$Res> {
  factory _$AiMessageDtoCopyWith(_AiMessageDto value, $Res Function(_AiMessageDto) _then) = __$AiMessageDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false, includeToJson: false) String? id, String role, String content,@JsonKey(name: 'reasoning_content', includeIfNull: false) String? reasoningContent,@JsonKey(includeFromJson: false, includeToJson: false) bool isThinking,@JsonKey(name: 'tool_calls', includeIfNull: false) List<Map<String, dynamic>>? toolCalls,@JsonKey(name: 'tool_call_id', includeIfNull: false) String? toolCallId,@JsonKey(includeFromJson: false, includeToJson: false) bool isError,@JsonKey(includeFromJson: false, includeToJson: false) bool isToolResultBubble
});




}
/// @nodoc
class __$AiMessageDtoCopyWithImpl<$Res>
    implements _$AiMessageDtoCopyWith<$Res> {
  __$AiMessageDtoCopyWithImpl(this._self, this._then);

  final _AiMessageDto _self;
  final $Res Function(_AiMessageDto) _then;

/// Create a copy of AiMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? role = null,Object? content = null,Object? reasoningContent = freezed,Object? isThinking = null,Object? toolCalls = freezed,Object? toolCallId = freezed,Object? isError = null,Object? isToolResultBubble = null,}) {
  return _then(_AiMessageDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,reasoningContent: freezed == reasoningContent ? _self.reasoningContent : reasoningContent // ignore: cast_nullable_to_non_nullable
as String?,isThinking: null == isThinking ? _self.isThinking : isThinking // ignore: cast_nullable_to_non_nullable
as bool,toolCalls: freezed == toolCalls ? _self._toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isToolResultBubble: null == isToolResultBubble ? _self.isToolResultBubble : isToolResultBubble // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
