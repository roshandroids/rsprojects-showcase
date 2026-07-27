/// Elevation / opacity tokens for surfaces.
///
/// **Why:** Card and chrome depth without hardcoding shadow values in widgets.
/// **Owner:** Design system.
library;

import 'package:flutter/material.dart';

/// Surface elevation and overlay opacity scale — restrained, Linear-like.
abstract final class AppElevation {
  AppElevation._();

  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 2;

  static const double overlaySubtle = 0.03;
  static const double overlayMedium = 0.06;
  static const double chromeOpacity = 0.92;
  static const double footerOpacity = 1;

  /// Resting card shadow (~1–2dp).
  static List<BoxShadow> softShadow(ColorScheme scheme) {
    return [
      BoxShadow(
        color: scheme.shadow.withValues(alpha: 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /// Hover lift (~2–4dp).
  static List<BoxShadow> hoverShadow(ColorScheme scheme) {
    return [
      BoxShadow(
        color: scheme.shadow.withValues(alpha: 0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
