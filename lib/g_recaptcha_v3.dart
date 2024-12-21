library g_recaptcha_v3;

import 'dart:async';

import 'src/_g_recaptcha_v3_native.dart'
    if (dart.library.js_interop) 'src/g_recaptcha_v3_web.dart' as recap;

/// Google reCAPTCHA v3 plugin for flutter web.
///
/// `ready()` `execute()` `hideBadge()` `showBadge()` methods are available.
///
/// `Supports only web.`
class GRecaptchaV3 {
  /// use in `main()` or before `execute()`
  ///
  /// `Supports only web.`
  ///
  /// return `true` if
  /// - Google reCAPTCHA v3 sript is loaded &&
  /// - Site key has been set
  ///
  /// [siteKey] - Your recaptcha v3 siteKey.
  ///
  /// This method should be called before calling `execute()` method.
  ///
  /// sets z-index of recatpcha badge to `10` to be on top of flutter elements
  ///
  /// ## Warning:
  ///
  /// ### [From reCaptcha docs](https://developers.google.com/recaptcha/docs/faq#id-like-to-hide-the-recaptcha-badge.-what-is-allowed)
  ///
  /// You are allowed to hide the badge as long as you include the `reCAPTCHA branding visibly in the user flow.`
  ///
  static Future<bool> ready(String siteKey, {bool showBadge = true}) async {
    return await recap.GRecaptchaV3PlatformInterface.ready(siteKey, showBadge);
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
  /// For example:
  ///
  ///![alternate way](https://developers.google.com/recaptcha/images/text_badge_example.png)
  ///
  static Future<void> hideBadge() async {
    await recap.GRecaptchaV3PlatformInterface.changeVisibility(false);
  }

  /// set the reCaptcha badge visibility to `visible`
  static Future<void> showBadge() async {
    await recap.GRecaptchaV3PlatformInterface.changeVisibility(true);
  }
}
