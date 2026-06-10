## 1.1.0 - [2026-06-10]

### Features

* reCAPTCHA Enterprise support via `ready(useEnterprise: true)`.
* `ready(useRecaptchaNet: true)` loads the script from `recaptcha.net` for regions where `google.com` is blocked.
* `ready(badgeLanguage: 'fr')` sets the badge language (`hl` query parameter).
* `ready(scriptNonce: ...)` applies a CSP nonce to the injected script tag.
* New `GRecaptchaV3.isReady` getter.
* Typed exceptions: `execute()` now throws `GRecaptchaNotReadyException` when called before `ready()`, and `execute(throwOnError: true)` throws `GRecaptchaExecutionException` on failure instead of returning `null`.

### Fixes

* `ready()` no longer hangs forever — it now times out and returns `false` if the reCAPTCHA script fails to load or `grecaptcha.ready` never fires (e.g. invalid site key, blocked network, ad-blocker).
* Script load errors are detected immediately via `onError` instead of waiting out the timeout.
* Replaced the fixed 500ms post-load delay with polling for the `grecaptcha` global.
* Fixed `showBadge: false` race — the badge element is inserted asynchronously by reCAPTCHA, visibility changes now retry until the badge appears.
* Logging only happens in debug mode.
* Removed unused method channel boilerplate and fixed doc typos.

### Housekeeping

* Added unit tests (VM + browser) and a GitHub Actions CI workflow.
* Reworked README (automatic script injection, advanced options, error handling) and API doc comments.
* Minimum SDK raised to Dart 3.4 / Flutter 3.22.

## 1.0.0 - [2024-12-21]

* WASM support added.
* no need to do add script tag in html file. The package will do it automatically.
* More Optimization.

## 0.0.6 - [2024-02-09]

* Js package Updated.

## 0.0.5 - [2022-06-11]

* Added bool return for ready()
* Readme updated.

## 0.0.4 - [2021-11-28]

* Fixed dart html error during android / ios build

## 0.0.3 - [2021-11-20]

* Added Show/hide reCaptcha badge.

## 0.0.2-beta - [2021-11-17]

* Recaptcha Typo fixes.
* `NoSuchMethodError: tried to call a non-function, such as null: 'dart.global.ready'` fixed

## 0.0.1-beta - [2021-11-14]

* Initial release for Web only platform.
