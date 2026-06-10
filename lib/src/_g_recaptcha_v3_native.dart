/// The non-web stub of the GRecaptchaV3 plugin.
///
/// reCAPTCHA v3 only exists in browsers, so every member here is a no-op
/// that lets the same app code compile and run on mobile/desktop.
///
/// Use the public `GRecaptchaV3` facade instead of calling this directly.
class GRecaptchaV3PlatformInterface {
  /// Always `false` on non-web platforms.
  static bool get isReady => false;

  /// Always returns `false` on non-web platforms.
  static Future<bool> ready(
    String key, {
    required bool showBadge,
    required bool useRecaptchaNet,
    required bool useEnterprise,
    String? badgeLanguage,
    String? scriptNonce,
  }) async {
    return false;
  }

  /// Always returns `null` on non-web platforms.
  static Future<String?> execute(
    String action, {
    required bool throwOnError,
  }) async {
    return null;
  }

  /// Does nothing on non-web platforms.
  static Future<void> changeVisibility(bool showBadge) async {
    return;
  }
}
