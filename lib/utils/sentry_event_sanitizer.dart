import 'package:sentry_flutter/sentry_flutter.dart';

SentryEvent sanitizeSentryEvent(SentryEvent event) {
  final sanitized = SentryEvent(
    eventId: event.eventId,
    timestamp: event.timestamp,
    platform: event.platform,
    release: event.release,
    dist: event.dist,
    environment: event.environment,
    sdk: event.sdk,
    level: event.level,
    type: event.type,
    debugMeta: _sanitizeDebugMeta(event.debugMeta),
    exceptions: event.exceptions
        ?.map(
          (exception) => SentryException(
            type: exception.type,
            value: null,
            stackTrace: _sanitizeStackTrace(exception.stackTrace),
          ),
        )
        .toList(),
    threads: event.threads
        ?.map(
          (thread) => SentryThread(
            crashed: thread.crashed,
            current: thread.current,
            stacktrace: _sanitizeStackTrace(thread.stacktrace),
          ),
        )
        .toList(),
  );
  sanitized.contexts.clear();
  return sanitized;
}

DebugMeta? _sanitizeDebugMeta(DebugMeta? debugMeta) {
  if (debugMeta == null) return null;

  final sanitized = DebugMeta(sdk: debugMeta.sdk);
  for (final image in debugMeta.images) {
    sanitized.addDebugImage(
      DebugImage(
        type: image.type,
        debugId: image.debugId,
        imageAddr: image.imageAddr,
        imageVmAddr: image.imageVmAddr,
        imageSize: image.imageSize,
        uuid: image.uuid,
        arch: image.arch,
        codeId: image.codeId,
        cpuType: image.cpuType,
        cpuSubtype: image.cpuSubtype,
      ),
    );
  }
  return sanitized;
}

SentryStackTrace? _sanitizeStackTrace(SentryStackTrace? stackTrace) {
  if (stackTrace == null) return null;

  return SentryStackTrace(
    frames: stackTrace.frames
        .map(
          (frame) => SentryStackFrame(
            fileName: frame.fileName,
            function: frame.function,
            module: frame.module,
            lineNo: frame.lineNo,
            colNo: frame.colNo,
            inApp: frame.inApp,
            package: frame.package,
            native: frame.native,
            platform: frame.platform,
            imageAddr: frame.imageAddr,
            symbolAddr: frame.symbolAddr,
            instructionAddr: frame.instructionAddr,
            rawFunction: frame.rawFunction,
            stackStart: frame.stackStart,
            symbol: frame.symbol,
          ),
        )
        .toList(),
    lang: stackTrace.lang,
    snapshot: stackTrace.snapshot,
  );
}
