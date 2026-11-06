import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:nexus/utils/sentry_event_sanitizer.dart';

void main() {
  test('removes identifying and free-text data but keeps exception types', () {
    final frame = SentryStackFrame(
      fileName: 'profile.dart',
      function: 'loadProfile',
      lineNo: 12,
      contextLine: 'email = person@example.com',
      vars: {'email': 'person@example.com'},
    );
    final exception = SentryException(
      type: 'StateError',
      value: 'private user input',
      stackTrace: SentryStackTrace(frames: [frame]),
    );
    final event = SentryEvent(
      user: SentryUser(email: 'person@example.com'),
      request: SentryRequest(url: 'https://example.com?token=secret'),
      breadcrumbs: [Breadcrumb(message: 'private user action')],
      exceptions: [exception],
      threads: [
        SentryThread(
          id: 1,
          name: 'person@example.com',
          crashed: true,
          stacktrace: SentryStackTrace(frames: [frame]),
        ),
      ],
      contexts: Contexts(),
      logger: 'nexus.test',
      environment: 'prod',
      release: 'nexus@1.0.0',
    )..message = SentryMessage('private user input');

    final sanitized = sanitizeSentryEvent(event);

    expect(sanitized.user, isNull);
    expect(sanitized.request, isNull);
    expect(sanitized.breadcrumbs, isNull);
    expect(sanitized.message, isNull);
    expect(sanitized.contexts, isEmpty);
    expect(sanitized.exceptions!.single.type, 'StateError');
    expect(sanitized.exceptions!.single.value, isNull);
    expect(sanitized.exceptions!.single.stackTrace, isNotNull);
    final sanitizedFrame =
        sanitized.exceptions!.single.stackTrace!.frames.single;
    expect(sanitizedFrame.fileName, 'profile.dart');
    expect(sanitizedFrame.function, 'loadProfile');
    expect(sanitizedFrame.contextLine, isNull);
    expect(sanitizedFrame.vars, isEmpty);
    expect(sanitized.logger, isNull);
    expect(sanitized.environment, 'prod');
    expect(sanitized.release, 'nexus@1.0.0');
    final payload = jsonEncode(sanitized.toJson());
    expect(payload, isNot(contains('person@example.com')));
    expect(payload, isNot(contains('token=secret')));
    expect(payload, isNot(contains('private user input')));
    expect(payload, isNot(contains('private user action')));
  });
}
