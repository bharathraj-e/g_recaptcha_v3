/// Base class for all exceptions thrown by the g_recaptcha_v3 plugin.
class GRecaptchaException implements Exception {
  /// Human readable description of what went wrong.
  final String message;

  const GRecaptchaException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when `execute()` is called before a successful `ready()`.
class GRecaptchaNotReadyException extends GRecaptchaException {
  const GRecaptchaNotReadyException(super.message);
}

/// Thrown when the underlying `grecaptcha.execute()` call fails,
/// if `throwOnError` is enabled.
class GRecaptchaExecutionException extends GRecaptchaException {
  const GRecaptchaExecutionException(super.message);
}
