// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_conversation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiConversationDto {

 String get id; String get title; String get assistantId; String get environmentId; String? get scopeId; String get createdAt; String get updatedAt; String? get archivedAt;
/// Create a copy of AiConversationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiConversationDtoCopyWith<AiConversationDto> get copyWith => _$AiConversationDtoCopyWithImpl<AiConversationDto>(this as AiConversationDto, _$identity);

  /// Serializes this AiConversationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiConversationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.assistantId, assistantId) || other.assistantId == assistantId)&&(identical(other.environmentId, environmentId) || other.environmentId == environmentId)&&(identical(other.scopeId, scopeId) || other.scopeId == scopeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,assistantId,environmentId,scopeId,createdAt,updatedAt,archivedAt);

@override
String toString() {
  return 'AiConversationDto(id: $id, title: $title, assistantId: $assistantId, environmentId: $environmentId, scopeId: $scopeId, createdAt: $createdAt, updatedAt: $updatedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class $AiConversationDtoCopyWith<$Res>  {
  factory $AiConversationDtoCopyWith(AiConversationDto value, $Res Function(AiConversationDto) _then) = _$AiConversationDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String assistantId, String environmentId, String? scopeId, String createdAt, String updatedAt, String? archivedAt
});




}
/// @nodoc
class _$AiConversationDtoCopyWithImpl<$Res>
    implements $AiConversationDtoCopyWith<$Res> {
  _$AiConversationDtoCopyWithImpl(this._self, this._then);

  final AiConversationDto _self;
  final $Res Function(AiConversationDto) _then;

/// Create a copy of AiConversationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? assistantId = null,Object? environmentId = null,Object? scopeId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? archivedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,assistantId: null == assistantId ? _self.assistantId : assistantId // ignore: cast_nullable_to_non_nullable
as String,environmentId: null == environmentId ? _self.environmentId : environmentId // ignore: cast_nullable_to_non_nullable
as String,scopeId: freezed == scopeId ? _self.scopeId : scopeId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AiConversationDto].
extension AiConversationDtoPatterns on AiConversationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiConversationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiConversationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiConversationDto value)  $default,){
final _that = this;
switch (_that) {
case _AiConversationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiConversationDto value)?  $default,){
final _that = this;
switch (_that) {
case _AiConversationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String assistantId,  String environmentId,  String? scopeId,  String createdAt,  String updatedAt,  String? archivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiConversationDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String assistantId,  String environmentId,  String? scopeId,  String createdAt,  String updatedAt,  String? archivedAt)  $default,) {final _that = this;
switch (_that) {
case _AiConversationDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String assistantId,  String environmentId,  String? scopeId,  String createdAt,  String updatedAt,  String? archivedAt)?  $default,) {final _that = this;
switch (_that) {
case _AiConversationDto() when $default != null:
return $default(_that.id,_that.title,_that.assistantId,_that.environmentId,_that.scopeId,_that.createdAt,_that.updatedAt,_that.archivedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiConversationDto extends AiConversationDto {
  const _AiConversationDto({required this.id, required this.title, required this.assistantId, this.environmentId = 'general', this.scopeId, required this.createdAt, required this.updatedAt, this.archivedAt}): super._();
  factory _AiConversationDto.fromJson(Map<String, dynamic> json) => _$AiConversationDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String assistantId;
@override@JsonKey() final  String environmentId;
@override final  String? scopeId;
@override final  String createdAt;
@override final  String updatedAt;
@override final  String? archivedAt;

/// Create a copy of AiConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiConversationDtoCopyWith<_AiConversationDto> get copyWith => __$AiConversationDtoCopyWithImpl<_AiConversationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiConversationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiConversationDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.assistantId, assistantId) || other.assistantId == assistantId)&&(identical(other.environmentId, environmentId) || other.environmentId == environmentId)&&(identical(other.scopeId, scopeId) || other.scopeId == scopeId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,assistantId,environmentId,scopeId,createdAt,updatedAt,archivedAt);

@override
String toString() {
  return 'AiConversationDto(id: $id, title: $title, assistantId: $assistantId, environmentId: $environmentId, scopeId: $scopeId, createdAt: $createdAt, updatedAt: $updatedAt, archivedAt: $archivedAt)';
}


}

/// @nodoc
abstract mixin class _$AiConversationDtoCopyWith<$Res> implements $AiConversationDtoCopyWith<$Res> {
  factory _$AiConversationDtoCopyWith(_AiConversationDto value, $Res Function(_AiConversationDto) _then) = __$AiConversationDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String assistantId, String environmentId, String? scopeId, String createdAt, String updatedAt, String? archivedAt
});




}
/// @nodoc
class __$AiConversationDtoCopyWithImpl<$Res>
    implements _$AiConversationDtoCopyWith<$Res> {
  __$AiConversationDtoCopyWithImpl(this._self, this._then);

  final _AiConversationDto _self;
  final $Res Function(_AiConversationDto) _then;

/// Create a copy of AiConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? assistantId = null,Object? environmentId = null,Object? scopeId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? archivedAt = freezed,}) {
  return _then(_AiConversationDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,assistantId: null == assistantId ? _self.assistantId : assistantId // ignore: cast_nullable_to_non_nullable
as String,environmentId: null == environmentId ? _self.environmentId : environmentId // ignore: cast_nullable_to_non_nullable
as String,scopeId: freezed == scopeId ? _self.scopeId : scopeId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
