
# g_recaptcha_v3

Create Google reCAPTCHA v3 token for Flutter web.

## Badges

[![Pub](https://img.shields.io/pub/v/g_recaptcha_v3.svg?style=flat-square)](https://pub.dartlang.org/packages/g_recaptcha_v3) 

[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?style=flat-square)](https://github.com/bharathraj-e/g_recaptcha_v3/blob/dev/LICENSE)


## Preparation

#### Step 1

- [Create your keys 🗝 ](https://www.google.com/recaptcha/admin)
- [ReCaptcha Docs](https://developers.google.com/recaptcha/docs/v3)
- For development, add `localhost` as domain in reCaptcha console

#### Step 2

- Add the script inside the `web/index.html` `<body>` tag

```html
  <script src="https://www.google.com/recaptcha/api.js?render=<your Recaptcha site key>"></script>
```
#### Step 3

- Add `g_recaptcha_v3` to pubspec.yaml

```bash
  flutter pub add g_recaptcha_v3
```

## Development

### GRecaptchaV3.ready()

The `ready()` method should be called before `execute()`

````dart
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart'; //--1

void main() async {
  await GRecaptchaV3.ready("<your Recaptcha site key>"); //--2
  runApp(const MyApp());
}
````

### GRecaptchaV3.execute()

The `ready()` method should be called before `execute()`

````dart
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

void generateToken() async {
  String? token = await GRecaptchaV3.execute('<your_action>'); //--3
  print(token);
}
````
- `String action` - used to verify the string in backend. ( [action docs](https://developers.google.com/recaptcha/docs/v3#actions) )
- `token` will be null if the,
  - web setup has any errors.
  - method called from other than web platform.

### Web Port 80 setup 
#### (for localhost only)

Other than port :80, recaptcha script will give you error.

```bash
  flutter run web --web-port 80
```

## Roadmap

- Additional platform support

- reCaptcha Badge setup 
