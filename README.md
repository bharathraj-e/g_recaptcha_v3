
# g_recaptcha_v3

Create Google reCAPTCHA v3 token for Flutter web.  Google reCAPTCHA v3 plugin for Flutter. A Google reCAPTCHA is a free service that protects your website from spam and abuse.

[![Pub](https://img.shields.io/pub/v/g_recaptcha_v3.svg?style=flat-square)](https://pub.dartlang.org/packages/g_recaptcha_v3)
[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?style=flat-square)](https://github.com/bharathraj-e/g_recaptcha_v3/blob/dev/LICENSE)

> [Web Demo](https://bharathraj-e.github.io/g_recaptcha_v3_example_build/)


<img src='https://raw.githubusercontent.com/bharathraj-e/g_recaptcha_v3/dev/sample.gif' width='70%'>

<hr>

## Preparation

#### Step 1

- [Create your keys 🗝 ](https://www.google.com/recaptcha/admin)
- [ReCaptcha Docs](https://developers.google.com/recaptcha/docs/v3)
- For development, add `localhost` as domain in reCaptcha console

#### Step 2

- Add the script inside `web/index.html` - `<body>` tag

```html
  <script src="https://www.google.com/recaptcha/api.js?render=<your Recaptcha v3 site key>"></script>
```
#### Step 3

- Add `g_recaptcha_v3` to pubspec.yaml

```bash
  flutter pub add g_recaptcha_v3
```

## Development

> ### 1. GRecaptchaV3.ready()

The `ready()` method should be called before `execute()`

````dart
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart'; //--1

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GRecaptchaV3.ready("<your Recaptcha site key>"); //--2
  runApp(const MyApp());
}
````

> ### 2. GRecaptchaV3.execute()

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
- `token` will be null if the,
  - web setup has any errors.
  - method called from other than web platform.

> ### 3. Show / Hide reCaptcha badge

change the reCaptcha badge visibility

````dart
    GRecaptchaV3.showBadge();
    GRecaptchaV3.hideBadge();
````
  
## Warning!!!
  
You are allowed to hide the badge as long as you `include the reCAPTCHA branding` visibly in the user flow.`

Sample Image 

![alternate way](https://developers.google.com/recaptcha/images/text_badge_example.png)

### [Read more about hiding - reCaptcha docs](https://developers.google.com/recaptcha/docs/faq#id-like-to-hide-the-recaptcha-badge.-what-is-allowed)
  

### Web Port 80 setup 
##### (for localhost only)

If in case recaptcha script gives you error for port other than port :80, you can use the following code to setup the port.

```bash
  flutter run -d chrome --web-port 80
```