@JS('grecaptcha')
library g_recaptcha_v3_web;

import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;

@JS('flutter_g_recaptcha_v3_key')
external set _gRecaptchaV3Key(String key);
@JS('flutter_g_recaptcha_v3_key')
external String get _gRecaptchaV3Key;

@JS('ready')
external Future _ready(void Function() f);

@JS('execute')
external Future<String> _execute(String action, _Options options);

@JS()
@anonymous
class _Options {
  external String get action;
  external factory _Options({String action});
}

/// A web implementation of the GRecaptchaV3 plugin.
///
/// use `GRecaptchaV3` not ~GRecaptchaV3Web~
class GRecaptchaV3Web {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'g_recaptcha_v3',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = GRecaptchaV3Web();
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

  /// use `GRecaptchaV3` not ~GRecaptchaV3Web~
  static Future<void> ready(String key, bool showBadge) async {
    if (!kIsWeb) return;
    _gRecaptchaV3Key = key;

    try {
      await _ready(allowInterop(() {
        debugPrint('gRecaptcha V3 ready');
        changeVisibility(showBadge);
      }));
    } catch (e) {
      debugPrint(e.toString());
      // !TypeError: Cannot read properties of undefined (reading 'ready')
    }
  }

  /// use `GRecaptchaV3` not ~GRecaptchaV3Web~
  static Future<String?> execute(String action) async {
    if (!kIsWeb) return null;
    if (":$_gRecaptchaV3Key" == ':undefined') {
      throw Exception('gRecaptcha V3 key not set');
    }
    try {
      var result = await js_util.promiseToFuture(
          await _execute(_gRecaptchaV3Key, _Options(action: action)));
      return result;
    } catch (e) {
      debugPrint(e.toString());
      // Error: No reCAPTCHA clients exist.
      return null;
    }
  }

  /// change the reCaptcha badge visibility
  static Future<void> changeVisibility(bool showBagde) async {
    if (!kIsWeb) return;
    var badge = html.document.querySelector(".grecaptcha-badge");
    if (badge == null) return;
    badge.style.zIndex = "10";
    badge.style.visibility = showBagde ? "visible" : "hidden";
  }
}
