import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config.freezed.dart';
part 'server_config.g.dart';

enum ServerProtocol {
  @JsonValue('http')
  http,
  @JsonValue('websocket')
  websocket,
  @JsonValue('tcp')
  tcp,
}

enum ServerRunState {
  @JsonValue('stopped')
  stopped,
  @JsonValue('running')
  running,
  @JsonValue('error')
  error,
}

@freezed
abstract class FakeServerConfig with _$FakeServerConfig {
  const factory FakeServerConfig({
    required String id,
    required String name,
    required ServerProtocol protocol,
    required int port,
    @Default('') String targetHost,
    @Default('') String targetPort,
    @Default('') String description,
    @Default(<RouteRule>[]) List<RouteRule> routes,
    @Default(false) bool enablePortForwarding,
    @Default('') String portForwardingService,
    @Default('') String portForwardingToken,
    @Default('') String portForwardingUrl,
    @Default(0) int createdAt,
    @Default(0) int updatedAt,
  }) = _FakeServerConfig;

  factory FakeServerConfig.fromJson(Map<String, dynamic> json) =>
      _$FakeServerConfigFromJson(json);
}

@freezed
abstract class RouteRule with _$RouteRule {
  const factory RouteRule({
    required String path,
    @Default('GET') String method,
    @Default('200') String responseStatus,
    @Default('application/json') String responseType,
    @Default('') String responseBody,
    @Default(0) int responseDelay,
  }) = _RouteRule;

  factory RouteRule.fromJson(Map<String, dynamic> json) =>
      _$RouteRuleFromJson(json);
}
