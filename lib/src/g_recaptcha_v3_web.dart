library g_recaptcha_v3;

import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

@JS('grecaptcha.ready')
external void _ready(JSFunction callback);

@JS('grecaptcha.execute')
external JSPromise<JSString?> _execute(JSString siteKey, JSAny options);

web.HTMLElement? get recaptchaWidget =>
    web.document.querySelector(".grecaptcha-badge") as web.HTMLElement?;

/// A web implementation of the GRecaptchaV3 plugin.
///
/// use `GRecaptchaV3` not ~GRecaptchaV3PlatformInterace~
class GRecaptchaV3PlatformInterface {
  static _logger(String message) {
    debugPrint("[g_recaptcha_v3] $message");
  }

  /// storing the site key
  static JSString? _gRecaptchaV3Key;

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'g_recaptcha_v3',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = GRecaptchaV3PlatformInterface();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'g_recaptcha_v3 for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  // Function to check if the reCAPTCHA script already exists
  static Future<void> _addRecaptchaScriptIfNotExists() async {
    final Completer completer = Completer();

    // Check if the script with the specified URL already exists
    final web.HTMLCollection scripts = web.document.scripts;
    bool scriptExists = false;
    for (var i = 0; i < scripts.length; i++) {
      final script = scripts.item(i) as web.HTMLScriptElement?;
      if (script == null) continue;

      if (script.src.startsWith('https://www.google.com/recaptcha/api.js')) {
        scriptExists = true;
        break;
      }
    }

    // call completer.complete() after 10 seconds if script adding fails
    Future.delayed(const Duration(seconds: 10)).then((value) {
      _logger('reCAPTCHA script adding failed.');
      if (!completer.isCompleted) completer.complete();
    });

    // If script does not exist, create and append it
    if (!scriptExists) {
      final scriptElement = web.HTMLScriptElement();
      scriptElement.src =
          'https://www.google.com/recaptcha/api.js?render=${_gRecaptchaV3Key!.toDart}';
      scriptElement.async = true;
      scriptElement.defer = true;
      scriptElement.type = 'text/javascript';

      scriptElement.onLoad.listen((_) {
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          if (!completer.isCompleted) completer.complete();
        });
      });

      web.document.head?.append(scriptElement);
      _logger('reCAPTCHA script added.');
    } else {
      _logger('reCAPTCHA script already exists.');
      completer.complete();
    }

    return completer.future;
  }

  /// This method should be called before calling `execute()` method.
  static Future<bool> ready(String key, bool showBadge) async {
    if (!kIsWeb) return false;
    try {
      _gRecaptchaV3Key = key.toJS;

      await _addRecaptchaScriptIfNotExists();

      Completer<bool> completer = Completer<bool>();

      var f = () {
        _logger('ready');
        completer.complete(true);
        changeVisibility(showBadge);
      }.toJS;

      _ready(f);

      return completer.future;
    } catch (e) {
      _logger("Error: Looks like reCaptcha js is not loaded yet."
          "Try to add the recaptcha js to your html <head> tag (or before flutter.js).");
      _logger(e.toString());
      return false;
    }
  }

  /// use `GRecaptchaV3` not ~GRecaptchaV3PlatformInterace~
  static Future<String?> execute(String action) async {
    if (!kIsWeb) return null;

    if (_gRecaptchaV3Key.isUndefinedOrNull) {
      throw Exception('gRecaptcha V3 key not set : Try calling ready() first.');
    }

    try {
      var actionObj = {"action": action}.jsify();

      if (actionObj == null) {
        _logger("[g_recaptcha_v3] Issue with execute - action object");
        return null;
      }

      final result = await _execute(_gRecaptchaV3Key!, actionObj).toDart;

      if (result.isUndefinedOrNull) return null;

      return result?.toDart;
    } catch (e) {
      _logger(e.toString());
      return null;
    }
  }

  /// update the reCaptcha badge visibility to `visible` or `hidden`
  static Future<void> changeVisibility(bool showBagde) async {
    if (!kIsWeb) return;
    var badge = recaptchaWidget;
    if (badge == null) {
      _logger("Badge not found");
      return;
    }
    badge.style.zIndex = "10";
    badge.style.visibility = showBagde ? "visible" : "hidden";
  }
}
