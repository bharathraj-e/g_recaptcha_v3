import 'dart:async';

import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3_web.dart';

/// This class is used to create a Google reCAPTCHA v3 token.
///
/// `Supports only web.`
class GRecaptchaV3 {
  // static const MethodChannel _channel = MethodChannel('g_recaptcha_v3');

  // static Future<String?> get platformVersion async {
  //   final String? version = await _channel.invokeMethod('getPlatformVersion');
  //   return version;
  // }

  /// use in main()
  ///
  /// This method should be called before calling `execute()` method.
  ///
  /// [siteKey] - Your recaptcha v3 siteKey.
  ///
  /// `Supports only web.`
  static Future<void> ready(String siteKey) async {
    if (kIsWeb) {
      // await _channel.invokeMethod('ready', key);
      await GRecaptchaV3Web.ready(siteKey);
    }
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
    if (kIsWeb) {
      // final String? token = await _channel.invokeMethod('execute', action);
      return await GRecaptchaV3Web.execute(action);
    }
    return null;
  }
}
