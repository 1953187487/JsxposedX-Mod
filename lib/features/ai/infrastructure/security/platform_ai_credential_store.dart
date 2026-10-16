import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:JsxposedX/features/ai/domain/ports/ai_credential_store.dart';

class PlatformAiCredentialStore implements AiCredentialStore {
  const PlatformAiCredentialStore(this._storage);

  static const _prefix = 'ai_credential_v2_';
  final FlutterSecureStorage _storage;

  @override
  Future<String> put(AiSecret secret, {String? credentialRef}) async {
    final reference = credentialRef ?? const Uuid().v4();
    if (reference.trim().isEmpty) {
      throw ArgumentError.value(reference, 'credentialRef');
    }
    await _storage.write(key: '$_prefix$reference', value: secret.value);
    return reference;
  }

  @override
  Future<AiSecret?> read(String credentialRef) async {
    final value = await _storage.read(key: '$_prefix$credentialRef');
    return value == null ? null : AiSecret(value);
  }

  @override
  Future<void> delete(String credentialRef) {
    return _storage.delete(key: '$_prefix$credentialRef');
  }
}
