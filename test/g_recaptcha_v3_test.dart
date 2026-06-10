@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

void main() {
  group('non-web stub', () {
    test('ready() returns false', () async {
      expect(await GRecaptchaV3.ready('site-key'), isFalse);
    });

    test('ready() accepts all options', () async {
      final result = await GRecaptchaV3.ready(
        'site-key',
        showBadge: false,
        useRecaptchaNet: true,
        useEnterprise: true,
        badgeLanguage: 'fr',
        scriptNonce: 'abc123',
      );
      expect(result, isFalse);
    });

    test('execute() returns null', () async {
      expect(await GRecaptchaV3.execute('login'), isNull);
    });

    test('execute() with throwOnError still returns null off web', () async {
      expect(await GRecaptchaV3.execute('login', throwOnError: true), isNull);
    });

    test('isReady is false', () {
      expect(GRecaptchaV3.isReady, isFalse);
    });

    test('badge helpers complete without error', () async {
      await GRecaptchaV3.hideBadge();
      await GRecaptchaV3.showBadge();
    });
  });

  group('exceptions', () {
    test('toString includes type and message', () {
      expect(
        const GRecaptchaNotReadyException('call ready() first').toString(),
        'GRecaptchaNotReadyException: call ready() first',
      );
      expect(
        const GRecaptchaExecutionException('boom').toString(),
        'GRecaptchaExecutionException: boom',
      );
    });

    test('subtypes are GRecaptchaException', () {
      expect(
          const GRecaptchaNotReadyException('x'), isA<GRecaptchaException>());
      expect(
          const GRecaptchaExecutionException('x'), isA<GRecaptchaException>());
    });
  });
}
