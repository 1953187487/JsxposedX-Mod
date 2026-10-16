import 'package:JsxposedX/core/models/update.dart';
import 'package:JsxposedX/features/home/presentation/utils/update_check_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldShowUpdateDialog', () {
    test('returns true when remote build number is greater', () {
      final update = Update(
        code: 200,
        check: '',
        msg: const UpdateMsg(
          version: '501',
          url: 'https://example.com/download',
          content: 'bugfix',
          mustUpdate: '',
        ),
      );

      expect(
        shouldShowUpdateDialog(update: update, localBuildNumber: 500),
        isTrue,
      );
    });

    test('returns false when remote build number is not greater', () {
      final update = Update(
        code: 200,
        check: '',
        msg: const UpdateMsg(
          version: '500',
          url: 'https://example.com/download',
          content: 'bugfix',
          mustUpdate: '',
        ),
      );

      expect(
        shouldShowUpdateDialog(update: update, localBuildNumber: 500),
        isFalse,
      );
    });

    test('returns false when version cannot be parsed', () {
      final update = Update(
        code: 200,
        check: '',
        msg: const UpdateMsg(
          version: '5.0.1',
          url: 'https://example.com/download',
          content: 'bugfix',
          mustUpdate: '',
        ),
      );

      expect(
        shouldShowUpdateDialog(update: update, localBuildNumber: 500),
        isFalse,
      );
    });

    test('returns false when download url is empty', () {
      final update = Update(
        code: 200,
        check: '',
        msg: const UpdateMsg(
          version: '501',
          url: '',
          content: 'bugfix',
          mustUpdate: '',
        ),
      );

      expect(
        shouldShowUpdateDialog(update: update, localBuildNumber: 500),
        isFalse,
      );
    });
  });
}
