import 'package:JsxposedX/features/ai/domain/models/ai_system_models.dart';

class ProviderDefinitionRegistry {
  ProviderDefinitionRegistry(Iterable<AiProviderDefinition> providers)
    : _providers = Map.unmodifiable({
        for (final provider in providers) provider.id: provider,
      }) {
    if (_providers.length != providers.length) {
      throw ArgumentError('Provider definition IDs must be unique');
    }
  }

  final Map<String, AiProviderDefinition> _providers;

  Iterable<String> get providerIds => _providers.keys;

  Iterable<AiProviderDefinition> get providers => _providers.values;

  AiProviderDefinition require(String id) {
    final provider = _providers[id];
    if (provider == null) {
      throw UnsupportedError('Provider is not registered: $id');
    }
    return provider;
  }
}
