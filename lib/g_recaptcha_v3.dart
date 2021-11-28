import 'dart:async';

import 'g_recaptcha_v3_native.dart'
    if (dart.library.html) 'g_recaptcha_v3_web.dart' as recap;

/// This class is used to create a Google reCAPTCHA v3 token.
///
/// `Supports only web.`
class GRecaptchaV3 {
  /// use in main()
  ///
  /// This method should be called before calling `execute()` method.
  ///
  /// [siteKey] - Your recaptcha v3 siteKey.
  ///
  /// `Supports only web.`
  static Future<void> ready(String siteKey,

      /// ## Warning:
      ///
      /// ### [From reCaptcha docs](https://developers.google.com/recaptcha/docs/faq#id-like-to-hide-the-recaptcha-badge.-what-is-allowed)
      ///
      /// You are allowed to hide the badge as long as you include the `reCAPTCHA branding visibly in the user flow.`
      ///
      {bool showBadge = true}) async {
    await recap.GRecaptchaV3PlatformInterface.ready(siteKey, showBadge);
  }

  /// `ready()` method should be called before calling this method.
  ///
  /// `action` the action name for this request
  ///
  /// - eg.'homepage','submit','login','e-commerce' or anything you like.
  ///
  /// returns `token` if success else `null`
  ///
  /// `Supports only web.`
  static Future<String?> execute(String action) async {
    return await recap.GRecaptchaV3PlatformInterface.execute(action);
  }

  /// change the reCaptcha badge visibility
  ///
  /// ## Warning:
  ///
  /// ### [From reCaptcha docs](https://developers.google.com/recaptcha/docs/faq#id-like-to-hide-the-recaptcha-badge.-what-is-allowed)
  ///
  /// You are allowed to hide the badge as long as you include the `reCAPTCHA branding visibly in the user flow.`
  ///
  ///![alternate way](https://developers.google.com/recaptcha/images/text_badge_example.png)
  ///
  static Future<void> hideBadge() async {
    await recap.GRecaptchaV3PlatformInterface.changeVisibility(false);
  }

  /// change the reCaptcha badge visibility
  ///
  /// sets z-index of recatpcha badge to `10` to be on top of flutter elements
  static Future<void> showBadge() async {
    await recap.GRecaptchaV3PlatformInterface.changeVisibility(true);
  }
}
