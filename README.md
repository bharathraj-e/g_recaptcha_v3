
# g_recaptcha_v3

Create Google reCAPTCHA v3 tokens for Flutter web. Google reCAPTCHA is a free service that protects your website from spam and abuse. Supports reCAPTCHA Enterprise, `recaptcha.net`, and WASM builds.

[![Pub](https://img.shields.io/pub/v/g_recaptcha_v3.svg?style=flat-square)](https://pub.dev/packages/g_recaptcha_v3)


> [Web Demo](https://bharathraj-e.github.io/g_recaptcha_v3_example_build/)


<img src='https://raw.githubusercontent.com/bharathraj-e/g_recaptcha_v3/dev/sample.gif' width='70%'>

<hr>

## Preparation

#### Step 1

- [Create your keys 🗝 ](https://www.google.com/recaptcha/admin)
- [ReCaptcha Docs](https://developers.google.com/recaptcha/docs/v3)
- For development, add `localhost` as domain in reCaptcha console

#### Step 2

- Add `g_recaptcha_v3` to pubspec.yaml

```bash
  flutter pub add g_recaptcha_v3
```

#### Optional: manual script tag

The plugin injects the reCAPTCHA script automatically — no `index.html` changes are needed. If you prefer to load it yourself (e.g. for an earlier load), add the script inside the `web/index.html` `<head>` tag, **before** the `flutter.js` / `flutter_bootstrap.js` script. The plugin detects the existing tag and will not add a second one.

```html
<head>
  <script src="https://www.google.com/recaptcha/api.js?render=<your Recaptcha v3 site key>"></script>
</head>
```

## Development

### 1. GRecaptchaV3.ready()

The `ready()` method should be called before `execute()`

````dart
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart'; //--1

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    bool ready = await GRecaptchaV3.ready("<your Recaptcha site key>"); //--2
    print("Is Recaptcha ready? $ready");
  }
  runApp(const MyApp());
}
````

### 2. GRecaptchaV3.execute()

The `ready()` method should be called before `execute()`

````dart
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

void generateToken() async {
  String? token = await GRecaptchaV3.execute('<your_action>'); //--3
  print(token);
  // send token to server and verify
}
````
- `String action` - used to verify the string in backend. ( [action docs](https://developers.google.com/recaptcha/docs/v3#actions) )
- `token` will be null if,
  - the web setup has any errors (see [Error handling](#4-error-handling) for diagnosable exceptions).
  - the method is called from a non-web platform.
- `execute()` throws a `GRecaptchaNotReadyException` if `ready()` was never called.

### 3. Advanced options

```dart
bool ready = await GRecaptchaV3.ready(
  "<your Recaptcha site key>",
  showBadge: false,        // hide the badge (see warning below)
  useRecaptchaNet: true,   // load script from recaptcha.net instead of google.com
                           // (for regions where google.com is blocked, e.g. China)
  useEnterprise: true,     // use reCAPTCHA Enterprise (grecaptcha.enterprise)
  badgeLanguage: 'fr',     // badge language (hl param)
  scriptNonce: '<nonce>',  // CSP nonce for the injected <script> tag
);

// check readiness anywhere
if (GRecaptchaV3.isReady) { ... }
```

### 4. Error handling

By default `execute()` returns `null` on failure. For diagnosable errors:

```dart
try {
  String? token = await GRecaptchaV3.execute('login', throwOnError: true);
} on GRecaptchaNotReadyException {
  // ready() was not called or did not succeed
} on GRecaptchaExecutionException catch (e) {
  // the underlying grecaptcha.execute() call failed
  print(e.message);
}
```

### 5. Show / Hide reCaptcha badge

change the reCaptcha badge visibility

````dart
    GRecaptchaV3.showBadge();
    GRecaptchaV3.hideBadge();
````
  
## Warning!!!

You are allowed to hide the badge as long as you **include the reCAPTCHA branding visibly in the user flow**.

Sample Image

![alternate way](https://developers.google.com/recaptcha/images/text_badge_example.png)

### [Read more about hiding in reCaptcha docs](https://developers.google.com/recaptcha/docs/faq#id-like-to-hide-the-recaptcha-badge.-what-is-allowed)
  

### Web Port 80 setup 
##### (for localhost only)

If in case recaptcha script gives you error for port other than port :80, you can use the following code to setup the port.

```bash
  flutter run -d chrome --web-port 80
```

### FAQ
**Q:** How to hide reCaptcha until / before Flutter render its UI?

**A:** [https://github.com/bharathraj-e/g_recaptcha_v3/issues/3](https://github.com/bharathraj-e/g_recaptcha_v3/issues/3)
