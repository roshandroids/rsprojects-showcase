/// Centralized crash / error capture for Flutter framework and async errors.
///
/// **Why:** Replaces default release red screens with structured reporting hooks.
/// **Owner:** Core quality / platform.
/// **When:** Wire presenters and feedback flows after shell foundation; no SaaS yet.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rsprojects_showcase/core/quality/crash/crash_report.dart';
import 'package:rsprojects_showcase/core/quality/diagnostics/diagnostics_service.dart';

/// Receives structured [CrashReport]s (UI presenter, logging, future reporters).
typedef CrashReportListener = void Function(CrashReport report);

/// Installs Flutter / zone error hooks and builds [CrashReport]s.
///
/// Does **not** integrate Crashlytics, Sentry, or other external providers.
abstract final class CrashHandler {
  CrashHandler._();

  static CrashReportListener? _listener;
  static DiagnosticsService _diagnostics = const DiagnosticsService();
  static bool _installed = false;

  /// Last captured report (in-memory only; no persistence yet).
  static CrashReport? lastReport;

  /// Registers listeners and Flutter error hooks.
  ///
  /// Call once from [bootstrap] before [runApp].
  static void install({
    CrashReportListener? listener,
    DiagnosticsService diagnostics = const DiagnosticsService(),
  }) {
    _listener = listener;
    _diagnostics = diagnostics;

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _capture(
        exception: details.exceptionAsString(),
        stack: details.stack ?? StackTrace.current,
        context: details.context?.toString(),
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _capture(
        exception: error.toString(),
        stack: stack,
        context: 'PlatformDispatcher.onError',
      );
      // Return true to mark as handled so the default fatal path can be customized.
      return true;
    };

    _installed = true;
  }

  /// Whether [install] has been called.
  static bool get isInstalled => _installed;

  /// Runs [body] inside a guarded zone that captures uncaught async errors.
  static void runGuarded(void Function() body) {
    runZonedGuarded(body, (error, stack) {
      _capture(
        exception: error.toString(),
        stack: stack,
        context: 'runZonedGuarded',
      );
    });
  }

  /// Manually record an unexpected exception (e.g. caught in repositories).
  static void recordError(
    Object error,
    StackTrace stack, {
    String? context,
  }) {
    _capture(
      exception: error.toString(),
      stack: stack,
      context: context,
    );
  }

  static void _capture({
    required String exception,
    required StackTrace stack,
    String? context,
  }) {
    final snapshot = _diagnostics.capture();
    final report = CrashReport(
      timestamp: DateTime.now().toUtc(),
      exception: exception,
      stackTrace: stack.toString(),
      appVersion: snapshot.appVersion,
      buildNumber: snapshot.buildNumber,
      platform: snapshot.platform,
      operatingSystem: snapshot.operatingSystem,
      browser: snapshot.browser,
      route: snapshot.currentRoute,
      themeMode: snapshot.themeMode,
      locale: snapshot.locale,
      screenSize: snapshot.screenSize,
      devicePixelRatio: snapshot.devicePixelRatio,
      context: context,
    );
    lastReport = report;
    _listener?.call(report);
    // TODO(quality): Present friendly error experience via ErrorExperiencePresenter.
    debugPrint('CrashHandler captured: $exception');
  }
}
