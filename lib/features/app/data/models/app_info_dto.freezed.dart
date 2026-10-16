// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppInfoDto {

 String get name; String get packageName; String get versionName; int get versionCode; bool get isSystemApp;@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? get icon;
/// Create a copy of AppInfoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppInfoDtoCopyWith<AppInfoDto> get copyWith => _$AppInfoDtoCopyWithImpl<AppInfoDto>(this as AppInfoDto, _$identity);

  /// Serializes this AppInfoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppInfoDto&&(identical(other.name, name) || other.name == name)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.versionName, versionName) || other.versionName == versionName)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.isSystemApp, isSystemApp) || other.isSystemApp == isSystemApp)&&const DeepCollectionEquality().equals(other.icon, icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,packageName,versionName,versionCode,isSystemApp,const DeepCollectionEquality().hash(icon));

@override
String toString() {
  return 'AppInfoDto(name: $name, packageName: $packageName, versionName: $versionName, versionCode: $versionCode, isSystemApp: $isSystemApp, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $AppInfoDtoCopyWith<$Res>  {
  factory $AppInfoDtoCopyWith(AppInfoDto value, $Res Function(AppInfoDto) _then) = _$AppInfoDtoCopyWithImpl;
@useResult
$Res call({
 String name, String packageName, String versionName, int versionCode, bool isSystemApp,@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? icon
});




}
/// @nodoc
class _$AppInfoDtoCopyWithImpl<$Res>
    implements $AppInfoDtoCopyWith<$Res> {
  _$AppInfoDtoCopyWithImpl(this._self, this._then);

  final AppInfoDto _self;
  final $Res Function(AppInfoDto) _then;

/// Create a copy of AppInfoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? packageName = null,Object? versionName = null,Object? versionCode = null,Object? isSystemApp = null,Object? icon = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,versionName: null == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String,versionCode: null == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as int,isSystemApp: null == isSystemApp ? _self.isSystemApp : isSystemApp // ignore: cast_nullable_to_non_nullable
as bool,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppInfoDto].
extension AppInfoDtoPatterns on AppInfoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppInfoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppInfoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppInfoDto value)  $default,){
final _that = this;
switch (_that) {
case _AppInfoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppInfoDto value)?  $default,){
final _that = this;
switch (_that) {
case _AppInfoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String packageName,  String versionName,  int versionCode,  bool isSystemApp, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppInfoDto() when $default != null:
return $default(_that.name,_that.packageName,_that.versionName,_that.versionCode,_that.isSystemApp,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String packageName,  String versionName,  int versionCode,  bool isSystemApp, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? icon)  $default,) {final _that = this;
switch (_that) {
case _AppInfoDto():
return $default(_that.name,_that.packageName,_that.versionName,_that.versionCode,_that.isSystemApp,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String packageName,  String versionName,  int versionCode,  bool isSystemApp, @JsonKey(includeFromJson: false, includeToJson: false)  Uint8List? icon)?  $default,) {final _that = this;
switch (_that) {
case _AppInfoDto() when $default != null:
return $default(_that.name,_that.packageName,_that.versionName,_that.versionCode,_that.isSystemApp,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppInfoDto extends AppInfoDto {
  const _AppInfoDto({this.name = "", this.packageName = "", this.versionName = "", this.versionCode = 0, this.isSystemApp = false, @JsonKey(includeFromJson: false, includeToJson: false) this.icon}): super._();
  factory _AppInfoDto.fromJson(Map<String, dynamic> json) => _$AppInfoDtoFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String packageName;
@override@JsonKey() final  String versionName;
@override@JsonKey() final  int versionCode;
@override@JsonKey() final  bool isSystemApp;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  Uint8List? icon;

/// Create a copy of AppInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppInfoDtoCopyWith<_AppInfoDto> get copyWith => __$AppInfoDtoCopyWithImpl<_AppInfoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppInfoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppInfoDto&&(identical(other.name, name) || other.name == name)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.versionName, versionName) || other.versionName == versionName)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.isSystemApp, isSystemApp) || other.isSystemApp == isSystemApp)&&const DeepCollectionEquality().equals(other.icon, icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,packageName,versionName,versionCode,isSystemApp,const DeepCollectionEquality().hash(icon));

@override
String toString() {
  return 'AppInfoDto(name: $name, packageName: $packageName, versionName: $versionName, versionCode: $versionCode, isSystemApp: $isSystemApp, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$AppInfoDtoCopyWith<$Res> implements $AppInfoDtoCopyWith<$Res> {
  factory _$AppInfoDtoCopyWith(_AppInfoDto value, $Res Function(_AppInfoDto) _then) = __$AppInfoDtoCopyWithImpl;
@override @useResult
$Res call({
 String name, String packageName, String versionName, int versionCode, bool isSystemApp,@JsonKey(includeFromJson: false, includeToJson: false) Uint8List? icon
});




}
/// @nodoc
class __$AppInfoDtoCopyWithImpl<$Res>
    implements _$AppInfoDtoCopyWith<$Res> {
  __$AppInfoDtoCopyWithImpl(this._self, this._then);

  final _AppInfoDto _self;
  final $Res Function(_AppInfoDto) _then;

/// Create a copy of AppInfoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? packageName = null,Object? versionName = null,Object? versionCode = null,Object? isSystemApp = null,Object? icon = freezed,}) {
  return _then(_AppInfoDto(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,versionName: null == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String,versionCode: null == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as int,isSystemApp: null == isSystemApp ? _self.isSystemApp : isSystemApp // ignore: cast_nullable_to_non_nullable
as bool,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}


}

// dart format on
