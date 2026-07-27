/// Structured crash report captured by the centralized crash handler.
///
/// **Why:** Portable, serializable crash context for diagnostics and feedback.
/// **Owner:** Core quality / platform.
/// **When:** Expand fields as diagnostics needs grow; do not wire external SaaS yet.
library;

import 'package:flutter/foundation.dart';

/// Immutable crash report used by diagnostics and community feedback.
@immutable
class CrashReport {
  const CrashReport({
    required this.timestamp,
    required this.exception,
    required this.stackTrace,
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    required this.operatingSystem,
    required this.route,
    required this.themeMode,
    required this.locale,
    required this.screenSize,
    required this.devicePixelRatio,
    this.browser,
    this.context,
  });

  final DateTime timestamp;
  final String exception;
  final String stackTrace;
  final String appVersion;
  final String buildNumber;
  final String platform;
  final String operatingSystem;
  final String? browser;
  final String route;
  final String themeMode;
  final String locale;
  final String screenSize;
  final double devicePixelRatio;
  final String? context;

  /// Human-readable block suitable for email / GitHub issue bodies.
  String toDiagnosticsBlock() {
    final buffer = StringBuffer()
      ..writeln('## Crash Report')
      ..writeln()
      ..writeln('- **Timestamp:** ${timestamp.toUtc().toIso8601String()}')
      ..writeln('- **App version:** $appVersion')
      ..writeln('- **Build number:** $buildNumber')
      ..writeln('- **Platform:** $platform')
      ..writeln('- **OS:** $operatingSystem');
    if (browser != null && browser!.isNotEmpty) {
      buffer.writeln('- **Browser:** $browser');
    }
    buffer
      ..writeln('- **Route:** $route')
      ..writeln('- **Theme:** $themeMode')
      ..writeln('- **Locale:** $locale')
      ..writeln('- **Screen:** $screenSize @ ${devicePixelRatio}x')
      ..writeln()
      ..writeln('### Exception')
      ..writeln()
      ..writeln('```')
      ..writeln(exception)
      ..writeln('```')
      ..writeln()
      ..writeln('### Stack trace')
      ..writeln()
      ..writeln('```')
      ..writeln(stackTrace)
      ..writeln('```');
    if (context != null && context!.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('### Context')
        ..writeln()
        ..writeln(context);
    }
    return buffer.toString();
  }

  Map<String, Object?> toJson() => {
        'timestamp': timestamp.toUtc().toIso8601String(),
        'exception': exception,
        'stackTrace': stackTrace,
        'appVersion': appVersion,
        'buildNumber': buildNumber,
        'platform': platform,
        'operatingSystem': operatingSystem,
        'browser': browser,
        'route': route,
        'themeMode': themeMode,
        'locale': locale,
        'screenSize': screenSize,
        'devicePixelRatio': devicePixelRatio,
        'context': context,
      };
}
