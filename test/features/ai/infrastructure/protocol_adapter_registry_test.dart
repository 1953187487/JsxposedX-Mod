import 'package:flutter_test/flutter_test.dart';
import 'package:JsxposedX/features/ai/domain/registries/protocol_adapter_registry.dart';
import 'package:JsxposedX/features/ai/infrastructure/adapters/openai_chat_adapter.dart';

void main() {
  test('resolves adapters by stable ID', () {
    final registry = ProtocolAdapterRegistry([const OpenAiChatAdapter()]);

    expect(registry.require('openai.chat.v1'), isA<OpenAiChatAdapter>());
    expect(() => registry.require('missing'), throwsA(isA<UnsupportedError>()));
  });

  test('rejects duplicate adapter IDs', () {
    expect(
      () => ProtocolAdapterRegistry([
        const OpenAiChatAdapter(),
        const OpenAiChatAdapter(),
      ]),
      throwsArgumentError,
    );
  });
}
