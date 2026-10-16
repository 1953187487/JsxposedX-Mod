import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

part 'ai_provider_connection_dto.freezed.dart';
part 'ai_provider_connection_dto.g.dart';

@freezed
abstract class AiProviderConnectionDto with _$AiProviderConnectionDto {
  const AiProviderConnectionDto._();

  const factory AiProviderConnectionDto({
    required String id,
    required String providerId,
    required String displayName,
    required String baseUri,
    String? credentialRef,
    @Default(<String, String>{}) Map<String, String> endpointOverrides,
    @Default(<String, String>{}) Map<String, String> customHeaders,
    @Default(<String, Object?>{}) Map<String, Object?> adapterOptions,
    @Default(true) bool enabled,
  }) = _AiProviderConnectionDto;

  factory AiProviderConnectionDto.fromJson(Map<String, Object?> json) =>
      _$AiProviderConnectionDtoFromJson(json);

  factory AiProviderConnectionDto.fromEntity(AiProviderConnection entity) =>
      AiProviderConnectionDto(
        id: entity.id,
        providerId: entity.providerId,
        displayName: entity.displayName,
        baseUri: entity.baseUri.toString(),
        credentialRef: entity.credentialRef,
        endpointOverrides: entity.endpointOverrides.map(
          (key, value) => MapEntry(key.name, value.toString()),
        ),
        customHeaders: entity.customHeaders,
        adapterOptions: entity.adapterOptions,
        enabled: entity.enabled,
      );

  AiProviderConnection toEntity() {
    final parsedBaseUri = _parseHttpUri(baseUri, 'base URI');
    final parsedOverrides = <AiEndpointKind, Uri>{};
    for (final entry in endpointOverrides.entries) {
      final kind = _endpointKind(entry.key);
      if (kind == null) {
        throw FormatException('Unknown AI endpoint kind: ${entry.key}');
      }
      parsedOverrides[kind] = _parseHttpUri(
        entry.value,
        '${entry.key} endpoint override',
      );
    }
    return AiProviderConnection(
      id: id,
      providerId: providerId,
      displayName: displayName,
      baseUri: parsedBaseUri,
      credentialRef: credentialRef,
      endpointOverrides: parsedOverrides,
      customHeaders: customHeaders,
      adapterOptions: adapterOptions,
      enabled: enabled,
    );
  }

  static AiEndpointKind? _endpointKind(String value) {
    for (final kind in AiEndpointKind.values) {
      if (kind.name == value) return kind;
    }
    return null;
  }

  static Uri _parseHttpUri(String value, String fieldName) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        !uri.hasScheme ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw FormatException('Invalid AI provider $fieldName');
    }
    return uri;
  }
}
