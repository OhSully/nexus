import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:nexus/config/app_config.dart';
import 'package:nexus/utils/app_logger.dart';

void main() {
  test('Sentry is disabled without a DSN', () {
    expect(const AppConfig().sentryEnabled, isFalse);
    expect(const AppConfig(sentryDsn: 'https://x@y/1').sentryEnabled, isTrue);
    expect(const AppConfig(environment: 'prod').isProd, isTrue);
  });

  test('appLogger namespaces loggers under nexus', () {
    expect(appLogger('chat').fullName, 'nexus.chat');
    configureLogging(reportToSentry: false);
    expect(() => appLogger('chat').severe('boom', 'err'), returnsNormally);
    Logger.root.clearListeners();
  });
}
