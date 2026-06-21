import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/env_config.dart';

class AppTelemetry {
  const AppTelemetry._();

  static bool get isEnabled => EnvConfig.isSentryEnabled;

  static Future<void> initialize(Future<void> Function() appRunner) async {
    if (!isEnabled) {
      await appRunner();
      return;
    }

    await SentryFlutter.init((options) {
      options
        ..dsn = EnvConfig.sentryDsn
        ..environment = EnvConfig.appEnvironment
        ..release = EnvConfig.appRelease
        ..tracesSampleRate = EnvConfig.sentryTracesSampleRate.clamp(0.0, 1.0)
        ..profilesSampleRate = EnvConfig.sentryProfilesSampleRate.clamp(
          0.0,
          1.0,
        )
        ..enableAutoSessionTracking = true
        ..sendDefaultPii = false;
    }, appRunner: appRunner);
  }

  static Future<void> captureException(
    Object error,
    StackTrace stackTrace, {
    String? context,
    SentryLevel level = SentryLevel.error,
  }) async {
    if (!isEnabled) {
      debugPrint('Captured exception [$context]: $error');
      debugPrintStack(stackTrace: stackTrace);
      return;
    }

    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.level = level;
        if (context != null && context.isNotEmpty) {
          scope.setTag('context', context);
        }
      },
    );
  }

  static Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, Object?> data = const <String, Object?>{},
  }) async {
    if (!isEnabled) {
      debugPrint('Telemetry message: $message');
      return;
    }

    await Sentry.captureMessage(
      message,
      withScope: (scope) {
        scope.level = level;
        if (data.isNotEmpty) {
          scope.setContexts('app_data', data);
        }
      },
    );
  }

  static Future<void> addNavigationBreadcrumb({
    required String action,
    required String route,
  }) async {
    if (!isEnabled) return;

    await Sentry.addBreadcrumb(
      Breadcrumb(
        category: 'navigation',
        type: 'navigation',
        message: action,
        data: <String, dynamic>{'route': route},
        level: SentryLevel.info,
      ),
    );
  }
}
