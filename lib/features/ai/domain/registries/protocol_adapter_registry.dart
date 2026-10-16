import 'package:JsxposedX/features/ai/domain/ports/ai_protocol_adapter.dart';

class ProtocolAdapterRegistry {
  ProtocolAdapterRegistry(Iterable<AiProtocolAdapter> adapters)
    : _adapters = Map.unmodifiable({
        for (final adapter in adapters) adapter.id: adapter,
      }) {
    if (_adapters.length != adapters.length) {
      throw ArgumentError('Protocol adapter IDs must be unique');
    }
  }

  final Map<String, AiProtocolAdapter> _adapters;

  Iterable<String> get adapterIds => _adapters.keys;

  AiProtocolAdapter require(String id) {
    final adapter = _adapters[id];
    if (adapter == null) {
      throw UnsupportedError('Protocol adapter is not registered: $id');
    }
    return adapter;
  }
}
