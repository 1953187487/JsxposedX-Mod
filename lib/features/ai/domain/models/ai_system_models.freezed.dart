// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_system_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiContentPart {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiContentPart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AiContentPart()';
}


}

/// @nodoc
class $AiContentPartCopyWith<$Res>  {
$AiContentPartCopyWith(AiContentPart _, $Res Function(AiContentPart) __);
}


/// Adds pattern-matching-related methods to [AiContentPart].
extension AiContentPartPatterns on AiContentPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AiTextPart value)?  text,TResult Function( AiReasoningPart value)?  reasoning,TResult Function( AiImagePart value)?  image,TResult Function( AiToolCallPart value)?  toolCall,TResult Function( AiToolResultPart value)?  toolResult,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AiTextPart() when text != null:
return text(_that);case AiReasoningPart() when reasoning != null:
return reasoning(_that);case AiImagePart() when image != null:
return image(_that);case AiToolCallPart() when toolCall != null:
return toolCall(_that);case AiToolResultPart() when toolResult != null:
return toolResult(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AiTextPart value)  text,required TResult Function( AiReasoningPart value)  reasoning,required TResult Function( AiImagePart value)  image,required TResult Function( AiToolCallPart value)  toolCall,required TResult Function( AiToolResultPart value)  toolResult,}){
final _that = this;
switch (_that) {
case AiTextPart():
return text(_that);case AiReasoningPart():
return reasoning(_that);case AiImagePart():
return image(_that);case AiToolCallPart():
return toolCall(_that);case AiToolResultPart():
return toolResult(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AiTextPart value)?  text,TResult? Function( AiReasoningPart value)?  reasoning,TResult? Function( AiImagePart value)?  image,TResult? Function( AiToolCallPart value)?  toolCall,TResult? Function( AiToolResultPart value)?  toolResult,}){
final _that = this;
switch (_that) {
case AiTextPart() when text != null:
return text(_that);case AiReasoningPart() when reasoning != null:
return reasoning(_that);case AiImagePart() when image != null:
return image(_that);case AiToolCallPart() when toolCall != null:
return toolCall(_that);case AiToolResultPart() when toolResult != null:
return toolResult(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  text,TResult Function( String text)?  reasoning,TResult Function( String attachmentId)?  image,TResult Function( AiToolCall toolCall)?  toolCall,TResult Function( AiToolResult toolResult)?  toolResult,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AiTextPart() when text != null:
return text(_that.text);case AiReasoningPart() when reasoning != null:
return reasoning(_that.text);case AiImagePart() when image != null:
return image(_that.attachmentId);case AiToolCallPart() when toolCall != null:
return toolCall(_that.toolCall);case AiToolResultPart() when toolResult != null:
return toolResult(_that.toolResult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  text,required TResult Function( String text)  reasoning,required TResult Function( String attachmentId)  image,required TResult Function( AiToolCall toolCall)  toolCall,required TResult Function( AiToolResult toolResult)  toolResult,}) {final _that = this;
switch (_that) {
case AiTextPart():
return text(_that.text);case AiReasoningPart():
return reasoning(_that.text);case AiImagePart():
return image(_that.attachmentId);case AiToolCallPart():
return toolCall(_that.toolCall);case AiToolResultPart():
return toolResult(_that.toolResult);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  text,TResult? Function( String text)?  reasoning,TResult? Function( String attachmentId)?  image,TResult? Function( AiToolCall toolCall)?  toolCall,TResult? Function( AiToolResult toolResult)?  toolResult,}) {final _that = this;
switch (_that) {
case AiTextPart() when text != null:
return text(_that.text);case AiReasoningPart() when reasoning != null:
return reasoning(_that.text);case AiImagePart() when image != null:
return image(_that.attachmentId);case AiToolCallPart() when toolCall != null:
return toolCall(_that.toolCall);case AiToolResultPart() when toolResult != null:
return toolResult(_that.toolResult);case _:
  return null;

}
}

}

/// @nodoc


class AiTextPart implements AiContentPart {
  const AiTextPart(this.text);
  

 final  String text;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiTextPartCopyWith<AiTextPart> get copyWith => _$AiTextPartCopyWithImpl<AiTextPart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiTextPart&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'AiContentPart.text(text: $text)';
}


}

/// @nodoc
abstract mixin class $AiTextPartCopyWith<$Res> implements $AiContentPartCopyWith<$Res> {
  factory $AiTextPartCopyWith(AiTextPart value, $Res Function(AiTextPart) _then) = _$AiTextPartCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$AiTextPartCopyWithImpl<$Res>
    implements $AiTextPartCopyWith<$Res> {
  _$AiTextPartCopyWithImpl(this._self, this._then);

  final AiTextPart _self;
  final $Res Function(AiTextPart) _then;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(AiTextPart(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AiReasoningPart implements AiContentPart {
  const AiReasoningPart(this.text);
  

 final  String text;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiReasoningPartCopyWith<AiReasoningPart> get copyWith => _$AiReasoningPartCopyWithImpl<AiReasoningPart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiReasoningPart&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'AiContentPart.reasoning(text: $text)';
}


}

/// @nodoc
abstract mixin class $AiReasoningPartCopyWith<$Res> implements $AiContentPartCopyWith<$Res> {
  factory $AiReasoningPartCopyWith(AiReasoningPart value, $Res Function(AiReasoningPart) _then) = _$AiReasoningPartCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$AiReasoningPartCopyWithImpl<$Res>
    implements $AiReasoningPartCopyWith<$Res> {
  _$AiReasoningPartCopyWithImpl(this._self, this._then);

  final AiReasoningPart _self;
  final $Res Function(AiReasoningPart) _then;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(AiReasoningPart(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AiImagePart implements AiContentPart {
  const AiImagePart({required this.attachmentId});
  

 final  String attachmentId;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiImagePartCopyWith<AiImagePart> get copyWith => _$AiImagePartCopyWithImpl<AiImagePart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiImagePart&&(identical(other.attachmentId, attachmentId) || other.attachmentId == attachmentId));
}


@override
int get hashCode => Object.hash(runtimeType,attachmentId);

@override
String toString() {
  return 'AiContentPart.image(attachmentId: $attachmentId)';
}


}

/// @nodoc
abstract mixin class $AiImagePartCopyWith<$Res> implements $AiContentPartCopyWith<$Res> {
  factory $AiImagePartCopyWith(AiImagePart value, $Res Function(AiImagePart) _then) = _$AiImagePartCopyWithImpl;
@useResult
$Res call({
 String attachmentId
});




}
/// @nodoc
class _$AiImagePartCopyWithImpl<$Res>
    implements $AiImagePartCopyWith<$Res> {
  _$AiImagePartCopyWithImpl(this._self, this._then);

  final AiImagePart _self;
  final $Res Function(AiImagePart) _then;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attachmentId = null,}) {
  return _then(AiImagePart(
attachmentId: null == attachmentId ? _self.attachmentId : attachmentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AiToolCallPart implements AiContentPart {
  const AiToolCallPart({required this.toolCall});
  

 final  AiToolCall toolCall;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolCallPartCopyWith<AiToolCallPart> get copyWith => _$AiToolCallPartCopyWithImpl<AiToolCallPart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolCallPart&&(identical(other.toolCall, toolCall) || other.toolCall == toolCall));
}


@override
int get hashCode => Object.hash(runtimeType,toolCall);

@override
String toString() {
  return 'AiContentPart.toolCall(toolCall: $toolCall)';
}


}

/// @nodoc
abstract mixin class $AiToolCallPartCopyWith<$Res> implements $AiContentPartCopyWith<$Res> {
  factory $AiToolCallPartCopyWith(AiToolCallPart value, $Res Function(AiToolCallPart) _then) = _$AiToolCallPartCopyWithImpl;
@useResult
$Res call({
 AiToolCall toolCall
});


$AiToolCallCopyWith<$Res> get toolCall;

}
/// @nodoc
class _$AiToolCallPartCopyWithImpl<$Res>
    implements $AiToolCallPartCopyWith<$Res> {
  _$AiToolCallPartCopyWithImpl(this._self, this._then);

  final AiToolCallPart _self;
  final $Res Function(AiToolCallPart) _then;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? toolCall = null,}) {
  return _then(AiToolCallPart(
toolCall: null == toolCall ? _self.toolCall : toolCall // ignore: cast_nullable_to_non_nullable
as AiToolCall,
  ));
}

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiToolCallCopyWith<$Res> get toolCall {
  
  return $AiToolCallCopyWith<$Res>(_self.toolCall, (value) {
    return _then(_self.copyWith(toolCall: value));
  });
}
}

/// @nodoc


class AiToolResultPart implements AiContentPart {
  const AiToolResultPart({required this.toolResult});
  

 final  AiToolResult toolResult;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolResultPartCopyWith<AiToolResultPart> get copyWith => _$AiToolResultPartCopyWithImpl<AiToolResultPart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolResultPart&&(identical(other.toolResult, toolResult) || other.toolResult == toolResult));
}


@override
int get hashCode => Object.hash(runtimeType,toolResult);

@override
String toString() {
  return 'AiContentPart.toolResult(toolResult: $toolResult)';
}


}

/// @nodoc
abstract mixin class $AiToolResultPartCopyWith<$Res> implements $AiContentPartCopyWith<$Res> {
  factory $AiToolResultPartCopyWith(AiToolResultPart value, $Res Function(AiToolResultPart) _then) = _$AiToolResultPartCopyWithImpl;
@useResult
$Res call({
 AiToolResult toolResult
});


$AiToolResultCopyWith<$Res> get toolResult;

}
/// @nodoc
class _$AiToolResultPartCopyWithImpl<$Res>
    implements $AiToolResultPartCopyWith<$Res> {
  _$AiToolResultPartCopyWithImpl(this._self, this._then);

  final AiToolResultPart _self;
  final $Res Function(AiToolResultPart) _then;

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? toolResult = null,}) {
  return _then(AiToolResultPart(
toolResult: null == toolResult ? _self.toolResult : toolResult // ignore: cast_nullable_to_non_nullable
as AiToolResult,
  ));
}

/// Create a copy of AiContentPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiToolResultCopyWith<$Res> get toolResult {
  
  return $AiToolResultCopyWith<$Res>(_self.toolResult, (value) {
    return _then(_self.copyWith(toolResult: value));
  });
}
}

/// @nodoc
mixin _$AiToolCall {

 String get id; String get name; Map<String, Object?> get arguments;
/// Create a copy of AiToolCall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolCallCopyWith<AiToolCall> get copyWith => _$AiToolCallCopyWithImpl<AiToolCall>(this as AiToolCall, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolCall&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.arguments, arguments));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(arguments));

@override
String toString() {
  return 'AiToolCall(id: $id, name: $name, arguments: $arguments)';
}


}

/// @nodoc
abstract mixin class $AiToolCallCopyWith<$Res>  {
  factory $AiToolCallCopyWith(AiToolCall value, $Res Function(AiToolCall) _then) = _$AiToolCallCopyWithImpl;
@useResult
$Res call({
 String id, String name, Map<String, Object?> arguments
});




}
/// @nodoc
class _$AiToolCallCopyWithImpl<$Res>
    implements $AiToolCallCopyWith<$Res> {
  _$AiToolCallCopyWithImpl(this._self, this._then);

  final AiToolCall _self;
  final $Res Function(AiToolCall) _then;

/// Create a copy of AiToolCall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? arguments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,arguments: null == arguments ? _self.arguments : arguments // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiToolCall].
extension AiToolCallPatterns on AiToolCall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiToolCall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiToolCall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiToolCall value)  $default,){
final _that = this;
switch (_that) {
case _AiToolCall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiToolCall value)?  $default,){
final _that = this;
switch (_that) {
case _AiToolCall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Map<String, Object?> arguments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiToolCall() when $default != null:
return $default(_that.id,_that.name,_that.arguments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Map<String, Object?> arguments)  $default,) {final _that = this;
switch (_that) {
case _AiToolCall():
return $default(_that.id,_that.name,_that.arguments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Map<String, Object?> arguments)?  $default,) {final _that = this;
switch (_that) {
case _AiToolCall() when $default != null:
return $default(_that.id,_that.name,_that.arguments);case _:
  return null;

}
}

}

/// @nodoc


class _AiToolCall implements AiToolCall {
  const _AiToolCall({required this.id, required this.name, required final  Map<String, Object?> arguments}): _arguments = arguments;
  

@override final  String id;
@override final  String name;
 final  Map<String, Object?> _arguments;
@override Map<String, Object?> get arguments {
  if (_arguments is EqualUnmodifiableMapView) return _arguments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_arguments);
}


/// Create a copy of AiToolCall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiToolCallCopyWith<_AiToolCall> get copyWith => __$AiToolCallCopyWithImpl<_AiToolCall>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiToolCall&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._arguments, _arguments));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_arguments));

@override
String toString() {
  return 'AiToolCall(id: $id, name: $name, arguments: $arguments)';
}


}

/// @nodoc
abstract mixin class _$AiToolCallCopyWith<$Res> implements $AiToolCallCopyWith<$Res> {
  factory _$AiToolCallCopyWith(_AiToolCall value, $Res Function(_AiToolCall) _then) = __$AiToolCallCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Map<String, Object?> arguments
});




}
/// @nodoc
class __$AiToolCallCopyWithImpl<$Res>
    implements _$AiToolCallCopyWith<$Res> {
  __$AiToolCallCopyWithImpl(this._self, this._then);

  final _AiToolCall _self;
  final $Res Function(_AiToolCall) _then;

/// Create a copy of AiToolCall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? arguments = null,}) {
  return _then(_AiToolCall(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,arguments: null == arguments ? _self._arguments : arguments // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

/// @nodoc
mixin _$AiToolResult {

 String get toolCallId; String get name; bool get success; String get content;
/// Create a copy of AiToolResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolResultCopyWith<AiToolResult> get copyWith => _$AiToolResultCopyWithImpl<AiToolResult>(this as AiToolResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolResult&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.name, name) || other.name == name)&&(identical(other.success, success) || other.success == success)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,toolCallId,name,success,content);

@override
String toString() {
  return 'AiToolResult(toolCallId: $toolCallId, name: $name, success: $success, content: $content)';
}


}

/// @nodoc
abstract mixin class $AiToolResultCopyWith<$Res>  {
  factory $AiToolResultCopyWith(AiToolResult value, $Res Function(AiToolResult) _then) = _$AiToolResultCopyWithImpl;
@useResult
$Res call({
 String toolCallId, String name, bool success, String content
});




}
/// @nodoc
class _$AiToolResultCopyWithImpl<$Res>
    implements $AiToolResultCopyWith<$Res> {
  _$AiToolResultCopyWithImpl(this._self, this._then);

  final AiToolResult _self;
  final $Res Function(AiToolResult) _then;

/// Create a copy of AiToolResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toolCallId = null,Object? name = null,Object? success = null,Object? content = null,}) {
  return _then(_self.copyWith(
toolCallId: null == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiToolResult].
extension AiToolResultPatterns on AiToolResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiToolResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiToolResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiToolResult value)  $default,){
final _that = this;
switch (_that) {
case _AiToolResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiToolResult value)?  $default,){
final _that = this;
switch (_that) {
case _AiToolResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String toolCallId,  String name,  bool success,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiToolResult() when $default != null:
return $default(_that.toolCallId,_that.name,_that.success,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String toolCallId,  String name,  bool success,  String content)  $default,) {final _that = this;
switch (_that) {
case _AiToolResult():
return $default(_that.toolCallId,_that.name,_that.success,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String toolCallId,  String name,  bool success,  String content)?  $default,) {final _that = this;
switch (_that) {
case _AiToolResult() when $default != null:
return $default(_that.toolCallId,_that.name,_that.success,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _AiToolResult implements AiToolResult {
  const _AiToolResult({required this.toolCallId, required this.name, required this.success, required this.content});
  

@override final  String toolCallId;
@override final  String name;
@override final  bool success;
@override final  String content;

/// Create a copy of AiToolResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiToolResultCopyWith<_AiToolResult> get copyWith => __$AiToolResultCopyWithImpl<_AiToolResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiToolResult&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.name, name) || other.name == name)&&(identical(other.success, success) || other.success == success)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,toolCallId,name,success,content);

@override
String toString() {
  return 'AiToolResult(toolCallId: $toolCallId, name: $name, success: $success, content: $content)';
}


}

/// @nodoc
abstract mixin class _$AiToolResultCopyWith<$Res> implements $AiToolResultCopyWith<$Res> {
  factory _$AiToolResultCopyWith(_AiToolResult value, $Res Function(_AiToolResult) _then) = __$AiToolResultCopyWithImpl;
@override @useResult
$Res call({
 String toolCallId, String name, bool success, String content
});




}
/// @nodoc
class __$AiToolResultCopyWithImpl<$Res>
    implements _$AiToolResultCopyWith<$Res> {
  __$AiToolResultCopyWithImpl(this._self, this._then);

  final _AiToolResult _self;
  final $Res Function(_AiToolResult) _then;

/// Create a copy of AiToolResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toolCallId = null,Object? name = null,Object? success = null,Object? content = null,}) {
  return _then(_AiToolResult(
toolCallId: null == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AiToolSpec {

 String get name; String get description; Map<String, Object?> get inputSchema;
/// Create a copy of AiToolSpec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolSpecCopyWith<AiToolSpec> get copyWith => _$AiToolSpecCopyWithImpl<AiToolSpec>(this as AiToolSpec, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolSpec&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.inputSchema, inputSchema));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(inputSchema));

@override
String toString() {
  return 'AiToolSpec(name: $name, description: $description, inputSchema: $inputSchema)';
}


}

/// @nodoc
abstract mixin class $AiToolSpecCopyWith<$Res>  {
  factory $AiToolSpecCopyWith(AiToolSpec value, $Res Function(AiToolSpec) _then) = _$AiToolSpecCopyWithImpl;
@useResult
$Res call({
 String name, String description, Map<String, Object?> inputSchema
});




}
/// @nodoc
class _$AiToolSpecCopyWithImpl<$Res>
    implements $AiToolSpecCopyWith<$Res> {
  _$AiToolSpecCopyWithImpl(this._self, this._then);

  final AiToolSpec _self;
  final $Res Function(AiToolSpec) _then;

/// Create a copy of AiToolSpec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? inputSchema = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,inputSchema: null == inputSchema ? _self.inputSchema : inputSchema // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [AiToolSpec].
extension AiToolSpecPatterns on AiToolSpec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiToolSpec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiToolSpec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiToolSpec value)  $default,){
final _that = this;
switch (_that) {
case _AiToolSpec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiToolSpec value)?  $default,){
final _that = this;
switch (_that) {
case _AiToolSpec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  Map<String, Object?> inputSchema)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiToolSpec() when $default != null:
return $default(_that.name,_that.description,_that.inputSchema);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  Map<String, Object?> inputSchema)  $default,) {final _that = this;
switch (_that) {
case _AiToolSpec():
return $default(_that.name,_that.description,_that.inputSchema);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  Map<String, Object?> inputSchema)?  $default,) {final _that = this;
switch (_that) {
case _AiToolSpec() when $default != null:
return $default(_that.name,_that.description,_that.inputSchema);case _:
  return null;

}
}

}

/// @nodoc


class _AiToolSpec implements AiToolSpec {
  const _AiToolSpec({required this.name, required this.description, required final  Map<String, Object?> inputSchema}): _inputSchema = inputSchema;
  

@override final  String name;
@override final  String description;
 final  Map<String, Object?> _inputSchema;
@override Map<String, Object?> get inputSchema {
  if (_inputSchema is EqualUnmodifiableMapView) return _inputSchema;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_inputSchema);
}


/// Create a copy of AiToolSpec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiToolSpecCopyWith<_AiToolSpec> get copyWith => __$AiToolSpecCopyWithImpl<_AiToolSpec>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiToolSpec&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._inputSchema, _inputSchema));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,const DeepCollectionEquality().hash(_inputSchema));

@override
String toString() {
  return 'AiToolSpec(name: $name, description: $description, inputSchema: $inputSchema)';
}


}

/// @nodoc
abstract mixin class _$AiToolSpecCopyWith<$Res> implements $AiToolSpecCopyWith<$Res> {
  factory _$AiToolSpecCopyWith(_AiToolSpec value, $Res Function(_AiToolSpec) _then) = __$AiToolSpecCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, Map<String, Object?> inputSchema
});




}
/// @nodoc
class __$AiToolSpecCopyWithImpl<$Res>
    implements _$AiToolSpecCopyWith<$Res> {
  __$AiToolSpecCopyWithImpl(this._self, this._then);

  final _AiToolSpec _self;
  final $Res Function(_AiToolSpec) _then;

/// Create a copy of AiToolSpec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? inputSchema = null,}) {
  return _then(_AiToolSpec(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,inputSchema: null == inputSchema ? _self._inputSchema : inputSchema // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

/// @nodoc
mixin _$AiMessage {

 String get id; String get conversationId; AiMessageRole get role; List<AiContentPart> get parts; AiMessageStatus get status; AiUsage? get usage; AiFailure? get failure; AiTransportTrace? get transportTrace; String? get parentId; DateTime get createdAt; DateTime? get completedAt;
/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiMessageCopyWith<AiMessage> get copyWith => _$AiMessageCopyWithImpl<AiMessage>(this as AiMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.parts, parts)&&(identical(other.status, status) || other.status == status)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transportTrace, transportTrace) || other.transportTrace == transportTrace)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,conversationId,role,const DeepCollectionEquality().hash(parts),status,usage,failure,transportTrace,parentId,createdAt,completedAt);

@override
String toString() {
  return 'AiMessage(id: $id, conversationId: $conversationId, role: $role, parts: $parts, status: $status, usage: $usage, failure: $failure, transportTrace: $transportTrace, parentId: $parentId, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $AiMessageCopyWith<$Res>  {
  factory $AiMessageCopyWith(AiMessage value, $Res Function(AiMessage) _then) = _$AiMessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, AiMessageRole role, List<AiContentPart> parts, AiMessageStatus status, AiUsage? usage, AiFailure? failure, AiTransportTrace? transportTrace, String? parentId, DateTime createdAt, DateTime? completedAt
});


$AiUsageCopyWith<$Res>? get usage;$AiFailureCopyWith<$Res>? get failure;$AiTransportTraceCopyWith<$Res>? get transportTrace;

}
/// @nodoc
class _$AiMessageCopyWithImpl<$Res>
    implements $AiMessageCopyWith<$Res> {
  _$AiMessageCopyWithImpl(this._self, this._then);

  final AiMessage _self;
  final $Res Function(AiMessage) _then;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? role = null,Object? parts = null,Object? status = null,Object? usage = freezed,Object? failure = freezed,Object? transportTrace = freezed,Object? parentId = freezed,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AiMessageRole,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<AiContentPart>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiMessageStatus,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as AiUsage?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailure?,transportTrace: freezed == transportTrace ? _self.transportTrace : transportTrace // ignore: cast_nullable_to_non_nullable
as AiTransportTrace?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of AiMessage
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
}/// Create a copy of AiMessage
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
}/// Create a copy of AiMessage
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  AiMessageRole role,  List<AiContentPart> parts,  AiMessageStatus status,  AiUsage? usage,  AiFailure? failure,  AiTransportTrace? transportTrace,  String? parentId,  DateTime createdAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.role,_that.parts,_that.status,_that.usage,_that.failure,_that.transportTrace,_that.parentId,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  AiMessageRole role,  List<AiContentPart> parts,  AiMessageStatus status,  AiUsage? usage,  AiFailure? failure,  AiTransportTrace? transportTrace,  String? parentId,  DateTime createdAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _AiMessage():
return $default(_that.id,_that.conversationId,_that.role,_that.parts,_that.status,_that.usage,_that.failure,_that.transportTrace,_that.parentId,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  AiMessageRole role,  List<AiContentPart> parts,  AiMessageStatus status,  AiUsage? usage,  AiFailure? failure,  AiTransportTrace? transportTrace,  String? parentId,  DateTime createdAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.role,_that.parts,_that.status,_that.usage,_that.failure,_that.transportTrace,_that.parentId,_that.createdAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AiMessage implements AiMessage {
  const _AiMessage({required this.id, required this.conversationId, required this.role, required final  List<AiContentPart> parts, this.status = AiMessageStatus.completed, this.usage, this.failure, this.transportTrace, this.parentId, required this.createdAt, this.completedAt}): _parts = parts;
  

@override final  String id;
@override final  String conversationId;
@override final  AiMessageRole role;
 final  List<AiContentPart> _parts;
@override List<AiContentPart> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override@JsonKey() final  AiMessageStatus status;
@override final  AiUsage? usage;
@override final  AiFailure? failure;
@override final  AiTransportTrace? transportTrace;
@override final  String? parentId;
@override final  DateTime createdAt;
@override final  DateTime? completedAt;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiMessageCopyWith<_AiMessage> get copyWith => __$AiMessageCopyWithImpl<_AiMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._parts, _parts)&&(identical(other.status, status) || other.status == status)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transportTrace, transportTrace) || other.transportTrace == transportTrace)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,conversationId,role,const DeepCollectionEquality().hash(_parts),status,usage,failure,transportTrace,parentId,createdAt,completedAt);

@override
String toString() {
  return 'AiMessage(id: $id, conversationId: $conversationId, role: $role, parts: $parts, status: $status, usage: $usage, failure: $failure, transportTrace: $transportTrace, parentId: $parentId, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$AiMessageCopyWith<$Res> implements $AiMessageCopyWith<$Res> {
  factory _$AiMessageCopyWith(_AiMessage value, $Res Function(_AiMessage) _then) = __$AiMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, AiMessageRole role, List<AiContentPart> parts, AiMessageStatus status, AiUsage? usage, AiFailure? failure, AiTransportTrace? transportTrace, String? parentId, DateTime createdAt, DateTime? completedAt
});


@override $AiUsageCopyWith<$Res>? get usage;@override $AiFailureCopyWith<$Res>? get failure;@override $AiTransportTraceCopyWith<$Res>? get transportTrace;

}
/// @nodoc
class __$AiMessageCopyWithImpl<$Res>
    implements _$AiMessageCopyWith<$Res> {
  __$AiMessageCopyWithImpl(this._self, this._then);

  final _AiMessage _self;
  final $Res Function(_AiMessage) _then;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? role = null,Object? parts = null,Object? status = null,Object? usage = freezed,Object? failure = freezed,Object? transportTrace = freezed,Object? parentId = freezed,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_AiMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AiMessageRole,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<AiContentPart>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AiMessageStatus,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as AiUsage?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AiFailure?,transportTrace: freezed == transportTrace ? _self.transportTrace : transportTrace // ignore: cast_nullable_to_non_nullable
as AiTransportTrace?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of AiMessage
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
}/// Create a copy of AiMessage
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
}/// Create a copy of AiMessage
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

/// @nodoc
mixin _$AiGenerationOptions {

 int? get maxOutputTokens; double? get temperature; double? get topP; double? get presencePenalty; double? get frequencyPenalty; String? get reasoningEffort; bool get stream;
/// Create a copy of AiGenerationOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiGenerationOptionsCopyWith<AiGenerationOptions> get copyWith => _$AiGenerationOptionsCopyWithImpl<AiGenerationOptions>(this as AiGenerationOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiGenerationOptions&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.topP, topP) || other.topP == topP)&&(identical(other.presencePenalty, presencePenalty) || other.presencePenalty == presencePenalty)&&(identical(other.frequencyPenalty, frequencyPenalty) || other.frequencyPenalty == frequencyPenalty)&&(identical(other.reasoningEffort, reasoningEffort) || other.reasoningEffort == reasoningEffort)&&(identical(other.stream, stream) || other.stream == stream));
}


@override
int get hashCode => Object.hash(runtimeType,maxOutputTokens,temperature,topP,presencePenalty,frequencyPenalty,reasoningEffort,stream);

@override
String toString() {
  return 'AiGenerationOptions(maxOutputTokens: $maxOutputTokens, temperature: $temperature, topP: $topP, presencePenalty: $presencePenalty, frequencyPenalty: $frequencyPenalty, reasoningEffort: $reasoningEffort, stream: $stream)';
}


}

/// @nodoc
abstract mixin class $AiGenerationOptionsCopyWith<$Res>  {
  factory $AiGenerationOptionsCopyWith(AiGenerationOptions value, $Res Function(AiGenerationOptions) _then) = _$AiGenerationOptionsCopyWithImpl;
@useResult
$Res call({
 int? maxOutputTokens, double? temperature, double? topP, double? presencePenalty, double? frequencyPenalty, String? reasoningEffort, bool stream
});




}
/// @nodoc
class _$AiGenerationOptionsCopyWithImpl<$Res>
    implements $AiGenerationOptionsCopyWith<$Res> {
  _$AiGenerationOptionsCopyWithImpl(this._self, this._then);

  final AiGenerationOptions _self;
  final $Res Function(AiGenerationOptions) _then;

/// Create a copy of AiGenerationOptions
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


/// Adds pattern-matching-related methods to [AiGenerationOptions].
extension AiGenerationOptionsPatterns on AiGenerationOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiGenerationOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiGenerationOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiGenerationOptions value)  $default,){
final _that = this;
switch (_that) {
case _AiGenerationOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiGenerationOptions value)?  $default,){
final _that = this;
switch (_that) {
case _AiGenerationOptions() when $default != null:
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
case _AiGenerationOptions() when $default != null:
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
case _AiGenerationOptions():
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
case _AiGenerationOptions() when $default != null:
return $default(_that.maxOutputTokens,_that.temperature,_that.topP,_that.presencePenalty,_that.frequencyPenalty,_that.reasoningEffort,_that.stream);case _:
  return null;

}
}

}

/// @nodoc


class _AiGenerationOptions implements AiGenerationOptions {
  const _AiGenerationOptions({this.maxOutputTokens, this.temperature, this.topP, this.presencePenalty, this.frequencyPenalty, this.reasoningEffort, this.stream = true});
  

@override final  int? maxOutputTokens;
@override final  double? temperature;
@override final  double? topP;
@override final  double? presencePenalty;
@override final  double? frequencyPenalty;
@override final  String? reasoningEffort;
@override@JsonKey() final  bool stream;

/// Create a copy of AiGenerationOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiGenerationOptionsCopyWith<_AiGenerationOptions> get copyWith => __$AiGenerationOptionsCopyWithImpl<_AiGenerationOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiGenerationOptions&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.topP, topP) || other.topP == topP)&&(identical(other.presencePenalty, presencePenalty) || other.presencePenalty == presencePenalty)&&(identical(other.frequencyPenalty, frequencyPenalty) || other.frequencyPenalty == frequencyPenalty)&&(identical(other.reasoningEffort, reasoningEffort) || other.reasoningEffort == reasoningEffort)&&(identical(other.stream, stream) || other.stream == stream));
}


@override
int get hashCode => Object.hash(runtimeType,maxOutputTokens,temperature,topP,presencePenalty,frequencyPenalty,reasoningEffort,stream);

@override
String toString() {
  return 'AiGenerationOptions(maxOutputTokens: $maxOutputTokens, temperature: $temperature, topP: $topP, presencePenalty: $presencePenalty, frequencyPenalty: $frequencyPenalty, reasoningEffort: $reasoningEffort, stream: $stream)';
}


}

/// @nodoc
abstract mixin class _$AiGenerationOptionsCopyWith<$Res> implements $AiGenerationOptionsCopyWith<$Res> {
  factory _$AiGenerationOptionsCopyWith(_AiGenerationOptions value, $Res Function(_AiGenerationOptions) _then) = __$AiGenerationOptionsCopyWithImpl;
@override @useResult
$Res call({
 int? maxOutputTokens, double? temperature, double? topP, double? presencePenalty, double? frequencyPenalty, String? reasoningEffort, bool stream
});




}
/// @nodoc
class __$AiGenerationOptionsCopyWithImpl<$Res>
    implements _$AiGenerationOptionsCopyWith<$Res> {
  __$AiGenerationOptionsCopyWithImpl(this._self, this._then);

  final _AiGenerationOptions _self;
  final $Res Function(_AiGenerationOptions) _then;

/// Create a copy of AiGenerationOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxOutputTokens = freezed,Object? temperature = freezed,Object? topP = freezed,Object? presencePenalty = freezed,Object? frequencyPenalty = freezed,Object? reasoningEffort = freezed,Object? stream = null,}) {
  return _then(_AiGenerationOptions(
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
mixin _$AiModelCapabilities {

 bool get streaming; bool get visionInput; bool get fileInput; bool get reasoning; bool get toolCalling; bool get parallelToolCalling; bool get structuredOutput; bool get systemRole;
/// Create a copy of AiModelCapabilities
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelCapabilitiesCopyWith<AiModelCapabilities> get copyWith => _$AiModelCapabilitiesCopyWithImpl<AiModelCapabilities>(this as AiModelCapabilities, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModelCapabilities&&(identical(other.streaming, streaming) || other.streaming == streaming)&&(identical(other.visionInput, visionInput) || other.visionInput == visionInput)&&(identical(other.fileInput, fileInput) || other.fileInput == fileInput)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&(identical(other.toolCalling, toolCalling) || other.toolCalling == toolCalling)&&(identical(other.parallelToolCalling, parallelToolCalling) || other.parallelToolCalling == parallelToolCalling)&&(identical(other.structuredOutput, structuredOutput) || other.structuredOutput == structuredOutput)&&(identical(other.systemRole, systemRole) || other.systemRole == systemRole));
}


@override
int get hashCode => Object.hash(runtimeType,streaming,visionInput,fileInput,reasoning,toolCalling,parallelToolCalling,structuredOutput,systemRole);

@override
String toString() {
  return 'AiModelCapabilities(streaming: $streaming, visionInput: $visionInput, fileInput: $fileInput, reasoning: $reasoning, toolCalling: $toolCalling, parallelToolCalling: $parallelToolCalling, structuredOutput: $structuredOutput, systemRole: $systemRole)';
}


}

/// @nodoc
abstract mixin class $AiModelCapabilitiesCopyWith<$Res>  {
  factory $AiModelCapabilitiesCopyWith(AiModelCapabilities value, $Res Function(AiModelCapabilities) _then) = _$AiModelCapabilitiesCopyWithImpl;
@useResult
$Res call({
 bool streaming, bool visionInput, bool fileInput, bool reasoning, bool toolCalling, bool parallelToolCalling, bool structuredOutput, bool systemRole
});




}
/// @nodoc
class _$AiModelCapabilitiesCopyWithImpl<$Res>
    implements $AiModelCapabilitiesCopyWith<$Res> {
  _$AiModelCapabilitiesCopyWithImpl(this._self, this._then);

  final AiModelCapabilities _self;
  final $Res Function(AiModelCapabilities) _then;

/// Create a copy of AiModelCapabilities
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


/// Adds pattern-matching-related methods to [AiModelCapabilities].
extension AiModelCapabilitiesPatterns on AiModelCapabilities {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModelCapabilities value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModelCapabilities() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModelCapabilities value)  $default,){
final _that = this;
switch (_that) {
case _AiModelCapabilities():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModelCapabilities value)?  $default,){
final _that = this;
switch (_that) {
case _AiModelCapabilities() when $default != null:
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
case _AiModelCapabilities() when $default != null:
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
case _AiModelCapabilities():
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
case _AiModelCapabilities() when $default != null:
return $default(_that.streaming,_that.visionInput,_that.fileInput,_that.reasoning,_that.toolCalling,_that.parallelToolCalling,_that.structuredOutput,_that.systemRole);case _:
  return null;

}
}

}

/// @nodoc


class _AiModelCapabilities implements AiModelCapabilities {
  const _AiModelCapabilities({this.streaming = false, this.visionInput = false, this.fileInput = false, this.reasoning = false, this.toolCalling = false, this.parallelToolCalling = false, this.structuredOutput = false, this.systemRole = true});
  

@override@JsonKey() final  bool streaming;
@override@JsonKey() final  bool visionInput;
@override@JsonKey() final  bool fileInput;
@override@JsonKey() final  bool reasoning;
@override@JsonKey() final  bool toolCalling;
@override@JsonKey() final  bool parallelToolCalling;
@override@JsonKey() final  bool structuredOutput;
@override@JsonKey() final  bool systemRole;

/// Create a copy of AiModelCapabilities
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelCapabilitiesCopyWith<_AiModelCapabilities> get copyWith => __$AiModelCapabilitiesCopyWithImpl<_AiModelCapabilities>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModelCapabilities&&(identical(other.streaming, streaming) || other.streaming == streaming)&&(identical(other.visionInput, visionInput) || other.visionInput == visionInput)&&(identical(other.fileInput, fileInput) || other.fileInput == fileInput)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&(identical(other.toolCalling, toolCalling) || other.toolCalling == toolCalling)&&(identical(other.parallelToolCalling, parallelToolCalling) || other.parallelToolCalling == parallelToolCalling)&&(identical(other.structuredOutput, structuredOutput) || other.structuredOutput == structuredOutput)&&(identical(other.systemRole, systemRole) || other.systemRole == systemRole));
}


@override
int get hashCode => Object.hash(runtimeType,streaming,visionInput,fileInput,reasoning,toolCalling,parallelToolCalling,structuredOutput,systemRole);

@override
String toString() {
  return 'AiModelCapabilities(streaming: $streaming, visionInput: $visionInput, fileInput: $fileInput, reasoning: $reasoning, toolCalling: $toolCalling, parallelToolCalling: $parallelToolCalling, structuredOutput: $structuredOutput, systemRole: $systemRole)';
}


}

/// @nodoc
abstract mixin class _$AiModelCapabilitiesCopyWith<$Res> implements $AiModelCapabilitiesCopyWith<$Res> {
  factory _$AiModelCapabilitiesCopyWith(_AiModelCapabilities value, $Res Function(_AiModelCapabilities) _then) = __$AiModelCapabilitiesCopyWithImpl;
@override @useResult
$Res call({
 bool streaming, bool visionInput, bool fileInput, bool reasoning, bool toolCalling, bool parallelToolCalling, bool structuredOutput, bool systemRole
});




}
/// @nodoc
class __$AiModelCapabilitiesCopyWithImpl<$Res>
    implements _$AiModelCapabilitiesCopyWith<$Res> {
  __$AiModelCapabilitiesCopyWithImpl(this._self, this._then);

  final _AiModelCapabilities _self;
  final $Res Function(_AiModelCapabilities) _then;

/// Create a copy of AiModelCapabilities
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streaming = null,Object? visionInput = null,Object? fileInput = null,Object? reasoning = null,Object? toolCalling = null,Object? parallelToolCalling = null,Object? structuredOutput = null,Object? systemRole = null,}) {
  return _then(_AiModelCapabilities(
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
mixin _$AiModelLimits {

 int? get contextTokens; int? get maxOutputTokens; int? get maxImages; int? get maxTools; int? get maxToolResultBytes;
/// Create a copy of AiModelLimits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelLimitsCopyWith<AiModelLimits> get copyWith => _$AiModelLimitsCopyWithImpl<AiModelLimits>(this as AiModelLimits, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModelLimits&&(identical(other.contextTokens, contextTokens) || other.contextTokens == contextTokens)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens)&&(identical(other.maxImages, maxImages) || other.maxImages == maxImages)&&(identical(other.maxTools, maxTools) || other.maxTools == maxTools)&&(identical(other.maxToolResultBytes, maxToolResultBytes) || other.maxToolResultBytes == maxToolResultBytes));
}


@override
int get hashCode => Object.hash(runtimeType,contextTokens,maxOutputTokens,maxImages,maxTools,maxToolResultBytes);

@override
String toString() {
  return 'AiModelLimits(contextTokens: $contextTokens, maxOutputTokens: $maxOutputTokens, maxImages: $maxImages, maxTools: $maxTools, maxToolResultBytes: $maxToolResultBytes)';
}


}

/// @nodoc
abstract mixin class $AiModelLimitsCopyWith<$Res>  {
  factory $AiModelLimitsCopyWith(AiModelLimits value, $Res Function(AiModelLimits) _then) = _$AiModelLimitsCopyWithImpl;
@useResult
$Res call({
 int? contextTokens, int? maxOutputTokens, int? maxImages, int? maxTools, int? maxToolResultBytes
});




}
/// @nodoc
class _$AiModelLimitsCopyWithImpl<$Res>
    implements $AiModelLimitsCopyWith<$Res> {
  _$AiModelLimitsCopyWithImpl(this._self, this._then);

  final AiModelLimits _self;
  final $Res Function(AiModelLimits) _then;

/// Create a copy of AiModelLimits
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


/// Adds pattern-matching-related methods to [AiModelLimits].
extension AiModelLimitsPatterns on AiModelLimits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModelLimits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModelLimits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModelLimits value)  $default,){
final _that = this;
switch (_that) {
case _AiModelLimits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModelLimits value)?  $default,){
final _that = this;
switch (_that) {
case _AiModelLimits() when $default != null:
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
case _AiModelLimits() when $default != null:
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
case _AiModelLimits():
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
case _AiModelLimits() when $default != null:
return $default(_that.contextTokens,_that.maxOutputTokens,_that.maxImages,_that.maxTools,_that.maxToolResultBytes);case _:
  return null;

}
}

}

/// @nodoc


class _AiModelLimits implements AiModelLimits {
  const _AiModelLimits({this.contextTokens, this.maxOutputTokens, this.maxImages, this.maxTools, this.maxToolResultBytes});
  

@override final  int? contextTokens;
@override final  int? maxOutputTokens;
@override final  int? maxImages;
@override final  int? maxTools;
@override final  int? maxToolResultBytes;

/// Create a copy of AiModelLimits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelLimitsCopyWith<_AiModelLimits> get copyWith => __$AiModelLimitsCopyWithImpl<_AiModelLimits>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModelLimits&&(identical(other.contextTokens, contextTokens) || other.contextTokens == contextTokens)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens)&&(identical(other.maxImages, maxImages) || other.maxImages == maxImages)&&(identical(other.maxTools, maxTools) || other.maxTools == maxTools)&&(identical(other.maxToolResultBytes, maxToolResultBytes) || other.maxToolResultBytes == maxToolResultBytes));
}


@override
int get hashCode => Object.hash(runtimeType,contextTokens,maxOutputTokens,maxImages,maxTools,maxToolResultBytes);

@override
String toString() {
  return 'AiModelLimits(contextTokens: $contextTokens, maxOutputTokens: $maxOutputTokens, maxImages: $maxImages, maxTools: $maxTools, maxToolResultBytes: $maxToolResultBytes)';
}


}

/// @nodoc
abstract mixin class _$AiModelLimitsCopyWith<$Res> implements $AiModelLimitsCopyWith<$Res> {
  factory _$AiModelLimitsCopyWith(_AiModelLimits value, $Res Function(_AiModelLimits) _then) = __$AiModelLimitsCopyWithImpl;
@override @useResult
$Res call({
 int? contextTokens, int? maxOutputTokens, int? maxImages, int? maxTools, int? maxToolResultBytes
});




}
/// @nodoc
class __$AiModelLimitsCopyWithImpl<$Res>
    implements _$AiModelLimitsCopyWith<$Res> {
  __$AiModelLimitsCopyWithImpl(this._self, this._then);

  final _AiModelLimits _self;
  final $Res Function(_AiModelLimits) _then;

/// Create a copy of AiModelLimits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contextTokens = freezed,Object? maxOutputTokens = freezed,Object? maxImages = freezed,Object? maxTools = freezed,Object? maxToolResultBytes = freezed,}) {
  return _then(_AiModelLimits(
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
mixin _$AiModelDefinition {

 String get id; String get connectionId; String get displayName; AiModelCapabilities get capabilities; AiModelLimits get limits; String get source;
/// Create a copy of AiModelDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiModelDefinitionCopyWith<AiModelDefinition> get copyWith => _$AiModelDefinitionCopyWithImpl<AiModelDefinition>(this as AiModelDefinition, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiModelDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities)&&(identical(other.limits, limits) || other.limits == limits)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,connectionId,displayName,capabilities,limits,source);

@override
String toString() {
  return 'AiModelDefinition(id: $id, connectionId: $connectionId, displayName: $displayName, capabilities: $capabilities, limits: $limits, source: $source)';
}


}

/// @nodoc
abstract mixin class $AiModelDefinitionCopyWith<$Res>  {
  factory $AiModelDefinitionCopyWith(AiModelDefinition value, $Res Function(AiModelDefinition) _then) = _$AiModelDefinitionCopyWithImpl;
@useResult
$Res call({
 String id, String connectionId, String displayName, AiModelCapabilities capabilities, AiModelLimits limits, String source
});


$AiModelCapabilitiesCopyWith<$Res> get capabilities;$AiModelLimitsCopyWith<$Res> get limits;

}
/// @nodoc
class _$AiModelDefinitionCopyWithImpl<$Res>
    implements $AiModelDefinitionCopyWith<$Res> {
  _$AiModelDefinitionCopyWithImpl(this._self, this._then);

  final AiModelDefinition _self;
  final $Res Function(AiModelDefinition) _then;

/// Create a copy of AiModelDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? connectionId = null,Object? displayName = null,Object? capabilities = null,Object? limits = null,Object? source = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as AiModelCapabilities,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as AiModelLimits,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AiModelDefinition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelCapabilitiesCopyWith<$Res> get capabilities {
  
  return $AiModelCapabilitiesCopyWith<$Res>(_self.capabilities, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}/// Create a copy of AiModelDefinition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelLimitsCopyWith<$Res> get limits {
  
  return $AiModelLimitsCopyWith<$Res>(_self.limits, (value) {
    return _then(_self.copyWith(limits: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiModelDefinition].
extension AiModelDefinitionPatterns on AiModelDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiModelDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiModelDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiModelDefinition value)  $default,){
final _that = this;
switch (_that) {
case _AiModelDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiModelDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _AiModelDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String connectionId,  String displayName,  AiModelCapabilities capabilities,  AiModelLimits limits,  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiModelDefinition() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String connectionId,  String displayName,  AiModelCapabilities capabilities,  AiModelLimits limits,  String source)  $default,) {final _that = this;
switch (_that) {
case _AiModelDefinition():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String connectionId,  String displayName,  AiModelCapabilities capabilities,  AiModelLimits limits,  String source)?  $default,) {final _that = this;
switch (_that) {
case _AiModelDefinition() when $default != null:
return $default(_that.id,_that.connectionId,_that.displayName,_that.capabilities,_that.limits,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _AiModelDefinition implements AiModelDefinition {
  const _AiModelDefinition({required this.id, required this.connectionId, required this.displayName, required this.capabilities, required this.limits, this.source = 'discovered'});
  

@override final  String id;
@override final  String connectionId;
@override final  String displayName;
@override final  AiModelCapabilities capabilities;
@override final  AiModelLimits limits;
@override@JsonKey() final  String source;

/// Create a copy of AiModelDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiModelDefinitionCopyWith<_AiModelDefinition> get copyWith => __$AiModelDefinitionCopyWithImpl<_AiModelDefinition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiModelDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities)&&(identical(other.limits, limits) || other.limits == limits)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,connectionId,displayName,capabilities,limits,source);

@override
String toString() {
  return 'AiModelDefinition(id: $id, connectionId: $connectionId, displayName: $displayName, capabilities: $capabilities, limits: $limits, source: $source)';
}


}

/// @nodoc
abstract mixin class _$AiModelDefinitionCopyWith<$Res> implements $AiModelDefinitionCopyWith<$Res> {
  factory _$AiModelDefinitionCopyWith(_AiModelDefinition value, $Res Function(_AiModelDefinition) _then) = __$AiModelDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String id, String connectionId, String displayName, AiModelCapabilities capabilities, AiModelLimits limits, String source
});


@override $AiModelCapabilitiesCopyWith<$Res> get capabilities;@override $AiModelLimitsCopyWith<$Res> get limits;

}
/// @nodoc
class __$AiModelDefinitionCopyWithImpl<$Res>
    implements _$AiModelDefinitionCopyWith<$Res> {
  __$AiModelDefinitionCopyWithImpl(this._self, this._then);

  final _AiModelDefinition _self;
  final $Res Function(_AiModelDefinition) _then;

/// Create a copy of AiModelDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? connectionId = null,Object? displayName = null,Object? capabilities = null,Object? limits = null,Object? source = null,}) {
  return _then(_AiModelDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as AiModelCapabilities,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as AiModelLimits,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AiModelDefinition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelCapabilitiesCopyWith<$Res> get capabilities {
  
  return $AiModelCapabilitiesCopyWith<$Res>(_self.capabilities, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}/// Create a copy of AiModelDefinition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelLimitsCopyWith<$Res> get limits {
  
  return $AiModelLimitsCopyWith<$Res>(_self.limits, (value) {
    return _then(_self.copyWith(limits: value));
  });
}
}

/// @nodoc
mixin _$AiProviderDefinition {

 String get id; String get displayName; String get adapterId; AiAuthScheme get authScheme; String? get authParameterName;
/// Create a copy of AiProviderDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiProviderDefinitionCopyWith<AiProviderDefinition> get copyWith => _$AiProviderDefinitionCopyWithImpl<AiProviderDefinition>(this as AiProviderDefinition, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiProviderDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.adapterId, adapterId) || other.adapterId == adapterId)&&(identical(other.authScheme, authScheme) || other.authScheme == authScheme)&&(identical(other.authParameterName, authParameterName) || other.authParameterName == authParameterName));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,adapterId,authScheme,authParameterName);

@override
String toString() {
  return 'AiProviderDefinition(id: $id, displayName: $displayName, adapterId: $adapterId, authScheme: $authScheme, authParameterName: $authParameterName)';
}


}

/// @nodoc
abstract mixin class $AiProviderDefinitionCopyWith<$Res>  {
  factory $AiProviderDefinitionCopyWith(AiProviderDefinition value, $Res Function(AiProviderDefinition) _then) = _$AiProviderDefinitionCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String adapterId, AiAuthScheme authScheme, String? authParameterName
});




}
/// @nodoc
class _$AiProviderDefinitionCopyWithImpl<$Res>
    implements $AiProviderDefinitionCopyWith<$Res> {
  _$AiProviderDefinitionCopyWithImpl(this._self, this._then);

  final AiProviderDefinition _self;
  final $Res Function(AiProviderDefinition) _then;

/// Create a copy of AiProviderDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? adapterId = null,Object? authScheme = null,Object? authParameterName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,adapterId: null == adapterId ? _self.adapterId : adapterId // ignore: cast_nullable_to_non_nullable
as String,authScheme: null == authScheme ? _self.authScheme : authScheme // ignore: cast_nullable_to_non_nullable
as AiAuthScheme,authParameterName: freezed == authParameterName ? _self.authParameterName : authParameterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiProviderDefinition].
extension AiProviderDefinitionPatterns on AiProviderDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiProviderDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiProviderDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiProviderDefinition value)  $default,){
final _that = this;
switch (_that) {
case _AiProviderDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiProviderDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _AiProviderDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String adapterId,  AiAuthScheme authScheme,  String? authParameterName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiProviderDefinition() when $default != null:
return $default(_that.id,_that.displayName,_that.adapterId,_that.authScheme,_that.authParameterName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String adapterId,  AiAuthScheme authScheme,  String? authParameterName)  $default,) {final _that = this;
switch (_that) {
case _AiProviderDefinition():
return $default(_that.id,_that.displayName,_that.adapterId,_that.authScheme,_that.authParameterName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String adapterId,  AiAuthScheme authScheme,  String? authParameterName)?  $default,) {final _that = this;
switch (_that) {
case _AiProviderDefinition() when $default != null:
return $default(_that.id,_that.displayName,_that.adapterId,_that.authScheme,_that.authParameterName);case _:
  return null;

}
}

}

/// @nodoc


class _AiProviderDefinition implements AiProviderDefinition {
  const _AiProviderDefinition({required this.id, required this.displayName, required this.adapterId, this.authScheme = AiAuthScheme.bearer, this.authParameterName});
  

@override final  String id;
@override final  String displayName;
@override final  String adapterId;
@override@JsonKey() final  AiAuthScheme authScheme;
@override final  String? authParameterName;

/// Create a copy of AiProviderDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiProviderDefinitionCopyWith<_AiProviderDefinition> get copyWith => __$AiProviderDefinitionCopyWithImpl<_AiProviderDefinition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiProviderDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.adapterId, adapterId) || other.adapterId == adapterId)&&(identical(other.authScheme, authScheme) || other.authScheme == authScheme)&&(identical(other.authParameterName, authParameterName) || other.authParameterName == authParameterName));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,adapterId,authScheme,authParameterName);

@override
String toString() {
  return 'AiProviderDefinition(id: $id, displayName: $displayName, adapterId: $adapterId, authScheme: $authScheme, authParameterName: $authParameterName)';
}


}

/// @nodoc
abstract mixin class _$AiProviderDefinitionCopyWith<$Res> implements $AiProviderDefinitionCopyWith<$Res> {
  factory _$AiProviderDefinitionCopyWith(_AiProviderDefinition value, $Res Function(_AiProviderDefinition) _then) = __$AiProviderDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String adapterId, AiAuthScheme authScheme, String? authParameterName
});




}
/// @nodoc
class __$AiProviderDefinitionCopyWithImpl<$Res>
    implements _$AiProviderDefinitionCopyWith<$Res> {
  __$AiProviderDefinitionCopyWithImpl(this._self, this._then);

  final _AiProviderDefinition _self;
  final $Res Function(_AiProviderDefinition) _then;

/// Create a copy of AiProviderDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? adapterId = null,Object? authScheme = null,Object? authParameterName = freezed,}) {
  return _then(_AiProviderDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,adapterId: null == adapterId ? _self.adapterId : adapterId // ignore: cast_nullable_to_non_nullable
as String,authScheme: null == authScheme ? _self.authScheme : authScheme // ignore: cast_nullable_to_non_nullable
as AiAuthScheme,authParameterName: freezed == authParameterName ? _self.authParameterName : authParameterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AiProviderConnection {

 String get id; String get providerId; String get displayName; Uri get baseUri; String? get credentialRef; Map<AiEndpointKind, Uri> get endpointOverrides; Map<String, String> get customHeaders; Map<String, Object?> get adapterOptions; bool get enabled;
/// Create a copy of AiProviderConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiProviderConnectionCopyWith<AiProviderConnection> get copyWith => _$AiProviderConnectionCopyWithImpl<AiProviderConnection>(this as AiProviderConnection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiProviderConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.baseUri, baseUri) || other.baseUri == baseUri)&&(identical(other.credentialRef, credentialRef) || other.credentialRef == credentialRef)&&const DeepCollectionEquality().equals(other.endpointOverrides, endpointOverrides)&&const DeepCollectionEquality().equals(other.customHeaders, customHeaders)&&const DeepCollectionEquality().equals(other.adapterOptions, adapterOptions)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,providerId,displayName,baseUri,credentialRef,const DeepCollectionEquality().hash(endpointOverrides),const DeepCollectionEquality().hash(customHeaders),const DeepCollectionEquality().hash(adapterOptions),enabled);

@override
String toString() {
  return 'AiProviderConnection(id: $id, providerId: $providerId, displayName: $displayName, baseUri: $baseUri, credentialRef: $credentialRef, endpointOverrides: $endpointOverrides, customHeaders: $customHeaders, adapterOptions: $adapterOptions, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $AiProviderConnectionCopyWith<$Res>  {
  factory $AiProviderConnectionCopyWith(AiProviderConnection value, $Res Function(AiProviderConnection) _then) = _$AiProviderConnectionCopyWithImpl;
@useResult
$Res call({
 String id, String providerId, String displayName, Uri baseUri, String? credentialRef, Map<AiEndpointKind, Uri> endpointOverrides, Map<String, String> customHeaders, Map<String, Object?> adapterOptions, bool enabled
});




}
/// @nodoc
class _$AiProviderConnectionCopyWithImpl<$Res>
    implements $AiProviderConnectionCopyWith<$Res> {
  _$AiProviderConnectionCopyWithImpl(this._self, this._then);

  final AiProviderConnection _self;
  final $Res Function(AiProviderConnection) _then;

/// Create a copy of AiProviderConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? providerId = null,Object? displayName = null,Object? baseUri = null,Object? credentialRef = freezed,Object? endpointOverrides = null,Object? customHeaders = null,Object? adapterOptions = null,Object? enabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,baseUri: null == baseUri ? _self.baseUri : baseUri // ignore: cast_nullable_to_non_nullable
as Uri,credentialRef: freezed == credentialRef ? _self.credentialRef : credentialRef // ignore: cast_nullable_to_non_nullable
as String?,endpointOverrides: null == endpointOverrides ? _self.endpointOverrides : endpointOverrides // ignore: cast_nullable_to_non_nullable
as Map<AiEndpointKind, Uri>,customHeaders: null == customHeaders ? _self.customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,adapterOptions: null == adapterOptions ? _self.adapterOptions : adapterOptions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiProviderConnection].
extension AiProviderConnectionPatterns on AiProviderConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiProviderConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiProviderConnection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiProviderConnection value)  $default,){
final _that = this;
switch (_that) {
case _AiProviderConnection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiProviderConnection value)?  $default,){
final _that = this;
switch (_that) {
case _AiProviderConnection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String providerId,  String displayName,  Uri baseUri,  String? credentialRef,  Map<AiEndpointKind, Uri> endpointOverrides,  Map<String, String> customHeaders,  Map<String, Object?> adapterOptions,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiProviderConnection() when $default != null:
return $default(_that.id,_that.providerId,_that.displayName,_that.baseUri,_that.credentialRef,_that.endpointOverrides,_that.customHeaders,_that.adapterOptions,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String providerId,  String displayName,  Uri baseUri,  String? credentialRef,  Map<AiEndpointKind, Uri> endpointOverrides,  Map<String, String> customHeaders,  Map<String, Object?> adapterOptions,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _AiProviderConnection():
return $default(_that.id,_that.providerId,_that.displayName,_that.baseUri,_that.credentialRef,_that.endpointOverrides,_that.customHeaders,_that.adapterOptions,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String providerId,  String displayName,  Uri baseUri,  String? credentialRef,  Map<AiEndpointKind, Uri> endpointOverrides,  Map<String, String> customHeaders,  Map<String, Object?> adapterOptions,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _AiProviderConnection() when $default != null:
return $default(_that.id,_that.providerId,_that.displayName,_that.baseUri,_that.credentialRef,_that.endpointOverrides,_that.customHeaders,_that.adapterOptions,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _AiProviderConnection implements AiProviderConnection {
  const _AiProviderConnection({required this.id, required this.providerId, required this.displayName, required this.baseUri, this.credentialRef, final  Map<AiEndpointKind, Uri> endpointOverrides = const <AiEndpointKind, Uri>{}, final  Map<String, String> customHeaders = const <String, String>{}, final  Map<String, Object?> adapterOptions = const <String, Object?>{}, this.enabled = true}): _endpointOverrides = endpointOverrides,_customHeaders = customHeaders,_adapterOptions = adapterOptions;
  

@override final  String id;
@override final  String providerId;
@override final  String displayName;
@override final  Uri baseUri;
@override final  String? credentialRef;
 final  Map<AiEndpointKind, Uri> _endpointOverrides;
@override@JsonKey() Map<AiEndpointKind, Uri> get endpointOverrides {
  if (_endpointOverrides is EqualUnmodifiableMapView) return _endpointOverrides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_endpointOverrides);
}

 final  Map<String, String> _customHeaders;
@override@JsonKey() Map<String, String> get customHeaders {
  if (_customHeaders is EqualUnmodifiableMapView) return _customHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customHeaders);
}

 final  Map<String, Object?> _adapterOptions;
@override@JsonKey() Map<String, Object?> get adapterOptions {
  if (_adapterOptions is EqualUnmodifiableMapView) return _adapterOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_adapterOptions);
}

@override@JsonKey() final  bool enabled;

/// Create a copy of AiProviderConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiProviderConnectionCopyWith<_AiProviderConnection> get copyWith => __$AiProviderConnectionCopyWithImpl<_AiProviderConnection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiProviderConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.baseUri, baseUri) || other.baseUri == baseUri)&&(identical(other.credentialRef, credentialRef) || other.credentialRef == credentialRef)&&const DeepCollectionEquality().equals(other._endpointOverrides, _endpointOverrides)&&const DeepCollectionEquality().equals(other._customHeaders, _customHeaders)&&const DeepCollectionEquality().equals(other._adapterOptions, _adapterOptions)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,providerId,displayName,baseUri,credentialRef,const DeepCollectionEquality().hash(_endpointOverrides),const DeepCollectionEquality().hash(_customHeaders),const DeepCollectionEquality().hash(_adapterOptions),enabled);

@override
String toString() {
  return 'AiProviderConnection(id: $id, providerId: $providerId, displayName: $displayName, baseUri: $baseUri, credentialRef: $credentialRef, endpointOverrides: $endpointOverrides, customHeaders: $customHeaders, adapterOptions: $adapterOptions, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$AiProviderConnectionCopyWith<$Res> implements $AiProviderConnectionCopyWith<$Res> {
  factory _$AiProviderConnectionCopyWith(_AiProviderConnection value, $Res Function(_AiProviderConnection) _then) = __$AiProviderConnectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String providerId, String displayName, Uri baseUri, String? credentialRef, Map<AiEndpointKind, Uri> endpointOverrides, Map<String, String> customHeaders, Map<String, Object?> adapterOptions, bool enabled
});




}
/// @nodoc
class __$AiProviderConnectionCopyWithImpl<$Res>
    implements _$AiProviderConnectionCopyWith<$Res> {
  __$AiProviderConnectionCopyWithImpl(this._self, this._then);

  final _AiProviderConnection _self;
  final $Res Function(_AiProviderConnection) _then;

/// Create a copy of AiProviderConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? providerId = null,Object? displayName = null,Object? baseUri = null,Object? credentialRef = freezed,Object? endpointOverrides = null,Object? customHeaders = null,Object? adapterOptions = null,Object? enabled = null,}) {
  return _then(_AiProviderConnection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,providerId: null == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,baseUri: null == baseUri ? _self.baseUri : baseUri // ignore: cast_nullable_to_non_nullable
as Uri,credentialRef: freezed == credentialRef ? _self.credentialRef : credentialRef // ignore: cast_nullable_to_non_nullable
as String?,endpointOverrides: null == endpointOverrides ? _self._endpointOverrides : endpointOverrides // ignore: cast_nullable_to_non_nullable
as Map<AiEndpointKind, Uri>,customHeaders: null == customHeaders ? _self._customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,adapterOptions: null == adapterOptions ? _self._adapterOptions : adapterOptions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$AiContextPolicy {

 AiContextMode get mode; int get reservedOutputTokens; int get recentMessageMinimum; int? get recentMessageLimit; bool get includeToolResults; bool get enableSummarization;/// 模型元数据未提供上下文长度时使用的兜底值。正常情况下上下文预算
/// 按模型自身的 contextTokens 计算，该值仅在接口未返回长度字段时生效。
 int get fallbackContextTokens;
/// Create a copy of AiContextPolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiContextPolicyCopyWith<AiContextPolicy> get copyWith => _$AiContextPolicyCopyWithImpl<AiContextPolicy>(this as AiContextPolicy, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiContextPolicy&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reservedOutputTokens, reservedOutputTokens) || other.reservedOutputTokens == reservedOutputTokens)&&(identical(other.recentMessageMinimum, recentMessageMinimum) || other.recentMessageMinimum == recentMessageMinimum)&&(identical(other.recentMessageLimit, recentMessageLimit) || other.recentMessageLimit == recentMessageLimit)&&(identical(other.includeToolResults, includeToolResults) || other.includeToolResults == includeToolResults)&&(identical(other.enableSummarization, enableSummarization) || other.enableSummarization == enableSummarization)&&(identical(other.fallbackContextTokens, fallbackContextTokens) || other.fallbackContextTokens == fallbackContextTokens));
}


@override
int get hashCode => Object.hash(runtimeType,mode,reservedOutputTokens,recentMessageMinimum,recentMessageLimit,includeToolResults,enableSummarization,fallbackContextTokens);

@override
String toString() {
  return 'AiContextPolicy(mode: $mode, reservedOutputTokens: $reservedOutputTokens, recentMessageMinimum: $recentMessageMinimum, recentMessageLimit: $recentMessageLimit, includeToolResults: $includeToolResults, enableSummarization: $enableSummarization, fallbackContextTokens: $fallbackContextTokens)';
}


}

/// @nodoc
abstract mixin class $AiContextPolicyCopyWith<$Res>  {
  factory $AiContextPolicyCopyWith(AiContextPolicy value, $Res Function(AiContextPolicy) _then) = _$AiContextPolicyCopyWithImpl;
@useResult
$Res call({
 AiContextMode mode, int reservedOutputTokens, int recentMessageMinimum, int? recentMessageLimit, bool includeToolResults, bool enableSummarization, int fallbackContextTokens
});




}
/// @nodoc
class _$AiContextPolicyCopyWithImpl<$Res>
    implements $AiContextPolicyCopyWith<$Res> {
  _$AiContextPolicyCopyWithImpl(this._self, this._then);

  final AiContextPolicy _self;
  final $Res Function(AiContextPolicy) _then;

/// Create a copy of AiContextPolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? reservedOutputTokens = null,Object? recentMessageMinimum = null,Object? recentMessageLimit = freezed,Object? includeToolResults = null,Object? enableSummarization = null,Object? fallbackContextTokens = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AiContextMode,reservedOutputTokens: null == reservedOutputTokens ? _self.reservedOutputTokens : reservedOutputTokens // ignore: cast_nullable_to_non_nullable
as int,recentMessageMinimum: null == recentMessageMinimum ? _self.recentMessageMinimum : recentMessageMinimum // ignore: cast_nullable_to_non_nullable
as int,recentMessageLimit: freezed == recentMessageLimit ? _self.recentMessageLimit : recentMessageLimit // ignore: cast_nullable_to_non_nullable
as int?,includeToolResults: null == includeToolResults ? _self.includeToolResults : includeToolResults // ignore: cast_nullable_to_non_nullable
as bool,enableSummarization: null == enableSummarization ? _self.enableSummarization : enableSummarization // ignore: cast_nullable_to_non_nullable
as bool,fallbackContextTokens: null == fallbackContextTokens ? _self.fallbackContextTokens : fallbackContextTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiContextPolicy].
extension AiContextPolicyPatterns on AiContextPolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiContextPolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiContextPolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiContextPolicy value)  $default,){
final _that = this;
switch (_that) {
case _AiContextPolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiContextPolicy value)?  $default,){
final _that = this;
switch (_that) {
case _AiContextPolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiContextMode mode,  int reservedOutputTokens,  int recentMessageMinimum,  int? recentMessageLimit,  bool includeToolResults,  bool enableSummarization,  int fallbackContextTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiContextPolicy() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiContextMode mode,  int reservedOutputTokens,  int recentMessageMinimum,  int? recentMessageLimit,  bool includeToolResults,  bool enableSummarization,  int fallbackContextTokens)  $default,) {final _that = this;
switch (_that) {
case _AiContextPolicy():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiContextMode mode,  int reservedOutputTokens,  int recentMessageMinimum,  int? recentMessageLimit,  bool includeToolResults,  bool enableSummarization,  int fallbackContextTokens)?  $default,) {final _that = this;
switch (_that) {
case _AiContextPolicy() when $default != null:
return $default(_that.mode,_that.reservedOutputTokens,_that.recentMessageMinimum,_that.recentMessageLimit,_that.includeToolResults,_that.enableSummarization,_that.fallbackContextTokens);case _:
  return null;

}
}

}

/// @nodoc


class _AiContextPolicy implements AiContextPolicy {
  const _AiContextPolicy({this.mode = AiContextMode.tokenBudget, this.reservedOutputTokens = 1024, this.recentMessageMinimum = 4, this.recentMessageLimit, this.includeToolResults = true, this.enableSummarization = false, this.fallbackContextTokens = kDefaultFallbackContextTokens});
  

@override@JsonKey() final  AiContextMode mode;
@override@JsonKey() final  int reservedOutputTokens;
@override@JsonKey() final  int recentMessageMinimum;
@override final  int? recentMessageLimit;
@override@JsonKey() final  bool includeToolResults;
@override@JsonKey() final  bool enableSummarization;
/// 模型元数据未提供上下文长度时使用的兜底值。正常情况下上下文预算
/// 按模型自身的 contextTokens 计算，该值仅在接口未返回长度字段时生效。
@override@JsonKey() final  int fallbackContextTokens;

/// Create a copy of AiContextPolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiContextPolicyCopyWith<_AiContextPolicy> get copyWith => __$AiContextPolicyCopyWithImpl<_AiContextPolicy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiContextPolicy&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reservedOutputTokens, reservedOutputTokens) || other.reservedOutputTokens == reservedOutputTokens)&&(identical(other.recentMessageMinimum, recentMessageMinimum) || other.recentMessageMinimum == recentMessageMinimum)&&(identical(other.recentMessageLimit, recentMessageLimit) || other.recentMessageLimit == recentMessageLimit)&&(identical(other.includeToolResults, includeToolResults) || other.includeToolResults == includeToolResults)&&(identical(other.enableSummarization, enableSummarization) || other.enableSummarization == enableSummarization)&&(identical(other.fallbackContextTokens, fallbackContextTokens) || other.fallbackContextTokens == fallbackContextTokens));
}


@override
int get hashCode => Object.hash(runtimeType,mode,reservedOutputTokens,recentMessageMinimum,recentMessageLimit,includeToolResults,enableSummarization,fallbackContextTokens);

@override
String toString() {
  return 'AiContextPolicy(mode: $mode, reservedOutputTokens: $reservedOutputTokens, recentMessageMinimum: $recentMessageMinimum, recentMessageLimit: $recentMessageLimit, includeToolResults: $includeToolResults, enableSummarization: $enableSummarization, fallbackContextTokens: $fallbackContextTokens)';
}


}

/// @nodoc
abstract mixin class _$AiContextPolicyCopyWith<$Res> implements $AiContextPolicyCopyWith<$Res> {
  factory _$AiContextPolicyCopyWith(_AiContextPolicy value, $Res Function(_AiContextPolicy) _then) = __$AiContextPolicyCopyWithImpl;
@override @useResult
$Res call({
 AiContextMode mode, int reservedOutputTokens, int recentMessageMinimum, int? recentMessageLimit, bool includeToolResults, bool enableSummarization, int fallbackContextTokens
});




}
/// @nodoc
class __$AiContextPolicyCopyWithImpl<$Res>
    implements _$AiContextPolicyCopyWith<$Res> {
  __$AiContextPolicyCopyWithImpl(this._self, this._then);

  final _AiContextPolicy _self;
  final $Res Function(_AiContextPolicy) _then;

/// Create a copy of AiContextPolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? reservedOutputTokens = null,Object? recentMessageMinimum = null,Object? recentMessageLimit = freezed,Object? includeToolResults = null,Object? enableSummarization = null,Object? fallbackContextTokens = null,}) {
  return _then(_AiContextPolicy(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AiContextMode,reservedOutputTokens: null == reservedOutputTokens ? _self.reservedOutputTokens : reservedOutputTokens // ignore: cast_nullable_to_non_nullable
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
mixin _$AiToolPolicy {

 AiToolApprovalMode get approvalMode; int get maxRounds; int get maxResultBytes;
/// Create a copy of AiToolPolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiToolPolicyCopyWith<AiToolPolicy> get copyWith => _$AiToolPolicyCopyWithImpl<AiToolPolicy>(this as AiToolPolicy, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiToolPolicy&&(identical(other.approvalMode, approvalMode) || other.approvalMode == approvalMode)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.maxResultBytes, maxResultBytes) || other.maxResultBytes == maxResultBytes));
}


@override
int get hashCode => Object.hash(runtimeType,approvalMode,maxRounds,maxResultBytes);

@override
String toString() {
  return 'AiToolPolicy(approvalMode: $approvalMode, maxRounds: $maxRounds, maxResultBytes: $maxResultBytes)';
}


}

/// @nodoc
abstract mixin class $AiToolPolicyCopyWith<$Res>  {
  factory $AiToolPolicyCopyWith(AiToolPolicy value, $Res Function(AiToolPolicy) _then) = _$AiToolPolicyCopyWithImpl;
@useResult
$Res call({
 AiToolApprovalMode approvalMode, int maxRounds, int maxResultBytes
});




}
/// @nodoc
class _$AiToolPolicyCopyWithImpl<$Res>
    implements $AiToolPolicyCopyWith<$Res> {
  _$AiToolPolicyCopyWithImpl(this._self, this._then);

  final AiToolPolicy _self;
  final $Res Function(AiToolPolicy) _then;

/// Create a copy of AiToolPolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? approvalMode = null,Object? maxRounds = null,Object? maxResultBytes = null,}) {
  return _then(_self.copyWith(
approvalMode: null == approvalMode ? _self.approvalMode : approvalMode // ignore: cast_nullable_to_non_nullable
as AiToolApprovalMode,maxRounds: null == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int,maxResultBytes: null == maxResultBytes ? _self.maxResultBytes : maxResultBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiToolPolicy].
extension AiToolPolicyPatterns on AiToolPolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiToolPolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiToolPolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiToolPolicy value)  $default,){
final _that = this;
switch (_that) {
case _AiToolPolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiToolPolicy value)?  $default,){
final _that = this;
switch (_that) {
case _AiToolPolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiToolApprovalMode approvalMode,  int maxRounds,  int maxResultBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiToolPolicy() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiToolApprovalMode approvalMode,  int maxRounds,  int maxResultBytes)  $default,) {final _that = this;
switch (_that) {
case _AiToolPolicy():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiToolApprovalMode approvalMode,  int maxRounds,  int maxResultBytes)?  $default,) {final _that = this;
switch (_that) {
case _AiToolPolicy() when $default != null:
return $default(_that.approvalMode,_that.maxRounds,_that.maxResultBytes);case _:
  return null;

}
}

}

/// @nodoc


class _AiToolPolicy implements AiToolPolicy {
  const _AiToolPolicy({this.approvalMode = AiToolApprovalMode.riskyOnly, this.maxRounds = kDefaultMaxToolRounds, this.maxResultBytes = 1024 * 1024});
  

@override@JsonKey() final  AiToolApprovalMode approvalMode;
@override@JsonKey() final  int maxRounds;
@override@JsonKey() final  int maxResultBytes;

/// Create a copy of AiToolPolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiToolPolicyCopyWith<_AiToolPolicy> get copyWith => __$AiToolPolicyCopyWithImpl<_AiToolPolicy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiToolPolicy&&(identical(other.approvalMode, approvalMode) || other.approvalMode == approvalMode)&&(identical(other.maxRounds, maxRounds) || other.maxRounds == maxRounds)&&(identical(other.maxResultBytes, maxResultBytes) || other.maxResultBytes == maxResultBytes));
}


@override
int get hashCode => Object.hash(runtimeType,approvalMode,maxRounds,maxResultBytes);

@override
String toString() {
  return 'AiToolPolicy(approvalMode: $approvalMode, maxRounds: $maxRounds, maxResultBytes: $maxResultBytes)';
}


}

/// @nodoc
abstract mixin class _$AiToolPolicyCopyWith<$Res> implements $AiToolPolicyCopyWith<$Res> {
  factory _$AiToolPolicyCopyWith(_AiToolPolicy value, $Res Function(_AiToolPolicy) _then) = __$AiToolPolicyCopyWithImpl;
@override @useResult
$Res call({
 AiToolApprovalMode approvalMode, int maxRounds, int maxResultBytes
});




}
/// @nodoc
class __$AiToolPolicyCopyWithImpl<$Res>
    implements _$AiToolPolicyCopyWith<$Res> {
  __$AiToolPolicyCopyWithImpl(this._self, this._then);

  final _AiToolPolicy _self;
  final $Res Function(_AiToolPolicy) _then;

/// Create a copy of AiToolPolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? approvalMode = null,Object? maxRounds = null,Object? maxResultBytes = null,}) {
  return _then(_AiToolPolicy(
approvalMode: null == approvalMode ? _self.approvalMode : approvalMode // ignore: cast_nullable_to_non_nullable
as AiToolApprovalMode,maxRounds: null == maxRounds ? _self.maxRounds : maxRounds // ignore: cast_nullable_to_non_nullable
as int,maxResultBytes: null == maxResultBytes ? _self.maxResultBytes : maxResultBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AiAssistantProfile {

 String get id; String get name; String get connectionId; String get modelId; String? get systemPrompt; AiGenerationOptions get generation; AiContextPolicy get contextPolicy; AiToolPolicy get toolPolicy; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiAssistantProfileCopyWith<AiAssistantProfile> get copyWith => _$AiAssistantProfileCopyWithImpl<AiAssistantProfile>(this as AiAssistantProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiAssistantProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.contextPolicy, contextPolicy) || other.contextPolicy == contextPolicy)&&(identical(other.toolPolicy, toolPolicy) || other.toolPolicy == toolPolicy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,connectionId,modelId,systemPrompt,generation,contextPolicy,toolPolicy,createdAt,updatedAt);

@override
String toString() {
  return 'AiAssistantProfile(id: $id, name: $name, connectionId: $connectionId, modelId: $modelId, systemPrompt: $systemPrompt, generation: $generation, contextPolicy: $contextPolicy, toolPolicy: $toolPolicy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AiAssistantProfileCopyWith<$Res>  {
  factory $AiAssistantProfileCopyWith(AiAssistantProfile value, $Res Function(AiAssistantProfile) _then) = _$AiAssistantProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, String connectionId, String modelId, String? systemPrompt, AiGenerationOptions generation, AiContextPolicy contextPolicy, AiToolPolicy toolPolicy, DateTime createdAt, DateTime updatedAt
});


$AiGenerationOptionsCopyWith<$Res> get generation;$AiContextPolicyCopyWith<$Res> get contextPolicy;$AiToolPolicyCopyWith<$Res> get toolPolicy;

}
/// @nodoc
class _$AiAssistantProfileCopyWithImpl<$Res>
    implements $AiAssistantProfileCopyWith<$Res> {
  _$AiAssistantProfileCopyWithImpl(this._self, this._then);

  final AiAssistantProfile _self;
  final $Res Function(AiAssistantProfile) _then;

/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? connectionId = null,Object? modelId = null,Object? systemPrompt = freezed,Object? generation = null,Object? contextPolicy = null,Object? toolPolicy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: freezed == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as AiGenerationOptions,contextPolicy: null == contextPolicy ? _self.contextPolicy : contextPolicy // ignore: cast_nullable_to_non_nullable
as AiContextPolicy,toolPolicy: null == toolPolicy ? _self.toolPolicy : toolPolicy // ignore: cast_nullable_to_non_nullable
as AiToolPolicy,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiGenerationOptionsCopyWith<$Res> get generation {
  
  return $AiGenerationOptionsCopyWith<$Res>(_self.generation, (value) {
    return _then(_self.copyWith(generation: value));
  });
}/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiContextPolicyCopyWith<$Res> get contextPolicy {
  
  return $AiContextPolicyCopyWith<$Res>(_self.contextPolicy, (value) {
    return _then(_self.copyWith(contextPolicy: value));
  });
}/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiToolPolicyCopyWith<$Res> get toolPolicy {
  
  return $AiToolPolicyCopyWith<$Res>(_self.toolPolicy, (value) {
    return _then(_self.copyWith(toolPolicy: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiAssistantProfile].
extension AiAssistantProfilePatterns on AiAssistantProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiAssistantProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiAssistantProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiAssistantProfile value)  $default,){
final _that = this;
switch (_that) {
case _AiAssistantProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiAssistantProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AiAssistantProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String connectionId,  String modelId,  String? systemPrompt,  AiGenerationOptions generation,  AiContextPolicy contextPolicy,  AiToolPolicy toolPolicy,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiAssistantProfile() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String connectionId,  String modelId,  String? systemPrompt,  AiGenerationOptions generation,  AiContextPolicy contextPolicy,  AiToolPolicy toolPolicy,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AiAssistantProfile():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String connectionId,  String modelId,  String? systemPrompt,  AiGenerationOptions generation,  AiContextPolicy contextPolicy,  AiToolPolicy toolPolicy,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiAssistantProfile() when $default != null:
return $default(_that.id,_that.name,_that.connectionId,_that.modelId,_that.systemPrompt,_that.generation,_that.contextPolicy,_that.toolPolicy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AiAssistantProfile implements AiAssistantProfile {
  const _AiAssistantProfile({required this.id, required this.name, required this.connectionId, required this.modelId, this.systemPrompt, this.generation = const AiGenerationOptions(), this.contextPolicy = const AiContextPolicy(), this.toolPolicy = const AiToolPolicy(), required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String name;
@override final  String connectionId;
@override final  String modelId;
@override final  String? systemPrompt;
@override@JsonKey() final  AiGenerationOptions generation;
@override@JsonKey() final  AiContextPolicy contextPolicy;
@override@JsonKey() final  AiToolPolicy toolPolicy;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiAssistantProfileCopyWith<_AiAssistantProfile> get copyWith => __$AiAssistantProfileCopyWithImpl<_AiAssistantProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiAssistantProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&(identical(other.modelId, modelId) || other.modelId == modelId)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.contextPolicy, contextPolicy) || other.contextPolicy == contextPolicy)&&(identical(other.toolPolicy, toolPolicy) || other.toolPolicy == toolPolicy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,connectionId,modelId,systemPrompt,generation,contextPolicy,toolPolicy,createdAt,updatedAt);

@override
String toString() {
  return 'AiAssistantProfile(id: $id, name: $name, connectionId: $connectionId, modelId: $modelId, systemPrompt: $systemPrompt, generation: $generation, contextPolicy: $contextPolicy, toolPolicy: $toolPolicy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AiAssistantProfileCopyWith<$Res> implements $AiAssistantProfileCopyWith<$Res> {
  factory _$AiAssistantProfileCopyWith(_AiAssistantProfile value, $Res Function(_AiAssistantProfile) _then) = __$AiAssistantProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String connectionId, String modelId, String? systemPrompt, AiGenerationOptions generation, AiContextPolicy contextPolicy, AiToolPolicy toolPolicy, DateTime createdAt, DateTime updatedAt
});


@override $AiGenerationOptionsCopyWith<$Res> get generation;@override $AiContextPolicyCopyWith<$Res> get contextPolicy;@override $AiToolPolicyCopyWith<$Res> get toolPolicy;

}
/// @nodoc
class __$AiAssistantProfileCopyWithImpl<$Res>
    implements _$AiAssistantProfileCopyWith<$Res> {
  __$AiAssistantProfileCopyWithImpl(this._self, this._then);

  final _AiAssistantProfile _self;
  final $Res Function(_AiAssistantProfile) _then;

/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? connectionId = null,Object? modelId = null,Object? systemPrompt = freezed,Object? generation = null,Object? contextPolicy = null,Object? toolPolicy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AiAssistantProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,modelId: null == modelId ? _self.modelId : modelId // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: freezed == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String?,generation: null == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as AiGenerationOptions,contextPolicy: null == contextPolicy ? _self.contextPolicy : contextPolicy // ignore: cast_nullable_to_non_nullable
as AiContextPolicy,toolPolicy: null == toolPolicy ? _self.toolPolicy : toolPolicy // ignore: cast_nullable_to_non_nullable
as AiToolPolicy,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiGenerationOptionsCopyWith<$Res> get generation {
  
  return $AiGenerationOptionsCopyWith<$Res>(_self.generation, (value) {
    return _then(_self.copyWith(generation: value));
  });
}/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiContextPolicyCopyWith<$Res> get contextPolicy {
  
  return $AiContextPolicyCopyWith<$Res>(_self.contextPolicy, (value) {
    return _then(_self.copyWith(contextPolicy: value));
  });
}/// Create a copy of AiAssistantProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiToolPolicyCopyWith<$Res> get toolPolicy {
  
  return $AiToolPolicyCopyWith<$Res>(_self.toolPolicy, (value) {
    return _then(_self.copyWith(toolPolicy: value));
  });
}
}

/// @nodoc
mixin _$AiConversation {

 String get id; String get title; String get assistantId; String get environmentId; String? get scopeId; DateTime get createdAt; DateTime get updatedAt; DateTime? get archivedAt;
/// Create a copy of AiConversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiConversationCopyWith<AiConversation> get copyWith => _$AiConversationCopyWithImpl<AiConversation>(this as AiConversation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.assistantId, assistantId) || other.assistantId == assistantId)&&(identical(other.environmentId, environmentId) || other.environmentId == environmentId)&&(identical(other.scopeId, scopeId) || other.scopeId == scopeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,assistantId,environmentId,scopeId,createdAt,updatedAt,archivedAt);

@override
String toString() {
  return 'AiConversation(id: $id, title: $title, assistantId: $assistantId, environmentId: $environmentId, scopeId: $scopeId, createdAt: $createdAt, updatedAt: $updatedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $AiConversationCopyWith<$Res>  {
  factory $AiConversationCopyWith(AiConversation value, $Res Function(AiConversation) _then) = _$AiConversationCopyWithImpl;
@useResult
$Res call({
 String id, String title, String assistantId, String environmentId, String? scopeId, DateTime createdAt, DateTime updatedAt, DateTime? archivedAt
});




}
/// @nodoc
class _$AiConversationCopyWithImpl<$Res>
    implements $AiConversationCopyWith<$Res> {
  _$AiConversationCopyWithImpl(this._self, this._then);

  final AiConversation _self;
  final $Res Function(AiConversation) _then;

/// Create a copy of AiConversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? assistantId = null,Object? environmentId = null,Object? scopeId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,assistantId: null == assistantId ? _self.assistantId : assistantId // ignore: cast_nullable_to_non_nullable
as String,environmentId: null == environmentId ? _self.environmentId : environmentId // ignore: cast_nullable_to_non_nullable
as String,scopeId: freezed == scopeId ? _self.scopeId : scopeId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiConversation].
extension AiConversationPatterns on AiConversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiConversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiConversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiConversation value)  $default,){
final _that = this;
switch (_that) {
case _AiConversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiConversation value)?  $default,){
final _that = this;
switch (_that) {
case _AiConversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String assistantId,  String environmentId,  String? scopeId,  DateTime createdAt,  DateTime updatedAt,  DateTime? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiConversation() when $default != null:
return $default(_that.id,_that.title,_that.assistantId,_that.environmentId,_that.scopeId,_that.createdAt,_that.updatedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String assistantId,  String environmentId,  String? scopeId,  DateTime createdAt,  DateTime updatedAt,  DateTime? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _AiConversation():
return $default(_that.id,_that.title,_that.assistantId,_that.environmentId,_that.scopeId,_that.createdAt,_that.updatedAt,_that.archivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String assistantId,  String environmentId,  String? scopeId,  DateTime createdAt,  DateTime updatedAt,  DateTime? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiConversation() when $default != null:
return $default(_that.id,_that.title,_that.assistantId,_that.environmentId,_that.scopeId,_that.createdAt,_that.updatedAt,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AiConversation implements AiConversation {
  const _AiConversation({required this.id, required this.title, required this.assistantId, this.environmentId = 'general', this.scopeId, required this.createdAt, required this.updatedAt, this.archivedAt});
  

@override final  String id;
@override final  String title;
@override final  String assistantId;
@override@JsonKey() final  String environmentId;
@override final  String? scopeId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? archivedAt;

/// Create a copy of AiConversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiConversationCopyWith<_AiConversation> get copyWith => __$AiConversationCopyWithImpl<_AiConversation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiConversation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.assistantId, assistantId) || other.assistantId == assistantId)&&(identical(other.environmentId, environmentId) || other.environmentId == environmentId)&&(identical(other.scopeId, scopeId) || other.scopeId == scopeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,assistantId,environmentId,scopeId,createdAt,updatedAt,archivedAt);

@override
String toString() {
  return 'AiConversation(id: $id, title: $title, assistantId: $assistantId, environmentId: $environmentId, scopeId: $scopeId, createdAt: $createdAt, updatedAt: $updatedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$AiConversationCopyWith<$Res> implements $AiConversationCopyWith<$Res> {
  factory _$AiConversationCopyWith(_AiConversation value, $Res Function(_AiConversation) _then) = __$AiConversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String assistantId, String environmentId, String? scopeId, DateTime createdAt, DateTime updatedAt, DateTime? archivedAt
});




}
/// @nodoc
class __$AiConversationCopyWithImpl<$Res>
    implements _$AiConversationCopyWith<$Res> {
  __$AiConversationCopyWithImpl(this._self, this._then);

  final _AiConversation _self;
  final $Res Function(_AiConversation) _then;

/// Create a copy of AiConversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? assistantId = null,Object? environmentId = null,Object? scopeId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? archivedAt = freezed,}) {
  return _then(_AiConversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,assistantId: null == assistantId ? _self.assistantId : assistantId // ignore: cast_nullable_to_non_nullable
as String,environmentId: null == environmentId ? _self.environmentId : environmentId // ignore: cast_nullable_to_non_nullable
as String,scopeId: freezed == scopeId ? _self.scopeId : scopeId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$AiRequest {

 String get requestId; AiProviderConnection get connection; AiModelDefinition get model; List<AiMessage> get messages; AiGenerationOptions get options; List<AiToolSpec> get tools;
/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiRequestCopyWith<AiRequest> get copyWith => _$AiRequestCopyWithImpl<AiRequest>(this as AiRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.options, options) || other.options == options)&&const DeepCollectionEquality().equals(other.tools, tools));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,connection,model,const DeepCollectionEquality().hash(messages),options,const DeepCollectionEquality().hash(tools));

@override
String toString() {
  return 'AiRequest(requestId: $requestId, connection: $connection, model: $model, messages: $messages, options: $options, tools: $tools)';
}


}

/// @nodoc
abstract mixin class $AiRequestCopyWith<$Res>  {
  factory $AiRequestCopyWith(AiRequest value, $Res Function(AiRequest) _then) = _$AiRequestCopyWithImpl;
@useResult
$Res call({
 String requestId, AiProviderConnection connection, AiModelDefinition model, List<AiMessage> messages, AiGenerationOptions options, List<AiToolSpec> tools
});


$AiProviderConnectionCopyWith<$Res> get connection;$AiModelDefinitionCopyWith<$Res> get model;$AiGenerationOptionsCopyWith<$Res> get options;

}
/// @nodoc
class _$AiRequestCopyWithImpl<$Res>
    implements $AiRequestCopyWith<$Res> {
  _$AiRequestCopyWithImpl(this._self, this._then);

  final AiRequest _self;
  final $Res Function(AiRequest) _then;

/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? connection = null,Object? model = null,Object? messages = null,Object? options = null,Object? tools = null,}) {
  return _then(_self.copyWith(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AiProviderConnection,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as AiModelDefinition,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as AiGenerationOptions,tools: null == tools ? _self.tools : tools // ignore: cast_nullable_to_non_nullable
as List<AiToolSpec>,
  ));
}
/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiProviderConnectionCopyWith<$Res> get connection {
  
  return $AiProviderConnectionCopyWith<$Res>(_self.connection, (value) {
    return _then(_self.copyWith(connection: value));
  });
}/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelDefinitionCopyWith<$Res> get model {
  
  return $AiModelDefinitionCopyWith<$Res>(_self.model, (value) {
    return _then(_self.copyWith(model: value));
  });
}/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiGenerationOptionsCopyWith<$Res> get options {
  
  return $AiGenerationOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiRequest].
extension AiRequestPatterns on AiRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiRequest value)  $default,){
final _that = this;
switch (_that) {
case _AiRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AiRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  AiProviderConnection connection,  AiModelDefinition model,  List<AiMessage> messages,  AiGenerationOptions options,  List<AiToolSpec> tools)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiRequest() when $default != null:
return $default(_that.requestId,_that.connection,_that.model,_that.messages,_that.options,_that.tools);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  AiProviderConnection connection,  AiModelDefinition model,  List<AiMessage> messages,  AiGenerationOptions options,  List<AiToolSpec> tools)  $default,) {final _that = this;
switch (_that) {
case _AiRequest():
return $default(_that.requestId,_that.connection,_that.model,_that.messages,_that.options,_that.tools);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  AiProviderConnection connection,  AiModelDefinition model,  List<AiMessage> messages,  AiGenerationOptions options,  List<AiToolSpec> tools)?  $default,) {final _that = this;
switch (_that) {
case _AiRequest() when $default != null:
return $default(_that.requestId,_that.connection,_that.model,_that.messages,_that.options,_that.tools);case _:
  return null;

}
}

}

/// @nodoc


class _AiRequest implements AiRequest {
  const _AiRequest({required this.requestId, required this.connection, required this.model, required final  List<AiMessage> messages, this.options = const AiGenerationOptions(), final  List<AiToolSpec> tools = const <AiToolSpec>[]}): _messages = messages,_tools = tools;
  

@override final  String requestId;
@override final  AiProviderConnection connection;
@override final  AiModelDefinition model;
 final  List<AiMessage> _messages;
@override List<AiMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  AiGenerationOptions options;
 final  List<AiToolSpec> _tools;
@override@JsonKey() List<AiToolSpec> get tools {
  if (_tools is EqualUnmodifiableListView) return _tools;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tools);
}


/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiRequestCopyWith<_AiRequest> get copyWith => __$AiRequestCopyWithImpl<_AiRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.options, options) || other.options == options)&&const DeepCollectionEquality().equals(other._tools, _tools));
}


@override
int get hashCode => Object.hash(runtimeType,requestId,connection,model,const DeepCollectionEquality().hash(_messages),options,const DeepCollectionEquality().hash(_tools));

@override
String toString() {
  return 'AiRequest(requestId: $requestId, connection: $connection, model: $model, messages: $messages, options: $options, tools: $tools)';
}


}

/// @nodoc
abstract mixin class _$AiRequestCopyWith<$Res> implements $AiRequestCopyWith<$Res> {
  factory _$AiRequestCopyWith(_AiRequest value, $Res Function(_AiRequest) _then) = __$AiRequestCopyWithImpl;
@override @useResult
$Res call({
 String requestId, AiProviderConnection connection, AiModelDefinition model, List<AiMessage> messages, AiGenerationOptions options, List<AiToolSpec> tools
});


@override $AiProviderConnectionCopyWith<$Res> get connection;@override $AiModelDefinitionCopyWith<$Res> get model;@override $AiGenerationOptionsCopyWith<$Res> get options;

}
/// @nodoc
class __$AiRequestCopyWithImpl<$Res>
    implements _$AiRequestCopyWith<$Res> {
  __$AiRequestCopyWithImpl(this._self, this._then);

  final _AiRequest _self;
  final $Res Function(_AiRequest) _then;

/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? connection = null,Object? model = null,Object? messages = null,Object? options = null,Object? tools = null,}) {
  return _then(_AiRequest(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as AiProviderConnection,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as AiModelDefinition,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as AiGenerationOptions,tools: null == tools ? _self._tools : tools // ignore: cast_nullable_to_non_nullable
as List<AiToolSpec>,
  ));
}

/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiProviderConnectionCopyWith<$Res> get connection {
  
  return $AiProviderConnectionCopyWith<$Res>(_self.connection, (value) {
    return _then(_self.copyWith(connection: value));
  });
}/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiModelDefinitionCopyWith<$Res> get model {
  
  return $AiModelDefinitionCopyWith<$Res>(_self.model, (value) {
    return _then(_self.copyWith(model: value));
  });
}/// Create a copy of AiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiGenerationOptionsCopyWith<$Res> get options {
  
  return $AiGenerationOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}

/// @nodoc
mixin _$AiUsage {

 int get inputTokens; int get outputTokens; int get totalTokens;
/// Create a copy of AiUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiUsageCopyWith<AiUsage> get copyWith => _$AiUsageCopyWithImpl<AiUsage>(this as AiUsage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiUsage&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens)&&(identical(other.totalTokens, totalTokens) || other.totalTokens == totalTokens));
}


@override
int get hashCode => Object.hash(runtimeType,inputTokens,outputTokens,totalTokens);

@override
String toString() {
  return 'AiUsage(inputTokens: $inputTokens, outputTokens: $outputTokens, totalTokens: $totalTokens)';
}


}

/// @nodoc
abstract mixin class $AiUsageCopyWith<$Res>  {
  factory $AiUsageCopyWith(AiUsage value, $Res Function(AiUsage) _then) = _$AiUsageCopyWithImpl;
@useResult
$Res call({
 int inputTokens, int outputTokens, int totalTokens
});




}
/// @nodoc
class _$AiUsageCopyWithImpl<$Res>
    implements $AiUsageCopyWith<$Res> {
  _$AiUsageCopyWithImpl(this._self, this._then);

  final AiUsage _self;
  final $Res Function(AiUsage) _then;

/// Create a copy of AiUsage
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


/// Adds pattern-matching-related methods to [AiUsage].
extension AiUsagePatterns on AiUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiUsage value)  $default,){
final _that = this;
switch (_that) {
case _AiUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiUsage value)?  $default,){
final _that = this;
switch (_that) {
case _AiUsage() when $default != null:
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
case _AiUsage() when $default != null:
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
case _AiUsage():
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
case _AiUsage() when $default != null:
return $default(_that.inputTokens,_that.outputTokens,_that.totalTokens);case _:
  return null;

}
}

}

/// @nodoc


class _AiUsage implements AiUsage {
  const _AiUsage({this.inputTokens = 0, this.outputTokens = 0, this.totalTokens = 0});
  

@override@JsonKey() final  int inputTokens;
@override@JsonKey() final  int outputTokens;
@override@JsonKey() final  int totalTokens;

/// Create a copy of AiUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiUsageCopyWith<_AiUsage> get copyWith => __$AiUsageCopyWithImpl<_AiUsage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiUsage&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens)&&(identical(other.totalTokens, totalTokens) || other.totalTokens == totalTokens));
}


@override
int get hashCode => Object.hash(runtimeType,inputTokens,outputTokens,totalTokens);

@override
String toString() {
  return 'AiUsage(inputTokens: $inputTokens, outputTokens: $outputTokens, totalTokens: $totalTokens)';
}


}

/// @nodoc
abstract mixin class _$AiUsageCopyWith<$Res> implements $AiUsageCopyWith<$Res> {
  factory _$AiUsageCopyWith(_AiUsage value, $Res Function(_AiUsage) _then) = __$AiUsageCopyWithImpl;
@override @useResult
$Res call({
 int inputTokens, int outputTokens, int totalTokens
});




}
/// @nodoc
class __$AiUsageCopyWithImpl<$Res>
    implements _$AiUsageCopyWith<$Res> {
  __$AiUsageCopyWithImpl(this._self, this._then);

  final _AiUsage _self;
  final $Res Function(_AiUsage) _then;

/// Create a copy of AiUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputTokens = null,Object? outputTokens = null,Object? totalTokens = null,}) {
  return _then(_AiUsage(
inputTokens: null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,outputTokens: null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,totalTokens: null == totalTokens ? _self.totalTokens : totalTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AiFailure {

 AiFailureCode get code; String get messageKey; bool get retryable; int? get httpStatus; String? get providerRequestId; String? get detail;
/// Create a copy of AiFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiFailureCopyWith<AiFailure> get copyWith => _$AiFailureCopyWithImpl<AiFailure>(this as AiFailure, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiFailure&&(identical(other.code, code) || other.code == code)&&(identical(other.messageKey, messageKey) || other.messageKey == messageKey)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.httpStatus, httpStatus) || other.httpStatus == httpStatus)&&(identical(other.providerRequestId, providerRequestId) || other.providerRequestId == providerRequestId)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,code,messageKey,retryable,httpStatus,providerRequestId,detail);

@override
String toString() {
  return 'AiFailure(code: $code, messageKey: $messageKey, retryable: $retryable, httpStatus: $httpStatus, providerRequestId: $providerRequestId, detail: $detail)';
}


}

/// @nodoc
abstract mixin class $AiFailureCopyWith<$Res>  {
  factory $AiFailureCopyWith(AiFailure value, $Res Function(AiFailure) _then) = _$AiFailureCopyWithImpl;
@useResult
$Res call({
 AiFailureCode code, String messageKey, bool retryable, int? httpStatus, String? providerRequestId, String? detail
});




}
/// @nodoc
class _$AiFailureCopyWithImpl<$Res>
    implements $AiFailureCopyWith<$Res> {
  _$AiFailureCopyWithImpl(this._self, this._then);

  final AiFailure _self;
  final $Res Function(AiFailure) _then;

/// Create a copy of AiFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? messageKey = null,Object? retryable = null,Object? httpStatus = freezed,Object? providerRequestId = freezed,Object? detail = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as AiFailureCode,messageKey: null == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,httpStatus: freezed == httpStatus ? _self.httpStatus : httpStatus // ignore: cast_nullable_to_non_nullable
as int?,providerRequestId: freezed == providerRequestId ? _self.providerRequestId : providerRequestId // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiFailure].
extension AiFailurePatterns on AiFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiFailure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiFailure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiFailure value)  $default,){
final _that = this;
switch (_that) {
case _AiFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiFailure value)?  $default,){
final _that = this;
switch (_that) {
case _AiFailure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiFailureCode code,  String messageKey,  bool retryable,  int? httpStatus,  String? providerRequestId,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiFailure() when $default != null:
return $default(_that.code,_that.messageKey,_that.retryable,_that.httpStatus,_that.providerRequestId,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiFailureCode code,  String messageKey,  bool retryable,  int? httpStatus,  String? providerRequestId,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _AiFailure():
return $default(_that.code,_that.messageKey,_that.retryable,_that.httpStatus,_that.providerRequestId,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiFailureCode code,  String messageKey,  bool retryable,  int? httpStatus,  String? providerRequestId,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _AiFailure() when $default != null:
return $default(_that.code,_that.messageKey,_that.retryable,_that.httpStatus,_that.providerRequestId,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _AiFailure implements AiFailure {
  const _AiFailure({required this.code, required this.messageKey, this.retryable = false, this.httpStatus, this.providerRequestId, this.detail});
  

@override final  AiFailureCode code;
@override final  String messageKey;
@override@JsonKey() final  bool retryable;
@override final  int? httpStatus;
@override final  String? providerRequestId;
@override final  String? detail;

/// Create a copy of AiFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiFailureCopyWith<_AiFailure> get copyWith => __$AiFailureCopyWithImpl<_AiFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiFailure&&(identical(other.code, code) || other.code == code)&&(identical(other.messageKey, messageKey) || other.messageKey == messageKey)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&(identical(other.httpStatus, httpStatus) || other.httpStatus == httpStatus)&&(identical(other.providerRequestId, providerRequestId) || other.providerRequestId == providerRequestId)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,code,messageKey,retryable,httpStatus,providerRequestId,detail);

@override
String toString() {
  return 'AiFailure(code: $code, messageKey: $messageKey, retryable: $retryable, httpStatus: $httpStatus, providerRequestId: $providerRequestId, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$AiFailureCopyWith<$Res> implements $AiFailureCopyWith<$Res> {
  factory _$AiFailureCopyWith(_AiFailure value, $Res Function(_AiFailure) _then) = __$AiFailureCopyWithImpl;
@override @useResult
$Res call({
 AiFailureCode code, String messageKey, bool retryable, int? httpStatus, String? providerRequestId, String? detail
});




}
/// @nodoc
class __$AiFailureCopyWithImpl<$Res>
    implements _$AiFailureCopyWith<$Res> {
  __$AiFailureCopyWithImpl(this._self, this._then);

  final _AiFailure _self;
  final $Res Function(_AiFailure) _then;

/// Create a copy of AiFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? messageKey = null,Object? retryable = null,Object? httpStatus = freezed,Object? providerRequestId = freezed,Object? detail = freezed,}) {
  return _then(_AiFailure(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as AiFailureCode,messageKey: null == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,httpStatus: freezed == httpStatus ? _self.httpStatus : httpStatus // ignore: cast_nullable_to_non_nullable
as int?,providerRequestId: freezed == providerRequestId ? _self.providerRequestId : providerRequestId // ignore: cast_nullable_to_non_nullable
as String?,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
