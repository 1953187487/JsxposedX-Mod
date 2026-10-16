// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLogDto _$AuditLogDtoFromJson(Map<String, dynamic> json) => _AuditLogDto(
  algorithm: json['algorithm'] as String? ?? '',
  operation: (json['operation'] as num?)?.toInt() ?? 1,
  key: json['key'] as String? ?? '',
  keyBase64: json['keyBase64'] as String? ?? '',
  keyPlaintext: json['keyPlaintext'] as String? ?? '',
  iv: json['iv'] as String? ?? '',
  ivBase64: json['ivBase64'] as String? ?? '',
  ivPlaintext: json['ivPlaintext'] as String? ?? '',
  input: json['input'] as String? ?? '',
  inputBase64: json['inputBase64'] as String? ?? '',
  output: json['output'] as String? ?? '',
  outputBase64: json['outputBase64'] as String? ?? '',
  inputHex: json['inputHex'] as String? ?? '',
  outputHex: json['outputHex'] as String? ?? '',
  stackTrace:
      (json['stackTrace'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  fingerprint: json['fingerprint'] as String? ?? '',
  timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AuditLogDtoToJson(_AuditLogDto instance) =>
    <String, dynamic>{
      'algorithm': instance.algorithm,
      'operation': instance.operation,
      'key': instance.key,
      'keyBase64': instance.keyBase64,
      'keyPlaintext': instance.keyPlaintext,
      'iv': instance.iv,
      'ivBase64': instance.ivBase64,
      'ivPlaintext': instance.ivPlaintext,
      'input': instance.input,
      'inputBase64': instance.inputBase64,
      'output': instance.output,
      'outputBase64': instance.outputBase64,
      'inputHex': instance.inputHex,
      'outputHex': instance.outputHex,
      'stackTrace': instance.stackTrace,
      'fingerprint': instance.fingerprint,
      'timestamp': instance.timestamp,
    };
