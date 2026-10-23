// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FakeServerConfig {

 String get id; String get name; ServerProtocol get protocol; int get port; String get targetHost; String get targetPort; String get description; List<RouteRule> get routes; bool get enablePortForwarding; String get portForwardingService; String get portForwardingToken; String get portForwardingUrl; int get createdAt; int get updatedAt;
/// Create a copy of FakeServerConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FakeServerConfigCopyWith<FakeServerConfig> get copyWith => _$FakeServerConfigCopyWithImpl<FakeServerConfig>(this as FakeServerConfig, _$identity);

  /// Serializes this FakeServerConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FakeServerConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.port, port) || other.port == port)&&(identical(other.targetHost, targetHost) || other.targetHost == targetHost)&&(identical(other.targetPort, targetPort) || other.targetPort == targetPort)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.routes, routes)&&(identical(other.enablePortForwarding, enablePortForwarding) || other.enablePortForwarding == enablePortForwarding)&&(identical(other.portForwardingService, portForwardingService) || other.portForwardingService == portForwardingService)&&(identical(other.portForwardingToken, portForwardingToken) || other.portForwardingToken == portForwardingToken)&&(identical(other.portForwardingUrl, portForwardingUrl) || other.portForwardingUrl == portForwardingUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,protocol,port,targetHost,targetPort,description,const DeepCollectionEquality().hash(routes),enablePortForwarding,portForwardingService,portForwardingToken,portForwardingUrl,createdAt,updatedAt);

@override
String toString() {
  return 'FakeServerConfig(id: $id, name: $name, protocol: $protocol, port: $port, targetHost: $targetHost, targetPort: $targetPort, description: $description, routes: $routes, enablePortForwarding: $enablePortForwarding, portForwardingService: $portForwardingService, portForwardingToken: $portForwardingToken, portForwardingUrl: $portForwardingUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FakeServerConfigCopyWith<$Res>  {
  factory $FakeServerConfigCopyWith(FakeServerConfig value, $Res Function(FakeServerConfig) _then) = _$FakeServerConfigCopyWithImpl;
@useResult
$Res call({
 String id, String name, ServerProtocol protocol, int port, String targetHost, String targetPort, String description, List<RouteRule> routes, bool enablePortForwarding, String portForwardingService, String portForwardingToken, String portForwardingUrl, int createdAt, int updatedAt
});




}
/// @nodoc
class _$FakeServerConfigCopyWithImpl<$Res>
    implements $FakeServerConfigCopyWith<$Res> {
  _$FakeServerConfigCopyWithImpl(this._self, this._then);

  final FakeServerConfig _self;
  final $Res Function(FakeServerConfig) _then;

/// Create a copy of FakeServerConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? protocol = null,Object? port = null,Object? targetHost = null,Object? targetPort = null,Object? description = null,Object? routes = null,Object? enablePortForwarding = null,Object? portForwardingService = null,Object? portForwardingToken = null,Object? portForwardingUrl = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as ServerProtocol,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,targetHost: null == targetHost ? _self.targetHost : targetHost // ignore: cast_nullable_to_non_nullable
as String,targetPort: null == targetPort ? _self.targetPort : targetPort // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteRule>,enablePortForwarding: null == enablePortForwarding ? _self.enablePortForwarding : enablePortForwarding // ignore: cast_nullable_to_non_nullable
as bool,portForwardingService: null == portForwardingService ? _self.portForwardingService : portForwardingService // ignore: cast_nullable_to_non_nullable
as String,portForwardingToken: null == portForwardingToken ? _self.portForwardingToken : portForwardingToken // ignore: cast_nullable_to_non_nullable
as String,portForwardingUrl: null == portForwardingUrl ? _self.portForwardingUrl : portForwardingUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FakeServerConfig].
extension FakeServerConfigPatterns on FakeServerConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FakeServerConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FakeServerConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FakeServerConfig value)  $default,){
final _that = this;
switch (_that) {
case _FakeServerConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FakeServerConfig value)?  $default,){
final _that = this;
switch (_that) {
case _FakeServerConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  ServerProtocol protocol,  int port,  String targetHost,  String targetPort,  String description,  List<RouteRule> routes,  bool enablePortForwarding,  String portForwardingService,  String portForwardingToken,  String portForwardingUrl,  int createdAt,  int updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FakeServerConfig() when $default != null:
return $default(_that.id,_that.name,_that.protocol,_that.port,_that.targetHost,_that.targetPort,_that.description,_that.routes,_that.enablePortForwarding,_that.portForwardingService,_that.portForwardingToken,_that.portForwardingUrl,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  ServerProtocol protocol,  int port,  String targetHost,  String targetPort,  String description,  List<RouteRule> routes,  bool enablePortForwarding,  String portForwardingService,  String portForwardingToken,  String portForwardingUrl,  int createdAt,  int updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FakeServerConfig():
return $default(_that.id,_that.name,_that.protocol,_that.port,_that.targetHost,_that.targetPort,_that.description,_that.routes,_that.enablePortForwarding,_that.portForwardingService,_that.portForwardingToken,_that.portForwardingUrl,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  ServerProtocol protocol,  int port,  String targetHost,  String targetPort,  String description,  List<RouteRule> routes,  bool enablePortForwarding,  String portForwardingService,  String portForwardingToken,  String portForwardingUrl,  int createdAt,  int updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FakeServerConfig() when $default != null:
return $default(_that.id,_that.name,_that.protocol,_that.port,_that.targetHost,_that.targetPort,_that.description,_that.routes,_that.enablePortForwarding,_that.portForwardingService,_that.portForwardingToken,_that.portForwardingUrl,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FakeServerConfig implements FakeServerConfig {
  const _FakeServerConfig({required this.id, required this.name, required this.protocol, required this.port, this.targetHost = '', this.targetPort = '', this.description = '', final  List<RouteRule> routes = const <RouteRule>[], this.enablePortForwarding = false, this.portForwardingService = '', this.portForwardingToken = '', this.portForwardingUrl = '', this.createdAt = 0, this.updatedAt = 0}): _routes = routes;
  factory _FakeServerConfig.fromJson(Map<String, dynamic> json) => _$FakeServerConfigFromJson(json);

@override final  String id;
@override final  String name;
@override final  ServerProtocol protocol;
@override final  int port;
@override@JsonKey() final  String targetHost;
@override@JsonKey() final  String targetPort;
@override@JsonKey() final  String description;
 final  List<RouteRule> _routes;
@override@JsonKey() List<RouteRule> get routes {
  if (_routes is EqualUnmodifiableListView) return _routes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routes);
}

@override@JsonKey() final  bool enablePortForwarding;
@override@JsonKey() final  String portForwardingService;
@override@JsonKey() final  String portForwardingToken;
@override@JsonKey() final  String portForwardingUrl;
@override@JsonKey() final  int createdAt;
@override@JsonKey() final  int updatedAt;

/// Create a copy of FakeServerConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FakeServerConfigCopyWith<_FakeServerConfig> get copyWith => __$FakeServerConfigCopyWithImpl<_FakeServerConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FakeServerConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FakeServerConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.port, port) || other.port == port)&&(identical(other.targetHost, targetHost) || other.targetHost == targetHost)&&(identical(other.targetPort, targetPort) || other.targetPort == targetPort)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._routes, _routes)&&(identical(other.enablePortForwarding, enablePortForwarding) || other.enablePortForwarding == enablePortForwarding)&&(identical(other.portForwardingService, portForwardingService) || other.portForwardingService == portForwardingService)&&(identical(other.portForwardingToken, portForwardingToken) || other.portForwardingToken == portForwardingToken)&&(identical(other.portForwardingUrl, portForwardingUrl) || other.portForwardingUrl == portForwardingUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,protocol,port,targetHost,targetPort,description,const DeepCollectionEquality().hash(_routes),enablePortForwarding,portForwardingService,portForwardingToken,portForwardingUrl,createdAt,updatedAt);

@override
String toString() {
  return 'FakeServerConfig(id: $id, name: $name, protocol: $protocol, port: $port, targetHost: $targetHost, targetPort: $targetPort, description: $description, routes: $routes, enablePortForwarding: $enablePortForwarding, portForwardingService: $portForwardingService, portForwardingToken: $portForwardingToken, portForwardingUrl: $portForwardingUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FakeServerConfigCopyWith<$Res> implements $FakeServerConfigCopyWith<$Res> {
  factory _$FakeServerConfigCopyWith(_FakeServerConfig value, $Res Function(_FakeServerConfig) _then) = __$FakeServerConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, ServerProtocol protocol, int port, String targetHost, String targetPort, String description, List<RouteRule> routes, bool enablePortForwarding, String portForwardingService, String portForwardingToken, String portForwardingUrl, int createdAt, int updatedAt
});




}
/// @nodoc
class __$FakeServerConfigCopyWithImpl<$Res>
    implements _$FakeServerConfigCopyWith<$Res> {
  __$FakeServerConfigCopyWithImpl(this._self, this._then);

  final _FakeServerConfig _self;
  final $Res Function(_FakeServerConfig) _then;

/// Create a copy of FakeServerConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? protocol = null,Object? port = null,Object? targetHost = null,Object? targetPort = null,Object? description = null,Object? routes = null,Object? enablePortForwarding = null,Object? portForwardingService = null,Object? portForwardingToken = null,Object? portForwardingUrl = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FakeServerConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as ServerProtocol,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,targetHost: null == targetHost ? _self.targetHost : targetHost // ignore: cast_nullable_to_non_nullable
as String,targetPort: null == targetPort ? _self.targetPort : targetPort // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,routes: null == routes ? _self._routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteRule>,enablePortForwarding: null == enablePortForwarding ? _self.enablePortForwarding : enablePortForwarding // ignore: cast_nullable_to_non_nullable
as bool,portForwardingService: null == portForwardingService ? _self.portForwardingService : portForwardingService // ignore: cast_nullable_to_non_nullable
as String,portForwardingToken: null == portForwardingToken ? _self.portForwardingToken : portForwardingToken // ignore: cast_nullable_to_non_nullable
as String,portForwardingUrl: null == portForwardingUrl ? _self.portForwardingUrl : portForwardingUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RouteRule {

 String get path; String get method; String get responseStatus; String get responseType; String get responseBody; int get responseDelay;
/// Create a copy of RouteRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteRuleCopyWith<RouteRule> get copyWith => _$RouteRuleCopyWithImpl<RouteRule>(this as RouteRule, _$identity);

  /// Serializes this RouteRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteRule&&(identical(other.path, path) || other.path == path)&&(identical(other.method, method) || other.method == method)&&(identical(other.responseStatus, responseStatus) || other.responseStatus == responseStatus)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.responseBody, responseBody) || other.responseBody == responseBody)&&(identical(other.responseDelay, responseDelay) || other.responseDelay == responseDelay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,method,responseStatus,responseType,responseBody,responseDelay);

@override
String toString() {
  return 'RouteRule(path: $path, method: $method, responseStatus: $responseStatus, responseType: $responseType, responseBody: $responseBody, responseDelay: $responseDelay)';
}


}

/// @nodoc
abstract mixin class $RouteRuleCopyWith<$Res>  {
  factory $RouteRuleCopyWith(RouteRule value, $Res Function(RouteRule) _then) = _$RouteRuleCopyWithImpl;
@useResult
$Res call({
 String path, String method, String responseStatus, String responseType, String responseBody, int responseDelay
});




}
/// @nodoc
class _$RouteRuleCopyWithImpl<$Res>
    implements $RouteRuleCopyWith<$Res> {
  _$RouteRuleCopyWithImpl(this._self, this._then);

  final RouteRule _self;
  final $Res Function(RouteRule) _then;

/// Create a copy of RouteRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? method = null,Object? responseStatus = null,Object? responseType = null,Object? responseBody = null,Object? responseDelay = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,responseStatus: null == responseStatus ? _self.responseStatus : responseStatus // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,responseBody: null == responseBody ? _self.responseBody : responseBody // ignore: cast_nullable_to_non_nullable
as String,responseDelay: null == responseDelay ? _self.responseDelay : responseDelay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteRule].
extension RouteRulePatterns on RouteRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteRule value)  $default,){
final _that = this;
switch (_that) {
case _RouteRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteRule value)?  $default,){
final _that = this;
switch (_that) {
case _RouteRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String method,  String responseStatus,  String responseType,  String responseBody,  int responseDelay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteRule() when $default != null:
return $default(_that.path,_that.method,_that.responseStatus,_that.responseType,_that.responseBody,_that.responseDelay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String method,  String responseStatus,  String responseType,  String responseBody,  int responseDelay)  $default,) {final _that = this;
switch (_that) {
case _RouteRule():
return $default(_that.path,_that.method,_that.responseStatus,_that.responseType,_that.responseBody,_that.responseDelay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String method,  String responseStatus,  String responseType,  String responseBody,  int responseDelay)?  $default,) {final _that = this;
switch (_that) {
case _RouteRule() when $default != null:
return $default(_that.path,_that.method,_that.responseStatus,_that.responseType,_that.responseBody,_that.responseDelay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteRule implements RouteRule {
  const _RouteRule({required this.path, this.method = 'GET', this.responseStatus = '200', this.responseType = 'application/json', this.responseBody = '', this.responseDelay = 0});
  factory _RouteRule.fromJson(Map<String, dynamic> json) => _$RouteRuleFromJson(json);

@override final  String path;
@override@JsonKey() final  String method;
@override@JsonKey() final  String responseStatus;
@override@JsonKey() final  String responseType;
@override@JsonKey() final  String responseBody;
@override@JsonKey() final  int responseDelay;

/// Create a copy of RouteRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteRuleCopyWith<_RouteRule> get copyWith => __$RouteRuleCopyWithImpl<_RouteRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteRule&&(identical(other.path, path) || other.path == path)&&(identical(other.method, method) || other.method == method)&&(identical(other.responseStatus, responseStatus) || other.responseStatus == responseStatus)&&(identical(other.responseType, responseType) || other.responseType == responseType)&&(identical(other.responseBody, responseBody) || other.responseBody == responseBody)&&(identical(other.responseDelay, responseDelay) || other.responseDelay == responseDelay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,method,responseStatus,responseType,responseBody,responseDelay);

@override
String toString() {
  return 'RouteRule(path: $path, method: $method, responseStatus: $responseStatus, responseType: $responseType, responseBody: $responseBody, responseDelay: $responseDelay)';
}


}

/// @nodoc
abstract mixin class _$RouteRuleCopyWith<$Res> implements $RouteRuleCopyWith<$Res> {
  factory _$RouteRuleCopyWith(_RouteRule value, $Res Function(_RouteRule) _then) = __$RouteRuleCopyWithImpl;
@override @useResult
$Res call({
 String path, String method, String responseStatus, String responseType, String responseBody, int responseDelay
});




}
/// @nodoc
class __$RouteRuleCopyWithImpl<$Res>
    implements _$RouteRuleCopyWith<$Res> {
  __$RouteRuleCopyWithImpl(this._self, this._then);

  final _RouteRule _self;
  final $Res Function(_RouteRule) _then;

/// Create a copy of RouteRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? method = null,Object? responseStatus = null,Object? responseType = null,Object? responseBody = null,Object? responseDelay = null,}) {
  return _then(_RouteRule(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,responseStatus: null == responseStatus ? _self.responseStatus : responseStatus // ignore: cast_nullable_to_non_nullable
as String,responseType: null == responseType ? _self.responseType : responseType // ignore: cast_nullable_to_non_nullable
as String,responseBody: null == responseBody ? _self.responseBody : responseBody // ignore: cast_nullable_to_non_nullable
as String,responseDelay: null == responseDelay ? _self.responseDelay : responseDelay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
