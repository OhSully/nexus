/// Build-time configuration, supplied with `--dart-define` so no secrets or
/// environment-specific values live in git.
///
/// Example:
/// `flutter run --dart-define=APP_ENV=dev --dart-define=SENTRY_DSN=https://...`
class AppConfig {
  const AppConfig({this.environment = 'dev', this.sentryDsn = ''});

  factory AppConfig.fromEnvironment() => const AppConfig(
    environment: String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
    sentryDsn: String.fromEnvironment('SENTRY_DSN'),
  );

  final String environment;
  final String sentryDsn;

  bool get isProd => environment == 'prod';

  /// Crash reporting is off unless a DSN is provided.
  bool get sentryEnabled => sentryDsn.isNotEmpty;
}
