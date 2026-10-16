import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

const _sensitiveHeaderNames = {
  'authorization',
  'proxy-authorization',
  'cookie',
  'set-cookie',
  'x-api-key',
  'api-key',
};

void validateAiProviderConnection(AiProviderConnection connection) {
  _validateHttpUri(connection.baseUri, 'base URI');
  for (final entry in connection.endpointOverrides.entries) {
    _validateHttpUri(entry.value, '${entry.key.name} endpoint');
  }
  for (final entry in connection.customHeaders.entries) {
    final normalizedName = entry.key.trim().toLowerCase();
    if (normalizedName.isEmpty ||
        _sensitiveHeaderNames.contains(normalizedName)) {
      throw ArgumentError('Sensitive headers must use the credential store');
    }
    if (entry.key.contains('\r') ||
        entry.key.contains('\n') ||
        entry.value.contains('\r') ||
        entry.value.contains('\n')) {
      throw ArgumentError('AI provider headers cannot contain newlines');
    }
  }
  if (_containsSensitiveOption(connection.adapterOptions)) {
    throw ArgumentError(
      'Sensitive adapter options must use the credential store',
    );
  }
}

bool isSensitiveAiHeaderName(String name) =>
    _sensitiveHeaderNames.contains(name.trim().toLowerCase());

void _validateHttpUri(Uri uri, String fieldName) {
  if (!uri.hasScheme ||
      uri.host.isEmpty ||
      (uri.scheme != 'http' && uri.scheme != 'https')) {
    throw ArgumentError('Invalid AI provider $fieldName');
  }
}

bool _containsSensitiveOption(Object? value) {
  if (value is Map) {
    for (final entry in value.entries) {
      final key = entry.key.toString().toLowerCase();
      if (key.contains('secret') ||
          key.contains('password') ||
          key.contains('api_key') ||
          key.contains('apikey') ||
          key.contains('access_token') ||
          key.contains('refresh_token')) {
        return true;
      }
      if (_containsSensitiveOption(entry.value)) return true;
    }
  } else if (value is Iterable) {
    return value.any(_containsSensitiveOption);
  }
  return false;
}
