/// Point-in-time diagnostics snapshot for support and feedback.
///
/// **Why:** Makes issues reproducible without asking users for environment details.
/// **Owner:** Core quality / platform.
library;

import 'package:flutter/foundation.dart';

/// Immutable diagnostics payload (copyable / attachable to issues).
@immutable
class DiagnosticsSnapshot {
  const DiagnosticsSnapshot({
    required this.capturedAt,
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    required this.operatingSystem,
    required this.currentRoute,
    required this.themeMode,
    required this.locale,
    required this.screenSize,
    required this.devicePixelRatio,
    required this.buildMode,
    required this.registryStatus,
    required this.loadedProjectCount,
    this.gitCommit,
    this.browser,
  });

  final DateTime capturedAt;
  final String appVersion;
  final String buildNumber;
  final String? gitCommit;
  final String currentRoute;
  final String platform;
  final String operatingSystem;
  final String? browser;
  final String screenSize;
  final double devicePixelRatio;
  final String themeMode;
  final String locale;
  final int loadedProjectCount;
  final String registryStatus;
  final String buildMode;

  /// Plain-text block for clipboard / email / GitHub.
  String toCopyableText() {
    final buffer = StringBuffer()
      ..writeln('## Diagnostics')
      ..writeln()
      ..writeln('- **Captured:** ${capturedAt.toUtc().toIso8601String()}')
      ..writeln('- **App version:** $appVersion ($buildNumber)')
      ..writeln('- **Build mode:** $buildMode');
    if (gitCommit != null && gitCommit!.isNotEmpty) {
      buffer.writeln('- **Git commit:** $gitCommit');
    }
    buffer
      ..writeln('- **Platform:** $platform')
      ..writeln('- **OS:** $operatingSystem');
    if (browser != null && browser!.isNotEmpty) {
      buffer.writeln('- **Browser:** $browser');
    }
    buffer
      ..writeln('- **Route:** $currentRoute')
      ..writeln('- **Theme:** $themeMode')
      ..writeln('- **Locale:** $locale')
      ..writeln('- **Screen:** $screenSize @ ${devicePixelRatio}x')
      ..writeln('- **Loaded projects:** $loadedProjectCount')
      ..writeln('- **Registry:** $registryStatus');
    return buffer.toString();
  }

  Map<String, Object?> toJson() => {
        'capturedAt': capturedAt.toUtc().toIso8601String(),
        'appVersion': appVersion,
        'buildNumber': buildNumber,
        'gitCommit': gitCommit,
        'currentRoute': currentRoute,
        'platform': platform,
        'operatingSystem': operatingSystem,
        'browser': browser,
        'screenSize': screenSize,
        'devicePixelRatio': devicePixelRatio,
        'themeMode': themeMode,
        'locale': locale,
        'loadedProjectCount': loadedProjectCount,
        'registryStatus': registryStatus,
        'buildMode': buildMode,
      };
}
