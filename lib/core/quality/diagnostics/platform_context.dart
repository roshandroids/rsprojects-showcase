/// Portable platform / OS / browser labels for diagnostics.
///
/// **Why:** Avoid `dart:io` in shared layers; keep Web + mobile + desktop safe.
/// **Owner:** Core quality / platform.
library;

import 'package:flutter/foundation.dart';

/// Snapshot of host platform identity (not a plugin).
@immutable
class PlatformContext {
  const PlatformContext({
    required this.platform,
    required this.operatingSystem,
    this.browser,
  });

  final String platform;
  final String operatingSystem;
  final String? browser;

  /// Resolves using Flutter foundation only (cross-platform).
  static PlatformContext current() {
    if (kIsWeb) {
      return const PlatformContext(
        platform: 'web',
        operatingSystem: 'web',
        // TODO(quality): Detect browser family via portable JS interop adapter.
        browser: 'web',
      );
    }

    final target = defaultTargetPlatform;
    final name = switch (target) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'fuchsia',
    };

    return PlatformContext(
      platform: name,
      operatingSystem: name,
    );
  }
}
