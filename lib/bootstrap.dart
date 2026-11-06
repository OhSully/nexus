import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'config/app_config.dart';
import 'utils/app_logger.dart';

final _log = appLogger('app');

/// Initialises logging and crash reporting, then runs [runner].
/// Uncaught framework, platform and zone errors are logged (and reported to
/// Sentry when a DSN is configured).
Future<void> bootstrap(
  AppConfig config,
  FutureOr<void> Function() runner,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogging(reportToSentry: config.sentryEnabled);

  if (config.sentryEnabled) {
    await SentryFlutter.init((options) {
      options.dsn = config.sentryDsn;
      options.environment = config.environment;
      options.sendDefaultPii = false;
      options.tracesSampleRate = config.isProd ? 0.1 : 1.0;
    }, appRunner: () async => _installHandlers(runner));
  } else {
    await _installHandlers(runner);
  }
}

Future<void> _installHandlers(FutureOr<void> Function() runner) async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _log.severe(details.exceptionAsString(), details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    _log.severe('Uncaught platform error', error, stack);
    return true;
  };
  await runner();
}
