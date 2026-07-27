/// Collects runtime diagnostics for support, feedback, and developer tools.
///
/// **Why:** Single API for "Copy Diagnostics" and pre-filled issue reports.
/// **Owner:** Core quality / platform.
/// **When:** Enrich with router/registry hooks as those features land.
library;

import 'package:flutter/foundation.dart';
import 'package:rsprojects_showcase/core/constants/app_constants.dart';
import 'package:rsprojects_showcase/core/quality/diagnostics/diagnostics_snapshot.dart';
import 'package:rsprojects_showcase/core/quality/diagnostics/platform_context.dart';

/// Reads environment + app state into a [DiagnosticsSnapshot].
///
/// Future: logs, screenshots, performance traces.
class DiagnosticsService {
  const DiagnosticsService({
    this.routeResolver,
    this.themeModeResolver,
    this.localeResolver,
    this.screenResolver,
    this.projectCountResolver,
    this.registryStatusResolver,
    this.gitCommitResolver,
  });

  final String Function()? routeResolver;
  final String Function()? themeModeResolver;
  final String Function()? localeResolver;
  final ({String size, double dpr}) Function()? screenResolver;
  final int Function()? projectCountResolver;
  final String Function()? registryStatusResolver;
  final String? Function()? gitCommitResolver;

  /// Builds a fresh snapshot using resolvers when provided.
  DiagnosticsSnapshot capture() {
    final platform = PlatformContext.current();
    final screen = screenResolver?.call();

    return DiagnosticsSnapshot(
      capturedAt: DateTime.now().toUtc(),
      appVersion: AppConstants.appVersion,
      buildNumber: AppConstants.buildNumber,
      gitCommit: gitCommitResolver?.call(),
      currentRoute: routeResolver?.call() ?? '/',
      platform: platform.platform,
      operatingSystem: platform.operatingSystem,
      browser: platform.browser,
      screenSize: screen?.size ?? 'unknown',
      devicePixelRatio: screen?.dpr ?? 1,
      themeMode: themeModeResolver?.call() ?? 'system',
      locale: localeResolver?.call() ?? 'und',
      loadedProjectCount: projectCountResolver?.call() ?? 0,
      registryStatus: registryStatusResolver?.call() ?? 'not_loaded',
      buildMode: kReleaseMode
          ? 'release'
          : kProfileMode
              ? 'profile'
              : 'debug',
    );
  }

  /// Returns copyable diagnostics text.
  ///
  /// TODO(quality): Wire system clipboard via a portable abstraction.
  String copyDiagnosticsText() => capture().toCopyableText();
}
