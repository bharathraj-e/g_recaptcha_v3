/// A web implementation of the GRecaptchaV3 plugin.
///
/// use `GRecaptchaV3` not ~GRecaptchaV3PlatformInterace~
class GRecaptchaV3PlatformInterface {
  /// use `GRecaptchaV3` not ~GRecaptchaV3Platform~
  static Future<bool> ready(String key, bool showBadge) async {
    return false;
  }

  /// use `GRecaptchaV3` not ~GRecaptchaV3PlatformInterace~
  static Future<String?> execute(String action) async {
    return null;
  }

  /// change the reCaptcha badge visibility
  static Future<void> changeVisibility(bool showBagde) async {
    return;
  }
}
