import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_dto.freezed.dart';
part 'audit_log_dto.g.dart';

@freezed
abstract class AuditLogDto with _$AuditLogDto {
  const factory AuditLogDto({
    @Default('') String algorithm,
    @Default(1) int operation,
    @Default('') String key,
    @Default('') String keyBase64,
    @Default('') String keyPlaintext,
    @Default('') String iv,
    @Default('') String ivBase64,
    @Default('') String ivPlaintext,
    @Default('') String input,
    @Default('') String inputBase64,
    @Default('') String output,
    @Default('') String outputBase64,
    @Default('') String inputHex,
    @Default('') String outputHex,
    @Default([]) List<String> stackTrace,
    @Default('') String fingerprint, // Added fingerprint field
    @Default(0) int timestamp,
  }) = _AuditLogDto;

  factory AuditLogDto.fromJson(Map<String, dynamic> json) =>
      _$AuditLogDtoFromJson(json);
}
