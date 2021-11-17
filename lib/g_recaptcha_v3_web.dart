@JS('grecaptcha')
library g_recaptcha_v3_web;

import 'dart:async';

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
external Future<String> _execute(String action, Options options);

@JS()
@anonymous
class Options {
  external String get action;

  // Must have an unnamed factory constructor with named arguments.
  external factory Options({String action});
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

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      // case 'ready':
      //   return ready(call.arguments);
      // case 'execute':
      //   return execute(call.arguments);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'g_recaptcha_v3 for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// use `GRecaptchaV3` not ~GRecaptchaV3Web~
  static Future<void> ready(String key) async {
    if (!kIsWeb) return;
    _gRecaptchaV3Key = key;
    try {
      await _ready(allowInterop(() {
        debugPrint('gRecaptcha V3 ready');
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
      return await js_util.promiseToFuture(
          await _execute(_gRecaptchaV3Key, Options(action: action)));
    } catch (e) {
      debugPrint(e.toString());
      // !Error: No reCAPTCHA clients exist.
      return null;
    }
  }
}
