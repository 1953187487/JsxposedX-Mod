import 'package:JsxposedX/features/ai/presentation/widgets/ai_chat_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('appendedMessageCount', () {
    test('counts messages appended after the latest existing message', () {
      expect(appendedMessageCount(['a', 'b'], ['a', 'b', 'c']), 1);
      expect(appendedMessageCount(['a'], ['a', 'b', 'c']), 2);
    });

    test('does not count older messages prepended to history', () {
      expect(appendedMessageCount(['b', 'c'], ['a', 'b', 'c']), 0);
    });

    test('does not count deletion as a new message', () {
      expect(appendedMessageCount(['a', 'b', 'c'], ['a', 'b']), 0);
    });

    test('counts a regenerated tail after removed messages', () {
      expect(
        appendedMessageCount(
          ['a', 'old-user', 'old-answer'],
          ['a', 'new-answer'],
        ),
        1,
      );
    });

    test('does not compare unrelated conversations', () {
      expect(appendedMessageCount(['old'], ['new']), 0);
    });
  });
}
