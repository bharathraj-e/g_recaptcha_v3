import 'src/_g_recaptcha_v3_native.dart'
    if (dart.library.js_interop) 'src/g_recaptcha_v3_web.dart' as recap;

export 'src/g_recaptcha_v3_exceptions.dart';

/// Google reCAPTCHA v3 plugin for flutter web.
///
/// `ready()` `execute()` `hideBadge()` `showBadge()` methods are available.
///
/// `Supports only web.`
class GRecaptchaV3 {
  /// Whether [ready] has completed successfully.
  ///
  /// Always `false` on non-web platforms.
  static bool get isReady => recap.GRecaptchaV3PlatformInterface.isReady;

  /// use in `main()` or before `execute()`
  ///
  /// `Supports only web.`
  ///
  /// return `true` if
  /// - Google reCAPTCHA v3 script is loaded &&
  /// - Site key has been set
  ///
  /// [siteKey] - Your recaptcha v3 siteKey.
  ///
  /// [showBadge] - whether the reCaptcha badge should stay visible.
  ///
  /// [useRecaptchaNet] - load the script from `recaptcha.net` instead of
  /// `google.com` (use when google.com is blocked, e.g. in China).
  /// ([docs](https://developers.google.com/recaptcha/docs/faq#can-i-use-recaptcha-globally))
  ///
  /// [useEnterprise] - use reCAPTCHA Enterprise (`grecaptcha.enterprise`).
  /// ([docs](https://cloud.google.com/recaptcha/docs/instrument-web-pages))
  ///
  /// [badgeLanguage] - an optional language code (e.g. `'fr'`, `'ta'`) for the
  /// badge, passed as the `hl` query parameter.
  /// ([language codes](https://developers.google.com/recaptcha/docs/language))
  ///
  /// [scriptNonce] - an optional CSP nonce applied to the injected
  /// `<script>` tag.
  ///
  /// This method should be called before calling `execute()` method.
  ///
  /// sets z-index of recaptcha badge to `10` to be on top of flutter elements
  ///
  /// ## Warning:
  ///
  /// ### [From reCaptcha docs](https://developers.google.com/recaptcha/docs/faq#id-like-to-hide-the-recaptcha-badge.-what-is-allowed)
  ///
  /// You are allowed to hide the badge as long as you include the `reCAPTCHA branding visibly in the user flow.`
  ///
  static Future<bool> ready(
    String siteKey, {
    bool showBadge = true,
    bool useRecaptchaNet = false,
    bool useEnterprise = false,
    String? badgeLanguage,
    String? scriptNonce,
  }) async {
    return await recap.GRecaptchaV3PlatformInterface.ready(
      siteKey,
      showBadge: showBadge,
      useRecaptchaNet: useRecaptchaNet,
      useEnterprise: useEnterprise,
      badgeLanguage: badgeLanguage,
      scriptNonce: scriptNonce,
    );
  }

  /// `ready()` method should be called before calling this method.
  ///
  /// `action` the action name for this request
  ///
  /// - eg.'homepage','submit','login','e-commerce' or anything you like.
  ///
  /// returns `token` if success else `null`
  ///
  /// Throws a [GRecaptchaNotReadyException] if `ready()` was not called
  /// first. With [throwOnError] set to `true`, failures of the underlying
  /// `grecaptcha.execute()` call throw a [GRecaptchaExecutionException]
  /// instead of returning `null`.
  ///
  /// `Supports only web.`
  static Future<String?> execute(
    String action, {
    bool throwOnError = false,
  }) async {
    return await recap.GRecaptchaV3PlatformInterface.execute(
      action,
      throwOnError: throwOnError,
    );
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
