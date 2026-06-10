import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'g_recaptcha_v3_exceptions.dart';

@JS('grecaptcha')
external _Grecaptcha? get _grecaptcha;

/// Bindings shared by `grecaptcha` and `grecaptcha.enterprise` —
/// both expose the same `ready` / `execute` API.
extension type _Grecaptcha._(JSObject _) implements JSObject {
  external void ready(JSFunction callback);
  external JSPromise<JSString?> execute(JSString siteKey, JSAny options);
  external _Grecaptcha? get enterprise;
}

/// The reCAPTCHA badge element, or `null` if it has not been
/// inserted into the DOM yet.
web.HTMLElement? get recaptchaWidget =>
    web.document.querySelector(".grecaptcha-badge") as web.HTMLElement?;

/// The web implementation of the GRecaptchaV3 plugin.
///
/// Use the public `GRecaptchaV3` facade instead of calling this directly.
class GRecaptchaV3PlatformInterface {
  static void _logger(String message) {
    if (kDebugMode) debugPrint("[g_recaptcha_v3] $message");
  }

  /// The site key passed to `ready()`, kept for subsequent `execute()` calls.
  static JSString? _gRecaptchaV3Key;

  static bool _useEnterprise = false;

  static bool _isReady = false;

  /// Whether `ready()` has completed successfully.
  static bool get isReady => _isReady;

  static void registerWith(Registrar registrar) {
    // No method channel needed: all calls go through static js_interop
    // bindings. Registration only requires this entry point to exist.
  }

  // The active grecaptcha API object: `grecaptcha` or `grecaptcha.enterprise`.
  static _Grecaptcha? get _api =>
      _useEnterprise ? _grecaptcha?.enterprise : _grecaptcha;

  /// Builds the reCAPTCHA script URL for the given configuration.
  @visibleForTesting
  static String buildScriptUrl(
    String siteKey, {
    required bool useRecaptchaNet,
    required bool useEnterprise,
    String? badgeLanguage,
  }) {
    final host = useRecaptchaNet ? 'www.recaptcha.net' : 'www.google.com';
    final file = useEnterprise ? 'enterprise.js' : 'api.js';
    final hl = badgeLanguage == null
        ? ''
        : '&hl=${Uri.encodeQueryComponent(badgeLanguage)}';
    return 'https://$host/recaptcha/$file'
        '?render=${Uri.encodeQueryComponent(siteKey)}$hl';
  }

  // Adds the reCAPTCHA script tag if not already present and waits until
  // the grecaptcha API is available (or the timeout elapses).
  static Future<bool> _addRecaptchaScriptIfNotExists({
    required Duration timeout,
    required bool useRecaptchaNet,
    String? badgeLanguage,
    String? scriptNonce,
  }) async {
    final Completer<bool> completer = Completer<bool>();

    void completeOnce(bool success) {
      if (!completer.isCompleted) completer.complete(success);
    }

    // Wait until the script has executed and the grecaptcha API exists.
    Future<void> waitForGrecaptcha() async {
      while (!completer.isCompleted) {
        if (_api != null) {
          completeOnce(true);
          return;
        }
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    // Check if a reCAPTCHA script (google.com or recaptcha.net,
    // standard or enterprise) already exists
    final web.HTMLCollection scripts = web.document.scripts;
    bool scriptExists = false;
    for (var i = 0; i < scripts.length; i++) {
      final script = scripts.item(i) as web.HTMLScriptElement?;
      if (script == null) continue;

      if (script.src.contains('/recaptcha/api.js') ||
          script.src.contains('/recaptcha/enterprise.js')) {
        scriptExists = true;
        break;
      }
    }

    Future.delayed(timeout).then((_) {
      if (!completer.isCompleted) {
        _logger('Timed out waiting for the reCAPTCHA script to load.');
        completeOnce(false);
      }
    });

    // If script does not exist, create and append it
    if (!scriptExists) {
      final scriptElement = web.HTMLScriptElement();
      scriptElement.src = buildScriptUrl(
        _gRecaptchaV3Key!.toDart,
        useRecaptchaNet: useRecaptchaNet,
        useEnterprise: _useEnterprise,
        badgeLanguage: badgeLanguage,
      );
      scriptElement.async = true;
      scriptElement.defer = true;
      scriptElement.type = 'text/javascript';
      if (scriptNonce != null) scriptElement.nonce = scriptNonce;

      scriptElement.onLoad.listen((_) => waitForGrecaptcha());
      scriptElement.onError.listen((_) {
        _logger('reCAPTCHA script failed to load '
            '(network blocked, offline, or an ad-blocker?).');
        completeOnce(false);
      });

      web.document.head?.append(scriptElement);
      _logger('reCAPTCHA script added.');
    } else {
      _logger('reCAPTCHA script already exists.');
      waitForGrecaptcha();
    }

    return completer.future;
  }

  /// Loads the reCAPTCHA script (if needed) and waits for `grecaptcha.ready`.
  ///
  /// Returns `false` if the script fails to load or the ready callback does
  /// not fire within 10 seconds. Must be called before `execute()`.
  static Future<bool> ready(
    String key, {
    required bool showBadge,
    required bool useRecaptchaNet,
    required bool useEnterprise,
    String? badgeLanguage,
    String? scriptNonce,
  }) async {
    if (!kIsWeb) return false;
    try {
      _isReady = false;
      _gRecaptchaV3Key = key.toJS;
      _useEnterprise = useEnterprise;

      final scriptLoaded = await _addRecaptchaScriptIfNotExists(
        timeout: const Duration(seconds: 10),
        useRecaptchaNet: useRecaptchaNet,
        badgeLanguage: badgeLanguage,
        scriptNonce: scriptNonce,
      );
      if (!scriptLoaded) return false;

      final api = _api;
      if (api == null) {
        _logger(useEnterprise
            ? 'grecaptcha.enterprise is not available - '
                'is the loaded script the enterprise one?'
            : 'grecaptcha is not available.');
        return false;
      }

      Completer<bool> completer = Completer<bool>();

      var f = () {
        _logger('ready');
        _isReady = true;
        if (!completer.isCompleted) completer.complete(true);
        // Fire and forget: the badge appears asynchronously and
        // changeVisibility retries internally until it does.
        changeVisibility(showBadge);
      }.toJS;

      api.ready(f);

      // Guard against grecaptcha.ready never firing its callback
      // (e.g. an invalid site key) so callers are not stuck awaiting.
      Future.delayed(const Duration(seconds: 10)).then((_) {
        if (!completer.isCompleted) {
          _logger('Timed out waiting for grecaptcha.ready().');
          completer.complete(false);
        }
      });

      return completer.future;
    } catch (e) {
      _logger("Error: Looks like the reCAPTCHA js could not be set up. "
          "As a fallback, try adding the script tag to your html <head> "
          "manually (before flutter.js / flutter_bootstrap.js).");
      _logger(e.toString());
      return false;
    }
  }

  /// Runs `grecaptcha.execute(siteKey, {action})` and returns the token.
  ///
  /// Throws a `GRecaptchaNotReadyException` if `ready()` was never called.
  /// Other failures return `null`, or throw a `GRecaptchaExecutionException`
  /// when [throwOnError] is `true`.
  static Future<String?> execute(
    String action, {
    required bool throwOnError,
  }) async {
    if (!kIsWeb) return null;

    if (_gRecaptchaV3Key == null) {
      throw const GRecaptchaNotReadyException(
          'gRecaptcha V3 key not set: try calling ready() first.');
    }

    final api = _api;
    if (api == null) {
      const error = GRecaptchaNotReadyException(
          'grecaptcha is not available: did ready() succeed?');
      if (throwOnError) throw error;
      _logger(error.message);
      return null;
    }

    try {
      final actionObj = {"action": action}.jsify()!;
      final result = await api.execute(_gRecaptchaV3Key!, actionObj).toDart;
      return result?.toDart;
    } catch (e) {
      final error = GRecaptchaExecutionException(e.toString());
      if (throwOnError) throw error;
      _logger(error.message);
      return null;
    }
  }

  /// update the reCaptcha badge visibility to `visible` or `hidden`
  static Future<void> changeVisibility(bool showBadge) async {
    if (!kIsWeb) return;

    // The badge element is inserted by grecaptcha asynchronously, so it may
    // not exist yet right after ready() — retry briefly before giving up.
    web.HTMLElement? badge = recaptchaWidget;
    const maxAttempts = 20;
    for (var attempt = 0; badge == null && attempt < maxAttempts; attempt++) {
      await Future.delayed(const Duration(milliseconds: 100));
      badge = recaptchaWidget;
    }
    if (badge == null) {
      _logger("Badge not found");
      return;
    }
    badge.style.zIndex = "10";
    badge.style.visibility = showBadge ? "visible" : "hidden";
  }
}
