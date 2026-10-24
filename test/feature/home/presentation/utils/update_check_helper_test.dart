import 'package:JsxposedX/core/models/update.dart';
import 'package:JsxposedX/features/home/presentation/utils/update_check_helper.dart';
import 'package:flutter_test/flutter_test.dart';

Update _update(String version, {String url = 'https://example.com/download'}) {
  return Update(
    code: 200,
    check: '',
    msg: UpdateMsg(
      version: version,
      url: url,
      content: 'bugfix',
      mustUpdate: '',
    ),
  );
}

void main() {
  group('compareAppVersion', () {
    test('parses semver with prerelease', () {
      expect(compareAppVersion('1.0.2-beta.2', '1.0.2-beta.1'), greaterThan(0));
      expect(compareAppVersion('1.0.2-beta.1', '1.0.2-beta.2'), lessThan(0));
      expect(compareAppVersion('1.0.2-beta.1', '1.0.2-beta.1'), 0);
    });

    test('handles v prefix and plain versions', () {
      expect(compareAppVersion('v1.0.2', '1.0.1'), greaterThan(0));
      expect(compareAppVersion('1.2.0', '1.10.0'), lessThan(0));
    });

    test('release is newer than prerelease of same core', () {
      expect(compareAppVersion('1.0.2', '1.0.2-beta.9'), greaterThan(0));
      expect(compareAppVersion('1.0.2-beta.9', '1.0.2'), lessThan(0));
    });

    test('unparseable versions compare equal', () {
      expect(compareAppVersion('unknown', '1.0.0'), 0);
    });
  });

  group('shouldShowUpdateDialog', () {
    test('returns true when remote version is newer', () {
      expect(
        shouldShowUpdateDialog(
          update: _update('1.0.2-beta.2'),
          localVersionName: '1.0.2-beta.1',
        ),
        isTrue,
      );
    });

    test('returns false when remote version is not newer', () {
      expect(
        shouldShowUpdateDialog(
          update: _update('1.0.2-beta.1'),
          localVersionName: '1.0.2-beta.1',
        ),
        isFalse,
      );
      expect(
        shouldShowUpdateDialog(
          update: _update('1.0.1'),
          localVersionName: '1.0.2-beta.2',
        ),
        isFalse,
      );
    });

    test('returns false when version cannot be parsed', () {
      expect(
        shouldShowUpdateDialog(
          update: _update('not-a-version'),
          localVersionName: '1.0.2-beta.2',
        ),
        isFalse,
      );
    });

    test('returns false when download url is empty', () {
      expect(
        shouldShowUpdateDialog(
          update: _update('9.9.9', url: ''),
          localVersionName: '1.0.2-beta.2',
        ),
        isFalse,
      );
    });
  });
}
