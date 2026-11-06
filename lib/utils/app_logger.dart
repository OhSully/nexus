import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Convention: create one logger per file/feature, e.g.
/// `final _log = appLogger('activities');`, then use `_log.info(...)` and
/// `_log.severe('what failed', error, stackTrace)` for caught errors.
/// SEVERE and above are forwarded to Sentry when crash reporting is enabled.
Logger appLogger(String name) => Logger('nexus.$name');

/// Wires the root logger. Call once at startup.
void configureLogging({required bool reportToSentry}) {
  Logger.root.level = kReleaseMode ? Level.INFO : Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (!kReleaseMode) {
      debugPrint(
        '[${record.level.name}] ${record.loggerName}: ${record.message}'
        '${record.error != null ? ' | ${record.error}' : ''}',
      );
    }
    if (reportToSentry && record.level >= Level.SEVERE) {
      Sentry.captureException(
        record.error ?? record.message,
        stackTrace: record.stackTrace,
      );
    } else if (reportToSentry && record.level >= Level.INFO) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: record.message,
          category: record.loggerName,
          level: record.level >= Level.WARNING
              ? SentryLevel.warning
              : SentryLevel.info,
        ),
      );
    }
  });
}
