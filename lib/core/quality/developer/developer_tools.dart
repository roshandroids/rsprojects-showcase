/// Hidden developer diagnostics / tooling surface (architecture only).
///
/// **Why:** Faster debugging without shipping noisy UI to end users.
/// **Owner:** Core quality / platform.
/// **When:** Expose behind a debug-only entry (gesture / query flag).
library;

import 'package:flutter/foundation.dart';

/// Catalog of future developer tools.
enum DeveloperToolAction {
  forceException,
  simulateNetworkFailure,
  testRouting,
  performanceOverlay,
  themePreview,
  debugRegistry,
  diagnosticsExport,
}

/// Gate for developer tools — never enable in release by default.
abstract final class DeveloperTools {
  DeveloperTools._();

  static bool get isAvailable => !kReleaseMode;

  /// TODO(quality): Implement each [DeveloperToolAction].
  static void invoke(DeveloperToolAction action) {
    assert(isAvailable, 'Developer tools are debug/profile only');
    debugPrint('DeveloperTools.invoke($action) — not implemented yet');
  }
}
