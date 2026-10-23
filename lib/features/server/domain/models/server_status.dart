import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_status.freezed.dart';

@freezed
abstract class FakeServerStatus with _$FakeServerStatus {
  const factory FakeServerStatus({
    required String serverId,
    required int status,
    @Default('') String address,
    @Default(0) int port,
    @Default('') String error,
    @Default(0) int connections,
    @Default(0) int requests,
    @Default(0) int uptime,
  }) = _FakeServerStatus;
}

@freezed
abstract class ServerRequestLog with _$ServerRequestLog {
  const factory ServerRequestLog({
    required int id,
    required String serverId,
    required int timestamp,
    required String method,
    required String path,
    required String client,
    @Default(200) int status,
    @Default(0) int duration,
    @Default('') String requestBody,
    @Default('') String responseBody,
  }) = _ServerRequestLog;
}
