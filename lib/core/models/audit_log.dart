import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log.freezed.dart';

@freezed
abstract class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String algorithm,
    required int operation,
    required String key,
    required String keyBase64,
    required String keyPlaintext,
    required String? iv,
    required String? ivBase64,
    required String? ivPlaintext,
    required String input,
    required String inputBase64,
    required String output,
    required String outputBase64,
    required String inputHex,
    required String outputHex,
    required List<String> stackTrace,
    required String fingerprint,
    required int timestamp,
  }) = _AuditLog;
}
