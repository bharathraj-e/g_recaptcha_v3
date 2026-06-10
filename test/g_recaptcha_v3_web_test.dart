@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:g_recaptcha_v3/src/g_recaptcha_v3_web.dart';

void main() {
  group('buildScriptUrl', () {
    test('default google.com url', () {
      expect(
        GRecaptchaV3PlatformInterface.buildScriptUrl(
          'my-key',
          useRecaptchaNet: false,
          useEnterprise: false,
        ),
        'https://www.google.com/recaptcha/api.js?render=my-key',
      );
    });

    test('recaptcha.net host', () {
      expect(
        GRecaptchaV3PlatformInterface.buildScriptUrl(
          'my-key',
          useRecaptchaNet: true,
          useEnterprise: false,
        ),
        'https://www.recaptcha.net/recaptcha/api.js?render=my-key',
      );
    });

    test('enterprise script', () {
      expect(
        GRecaptchaV3PlatformInterface.buildScriptUrl(
          'my-key',
          useRecaptchaNet: false,
          useEnterprise: true,
        ),
        'https://www.google.com/recaptcha/enterprise.js?render=my-key',
      );
    });

    test('badge language adds hl param', () {
      expect(
        GRecaptchaV3PlatformInterface.buildScriptUrl(
          'my-key',
          useRecaptchaNet: false,
          useEnterprise: false,
          badgeLanguage: 'fr',
        ),
        'https://www.google.com/recaptcha/api.js?render=my-key&hl=fr',
      );
    });

    test('site key and language are query-encoded', () {
      expect(
        GRecaptchaV3PlatformInterface.buildScriptUrl(
          'a key&x',
          useRecaptchaNet: false,
          useEnterprise: false,
          badgeLanguage: 'zh-CN',
        ),
        'https://www.google.com/recaptcha/api.js?render=a+key%26x&hl=zh-CN',
      );
    });
  });

  test('isReady is false before ready()', () {
    expect(GRecaptchaV3.isReady, isFalse);
  });

  test('execute() before ready() throws GRecaptchaNotReadyException', () {
    expect(
      () => GRecaptchaV3.execute('login'),
      throwsA(isA<GRecaptchaNotReadyException>()),
    );
  });
}
