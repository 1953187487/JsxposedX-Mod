// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FakeServerStatus {

 String get serverId; int get status; String get address; int get port; String get error; int get connections; int get requests; int get uptime;
/// Create a copy of FakeServerStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FakeServerStatusCopyWith<FakeServerStatus> get copyWith => _$FakeServerStatusCopyWithImpl<FakeServerStatus>(this as FakeServerStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FakeServerStatus&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.status, status) || other.status == status)&&(identical(other.address, address) || other.address == address)&&(identical(other.port, port) || other.port == port)&&(identical(other.error, error) || other.error == error)&&(identical(other.connections, connections) || other.connections == connections)&&(identical(other.requests, requests) || other.requests == requests)&&(identical(other.uptime, uptime) || other.uptime == uptime));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,status,address,port,error,connections,requests,uptime);

@override
String toString() {
  return 'FakeServerStatus(serverId: $serverId, status: $status, address: $address, port: $port, error: $error, connections: $connections, requests: $requests, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class $FakeServerStatusCopyWith<$Res>  {
  factory $FakeServerStatusCopyWith(FakeServerStatus value, $Res Function(FakeServerStatus) _then) = _$FakeServerStatusCopyWithImpl;
@useResult
$Res call({
 String serverId, int status, String address, int port, String error, int connections, int requests, int uptime
});




}
/// @nodoc
class _$FakeServerStatusCopyWithImpl<$Res>
    implements $FakeServerStatusCopyWith<$Res> {
  _$FakeServerStatusCopyWithImpl(this._self, this._then);

  final FakeServerStatus _self;
  final $Res Function(FakeServerStatus) _then;

/// Create a copy of FakeServerStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverId = null,Object? status = null,Object? address = null,Object? port = null,Object? error = null,Object? connections = null,Object? requests = null,Object? uptime = null,}) {
  return _then(_self.copyWith(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as int,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as int,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FakeServerStatus].
extension FakeServerStatusPatterns on FakeServerStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FakeServerStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FakeServerStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FakeServerStatus value)  $default,){
final _that = this;
switch (_that) {
case _FakeServerStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FakeServerStatus value)?  $default,){
final _that = this;
switch (_that) {
case _FakeServerStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serverId,  int status,  String address,  int port,  String error,  int connections,  int requests,  int uptime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FakeServerStatus() when $default != null:
return $default(_that.serverId,_that.status,_that.address,_that.port,_that.error,_that.connections,_that.requests,_that.uptime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serverId,  int status,  String address,  int port,  String error,  int connections,  int requests,  int uptime)  $default,) {final _that = this;
switch (_that) {
case _FakeServerStatus():
return $default(_that.serverId,_that.status,_that.address,_that.port,_that.error,_that.connections,_that.requests,_that.uptime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serverId,  int status,  String address,  int port,  String error,  int connections,  int requests,  int uptime)?  $default,) {final _that = this;
switch (_that) {
case _FakeServerStatus() when $default != null:
return $default(_that.serverId,_that.status,_that.address,_that.port,_that.error,_that.connections,_that.requests,_that.uptime);case _:
  return null;

}
}

}

/// @nodoc


class _FakeServerStatus implements FakeServerStatus {
  const _FakeServerStatus({required this.serverId, required this.status, this.address = '', this.port = 0, this.error = '', this.connections = 0, this.requests = 0, this.uptime = 0});
  

@override final  String serverId;
@override final  int status;
@override@JsonKey() final  String address;
@override@JsonKey() final  int port;
@override@JsonKey() final  String error;
@override@JsonKey() final  int connections;
@override@JsonKey() final  int requests;
@override@JsonKey() final  int uptime;

/// Create a copy of FakeServerStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FakeServerStatusCopyWith<_FakeServerStatus> get copyWith => __$FakeServerStatusCopyWithImpl<_FakeServerStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FakeServerStatus&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.status, status) || other.status == status)&&(identical(other.address, address) || other.address == address)&&(identical(other.port, port) || other.port == port)&&(identical(other.error, error) || other.error == error)&&(identical(other.connections, connections) || other.connections == connections)&&(identical(other.requests, requests) || other.requests == requests)&&(identical(other.uptime, uptime) || other.uptime == uptime));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,status,address,port,error,connections,requests,uptime);

@override
String toString() {
  return 'FakeServerStatus(serverId: $serverId, status: $status, address: $address, port: $port, error: $error, connections: $connections, requests: $requests, uptime: $uptime)';
}


}

/// @nodoc
abstract mixin class _$FakeServerStatusCopyWith<$Res> implements $FakeServerStatusCopyWith<$Res> {
  factory _$FakeServerStatusCopyWith(_FakeServerStatus value, $Res Function(_FakeServerStatus) _then) = __$FakeServerStatusCopyWithImpl;
@override @useResult
$Res call({
 String serverId, int status, String address, int port, String error, int connections, int requests, int uptime
});




}
/// @nodoc
class __$FakeServerStatusCopyWithImpl<$Res>
    implements _$FakeServerStatusCopyWith<$Res> {
  __$FakeServerStatusCopyWithImpl(this._self, this._then);

  final _FakeServerStatus _self;
  final $Res Function(_FakeServerStatus) _then;

/// Create a copy of FakeServerStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverId = null,Object? status = null,Object? address = null,Object? port = null,Object? error = null,Object? connections = null,Object? requests = null,Object? uptime = null,}) {
  return _then(_FakeServerStatus(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as int,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as int,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ServerRequestLog {

 int get id; String get serverId; int get timestamp; String get method; String get path; String get client; int get status; int get duration; String get requestBody; String get responseBody;
/// Create a copy of ServerRequestLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerRequestLogCopyWith<ServerRequestLog> get copyWith => _$ServerRequestLogCopyWithImpl<ServerRequestLog>(this as ServerRequestLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerRequestLog&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&(identical(other.client, client) || other.client == client)&&(identical(other.status, status) || other.status == status)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.requestBody, requestBody) || other.requestBody == requestBody)&&(identical(other.responseBody, responseBody) || other.responseBody == responseBody));
}


@override
int get hashCode => Object.hash(runtimeType,id,serverId,timestamp,method,path,client,status,duration,requestBody,responseBody);

@override
String toString() {
  return 'ServerRequestLog(id: $id, serverId: $serverId, timestamp: $timestamp, method: $method, path: $path, client: $client, status: $status, duration: $duration, requestBody: $requestBody, responseBody: $responseBody)';
}


}

/// @nodoc
abstract mixin class $ServerRequestLogCopyWith<$Res>  {
  factory $ServerRequestLogCopyWith(ServerRequestLog value, $Res Function(ServerRequestLog) _then) = _$ServerRequestLogCopyWithImpl;
@useResult
$Res call({
 int id, String serverId, int timestamp, String method, String path, String client, int status, int duration, String requestBody, String responseBody
});




}
/// @nodoc
class _$ServerRequestLogCopyWithImpl<$Res>
    implements $ServerRequestLogCopyWith<$Res> {
  _$ServerRequestLogCopyWithImpl(this._self, this._then);

  final ServerRequestLog _self;
  final $Res Function(ServerRequestLog) _then;

/// Create a copy of ServerRequestLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serverId = null,Object? timestamp = null,Object? method = null,Object? path = null,Object? client = null,Object? status = null,Object? duration = null,Object? requestBody = null,Object? responseBody = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,requestBody: null == requestBody ? _self.requestBody : requestBody // ignore: cast_nullable_to_non_nullable
as String,responseBody: null == responseBody ? _self.responseBody : responseBody // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerRequestLog].
extension ServerRequestLogPatterns on ServerRequestLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerRequestLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerRequestLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerRequestLog value)  $default,){
final _that = this;
switch (_that) {
case _ServerRequestLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerRequestLog value)?  $default,){
final _that = this;
switch (_that) {
case _ServerRequestLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String serverId,  int timestamp,  String method,  String path,  String client,  int status,  int duration,  String requestBody,  String responseBody)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerRequestLog() when $default != null:
return $default(_that.id,_that.serverId,_that.timestamp,_that.method,_that.path,_that.client,_that.status,_that.duration,_that.requestBody,_that.responseBody);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String serverId,  int timestamp,  String method,  String path,  String client,  int status,  int duration,  String requestBody,  String responseBody)  $default,) {final _that = this;
switch (_that) {
case _ServerRequestLog():
return $default(_that.id,_that.serverId,_that.timestamp,_that.method,_that.path,_that.client,_that.status,_that.duration,_that.requestBody,_that.responseBody);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String serverId,  int timestamp,  String method,  String path,  String client,  int status,  int duration,  String requestBody,  String responseBody)?  $default,) {final _that = this;
switch (_that) {
case _ServerRequestLog() when $default != null:
return $default(_that.id,_that.serverId,_that.timestamp,_that.method,_that.path,_that.client,_that.status,_that.duration,_that.requestBody,_that.responseBody);case _:
  return null;

}
}

}

/// @nodoc


class _ServerRequestLog implements ServerRequestLog {
  const _ServerRequestLog({required this.id, required this.serverId, required this.timestamp, required this.method, required this.path, required this.client, this.status = 200, this.duration = 0, this.requestBody = '', this.responseBody = ''});
  

@override final  int id;
@override final  String serverId;
@override final  int timestamp;
@override final  String method;
@override final  String path;
@override final  String client;
@override@JsonKey() final  int status;
@override@JsonKey() final  int duration;
@override@JsonKey() final  String requestBody;
@override@JsonKey() final  String responseBody;

/// Create a copy of ServerRequestLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerRequestLogCopyWith<_ServerRequestLog> get copyWith => __$ServerRequestLogCopyWithImpl<_ServerRequestLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerRequestLog&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.method, method) || other.method == method)&&(identical(other.path, path) || other.path == path)&&(identical(other.client, client) || other.client == client)&&(identical(other.status, status) || other.status == status)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.requestBody, requestBody) || other.requestBody == requestBody)&&(identical(other.responseBody, responseBody) || other.responseBody == responseBody));
}


@override
int get hashCode => Object.hash(runtimeType,id,serverId,timestamp,method,path,client,status,duration,requestBody,responseBody);

@override
String toString() {
  return 'ServerRequestLog(id: $id, serverId: $serverId, timestamp: $timestamp, method: $method, path: $path, client: $client, status: $status, duration: $duration, requestBody: $requestBody, responseBody: $responseBody)';
}


}

/// @nodoc
abstract mixin class _$ServerRequestLogCopyWith<$Res> implements $ServerRequestLogCopyWith<$Res> {
  factory _$ServerRequestLogCopyWith(_ServerRequestLog value, $Res Function(_ServerRequestLog) _then) = __$ServerRequestLogCopyWithImpl;
@override @useResult
$Res call({
 int id, String serverId, int timestamp, String method, String path, String client, int status, int duration, String requestBody, String responseBody
});




}
/// @nodoc
class __$ServerRequestLogCopyWithImpl<$Res>
    implements _$ServerRequestLogCopyWith<$Res> {
  __$ServerRequestLogCopyWithImpl(this._self, this._then);

  final _ServerRequestLog _self;
  final $Res Function(_ServerRequestLog) _then;

/// Create a copy of ServerRequestLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serverId = null,Object? timestamp = null,Object? method = null,Object? path = null,Object? client = null,Object? status = null,Object? duration = null,Object? requestBody = null,Object? responseBody = null,}) {
  return _then(_ServerRequestLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,client: null == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,requestBody: null == requestBody ? _self.requestBody : requestBody // ignore: cast_nullable_to_non_nullable
as String,responseBody: null == responseBody ? _self.responseBody : responseBody // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
