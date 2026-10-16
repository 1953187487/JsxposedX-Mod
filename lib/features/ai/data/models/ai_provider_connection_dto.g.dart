// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider_connection_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiProviderConnectionDto _$AiProviderConnectionDtoFromJson(
  Map<String, dynamic> json,
) => _AiProviderConnectionDto(
  id: json['id'] as String,
  providerId: json['providerId'] as String,
  displayName: json['displayName'] as String,
  baseUri: json['baseUri'] as String,
  credentialRef: json['credentialRef'] as String?,
  endpointOverrides:
      (json['endpointOverrides'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  customHeaders:
      (json['customHeaders'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  adapterOptions:
      json['adapterOptions'] as Map<String, dynamic>? ??
      const <String, Object?>{},
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$AiProviderConnectionDtoToJson(
  _AiProviderConnectionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'providerId': instance.providerId,
  'displayName': instance.displayName,
  'baseUri': instance.baseUri,
  'credentialRef': instance.credentialRef,
  'endpointOverrides': instance.endpointOverrides,
  'customHeaders': instance.customHeaders,
  'adapterOptions': instance.adapterOptions,
  'enabled': instance.enabled,
};
