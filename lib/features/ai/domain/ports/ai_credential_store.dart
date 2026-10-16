abstract interface class AiCredentialStore {
  Future<String> put(AiSecret secret, {String? credentialRef});

  Future<AiSecret?> read(String credentialRef);

  Future<void> delete(String credentialRef);
}

class AiSecret {
  const AiSecret(this.value);

  final String value;

  @override
  String toString() => 'AiSecret(***)';
}
