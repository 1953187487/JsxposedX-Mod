// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FakeServerConfig _$FakeServerConfigFromJson(Map<String, dynamic> json) =>
    _FakeServerConfig(
      id: json['id'] as String,
      name: json['name'] as String,
      protocol: $enumDecode(_$ServerProtocolEnumMap, json['protocol']),
      port: (json['port'] as num).toInt(),
      targetHost: json['targetHost'] as String? ?? '',
      targetPort: json['targetPort'] as String? ?? '',
      description: json['description'] as String? ?? '',
      routes:
          (json['routes'] as List<dynamic>?)
              ?.map((e) => RouteRule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RouteRule>[],
      enablePortForwarding: json['enablePortForwarding'] as bool? ?? false,
      portForwardingService: json['portForwardingService'] as String? ?? '',
      portForwardingToken: json['portForwardingToken'] as String? ?? '',
      portForwardingUrl: json['portForwardingUrl'] as String? ?? '',
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FakeServerConfigToJson(_FakeServerConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'protocol': _$ServerProtocolEnumMap[instance.protocol]!,
      'port': instance.port,
      'targetHost': instance.targetHost,
      'targetPort': instance.targetPort,
      'description': instance.description,
      'routes': instance.routes,
      'enablePortForwarding': instance.enablePortForwarding,
      'portForwardingService': instance.portForwardingService,
      'portForwardingToken': instance.portForwardingToken,
      'portForwardingUrl': instance.portForwardingUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$ServerProtocolEnumMap = {
  ServerProtocol.http: 'http',
  ServerProtocol.websocket: 'websocket',
  ServerProtocol.tcp: 'tcp',
};

_RouteRule _$RouteRuleFromJson(Map<String, dynamic> json) => _RouteRule(
  path: json['path'] as String,
  method: json['method'] as String? ?? 'GET',
  responseStatus: json['responseStatus'] as String? ?? '200',
  responseType: json['responseType'] as String? ?? 'application/json',
  responseBody: json['responseBody'] as String? ?? '',
  responseDelay: (json['responseDelay'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RouteRuleToJson(_RouteRule instance) =>
    <String, dynamic>{
      'path': instance.path,
      'method': instance.method,
      'responseStatus': instance.responseStatus,
      'responseType': instance.responseType,
      'responseBody': instance.responseBody,
      'responseDelay': instance.responseDelay,
    };
